local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

local UF = E:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local m_max = _G.math.max
local m_min = _G.math.min
local m_huge = _G.math.huge
local t_sort = _G.table.sort
local next = _G.next
local select = _G.select
local unpack = _G.unpack

local GetTime = _G.GetTime
local UnitIsFriend = _G.UnitIsFriend

-- ---------------

local MOUNTS = {}

for _, id in next, C_MountJournal.GetMountIDs() do
    MOUNTS[select(2, C_MountJournal.GetMountInfoByID(id))] = true
end

UF.filterFunctions = {
    default = function(
        self,
        unit,
        aura,
        name,
        _,
        count,
        debuffType,
        duration,
        expiration,
        caster,
        isStealable,
        _,
        spellID,
        _,
        isBossAura)
        local config = self._config and self._config.filter or nil
        if not config then
            return
        end

        aura.name = name
        aura.spell = name
        aura.spellID = spellID
        aura.dtype = debuffType
        aura.expiration = expiration
        aura.duration = duration
        aura.noTime = duration == 0 and expiration == 0
        aura.isStealable = isStealable
        aura.canDispell =
            (not aura.isDebuff and isStealable) or (aura.isDebuff and debuffType and E:IsDispellable(debuffType))

        -- black and whitelists
        for filter, enabled in next, config.custom do
            if enabled then
                filter = C.global.aura_filters[filter]
                if filter and filter[spellID] then
                    if filter.onlyShowPlayer then
                        if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
                            return filter.state
                        end
                    else
                        return filter.state
                    end
                end
            end
        end

        local isFriend = UnitIsFriend("player", unit)

        config = isFriend and config.friendly or config.enemy
        if not config then
            return
        end

        config = aura.isDebuff and config.debuff or config.buff
        if not config then
            return
        end

        -- boss
        isBossAura = isBossAura or E:IsUnitBoss(caster)
        if isBossAura then
            return config.boss
        end

        -- applied by tank
        if caster and E:IsUnitTank(caster) then
            return config.tank
        end

        -- applied by healer
        if caster and E:IsUnitTank(caster) then
            return config.healer
        end

        -- mounts
        if MOUNTS[spellID] then
            return config.mount
        end

        -- self-cast
        if caster and UnitIsUnit(unit, caster) then
            if duration and duration ~= 0 then
                return config.selfcast
            else
                return config.selfcast and config.selfcast_permanent
            end
        end

        -- applied by player
        if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
            if duration and duration ~= 0 then
                return config.player
            else
                return config.player and config.player_permanent
            end
        end

        if isFriend then
            if aura.isDebuff then
                -- dispellable
                if debuffType and E:IsDispellable(debuffType) then
                    return config.dispellable
                end
            end
        else
            -- stealable
            if isStealable then
                return config.dispellable
            end
        end

        return config.misc
    end,
    boss = function(
        self,
        unit,
        aura,
        name,
        _,
        count,
        debuffType,
        duration,
        expiration,
        caster,
        isStealable,
        _,
        spellID,
        _,
        isBossAura)
        local config = self._config and self._config.filter or nil
        if not config then
            return
        end

        aura.name = name
        aura.spell = name
        aura.spellID = spellID
        aura.dtype = debuffType
        aura.expiration = expiration
        aura.duration = duration
        aura.noTime = duration == 0 and expiration == 0
        aura.isStealable = isStealable
        aura.canDispell =
            (not aura.isDebuff and isStealable) or (aura.isDebuff and debuffType and E:IsDispellable(debuffType))

        -- black and whitelists
        for filter, enabled in next, config.custom do
            if enabled then
                filter = C.global.aura_filters[filter]
                if filter and filter[spellID] then
                    if filter.onlyShowPlayer then
                        if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
                            return filter.state
                        end
                    else
                        return filter.state
                    end
                end
            end
        end

        local isFriend = UnitIsFriend("player", unit)

        config = isFriend and config.friendly or config.enemy
        if not config then
            return
        end

        config = aura.isDebuff and config.debuff or config.buff
        if not config then
            return
        end

        -- boss
        isBossAura = isBossAura or E:IsUnitBoss(caster)
        if isBossAura then
            return config.boss
        end

        -- applied by tank
        if caster and E:IsUnitTank(caster) then
            return config.tank
        end

        -- applied by healer
        if caster and E:IsUnitTank(caster) then
            return config.healer
        end

        -- applied by player
        if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
            if duration and duration ~= 0 then
                return config.player
            else
                return config.player and config.player_permanent
            end
        end

        if isFriend then
            if aura.isDebuff then
                -- dispellable
                if debuffType and E:IsDispellable(debuffType) then
                    return config.dispellable
                end
            end
        else
            -- stealable
            if isStealable then
                return config.dispellable
            end
        end

        return config.misc
    end
}

function UF.SortAuras(a, b)
    if a and b and a:GetParent()._config then
        if a:IsShown() and b:IsShown() then
            local aTime = a.noTime and m_huge or a.expiration or -1
            local bTime = b.noTime and m_huge or b.expiration or -1

            if aTime and bTime then
                return aTime > bTime
            end
        elseif a:IsShown() then
            return true
        end
    end
end

local function element_SortAuras(self)
    if self._config and self._config.sort then
        t_sort(self, UF.SortAuras)
        return 1, #self -- Prevent things from going crazy!
    end
end

local function button_UpdateTooltip(self)
    GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
end

local function button_OnEnter(self)
    if not self:IsVisible() then
        return
    end

    GameTooltip:SetOwner(self, self:GetParent().tooltipAnchor)
    self:UpdateTooltip()
end

local function button_OnLeave()
    GameTooltip:Hide()
end

local function element_PostUpdateIcon(self, _, aura, _, _, duration, expiration, debuffType)
    if aura.isDebuff then
        aura.Border:SetVertexColor(E:GetRGB(C.global.colors.debuff[debuffType] or C.global.colors.debuff.None))

        if self._config.type then
            if self._config.type.debuff_type then
                aura.AuraType:SetTexCoord(unpack(M.textures.aura_icons[debuffType] or M.textures.aura_icons["Debuff"]))
            else
                aura.AuraType:SetTexCoord(unpack(M.textures.aura_icons["Debuff"]))
            end
        end

        -- Zoom animation
        if self._config.animate.debuff then
            if aura.ZoomIn and duration and duration ~= 0 then
                local remain = expiration - GetTime()
                if duration - remain < 0.1 then
                    aura.ZoomIn:Play()
                end
            end
        end

        -- Show cooldown border
        local border_swipe = self._config.cooldown.border_swipe
        if border_swipe and border_swipe.type then
            aura.cd:SetSwipeColor(E:GetRGB(C.global.colors.debuff[debuffType] or C.global.colors.debuff.None))
        end
    else
        aura.Border:SetVertexColor(E:GetRGB(C.global.border.color))
        if self._config.type then
            aura.AuraType:SetTexCoord(unpack(M.textures.aura_icons["Buff"]))
        end

        -- Zoom animation
        if self._config.animate.buff then
            if aura.ZoomIn and duration and duration ~= 0 then
                local remain = expiration - GetTime()
                if duration - remain < 0.1 then
                    aura.ZoomIn:Play()
                end
            end
        end
    end
end

local function element_CreateAuraIcon(self, index)
    local config = self._config
    if not config then
        self:UpdateConfig()
        config = self._config
    end

    local button = E:CreateButton(self, "$parentAura" .. index, true, true, true)

    button.icon = button.Icon
    button.Icon = nil

    local count = button.Count
    count:SetAllPoints()
    count:SetFont(config.count.font or M.fonts.normal, config.count.size, config.count.outline and "OUTLINE" or "")
    count:SetJustifyH(config.count.h_alignment)
    count:SetJustifyV(config.count.v_alignment)
    count:SetWordWrap(false)

    if config.count.shadow then
        count:SetShadowOffset(1, -1)
    else
        count:SetShadowOffset(0, 0)
    end

    button.count = count
    button.Count = nil

    button.cd = button.CD
    button.CD = nil

    if button.cd.UpdateConfig then
        button.cd:UpdateConfig(self.cooldownConfig or {})
        button.cd:UpdateFont()
    end

    button:SetPushedTexture("")
    button:SetHighlightTexture("")

    -- TODO: Update the stealable texture
    local stealable = button.FGParent:CreateTexture(nil, "OVERLAY", nil, 2)
    stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
    stealable:SetTexCoord(2 / 32, 30 / 32, 2 / 32, 30 / 32)
    stealable:SetPoint("TOPLEFT", -1, 1)
    stealable:SetPoint("BOTTOMRIGHT", 1, -1)
    stealable:SetBlendMode("ADD")
    button.stealable = stealable

    if config.type then
        local auraType = button.FGParent:CreateTexture(nil, "OVERLAY", nil, 3)
        auraType:SetTexture("Interface\\AddOns\\LumenUI\\media\\textures\\aura-icons")
        auraType:SetPoint(config.type.position, 2, -2)
        auraType:SetSize(config.type.size, config.type.size)
        button.AuraType = auraType
    end

    if config.cooldown.border_swipe then
        button:SetSize(button:GetWidth() - 2, button:GetWidth() - 2)
        button.Border:SetVertexColor(E:GetRGBA(C.global.colors.black, 0.2))
        button.cd:SetDrawSwipe(true)
        button.cd:SetFrameLevel(3)
        button.cd:SetSwipeTexture("Interface\\BUTTONS\\WHITE8X8")
        button.cd:SetSwipeColor(1, 1, 1, 1)
        button.cd:SetPoint("TOPLEFT", -1.5, 1.5)
        button.cd:SetPoint("BOTTOMRIGHT", 1.5, -1.5)
    end

    -- Create animation for new auras
    if config.animate then
        local ag = button:CreateAnimationGroup()
        local a1 = ag:CreateAnimation("alpha")
        local a2 = ag:CreateAnimation("scale")
        button.ZoomIn = ag

        a1:SetOrder(1)
        a1:SetDuration(0.2)
        a2:SetOrder(1)
        a2:SetDuration(0.2)

        a1:SetFromAlpha(0.5)
        a1:SetToAlpha(1.0)
        a2:SetFromScale(2.25, 2.25)
        a2:SetToScale(1.0, 1.0)
    end

    button.UpdateTooltip = button_UpdateTooltip
    button:SetScript("OnEnter", button_OnEnter)
    button:SetScript("OnLeave", button_OnLeave)

    return button
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.profile.modules.unitframes.units[unit].auras, self._config)

    local size =
        self._config.size_override ~= 0 and self._config.size_override or
        E:Round(
            (C.profile.modules.unitframes.units[unit].width - (self.spacing * (self._config.per_row - 1)) + 2) /
                self._config.per_row
        )
    self._config.size = m_min(m_max(size, 20), 64)
end

local function element_UpdateFont(self)
    local config = self._config.count
    local font = config.font or M.fonts.normal
    local count

    for i = 1, self.createdIcons do
        count = self[i].count
        count:SetFont(font, config.size, config.outline and "OUTLINE" or "")
        count:SetJustifyH(config.h_alignment)
        count:SetJustifyV(config.v_alignment)
        count:SetWordWrap(false)

        if config.shadow then
            count:SetShadowOffset(1, -1)
        else
            count:SetShadowOffset(0, 0)
        end
    end
end

local function element_UpdateSize(self)
    local config = self._config

    self.size = config.size
    self.numTotal = config.per_row * config.rows

    self:SetSize(
        config.size * config.per_row + self.spacing * (config.per_row - 1),
        config.size * config.rows + self.spacing * (config.rows - 1)
    )
end

local function element_UpdatePoints(self)
    local frame = self.__owner
    local config = self._config

    self:ClearAllPoints()

    local point = config.point
    if point and point.p then
        self:SetPoint(point.p, E:ResolveAnchorPoint(self.__owner, point.anchor), point.ap, point.x, point.y)
    end
end

local function element_UpdateCooldownConfig(self)
    if not self.cooldownConfig then
        self.cooldownConfig = {text = {}}
    end

    self.cooldownConfig.exp_threshold = C.profile.modules.unitframes.cooldown.exp_threshold
    self.cooldownConfig.m_ss_threshold = C.profile.modules.unitframes.cooldown.m_ss_threshold
    self.cooldownConfig.text = E:CopyTable(self._config.cooldown.text, self.cooldownConfig.text)

    for i = 1, self.createdIcons do
        if not self[i].cd.UpdateConfig then
            break
        end

        self[i].cd:UpdateConfig(self.cooldownConfig)
        self[i].cd:UpdateFont()
    end
end

local function element_UpdateGrowthDirection(self)
    local config = self._config

    self["growth-x"] = config.x_growth
    self["growth-y"] = config.y_growth

    if config.y_growth == "UP" then
        if config.x_growth == "RIGHT" then
            self.initialAnchor = "BOTTOMLEFT"
        else
            self.initialAnchor = "BOTTOMRIGHT"
        end
    else
        if config.x_growth == "RIGHT" then
            self.initialAnchor = "TOPLEFT"
        else
            self.initialAnchor = "TOPRIGHT"
        end
    end
end

local function element_UpdateAuraTypeIcon(self)
    local config = self._config.type
    local auraType

    for i = 1, self.createdIcons do
        auraType = self[i].AuraType
        auraType:ClearAllPoints()
        auraType:SetPoint(config.position, 0, 0)
        auraType:SetSize(config.size, config.size)
    end
end

local function element_UpdateColors(self)
    self:ForceUpdate()
end

local function element_UpdateMouse(self)
    self.disableMouse = self._config.disable_mouse
end

local function frame_UpdateAuras(self)
    local element = self.Auras
    element:UpdateConfig()
    element:UpdateCooldownConfig()
    element:UpdateSize()
    element:UpdatePoints()
    element:UpdateFont()
    element:UpdateGrowthDirection()
    element:UpdateAuraTypeIcon()
    element:UpdateMouse()

    if element._config.enabled and not self:IsElementEnabled("Auras") then
        self:EnableElement("Auras")
    elseif not element._config.enabled and self:IsElementEnabled("Auras") then
        self:DisableElement("Auras")
    end

    if self:IsElementEnabled("Auras") then
        element:ForceUpdate()
    end
end

function UF:CreateAuras(frame, unit)
    local config = C.profile.modules.unitframes.units[frame._layout or frame._unit].auras

    local element = CreateFrame("Frame", nil, frame)
    element:SetSize(48, 48)

    element.showDebuffType = true
    element.showStealableBuffs = true
    element.spacing = config.spacing or 4
    element.UpdateConfig = element_UpdateConfig
    element.UpdateCooldownConfig = element_UpdateCooldownConfig
    element.UpdateFont = element_UpdateFont
    element.UpdateSize = element_UpdateSize
    element.UpdatePoints = element_UpdatePoints
    element.UpdateGrowthDirection = element_UpdateGrowthDirection
    element.UpdateAuraTypeIcon = element_UpdateAuraTypeIcon
    element.UpdateColors = element_UpdateColors
    element.UpdateMouse = element_UpdateMouse
    element.CreateIcon = element_CreateAuraIcon
    element.PostUpdateIcon = element_PostUpdateIcon
    element.PreSetPosition = element_SortAuras
    element.CustomFilter = UF.filterFunctions[unit] or UF.filterFunctions.default

    frame.UpdateAuras = frame_UpdateAuras
    frame.Auras = element

    return element
end
