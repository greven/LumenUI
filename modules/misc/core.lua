local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local MISC = P:AddModule("Misc")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false

function MISC:IsInit()
    return isInit
end

function MISC:Init()
    if not isInit and C.db.profile.misc.enabled then
        self:SetUpBindings()
        self:SetUpMerchant()

        isInit = true
    end
end
