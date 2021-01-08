local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local isInit = false

function UF:HasPlayerFrame()
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
    self:UpdatePower()
    -- self:UpdateName()
    -- self:UpdateCastbar()
    self:UpdateUnitIndicator()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end

function UF:CreatePlayerFrame(frame)
  local config = C.modules.unitframes.units[frame._unit]
  local level = frame:GetFrameLevel()

  E.SetBackdrop(frame, 2)
  E.CreateShadow(frame)

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  self:CreateHealthBar(frame, textParent)
  self:CreatePowerBar(frame, textParent)
  -- self:CreateCastbar(frame)
  self:CreateUnitIndicator(frame)

  frame.Update = frame_Update

  isInit = true
end
