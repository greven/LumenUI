-- Tooltip Info: SpellID, AuraID, ItemInfo...
local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

local TOOLTIPS = E:GetModule("Tooltips")

local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local s_format = _G.string.format
local s_upper = _G.string.upper

-- Blizz
local GetGuildInfo = _G.GetGuildInfo
local GetMouseFocus = _G.GetMouseFocus
local IsShiftKeyDown = _G.IsShiftKeyDown
local UnitClass = _G.UnitClass
local UnitCreatureType = _G.UnitCreatureType
local UnitEffectiveLevel = _G.UnitEffectiveLevel
local UnitRealmRelationship = _G.UnitRealmRelationship
local UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned
local UnitIsBattlePetCompanion = _G.UnitIsBattlePetCompanion
local UnitIsConnected = _G.UnitIsConnected
local UnitInParty = _G.UnitInParty
local UnitInRaid = _G.UnitInRaid
local UnitIsAFK = _G.UnitIsAFK
local UnitIsDND = _G.UnitIsDND
local UnitIsGroupLeader = _G.UnitIsGroupLeader
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsQuestBoss = _G.UnitIsQuestBoss
local UnitIsWildBattlePet = _G.UnitIsWildBattlePet
local UnitLevel = _G.UnitLevel
local UnitName = _G.UnitName
local UnitPhaseReason = _G.UnitPhaseReason
local UnitPVPName = _G.UnitPVPName
local UnitExists = _G.UnitExists
local UnitRace = _G.UnitRace

-- ---------------

local AFK = "[" .. _G.AFK .. "] "
local DND = "[" .. _G.DND .. "] "
local TARGET = "|cffffd100" .. _G.TARGET .. ":|r %s"
local PLAYER_TEMPLATE = "|c%s%s|r (|c%s" .. _G.PLAYER .. "|r)"
local GUILD_TEMPLATE = _G.GUILD_TEMPLATE:format("|c%s%s", "|r%s")

local TEXTS_TO_REMOVE = {
    [_G.FACTION_ALLIANCE] = true,
    [_G.FACTION_HORDE] = true,
    [_G.PVP] = true
}

local function getLineByText(tooltip, text, offset)
    for i = offset, tooltip:NumLines() do
        local line = _G["GameTooltipTextLeft" .. i]
        local lineText = line:GetText()

        if lineText and lineText:match(text) then
            return line
        end
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

        if unit and not (UnitExists(unit) or ShowBossFrameWhenUninteractable(unit)) then
            unit = nil
        end
    end

    return unit
end

-- Moves trash lines to the bottom
local function cleanUp(tooltip)
    local num = tooltip:NumLines()

    if not num or num <= 1 then
        return
    end

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

local function tooltip_SetUnit(self)
    if self:IsForbidden() then
        return
    end

    local unit = getTooltipUnit(self)
    if not unit then
        return
    end

    local nameColor = E:GetUnitColor(unit, nil, true)
    local scaledLevel = UnitEffectiveLevel(unit)
    local difficultyColor = E:GetCreatureDifficultyColor(scaledLevel)
    local isPVPReady, pvpFaction = E:GetUnitPVPStatus(unit)
    local isShiftKeyDown = IsShiftKeyDown()
    local lineOffset = 2

    if UnitIsPlayer(unit) then
        local name, realm = UnitName(unit)
        name = C.db.profile.modules.tooltips.title and UnitPVPName(unit) or name

        if realm and realm ~= "" then
            if isShiftKeyDown then
                name = s_format("%s|c%s-%s|r", name, C.db.global.colors.gray.hex, realm)
            elseif UnitRealmRelationship(unit) ~= LE_REALM_RELATION_VIRTUAL then
                name = name .. L["FOREIGN_SERVER_LABEL"]
            end
        end

        GameTooltipTextLeft1:SetFormattedText(
            "|c%s%s|r|c%s%s|r",
            C.db.global.colors.gray.hex,
            UnitIsAFK(unit) and AFK or UnitIsDND(unit) and DND or "",
            nameColor.hex,
            name
        )

        -- Status
        local status = ""

        -- GameTooltipTextRight1:SetText(M.textures.icons_inline["SHEEP"]:format(16, 16))
        local size = GameTooltipTextRight1:GetStringHeight()
        size = 16 * 16 / size

        if UnitInParty(unit) or UnitInRaid(unit) then
            if UnitIsGroupLeader(unit) then
            -- status = status .. M.textures.icons_inline["LEADER"]:format(size, size)
            end

            local role = UnitGroupRolesAssigned(unit)
            if role and role ~= "NONE" then
            -- status = status .. M.textures.icons_inline[role]:format(size, size)
            end
        end

        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitPhaseReason(unit) then
        -- status = status .. PHASE_ICONS[UnitPhaseReason(unit)]:format(size, size)
        end

        if isPVPReady then
        -- status = status .. M.textures.icons_inline[s_upper(pvpFaction)]:format(size, size)
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
                    guildName = s_format("%s|c%s-%s|r", guildName, C.db.global.colors.gray.hex, guildRealm)
                end

                if guildRankName then
                    guildName = GUILD_TEMPLATE:format(C.db.global.colors.gray.hex, guildRankName, guildName)
                end
            end

            GameTooltipTextLeft2:SetText(E:WrapText(C.db.global.colors.light_cyan, guildName))
        end

        local levelLine = getLineByText(self, scaledLevel > 0 and scaledLevel or "%?%?", lineOffset)
        if levelLine then
            local level = UnitLevel(unit)
            local classColor = E:GetUnitClassColor(unit)

            levelLine:SetFormattedText(
                "|c%s%s|r %s |c%s%s|r",
                difficultyColor.hex,
                scaledLevel > 0 and (scaledLevel ~= level and scaledLevel .. " (" .. level .. ")" or scaledLevel) or
                    "??",
                UnitRace(unit),
                classColor.hex,
                UnitClass(unit)
            )

            if C.db.profile.modules.tooltips.inspect and isShiftKeyDown and level > 10 then
                TOOLTIPS:AddInspectInfo(self, unit, 0)
            end
        end
    elseif UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
        GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", nameColor.hex, UnitName(unit) or L["UNKNOWN"])

        scaledLevel = UnitBattlePetLevel(unit)

        local levelLine = getLineByText(self, scaledLevel > 0 and scaledLevel or "%?%?", lineOffset)
        if levelLine then
            local petType = _G["BATTLE_PET_NAME_" .. UnitBattlePetType(unit)]

            local teamLevel = C_PetJournal.GetPetTeamAverageLevel()
            if teamLevel then
                difficultyColor = E:GetRelativeDifficultyColor(teamLevel, scaledLevel)
            else
                difficultyColor = E:GetCreatureDifficultyColor(scaledLevel)
            end

            levelLine:SetFormattedText(
                "|c%s%s|r %s",
                difficultyColor.hex,
                scaledLevel > 0 and scaledLevel or "??",
                (UnitCreatureType(unit) or L["PET"]) .. (petType and ", " .. petType or "")
            )
        end
    else
        GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", nameColor.hex, UnitName(unit) or L["UNKNOWN"])

        -- status
        local status = ""

        -- TODO: Icon
        -- GameTooltipTextRight1:SetText(M.textures.icons_inline["SHEEP"]:format(16, 16))
        local size = GameTooltipTextRight1:GetStringHeight()
        size = 16 * 16 / size

        if UnitIsQuestBoss(unit) then
        -- TODO: Icon
        -- status = status .. s_format(M.textures.icons_inline["QUEST"], size, size)
        end

        if isPVPReady then
        -- TODO: Icon
        -- status = status .. s_format(M.textures.icons_inline[s_upper(pvpFaction)], size, size)
        end

        if status ~= "" then
            GameTooltipTextRight1:SetText(status)
            GameTooltipTextRight1:Show()
        else
            GameTooltipTextRight1:SetText(nil)
        end

        local levelLine = getLineByText(self, scaledLevel > 0 and scaledLevel or "%?%?", lineOffset)
        if levelLine then
            local level = UnitLevel(unit)

            levelLine:SetFormattedText(
                "|c%s%s%s|r %s",
                difficultyColor.hex,
                scaledLevel > 0 and (scaledLevel ~= level and scaledLevel .. " (" .. level .. ")" or scaledLevel) or
                    "??",
                E:GetUnitClassification(unit),
                UnitCreatureType(unit) or ""
            )
        end
    end

    -- Show Target info
    if C.db.profile.modules.tooltips.target then
        local unitTarget = unit .. "target"
        if UnitExists(unitTarget) then
            local name = UnitName(unitTarget)

            if UnitIsPlayer(unitTarget) and name == E.PLAYER_NAME then
                name = E:WrapText(C.db.global.colors.red, s_upper(L["YOU"]) .. "!")
            elseif UnitIsPlayer(unitTarget) then
                name =
                    PLAYER_TEMPLATE:format(
                    E:GetUnitClassColor(unitTarget).hex,
                    name,
                    E:GetUnitReactionColor(unitTarget).hex
                )
            else
                name = s_format("|c%s%s|r", E:GetUnitColor(unitTarget, nil, true).hex, name)
            end

            self:AddLine(TARGET:format(name), 1, 1, 1)
        end
    end

    cleanUp(self)

    self:Show()
end

function TOOLTIPS:UpdateStatusBarColor(self)
    if not self then
        return
    end

    local tooltip = self:GetParent()
    if not tooltip then
        return
    end

    local unit = getTooltipUnit(tooltip)
    if not unit then
        return
    end

    self:SetStatusBarColor(E:GetRGB(C.db.global.colors.health))

    if UnitIsPlayer(unit) then
        -- Border color
        if C.db.profile.modules.tooltips.border.color_class and self.bg then
            self.bg:SetBackdropBorderColor(E:GetRGB(E:GetUnitClassColor(unit)))
        end

        -- Statusbar color
        if C.db.profile.modules.tooltips.health.color_class then
            self:SetStatusBarColor(E:GetRGB(E:GetUnitClassColor(unit)))
        end
    end
end

function TOOLTIPS:SetupUnitInfo()
    if not TOOLTIPS:IsInit() then
        GameTooltip:HookScript("OnTooltipSetUnit", tooltip_SetUnit)
    end
end
