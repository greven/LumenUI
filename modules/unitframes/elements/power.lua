local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- Lua
local _G = getfenv(0)

local UnitGUID = _G.UnitGUID
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function updateFont(fontString, config)
  fontString:SetFont(C.global.fonts.units.font.number, config.size, config.outline and "OUTLINE" or nil)
  fontString:SetJustifyH(config.h_alignment)
  fontString:SetJustifyV(config.v_alignment)
  fontString:SetWordWrap(false)

	if config.shadow then
		fontString:SetShadowOffset(1, -1)
	else
		fontString:SetShadowOffset(0, 0)
	end
end

local function updateTextPoint(frame, fontString, config)
  fontString:ClearAllPoints()

  if config and config.p then
    E:SetPosition(fontString, config, frame)
  end
end

local function updateTag(frame, fontString, tag)
	if tag ~= "" then
		frame:Tag(fontString, tag)
		fontString:UpdateTag()
	else
		frame:Untag(fontString)
		fontString:SetText("")
	end
end

-- Power
do
	local function element_PostUpdate(self, unit, cur, _, max)
    local shouldShown = self:IsShown() and max and max ~= 0

    if self.UpdateContainer then
			self:UpdateContainer(shouldShown)
		end

		local unitGUID = UnitGUID(unit)
		self.GainLossIndicators:Update(cur, max, unitGUID == self.GainLossIndicators._UnitGUID)
		self.GainLossIndicators._UnitGUID = unitGUID

		if shouldShown then
			self.Text:Show()
		else
			self.Text:Hide()
		end

		if not shouldShown or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
			self:SetMinMaxValues(0, 1)
			self:SetValue(0)
		end
	end

  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit].power, self._config)
  end

  local function element_UpdateColors(self)
    local config = self._config
    self.colorPower = config.color.power
    self.colorTapping = config.color.tapping
    self.colorDisconnected = config.color.disconnected
    self.colorClass = config.color.class

    self:ForceUpdate()
  end

  local function element_UpdateSize(self)
    local frame = self:GetParent()
    local config = self._config

    self:SetPoint("TOP", frame, "BOTTOM", 0, config.height)
    self:SetPoint("BOTTOM", frame, 0, 0)
    self:SetPoint("LEFT", frame, 0, 0)
    self:SetPoint("RIGHT", frame, 0, 0)

    self:ForceUpdate()
  end

  local function element_UpdateFonts(self)
    updateFont(self.Text, self._config.text)
  end

  local function element_UpdateTextPoints(self)
    updateTextPoint(self.__owner, self.Text, self._config.text.point)
  end

  local function element_UpdateTags(self)
    updateTag(self.__owner, self.Text, self._config.enabled and self._config.text.tag or "")
  end

  local function element_UpdateGainLossPoints(self)
    self.GainLossIndicators:UpdatePoints("HORIZONTAL")
  end

  local function element_UpdateGainLossThreshold(self)
    self.GainLossIndicators:UpdateThreshold(self._config.change_threshold)
  end

  local function element_UpdateGainLossColors(self)
    self.GainLossIndicators:UpdateColors()
  end

  local function frame_UpdatePower(self)
    local element = self.Power
    element:UpdateConfig()
    element:UpdateColors()
    element:UpdateSize()
    element:UpdateFonts()
    element:UpdateTextPoints()
    element:UpdateTags()
    element:UpdateGainLossColors()
		element:UpdateGainLossPoints()
    element:UpdateGainLossThreshold()

    if element._config.enabled and not self:IsElementEnabled("Power") then
			self:EnableElement("Power")
		elseif not element._config.enabled and self:IsElementEnabled("Power") then
			self:DisableElement("Power")
    end

		if self:IsElementEnabled("Power") then
			element:ForceUpdate()
		elseif element.UpdateContainer then
			element:UpdateContainer(false)
		end
  end

  function UF:CreatePowerBar(frame, textParent)
    local config = C.modules.unitframes.units[frame._unit].power

    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("BOTTOMLEFT", frame)
    element:SetPoint("BOTTOMRIGHT", frame)
    element:SetStatusBarTexture(M.textures.neon)
    E:SmoothBar(element)

    element.GainLossIndicators = E:CreateGainLossIndicators(element)

    local bg = element:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(M.textures.flat)
    bg.multiplier = 0.1
    element.bg = bg

    element.Text = E.CreateString((textParent or frame))

    element.frequentUpdates = true
    element.PostUpdate = element_PostUpdate
    element.UpdateConfig = element_UpdateConfig
    element.UpdateFonts = element_UpdateFonts
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize
    element.UpdateTextPoints = element_UpdateTextPoints
    element.UpdateTags = element_UpdateTags
    element.UpdateGainLossColors = element_UpdateGainLossColors
		element.UpdateGainLossPoints = element_UpdateGainLossPoints
		element.UpdateGainLossThreshold = element_UpdateGainLossThreshold

    frame.UpdatePower = frame_UpdatePower
    frame.Power = element

    return element
  end
end
