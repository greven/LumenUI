local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L
local oUF = ns.oUF

local UF = E:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local pcall = pcall

-- Blizzard
local GetTime = _G.GetTime
local UnitAura = _G.UnitAura
local CreateFrame = _G.CreateFrame
local UnitIsEnemy = _G.UnitIsEnemy
local UnitReaction = _G.UnitReaction
local GameTooltip = _G.GameTooltip

-- ---------------

local function updateFont(fontString, config)
    fontString:SetFont(C.global.fonts.units.font, config.size,
                       config.outline and "THINOUTLINE" or nil)
    fontString:SetWordWrap(false)

    if config.shadow then
        fontString:SetShadowOffset(1, -1)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.modules.unitframes.units[unit].aura_bars,
                               self._config)
end

local function element_UpdatePosition(self)
    local frame = self.__owner
    local config = self._config

    self:ClearAllPoints()

    local point = config.point
    if point and point.p then
        self:SetPoint(point.p, E:ResolveAnchorPoint(self.__owner, point.anchor),
                      point.ap, point.x, point.y)
    end
end

local function element_PostCreateBar(self, bar)
    if not self or not bar then return end

    E:HandleStatusBar(bar)
    E:SetStatusBarSkin(bar, C.media.textures.neon)
    E:SetBackdrop(bar, E.SCREEN_SCALE * 3, C.global.backdrop.alpha)
    -- E:SetBackdrop(self.Icon, 2)

    bar:SetPoint('LEFT')
    bar:SetPoint('RIGHT')
end

function element_SetPosition(from, to)
    --   local anchor = self.initialAnchor
    -- 	local growth = self.growth == 'DOWN' and -1 or 1
end

local function frame_UpdateAuraBars(self)
    local element = self.AuraBars
    element:UpdateConfig()
    element:UpdatePosition()

    if element._config.enabled and not self:IsElementEnabled("AuraBars") then
        self:EnableElement("AuraBars")
    elseif not element._config.enabled and self:IsElementEnabled("AuraBars") then
        self:DisableElement("AuraBars")
    end

    if self:IsElementEnabled("AuraBars") then element:ForceUpdate() end
end

function UF:CreateAuraBars(frame, unit)
    local config = C.modules.unitframes.units[frame._layout or frame._unit]
                       .aura_bars

    local element = CreateFrame("Frame", '$parent_AuraBars', frame)
    element:SetSize(1, 1)

    element.spacing = config.spacing or 4
    element.sparkEnabled = true
    element.initialAnchor = 'BOTTOMRIGHT'
    element.UpdateConfig = element_UpdateConfig
    element.UpdatePosition = element_UpdatePosition
    -- element.UpdateFonts = element_UpdateFonts
    -- element.UpdateColors = element_UpdateColors
    -- element.UpdateMouse = element_UpdateMouse
    -- element.CreateIcon = element_CreateAuraIcon
    -- element.PostUpdateIcon = element_PostUpdateIcon
    -- element.PreSetPosition = element_SortAuras
    -- element.CustomFilter = filterFunctions[unit] or filterFunctions.default

    -- element.PreSetPosition = UF.SortAuras
    element.PostCreateBar = element_PostCreateBar
    -- element.PostUpdateBar = element_PostUpdateBar
    -- element.SetPosition = element_SetPosition
    element.CustomFilter = UF.filterFunctions[unit] or
                               UF.filterFunctions.default

    frame.UpdateAuraBars = frame_UpdateAuraBars
    frame.AuraBars = element

    return element
end

-- ------------------
-- Aura Bars Element
-- ------------------
do
    local VISIBLE = 1
    local HIDDEN = 0

    local function onEnter(self)
        if GameTooltip:IsForbidden() or not self:IsVisible() then return end

        GameTooltip:SetOwner(self, self.tooltipAnchor)
        GameTooltip:SetUnitAura(self.unit, self.index, self.filter)
    end

    local function onLeave()
        if GameTooltip:IsForbidden() then return end

        GameTooltip:Hide()
    end

    local function onUpdate(self, elapsed)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed >= 0.01 then
            if self.noTime then
                self:SetValue(1)
                self.Time:SetText()
                self:SetScript("OnUpdate", nil)
            else
                local timeNow = GetTime()
                self:SetValue((self.expiration - timeNow) / self.duration)
                self.Time:SetText(E:TimeFormat(self.expiration - timeNow))
            end
            self.elapsed = 0
        end
    end

    local function createAuraBar(element, index)
        local statusBar = CreateFrame('StatusBar', element:GetName() ..
                                          'StatusBar' .. index, element)
        statusBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
        statusBar:SetMinMaxValues(0, 1)
        statusBar.tooltipAnchor = element.tooltipAnchor
        statusBar:SetScript('OnEnter', onEnter)
        statusBar:SetScript('OnLeave', onLeave)
        statusBar:EnableMouse(false)

        local spark = statusBar:CreateTexture(nil, "OVERLAY", nil);
        spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
        spark:SetWidth(12)
        spark:SetBlendMode("ADD")
        spark:SetPoint('CENTER', statusBar:GetStatusBarTexture(), 'RIGHT')

        local icon = statusBar:CreateTexture(nil, 'ARTWORK')
        icon:SetPoint('RIGHT', statusBar, 'LEFT', -(element.gap or 2), 0)
        icon:SetSize(element.height, element.height)

        local name = statusBar:CreateFontString(nil, 'OVERLAY',
                                                'NumberFontNormal')
        name:SetPoint('LEFT', statusBar, 'LEFT', 2, 0)

        local time = statusBar:CreateFontString(nil, 'OVERLAY',
                                                'NumberFontNormal')
        time:SetPoint('RIGHT', statusBar, 'RIGHT', -2, 0)

        statusBar.Icon = icon
        statusBar.Name = name
        statusBar.Time = time
        statusBar.Spark = spark

        if (element.PostCreateBar) then element:PostCreateBar(statusBar) end

        return statusBar
    end

    local function customFilter(element, unit, button, name)
        if ((element.onlyShowPlayer and button.isPlayer) or
            (not element.onlyShowPlayer and name)) then return true end
    end

    local function updateBar(element, unit, index, offset, filter, isDebuff,
                             visible)
        local name, texture, count, debuffType, duration, expiration, caster,
              isStealable, nameplateShowSelf, spellID, canApply, isBossDebuff,
              casterIsPlayer, nameplateShowAll, timeMod, effect1, effect2,
              effect3 = UnitAura(unit, index, filter)

        if name then
            local position = visible + offset + 1
            local statusBar = element[position]
            if not statusBar then
                statusBar = (element.CreateBar or createAuraBar)(element,
                                                                 position)
                tinsert(element, statusBar)
                element.createdBars = element.createdBars + 1
            end

            statusBar.unit = unit
            statusBar.index = index
            statusBar.caster = caster
            statusBar.filter = filter
            statusBar.isDebuff = isDebuff
            statusBar.isPlayer = caster == 'player' or caster == 'vehicle'

            local show = (element.CustomFilter or customFilter)(element, unit,
                                                                statusBar, name,
                                                                texture, count,
                                                                debuffType,
                                                                duration,
                                                                expiration,
                                                                caster,
                                                                isStealable,
                                                                nameplateShowSelf,
                                                                spellID,
                                                                canApply,
                                                                isBossDebuff,
                                                                casterIsPlayer,
                                                                nameplateShowAll,
                                                                timeMod,
                                                                effect1,
                                                                effect2, effect3)

            if show then
                statusBar.Icon:SetTexture(texture)
                if count > 1 then
                    statusBar.Name:SetFormattedText('[%d] %s', count, name)
                else
                    statusBar.Name:SetText(name)
                end

                statusBar.duration = duration
                statusBar.expiration = expiration
                statusBar.spellID = spellID
                statusBar.spell = name
                statusBar.noTime = (duration == 0 and expiration == 0)

                if not statusBar.noTime and element.sparkEnabled then
                    statusBar.Spark:Show()
                else
                    statusBar.Spark:Hide()
                end

                local r, g, b = .2, .6, 1
                if element.buffColor then
                    r, g, b = unpack(element.buffColor)
                end
                if filter == 'HARMFUL' then
                    if not debuffType or debuffType == '' then
                        debuffType = 'none'
                    end

                    local color = _G.DebuffTypeColor[debuffType]
                    r, g, b = color.r, color.g, color.b
                end

                statusBar:SetStatusBarColor(r, g, b)
                statusBar:SetSize(element.width, element.height)
                statusBar.Icon:SetSize(element.height, element.height)
                statusBar:SetScript('OnUpdate', onUpdate)
                statusBar:SetID(index)
                statusBar:Show()

                if element.PostUpdateBar then
                    element:PostUpdateBar(unit, statusBar, index, position,
                                          duration, expiration, debuffType,
                                          isStealable)
                end

                return VISIBLE
            else
                return HIDDEN
            end
        end
    end

    local function SetPosition(element, from, to)
        local height = element.height
        local spacing = element.spacing or 1
        local anchor = element.initialAnchor
        local growth = element.growth == 'DOWN' and -1 or 1

        for i = from, to do
            local button = element[i]
            if (not button) then break end

            button:ClearAllPoints()
            button:SetPoint(anchor, element, anchor, (height + element.gap),
                            growth *
                                (i > 1 and ((i - 1) * (height + spacing)) or 0))
        end
    end

    local function filterBars(element, unit, filter, limit, isDebuff, offset,
                              dontHide)
        if (not offset) then offset = 0 end
        local index = 1
        local visible = 0
        local hidden = 0
        while (visible < limit) do
            local result = updateBar(element, unit, index, offset, filter,
                                     isDebuff, visible)
            if not result then
                break
            elseif result == VISIBLE then
                visible = visible + 1
            elseif result == HIDDEN then
                hidden = hidden + 1
            end

            index = index + 1
        end

        if not dontHide then
            for i = visible + offset + 1, #element do
                element[i]:Hide()
            end
        end

        return visible, hidden
    end

    local function UpdateAuras(self, event, unit)
        if self.unit ~= unit then return end

        local element = self.AuraBars
        if element then
            if element.PreUpdate then element:PreUpdate(unit) end

            local isEnemy = UnitIsEnemy(unit, 'player')
            local reaction = UnitReaction(unit, 'player')
            local filter = (not isEnemy and (not reaction or reaction > 4) and
                               (element.friendlyAuraType or 'HELPFUL')) or
                               element.enemyAuraType or 'HARMFUL'
            local visible, hidden = filterBars(element, unit, filter,
                                               element.maxBars,
                                               filter == 'HARMFUL', 0)

            local fromRange, toRange
            if (element.PreSetPosition) then
                fromRange, toRange = element:PreSetPosition(element.maxBars)
            end

            if (fromRange or element.createdBars > element.anchoredBars) then
                (element.SetPosition or SetPosition)(element, fromRange or
                                                         element.anchoredBars +
                                                         1, toRange or
                                                         element.createdBars)
                element.anchoredBars = element.createdBars
            end

            if (element.PostUpdate) then element:PostUpdate(unit) end
        end
    end

    local function Update(self, event, unit)
        if (self.unit ~= unit) then return end

        UpdateAuras(self, event, unit)

        if event == 'ForceUpdate' or not event then
            local element = self.AuraBars
            if element then
                (element.SetPosition or SetPosition)(element, 1,
                                                     element.createdBars)
            end
        end
    end

    local function ForceUpdate(element)
        return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
    end

    local function Enable(self)
        local element = self.AuraBars

        if element then
            self:RegisterEvent('UNIT_AURA', UpdateAuras)

            element.__owner = self
            element.ForceUpdate = ForceUpdate
            element.createdBars = element.createdBars or 0
            element.anchoredBars = 0
            element.width = element.width or 240
            element.height = element.height or 12
            element.sparkEnabled = element.sparkEnabled or true
            element.spacing = element.spacing or 2
            element.initialAnchor = element.initialAnchor or 'BOTTOMLEFT'
            element.growth = element.growth or 'UP'
            element.gap = element.gap or 2
            element.maxBars = element.maxBars or 32

            if (not pcall(self.GetCenter, self)) then
                element.tooltipAnchor = 'ANCHOR_CURSOR'
            else
                element.tooltipAnchor = element.tooltipAnchor or
                                            'ANCHOR_BOTTOMRIGHT'
            end

            element:Show()

            return true
        end
    end

    local function Disable(self)
        local element = self.AuraBars

        if element then
            self:UnregisterEvent('UNIT_AURA', UpdateAuras)
            element:Hide()
        end
    end

    oUF:AddElement('AuraBars', Update, Enable, Disable)
end
