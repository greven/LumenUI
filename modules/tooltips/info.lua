-- Tooltip Info: SpellID, AuraID, ItemInfo...
local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Tooltips")

local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local type = _G.type

-- Blizz
local C_ArtifactUI = _G.C_ArtifactUI
local C_TradeSkillUI = _G.C_TradeSkillUI
local C_CurrencyInfo = _G.C_CurrencyInfo
local IsShiftKeyDown = _G.IsShiftKeyDown
local UnitName = _G.UnitName
local UnitAura = _G.UnitAura
local GetItemCount = _G.GetItemCount
local GetLootSlotLink = _G.GetLootSlotLink
local GetLootRollItemLink = _G.GetLootRollItemLink
local GetMerchantItemLink = _G.GetMerchantItemLink
local GetLFGDungeonRewardLink = _G.GetLFGDungeonRewardLink
local GetLFGDungeonShortageRewardLink = _G.GetLFGDungeonShortageRewardLink

-- ---------------

local ID = "|cffffd100" .. _G.ID .. ":|r %d"
local TOTAL = "|cffffd100" .. _G.TOTAL .. ":|r %d"

local function addSpellInfo(tooltip, id, caster)
    if not (id and C.db.profile.modules.tooltips.id) then
        return
    end

    local name = tooltip:GetName()
    local textLeft = ID:format(id)

    for i = 1, tooltip:NumLines() do
        local text = _G[name .. "TextLeft" .. i]:GetText()

        if text and text:match(textLeft) then
            return
        end
    end

    tooltip:AddLine(" ")

    if caster and type(caster) == "string" then
        tooltip:AddDoubleLine(textLeft, UnitName(caster), 1, 1, 1, E:GetRGB(E:GetUnitColor(caster, true, true)))
    else
        tooltip:AddLine(textLeft, 1, 1, 1)
    end

    tooltip:Show()
end

local function addGenericInfo(tooltip, id)
    if not (id and C.db.profile.modules.tooltips.id) then
        return
    end

    local name = tooltip:GetName()
    local textLeft = ID:format(id)

    for i = 2, tooltip:NumLines() do
        local text = _G[name .. "TextLeft" .. i]:GetText()

        if text and text:match(textLeft) then
            return
        end
    end

    tooltip:AddLine(" ")
    tooltip:AddLine(textLeft, 1, 1, 1)
    tooltip:Show()
end

local function addItemInfo(tooltip, id, showQuantity)
    if not id then
        return
    end

    local name = tooltip:GetName()
    local textLeft, textRight

    if C.db.profile.modules.tooltips.id then
        textLeft = ID:format(id)

        for i = 2, tooltip:NumLines() do
            local text = _G[name .. "TextLeft" .. i]:GetText()

            if text and text:match(textLeft) then
                return
            end
        end
    end

    if showQuantity and C.db.profile.modules.tooltips.count then
        textRight = TOTAL:format(GetItemCount(id, true))

        for i = 2, tooltip:NumLines() do
            local text = _G[name .. "TextRight" .. i]:GetText()

            if text and text:match(textRight) then
                return
            end
        end
    end

    if textLeft or textRight then
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(textLeft or " ", textRight or " ", 1, 1, 1, 1, 1, 1)
        tooltip:Show()
    end
end

local function validateLink(link)
    if not link then
        return
    end

    link = link:match("|H(.+)|h.+|h") or link

    if link:match("^%w+:(%d+)") then
        return link
    end

    return
end

local function handleLink(tooltip, link, showExtraInfo)
    link = validateLink(link)

    if not link then
        return
    end

    local linkType, id = link:match("^(%w+):(%d+)")

    if linkType == "item" then
        addItemInfo(tooltip, id, showExtraInfo)
    else
        addGenericInfo(tooltip, id)
    end
end

local function tooltip_SetUnitAura(self, unit, index, filter)
    if self:IsForbidden() then
        return
    end

    local config = C.db.profile.modules.tooltips
    local isShiftKeyDown = IsShiftKeyDown()
    local _, _, _, _, _, _, caster, _, _, id = UnitAura(unit, index, filter)

    if config.aura_id == "ON_SHIFT_DOWN" and isShiftKeyDown then
        addSpellInfo(self, id, caster)
    elseif config.aura_id == "SHOW" then
        addSpellInfo(self, id, caster)
    end
end

local function tooltip_SetSpell(self)
    if self:IsForbidden() then
        return
    end

    local config = C.db.profile.modules.tooltips
    local isShiftKeyDown = IsShiftKeyDown()
    local _, id = self:GetSpell()

    if config.spell_id == "ON_SHIFT_DOWN" and isShiftKeyDown then
        addSpellInfo(self, id)
    elseif config.spell_id == "SHOW" then
        addSpellInfo(self, id)
    end
end

local function tooltip_SetArtifactPowerByID(self, powerID)
    if self:IsForbidden() then
        return
    end

    local info = C_ArtifactUI.GetPowerInfo(powerID)

    addSpellInfo(self, info.spellID)
end

local function tooltip_SetLoot(self, index)
    if self:IsForbidden() then
        return
    end

    local link = GetLootSlotLink(index)

    handleLink(self, link, true)
end

local function tooltip_SetLootRollItem(self, rollID)
    if self:IsForbidden() then
        return
    end

    local link = GetLootRollItemLink(rollID)

    handleLink(self, link, true)
end

local function tooltip_SetMerchantItem(self, index)
    if self:IsForbidden() then
        return
    end

    local link = GetMerchantItemLink(index)

    handleLink(self, link, true)
end

local function tooltip_SetRecipeReagentItem(self, recipeID, reagentIndex)
    if self:IsForbidden() then
        return
    end

    local link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex)

    handleLink(self, link, true)
end

local function tooltip_SetBackpackToken(self, index)
    if self:IsForbidden() then
        return
    end

    local info = C_CurrencyInfo.GetBackpackCurrencyInfo(index)

    addGenericInfo(self, info.currencyTypesID)
end

local function tooltip_SetCurrencyToken(self, index)
    if self:IsForbidden() then
        return
    end

    local link = C_CurrencyInfo.GetCurrencyListLink(index)

    handleLink(self, link)
end

local function tooltip_SetQuest(self)
    if self:IsForbidden() then
        return
    end

    if not (self.questID and GameTooltip:IsOwned(self)) then
        return
    end

    addGenericInfo(GameTooltip, self.questID)
end

local function tooltip_SetHyperlink(self, link)
    if self:IsForbidden() then
        return
    end

    handleLink(self, link, true)
end

local function tooltip_SetSpellOrItem(self)
    if self:IsForbidden() then
        return
    end

    local _, linkOrId = self:GetSpell()

    if linkOrId then
        addSpellInfo(self, linkOrId)
    else
        _, linkOrId = self:GetItem()

        handleLink(self, linkOrId, true)
    end
end

local function tooltip_SetLFGDungeonReward(self, dungeonID, rewardID)
    if self:IsForbidden() then
        return
    end

    local link = GetLFGDungeonRewardLink(dungeonID, rewardID)

    handleLink(self, link)
end

local function tooltip_SetLFGDungeonShortageReward(self, dungeonID, rewardArg, rewardID)
    if self:IsForbidden() then
        return
    end

    local link = GetLFGDungeonShortageRewardLink(dungeonID, rewardArg, rewardID)

    handleLink(self, link)
end

local function tooltip_SetItem(self)
    if self:IsForbidden() then
        return
    end

    local _, link = self:GetItem()

    handleLink(self, link, true)
end

function M:SetupTooltipInfo()
    if not M:IsInit() then
        -- Spells
        GameTooltip:HookScript("OnTooltipSetSpell", tooltip_SetSpell)
        hooksecurefunc(GameTooltip, "SetUnitAura", tooltip_SetUnitAura)
        hooksecurefunc(GameTooltip, "SetUnitBuff", tooltip_SetUnitAura)
        hooksecurefunc(GameTooltip, "SetUnitDebuff", tooltip_SetUnitAura)
        hooksecurefunc(GameTooltip, "SetArtifactPowerByID", tooltip_SetArtifactPowerByID)

        -- Items
        GameTooltip:HookScript("OnTooltipSetItem", tooltip_SetItem)
        hooksecurefunc(GameTooltip, "SetLootItem", tooltip_SetLoot)
        hooksecurefunc(GameTooltip, "SetLootRollItem", tooltip_SetLootRollItem)
        hooksecurefunc(GameTooltip, "SetMerchantItem", tooltip_SetMerchantItem)
        hooksecurefunc(GameTooltip, "SetRecipeReagentItem", tooltip_SetRecipeReagentItem)
        hooksecurefunc(GameTooltip, "SetToyByItemID", addItemInfo)

        -- Currencies
        hooksecurefunc(GameTooltip, "SetBackpackToken", tooltip_SetBackpackToken)
        hooksecurefunc(GameTooltip, "SetCurrencyToken", tooltip_SetCurrencyToken)
        hooksecurefunc(GameTooltip, "SetCurrencyByID", addGenericInfo)
        hooksecurefunc(GameTooltip, "SetCurrencyTokenByID", addGenericInfo)
        hooksecurefunc(GameTooltip, "SetLootCurrency", tooltip_SetLoot)

        -- Quests
        hooksecurefunc("QuestMapLogTitleButton_OnEnter", tooltip_SetQuest)

        -- Other
        hooksecurefunc(GameTooltip, "SetHyperlink", tooltip_SetHyperlink)
        hooksecurefunc(ItemRefTooltip, "SetHyperlink", tooltip_SetHyperlink)
        hooksecurefunc(GameTooltip, "SetAction", tooltip_SetSpellOrItem)
        hooksecurefunc(GameTooltip, "SetRecipeResultItem", tooltip_SetSpellOrItem)
        hooksecurefunc(GameTooltip, "SetLFGDungeonReward", tooltip_SetLFGDungeonReward)
        hooksecurefunc(GameTooltip, "SetLFGDungeonShortageReward", tooltip_SetLFGDungeonShortageReward)
    end
end
