-- Credits: ElvUI
local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local GetVehicleUIIndicator = _G.GetVehicleUIIndicator
local GetVehicleUIIndicatorSeat = _G.GetVehicleUIIndicatorSeat
local VehicleSeatIndicator_SetUpVehicle = _G.VehicleSeatIndicator_SetUpVehicle

-- ---------------

local isInit = false

local function updatePosition(_, _, anchor)
    if anchor == "MinimapCluster" or anchor == _G.MinimapCluster then
        _G.VehicleSeatIndicator:ClearAllPoints()
        _G.VehicleSeatIndicator:SetPoint(unpack(C.profile.modules.blizzard.vehicle.point))
    end
end

local function setUpVehicle(vehicleID)
    local size = C.profile.modules.blizzard.vehicle.size
    _G.VehicleSeatIndicator:SetSize(size, size)

    local _, numSeatIndicators = GetVehicleUIIndicator(vehicleID)
    if numSeatIndicators then
        local fourth = size / 4

        for i = 1, numSeatIndicators do
            local button = _G["VehicleSeatIndicatorButton" .. i]
            button:SetSize(fourth, fourth)

            local _, xOffset, yOffset = GetVehicleUIIndicatorSeat(vehicleID, i)
            button:ClearAllPoints()
            button:SetPoint("CENTER", button:GetParent(), "TOPLEFT", xOffset * size, -yOffset * size)
        end
    end
end

function M.HasVehicleSeatFrame()
    return isInit
end

function M.SetUpVehicleSeatFrame()
    if not isInit and C.profile.modules.blizzard.vehicle.enabled then
        local VehicleSeatIndicator = _G.VehicleSeatIndicator
        hooksecurefunc(VehicleSeatIndicator, "SetPoint", updatePosition)
        hooksecurefunc("VehicleSeatIndicator_SetUpVehicle", setUpVehicle)
        -- E.Movers:Create(VehicleSeatIndicator)

        local size = C.profile.modules.blizzard.vehicle.size
        VehicleSeatIndicator:SetSize(size, size)

        if VehicleSeatIndicator.currSkin then
            setUpVehicle(VehicleSeatIndicator.currSkin)
        end

        isInit = true
    end
end

function M.UpdateVehicleSeatFrame()
    if isInit then
        if _G.VehicleSeatIndicator.currSkin then
            VehicleSeatIndicator_SetUpVehicle(_G.VehicleSeatIndicator.currSkin)
        end
    end
end
