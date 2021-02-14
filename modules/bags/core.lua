local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BAGS = P:AddModule("Bags")

-- Lua
local _G = getfenv(0)
local t_wipe = _G.table.wipe

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local isInit = false

local function frame_OnEvent(self, event)
    if event == "MERCHANT_CLOSED" then
        BAGS.SellFrame:Hide()

        BAGS.SellFrame.Info.progressTimer = 0
        BAGS.SellFrame.Info.sellInterval = 0.2
        BAGS.SellFrame.Info.progressMax = 0
        BAGS.SellFrame.Info.goldGained = 0
        BAGS.SellFrame.Info.itemsSold = 0
        t_wipe(BAGS.SellFrame.Info.items)
    end
end

function BAGS.IsInit()
    return isInit
end

function BAGS:Init()
    if not isInit and C.db.profile.modules.bags.enabled then
        local frame = CreateFrame("Frame", "LumBags")

        self:CreateSellFrame()

        frame:SetScript("OnEvent", frame_OnEvent)
        frame:RegisterEvent("MERCHANT_CLOSED")

        isInit = true
    end
end
