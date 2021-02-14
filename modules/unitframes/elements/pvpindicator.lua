local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- Lua
local _G = getfenv(0)

local UnitFactionGroup = _G.UnitFactionGroup
local UnitIsMercenary = _G.UnitIsMercenary
local UnitIsPVP = _G.UnitIsPVP
local UnitIsPVPFreeForAll = _G.UnitIsPVPFreeForAll

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------
local function element_Override(self, _, unit)
    if unit ~= self.unit then
        return
    end

    local element = self.PvPIndicator
    unit = unit or self.unit

    local factionGroup = UnitFactionGroup(unit) or "Neutral"
    local status

    if UnitIsPVPFreeForAll(unit) then
        status = "FFA"
    elseif factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit) then
        if unit == "player" and UnitIsMercenary(unit) then
            if factionGroup == "Horde" then
                factionGroup = "Alliance"
            elseif factionGroup == "Alliance" then
                factionGroup = "Horde"
            end
        end

        status = factionGroup
    end

    if status then
        element:SetTexture("Interface\\AddOns\\LumenUI\\media\\textures\\pvp")

        if status == "Alliance" then
            element:SetVertexColor(E:GetRGB(C.db.global.colors.faction[status]))
            if element.Timer then
                element.Timer:SetTextColor(E:GetRGB(C.db.global.colors.faction[status]))
            end
        elseif status == "Horde" then
            element:SetVertexColor(E:GetRGB(C.db.global.colors.faction[status]))
            if element.Timer then
                element.Timer:SetTextColor(E:GetRGB(C.db.global.colors.faction[status]))
            end
        else
            element:SetVertexColor(E:GetRGB(C.db.global.colors.amber))
            if element.Timer then
                element.Timer:SetTextColor(E:GetRGB(C.db.global.colors.amber))
            end
        end

        element:Show()
    else
        element:Hide()
    end
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.db.profile.modules.unitframes.units[unit].pvp, self._config)
end

local function element_UpdateSize(self)
    self:SetSize(self._config.width, self._config.height)
end

local function element_UpdatePoints(self)
    local frame = self.__owner

    self:ClearAllPoints()

    local config = self._config.point
    if config and config.p and config.p ~= "" then
        E:SetPosition(self, config, frame)
    end
end

local function element_UpdateTags(self)
    if self.Timer then
        local tag = self._config.enabled and "[lum:pvptimer]" or ""
        if tag ~= "" then
            self.Timer.frequentUpdates = 0.1
            self.__owner:Tag(self.Timer, tag)
            self.Timer:UpdateTag()
        else
            self.Timer.frequentUpdates = nil
            self.__owner:Untag(self.Timer)
            self.Timer:SetText("")
        end
    end
end

local function frame_UpdatePvPIndicator(self)
    local element = self.PvPIndicator
    element:UpdateConfig()
    element:UpdateSize()
    element:UpdatePoints()
    element:UpdateTags()

    element:SetAlpha(element._config.alpha or 1)

    if element._config.enabled and not self:IsElementEnabled("PvPIndicator") then
        self:EnableElement("PvPIndicator")
    elseif not element._config.enabled and self:IsElementEnabled("PvPIndicator") then
        self:DisableElement("PvPIndicator")
    end

    if self:IsElementEnabled("PvPIndicator") then
        element:ForceUpdate()
    end
end

function UF:CreatePvPIndicator(frame, parent)
    local holder = CreateFrame("Frame", nil, parent or frame)
    holder:SetFrameLevel(frame:GetFrameLevel() + 3)
    holder:SetSize(50, 50)

    local element = holder:CreateTexture(nil, "ARTWORK", nil, 0)
    element:SetSize(32, 32)
    element.Holder = holder

    element.__owner = frame
    element.Override = element_Override
    element.UpdateConfig = element_UpdateConfig
    element.UpdateSize = element_UpdateSize
    element.UpdatePoints = element_UpdatePoints
    element.UpdateTags = element_UpdateTags

    frame.UpdatePvPIndicator = frame_UpdatePvPIndicator
    frame.PvPIndicator = element

    return element
end
