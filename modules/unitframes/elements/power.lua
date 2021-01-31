local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)

local UnitGUID = _G.UnitGUID

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function updateFont(fontString, config)
    fontString:SetFont(C.global.fonts.units.font, config.size,
                       config.outline and "OUTLINE" or nil)
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

    if config and config.p then E:SetPosition(fontString, config, frame) end
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

local function element_UpdateFonts(self) updateFont(self.Text, self._config.text) end

local function element_UpdateTextPoints(self)
    updateTextPoint(self.__owner, self.Text, self._config.text.point)
end

local function element_UpdateTags(self)
    updateTag(self.__owner, self.Text,
              self._config.enabled and self._config.text.tag or "")
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

-- Power
do
    local function element_PostUpdate(self, unit, cur, _, max)
        local shouldShown = self:IsShown() and max and max ~= 0

        if self.UpdateContainer then self:UpdateContainer(shouldShown) end

        local unitGUID = UnitGUID(unit)
        self.GainLossIndicators:Update(cur, max, unitGUID ==
                                           self.GainLossIndicators._UnitGUID)
        self.GainLossIndicators._UnitGUID = unitGUID

        if shouldShown and cur ~= max then
            self.Text:Show()
        else
            self.Text:Hide()
        end

        if not shouldShown or E:UnitIsDisconnectedOrDeadOrGhost(unit) then
            self:SetMinMaxValues(0, 1)
            self:SetValue(0)
        end
    end

    local function element_UpdateConfig(self)
        local unit = self.__owner._layout or self.__owner._unit
        self._config = E:CopyTable(C.modules.unitframes.units[unit].power,
                                   self._config)
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

    local function element_UpdateColors(self)
        local config = self._config
        self.colorPower = config.color.power
        self.colorTapping = config.color.tapping
        self.colorDisconnected = config.color.disconnected
        self.colorClass = config.color.class

        self:ForceUpdate()
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
        element:SetStatusBarTexture(C.media.textures.neon)
        element:GetStatusBarTexture():SetVertTile(true)
        -- element:GetStatusBarTexture():SetHorizTile(true)
        E:SmoothBar(element)

        local bg = element:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetTexture(C.media.textures.flat)
        bg:SetAlpha(0.25)
        bg.multiplier = 0.4
        element.bg = bg

        element.Text = (textParent or element):CreateFontString(nil, "ARTWORK")

        element.GainLossIndicators = E:CreateGainLossIndicators(element)

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

-- .AdditionalPower
do
    local function element_PostUpdate(self, cur, max)
        if self:IsShown() and max and max ~= 0 then
            self.GainLossIndicators:Update(cur, max)
        end

        -- Hide when full
        if self.__isEnabled then
            if cur == max then
                self:Hide()
            else
                self:Show()
            end
        end

        if not UnitIsConnected("player") or UnitIsDeadOrGhost("player") then
            self:SetMinMaxValues(0, 1)
            self:SetValue(0)
        end
    end

    local function element_UpdateConfig(self)
        local unit = self.__owner._layout or self.__owner._unit
        self._config = E:CopyTable(C.modules.unitframes.units[unit]
                                       .additional_power, self._config)
    end

    local function element_UpdateSize(self)
        local frame = self:GetParent()
        local config = self._config

        self:SetSize(config.width or frame:GetWidth(), config.height or 4)

        local point = config.point
        if point and point.p then
            self:ClearAllPoints()
            self:SetPoint(point.p, E:ResolveAnchorPoint(frame, point.anchor),
                          point.ap, point.x, point.y)
        end
    end

    local function element_UpdateColors(self) self:ForceUpdate() end

    local function frame_UpdateAdditionalPower(frame)
        local element = frame.AdditionalPower
        element:UpdateConfig()
        element:SetOrientation("HORIZONTAL")
        element:UpdateColors()
        element:UpdateSize()
        element:UpdateGainLossColors()
        element:UpdateGainLossPoints()
        element:UpdateGainLossThreshold()

        if element._config.enabled and
            not frame:IsElementEnabled("AdditionalPower") then
            frame:EnableElement("AdditionalPower")
        elseif not element._config.enabled and
            frame:IsElementEnabled("AdditionalPower") then
            frame:DisableElement("AdditionalPower")
        end

        element:ForceUpdate()
    end

    function UF:CreateAdditionalPower(frame)
        local element = CreateFrame("StatusBar", nil, frame)
        element:SetStatusBarTexture(C.media.textures.flat)
        element:GetStatusBarTexture():SetVertTile(true)
        element:GetStatusBarTexture():SetHorizTile(true)
        element:SetFrameLevel(frame:GetFrameLevel() + 1)
        E:SmoothBar(element)
        element:Hide()

        local bg = element:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        element:SetFrameLevel(element:GetFrameLevel() + 1)
        bg:SetTexture(C.media.textures.flat)
        bg:SetAlpha(0.5)
        bg.multiplier = 0.3
        element.bg = bg

        element.GainLossIndicators = E:CreateGainLossIndicators(element)

        element.colorPower = true
        element.PostUpdate = element_PostUpdate
        element.UpdateColors = element_UpdateColors
        element.UpdateConfig = element_UpdateConfig
        element.UpdateSize = element_UpdateSize
        element.UpdateGainLossColors = element_UpdateGainLossColors
        element.UpdateGainLossPoints = element_UpdateGainLossPoints
        element.UpdateGainLossThreshold = element_UpdateGainLossThreshold

        frame.UpdateAdditionalPower = frame_UpdateAdditionalPower
        frame.AdditionalPower = element

        return element
    end
end

-- PowerPrediction
do
    local function element_UpdateConfig(self)
        if not self._config then
            self._config = {power = {}, additional_power = {}}
        end

        local unit = self.__owner._layout or self.__owner._unit
        self._config.power.enabled = C.modules.unitframes.units[unit].power
                                         .prediction.enabled
        self._config.additional_power.enabled =
            C.modules.unitframes.units[unit].additional_power.prediction.enabled
    end

    local function element_UpdateColors(self)
        self.mainBar_:SetStatusBarColor(E:GetRGB(C.colors.prediction.power_cost))
        self.altBar_:SetStatusBarColor(E:GetRGB(C.colors.prediction.power_cost))
    end

    local function frame_UpdatePowerPrediction(frame)
        local element = frame.PowerPrediction
        element:UpdateConfig()

        local config1 = element._config.power
        if config1.enabled then
            local mainBar_ = element.mainBar_
            mainBar_:SetOrientation("HORIZONTAL")
            mainBar_:ClearAllPoints()

            local width = frame.Power:GetWidth()
            width = width > 0 and width or frame:GetWidth()

            mainBar_:SetPoint("TOP")
            mainBar_:SetPoint("BOTTOM")
            mainBar_:SetPoint("RIGHT", frame.Power:GetStatusBarTexture(),
                              "RIGHT")
            mainBar_:SetWidth(width)

            element.mainBar = mainBar_
        else
            element.mainBar = nil

            element.mainBar_:Hide()
            element.mainBar_:ClearAllPoints()
        end

        local config2 = element._config.additional_power
        if config2.enabled then
            local altBar_ = element.altBar_
            altBar_:SetOrientation("HORIZONTAL")
            altBar_:ClearAllPoints()

            local width = frame.AdditionalPower:GetWidth()
            width = width > 0 and width or altBar_:SetPoint("TOP")
            altBar_:SetPoint("BOTTOM")
            altBar_:SetPoint("RIGHT",
                             frame.AdditionalPower:GetStatusBarTexture(),
                             "RIGHT")
            altBar_:SetWidth(width)

            element.altBar = altBar_
        else
            element.altBar = nil

            element.altBar_:Hide()
            element.altBar_:ClearAllPoints()
        end

        element:UpdateColors()

        local isEnabled = config1.enabled or config2.enabled
        if isEnabled and not frame:IsElementEnabled("PowerPrediction") then
            frame:EnableElement("PowerPrediction")
        elseif not isEnabled and frame:IsElementEnabled("PowerPrediction") then
            frame:DisableElement("PowerPrediction")
        end

        if frame:IsElementEnabled("PowerPrediction") then
            element:ForceUpdate()
        end
    end

    function UF:CreatePowerPrediction(frame, parent1, parent2)
        local mainBar = CreateFrame("StatusBar", nil, parent1)
        mainBar:SetStatusBarTexture(C.media.textures.flat)
        mainBar:SetReverseFill(true)
        E:SmoothBar(mainBar)
        parent1.CostPrediction = mainBar

        local altBar = CreateFrame("StatusBar", nil, parent2)
        altBar:SetStatusBarTexture(C.media.textures.flat)
        altBar:SetReverseFill(true)
        E:SmoothBar(altBar)
        if parent2 then parent2.CostPrediction = altBar end

        frame.UpdatePowerPrediction = frame_UpdatePowerPrediction

        local element = {
            mainBar_ = mainBar,
            altBar_ = altBar,
            UpdateColors = element_UpdateColors,
            UpdateConfig = element_UpdateConfig
        }

        frame.PowerPrediction = element

        return element
    end
end
