local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Misc")
local Bags = E:GetModule("Bags")

-- Lua
local _G = getfenv(0)
local s_format = _G.string.format

local IsInGuild = _G.IsInGuild
local CanMerchantRepair = _G.CanMerchantRepair
local GetRepairAllCost = _G.GetRepairAllCost
local CanGuildBankRepair = _G.CanGuildBankRepair
local GetGuildBankWithdrawMoney = _G.GetGuildBankWithdrawMoney
local GetMoneyString = _G.GetMoneyString

-- ---------------

local isInit = false

do
    local repairStatus, repairType, repairCost, canRepair

    function M.AutoRepairOutput()
        if repairType == "GUILD" then
            if repairStatus == "GUILD_REPAIR_FAILED" then
                M:AttemptAutoRepair(true) -- Try using player money instead
            else
                E:Print(s_format(L["ITEMS_REPAIRED_GUILD_FUNDS"], GetMoneyString(repairCost, true)))
            end
        elseif repairType == "PLAYER" then
            if STATUS == "PLAYER_REPAIR_FAILED" then
                E:Print(L["NOT_ENOUGH_MONEY_TO_REPAIR"])
            else
                E:Print(s_format(L["ITEMS_REPAIRED"], GetMoneyString(repairCost, true)))
            end
        end
    end

    function M.AttemptAutoRepair(playerOverride)
        local useGuildFunds = C.db.profile.modules.misc.merchant.auto_repair.use_guild_funds
        repairType = useGuildFunds and "GUILD" or "PLAYER"

        repairCost, canRepair = GetRepairAllCost()

        if canRepair and repairCost > 0 then
            local tryGuild = not playerOverride and useGuildFunds and IsInGuild()
            local useGuild = tryGuild and CanGuildBankRepair() and repairCost <= GetGuildBankWithdrawMoney()

            if not useGuild then
                repairType = "PLAYER"
            end

            RepairAllItems(useGuild)
            E:Delay(0.5, M.AutoRepairOutput)
        end
    end
end

local function frame_OnEvent(self, event, ...)
    if event == "MERCHANT_SHOW" then
        if C.db.profile.modules.misc.merchant.vendor_grays.enabled then
            E:Delay(0.5, Bags.VendorGrays)
        end

        if not C.db.profile.modules.misc.merchant.auto_repair.enabled or IsShiftKeyDown() or not CanMerchantRepair() then
            return
        end

        -- Prepare to catch 'not enough money' messages
        self:RegisterEvent("UI_ERROR_MESSAGE")
        self:RegisterEvent("MERCHANT_CLOSED")

        M.AttemptAutoRepair()
    elseif event == "UI_ERROR_MESSAGE" then
        local messageType = select(1, ...)

        if messageType == LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
            repairStatus = "GUILD_REPAIR_FAILED"
        elseif messageType == LE_GAME_ERR_NOT_ENOUGH_MONEY then
            repairStatus = "PLAYER_REPAIR_FAILED"
        end
    end

    if event == "MERCHANT_CLOSED" then
        self:UnregisterEvent("UI_ERROR_MESSAGE")
        self:UnregisterEvent("MERCHANT_CLOSED")
    end
end

function M.SetUpMerchant()
    if not isInit and C.db.profile.modules.misc.merchant.enabled then
        local frame = CreateFrame("Frame", nil, UIParent)

        frame:SetScript("OnEvent", frame_OnEvent)
        frame:RegisterEvent("MERCHANT_SHOW")

        isInit = true
    end
end
