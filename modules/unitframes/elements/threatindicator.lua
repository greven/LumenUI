local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- Lua
local _G = getfenv(0)

local IsInGroup = _G.IsInGroup
local UnitExists = _G.UnitExists

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function element_UpdateConfig(self)
	local unit = self.__owner._unit
	self._config = E:CopyTable(C.modules.unitframes.units[unit].threat, self._config)
end

local function element_Override(self, event, unit)
  if unit ~= self.unit or not IsInGroup() then return end

  local element = self.ThreatIndicator

  if(element.PreUpdate) then element:PreUpdate(unit) end

  local feedbackUnit = element.feedbackUnit
  unit = unit or self.unit

  local status
  if UnitExists(unit) then
		if feedbackUnit and feedbackUnit ~= unit and UnitExists(feedbackUnit) then
			status = UnitThreatSituation(feedbackUnit, unit)
		else
			status = UnitThreatSituation(unit)
		end
  end

  local r, g, b
	if status and status > 0 then
		r, g, b = unpack(self.colors.threat[status])

		if element.SetVertexColor then
			element:SetVertexColor(r, g, b)
    end

    element.glow:SetVertexColor(element:GetVertexColor())
    element.glow:Show()

		element:Show()
	else
    element:Hide()
    element.glow:Hide()
  end

  if(element.PostUpdate) then
		return element:PostUpdate(unit, status, r, g, b)
	end

	-- if status and status == 0 then
  --   self:SetVertexColor(E:GetRGB(C.colors.threat[1]))
	-- 	self:Show()
  -- end

  -- if status and status > 0 then
  --   self.glow:SetVertexColor(self:GetVertexColor())
  --   self.glow:Show()
  -- else
  --   self.glow:Hide()
  -- end
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

  local glow = E:CreateGlow(parent or frame, 8)
  element.glow = glow

	element.Override = element_Override
	element.UpdateConfig = element_UpdateConfig

  frame.UpdateThreatIndicator = frame_UpdateThreatIndicator

  frame.ThreatIndicator = element

	return element
end
