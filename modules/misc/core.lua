local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Misc")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false
local config = C.modules.misc

function M:IsInit() return isInit end

function M:Init()
    if not isInit and config.enabled then
        self:SetUpBindings()
        self:SetUpMerchant()

        isInit = true
    end
end
