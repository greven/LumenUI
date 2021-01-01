local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function update(self)
  if not (self.unit and self:IsShown()) then return end

  local element = self.Name
  -- element:SetTextColor(E:GetUnitColor(self.unit))
  element.bg:SetVertexColor(E:GetUnitColor(self.unit))
end

local function updateTextPoint(frame, fontString, config)
  if config and config.p and config.p ~= "" then
		fontString:SetPoint(config.p, E:ResolveAnchorPoint(frame, config.anchor), config.ap, config.x, config.y)
  end
end

local function updateTexturePoint(frame, bg, config)
  if bg and config and config.p and config.p ~= "" then
    bg:SetPoint(config.p, E:ResolveAnchorPoint(frame, config.anchor), config.ap, config.x, config.y)
  end
end

local function element_UpdateConfig(self)
	local unit = self.__owner._unit
	self._config = E:CopyTable(C.modules.unitframes.units[unit].name, self._config)
end

local function element_UpdateFonts(self)
  local config = self._config

  self:SetFont(C.global.fonts.units.font, config.size, config.outline and "OUTLINE" or nil)
  self:SetJustifyH(config.h_alignment)
  self:SetJustifyV(config.v_alignment)
  self:SetWordWrap(config.word_wrap)
end

local function element_UpdatePoints(self)
  local config = self._config

  self:ClearAllPoints()
  updateTextPoint(self.__owner, self, config.point)
  updateTexturePoint(self.__owner, self.bg, config.background.point)
end

local function element_UpdateTags(self)
	if self._config.tag ~= "" then
		self.__owner:Tag(self, self._config.tag)
		self:UpdateTag()
	else
		self.__owner:Untag(self)
		self:SetText("")
	end
end

local function element_UpdateTexture(self)
  local config = self._config.background

  if config.enabled and config.texture ~= "" then
    self.bg:SetTexture(config.texture)
    self.bg:SetSize(config.width, config.height)
    self.bg:SetAlpha((config.alpha and config.alpha) or 0.1)
  end
end

local function frame_UpdateName(self)
	local element = self.Name
	element:UpdateConfig()
	element:UpdateFonts()
  element:UpdateTexture()
	element:UpdatePoints()
  element:UpdateTags()
end

function UF:CreateName(frame, textParent)
  local element = E.CreateString((textParent or frame))
  element.bg = frame:CreateTexture(nil, "BACKGROUND")

  hooksecurefunc(frame, "Show", update)

  element.__owner = frame
  element.UpdateConfig = element_UpdateConfig
  element.UpdateFonts = element_UpdateFonts
  element.UpdatePoints = element_UpdatePoints
  element.UpdateTags = element_UpdateTags
  element.UpdateTexture = element_UpdateTexture

  frame.UpdateName = frame_UpdateName
  frame.Name = element

  return element
end
