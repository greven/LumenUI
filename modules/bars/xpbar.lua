local _, ns = ...
local E, C = ns.E, ns.C

local M = E:GetModule("Bars")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local unpack = _G.unpack
local s_format = _G.string.format

-- Blizz
local C_ArtifactUI = _G.C_ArtifactUI
local C_AzeriteItem = _G.C_AzeriteItem
local C_PetBattles = _G.C_PetBattles
local C_PvP = _G.C_PvP
local C_QuestLog = _G.C_QuestLog
local C_Reputation = _G.C_Reputation

-- ---------------

local isInit = false
local barValueTemplate

local MAX_SEGMENTS = 4
local NAME_TEMPLATE = "|c%s%s|r"
local REPUTATION_TEMPLATE = "%s: |c%s%s|r"
local CUR_MAX_VALUE_TEMPLATE = "%s / %s"
local CUR_MAX_PERC_VALUE_TEMPLATE = "%s / %s (%.1f%%)"

local CFG = {
    visible = true,
    width = 594,
    height = 12,
    point = {p = "BOTTOM", anchor = "UIParent", ap = "BOTTOM", x = 0, y = 4},
    fade = {enabled = false}
}

local LAYOUT = {
    [1] = {[1] = {}},
    [2] = {[1] = {}, [2] = {}},
    [3] = {[1] = {}, [2] = {}, [3] = {}},
    [4] = {[1] = {}, [2] = {}, [3] = {}, [4] = {}}
}

local function bar_UpdateConfig(self)
    self._config = E:CopyTable(M:IsRestricted() and CFG or C.modules.bars.xpbar,
                               self._config)

    if M:IsRestricted() then
        self._config.text = E:CopyTable(C.modules.bars.xpbar.text,
                                        self._config.text)
    end

    self._config.text = E:CopyTable(C.global.fonts.bars, self._config.text)
end

local function updateFont(fontString, config)
    fontString:SetFont(C.global.fonts.bars.font, config.size,
                       config.outline and "THINOUTLINE" or nil)
    fontString:SetWordWrap(false)

    if config.shadow then
        fontString:SetShadowOffset(1, -1)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

local function bar_UpdateFont(self)
    for i = 1, MAX_SEGMENTS do updateFont(self[i].Text, self._config.text) end
end

local function bar_UpdateTextFormat(self)
    if self._config.text.format == "NUM" then
        barValueTemplate = CUR_MAX_VALUE_TEMPLATE
    elseif self._config.text.format == "NUM_PERC" then
        barValueTemplate = CUR_MAX_PERC_VALUE_TEMPLATE
    end
end

local function bar_UpdateTextVisibility(self)
    for i = 1, MAX_SEGMENTS do
        self[i]:LockText(self._config.text.visibility == 1)
    end
end

local function bar_UpdateSize(self, width, height)
    width = width or self._config.width
    height = height or self._config.height

    for i = 1, MAX_SEGMENTS do
        local layout = E:CalcSegmentsSizes(width, 2, i)

        for j = 1, i do LAYOUT[i][j].size = {layout[j], height} end
    end

    self:SetSize(width, height)

    -- if not M:IsRestricted() then E.Movers:Get(self):UpdateSize(width, height) end

    self._total = nil

    self:UpdateSegments()
end

local function bar_ForEach(self, method, ...)
    for i = 1, MAX_SEGMENTS do
        if self[i][method] then self[i][method](self[i], ...) end
    end
end

local function bar_Update(self)
    self:UpdateConfig()

    self:UpdateFont()
    self:UpdateTextFormat()
    self:UpdateTextVisibility()
    self:UpdateSize(self._config.width, self._config.height)

    if not M:IsRestricted() then self:UpdateFading() end
end

local function bar_UpdateSegments(self)
    local index = 0

    if C_PetBattles.IsInBattle() then
        local i = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
        local level = C_PetBattles.GetLevel(LE_BATTLE_PET_ALLY, i)

        if level and level < 25 then
            index = index + 1

            local name = C_PetBattles.GetName(1, i)
            local rarity = C_PetBattles.GetBreedQuality(1, i)
            local cur, max = C_PetBattles.GetXP(1, i)

            self[index].tooltipInfo = {
                header = NAME_TEMPLATE:format(C.colors.quality[rarity - 1].hex,
                                              name),
                -- line1 = L["LEVEL_TOOLTIP"]:format(level)
                line1 = s_format("Level: |cffffffff%d|r", level)
            }

            self[index]:Update(cur, max, 0, C.colors.xp[2])
        end
    else
        -- Artefact
        if HasArtifactEquipped() and not C_ArtifactUI.IsEquippedArtifactMaxed() and
            not C_ArtifactUI.IsEquippedArtifactDisabled() then
            index = index + 1

            local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, tier =
                C_ArtifactUI.GetEquippedArtifactInfo()
            local points, cur, max =
                ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent,
                                                                 totalXP, tier)

            self[index].tooltipInfo = {
                -- TODO: Localize this
                -- header = L["ARTIFACT_POWER"],
                -- line1 = L["UNSPENT_TRAIT_POINTS_TOOLTIP"]:format(points),
                -- line2 = L["ARTIFACT_LEVEL_TOOLTIP"]:format(pointsSpent)
                header = "Artifact Power",
                line1 = s_format("Unspent Trait Points: |cffffffff%s|r", points),
                line2 = s_format("Artifact Level: |cffffffff%s|r", pointsSpent)
            }

            self[index]:Update(cur, max, 0, C.colors.artifact)
        end

        -- Azerite
        if not C_AzeriteItem.IsAzeriteItemAtMaxLevel or
            not C_AzeriteItem.IsAzeriteItemAtMaxLevel() then
            local azeriteItem = C_AzeriteItem.FindActiveAzeriteItem()
            if azeriteItem and azeriteItem:IsEquipmentSlot() and
                C_AzeriteItem.IsAzeriteItemEnabled(azeriteItem) then
                index = index + 1

                local cur, max = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItem)
                local level = C_AzeriteItem.GetPowerLevel(azeriteItem)

                self[index].tooltipInfo =
                    {
                        -- TODO: Localize this
                        -- header = L["ARTIFACT_POWER"],
                        -- line1 = L["ARTIFACT_LEVEL_TOOLTIP"]:format(level)
                        header = "Artifact Power",
                        line1 = s_format("Artifact Level: |cffffffff%s|r", level)
                    }

                self[index]:Update(cur, max, 0, C.colors.white,
                                   C.media.textures.neon)
            end
        end

        -- XP
        if not IsXPUserDisabled() and UnitLevel("player") < MAX_PLAYER_LEVEL then
            index = index + 1

            local cur, max = UnitXP("player"), UnitXPMax("player")
            local bonus = GetXPExhaustion() or 0

            self[index].tooltipInfo = {
                -- TODO: Localize this
                -- header = L["EXPERIENCE"],
                -- line1 = L["LEVEL_TOOLTIP"]:format(UnitLevel("player"))
                header = "Experience",
                line1 = s_format("Level: |cffffffff%d|r", UnitLevel("player"))
            }

            if bonus > 0 then
                -- TODO: Localize this
                -- self[index].tooltipInfo.line2 = L["BONUS_XP_TOOLTIP"]:format(BreakUpLargeNumbers(bonus))
                self[index].tooltipInfo.line2 =
                    s_format("Bonus XP: |cffffffff%s|r",
                             BreakUpLargeNumbers(bonus))
            else
                self[index].tooltipInfo.line2 = nil
            end

            self[index]:Update(cur, max, bonus,
                               bonus > 0 and C.colors.xp[1] or C.colors.xp[2])
        end

        -- Honour
        if IsWatchingHonorAsXP() or C_PvP.IsActiveBattlefield() or
            IsInActiveWorldPVP() then
            index = index + 1

            local cur, max = UnitHonor("player"), UnitHonorMax("player")

            self[index].tooltipInfo = {
                -- TODO: Localize this
                -- header = L["HONOR"],
                -- line1 = L["HONOR_LEVEL_TOOLTIP"]:format(UnitHonorLevel("player"))
                header = "Honor",
                line1 = s_format("Honour Level: |cffffffff%d|r",
                                 UnitHonorLevel("player"))
            }

            -- self[index]:Update(cur, max, 0, C.colors.faction[UnitFactionGroup("player")])
            self[index]:Update(cur, max, 0, C.colors.difficulty.impossible)
        end

        -- Reputation
        local name, standing, repMin, repMax, repCur, factionID =
            GetWatchedFactionInfo()
        if name then
            index = index + 1

            local _, friendRep, _, _, _, _, friendTextLevel, friendThreshold,
                  nextFriendThreshold = GetFriendshipReputation(factionID)
            local repTextLevel = GetText("FACTION_STANDING_LABEL" .. standing,
                                         UnitSex("player"))
            local isParagon, rewardQuestID, hasRewardPending
            local cur, max

            if friendRep then
                if nextFriendThreshold then
                    max, cur = nextFriendThreshold - friendThreshold,
                               friendRep - friendThreshold
                else
                    max, cur = 1, 1
                end

                standing = 5
                repTextLevel = friendTextLevel
            else
                if standing ~= MAX_REPUTATION_REACTION then
                    max, cur = repMax - repMin, repCur - repMin
                else
                    isParagon = C_Reputation.IsFactionParagon(factionID)

                    if isParagon then
                        cur, max, rewardQuestID, hasRewardPending =
                            C_Reputation.GetFactionParagonInfo(factionID)
                        cur = cur % max
                        repTextLevel = repTextLevel .. "+"

                        if hasRewardPending then
                            cur = cur + max
                        end
                    else
                        max, cur = 1, 1
                    end
                end
            end

            self[index].tooltipInfo = {
                -- TODO: Localize this
                -- header = L["REPUTATION"],
                header = "Reputation",
                line1 = REPUTATION_TEMPLATE:format(name,
                                                   C.colors.reaction[standing]
                                                       .hex, repTextLevel)
            }

            if isParagon and hasRewardPending then
                local text = GetQuestLogCompletionText(
                                 C_QuestLog.GetLogIndexForQuestID(rewardQuestID))

                if text and text ~= "" then
                    self[index].tooltipInfo.line3 = text
                end
            else
                self[index].tooltipInfo.line3 = nil
            end

            self[index]:Update(cur, max, 0, C.colors.reaction[standing])
        end
    end

    if self._total ~= index then
        for i = 1, MAX_SEGMENTS do
            if i <= index then
                self[i]:SetSize(unpack(LAYOUT[index][i].size))
                self[i]:Show()

                if i == 1 then
                    self[i]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
                else
                    self[i]:SetPoint("TOPLEFT", self[i - 1], "TOPRIGHT", 2, 0)
                end

                self[i].Extension:SetSize(unpack(LAYOUT[index][i].size))
            else
                self[i]:SetMinMaxValues(0, 1)
                self[i]:SetValue(0)
                self[i]:ClearAllPoints()
                self[i]:Hide()

                self[i].Extension:SetMinMaxValues(0, 1)
                self[i].Extension:SetValue(0)

                self[i].tooltipInfo = nil
            end
        end

        if index == 0 then
            self[1]:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
            self[1]:SetSize(unpack(LAYOUT[1][1].size))
            self[1]:SetMinMaxValues(0, 1)
            self[1]:SetValue(1)
            self[1]:Show()

            self[1]:UpdateText(1, 1)
            self[1].Texture:SetVertexColor(
                E:GetRGB(C.colors.class[E.PLAYER_CLASS]))
        end

        self._total = index
    end
end

local function bar_OnEvent(self, event, ...)
    if event == "UNIT_INVENTORY_CHANGED" then
        local unit = ...
        if unit == "player" then self:UpdateSegments() end
    else
        self:UpdateSegments()
    end
end

local function segment_OnEnter(self)
    if self.tooltipInfo then
        local quadrant = E:GetScreenQuadrant(self)
        local p, rP, sign = "BOTTOMLEFT", "TOPLEFT", 1

        if quadrant == "TOPLEFT" or quadrant == "TOP" or quadrant == "TOPRIGHT" then
            p, rP, sign = "TOPLEFT", "BOTTOMLEFT", -1
        end

        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint(p, self, rP, 0, sign * 2)
        GameTooltip:AddLine(self.tooltipInfo.header, 1, 1, 1)
        GameTooltip:AddLine(self.tooltipInfo.line1)

        if self.tooltipInfo.line2 then
            GameTooltip:AddLine(self.tooltipInfo.line2)
        end

        if self.tooltipInfo.line3 then
            GameTooltip:AddLine(self.tooltipInfo.line3)
        end

        GameTooltip:Show()
    end

    if not self:IsTextLocked() then self.Text:Show() end
end

local function segment_OnLeave(self)
    GameTooltip:Hide()

    if not self:IsTextLocked() then self.Text:Hide() end
end

local function segment_Update(self, cur, max, bonus, color, texture)
    if not self._color or not E:AreColorsEqual(self._color, color) then
        self.Texture:SetVertexColor(E:GetRGBA(color, 1))
        self.Extension.Texture:SetVertexColor(E:GetRGBA(color, 0.4))

        self._color = self._color or {}
        E:SetRGB(self._color, E:GetRGB(color))
    end

    texture = texture or "Interface\\BUTTONS\\WHITE8X8"
    if not self._texture or self._texture ~= texture then
        self:SetStatusBarTexture(texture)
        self.Extension:SetStatusBarTexture(texture)

        self._texture = texture
    end

    if self._value ~= cur or self._max ~= max then
        self:SetMinMaxValues(0, max)
        self:SetValue(cur)
        self:UpdateText(cur, max)
    end

    if self._bonus ~= bonus then
        if bonus and bonus > 0 then
            if cur + bonus > max then bonus = max - cur end
            self.Extension:SetMinMaxValues(0, max)
            self.Extension:SetValue(bonus)
        else
            self.Extension:SetMinMaxValues(0, 1)
            self.Extension:SetValue(0)
        end

        self._bonus = bonus
    end
end

local function segment_UpdateText(self, cur, max)
    cur = cur or self._value or 1
    max = max or self._max or 1

    if cur == 1 and max == 1 then
        self.Text:SetText(nil)
    else
        self.Text:SetFormattedText(barValueTemplate, E:FormatNumber(cur),
                                   E:FormatNumber(max), E:NumberToPerc(cur, max))
    end
end

local function segment_LockText(self, isLocked)
    if self.textLocked ~= isLocked then
        self.textLocked = isLocked
        self.Text:SetShown(isLocked)
    end
end

local function segment_IsTextLocked(self) return self.textLocked end

function M.HasXPBar() return isInit end

function M.CreateXPBar()
    if not isInit and (C.modules.bars.xpbar.enabled or M:IsRestricted()) then
        local bar = CreateFrame("Frame", "LUMXPBar", UIParent)
        bar._id = "xpbar"

        M:AddBar(bar._id, bar)

        bar.ForEach = bar_ForEach
        bar.Update = bar_Update
        bar.UpdateConfig = bar_UpdateConfig
        bar.UpdateCooldownConfig = nil
        bar.UpdateFont = bar_UpdateFont
        bar.UpdateSegments = bar_UpdateSegments
        bar.UpdateSize = bar_UpdateSize
        bar.UpdateTextFormat = bar_UpdateTextFormat
        bar.UpdateTextVisibility = bar_UpdateTextVisibility

        local texParent = CreateFrame("Frame", nil, bar)
        texParent:SetAllPoints()
        texParent:SetFrameLevel(bar:GetFrameLevel() + 3)
        bar.TexParent = texParent

        local textParent = CreateFrame("Frame", nil, bar)
        textParent:SetAllPoints()
        textParent:SetFrameLevel(bar:GetFrameLevel() + 5)

        for i = 1, MAX_SEGMENTS do
            local segment = CreateFrame("StatusBar", "$parentSegment" .. i, bar)
            segment:SetFrameLevel(bar:GetFrameLevel() + 1)
            segment:SetStatusBarTexture(C.media.textures.neon)
            segment:SetHitRectInsets(0, 0, -4, -4)
            segment:SetClipsChildren(true)
            segment:SetScript("OnEnter", segment_OnEnter)
            segment:SetScript("OnLeave", segment_OnLeave)
            segment:Hide()
            E:SmoothBar(segment)
            bar[i] = segment

            segment.Texture = segment:GetStatusBarTexture()
            E:SmoothColor(segment.Texture)

            local ext = CreateFrame("StatusBar", nil, segment)
            ext:SetFrameLevel(segment:GetFrameLevel())
            ext:SetStatusBarTexture(C.media.textures.neon)
            ext:SetPoint("TOPLEFT", segment.Texture, "TOPRIGHT")
            ext:SetPoint("BOTTOMLEFT", segment.Texture, "BOTTOMRIGHT")
            E:SmoothBar(ext)
            segment.Extension = ext

            ext.Texture = ext:GetStatusBarTexture()
            E:SmoothColor(ext.Texture)

            local text = textParent:CreateFontString(nil, "OVERLAY")
            text:SetAllPoints(segment)
            text:SetWordWrap(false)
            text:Hide()
            segment.Text = text

            local bg = bar:CreateTexture(nil, "ARTWORK")
            bg:SetTexture(C.media.textures.flat)
            bg:SetVertexColor(C.colors.dark_gray)
            bg:SetInside()
            bg:SetAlpha(0.3)
            E:SetBackdrop(bg, 1.5, 0.4)
            E:CreateShadow(bg, 2)
            bar.bg = bg

            segment.IsTextLocked = segment_IsTextLocked
            segment.LockText = segment_LockText
            segment.Update = segment_Update
            segment.UpdateText = segment_UpdateText
        end

        bar:SetScript("OnEvent", bar_OnEvent)
        -- all
        bar:RegisterEvent("PET_BATTLE_CLOSE")
        bar:RegisterEvent("PET_BATTLE_OPENING_START")
        bar:RegisterEvent("PLAYER_UPDATE_RESTING")
        bar:RegisterEvent("UPDATE_EXHAUSTION")
        -- honour
        bar:RegisterEvent("HONOR_XP_UPDATE")
        bar:RegisterEvent("ZONE_CHANGED")
        bar:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        -- artifact
        bar:RegisterEvent("ARTIFACT_XP_UPDATE")
        bar:RegisterEvent("UNIT_INVENTORY_CHANGED")
        bar:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
        -- azerite
        bar:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")
        -- xp
        bar:RegisterEvent("DISABLE_XP_GAIN")
        bar:RegisterEvent("ENABLE_XP_GAIN")
        bar:RegisterEvent("PLAYER_LEVEL_UP")
        bar:RegisterEvent("PLAYER_XP_UPDATE")
        bar:RegisterEvent("UPDATE_EXPANSION_LEVEL")
        -- pet xp
        bar:RegisterEvent("PET_BATTLE_LEVEL_CHANGED")
        bar:RegisterEvent("PET_BATTLE_PET_CHANGED")
        bar:RegisterEvent("PET_BATTLE_XP_CHANGED")
        -- rep
        bar:RegisterEvent("UPDATE_FACTION")

        if M:IsRestricted() then
            M:ActionBarController_AddWidget(bar, "XP_BAR")
        else
            local config = M:IsRestricted() and CFG or C.modules.bars.xpbar
            local point = config.point
            bar:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
            -- E.Movers:Create(bar)
        end

        bar:Update()

        isInit = true
    end
end