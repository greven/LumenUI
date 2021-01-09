-- Credits: ls_UI

local _, ns = ...
local E, C = ns.E, ns.C

-- Lua
local _G = getfenv(0)

local next = _G.next
local ipairs = _G.ipairs
local pairs = _G.pairs
local select = _G.select

local m_floor = _G.math.floor
local m_min = _G.math.min
local m_max = _G.math.max
local m_modf = _G.math.modf

local s_format = _G.string.format
local s_utf8sub = _G.string.utf8sub
local s_split = _G.string.split

local BreakUpLargeNumbers = _G.BreakUpLargeNumbers
local UnitClass = _G.UnitClass
local UnitReaction = _G.UnitReaction
local UnitIsPlayer = _G.UnitIsPlayer
local UnitPlayerControlled = _G.UnitPlayerControlled
local UnitIsTapDenied = _G.UnitIsTapDenied
local UnitIsConnected = _G.UnitIsConnected
local UnitIsGhost = _G.UnitIsGhost
local UnitIsDead = _G.UnitIsDead

-- ---------------
-- > Math
-- ---------------

local function round(val)
  return m_floor(val + 0.5)
end

local function clamp(val, min, max)
	return m_min(max or 1, m_max(min or 0, val))
end

function E:Round(val)
  return val and round(val) or nil
end

function E:Clamp(val, ...)
	return val and clamp(val, ...) or nil
end

function E:NumberToPerc(v1, v2)
  return (v1 and v2) and (v1 / v2 * 100) or nil
end


function E:FormatNumber(val, colorCap)
	local FIRST_NUMBER_CAP = "%s.%d" .. _G.FIRST_NUMBER_CAP_NO_SPACE
	local SECOND_NUMBER_CAP = "%s.%d" .. _G.SECOND_NUMBER_CAP_NO_SPACE

	if colorCap then
		FIRST_NUMBER_CAP = "%s.%d|cffBBBBBB" .. _G.FIRST_NUMBER_CAP_NO_SPACE .. "|r"
		SECOND_NUMBER_CAP = "%s.%d|cffBBBBBB" .. _G.SECOND_NUMBER_CAP_NO_SPACE .. "|r"
	end

	if val >= 1E6 then
		local i, f = m_modf(val / 1E6)
		return s_format(SECOND_NUMBER_CAP, BreakUpLargeNumbers(i), f * 10)
	elseif val >= 1E4 then
		local i, f = m_modf(val / 1E3)
		return s_format(FIRST_NUMBER_CAP, BreakUpLargeNumbers(i), f * 10)
	elseif val >= 0 then
		return BreakUpLargeNumbers(val)
	else
		return 0
	end
end


do
  local D_D_ABBR = _G.DAY_ONELETTER_ABBR:gsub("[ .]", "")
  local D_H_ABBR = _G.HOUR_ONELETTER_ABBR:gsub("[ .]", "")
  local D_M_ABBR = _G.MINUTE_ONELETTER_ABBR:gsub("[ .]", "")
  local D_S_ABBR = _G.SECOND_ONELETTER_ABBR:gsub("[ .]", "")
  local D_MS_ABBR = "%d" .. _G.MILLISECONDS_ABBR
  local F_MS_ABBR = "%.1f" .. _G.MILLISECONDS_ABBR

  -- s: value in seconds
  -- returns: formatted time and color
  function E:FormatTime(s)
    local day, hour, minute = 86400, 3600, 60

    if s >= day then
			return s_format(D_D_ABBR, round(s / day)), "e5e5e5"
		elseif s >= hour then
			return s_format(D_H_ABBR, round(s / hour)), "e5e5e5"
		elseif s >= minute then
			return s_format(D_M_ABBR, round(s / minute)), "e5e5e5"
		elseif s >= 5 then
			return s_format(D_S_ABBR, round(s)), s >= 30 and "e5e5e5" or s >= 10 and "ffbf19" or "e51919"
		elseif s >= 0 then
			return s_format("%.1f", s), "e51919"
		else
			return 0
		end
  end
end

-- ---------------
-- > Tables
-- ---------------

function E:CopyTable(src, dest, ignore)
	if type(dest) ~= "table" then
		dest = {}
	end

	for k, v in next, src do
		if not ignore or not ignore[k] then
			if type(v) == "table" then
				dest[k] = self:CopyTable(v, dest[k])
			else
				dest[k] = v
			end
		end
	end

	return dest
end

function E:UpdateTable(src, dest)
	if type(dest) ~= "table" then
		dest = {}
	end

	for k, v in next, src do
		if type(v) == "table" then
			dest[k] = self:UpdateTable(v, dest[k])
		else
			if dest[k] == nil then
				dest[k] = v
			end
		end
	end

	return dest
end

function E:ReplaceTable(src, dest)
	if type(dest) ~= "table" then
		dest = {}
	end

	for k, v in next, dest do
		if type(src[k]) == "table" then
			dest[k] = self:ReplaceTable(src[k], v)
		else
			dest[k] = src[k]
		end
	end

	return dest
end

-- Count the number of elements
function E:TableCount(elements)
  local count = 0
  for _ in pairs(elements) do count = count + 1 end
  return count
end

-- Check if the table contains a specific value
function E:TableHasValue(tab, val)
  for _, v in ipairs(tab) do if v == val then return true end end
  return false
end

-- ---------------
-- > Strings
-- ---------------

function E:TruncateString(str, length)
	return s_utf8sub(str, 1, length)
end

-- ---------------
-- > Color
-- ---------------

do
  local rgb_hex_cache = {}

	local function hex(r, g, b)
		if r then
			if type(r) == "table" then
				if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
			end

			local key = r .. "-" .. g .. "-" .. b
			if rgb_hex_cache[key] then
				return rgb_hex_cache[key]
			end
			rgb_hex_cache[key] = s_format("ff%.2x%.2x%.2x", clamp(r) * 255, clamp(g) * 255, clamp(b) * 255)
			return rgb_hex_cache[key]
		end
  end

  function E:ToHex(r, g, b)
    return hex(r, g, b)
  end

  function E:GetRGB(color)
    return color.r, color.g, color.b
  end

  function E:GetRGBA(color, a)
    return color.r, color.g, color.b, a or color.a
  end

  function E:SetRGBA(color, r, g, b, a)
    if r > 1 or g > 1 or b > 1 then
      r, g, b = r / 255, g / 255, b / 255
    end

    color.r = r
    color.g = g
    color.b = b
    color.a = a
    color.hex = hex(r, g, b)

    return color
  end

  function E:SetRGB(color, r, g, b)
    return self:SetRGBA(color, r, g, b, 1)
  end

  function E:TextColor(text, color)
		return "|cff" .. color.hex .. text .. "|r"
	end

  -- Gradients
	local function calcGradient(perc, ...)
		local num = select("#", ...)

		if perc >= 1 then
			return select(-3, ...)
		elseif perc <= 0 then
			local r, g, b = ...
			return r, g, b
		end

		local i, relperc = Math.modf(perc * (num / 3 - 1))
		local r1, g1, b1, r2, g2, b2 = select((i * 3) + 1, ...)

		return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
  end

	function E:GetGradientAsRGB(perc, color)
		return calcGradient(
			perc,
			color[1].r, color[1].g, color[1].b,
			color[2].r, color[2].g, color[2].b,
			color[3].r, color[3].g, color[3].b
		)
	end

	function E:GetGradientAsHex(perc, color)
		return hex(calcGradient(
			perc,
			color[1].r, color[1].g, color[1].b,
			color[2].r, color[2].g, color[2].b,
			color[3].r, color[3].g, color[3].b
		))
	end
end

-- -------------------
-- > Points & Anchors
-- -------------------

function E:ResolveAnchorPoint(frame, children)
	if not frame then
		children = {s_split(".", children)}

		local anchor = _G[children[1]]

		assert(anchor, "Invalid anchor: "..children[1]..".")

		for i = 2, #children do
			anchor = anchor[children[i]]
		end

		return anchor
	else
		if not children or children == "" then
			return frame
		else
			local anchor = frame

			children = {s_split(".", children)}

			for i = 1, #children do
				anchor = anchor[children[i]]
			end

			return anchor
		end
	end
end

function E:SetPosition(frame, point, relative)
	local anchor = point.anchor
	if relative then
		anchor = E:ResolveAnchorPoint(relative, anchor)
	end
	frame:SetPoint(point.p, anchor, point.ap, point.x, point.y)
end

function E:CalcSegmentsSizes(totalSize, spacing, numSegs)
	local totalSizeWoGaps = totalSize - spacing * (numSegs - 1)
	local segSize = totalSizeWoGaps / numSegs
	local result = {}

	if segSize % 1 == 0 then
		for i = 1, numSegs do
			result[i] = segSize
		end
	else
		local numOddSegs = numSegs % 2 == 0 and 2 or 1
		local numNormalSegs = numSegs - numOddSegs
		segSize = round(segSize)

		for i = 1, numNormalSegs / 2 do
			result[i] = segSize
		end

		for i = numSegs - numNormalSegs / 2 + 1, numSegs do
			result[i] = segSize
		end

		segSize = (totalSizeWoGaps - segSize * numNormalSegs) / numOddSegs

		for i = 1, numOddSegs do
			result[numNormalSegs / 2 + i] = segSize
		end
	end

	return result
end

-- ---------------
-- > Units
-- ---------------

do
	function E:UnitIsDisconnectedOrDeadOrGhost(unit)
		if(not UnitIsConnected(unit)) then
			return 'Offline'
		elseif(UnitIsGhost(unit)) then
			return 'Ghost'
		elseif(UnitIsDead(unit)) then
			return 'Dead'
		end
	end

	function E:GetUnitColor(unit, colorByClass, colorByReaction)
		if not UnitIsConnected(unit) then
			return C.colors.disconnected
		elseif not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
			return C.colors.tapped
		elseif colorByClass and UnitIsPlayer(unit) then
			return self:GetUnitClassColor(unit)
		elseif colorByReaction then
			return self:GetUnitReactionColor(unit)
		end

		return C.colors.dark_gray
	end

	function E:GetUnitClassColor(unit)
		return C.colors.class[select(2, UnitClass(unit))] or C.colors.white
	end

	function E:GetUnitReactionColor(unit)
		if select(2, UnitDetailedThreatSituation("player", unit)) ~= nil then
			return C.colors.reaction[2]
		end

		return C.colors.reaction[UnitReaction(unit, "player")] or C.colors.reaction[4]
	end

	function E:GetUnitClassification(unit)
		local classification = UnitClassification(unit)
		if classification == "rare" then
			return "R"
		elseif classification == "rareelite" then
			return "R+"
		elseif classification == "elite" then
			return "+"
		elseif classification == "worldboss" then
			return "B"
		elseif classification == "minus" then
			return "-"
		end

		return ""
	end

	function E:GetUnitPVPStatus(unit)
		local faction = "Neutral"

		if UnitExists(unit) then
			faction = UnitFactionGroup(unit)

			if UnitIsPVPFreeForAll(unit) then
				return true, "FFA"
			elseif UnitIsPVP(unit) and faction and faction ~= "Neutral" then
				if UnitIsMercenary(unit) then
					if faction == "Horde" then
						faction = "Alliance"
					elseif faction == "Alliance" then
						faction = "Horde"
					end
				end

				return true, faction
			end
		end

		return false, faction
	end

	function E:GetUnitSpecializationInfo(unit)
		if UnitExists(unit) then
			local isPlayer = UnitIsUnit(unit, "player")
			local specID = isPlayer and GetSpecialization() or GetInspectSpecialization(unit)

			if specID and specID > 0 then
				if isPlayer then
					local _, name = GetSpecializationInfo(specID)

					return name
				else
					local _, name = GetSpecializationInfoByID(specID)

					return name
				end
			end
		end

		-- return L["UNKNOWN"] -- TODO: "LOCALIZE THIS?"
		return "UNKNOWN"
	end

	-- GetRelativeDifficultyColor function in UIParent.lua
	function E:GetRelativeDifficultyColor(unitLevel, challengeLevel)
		local diff = challengeLevel - unitLevel
		if diff >= 5 then
			return C.colors.difficulty.impossible
		elseif diff >= 3 then
			return C.colors.difficulty.very_difficult
		elseif diff >= -4 then
			return C.colors.difficulty.difficult
		elseif -diff <= UnitQuestTrivialLevelRange("player") then
			return C.colors.difficulty.standard
		else
			return C.colors.difficulty.trivial
		end
	end

	function E:GetCreatureDifficultyColor(level)
		return self:GetRelativeDifficultyColor(UnitEffectiveLevel("player"), level > 0 and level or 199)
	end
end
