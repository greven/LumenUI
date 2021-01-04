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

  if config.style == "2D" then
    self:SetDesaturation(config.desaturation)
    self:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  else -- 3D
    self:SetDesaturation(config.desaturation)
    self:SetModelAlpha(config.modelAlpha)
    self:SetCamDistanceScale(0.8)
    self:SetPortraitZoom(1)
  end
end

local function frame_UpdatePortrait(self)
  if C.modules.unitframes.units[self._unit].portrait.style == "2D" then
    self.Portrait = self.Portrait2D
    self.Portrait3D:ClearAllPoints()
    self.Portrait3D:Hide()
  else
    self.Portrait = self.Portrait3D
    self.Portrait2D:ClearAllPoints()
    self.Portrait2D:Hide()
  end

  self.Portrait3D.__owner = self.Portrait2D.__owner
	self.Portrait3D.ForceUpdate = self.Portrait2D.ForceUpdate

  local element = self.Portrait
  element:UpdateConfig()
  element:Hide()

  if element._config.enabled and not self:IsElementEnabled("Portrait") then
    self:EnableElement("Portrait")
  elseif not element._config.enabled and self:IsElementEnabled("Portrait") then
		self:DisableElement("Portrait")
  end

  if self:IsElementEnabled("Portrait") then
    element:SetInside()

    element:Show()
	  element:ForceUpdate()
  end
end

function UF:CreatePortrait(frame, parent)
  frame.Portrait2D = (parent or frame):CreateTexture(nil, "ARTWORK")
  frame.Portrait2D.UpdateConfig = element_UpdateConfig
  frame.Portrait2D.PostUpdate = element_PostUpdate
  frame.Portrait = frame.Portrait2D

	frame.Portrait3D = CreateFrame("PlayerModel", nil, parent or frame)
	frame.Portrait3D.UpdateConfig = element_UpdateConfig
  frame.Portrait3D.PostUpdate = element_PostUpdate

  frame.UpdatePortrait = frame_UpdatePortrait
	return frame.Portrait2D
end
