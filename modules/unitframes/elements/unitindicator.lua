local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- Lua
local _G = getfenv(0)

local UnitPlayerControlled = _G.UnitPlayerControlled
local IsResting = _G.IsResting

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function update(self)
    if not (self.unit and self:IsShown()) then
        return
    end

    local element = self.UnitIndicator
    local config = element._config
    local showRested = config and config.rested

    local inCombat = UnitAffectingCombat(self.unit)
    local isResting = IsResting()

    if self.unit == "player" then
        if inCombat then
            element:SetStatusBarColor(E:GetRGB(C.colors.red))
        elseif showRested and isResting then
            element:SetStatusBarColor(E:GetRGB(C.colors.green))
        else
            element:SetStatusBarColor(E:GetRGB(E:GetUnitColor(self.unit, true, true)))
        end
    elseif UnitPlayerControlled(self.unit) then -- Player controlled units
        if inCombat then
            element:SetStatusBarColor(E:GetRGB(C.colors.red))
        else
            element:SetStatusBarColor(E:GetRGB(E:GetUnitColor(self.unit, true, true)))
        end
    else -- NPCs
        if inCombat then
            element:SetStatusBarColor(E:GetRGB(E:GetUnitReactionColor("target")))
        else
            element:SetStatusBarColor(E:GetRGB(E:GetUnitColor(self.unit, true, true)))
        end
    end

    if config and config.hide_out_of_combat then
        if inCombat or (showRested and isResting) then
            element:Show()
        else
            element:Hide()
        end
    end
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.modules.unitframes.units[unit].unitIndicator, self._config)
end

local function element_UpdateSize(self)
    self:SetSize(self._config.width, self._config.height)
end

local function element_UpdatePoints(self)
    local config = self._config.point

    self:ClearAllPoints()

    if config and config.p and config.p ~= "" then
        E:SetPosition(self, config, self.__owner)
    end
end

local function frame_UpdateUnitIndicator(self)
    local element = self.UnitIndicator
    element:UpdateConfig()
    element:UpdateSize()
    element:UpdatePoints()
    update(self)
end

function UF:CreateUnitIndicator(frame, parent)
    local element = CreateFrame("StatusBar", nil, (parent or frame))
    element:SetStatusBarTexture(C.media.textures.flat)
    element:SetOrientation("VERTICAL")

    E:SetBackdrop(element, E.SCREEN_SCALE * 3)
    E:CreateShadow(element)

    hooksecurefunc(frame, "Show", update)

    element.__owner = frame
    element.UpdateConfig = element_UpdateConfig
    element.UpdateSize = element_UpdateSize
    element.UpdatePoints = element_UpdatePoints

    frame.UpdateUnitIndicator = frame_UpdateUnitIndicator
    frame.UnitIndicator = element

    return element
end
