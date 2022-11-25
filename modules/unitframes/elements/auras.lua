local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local m_max = _G.math.max
local m_min = _G.math.min
local m_huge = _G.math.huge
local t_sort = _G.table.sort
local next = _G.next
local select = _G.select
local unpack = _G.unpack

-- Blizz
local CreateFrame = _G.CreateFrame
local GetTime = _G.GetTime
local UnitIsFriend = _G.UnitIsFriend

-- ---------------

local MOUNTS = {}

for _, id in next, C_MountJournal.GetMountIDs() do
    MOUNTS[select(2, C_MountJournal.GetMountInfoByID(id))] = true
end

UF.filterFunctions = {
    -- default = function(self, unit, aura, name, _, count, debuffType, duration, expiration, caster, isStealable, _,
    --     spellID, _, isBossAura)
    --     local config = self._config and self._config.filter or nil
    --     if not config then
    --         return
    --     end

    --     aura.name = name
    --     aura.spell = name
    --     aura.spellID = spellID
    --     aura.dtype = debuffType
    --     aura.expiration = expiration
    --     aura.duration = duration
    --     aura.noTime = duration == 0 and expiration == 0
    --     aura.isStealable = isStealable
    --     aura.canDispell = (not aura.isDebuff and isStealable) or
    --                           (aura.isDebuff and debuffType and E:IsDispellable(debuffType))

    --     -- black and whitelists
    --     for filter, enabled in next, config.custom do
    --         if enabled then
    --             if filter == "Class Buffs" or filter == "Class Debuffs" then
    --                 filter = C.db.global.aura_filters[filter][E.PLAYER_CLASS]
    --             else
    --                 filter = C.db.global.aura_filters[filter]
    --             end

    --             if filter and filter[spellID] then
    --                 if filter.onlyShowPlayer then
    --                     if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
    --                         return filter.state
    --                     end
    --                 else
    --                     return filter.state
    --                 end
    --             end
    --         end
    --     end

    --     local isFriend = UnitIsFriend("player", unit)

    --     config = isFriend and config.friendly or config.enemy
    --     if not config then
    --         return
    --     end

    --     config = aura.isDebuff and config.debuff or config.buff
    --     if not config then
    --         return
    --     end

    --     -- boss
    --     isBossAura = isBossAura or E:IsUnitBoss(caster)
    --     if isBossAura then
    --         return config.boss
    --     end

    --     -- applied by tank
    --     if caster and E:IsUnitTank(caster) then
    --         return config.tank
    --     end

    --     -- applied by healer
    --     if caster and E:IsUnitTank(caster) then
    --         return config.healer
    --     end

    --     -- mounts
    --     if MOUNTS[spellID] then
    --         return config.mount
    --     end

    --     -- self-cast
    --     if caster and UnitIsUnit(unit, caster) then
    --         if duration and duration ~= 0 then
    --             return config.selfcast
    --         else
    --             return config.selfcast and config.selfcast_permanent
    --         end
    --     end

    --     -- applied by player
    --     if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
    --         if duration and duration ~= 0 then
    --             return config.player
    --         else
    --             return config.player and config.player_permanent
    --         end
    --     end

    --     if isFriend then
    --         if aura.isDebuff then
    --             -- dispellable
    --             if debuffType and E:IsDispellable(debuffType) then
    --                 return config.dispellable
    --             end
    --         end
    --     else
    --         -- stealable
    --         if isStealable then
    --             return config.dispellable
    --         end
    --     end

    --     return config.misc
    -- end,

    -- boss = function(self, unit, aura, name, _, count, debuffType, duration, expiration, caster, isStealable, _, spellID,
    --     _, isBossAura)
    --     local config = self._config and self._config.filter or nil
    --     if not config then
    --         return
    --     end

    --     aura.name = name
    --     aura.spell = name
    --     aura.spellID = spellID
    --     aura.dtype = debuffType
    --     aura.expiration = expiration
    --     aura.duration = duration
    --     aura.noTime = duration == 0 and expiration == 0
    --     aura.isStealable = isStealable
    --     aura.canDispell = (not aura.isDebuff and isStealable) or
    --                           (aura.isDebuff and debuffType and E:IsDispellable(debuffType))

    --     -- black and whitelists
    --     for filter, enabled in next, config.custom do
    --         if enabled then
    --             filter = C.db.global.aura_filters[filter]
    --             if filter and filter[spellID] then
    --                 if filter.onlyShowPlayer then
    --                     if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
    --                         return filter.state
    --                     end
    --                 else
    --                     return filter.state
    --                 end
    --             end
    --         end
    --     end

    --     local isFriend = UnitIsFriend("player", unit)

    --     config = isFriend and config.friendly or config.enemy
    --     if not config then
    --         return
    --     end

    --     config = aura.isDebuff and config.debuff or config.buff
    --     if not config then
    --         return
    --     end

    --     -- boss
    --     isBossAura = isBossAura or E:IsUnitBoss(caster)
    --     if isBossAura then
    --         return config.boss
    --     end

    --     -- applied by tank
    --     if caster and E:IsUnitTank(caster) then
    --         return config.tank
    --     end

    --     -- applied by healer
    --     if caster and E:IsUnitTank(caster) then
    --         return config.healer
    --     end

    --     -- applied by player
    --     if aura.isPlayer or (caster and UnitIsUnit(caster, "pet")) then
    --         if duration and duration ~= 0 then
    --             return config.player
    --         else
    --             return config.player and config.player_permanent
    --         end
    --     end

    --     if isFriend then
    --         if aura.isDebuff then
    --             -- dispellable
    --             if debuffType and E:IsDispellable(debuffType) then
    --                 return config.dispellable
    --             end
    --         end
    --     else
    --         -- stealable
    --         if isStealable then
    --             return config.dispellable
    --         end
    --     end

    --     return config.misc
    -- end
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

local function element_PostUpdateButton(self, button, unit, data)
    if button.isHarmful then
		button.Border:SetVertexColor(E:GetRGB(C.db.global.colors.debuff[data.dispelName] or C.db.global.colors.debuff.None))

		if self._config.type.enabled then
			if UnitIsFriend("player", unit) then
				button.AuraType:SetTexCoord(unpack(M.textures.aura_icons[data.dispelName] or M.textures.aura_icons.Debuff))
			else
				button.AuraType:SetTexCoord(unpack(M.textures.aura_icons.Debuff))
			end
		end
	else
		-- "" is enrage, it's a legit buff dispelName
		button.Border:SetVertexColor(E:GetRGB(C.db.global.colors.buff[data.dispelName] or C.db.global.colors.white))

		if self._config.type.enabled then
			if not UnitIsFriend("player", unit) then
				button.AuraType:SetTexCoord(unpack(M.textures.aura_icons[data.dispelName] or M.textures.aura_icons.Buff))
			else
				button.AuraType:SetTexCoord(unpack(M.textures.aura_icons.Buff))
			end
		end
	end
end

local function element_CreateButton(self, index)
    local config = self._config
    if not config then
        self:UpdateConfig()
        config = self._config
    end

    local button = E:CreateButton(self, "$parentAura" .. index, true, true, true)
    button:SetScript("OnEnter", button_OnEnter)
    button:SetScript("OnLeave", button_OnLeave)

    local count = button.Count
    count:SetFont(config.count.font or M.fonts.normal, config.count.size, config.count.outline and "OUTLINE" or "")
    count:SetJustifyH(config.count.h_alignment)
    count:SetJustifyV(config.count.v_alignment)
    count:SetWordWrap(false)
    count:SetAllPoints()

    -- if button.Cooldown.UpdateConfig then
	-- 	button.Cooldown:UpdateConfig(self.cooldownConfig or {})
	-- 	button.Cooldown:UpdateFont()
	-- 	button.Cooldown:UpdateSwipe()
	-- end

    button:SetPushedTexture(0)
	button:SetHighlightTexture(0)

	-- local stealable = button.TextureParent:CreateTexture(nil, "OVERLAY", nil, 2)
	-- stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
	-- stealable:SetTexCoord(2 / 32, 30 / 32, 2 / 32, 30 / 32)
	-- stealable:SetPoint("TOPLEFT", -1, 1)
	-- stealable:SetPoint("BOTTOMRIGHT", 1, -1)
	-- stealable:SetBlendMode("ADD")
	-- button.Stealable = stealable

	-- local auraType = button.TextureParent:CreateTexture(nil, "OVERLAY", nil, 3)
	-- auraType:SetTexture("Interface\\AddOns\\ls_UI\\assets\\unit-frame-aura-icons")
	-- auraType:SetPoint(config.type.position, 0, 0)
	-- auraType:SetSize(config.type.size, config.type.size)
	-- auraType:SetShown(config.type.enabled)
	-- button.AuraType = auraType

    return button
end

local function element_UpdateConfig(self)
    local unit = self.__owner._unit or self.__owner._layout
    self._config = E:CopyTable(C.db.profile.unitframes.units[unit].auras, self._config)

    local size = self._config.size_override ~= 0 and self._config.size_override or
                     E:Round((C.db.profile.unitframes.units[unit].width - (self.spacing * (self._config.per_row - 1)) +
                                 2) / self._config.per_row)
    self._config.size = m_min(m_max(size, 20), 64)
end

local function element_UpdateCooldownConfig(self)
    if not self.cooldownConfig then
        self.cooldownConfig = {
            swipe = {},
            text = {}
        }
    end

    self.cooldownConfig = E:CopyTable(C.db.profile.unitframes.cooldown, self.cooldownConfig)
	self.cooldownConfig.text = E:CopyTable(self._config.cooldown.text, self.cooldownConfig.text)

    for i = 1, self.createdButtons do
		if not self[i].Cooldown.UpdateConfig then
			break
		end

		self[i].Cooldown:UpdateConfig(self.cooldownConfig)
		self[i].Cooldown:UpdateFont()
		self[i].Cooldown:UpdateSwipe()
	end

    -- self.cooldownConfig.exp_threshold = C.db.profile.unitframes.cooldown.exp_threshold
    -- self.cooldownConfig.m_ss_threshold = C.db.profile.unitframes.cooldown.m_ss_threshold
    -- self.cooldownConfig.text = E:CopyTable(self._config.cooldown.text, self.cooldownConfig.text)

    -- for i = 1, self.createdButtons do
    --     if not self[i].Cooldown.UpdateConfig then
    --         break
    --     end

    --     self[i].Cooldown:UpdateConfig(self.cooldownConfig)
    --     self[i].Cooldown:UpdateFont()
    -- end
end

local function element_UpdateFont(self)
    local config = self._config.count
    local font = config.font or M.fonts.normal
    local count

    for i = 1, self.createdButtons do
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

    self:SetSize(config.size * config.per_row + self.spacing * (config.per_row - 1),
        config.size * config.rows + self.spacing * (config.rows - 1))
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

    for i = 1, self.createdButtons do
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
    local config = C.db.profile.unitframes.units[frame._layout or frame._unit].auras

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
    element.CreateButton = element_CreateButton
    element.PostUpdateButton = element_PostUpdateButton
    element.PreSetPosition = element_SortAuras
    -- element.FilterAura = UF.filterFunctions[unit] or UF.filterFunctions.default

    frame.UpdateAuras = frame_UpdateAuras
    frame.Auras = element

    return element
end
