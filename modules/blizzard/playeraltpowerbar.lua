local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false

function M.HasAltPowerBar()
    return isInit
end

function M.SetUpAltPowerBar()
    if not isInit and C.modules.blizzard.player_alt_power_bar.enabled then
        PlayerPowerBarAlt.ignoreFramePositionManager = true
        UIPARENT_ALTERNATE_FRAME_POSITIONS["PlayerPowerBarAlt_Top"] = nil
        UIPARENT_ALTERNATE_FRAME_POSITIONS["PlayerPowerBarAlt_Bottom"] = nil
        UIPARENT_MANAGED_FRAME_POSITIONS["PlayerPowerBarAlt"] = nil

        local holder = CreateFrame("Frame", "LumPowerBarAltHolder", _G.UIParent)
        holder:SetSize(64, 64)
        holder:SetPoint("TOP", 0, -200)
        -- E.Movers:Create(holder)

        PlayerPowerBarAlt:SetMovable(true)
        PlayerPowerBarAlt:SetUserPlaced(true)
        PlayerPowerBarAlt:SetParent(holder)
        PlayerPowerBarAlt:ClearAllPoints()
        PlayerPowerBarAlt:SetPoint("BOTTOM", holder, "BOTTOM", 0, 0)

        isInit = true
    end
end
