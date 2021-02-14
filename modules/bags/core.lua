local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Bags")

-- Lua
local _G = getfenv(0)
local t_wipe = _G.table.wipe

-- ---------------

local isInit = false

local function frame_OnEvent(self, event)
    if event == "MERCHANT_CLOSED" then
        M.SellFrame:Hide()

        M.SellFrame.Info.progressTimer = 0
        M.SellFrame.Info.sellInterval = 0.2
        M.SellFrame.Info.progressMax = 0
        M.SellFrame.Info.goldGained = 0
        M.SellFrame.Info.itemsSold = 0
        t_wipe(M.SellFrame.Info.items)
    end
end

function M.IsInit()
    return isInit
end

function M:Init()
    if not isInit and C.profile.modules.bags.enabled then
        local frame = CreateFrame("Frame", "LumBags")

        self:CreateSellFrame()

        frame:SetScript("OnEvent", frame_OnEvent)
        frame:RegisterEvent("MERCHANT_CLOSED")

        isInit = true
    end
end
