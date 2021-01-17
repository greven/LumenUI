local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function element_UpdateConfig(self)
	local unit = self.__owner._unit
	self._config = E:CopyTable(C.modules.unitframes.units[unit].threat, self._config)
end

local function element_PostUpdate(self, _, status)
	if status and status == 0 then
    self:SetVertexColor(E:GetRGB(C.colors.threat[1]))
		self:Show()
	end
end

local function frame_UpdateThreatIndicator(self)
	local element = self.ThreatIndicator
	element:UpdateConfig()

	element.feedbackUnit = element._config.feedback_unit

	if element._config.enabled and not self:IsElementEnabled("ThreatIndicator") then
		self:EnableElement("ThreatIndicator")
	elseif not element._config.enabled and self:IsElementEnabled("ThreatIndicator") then
		self:DisableElement("ThreatIndicator")
	end

	if self:IsElementEnabled("ThreatIndicator") then
		element:ForceUpdate()
	end
end

function UF:CreateThreatIndicator(frame, parent)
  local element = E:CreateBorder(parent or frame)
  element:SetTexture(M.textures.border_glow, "BACKGROUND", -7)
  element:SetOffset(-6)
  element:SetSize(16)

	element.PostUpdate = element_PostUpdate
	element.UpdateConfig = element_UpdateConfig

  frame.UpdateThreatIndicator = frame_UpdateThreatIndicator

  frame.ThreatIndicator = element

	return element
end
