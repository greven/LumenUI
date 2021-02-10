local _, ns = ...
local E, C, L, oUF = ns.E, ns.C, ns.L, ns.oUF

local UF = E:AddModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack
local next = _G.next

-- ---------------

local isInit = false
local objects = {}
local units = {}

function UF:For(unit, method, ...)
    if units[unit] and C.modules.unitframes.units[unit].enabled then
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
    for unit in next, units do
        self:For(unit, method, ...)
    end
end

function UF:ForEach(method, ...)
    for unit in next, units do
        self:For(unit, method, ...)
    end
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

function UF:Create(unit, name)
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

            objects[unit] = object
        end

        units[unit] = true
    end
end

function UF:SpawnFrames()
    local config = C.modules.unitframes

    if config.units.player.enabled then
        UF:Create("player", "LumPlayer")
        UF:For("player", "Update")
        UF:Create("pet", "LumPet")
        UF:For("pet", "Update")
    end

    if config.units.playerplate.enabled then
        UF:Create("playerplate", "LumPlayerPlate")
        UF:For("playerplate", "Update")
    end

    if config.units.target.enabled then
        UF:Create("target", "LumTarget")
        UF:For("target", "Update")
    end

    if config.units.targetplate.enabled then
        UF:Create("targetplate", "LumTargetPlate")
        UF:For("targetplate", "Update")
    end

    if config.units.targettarget.enabled then
        UF:Create("targettarget", "LumTargetTarget")
        UF:For("targettarget", "Update")
    end

    if config.units.focus.enabled then
        UF:Create("focus", "LumFocus")
        UF:For("focus", "Update")
    end

    if config.units.focustarget.enabled then
        UF:Create("focustarget", "LumFocusTarget")
        UF:For("focustarget", "Update")
    end

    -- if config.units.party.enabled then
    -- UF:Create("party", "LumParty")
    -- UF:For("party", "Update")
    -- end
end

function UF:CreateFrames()
    oUF:Factory(
        function()
            oUF:RegisterStyle(
                "Lum",
                function(frame, unit)
                    UF:SetSharedStyle(frame, unit)

                    if unit == "player" then
                        if frame._layout == "playerplate" then
                            UF:CreatePlayerPlateFrame(frame)
                        else
                            UF:CreatePlayerFrame(frame)
                        end
                    elseif unit == "target" then
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
                end
            )
            oUF:SetActiveStyle("Lum")
            UF:SpawnFrames()
        end
    )
end

function UF:IsInit()
    return isInit
end

function UF:Init()
    if not isInit and C.modules.unitframes.enabled then
        self:UpdateColors()
        UF:CreateFrames()

        isInit = true
    end
end

function UF:Update()
    if isInit then
        for unit in next, units do
            self:For(unit, "Update")
        end
    end
end
