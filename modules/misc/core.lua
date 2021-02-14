local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local MISC = E:AddModule("Misc")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false

function MISC:IsInit()
    return isInit
end

function MISC:Init()
    if not isInit and C.db.profile.modules.misc.enabled then
        self:SetUpGridLines()
        self:SetUpBindings()
        self:SetUpMerchant()

        isInit = true
    end
end
