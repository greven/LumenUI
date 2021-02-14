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
    if units[unit] and C.profile.modules.unitframes.units[unit].enabled then
        if unit == "party" then
            local header = objects[unit]
            if header then
                for i = 1, header:GetNumChildren() do
                    local child = select(i, header:GetChildren())
                    if child and child[method] then
                        child[method](child, ...)
                    end
                end
            end
        elseif unit == "boss" then
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

function UF:CreateHeader(unit, name)
    local config = C.profile.modules.unitframes.units

    -- Party
    do
        local partyWidth = config.party.width
        local partyHeight = config.party.height
        local xOffset, yOffset = config.party.x_offset, config.party.y_offset
        local horizontalParty = config.party.orientation == "HORIZONTAL"
        local groupingOrder = horizontalParty and "TANK,HEALER,DAMAGER,NONE" or "NONE,DAMAGER,HEALER,TANK"
        local showSolo = config.party.show_solo

        -- Spawn Headers here
        local header =
            oUF:SpawnHeader(
            "LumPartyFrame",
            nil,
            "solo,party",
            "showPlayer",
            true,
            "showSolo",
            showSolo,
            "showParty",
            true,
            "showRaid",
            false,
            "xoffset",
            xOffset,
            "yOffset",
            yOffset,
            "groupingOrder",
            groupingOrder,
            "groupBy",
            "ASSIGNEDROLE",
            "sortMethod",
            "NAME",
            "point",
            horizontalParty and "LEFT" or "BOTTOM",
            "columnAnchorPoint",
            "LEFT",
            "oUF-initialConfigFunction",
            ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
                ]]):format(
                partyWidth,
                partyHeight
            )
        )

        header:ClearAllPoints()

        return header
    end
end

function UF:Create(unit, name)
    if not units[unit] then
        if unit == "boss" then
            -- Boss
        elseif unit == "party" then
            local header = UF:CreateHeader("party", name .. "Frame")

            E:SetPosition(header, C.profile.modules.unitframes.units[unit].point)
            objects[unit] = header
        else
            local object

            if unit == "playerplate" then
                object = oUF:Spawn("player", name .. "Frame")
            elseif unit == "targetplate" then
                object = oUF:Spawn("target", name .. "Frame")
            else
                object = oUF:Spawn(unit, name .. "Frame")
            end

            E:SetPosition(object, C.profile.modules.unitframes.units[unit].point)
            objects[unit] = object
        end

        units[unit] = true
    end
end

function UF:CreateFrames()
    local config = C.profile.modules.unitframes.units

    oUF:Factory(
        function()
            oUF:RegisterStyle(
                "Lum",
                function(frame, unit)
                    frame._parent = frame:GetParent()
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
                    elseif unit == "party" then
                        UF:CreatePartyFrame(frame)
                    elseif unit:match("^boss%d") then
                    -- TODO: Create Boss
                    end
                end
            )
            oUF:SetActiveStyle("Lum")

            -- Spawn Frames
            if config.player.enabled then
                UF:Create("player", "LumPlayer")
                UF:For("player", "Update")
                UF:Create("pet", "LumPet")
                UF:For("pet", "Update")
            end

            if config.playerplate.enabled then
                UF:Create("playerplate", "LumPlayerPlate")
                UF:For("playerplate", "Update")
            end

            if config.target.enabled then
                UF:Create("target", "LumTarget")
                UF:For("target", "Update")
            end

            if config.targetplate.enabled then
                UF:Create("targetplate", "LumTargetPlate")
                UF:For("targetplate", "Update")
            end

            if config.targettarget.enabled then
                UF:Create("targettarget", "LumTargetTarget")
                UF:For("targettarget", "Update")
            end

            if config.focus.enabled then
                UF:Create("focus", "LumFocus")
                UF:For("focus", "Update")
            end

            if config.focustarget.enabled then
                UF:Create("focustarget", "LumFocusTarget")
                UF:For("focustarget", "Update")
            end

            if config.party.enabled then
                UF:Create("party", "LumParty")
                UF:For("party", "Update")
            end
        end
    )
end

function UF:IsInit()
    return isInit
end

function UF:Init()
    if not isInit and C.profile.modules.unitframes.enabled then
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
