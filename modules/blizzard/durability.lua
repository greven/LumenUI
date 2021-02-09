local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)

--[[ luacheck: globals
	DurabilityFrame UIParent
]]
-- Mine
local isInit = false

function M.HasDurabilityFrame()
    return isInit
end

function M.SetUpDurabilityFrame()
    if not isInit and C.modules.blizzard.durability.enabled then
        DurabilityFrame:ClearAllPoints()
        DurabilityFrame:SetPoint(unpack(C.modules.blizzard.durability.point))
        -- E.Movers:Create(DurabilityFrame)

        isInit = true
    end
end
