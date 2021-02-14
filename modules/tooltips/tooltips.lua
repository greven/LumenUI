local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

local TOOLTIPS = E:AddModule("Tooltips")

local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local pairs = _G.pairs

-- Blizz
local GetItemInfo = _G.GetItemInfo
local GetItem = _G.GetItem
local ItemRefTooltip = _G.ItemRefTooltip
local IsShiftKeyDown = _G.IsShiftKeyDown

-- ---------------

local isInit = false

TOOLTIPS.Tooltips = {
    ChatMenu,
    EmoteMenu,
    LanguageMenu,
    VoiceMacroMenu,
    GameTooltip,
    EmbeddedItemTooltip,
    ItemRefTooltip,
    ItemRefShoppingTooltip1,
    ItemRefShoppingTooltip2,
    ShoppingTooltip1,
    ShoppingTooltip2,
    AutoCompleteBox,
    FriendsTooltip,
    QuestScrollFrame.StoryTooltip,
    QuestScrollFrame.CampaignTooltip,
    GeneralDockManagerOverflowButtonList,
    ReputationParagonTooltip,
    NamePlateTooltip,
    QueueStatusFrame,
    FloatingGarrisonFollowerTooltip,
    FloatingGarrisonFollowerAbilityTooltip,
    FloatingGarrisonMissionTooltip,
    GarrisonFollowerAbilityTooltip,
    GarrisonFollowerTooltip,
    FloatingGarrisonShipyardFollowerTooltip,
    GarrisonShipyardFollowerTooltip,
    BattlePetTooltip,
    PetBattlePrimaryAbilityTooltip,
    PetBattlePrimaryUnitTooltip,
    FloatingBattlePetTooltip,
    FloatingPetBattleAbilityTooltip,
    IMECandidatesFrame,
    QuickKeybindTooltip
}

local function updateFont(fontString, size, outline, shadow)
    fontString:SetFont(M.fonts.normal, size, outline and "THINOUTLINE" or nil)

    if shadow then
        fontString:SetShadowOffset(1, -1)
        fontString:SetShadowColor(0, 0, 0, 0)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

local function reskinDropdown()
    for _, name in pairs({"DropDownList", "L_DropDownList", "Lib_DropDownList"}) do
        for i = 1, UIDROPDOWNMENU_MAXLEVELS do
            local menu = _G[name .. i .. "MenuBackdrop"]
            if menu and not menu.styled then
                menu:HookScript("OnShow", TOOLTIPS.ReskinTooltip)
            end
        end
    end
end

local function tooltipBar_Hook(self)
    if self:IsForbidden() or self:GetParent():IsForbidden() then
        return
    end
    local config = C.db.profile.modules.tooltips

    if self:IsShown() then
        if self.Text and (config.health.text.show or IsShiftKeyDown()) then
            local _, max = self:GetMinMaxValues()
            if max == 1 then
                self.Text:Hide()
            else
                local value = self:GetValue()

                self.Text:Show()
                self.Text:SetFormattedText("%s / %s", E:FormatNumber(value), E:FormatNumber(max))

                self:GetParent():SetMinimumWidth(self.Text:GetStringWidth() + 32)
            end
        else
            if self.Text then
                self.Text:Hide()
            end
        end

        TOOLTIPS:UpdateStatusBarColor(self)
        GameTooltip:SetPadding(0, 0, 0, config.health.height)
    end
end

local function tooltip_Hook(self)
    TOOLTIPS.ReskinTooltip(self)
end

local function tooltip_SetDefaultAnchor(self, parent)
    if self:IsForbidden() then
        return
    end
    if self:GetAnchorType() ~= "ANCHOR_NONE" then
        return
    end

    if parent then
        if C.db.profile.modules.tooltips.anchor_cursor then
            self:SetOwner(parent, "ANCHOR_CURSOR")
            return
        else
            self:SetOwner(parent, "ANCHOR_NONE")
        end
    end

    local _, anchor = self:GetPoint()
    if not anchor or anchor == UIParent or anchor == LumTooltipAnchor then
        local quadrant = E:GetScreenQuadrant(LumTooltipAnchor)
        local p = "BOTTOMRIGHT"

        if quadrant == "TOPRIGHT" or quadrant == "TOP" then
            p = "TOPRIGHT"
        elseif quadrant == "BOTTOMLEFT" or quadrant == "LEFT" then
            p = "BOTTOMLEFT"
        elseif quadrant == "TOPLEFT" then
            p = "TOPLEFT"
        end

        self:ClearAllPoints()
        self:SetPoint(p, "LumTooltipAnchor", p, 0, 0)
    end
end

local function tooltip_OnTooltipCleared(self)
    if not self.tooltipCleared then
        self:SetPadding(0, 0, 0, 0)
        self.tooltipCleared = true
    end
end

local function tooltip_SetSharedBackdropStyle(self)
    if not self.styled then
        return
    end
    self:SetBackdrop(nil)
end

function TOOLTIPS:StyleTooltips()
    for _, tt in pairs(TOOLTIPS.Tooltips) do
        tt:HookScript("OnShow", tooltip_Hook)
    end
    hooksecurefunc("UIDropDownMenu_CreateFrames", reskinDropdown)
end

function TOOLTIPS:SetupTooltipFonts()
    local textSize = 12

    updateFont(GameTooltipHeaderText, textSize + 2, true, false)
    updateFont(GameTooltipText, textSize, true, false)
    updateFont(GameTooltipTextSmall, textSize - 1, true, false)

    if GameTooltip.hasMoney then
        for i = 1, GameTooltip.numMoneyFrames do
            updateFont(_G["GameTooltipMoneyFrame" .. i .. "PrefixText"], textSize)
            updateFont(_G["GameTooltipMoneyFrame" .. i .. "SuffixText"], textSize)
            updateFont(_G["GameTooltipMoneyFrame" .. i .. "GoldButtonText"], textSize)
            updateFont(_G["GameTooltipMoneyFrame" .. i .. "SilverButtonText"], textSize)
            updateFont(_G["GameTooltipMoneyFrame" .. i .. "CopperButtonText"], textSize)
        end
    end

    for _, tt in ipairs(GameTooltip.shoppingTooltips) do
        for i = 1, tt:GetNumRegions() do
            local region = select(i, tt:GetRegions())
            if region:IsObjectType("FontString") then
                updateFont(region, textSize)
            end
        end
    end
end

function TOOLTIPS:ReskinStatusBar(self)
    local config = C.db.profile.modules.tooltips
    local statusbar = self.StatusBar

    E:HandleStatusBar(statusbar)
    E:SetStatusBarSkin(statusbar, M.textures.statusbar)
    E:SetBackdrop(statusbar, E.SCREEN_SCALE * 1.5, config.alpha)
    statusbar:ClearAllPoints()
    statusbar:SetPoint("LEFT", 4, 0)
    statusbar:SetPoint("RIGHT", -4, 0)
    statusbar:SetPoint("TOP", 0, -4)
    statusbar:GetStatusBarTexture():SetVertTile(true)
    statusbar:SetHeight(config.health.height)

    if statusbar.Text then
        updateFont(statusbar.Text, config.health.text.size or 13, true, true)
    end
end

function TOOLTIPS:ReskinTooltip()
    if not self then
        return
    end
    if self:IsForbidden() then
        return
    end

    local config = C.db.profile.modules.tooltips
    self:SetScale(config.scale)

    if not self.styled then
        E:HandleBackdrop(
            self,
            nil,
            config.alpha,
            C.db.global.backdrop.color,
            {
                bgFile = M.textures.flat,
                edgeFile = M.textures.backdrop_border,
                edgeSize = C.db.profile.modules.tooltips.border.size,
                tile = false
            }
        )

        if self.StatusBar then
            TOOLTIPS:ReskinStatusBar(self)
        end

        if self.GetBackdrop then
            self.GetBackdrop = self.bg.GetBackdrop
            self.GetBackdropColor = self.bg.GetBackdropColor
            self.GetBackdropBorderColor = self.bg.GetBackdropBorderColor
        end

        self.styled = true
        self.tooltipCleared = false
    end

    if self.bg then
        self.bg:SetBackdropBorderColor(E:GetRGB(C.db.global.border.color))
        if config.border.color_quality and self.GetItem then
            local _, item = self:GetItem()

            if item then
                local quality = select(3, GetItemInfo(item))
                local color = C.db.global.colors.quality[quality or 1]

                if color then
                    self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
                end
            end
        end
    end
end

function TOOLTIPS.IsInit()
    return isInit
end

function TOOLTIPS:Init()
    local config = C.db.profile.modules.tooltips

    if not isInit and config.enabled then
        GameTooltip.StatusBar = GameTooltipStatusBar

        TOOLTIPS:StyleTooltips()
        GameTooltip:HookScript("OnTooltipCleared", tooltip_OnTooltipCleared)

        -- Anchor
        local point = config.point
        local anchor = CreateFrame("Frame", "LumTooltipAnchor", _G.UIParent)
        anchor:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
        anchor:SetSize(64, 64)
        hooksecurefunc("GameTooltip_SetDefaultAnchor", tooltip_SetDefaultAnchor)
        -- E.Movers:Create(anchor)

        -- Backdrop
        hooksecurefunc("SharedTooltip_SetBackdropStyle", tooltip_SetSharedBackdropStyle)

        -- Statusbar
        GameTooltipStatusBar:HookScript("OnShow", tooltipBar_Hook)
        GameTooltipStatusBar:HookScript("OnValueChanged", tooltipBar_Hook)

        -- Elements
        TOOLTIPS:SetupTooltipFonts()
        TOOLTIPS:SetupTooltipInfo()
        TOOLTIPS:SetupUnitInfo()

        self:Update()

        isInit = true
    end
end

function TOOLTIPS.Update()
    if isInit then
        TOOLTIPS.ReskinTooltip(GameTooltip)
        GameTooltipStatusBar:SetHeight(C.db.profile.modules.tooltips.health.height)
    end
end
