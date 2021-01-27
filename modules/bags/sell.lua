local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Bags")

-- Lua
local _G = getfenv(0)

local unpack = _G.unpack
local select = _G.select
local t_insert = _G.table.insert
local t_remove = _G.table.remove
local t_maxn = _G.table.maxn
local s_format = _G.string.format

-- Blizzard
local GetItemInfo = _G.GetItemInfo
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetContainerItemInfo = _G.GetContainerItemInfo
local GetContainerItemID = _G.GetContainerItemID
local UseContainerItem = _G.UseContainerItem
local GetMoneyString = _G.GetMoneyString

-- ---------------

local config = C.modules.bags

local function frame_OnUpdate(self, elapsed)
    M.SellFrame.Info.progressTimer = M.SellFrame.Info.progressTimer - elapsed
    if M.SellFrame.Info.progressTimer > 0 then return end
    M.SellFrame.Info.progressTimer = M.SellFrame.Info.sellInterval

    local goldGained, lastItem = M:GetVendorProgress()
    if goldGained then

        M.SellFrame.Info.goldGained = M.SellFrame.Info.goldGained + goldGained
        M.SellFrame.Info.itemsSold = M.SellFrame.Info.itemsSold + 1
        M.SellFrame.statusbar:SetValue(M.SellFrame.Info.itemsSold)

        local timeLeft = (M.SellFrame.Info.progressMax -
                             M.SellFrame.Info.itemsSold) *
                             M.SellFrame.Info.sellInterval
        M.SellFrame.statusbar.Text:SetText(
            M.SellFrame.Info.itemsSold .. ' / ' .. M.SellFrame.Info.progressMax)
    elseif lastItem then
        M.SellFrame:Hide()

        if M.SellFrame.Info.goldGained > 0 then
            E:Print(s_format(L["SOLD_GRAY_ITEMS_FOR"],
                             GetMoneyString(M.SellFrame.Info.goldGained, true)))
        end
    end
end

function M:GetVendorProgress()
    local item = M.SellFrame.Info.items[1]
    if not item then return nil, true end -- Nothing more to sell

    local bag, slot, itemPrice, link = unpack(item)
    local stackCount = select(2, GetContainerItemInfo(bag, slot)) or 1
    local stackPrice = (itemPrice or 0) * stackCount
    UseContainerItem(bag, slot)

    t_remove(M.SellFrame.Info.items, 1)

    return stackPrice
end

function M:CreateSellFrame()
    local frame = CreateFrame("Frame", "LumenVendorGraysFrame", _G.UIParent)
    frame:SetSize(200, 16)
    frame:SetPoint("CENTER", _G.UIParent, 0, 200)
    E:SetBackdrop(frame, 2)

    frame.statusbar = E:CreateStatusBar(frame, "LumenVendorGraysFrameStatusBar")
    frame.statusbar:SetSize(200, 20)
    frame.statusbar:SetAllPoints()
    frame.statusbar:SetStatusBarColor(E:GetRGB(C.colors.dark_red))

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

    frame:SetScript('OnUpdate', frame_OnUpdate)
    frame:Hide()

    self.SellFrame = frame
end

function M:GetGraysValue()
    local value = 0

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemID = GetContainerItemID(bag, slot)
            if itemID then
                local _, _, rarity, _, _, itype, _, _, _, _, itemPrice =
                    GetItemInfo(itemID)
                if itemPrice then
                    local stackCount =
                        select(2, GetContainerItemInfo(bag, slot)) or 1
                    local stackPrice = itemPrice * stackCount
                    if rarity and rarity == 0 and (itype and itype ~= 'Quest') and
                        (stackPrice > 0) then
                        value = value + stackPrice
                    end
                end
            end
        end
    end

    return value
end

function M:VendorGrays()
    if M.SellFrame:IsShown() then return end

    for bag = 0, 4, 1 do
        for slot = 1, GetContainerNumSlots(bag), 1 do
            local itemID = GetContainerItemID(bag, slot)
            if itemID then
                local _, link, rarity, _, _, itype, _, _, _, _, itemPrice =
                    GetItemInfo(itemID)

                if rarity and rarity == 0 and (itype and itype ~= 'Quest') and
                    (itemPrice and itemPrice > 0) then
                    t_insert(M.SellFrame.Info.items,
                             {bag, slot, itemPrice, link})
                end

            end
        end
    end

    local itemCount = t_maxn(M.SellFrame.Info.items)

    if not M.SellFrame.Info.items then return end
    if itemCount < 1 then return end

    M.SellFrame.Info.progressTimer = 0
    M.SellFrame.Info.sellInterval = 0.2
    M.SellFrame.Info.progressMax = itemCount
    M.SellFrame.Info.goldGained = 0
    M.SellFrame.Info.itemsSold = 0

    M.SellFrame.statusbar:SetMinMaxValues(0, itemCount)
    M.SellFrame.statusbar:SetValue(0)
    M.SellFrame.statusbar.Text:SetText('0 / ' .. itemCount)

    M.SellFrame:Show()
end
