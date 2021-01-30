local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Tooltips")

local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next
local pairs = _G.pairs
local s_format = _G.string.format
local s_upper = _G.string.upper
local type = _G.type

-- Blizz
local C_ArtifactUI = _G.C_ArtifactUI
local C_CurrencyInfo = _G.C_CurrencyInfo
local C_PetJournal = _G.C_PetJournal
local C_Timer = _G.C_Timer
local C_TradeSkillUI = _G.C_TradeSkillUI
local GetGuildInfo = _G.GetGuildInfo
local GetItemCount = _G.GetItemCount
local GetItemInfo = _G.GetItemInfo
local GetItem = _G.GetItem
local GetLFGDungeonRewardLink = _G.GetLFGDungeonRewardLink
local GetLFGDungeonShortageRewardLink = _G.GetLFGDungeonShortageRewardLink
local GetLootRollItemLink = _G.GetLootRollItemLink
local GetLootSlotLink = _G.GetLootSlotLink
local GetMerchantItemLink = _G.GetMerchantItemLink
local GetMouseFocus = _G.GetMouseFocus
local GetTime = _G.GetTime
local IsShiftKeyDown = _G.IsShiftKeyDown
local ItemRefTooltip = _G.ItemRefTooltip
local NotifyInspect = _G.NotifyInspect
local ShowBossFrameWhenUninteractable = _G.ShowBossFrameWhenUninteractable
local UnitAura = _G.UnitAura
local UnitBattlePetLevel = _G.UnitBattlePetLevel
local UnitBattlePetType = _G.UnitBattlePetType
local UnitClass = _G.UnitClass
local UnitCreatureType = _G.UnitCreatureType
local UnitEffectiveLevel = _G.UnitEffectiveLevel
local UnitExists = _G.UnitExists
local UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned
local UnitGUID = _G.UnitGUID
local UnitInParty = _G.UnitInParty
local UnitInRaid = _G.UnitInRaid
local UnitIsAFK = _G.UnitIsAFK
local UnitIsBattlePetCompanion = _G.UnitIsBattlePetCompanion
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDND = _G.UnitIsDND
local UnitIsGroupLeader = _G.UnitIsGroupLeader
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsQuestBoss = _G.UnitIsQuestBoss
local UnitIsWildBattlePet = _G.UnitIsWildBattlePet
local UnitLevel = _G.UnitLevel
local UnitName = _G.UnitName
local UnitPhaseReason = _G.UnitPhaseReason
local UnitPVPName = _G.UnitPVPName
local UnitRace = _G.UnitRace
local UnitRealmRelationship = _G.UnitRealmRelationship

-- ---------------

local isInit = false

local tooltipsTable = {}
local tooltips = {
    ChatMenu, EmoteMenu, LanguageMenu, VoiceMacroMenu, GameTooltip,
    EmbeddedItemTooltip, ItemRefTooltip, ItemRefShoppingTooltip1,
    ItemRefShoppingTooltip2, ShoppingTooltip1, ShoppingTooltip2,
    AutoCompleteBox, FriendsTooltip, QuestScrollFrame.StoryTooltip,
    QuestScrollFrame.CampaignTooltip, GeneralDockManagerOverflowButtonList,
    ReputationParagonTooltip, NamePlateTooltip, QueueStatusFrame,
    FloatingGarrisonFollowerTooltip, FloatingGarrisonFollowerAbilityTooltip,
    FloatingGarrisonMissionTooltip, GarrisonFollowerAbilityTooltip,
    GarrisonFollowerTooltip, FloatingGarrisonShipyardFollowerTooltip,
    GarrisonShipyardFollowerTooltip, BattlePetTooltip,
    PetBattlePrimaryAbilityTooltip, PetBattlePrimaryUnitTooltip,
    FloatingBattlePetTooltip, FloatingPetBattleAbilityTooltip,
    IMECandidatesFrame, QuickKeybindTooltip
}

local AFK = "[" .. _G.AFK .. "] "
local DND = "[" .. _G.DND .. "] "
local GUILD_TEMPLATE = _G.GUILD_TEMPLATE:format("|c%s%s", "|r%s")
local ID = "|cffffd100" .. _G.ID .. ":|r %d"
local TARGET = "|cffffd100" .. _G.TARGET .. ":|r %s"
local TOTAL = "|cffffd100" .. _G.TOTAL .. ":|r %d"
local PLAYER_TEMPLATE = "|c%s%s|r (|c%s" .. _G.PLAYER .. "|r)"

local TEXTS_TO_REMOVE = {
    [_G.FACTION_ALLIANCE] = true,
    [_G.FACTION_HORDE] = true,
    [_G.PVP] = true
}

local function reskinDropdown()
    for _, name in pairs({"DropDownList", "L_DropDownList", "Lib_DropDownList"}) do
        for i = 1, UIDROPDOWNMENU_MAXLEVELS do
            local menu = _G[name .. i .. "MenuBackdrop"]
            if menu and not menu.styled then
                menu:HookScript("OnShow", M.ReskinTooltip)
                menu.styled = true
            end
        end
    end
end

-- Moves trash lines to the bottom
local function cleanUp(tooltip)
    local num = tooltip:NumLines()

    if not num or num <= 1 then return end

    for i = num, 2, -1 do
        local line = _G["GameTooltipTextLeft" .. i]
        local text = line:GetText()

        if TEXTS_TO_REMOVE[text] then
            for j = i, num do
                local curLine = _G["GameTooltipTextLeft" .. j]
                local nextLine = _G["GameTooltipTextLeft" .. (j + 1)]

                if nextLine:IsShown() then
                    curLine:SetText(nextLine:GetText())
                    curLine:SetTextColor(nextLine:GetTextColor())
                else
                    curLine:Hide()
                end
            end
        end
    end
end

local function getLineByText(tooltip, text, offset)
    for i = offset, tooltip:NumLines() do
        local line = _G["GameTooltipTextLeft" .. i]
        local lineText = line:GetText()

        if lineText and lineText:match(text) then return line end
    end

    return nil
end

local function getTooltipUnit(tooltip)
    local _, unit = tooltip:GetUnit()

    if not unit then
        local frameID = GetMouseFocus()

        if frameID and frameID.GetAttribute then
            unit = frameID:GetAttribute("unit")
        end

        if unit and
            not (UnitExists(unit) or ShowBossFrameWhenUninteractable(unit)) then
            unit = nil
        end
    end

    return unit
end

local function tooltip_SetUnit(self)
    if self:IsForbidden() then return end

    local unit = getTooltipUnit(self)
    if not unit then return end

    local nameColor = E:GetUnitColor(unit, nil, true)
    local scaledLevel = UnitEffectiveLevel(unit)
    local difficultyColor = E:GetCreatureDifficultyColor(scaledLevel)
    local isPVPReady, pvpFaction = E:GetUnitPVPStatus(unit)
    local isShiftKeyDown = IsShiftKeyDown()
    local lineOffset = 2

    if UnitIsPlayer(unit) then
        local name, realm = UnitName(unit)
        name = C.modules.tooltips.title and UnitPVPName(unit) or name

        if realm and realm ~= "" then
            if isShiftKeyDown then
                name = s_format("%s|c%s-%s|r", name, C.colors.gray.hex, realm)
            elseif UnitRealmRelationship(unit) ~= LE_REALM_RELATION_VIRTUAL then
                name = name .. L["FOREIGN_SERVER_LABEL"]
            end
        end

        GameTooltipTextLeft1:SetFormattedText("|c%s%s|r|c%s%s|r",
                                              C.colors.gray.hex,
                                              UnitIsAFK(unit) and AFK or
                                                  UnitIsDND(unit) and DND or "",
                                              nameColor.hex, name)

        -- Status
        local status = ""

        -- GameTooltipTextRight1:SetText(C.media.textures.icons_inline["SHEEP"]:format(16, 16))
        local size = GameTooltipTextRight1:GetStringHeight()
        size = 16 * 16 / size

        if UnitInParty(unit) or UnitInRaid(unit) then
            if UnitIsGroupLeader(unit) then
                -- status = status .. C.media.textures.icons_inline["LEADER"]:format(size, size)
            end

            local role = UnitGroupRolesAssigned(unit)
            if role and role ~= "NONE" then
                -- status = status .. C.media.textures.icons_inline[role]:format(size, size)
            end
        end

        if UnitIsPlayer(unit) and UnitIsConnected(unit) and
            UnitPhaseReason(unit) then
            -- status = status .. PHASE_ICONS[UnitPhaseReason(unit)]:format(size, size)
        end

        if isPVPReady then
            -- status = status .. C.media.textures.icons_inline[s_upper(pvpFaction)]:format(size, size)
        end

        if status ~= "" then
            GameTooltipTextRight1:SetText(status)
            GameTooltipTextRight1:Show()
        else
            GameTooltipTextRight1:SetText(nil)
        end

        -- Guild info
        local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
        if guildName then
            lineOffset = 3

            if isShiftKeyDown then
                if guildRealm then
                    guildName = s_format("%s|c%s-%s|r", guildName,
                                         C.colors.gray.hex, guildRealm)
                end

                if guildRankName then
                    guildName = GUILD_TEMPLATE:format(C.colors.gray.hex,
                                                      guildRankName, guildName)
                end
            end

            GameTooltipTextLeft2:SetText(
                E:WrapText(C.colors.light_cyan, guildName))
        end

        local levelLine = getLineByText(self,
                                        scaledLevel > 0 and scaledLevel or
                                            "%?%?", lineOffset)
        if levelLine then
            local level = UnitLevel(unit)
            local classColor = E:GetUnitClassColor(unit)

            levelLine:SetFormattedText("|c%s%s|r %s |c%s%s|r",
                                       difficultyColor.hex, scaledLevel > 0 and
                                           (scaledLevel ~= level and scaledLevel ..
                                               " (" .. level .. ")" or
                                               scaledLevel) or "??",
                                       UnitRace(unit), classColor.hex,
                                       UnitClass(unit))

            if C.modules.tooltips.inspect and isShiftKeyDown and level > 10 then
                M:AddInspectInfo(self, unit, 0)
            end
        end
    elseif UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
        GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", nameColor.hex,
                                              UnitName(unit) or L["UNKNOWN"])

        scaledLevel = UnitBattlePetLevel(unit)

        local levelLine = getLineByText(self,
                                        scaledLevel > 0 and scaledLevel or
                                            "%?%?", lineOffset)
        if levelLine then
            local petType = _G["BATTLE_PET_NAME_" .. UnitBattlePetType(unit)]

            local teamLevel = C_PetJournal.GetPetTeamAverageLevel()
            if teamLevel then
                difficultyColor = E:GetRelativeDifficultyColor(teamLevel,
                                                               scaledLevel)
            else
                difficultyColor = E:GetCreatureDifficultyColor(scaledLevel)
            end

            levelLine:SetFormattedText("|c%s%s|r %s", difficultyColor.hex,
                                       scaledLevel > 0 and scaledLevel or "??",
                                       (UnitCreatureType(unit) or L["PET"]) ..
                                           (petType and ", " .. petType or ""))
        end
    else
        GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", nameColor.hex,
                                              UnitName(unit) or L["UNKNOWN"])

        -- status
        local status = ""

        -- TODO: Icon
        -- GameTooltipTextRight1:SetText(C.media.textures.icons_inline["SHEEP"]:format(16, 16))
        local size = GameTooltipTextRight1:GetStringHeight()
        size = 16 * 16 / size

        if UnitIsQuestBoss(unit) then
            -- TODO: Icon
            -- status = status .. s_format(C.media.textures.icons_inline["QUEST"], size, size)
        end

        if isPVPReady then
            -- TODO: Icon
            -- status = status .. s_format(C.media.textures.icons_inline[s_upper(pvpFaction)], size, size)
        end

        if status ~= "" then
            GameTooltipTextRight1:SetText(status)
            GameTooltipTextRight1:Show()
        else
            GameTooltipTextRight1:SetText(nil)
        end

        local levelLine = getLineByText(self,
                                        scaledLevel > 0 and scaledLevel or
                                            "%?%?", lineOffset)
        if levelLine then
            local level = UnitLevel(unit)

            levelLine:SetFormattedText("|c%s%s%s|r %s", difficultyColor.hex,
                                       scaledLevel > 0 and
                                           (scaledLevel ~= level and scaledLevel ..
                                               " (" .. level .. ")" or
                                               scaledLevel) or "??",
                                       E:GetUnitClassification(unit),
                                       UnitCreatureType(unit) or "")
        end
    end

    -- Show Target info
    if C.modules.tooltips.target then
        local unitTarget = unit .. "target"
        if UnitExists(unitTarget) then
            local name = UnitName(unitTarget)

            if UnitIsPlayer(unitTarget) and name == E.PLAYER_NAME then
                name = E:WrapText(C.colors.red, s_upper(L["YOU"]) .. "!")
            elseif UnitIsPlayer(unitTarget) then
                name = PLAYER_TEMPLATE:format(
                           E:GetUnitClassColor(unitTarget).hex, name,
                           E:GetUnitReactionColor(unitTarget).hex)
            else
                name = s_format("|c%s%s|r",
                                E:GetUnitColor(unitTarget, nil, true).hex, name)
            end

            self:AddLine(TARGET:format(name), 1, 1, 1)
        end
    end

    -- Border color
    if C.modules.tooltips.border.color_class and UnitIsPlayer(unit) then
        self.bg:SetBackdropBorderColor(E:GetRGB(E:GetUnitClassColor(unit)))
    end

    -- Statusbar color
    if C.modules.tooltips.statusbar.color_class and UnitIsPlayer(unit) then
        self.StatusBar:SetStatusBarColor(E:GetRGB(E:GetUnitClassColor(unit)))
    end

    cleanUp(self)

    self:Show()
end

local function tooltipBar_Hook(self)
    if self:IsForbidden() or self:GetParent():IsForbidden() then return end

    local _, max = self:GetMinMaxValues()
    if max == 1 then
        self.Text:Hide()
    else
        local value = self:GetValue()

        self.Text:Show()
        self.Text:SetFormattedText("%s / %s", E:FormatNumber(value),
                                   E:FormatNumber(max))

        self:GetParent():SetMinimumWidth(self.Text:GetStringWidth() + 32)
    end

    self:SetStatusBarColor(E:GetRGB(C.colors.health))
end

local function tooltip_Hook(self) M:ReskinTooltip(self) end

local function tooltip_SetDefaultAnchor(self, parent)
    if self:IsForbidden() then return end
    if self:GetAnchorType() ~= "ANCHOR_NONE" then return end

    if parent then
        if C.modules.tooltips.anchor_cursor then
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

local function tooltip_SetSharedBackdropStyle(self)
    if not self.styled then return end
    self:SetBackdrop(nil)
end

function M:ReskinStatusBar(self)
    local config = C.modules.tooltips

    E:HandleStatusBar(self.StatusBar)
    E:SetStatusBarSkin(self.StatusBar, C.media.textures.statusbar)
    self.StatusBar:ClearAllPoints()
    self.StatusBar:SetPoint("BOTTOMLEFT", self.bg, "TOPLEFT", 0, 3)
    self.StatusBar:SetPoint("BOTTOMRIGHT", self.bg, "TOPRIGHT", 0, 3)
    self.StatusBar:SetHeight(5)
    E:SetBackdrop(self.StatusBar, nil, config.alpha)
end

function M:ReskinTooltip(self)
    if self:IsForbidden() then return end
    local config = C.modules.tooltips

    self:SetScale(config.scale)

    if not self.styled then
        E:HandleBackdrop(self, nil, config.alpha, C.global.backdrop.color, {
            bgFile = C.media.textures.flat,
            edgeFile = C.media.textures.backdrop_border,
            edgeSize = 8,
            tile = false
        })

        if self.StatusBar then M:ReskinStatusBar(self) end

        if self.GetBackdrop then
            self.GetBackdrop = self.bg.GetBackdrop
            self.GetBackdropColor = self.bg.GetBackdropColor
            self.GetBackdropBorderColor = self.bg.GetBackdropBorderColor
        end

        self.styled = true
    end

    self.bg:SetBackdropBorderColor(E:GetRGB(C.global.border.color))
    if config.border.color_quality and self.GetItem then
        local _, item = self:GetItem()

        if item then
            local quality = select(3, GetItemInfo(item))
            local color = C.colors.quality[quality or 1]

            if color then
                self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
            end
        end
    end
end

function M.IsInit() return isInit end

function M:Init()
    local config = C.modules.tooltips

    if not isInit and config.enabled then
        GameTooltip.StatusBar = GameTooltipStatusBar

        M:ReskinTooltip(GameTooltip)

        -- Style tooltips
        for _, tt in pairs(tooltips) do
            tt:HookScript("OnShow", tooltip_Hook)
        end

        -- GameTooltip:HookScript("OnTooltipCleared", tooltip_OnTooltipCleared)

        -- Anchor
        local point = config.point
        local anchor = CreateFrame("Frame", "LumTooltipAnchor", _G.UIParent)
        anchor:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
        anchor:SetSize(64, 64)
        hooksecurefunc("GameTooltip_SetDefaultAnchor", tooltip_SetDefaultAnchor)
        -- E.Movers:Create(anchor)

        -- Backdrop
        hooksecurefunc("SharedTooltip_SetBackdropStyle",
                       tooltip_SetSharedBackdropStyle)

        -- Statusbar
        GameTooltipStatusBar:HookScript("OnShow", tooltipBar_Hook)
        GameTooltipStatusBar:HookScript("OnValueChanged", tooltipBar_Hook)

        -- Units
        GameTooltip:HookScript("OnTooltipSetUnit", tooltip_SetUnit)

        -- Other
        hooksecurefunc("UIDropDownMenu_CreateFrames", reskinDropdown)

        -- Elements
        -- M:SetupTooltipFonts()

        isInit = true

        self:Update()
    end
end

function M.Update()
    if isInit then
        -- local config = C.modules.tooltips
    end
end
