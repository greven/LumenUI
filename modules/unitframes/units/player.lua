local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

local UF = E:GetModule("UnitFrames")

local isInit = false

-- ---------------

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
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end


function UF:CreatePlayerFrame(frame)
  E.SetBackdrop(frame, 2)

  -- Health
  local health = UF:CreateHealthBar(frame)

  frame.Update = frame_Update

  isInit = true
end
