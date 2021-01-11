local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- Lua
local _G = getfenv(0)

local UnitFactionGroup = _G.UnitFactionGroup
local UnitIsMercenary = _G.UnitIsMercenary
local UnitIsPVP = _G.UnitIsPVP
local UnitIsPVPFreeForAll = _G.UnitIsPVPFreeForAll

-- TODO: Add Timer Tag?
-- TODO: Change color Alliance, Horde and FFA!

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------
local function element_Override(self, _, unit)
  if unit ~= self.unit then return end

  local element = self.PvPIndicator
  unit = unit or self.unit

  local status
	local factionGroup = UnitFactionGroup(unit) or 'Neutral'

	if UnitIsPVPFreeForAll(unit) then
		status = "FFA"
	elseif factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit) then
		if unit == "player" and UnitIsMercenary(unit) then
			if factionGroup == "Horde" then
				factionGroup = "Alliance"
			elseif factionGroup == "Alliance" then
				factionGroup = "Horde"
			end
		end

		status = factionGroup
  end

  if status then
		element:Show()
	else
    element:Hide()
	end
end

local function element_UpdateConfig(self)
  local unit = self.__owner._unit
  self._config = E:CopyTable(C.modules.unitframes.units[unit].pvp, self._config)
end

local function element_UpdateSize(self)
  self:SetSize(self._config.width, self._config.height)
end

local function element_UpdatePoints(self)
  local frame = self:GetParent()
	local config = self._config.point

  self:ClearAllPoints()

  if config and config.p and config.p ~= "" then
    E:SetPosition(self, config, frame)
	end
end

local function frame_UpdatePvPIndicator(self)
  local element = self.PvPIndicator
  element:UpdateConfig()
  element:UpdateSize()
  element:UpdatePoints()

	if element._config.enabled and not self:IsElementEnabled("PvPIndicator") then
		self:EnableElement("PvPIndicator")
	elseif not element._config.enabled and self:IsElementEnabled("PvPIndicator") then
		self:DisableElement("PvPIndicator")
	end

	if self:IsElementEnabled("PvPIndicator") then
		element:ForceUpdate()
	end
end

function UF:CreatePvPIndicator(frame, parent)
  local element = CreateFrame("StatusBar", nil, (parent or frame))
  element:SetStatusBarTexture(M.textures.flat)
  element:SetOrientation("VERTICAL")

  E.SetBackdrop(element, 2)
  E.CreateShadow(element)

  element.__owner = frame
  element.Override = element_Override
  element.UpdateConfig = element_UpdateConfig
  element.UpdateSize = element_UpdateSize
  element.UpdatePoints = element_UpdatePoints

  frame.UpdatePvPIndicator = frame_UpdatePvPIndicator
  frame.PvPIndicator = element

  return element
end
