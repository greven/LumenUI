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

local UnitClass = _G.UnitClass
local UnitReaction = _G.UnitReaction
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsTapDenied = _G.UnitIsTapDenied

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

function E:FormatNumber(val)
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
  local FIRST_NUMBER_CAP = "%s.%d" .. _G.FIRST_NUMBER_CAP_NO_SPACE
  local SECOND_NUMBER_CAP = "%s.%d" .. _G.SECOND_NUMBER_CAP_NO_SPACE

  local D_D_ABBR = _G.DAY_ONELETTER_ABBR:gsub("[ .]", "")
  local D_H_ABBR = _G.HOUR_ONELETTER_ABBR:gsub("[ .]", "")
  local D_M_ABBR = _G.MINUTE_ONELETTER_ABBR:gsub("[ .]", "")
  local D_S_ABBR = _G.SECOND_ONELETTER_ABBR:gsub("[ .]", "")
  local D_MS_ABBR = "%d" .. _G.MILLISECONDS_ABBR
  local F_MS_ABBR = "%.1f" .. _G.MILLISECONDS_ABBR

  local F_D_ABBR = D_D_ABBR:gsub("%%d", "%%.1f")
  local F_H_ABBR = D_H_ABBR:gsub("%%d", "%%.1f")
  local F_M_ABBR = D_M_ABBR:gsub("%%d", "%%.1f")
  local F_S_ABBR = D_S_ABBR:gsub("%%d", "%%.1f")

  local X_XX_FORMAT = "%d:%02d"
	local D = "%d"
  local F = "%.1f"

  local BreakUpLargeNumbers = _G.BreakUpLargeNumbers

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
			rgb_hex_cache[key] = s_format("%.2x%.2x%.2x", clamp(r) * 255, clamp(g) * 255, clamp(b) * 255)
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

	-- Class colors
	function E:GetUnitClassColor(unit)
		local class = select(2, UnitClass(unit))
		local color = C.colors.class[class] or RAID_CLASS_COLORS[class]

		if not color then return .5, .5, .5 end
		return color.r, color.g, color.b
	end

	function E:GetUnitColor(unit)
		if not unit then return end
		local r, g, b = 1, 1, 1

		if UnitIsPlayer(unit) then
			r, g, b = E:GetUnitClassColor(unit)
		elseif UnitIsTapDenied(unit) then
			r, g, b = .6, .6, .6
		else
			local reaction = UnitReaction(unit, "player")
			if reaction then
				local color = FACTION_BAR_COLORS[reaction]
				r, g, b = color.r, color.g, color.b
			end
		end

		return r, g, b
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
