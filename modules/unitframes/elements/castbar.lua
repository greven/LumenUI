local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

--Lua
local _G = getfenv(0)
local m_abs = _G.math.abs

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function element_UpdateConfig(self)
  local unit = self.__owner._unit
  self._config = E:CopyTable(C.modules.unitframes.units[unit].castbar, self._config)
end

local function frame_UpdateCastbar(self)
  print("frame_UpdateCastbar")
	local element = self.Castbar
	element:UpdateConfig()
	-- element:UpdateSize()
	-- element:UpdateIcon()
	-- element:UpdateLatency()
	-- element:UpdateFonts()

	-- if element._config.enabled and not self:IsElementEnabled("Castbar") then
	-- 	self:EnableElement("Castbar")
	-- elseif not element._config.enabled and self:IsElementEnabled("Castbar") then
	-- 	self:DisableElement("Castbar")

	-- 	if self._unit == "player" then
	-- 		CastingBarFrame_SetUnit(CastingBarFrame, nil)
	-- 		CastingBarFrame_SetUnit(PetCastingBarFrame, nil)
	-- 	end
	-- end

	-- if self:IsElementEnabled("Castbar") then
	-- 	element:ForceUpdate()
	-- end
end

function UF:CreateCastbar(frame)
  local config = C.modules.unitframes.units[frame._unit].castbar

  local holder = CreateFrame("Frame", "$parentCastbarHolder", frame)
  holder._width = 0

	local element = CreateFrame("StatusBar", nil, holder)
	element:SetStatusBarTexture(C.global.statusbar.texture)
  element:SetFrameLevel(holder:GetFrameLevel())

  local bg = element:CreateTexture(nil, "BACKGROUND", nil)
  bg:SetAllPoints(holder)
  bg:SetTexture(M.textures.vertlines)
  bg:SetAlpha(0.4)
  bg.multiplier = 0.3

  local safeZone = element:CreateTexture(nil, "ARTWORK", nil, 1)
	safeZone:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	safeZone:SetVertexColor(E:GetRGBA(C.colors.red, 0.6))
  element.SafeZone_ = safeZone

  local texParent = CreateFrame("Frame", nil, element)
	texParent:SetPoint("TOPLEFT", holder, "TOPLEFT", 3, 0)
	texParent:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -3, 0)
  element.TexParent = texParent

  local time = texParent:CreateFontString(nil, "ARTWORK")
	time:SetWordWrap(false)
	time:SetPoint("TOP", element, "TOP", 0, 0)
	time:SetPoint("BOTTOM", element, "BOTTOM", 0, 0)
	time:SetPoint("RIGHT", element, "RIGHT", 0, 0)
  element.Time = time

  local text = texParent:CreateFontString(nil, "ARTWORK")
	text:SetWordWrap(false)
	text:SetJustifyH("LEFT")
	text:SetPoint("TOP", element, "TOP", 0, 0)
	text:SetPoint("BOTTOM", element, "BOTTOM", 0, 0)
	text:SetPoint("LEFT", element, "LEFT", 2, 0)
	text:SetPoint("RIGHT", time, "LEFT", -2, 0)
  element.Text = text

  element.Holder = holder
	-- element.CustomDelayText = element_CustomDelayText
	-- element.CustomTimeText = element_CustomTimeText
	-- element.PostCastFail = element_PostCastFail
	-- element.PostCastStart = element_PostCastStart
	-- element.timeToHold = 0.4
	element.UpdateConfig = element_UpdateConfig
	-- element.UpdateFonts = element_UpdateFonts
	-- element.UpdateIcon = element_UpdateIcon
	-- element.UpdateLatency = element_UpdateLatency
	-- element.UpdateSize = element_UpdateSize

  frame.UpdateCastbar = frame_UpdateCastbar
  frame.Castbar = element

	return element
end
