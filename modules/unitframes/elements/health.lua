local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

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
  fontString:SetFont(C.global.fonts.units.font or config.font, config.size, config.outline and "THINOUTLINE" or nil)
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

    if config then
      if config.reverse and config.color.smooth then
        local color = CreateColor(oUF:ColorGradient(cur, max, unpack(oUF.colors.smooth)))
        self.bg:SetVertexColor(E:GetRGB(color))
      end

       -- Text
      if self.Text then
        -- Hide text when full
        if config.text.hide_when_max and cur == max then
          self.Text:Hide()
        else
          self.Text:Show()
        end
      end

      -- Percent Text
      if self.Text.perc then
        -- Hide percent text when full
        if self.Text.perc and config.perc.hide_when_max and cur == max then
          self.Text.perc:Hide()
        else
          if self.Text.perc then
            self.Text.perc:Show()
          end
        end
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
    end

    if not (self:IsShown() and max and max ~= 0) or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
			self:SetMinMaxValues(0, 1)
      self:SetValue(0)
    end
	end

  local function element_PostUpdateColor(self)
    local unit = self.__owner._unit
    local config = self._config

    if config then
      if config.reverse then
        if not config.color.smooth then
          if config.color.health then
            self.bg:SetVertexColor(E:GetRGB(C.colors.health))
          else
            self.bg:SetVertexColor(E:GetRGB(E:GetUnitColor(unit, config.color.class, config.color.reaction)))
          end
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
		local unit = self.__owner._layout or self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit].health, self._config)
		self._config.power = E:CopyTable(C.modules.unitframes.units[unit].power, self._config.power)
  end

  local function element_UpdateColors(self)
    local config = self._config

    self.colorSmooth = config.color.smooth
    self.colorHealth = not config.reverse and config.color.health
    self.colorTapping = not config.reverse and config.color.tapping
    self.colorDisconnected = not config.reverse and config.color.disconnected
		self.colorClass = not config.color.smooth and config.color.class
    self.colorReaction = not config.color.smooth and not config.reverse and config.color.reaction

    if config.reverse then
      self.colorClass = false
      self.colorSmooth = false
      self:SetStatusBarTexture(C.media.textures.vertlines)
      self:SetAlpha(0.98)
      self.bg:SetTexture(C.global.statusbar.texture)
      self.bg:SetAlpha(0.9)
    end

    self:ForceUpdate()
  end

  local function element_UpdateSize(self)
    local frame = self:GetParent()
    local config = self._config

    if config.width or config.height then
      self:SetSize(config.width or frame:GetWidth(), config.height or 4)
      self:SetPoint("TOPLEFT", frame, 0, 0)
    else
      local gap = 0
      if config.power then
        if config.power.height then
          gap = gap + config.power.height
        end

        if config.power.gap then
          gap = gap + config.power.gap
        end
      end

      self:SetPoint("TOP", frame, 0, 0)
      self:SetPoint("BOTTOM", frame, 0, gap)
      self:SetPoint("LEFT", frame, 0, 0)
      self:SetPoint("RIGHT", frame, 0, 0)
    end

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
      perc:SetTextColor(E:GetRGBA(config.perc.color or C.colors.light_gray, config.perc.alpha or 1))
      element.Text.perc = perc
    end

    element.GainLossIndicators = E:CreateGainLossIndicators(element)
		element.GainLossIndicators.Gain = nil

    local bg = element:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(C.media.textures.vertlines)
    bg:SetAlpha(0.5)
    bg.multiplier = 0.3
    element.bg = bg

    kr = element:CreateTexture(nil, "OVERLAY")
    kr:SetTexture(C.media.textures.flat)
    kr:SetVertexColor(1, 0, 0)
    kr:SetBlendMode("ADD")
    kr:SetAlpha(0.2)

    kr.spark = element:CreateTexture(nil, "OVERLAY")
    kr.spark:SetTexture(C.media.textures.flat)
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

-- HealthPrediction
do
  local function element_UpdateConfig(self)
		local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.modules.unitframes.units[unit].health.prediction, self._config)
    self._config.absorb_text = E:CopyTable(C.global.fonts.units, self._config.absorb_text)
    self._config.heal_absorb_text = E:CopyTable(C.global.fonts.units, self._config.heal_absorb_text)
  end

  local function element_UpdateFonts(self)
		updateFont(self.absorbBar.Text, self._config.absorb_text)
		updateFont(self.healAbsorbBar.Text, self._config.heal_absorb_text)
  end

  local function element_UpdateTextPoints(self)
		updateTextPoint(self.__owner, self.absorbBar.Text, self._config.absorb_text.point1)
		updateTextPoint(self.__owner, self.healAbsorbBar.Text, self._config.heal_absorb_text.point1)
  end

  local function element_UpdateTags(self)
		updateTag(self.__owner, self.absorbBar.Text, self._config.enabled and self._config.absorb_text.tag or "")
		updateTag(self.__owner, self.healAbsorbBar.Text, self._config.enabled and self._config.heal_absorb_text.tag or "")
  end

  local function element_UpdateColors(self)
		self.myBar._texture:SetColorTexture(E:GetRGBA(C.colors.prediction.my_heal))
		self.otherBar._texture:SetColorTexture(E:GetRGBA(C.colors.prediction.other_heal))
		self.healAbsorbBar._texture:SetColorTexture(E:GetRGBA(C.colors.prediction.heal_absorb))
  end

  local function frame_UpdateHealthPrediction(self)
    local element = self.HealthPrediction
    element:UpdateConfig()

    local config = element._config
		local myBar = element.myBar
		local otherBar = element.otherBar
		local absorbBar = element.absorbBar
    local healAbsorbBar = element.healAbsorbBar

    myBar:SetOrientation("HORIZONTAL")
		otherBar:SetOrientation("HORIZONTAL")
		absorbBar:SetOrientation("HORIZONTAL")
    healAbsorbBar:SetOrientation("HORIZONTAL")

    local width = self.Health:GetWidth()
    width = width > 0 and width or self:GetWidth()

    myBar:ClearAllPoints()
    myBar:SetPoint("TOP")
    myBar:SetPoint("BOTTOM")
    myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
    myBar:SetWidth(width)

    otherBar:ClearAllPoints()
    otherBar:SetPoint("TOP")
    otherBar:SetPoint("BOTTOM")
    otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
    otherBar:SetWidth(width)

    absorbBar:ClearAllPoints()
    absorbBar:SetPoint("TOP")
    absorbBar:SetPoint("BOTTOM")
    absorbBar:SetPoint("LEFT", otherBar:GetStatusBarTexture(), "RIGHT")
    absorbBar:SetWidth(width)

    healAbsorbBar:ClearAllPoints()
    healAbsorbBar:SetPoint("TOP")
    healAbsorbBar:SetPoint("BOTTOM")
    healAbsorbBar:SetPoint("RIGHT", self.Health:GetStatusBarTexture(), "RIGHT")
    healAbsorbBar:SetWidth(width)

    element:UpdateColors()
		element:UpdateFonts()
		element:UpdateTextPoints()
    element:UpdateTags()

    if config.enabled and not self:IsElementEnabled("HealthPrediction") then
			self:EnableElement("HealthPrediction")
		elseif not config.enabled and self:IsElementEnabled("HealthPrediction") then
			self:DisableElement("HealthPrediction")
		end

		if self:IsElementEnabled("HealthPrediction") then
			element:ForceUpdate()
		end
  end

  function UF:CreateHealthPrediction(frame, parent, textParent)
    local level = parent:GetFrameLevel()

    local myBar = CreateFrame("StatusBar", nil, parent)
		myBar:SetFrameLevel(level)
		myBar:SetStatusBarTexture(C.media.textures.flat)
		myBar:GetStatusBarTexture():SetColorTexture(0, 0, 0, 0)
		E:SmoothBar(myBar)
		parent.MyHeal = myBar

		myBar._texture = myBar:CreateTexture(nil, "ARTWORK")
		myBar._texture:SetAllPoints(myBar:GetStatusBarTexture())

		local otherBar = CreateFrame("StatusBar", nil, parent)
		otherBar:SetFrameLevel(level)
		otherBar:SetStatusBarTexture(C.media.textures.flat)
		otherBar:GetStatusBarTexture():SetColorTexture(0, 0, 0, 0)
		E:SmoothBar(otherBar)
		parent.OtherHeal = otherBar

		otherBar._texture = otherBar:CreateTexture(nil, "ARTWORK")
		otherBar._texture:SetAllPoints(otherBar:GetStatusBarTexture())

		local absorbBar = CreateFrame("StatusBar", nil, parent)
		absorbBar:SetFrameLevel(level + 1)
		absorbBar:SetStatusBarTexture(C.media.textures.flat)
		absorbBar:GetStatusBarTexture():SetColorTexture(0, 0, 0, 0)
		E:SmoothBar(absorbBar)
		parent.DamageAbsorb = absorbBar

		local overlay = absorbBar:CreateTexture(nil, "ARTWORK", nil, 1)
    overlay:SetTexture(C.media.textures.absorb, "REPEAT", "REPEAT")
    overlay:SetAlpha(0.8)
		overlay:SetHorizTile(true)
		overlay:SetVertTile(true)
		overlay:SetAllPoints(absorbBar:GetStatusBarTexture())
		absorbBar.Overlay = overlay

		absorbBar.Text = (textParent or parent):CreateFontString(nil, "ARTWORK")

		local healAbsorbBar = CreateFrame("StatusBar", nil, parent)
		healAbsorbBar:SetReverseFill(true)
		healAbsorbBar:SetFrameLevel(level + 1)
		healAbsorbBar:SetStatusBarTexture(C.media.textures.flat)
		healAbsorbBar:GetStatusBarTexture():SetColorTexture(0, 0, 0, 0)
		E:SmoothBar(healAbsorbBar)
		parent.HealAbsorb = healAbsorbBar

		healAbsorbBar._texture = healAbsorbBar:CreateTexture(nil, "ARTWORK")
		healAbsorbBar._texture:SetAllPoints(healAbsorbBar:GetStatusBarTexture())

		healAbsorbBar.Text = (textParent or parent):CreateFontString(nil, "ARTWORK")

		frame.UpdateHealthPrediction = frame_UpdateHealthPrediction

		local element = {
			myBar = myBar,
			otherBar = otherBar,
			absorbBar = absorbBar,
			healAbsorbBar = healAbsorbBar,
			maxOverflow = 1,
			UpdateColors = element_UpdateColors,
			UpdateConfig = element_UpdateConfig,
			UpdateFonts = element_UpdateFonts,
			UpdateTags = element_UpdateTags,
			UpdateTextPoints = element_UpdateTextPoints,
    }

    frame.HealthPrediction = element

    return element
  end
end
