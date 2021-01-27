local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function frame_OnEnter(self)
    self = self.__owner or self
    UnitFrame_OnEnter(self)
end

local function frame_OnLeave(self)
    self = self.__owner or self
    UnitFrame_OnLeave(self)
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.modules.unitframes.units[unit].portrait,
                               self._config)
end

local function element_UpdateFonts(self)
    local element = self.Text
    local config = self._config.text

    if element then
        element:SetFont(config.font or C.media.fonts.condensed, config.size,
                        config.outline and "OUTLINE" or nil)
        element:SetJustifyH(config.h_alignment)
        element:SetJustifyV(config.v_alignment)
        element:SetWordWrap(config.word_wrap)

        if config.shadow then
            element:SetShadowOffset(1, -1)
        else
            element:SetShadowOffset(0, 0)
        end
    end
end

local function element_UpdateTextPoints(self)
    local config = self._config.text.point

    self.Text:ClearAllPoints()

    if config and config.p then E:SetPosition(self.Text, config, self) end
end

local function element_UpdateTags(self)
    if self.Text then
        local config = self._config.text
        if config.tag ~= "" then
            self.__owner:Tag(self.Text, config.tag)
            self.Text:UpdateTag()
        else
            self.__owner:Untag(self.Text)
            self.Text:SetText("")
        end
    end
end

local function element_PostUpdate(self)
    local config = self._config

    if config then
        if config.style == "2D" then
            self:SetDesaturation(config.desaturation or 0)
            self:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        else -- 3D
            self:SetDesaturation(config.desaturation or 0)
            self:SetModelAlpha(config.model_alpha or 1)
            self:SetCamDistanceScale(0.8)
            self:SetPortraitZoom(1)
        end
    end
end

local function frame_UpdatePortrait(self)
    if C.modules.unitframes.units[self._unit].portrait.style == "2D" then
        self.Portrait = self.Portrait2D
        self.Portrait3D:ClearAllPoints()
        self.Portrait3D:Hide()
    else
        self.Portrait = self.Portrait3D
        self.Portrait2D:ClearAllPoints()
        self.Portrait2D:Hide()
    end

    self.Portrait3D.__owner = self.Portrait2D.__owner
    self.Portrait3D.ForceUpdate = self.Portrait2D.ForceUpdate

    local element = self.Portrait
    element:UpdateConfig()
    element:Hide()

    if element._config.enabled and not self:IsElementEnabled("Portrait") then
        self:EnableElement("Portrait")
    elseif not element._config.enabled and self:IsElementEnabled("Portrait") then
        self:DisableElement("Portrait")
    end

    if self:IsElementEnabled("Portrait") then
        element:SetInside()
        element:UpdateFonts()
        element:UpdateTextPoints()
        element:UpdateTags()

        element:Show()
        element:ForceUpdate()
    end
end

function UF:CreatePortrait(frame, parent)
    frame.Portrait2D = (parent or frame):CreateTexture(nil, "ARTWORK")
    frame.Portrait2D.PostUpdate = element_PostUpdate
    frame.Portrait2D.UpdateConfig = element_UpdateConfig
    frame.Portrait2D.UpdateFonts = element_UpdateFonts
    frame.Portrait2D.UpdateTextPoints = element_UpdateTextPoints
    frame.Portrait2D.UpdateTags = element_UpdateTags
    frame.Portrait = frame.Portrait2D

    frame.Portrait3D = CreateFrame("PlayerModel", nil, parent or frame)
    frame.Portrait3D.PostUpdate = element_PostUpdate
    frame.Portrait3D.UpdateConfig = element_UpdateConfig
    frame.Portrait3D.UpdateFonts = element_UpdateFonts
    frame.Portrait3D.UpdateTextPoints = element_UpdateTextPoints
    frame.Portrait3D.UpdateTags = element_UpdateTags

    local text = (parent or frame):CreateFontString(nil, "ARTWORK")
    frame.Portrait2D.Text = text
    frame.Portrait3D.Text = text

    frame.UpdatePortrait = frame_UpdatePortrait

    return frame.Portrait2D
end
