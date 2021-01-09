local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- Lua
local _G = getfenv(0)

local UnitGUID = _G.UnitGUID
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitCanAttack = _G.UnitCanAttack
local CreateColor = _G.CreateColor

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function updateFont(fontString, config)
  fontString:SetFont(C.global.fonts.units.font.number, config.size, config.outline and "THINOUTLINE" or nil)
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

-- Health
do
  local function element_PostUpdate(self, unit, cur, max)
    local unitGUID = UnitGUID(unit)
    local config = self._config

		self.GainLossIndicators:Update(cur, max, unitGUID == self.GainLossIndicators._UnitGUID)
		self.GainLossIndicators._UnitGUID = unitGUID

    if config.color.reverse and config.color.smooth then
      local color = CreateColor(oUF:ColorGradient(cur, max, unpack(oUF.colors.smooth)))
      self.bg:SetVertexColor(E:GetRGB(color))
    end

    if config.text.hide_when_max and cur == max then
			self.Text:Hide()
		else
			self.Text:Show()
    end

    -- Kill Range texture
    if config.kill_range and (E:UnitIsDisconnectedOrDeadOrGhost(unit) or not UnitCanAttack("player", unit)) then
      self.KillRange:Hide()
      self.KillRange.spark:Hide()
    else
      if config.kill_range then
        self.KillRange:Show()
        self.KillRange.spark:Show()
      end
    end

    if not (self:IsShown() and max and max ~= 0) or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
			self:SetMinMaxValues(0, 1)
      self:SetValue(0)
    end
	end

  local function element_PostUpdateColor(self)
    local unit = self.__owner._unit
    local config = self._config

    if config.color.reverse then
      if not config.color.smooth then
        if config.color.health then
          self.bg:SetVertexColor(E:GetRGB(C.colors.health))
        else
          self.bg:SetVertexColor(E:GetRGB(E:GetUnitColor(unit, config.color.class, config.color.reaction)))
        end
      end
    end
  end

  local function element_UpdateFonts(self)
    updateFont(self.Text, self._config.text)

    if self.Text.perc then
      updateFont(self.Text.perc, self._config.perc)
    end
  end

  local function element_UpdateTextPoints(self)
    updateTextPoint(self.__owner, self.Text, self._config.text.point)

    if self._config.perc then
      updateTextPoint(self.__owner, self.Text.perc, self._config.perc.point)
    end
  end

  local function element_UpdateKillZone(self)
    if self._config.kill_range then
      self.KillRange:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
      self.KillRange:SetPoint("TOPRIGHT", self, "TOPLEFT", self:GetWidth() * 0.2, 0)
      self.KillRange.spark:SetSize(1, self:GetHeight())
      self.KillRange.spark:SetPoint("LEFT", self, "LEFT", self:GetWidth() * 0.2, 0)
    end
  end

  local function element_UpdateTags(self)
    updateTag(self.__owner, self.Text, self._config.enabled and self._config.text.tag or "")

    if self._config.perc then
      updateTag(self.__owner, self.Text.perc, self._config.enabled and self._config.perc.tag or "")
    end
  end

  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit].health, self._config)
		self._config.power = E:CopyTable(C.modules.unitframes.units[unit].power, self._config.power)
  end

  local function element_UpdateColors(self)
    local config = self._config

    self.colorSmooth = config.color.smooth
    self.colorHealth = not config.color.reverse and config.color.health
    self.colorTapping = not config.color.reverse and config.color.tapping
    self.colorDisconnected = not config.color.reverse and config.color.disconnected
		self.colorClass = not config.color.smooth and config.color.class
    self.colorReaction = not config.color.smooth and not config.color.reverse and config.color.reaction

    if config.color.reverse then
      self.colorClass = false
      self.colorSmooth = false
      self:SetStatusBarTexture(M.textures.vertlines)
      self:SetAlpha(0.96)
      self.bg:SetTexture(C.global.statusbar.texture)
      self.bg:SetAlpha(0.9)
    end

    self:ForceUpdate()
  end

  local function element_UpdateSize(self)
    local frame = self:GetParent()
    local config = self._config

    self:SetPoint("TOP", frame, 0, 0)
    self:SetPoint("BOTTOM", frame, 0, config.power.height + config.power.gap)
    self:SetPoint("LEFT", frame, 0, 0)
    self:SetPoint("RIGHT", frame, 0, 0)
    self:ForceUpdate()
  end

  local function element_UpdateGainLossPoints(self)
		self.GainLossIndicators:UpdatePoints(self._config.orientation)
	end

	local function element_UpdateGainLossThreshold(self)
		self.GainLossIndicators:UpdateThreshold(self._config.change_threshold)
	end

	local function element_UpdateGainLossColors(self)
		self.GainLossIndicators:UpdateColors()
	end

  local function frame_UpdateHealth(self)
    local element = self.Health
    element:UpdateConfig()
    element:UpdateColors()
    element:UpdateSize()
    element:UpdateFonts()
    element:UpdateTextPoints()
    element:UpdateTags()
    element:UpdateGainLossColors()
		element:UpdateGainLossPoints()
    element:UpdateGainLossThreshold()
    element:UpdateKillZone()
		element:ForceUpdate()
  end

  function UF:CreateHealthBar(frame, textParent)
    local config = C.modules.unitframes.units[frame._unit].health

    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("TOPLEFT", frame)
    element:SetPoint("TOPRIGHT", frame)
    element:SetStatusBarTexture(C.global.statusbar.texture)
    element:SetStatusBarColor(E:GetRGB(C.global.statusbar.color))
    E:SmoothBar(element)

    element.Text = (textParent or element):CreateFontString(nil, "ARTWORK")

    if config.perc then
      local perc = element:CreateFontString(nil, "BACKGROUND")
      perc:SetTextColor(0.4, 0.4, 0.4, 0.8)
      element.Text.perc = perc
    end

    element.GainLossIndicators = E:CreateGainLossIndicators(element)
		element.GainLossIndicators.Gain = nil

    local bg = element:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(M.textures.vertlines)
    bg:SetAlpha(0.4)
    bg.multiplier = 0.3
    element.bg = bg

    kr = element:CreateTexture(nil, "OVERLAY")
    kr:SetTexture("Interface\\BUTTONS\\WHITE8X8")
    kr:SetVertexColor(1, 0, 0)
    kr:SetBlendMode("ADD")
    kr:SetAlpha(0.2)

    kr.spark = element:CreateTexture(nil, "OVERLAY")
    kr.spark:SetTexture("Interface\\BUTTONS\\WHITE8X8")
    kr.spark:SetVertexColor(1, 0.25, 0.25)
    kr.spark:SetBlendMode("ADD")
    kr.spark:SetAlpha(0.6)
    element.KillRange = kr

    element.PostUpdate = element_PostUpdate
    element.PostUpdateColor = element_PostUpdateColor
    element.UpdateConfig = element_UpdateConfig
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize
    element.UpdateFonts = element_UpdateFonts
    element.UpdateTextPoints = element_UpdateTextPoints
    element.UpdateKillZone = element_UpdateKillZone
    element.UpdateTags = element_UpdateTags
    element.UpdateGainLossColors = element_UpdateGainLossColors
		element.UpdateGainLossPoints = element_UpdateGainLossPoints
    element.UpdateGainLossThreshold = element_UpdateGainLossThreshold

    frame.UpdateHealth = frame_UpdateHealth
    frame.Health = element

    return element
  end
end
