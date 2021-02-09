local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function updateTextPoint(frame, fontString, config)
    if config and config.p and config.p ~= "" then
        E:SetPosition(fontString, config, frame)
    end
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.modules.unitframes.units[unit].name, self._config)
end

local function element_UpdateFonts(self)
    local config = self._config

    self:SetFont(config.font or C.media.fonts.condensed, config.size, config.outline and "OUTLINE" or nil)
    self:SetJustifyH(config.h_alignment)
    self:SetJustifyV(config.v_alignment)
    self:SetWordWrap(config.word_wrap)

    if config.shadow then
        self:SetShadowOffset(1, -1)
    else
        self:SetShadowOffset(0, 0)
    end
end

local function element_UpdatePoints(self)
    local config = self._config

    self:ClearAllPoints()
    updateTextPoint(self.__owner, self, config.point)
end

local function element_UpdateTags(self)
    if self._config.tag ~= "" then
        self.__owner:Tag(self, self._config.tag)
        self:UpdateTag()
    else
        self.__owner:Untag(self)
        self:SetText("")
    end
end

local function frame_UpdateName(self)
    local element = self.Name
    element:UpdateConfig()
    element:UpdateFonts()
    element:UpdatePoints()
    element:UpdateTags()
end

function UF:CreateName(frame, textParent)
    local element = (textParent or frame):CreateFontString(nil, "ARTWORK")

    element.__owner = frame
    element.UpdateConfig = element_UpdateConfig
    element.UpdateFonts = element_UpdateFonts
    element.UpdatePoints = element_UpdatePoints
    element.UpdateTags = element_UpdateTags

    frame.UpdateName = frame_UpdateName
    frame.Name = element

    return element
end
