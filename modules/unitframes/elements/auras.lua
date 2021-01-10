local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

--Lua
local _G = getfenv(0)
local m_max = _G.math.max
local m_min = _G.math.min
local next = _G.next
local select = _G.select
local unpack = _G.unpack

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function element_PostUpdateIcon(self, _, aura, _, _, _, _, debuffType)
	-- if aura.isDebuff then
	-- 	aura.Border:SetVertexColor(E:GetRGB(C.db.global.colors.debuff[debuffType] or C.db.global.colors.debuff.None))

	-- 	if self._config.type.debuff_type then
	-- 		aura.AuraType:SetTexCoord(unpack(M.textures.aura_icons[debuffType] or M.textures.aura_icons["Debuff"]))
	-- 	else
	-- 		aura.AuraType:SetTexCoord(unpack(M.textures.aura_icons["Debuff"]))
	-- 	end
	-- else
	-- 	aura.Border:SetVertexColor(1, 1, 1)
	-- 	aura.AuraType:SetTexCoord(unpack(M.textures.aura_icons["Buff"]))
	-- end
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
	count:SetFont(config.count.font or  M.fonts.normal, config.count.size, config.count.outline and "OUTLINE" or "")
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

	-- if button.cd.UpdateConfig then
	-- 	button.cd:UpdateConfig(self.cooldownConfig or {})
	-- 	button.cd:UpdateFont()
	-- end

	-- button:SetPushedTexture("")
	-- button:SetHighlightTexture("")

	-- local stealable = button.FGParent:CreateTexture(nil, "OVERLAY", nil, 2)
	-- stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
	-- stealable:SetTexCoord(2 / 32, 30 / 32, 2 / 32, 30 / 32)
	-- stealable:SetPoint("TOPLEFT", -1, 1)
	-- stealable:SetPoint("BOTTOMRIGHT", 1, -1)
	-- stealable:SetBlendMode("ADD")
	-- button.stealable = stealable

	-- local auraType = button.FGParent:CreateTexture(nil, "OVERLAY", nil, 3)
	-- auraType:SetTexture("Interface\\AddOns\\ls_UI\\assets\\unit-frame-aura-icons")
	-- auraType:SetPoint(config.type.position, 0, 0)
	-- auraType:SetSize(config.type.size, config.type.size)
	-- button.AuraType = auraType

	-- button.UpdateTooltip = button_UpdateTooltip
	-- button:SetScript("OnEnter", button_OnEnter)
	-- button:SetScript("OnLeave", button_OnLeave)

	return button
end

local function element_UpdateConfig(self)
	local unit = self.__owner._unit
  self._config = E:CopyTable(C.modules.unitframes.units[unit].auras, self._config)

  local size = self._config.size_override ~= 0 and self._config.size_override
  or E:Round((C.modules.unitframes.units[unit].width - (self.spacing * (self._config.per_row - 1)) + 2) / self._config.per_row)
self._config.size = m_min(m_max(size, 24), 64)
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

	self:SetSize(config.size * config.per_row + self.spacing * (config.per_row - 1), config.size * config.rows + self.spacing * (config.rows - 1))
end

local function element_UpdatePoints(self)
	local config = self._config.point

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
  -- element:UpdateCooldownConfig()
	element:UpdateFont()
  element:UpdateSize()
  element:UpdatePoints()
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
  local element = CreateFrame("Frame", nil, frame)
  element:SetSize(48, 48)

  element.UpdateConfig = element_UpdateConfig
  -- element.UpdateCooldownConfig = element_UpdateCooldownConfig
  element.UpdateFont = element_UpdateFont
  element.UpdateSize = element_UpdateSize
  element.UpdatePoints = element_UpdatePoints
  element.UpdateGrowthDirection = element_UpdateGrowthDirection
  element.UpdateAuraTypeIcon = element_UpdateAuraTypeIcon
  element.UpdateColors = element_UpdateColors
  element.UpdateMouse = element_UpdateMouse
  element.spacing = 4
  element.showDebuffType = true
  element.showStealableBuffs = true
  element.CreateIcon = element_CreateAuraIcon
	element.PostUpdateIcon = element_PostUpdateIcon
	-- element.CustomFilter = filterFunctions[unit] or filterFunctions.default

  frame.UpdateAuras = frame_UpdateAuras
  frame.Auras = element

  return element
end
