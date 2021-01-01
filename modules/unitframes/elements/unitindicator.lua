local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function update(self)
  if not (self.unit and self:IsShown()) then return end

  local element = self.UnitIndicator
  element:SetStatusBarColor(E:GetUnitColor("target"))
end

local function element_UpdateConfig(self)
  -- local unit = self.__owner._unit
  -- self._config = E:CopyTable(C.modules.unitframes.units[unit], self._config)
end

local function element_UpdateSize(self)
  local frame = self:GetParent()
  local config = self._config

  -- self:SetWidth(config.width)
  self:SetSize(3, 28)
  self:SetPoint("RIGHT", frame, "LEFT", -6, 0)
  -- colorInfo:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -6, 0)
  -- self:SetPoint(config.point.p, E:ResolveAnchorPoint(frame, config.point.anchor),
  --   config.point.ap, config.point.x, config.point.y)
  -- self:ForceUpdate()
end

local function frame_UpdateUnitIndicator(self)
  local element = self.UnitIndicator
  element:UpdateConfig()
  -- element:UpdateColors()
  element:UpdateSize()
end

function UF:CreateUnitIndicator(frame, parent)
  local element = CreateFrame("StatusBar", nil, (parent or frame))
  element:SetStatusBarTexture(M.textures.backdrop)
  element:SetOrientation("VERTICAL")

  E.SetBackdrop(element, 2)
  E.CreateShadow(element)

  hooksecurefunc(frame, "Show", update)

  element.UpdateConfig = element_UpdateConfig
  element.UpdateSize = element_UpdateSize

  frame.UpdateUnitIndicator = frame_UpdateUnitIndicator
  frame.UnitIndicator = element
end
