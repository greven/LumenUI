local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack
local next = _G.next

-- ---------------

local UF = E:AddModule("UnitFrames")

-- ---------------

local isInit = false
local objects = {}
local units = {}

local configIgnoredKeys = {
    alt_power = true,
    auras = true,
    border = true,
    castbar = true,
    class = true,
    class_power = true,
    combat_feedback = true,
    debuff = true,
    health = true,
    name = true,
    portrait = true,
    power = true,
    pvp = true,
    raid_target = true,
    threat = true
}

local function frame_OnEnter(self)
    self = self.__owner or self
    UnitFrame_OnEnter(self)
end

local function frame_OnLeave(self)
    self = self.__owner or self
    UnitFrame_OnLeave(self)
end

local function frame_UpdateConfig(self)
    self._config = E:CopyTable(C.modules.unitframes.units[self._layout or
                                   self._unit], self._config, configIgnoredKeys)
end

local function frame_UpdateSize(self)
    local width, height = self._config.width, self._config.height

    self:SetSize(width, height)

    if self.TextParent then self.TextParent:SetSize(width - 8, height) end
end

local function frame_ForElement(self, element, method, ...)
    if self[element] and self[element][method] then
        self[element][method](self[element], ...)
    end
end

function UF:UpdateHealthColors()
    local color = oUF.colors.health
    color[1], color[2], color[3] = E:GetRGB(C.colors.health)

    color = oUF.colors.tapped
    color[1], color[2], color[3] = E:GetRGB(C.colors.tapped)

    color = oUF.colors.disconnected
    color[1], color[2], color[3] = E:GetRGB(C.colors.disconnected)

    oUF.colors.smooth = C.colors.smooth
end

function UF:UpdatePowerColors()
    local color = oUF.colors.power
    for k, myColor in next, C.colors.power do
        if type(k) == "string" then
            if not color[k] then color[k] = {} end

            if type(myColor[1]) == "table" then
                for i, myColor_ in next, myColor do
                    color[k][i][1], color[k][i][2], color[k][i][3] =
                        E:GetRGB(myColor_)
                end
            else
                color[k][1], color[k][2], color[k][3] = E:GetRGB(myColor)
            end
        end
    end

    color = oUF.colors.runes
    for k, v in next, C.colors.runes do
        color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
    end
end

function UF:UpdateReactionColors()
    local color = oUF.colors.reaction
    for k, v in next, C.colors.reaction do
        color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
    end
end

function UF:CreateUnitFrame(unit, name)
    if not units[unit] then
        if unit == "party" then
            -- Party
        elseif unit == "raid" then
            -- Raid
        elseif unit == "boss" then
            -- Boss
        else
            local object

            if unit == "playerplate" then
                object = oUF:Spawn("player", name .. "Frame")
            elseif unit == "targetplate" then
                object = oUF:Spawn("target", name .. "Frame")
            else
                object = oUF:Spawn(unit, name .. "Frame")
            end

            object:UpdateConfig()
            E:SetPosition(object, object._config.point)
            if C.global.shadows.enabled then E:CreateShadow(object) end

            objects[unit] = object
        end

        units[unit] = true
    end
end

function UF:UpdateUnitFrame(unit, method, ...)
    if units[unit] then
        if unit == "boss" then
            -- Boss
        elseif objects[unit] then
            if objects[unit][method] then
                objects[unit][method](objects[unit], ...)
            end
        end
    end
end

function UF:UpdateUnitFrames(method, ...)
    for unit in next, units do self:UpdateUnitFrame(unit, method, ...) end
end

function UF:ForEach(method, ...)
    for unit in next, units do self:UpdateUnitFrame(unit, method, ...) end
end

function UF:GetUnits(ignoredUnits)
    local temp = {}

    for unit in next, units do
        if not ignoredUnits or not ignoredUnits[unit] then
            temp[unit] = unit
        end
    end

    return temp
end

function UF:IsInit() return isInit end

function UF:Init()
    local config = C.modules.unitframes

    if not isInit and config.enabled then
        self:UpdateHealthColors()
        self:UpdatePowerColors()
        self:UpdateReactionColors()

        oUF:Factory(function()
            oUF:RegisterStyle("Lum", function(frame, unit)
                local name = frame:GetName()

                frame:RegisterForClicks("AnyUp")
                frame:SetScript("OnEnter", frame_OnEnter)
                frame:SetScript("OnLeave", frame_OnLeave)

                frame._unit = unit:gsub("%d+", "")
                frame._layout = name:match("Lum(%a+)Frame"):lower()

                frame.ForElement = frame_ForElement
                frame.UpdateConfig = frame_UpdateConfig
                frame.UpdateSize = frame_UpdateSize

                if unit == "player" then
                    if frame._layout == "playerplate" then
                        UF:CreatePlayerPlateFrame(frame)
                    else
                        UF:CreatePlayerFrame(frame)
                    end
                elseif unit == "target" then
                    -- UF:CreateTargetFrame(frame)
                    if frame._layout == "targetplate" then
                        UF:CreateTargetPlateFrame(frame)
                    else
                        UF:CreateTargetFrame(frame)
                    end
                elseif unit == "targettarget" then
                    UF:CreateTargetTargetFrame(frame)
                elseif unit == "focus" then
                    UF:CreateFocusFrame(frame)
                elseif unit == "focustarget" then
                    UF:CreateFocusTargetFrame(frame)
                elseif unit == "pet" then
                    UF:CreatePetFrame(frame)
                end
            end)
        end)
        oUF:SetActiveStyle("Lum")

        if config.units.player.enabled then
            UF:CreateUnitFrame("player", "LumPlayer")
            UF:UpdateUnitFrame("player", "Update")
            UF:CreateUnitFrame("pet", "LumPet")
            UF:UpdateUnitFrame("pet", "Update")
        end

        if config.units.playerplate.enabled then
            UF:CreateUnitFrame("playerplate", "LumPlayerPlate")
            UF:UpdateUnitFrame("playerplate", "Update")
        end

        if config.units.target.enabled then
            UF:CreateUnitFrame("target", "LumTarget")
            UF:UpdateUnitFrame("target", "Update")
        end

        if config.units.targetplate.enabled then
            UF:CreateUnitFrame("targetplate", "LumTargetPlate")
            UF:UpdateUnitFrame("targetplate", "Update")
        end

        if config.units.targettarget.enabled then
            UF:CreateUnitFrame("targettarget", "LumTargetTarget")
            UF:UpdateUnitFrame("targettarget", "Update")
        end

        if config.units.focus.enabled then
            UF:CreateUnitFrame("focus", "LumFocus")
            UF:UpdateUnitFrame("focus", "Update")
        end

        if config.units.focustarget.enabled then
            UF:CreateUnitFrame("focustarget", "LumFocusTarget")
            UF:UpdateUnitFrame("focustarget", "Update")
        end

        isInit = true
    end
end

function UF:Update()
    if isInit then
        for unit in next, units do self:UpdateUnitFrame(unit, "Update") end
    end
end
