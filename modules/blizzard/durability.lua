local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BLIZZARD = P:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false

function BLIZZARD.HasDurabilityFrame()
    return isInit
end

function BLIZZARD.SetUpDurabilityFrame()
    if not isInit and C.db.profile.modules.blizzard.durability.enabled then
        DurabilityFrame:ClearAllPoints()
        DurabilityFrame:SetPoint(unpack(C.db.profile.modules.blizzard.durability.point))
        -- E.Movers:Create(DurabilityFrame)

        isInit = true
    end
end
