local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local isInit = false

function UF:HasFocusFrame()
	return isInit
end

local function frame_Update(self)
  self:UpdateConfig()

  if self._config.enabled then
    if not self:IsEnabled() then
      self:Enable()
    end

    self:UpdateSize()
    self:UpdateHealth()
    self:UpdateHealthPrediction()
    self:UpdatePower()
    self:UpdateName()
    self:UpdateCastbar()
    self:UpdateAuras()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end

function UF:CreateFocusFrame(frame)
  local config = C.modules.unitframes.units[frame._unit]
  local level = frame:GetFrameLevel()

  E:SetBackdrop(frame, 2)

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  local health = self:CreateHealthBar(frame, textParent)
  self:CreateHealthPrediction(frame, health, textParent)

  self:CreatePowerBar(frame, textParent)
  self:CreateName(frame, textParent)
  self:CreateCastbar(frame)
  self:CreateAuras(frame, "focus")

  frame.Update = frame_Update

  isInit = true
end