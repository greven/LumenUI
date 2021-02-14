local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

local BARS = E:GetModule("Bars")

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
    self._config = E:CopyTable(BARS:IsRestricted() and CFG or C.profile.modules.bars.xpbar, self._config)

    if BARS:IsRestricted() then
        self._config.text = E:CopyTable(C.profile.modules.bars.xpbar.text, self._config.text)
    end

    self._config.text = E:CopyTable(C.global.fonts.bars, self._config.text)
end

local function updateFont(fontString, config)
    fontString:SetFont(C.global.fonts.bars.font, config.size, config.outline and "THINOUTLINE" or nil)
    fontString:SetWordWrap(false)

    if config.shadow then
        fontString:SetShadowOffset(1, -1)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

local function bar_UpdateFont(self)
    for i = 1, MAX_SEGMENTS do
        updateFont(self[i].Text, self._config.text)
    end
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

        for j = 1, i do
            LAYOUT[i][j].size = {layout[j], height}
        end
    end

    self:SetSize(width, height)

    -- if not BARS:IsRestricted() then E.Movers:Get(self):UpdateSize(width, height) end

    self.Overlay:ClearAllPoints()
    self.Overlay:SetPoint("TOPLEFT", self, E.SCREEN_SCALE * 3, -E.SCREEN_SCALE * 6)
    self.Overlay:SetPoint("BOTTOMRIGHT", self, -E.SCREEN_SCALE * 3, -4)

    self._total = nil

    self:UpdateSegments()
end

local function bar_ForEach(self, method, ...)
    for i = 1, MAX_SEGMENTS do
        if self[i][method] then
            self[i][method](self[i], ...)
        end
    end
end

local function bar_Update(self)
    self:UpdateConfig()

    self:UpdateFont()
    self:UpdateTextFormat()
    self:UpdateTextVisibility()
    self:UpdateSize(self._config.width, self._config.height)

    if not BARS:IsRestricted() then
        self:UpdateFading()
    end
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
                header = NAME_TEMPLATE:format(C.global.colors.quality[rarity - 1].hex, name),
                -- line1 = L["LEVEL_TOOLTIP"]:format(level)
                line1 = s_format("Level: |cffffffff%d|r", level)
            }

            self[index]:Update(cur, max, 0, C.global.colors.xp[2])
        end
    else
        -- Artifact
        if
            HasArtifactEquipped() and not C_ArtifactUI.IsEquippedArtifactMaxed() and
                not C_ArtifactUI.IsEquippedArtifactDisabled()
         then
            index = index + 1

            local _, _, _, _, totalXP, pointsSpent, _, _, _, _, _, _, tier = C_ArtifactUI.GetEquippedArtifactInfo()
            local points, cur, max = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, tier)

            self[index].tooltipInfo = {
                header = L["ARTIFACT_POWER"],
                line1 = s_format(L["UNSPENT_TRAIT_POINTS_TOOLTIP"], points),
                line2 = s_format(L["ARTIFACT_LEVEL_TOOLTIP"], pointsSpent)
            }

            self[index]:Update(cur, max, 0, C.global.colors.artifact)
        end

        -- Azerite
        if not C_AzeriteItem.IsAzeriteItemAtMaxLevel or not C_AzeriteItem.IsAzeriteItemAtMaxLevel() then
            local azeriteItem = C_AzeriteItem.FindActiveAzeriteItem()
            if azeriteItem and azeriteItem:IsEquipmentSlot() and C_AzeriteItem.IsAzeriteItemEnabled(azeriteItem) then
                index = index + 1

                local cur, max = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItem)
                local level = C_AzeriteItem.GetPowerLevel(azeriteItem)

                self[index].tooltipInfo = {
                    header = L["ARTIFACT_POWER"],
                    line1 = s_format(L["ARTIFACT_LEVEL_TOOLTIP"], level)
                }

                self[index]:Update(cur, max, 0, C.global.colors.white, M.textures.statusbar_azerite)
            end
        end

        -- XP
        if not IsXPUserDisabled() and UnitLevel("player") < MAX_PLAYER_LEVEL then
            index = index + 1

            local cur, max = UnitXP("player"), UnitXPMax("player")
            local bonus = GetXPExhaustion() or 0

            self[index].tooltipInfo = {
                header = L["EXPERIENCE"],
                line1 = s_format(L["LEVEL_TOOLTIP"], UnitLevel("player"))
            }

            if bonus > 0 then
                self[index].tooltipInfo.line2 = s_format(L["BONUS_XP_TOOLTIP"], BreakUpLargeNumbers(bonus))
            else
                self[index].tooltipInfo.line2 = nil
            end

            self[index]:Update(
                cur,
                max,
                bonus,
                bonus > 0 and C.global.colors.xp[1] or C.global.colors.xp[2],
                C.profile.modules.bars.xpbar.texture
            )
        end

        -- Honour
        if IsWatchingHonorAsXP() or C_PvP.IsActiveBattlefield() or IsInActiveWorldPVP() then
            index = index + 1

            local cur, max = UnitHonor("player"), UnitHonorMax("player")

            self[index].tooltipInfo = {
                header = L["HONOR"],
                line1 = s_format(L["HONOR_LEVEL_TOOLTIP"], UnitHonorLevel("player"))
            }

            -- self[index]:Update(cur, max, 0, C.global.colors.faction[UnitFactionGroup("player")])
            self[index]:Update(cur, max, 0, C.global.colors.difficulty.impossible)
        end

        -- Reputation
        local name, standing, repMin, repMax, repCur, factionID = GetWatchedFactionInfo()
        if name then
            index = index + 1

            local _, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold =
                GetFriendshipReputation(factionID)
            local repTextLevel = GetText("FACTION_STANDING_LABEL" .. standing, UnitSex("player"))
            local isParagon, rewardQuestID, hasRewardPending
            local cur, max

            if friendRep then
                if nextFriendThreshold then
                    max, cur = nextFriendThreshold - friendThreshold, friendRep - friendThreshold
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
                        cur, max, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
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
                header = L["REPUTATION"],
                line1 = REPUTATION_TEMPLATE:format(name, C.global.colors.reaction[standing].hex, repTextLevel)
            }

            if isParagon and hasRewardPending then
                local text = GetQuestLogCompletionText(C_QuestLog.GetLogIndexForQuestID(rewardQuestID))

                if text and text ~= "" then
                    self[index].tooltipInfo.line3 = text
                end
            else
                self[index].tooltipInfo.line3 = nil
            end

            self[index]:Update(cur, max, 0, C.global.colors.reaction[standing])
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
            self[1].Texture:SetVertexColor(E:GetRGB(C.global.colors.class[E.PLAYER_CLASS]))
        end

        self._total = index
    end
end

local function bar_OnEvent(self, event, ...)
    if event == "UNIT_INVENTORY_CHANGED" then
        local unit = ...
        if unit == "player" then
            self:UpdateSegments()
        end
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

    if not self:IsTextLocked() then
        self.Text:Show()
    end
end

local function segment_OnLeave(self)
    GameTooltip:Hide()

    if not self:IsTextLocked() then
        self.Text:Hide()
    end
end

local function segment_Update(self, cur, max, bonus, color, texture)
    if not self._color or not E:AreColorsEqual(self._color, color) then
        self.Texture:SetVertexColor(E:GetRGBA(color, 1))
        self.Extension.Texture:SetVertexColor(E:GetRGBA(color, 0.3))

        self._color = self._color or {}
        E:SetRGB(self._color, E:GetRGB(color))

        if self.Spark then
            self.Spark:SetVertexColor(E:GetRGB(self._color))
        end
    end

    texture = texture or "Interface\\BUTTONS\\WHITE8X8"
    if not self._texture or self._texture ~= texture then
        self:SetStatusBarTexture(texture)
        self:GetStatusBarTexture():SetVertTile(true)
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
            if cur + bonus > max then
                bonus = max - cur
            end
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
        self.Text:SetFormattedText(barValueTemplate, E:FormatNumber(cur), E:FormatNumber(max), E:NumberToPerc(cur, max))
    end
end

local function segment_LockText(self, isLocked)
    if self.textLocked ~= isLocked then
        self.textLocked = isLocked
        self.Text:SetShown(isLocked)
    end
end

local function segment_IsTextLocked(self)
    return self.textLocked
end

function BARS.HasXPBar()
    return isInit
end

function BARS.CreateXPBar()
    if not isInit and (C.profile.modules.bars.xpbar.enabled or BARS:IsRestricted()) then
        local config = C.profile.modules.bars.xpbar
        local bar = CreateFrame("Frame", "LumXPBar", UIParent)
        bar._id = "xpbar"

        BARS:AddBar(bar._id, bar)

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
        textParent:SetFrameLevel(bar:GetFrameLevel() + 10)

        bar.Overlay =
            E:SetBackdrop(
            texParent,
            E.SCREEN_SCALE * 3,
            0.98,
            nil,
            {
                bgFile = M.textures.vertlines,
                tile = true,
                tileSize = 8
            }
        )
        bar.Overlay:SetBackdropColor(E:GetRGBA(C.global.backdrop.color))

        for i = 1, MAX_SEGMENTS do
            local segment = CreateFrame("StatusBar", "$parentSegment" .. i, bar)
            segment:SetFrameLevel(bar:GetFrameLevel() + 1)
            segment:SetStatusBarTexture(M.textures.flat)
            segment:GetStatusBarTexture():SetVertTile(true)
            segment:SetHitRectInsets(0, 0, E.SCREEN_SCALE * 3, E.SCREEN_SCALE * 3)
            segment:SetClipsChildren(true)
            segment:SetScript("OnEnter", segment_OnEnter)
            segment:SetScript("OnLeave", segment_OnLeave)
            segment:Hide()
            E:SmoothBar(segment)
            bar[i] = segment

            if config.spark then
                local spark = segment:CreateTexture(nil, "OVERLAY")
                spark:SetTexture(M.textures.spark)
                spark:SetSize(10, config.height)
                spark:SetBlendMode("ADD")
                spark:SetPoint("CENTER", segment:GetStatusBarTexture(), "RIGHT", 0, 0)
                segment.Spark = spark
            end

            segment.Texture = segment:GetStatusBarTexture()
            E:SmoothColor(segment.Texture)

            local ext = CreateFrame("StatusBar", nil, segment)
            ext:SetFrameLevel(segment:GetFrameLevel())
            ext:SetStatusBarTexture(M.textures.flat)
            ext:GetStatusBarTexture():SetVertTile(true)
            ext:SetPoint("TOPLEFT", segment.Texture, "TOPRIGHT")
            ext:SetPoint("BOTTOMLEFT", segment.Texture, "BOTTOMRIGHT")
            E:SmoothBar(ext)
            segment.Extension = ext

            ext.Texture = ext:GetStatusBarTexture()
            E:SmoothColor(ext.Texture)

            local text = textParent:CreateFontString(nil, "OVERLAY")
            if config.text.position then
                if config.text.position == "TOP" then
                    text:SetPoint("CENTER", segment, "TOP", 0, -1)
                else
                    text:SetAllPoints(segment)
                end
            else
                text:SetAllPoints(segment)
            end
            text:SetWordWrap(false)
            text:Hide()
            segment.Text = text

            local bg = bar:CreateTexture(nil, "ARTWORK")
            bg:SetTexture(M.textures.flat)
            bg:SetVertexColor(C.global.colors.dark_gray)
            bg:SetAllPoints()
            bg:SetAlpha(0.3)
            -- E:SetBackdrop(bg, E.SCREEN_SCALE * 3, 0.5)
            -- E:CreateShadow(bg, E.SCREEN_SCALE * 3)
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

        if BARS:IsRestricted() then
            BARS:ActionBarController_AddWidget(bar, "XP_BAR")
        else
            -- E.Movers:Create(bar)
            local config = BARS:IsRestricted() and CFG or C.profile.modules.bars.xpbar
            local point = config.point
            bar:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
        end

        bar:Update()
        bar:UpdateVisibility()

        isInit = true
    end
end
