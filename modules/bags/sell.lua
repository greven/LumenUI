local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BAGS = P:GetModule("Bags")

-- Lua
local _G = getfenv(0)

local unpack = _G.unpack
local select = _G.select
local t_insert = _G.table.insert
local t_remove = _G.table.remove
local t_maxn = _G.table.maxn
local s_format = _G.string.format

-- Blizzard
local CreateFrame = _G.CreateFrame
local GetItemInfo = _G.GetItemInfo
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetContainerItemInfo = _G.GetContainerItemInfo
local GetContainerItemID = _G.GetContainerItemID
local UseContainerItem = _G.UseContainerItem
local GetMoneyString = _G.GetMoneyString

-- ---------------

local function frame_OnUpdate(self, elapsed)
    BAGS.SellFrame.Info.progressTimer = BAGS.SellFrame.Info.progressTimer - elapsed
    if BAGS.SellFrame.Info.progressTimer > 0 then
        return
    end
    BAGS.SellFrame.Info.progressTimer = BAGS.SellFrame.Info.sellInterval

    local goldGained, lastItem = BAGS:GetVendorProgress()
    if goldGained then
        BAGS.SellFrame.Info.goldGained = BAGS.SellFrame.Info.goldGained + goldGained
        BAGS.SellFrame.Info.itemsSold = BAGS.SellFrame.Info.itemsSold + 1
        BAGS.SellFrame.statusbar:SetValue(BAGS.SellFrame.Info.itemsSold)

        local timeLeft =
            (BAGS.SellFrame.Info.progressMax - BAGS.SellFrame.Info.itemsSold) * BAGS.SellFrame.Info.sellInterval
        BAGS.SellFrame.statusbar.Text:SetText(BAGS.SellFrame.Info.itemsSold .. " / " .. BAGS.SellFrame.Info.progressMax)
    elseif lastItem then
        BAGS.SellFrame:Hide()

        if BAGS.SellFrame.Info.goldGained > 0 then
            E:Print(s_format(L["SOLD_GRAY_ITEMS_FOR"], GetMoneyString(BAGS.SellFrame.Info.goldGained, true)))
        end
    end
end

function BAGS:GetVendorProgress()
    local item = BAGS.SellFrame.Info.items[1]
    if not item then
        return nil, true
    end -- Nothing more to sell

    local bag, slot, itemPrice, link = unpack(item)
    local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
    local stackPrice = (itemPrice or 0) * stackCount
    UseContainerItem(bag, slot)

    t_remove(BAGS.SellFrame.Info.items, 1)

    return stackPrice
end

function BAGS:CreateSellFrame()
    local frame = CreateFrame("Frame", "LumVendorGraysFrame", _G.UIParent)
    frame:SetSize(200, 16)
    frame:SetPoint("CENTER", _G.UIParent, 0, 200)
    E:SetBackdrop(frame, E.SCREEN_SCALE * 3)

    frame.statusbar = E:CreateStatusBar(frame, "LumVendorGraysFrameStatusBar")
    frame.statusbar:SetSize(200, 20)
    frame.statusbar:SetAllPoints()
    frame.statusbar:SetStatusBarColor(E:GetRGB(C.db.global.colors.dark_red))

    frame.statusbar.Title = E:CreateString(frame)
    frame.statusbar.Title:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 1, 4)
    frame.statusbar.Title:SetText(L["VENDORING_GRAYS"])

    frame.Info = {
        progressTimer = 0,
        progressMax = 0,
        sellInterval = 0.2,
        goldGained = 0,
        itemsSold = 0,
        items = {}
    }

    frame:SetScript("OnUpdate", frame_OnUpdate)
    frame:Hide()

    self.SellFrame = frame
end

function BAGS:GetGraysValue()
    local value = 0

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemID = GetContainerItemID(bag, slot)
            if itemID then
                local _, _, rarity, _, _, itype, _, _, _, _, itemPrice = GetItemInfo(itemID)
                if itemPrice then
                    local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
                    local stackPrice = itemPrice * stackCount
                    if rarity and rarity == 0 and (itype and itype ~= "Quest") and (stackPrice > 0) then
                        value = value + stackPrice
                    end
                end
            end
        end
    end

    return value
end

function BAGS:VendorGrays()
    if BAGS.SellFrame:IsShown() then
        return
    end

    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local itemID = GetContainerItemID(bag, slot)
            if itemID then
                local _, link, rarity, _, _, itype, _, _, _, _, itemPrice = GetItemInfo(itemID)

                if rarity and rarity == 0 and (itype and itype ~= "Quest") and (itemPrice and itemPrice > 0) then
                    t_insert(BAGS.SellFrame.Info.items, {bag, slot, itemPrice, link})
                end
            end
        end
    end

    local itemCount = t_maxn(BAGS.SellFrame.Info.items)

    if not BAGS.SellFrame.Info.items then
        return
    end
    if itemCount < 1 then
        return
    end

    BAGS.SellFrame.Info.progressTimer = 0
    BAGS.SellFrame.Info.sellInterval = 0.2
    BAGS.SellFrame.Info.progressMax = itemCount
    BAGS.SellFrame.Info.goldGained = 0
    BAGS.SellFrame.Info.itemsSold = 0

    BAGS.SellFrame.statusbar:SetMinMaxValues(0, itemCount)
    BAGS.SellFrame.statusbar:SetValue(0)
    BAGS.SellFrame.statusbar.Text:SetText("0 / " .. itemCount)

    BAGS.SellFrame:Show()
end
