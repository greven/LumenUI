local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local isInit = false

function UF:HasTargetTargetFrame()
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
    -- self:UpdateHealthPrediction()
    self:UpdatePower()
    self:UpdateName()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end

function UF:CreateTargetTargetFrame(frame)
  local config = C.modules.unitframes.units[frame._unit]
  local level = frame:GetFrameLevel()

  E.SetBackdrop(frame, 2)
  E.CreateShadow(frame)

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  local health = self:CreateHealthBar(frame, textParent)
  -- CreateHealthPrediction(frame, health, textParent)
  self:CreatePowerBar(frame, textParent)
  self:CreateName(frame, textParent)

  frame.Update = frame_Update

  isInit = true
end
