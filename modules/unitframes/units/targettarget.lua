local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

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
    if self._config.visibility then
      -- self:Disable()
      -- RegisterAttributeDriver(self, "state-visibility", self._config.visibility)
    elseif not self:IsEnabled() then
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

  E:SetBackdrop(frame, 2)

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  local health = self:CreateHealthBar(frame, textParent)
  -- self:CreateHealthPrediction(frame, health, textParent)

  self:CreatePowerBar(frame, textParent)
  self:CreateName(frame, textParent)

  -- Arrow indicator
  local arrow = frame:CreateTexture(nil, "ARTWORK")
  arrow:SetSize(18, 18)
  arrow:SetPoint("RIGHT", frame, "LEFT", -10, 0)
  arrow:SetTexture(C.media.textures.arrow)
  arrow:SetVertexColor(0, 0, 0)
  arrow:SetAlpha(0.8)
  frame.arrow = arrow

  frame.Update = frame_Update

  isInit = true
end
