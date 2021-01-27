local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Misc")
local Bags = E:GetModule("Bags")

-- Lua
local _G = getfenv(0)
local CanMerchantRepair = _G.CanMerchantRepair
local GetRepairAllCost = _G.GetRepairAllCost

-- ---------------

local isInit = false
local config = C.modules.misc.merchant

function M.AttemptAutoRepair(self)
    -- print("Attempt to Repair!!")
end

local function frame_OnEvent(self, event)
    if event == "MERCHANT_SHOW" then
        if config.vendor_grays.enabled then
            E:Delay(0.5, Bags.VendorGrays)
        end

        if not config.auto_repair.enabled or IsShiftKeyDown() or
            not CanMerchantRepair() then return end

        -- Prepare to catch 'not enough money' messages
        self:RegisterEvent("UI_ERROR_MESSAGE")
        self:RegisterEvent("MERCHANT_CLOSED")

        M.AttemptAutoRepair(self)
    end

    if event == "MERCHANT_CLOSED" then
        self:UnregisterEvent("UI_ERROR_MESSAGE")
        self:UnregisterEvent("MERCHANT_CLOSED")
    end
end

function M.SetUpMerchant()
    if not isInit and config.enabled then
        local frame = CreateFrame("Frame", nil, UIParent)

        frame:SetScript("OnEvent", frame_OnEvent)
        frame:RegisterEvent("MERCHANT_SHOW")
    end
end
