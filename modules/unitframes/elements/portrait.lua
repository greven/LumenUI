local _, ns = ...
local E, C = ns.E, ns.C

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function element_UpdateConfig(self)
  local unit = self.__owner._unit
	self._config = E:CopyTable(C.modules.unitframes.units[unit].portrait, self._config)
end

local function element_PostUpdate(self)
  local config = self._config
  self:SetModelAlpha(config.modelAlpha)
  self:SetDesaturation(config.desaturation)
end

local function frame_UpdatePortrait(self)
  local element = self.Portrait

  element:UpdateConfig()
  element:Hide()

  if element._config.enabled and not self:IsElementEnabled("Portrait") then
    self:EnableElement("Portrait")
    print("HERE")
  elseif not element._config.enabled and self:IsElementEnabled("Portrait") then
		self:DisableElement("Portrait")
  end

  if self:IsElementEnabled("Portrait") then
    element:SetInside()
    element:SetDesaturation(element._config.desaturation)

    element:Show()
		element:ForceUpdate()
  end
end

function UF:CreatePortrait(frame, parent)
  frame.Portrait = CreateFrame("PlayerModel", nil, parent or frame)

  frame.Portrait.UpdateConfig = element_UpdateConfig
  frame.Portrait.PostUpdate = element_PostUpdate

  frame.UpdatePortrait = frame_UpdatePortrait

	return frame.Portrait
end
