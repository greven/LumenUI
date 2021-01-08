local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

--Lua
local _G = getfenv(0)
local m_abs = _G.math.abs

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function updateFont(fontString, config)
  fontString:SetFont(C.global.fonts.units.font.text, config.size, config.outline and "THINOUTLINE" or nil)
  fontString:SetWordWrap(false)

  if config.shadow then
    fontString:SetShadowOffset(1, -1)
  else
    fontString:SetShadowOffset(0, 0)
  end
end

local function element_UpdateConfig(self)
  local unit = self.__owner._unit
  self._config = E:CopyTable(C.modules.unitframes.units[unit].castbar, self._config)
end

local function element_UpdateFonts(self)
	updateFont(self.Text, self._config.text)
	self.Text:SetJustifyH("LEFT")

	updateFont(self.Time, self._config.text)
	self.Time:SetJustifyH("RIGHT")

	if self._config.max then
		updateFont(self.Time.max, {size = 11, outline = true})
		self.Time:SetJustifyH("RIGHT")
	end
end

local function element_UpdateIcon(self)
	local config = self._config
	local height = config.height

	if config.icon.position == "LEFT" then
		self.Icon = self.LeftIcon

		-- self.LeftIcon:SetSize(height * 1.5, height)
		-- self.RightIcon:SetSize(0.0001, height)

		-- self.LeftSep:SetSize(12, height)
		-- self.LeftSep:SetTexCoord(1 / 32, 25 / 32, 0 / 8, height / 4)
		-- self.RightSep:SetSize(0.0001, height)

		-- self:SetPoint("TOPLEFT", 5 + height * 1.5, 0)
		-- self:SetPoint("BOTTOMRIGHT", -3, 0)
	elseif config.icon.position == "RIGHT" then
		self.Icon = self.RightIcon

		-- self.LeftIcon:SetSize(0.0001, height)
		-- self.RightIcon:SetSize(height * 1.5, height)

		-- self.LeftSep:SetSize(0.0001, height)
		-- self.RightSep:SetSize(12, height)
		-- self.RightSep:SetTexCoord(1 / 32, 25 / 32, 0 / 8, height / 4)

		-- self:SetPoint("TOPLEFT", 3, 0)
		-- self:SetPoint("BOTTOMRIGHT", -5 - height * 1.5, 0)
	else
		self.Icon = nil

		-- self.LeftIcon:SetSize(0.0001, height)
		-- self.RightIcon:SetSize(0.0001, height)

		-- self.LeftSep:SetSize(0.0001, height)
		-- self.RightSep:SetSize(0.0001, height)

		-- self:SetPoint("TOPLEFT", 3, 0)
		-- self:SetPoint("BOTTOMRIGHT", -3, 0)
	end
end

local function element_UpdateColors(self)
	if self._config.colorClass then
		self:SetStatusBarColor(E:GetRGB(C.colors.castbar[E.PLAYER_CLASS]))
	end
end

local function element_UpdateSize(self)
	local frame = self.__owner
	local width = self._config.width
	local height = self._config.height

	self:SetSize(width, height)

	local point = self._config.point
	if point and point.p then
		self:ClearAllPoints()
		self:SetPoint(point.p, E:ResolveAnchorPoint(frame, point.anchor), point.ap, point.x, point.y)
	end
end

local function element_CustomTimeText(self, duration)
	if self.max > 600 then
		return self.Time:SetText("")
	end

	if self.casting then
		duration = self.max - duration
	end

	self.Time:SetFormattedText("%.1f ", duration)

	if self.Time.max then
		self.Time.max:SetText(("%.1f "):format(self.max))
		self.Time.max:Show()
	end
end

local function frame_UpdateCastbar(self)
	local element = self.Castbar
	element:UpdateConfig()
	element:UpdateSize()
	element:UpdateFonts()
	element:UpdateColors()
	element:UpdateIcon()
	-- element:UpdateLatency()

	-- if element._config.enabled and not self:IsElementEnabled("Castbar") then
	-- 	self:EnableElement("Castbar")
	-- elseif not element._config.enabled and self:IsElementEnabled("Castbar") then
	-- 	self:DisableElement("Castbar")

	-- 	if self._unit == "player" then
	-- 		CastingBarFrame_SetUnit(CastingBarFrame, nil)
	-- 		CastingBarFrame_SetUnit(PetCastingBarFrame, nil)
	-- 	end
	-- end

	-- if self:IsElementEnabled("Castbar") then
	-- 	element:ForceUpdate()
	-- end
end

function UF:CreateCastbar(frame)
	local config = C.modules.unitframes.units[frame._unit].castbar

	local element = CreateFrame("StatusBar", nil, frame)
	element:SetStatusBarTexture(M.textures.mint)
	element:SetStatusBarColor(E:GetRGB(config.color))
	element:SetFrameStrata("HIGH")
	E.SetBackdrop(element, 2)

  local bg = element:CreateTexture(nil, "BACKGROUND", nil)
  bg:SetAllPoints(element)
	bg:SetTexture(M.textures.vertlines)
	bg:SetVertexColor(E:GetRGB(C.colors.dark_gray))
  bg:SetAlpha(0.6)
	element.bg = bg

	local icon = element:CreateTexture(nil, "BACKGROUND", nil, 0)
	icon:SetPoint("TOPLEFT", element, "TOPLEFT", 3, 0)
	icon:SetTexCoord(8 / 64, 56 / 64, 9 / 64, 41 / 64)
	element.LeftIcon = icon

	icon = element:CreateTexture(nil, "BACKGROUND", nil, 0)
	icon:SetTexCoord(8 / 64, 56 / 64, 9 / 64, 41 / 64)
	icon:SetPoint("TOPRIGHT", element, "TOPRIGHT", -3, 0)
	element.RightIcon = icon

  -- local safeZone = element:CreateTexture(nil, "ARTWORK", nil, 1)
	-- safeZone:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	-- safeZone:SetVertexColor(E:GetRGBA(C.colors.red, 0.6))
  -- element.SafeZone_ = safeZone

  local texParent = CreateFrame("Frame", nil, element)
	texParent:SetPoint("TOPLEFT", element, "TOPLEFT", 3, 0)
	texParent:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -3, 0)
  element.TexParent = texParent

  local text = texParent:CreateFontString(nil, "ARTWORK")
	text:SetWordWrap(false)
	text:SetJustifyH("LEFT")
	text:SetPoint("TOP", element, "TOP", 0, 0)
	text:SetPoint("BOTTOM", element, "BOTTOM", 0, -2)
	text:SetPoint("LEFT", element, "LEFT", 4, 0)
	text:SetPoint("RIGHT", time, "LEFT", -4, 0)
  element.Text = text

  local time = texParent:CreateFontString(nil, "ARTWORK")
	time:SetWordWrap(false)
	time:SetPoint("TOP", element, "TOP", 0, 0)
	time:SetPoint("BOTTOM", element, "BOTTOM", 0, -2)
	time:SetPoint("RIGHT", element, "RIGHT", -4, 0)
	element.Time = time

	if config.max then
		local max = element:CreateFontString(nil, "BACKGROUND")
		max:SetPoint("RIGHT", element.Time, "LEFT", -1, 0)
		max:SetTextColor(0.3, 0.3, 0.3)
		max:SetWordWrap(false)
		element.Time.max = max
	end

	-- element.CustomDelayText = element_CustomDelayText
	element.CustomTimeText = element_CustomTimeText
	-- element.PostCastFail = element_PostCastFail
	-- element.PostCastStart = element_PostCastStart
	element.timeToHold = 0.4
	element.UpdateConfig = element_UpdateConfig
	element.UpdateFonts = element_UpdateFonts
	element.UpdateColors = element_UpdateColors
	element.UpdateSize = element_UpdateSize
	element.UpdateIcon = element_UpdateIcon
	-- element.UpdateLatency = element_UpdateLatency

  frame.UpdateCastbar = frame_UpdateCastbar
  frame.Castbar = element

	return element
end
