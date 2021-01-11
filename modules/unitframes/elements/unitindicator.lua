local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- Lua
local _G = getfenv(0)

local UnitPlayerControlled = _G.UnitPlayerControlled
local IsResting = _G.IsResting

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function update(self)
  if not (self.unit and self:IsShown()) then return end

  local element = self.UnitIndicator
  local config = element._config

  local inCombat = UnitAffectingCombat(self.unit)
  local isResting = IsResting()

  if self.unit == "player" then
    if inCombat then
      element:SetStatusBarColor(E:GetRGB(C.colors.red))
    elseif isResting then
      element:SetStatusBarColor(E:GetRGB(C.colors.cyan))
    else
      element:SetStatusBarColor(E:GetRGB(E:GetUnitColor(self.unit, true, true)))
    end
  elseif UnitPlayerControlled(self.unit) then
    if inCombat then
      element:SetStatusBarColor(E:GetRGB(C.colors.red))
    else
      element:SetStatusBarColor(E:GetRGB(E:GetUnitColor(self.unit, true, true)))
    end
  else -- NPCs
    if inCombat then
      element:SetStatusBarColor(E:GetRGB(E:GetUnitReactionColor("target")))
    else
      element:SetStatusBarColor(E:GetRGB(E:GetUnitColor(self.unit, true, true)))
    end
  end

  if config and config.hide_out_of_combat then
    if inCombat or isResting then
      element:Show()
    else
      element:Hide()
    end
  end
end

local function element_UpdateConfig(self)
  local unit = self.__owner._unit
  self._config = E:CopyTable(C.modules.unitframes.units[unit].unitIndicator, self._config)
end

local function element_UpdateSize(self)
  local frame = self:GetParent()
  local config = self._config

  self:SetSize(config.width, config.height)
  E:SetPosition(self, config.point, frame)
end

local function frame_UpdateUnitIndicator(self)
  local element = self.UnitIndicator
  element:UpdateConfig()
  element:UpdateSize()
  update(self)
end

function UF:CreateUnitIndicator(frame, parent)
  local element = CreateFrame("StatusBar", nil, (parent or frame))
  element:SetStatusBarTexture(M.textures.flat)
  element:SetOrientation("VERTICAL")

  E.SetBackdrop(element, 2)
  E.CreateShadow(element)

  hooksecurefunc(frame, "Show", update)

  element.__owner = frame
  element.UpdateConfig = element_UpdateConfig
  element.UpdateSize = element_UpdateSize

  frame.UpdateUnitIndicator = frame_UpdateUnitIndicator
  frame.UnitIndicator = element

  return element
end
