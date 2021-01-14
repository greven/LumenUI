local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- Lua
local _G = getfenv(0)
local UnitIsPlayer = _G.UnitIsPlayer
local UnitReaction = _G.UnitReaction

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local isInit = false

function UF:HasTargetFrame()
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
    self:UpdateHealthPrediction()
    self:UpdatePower()
    self:UpdateName()
    self:UpdateCastbar()
    self:UpdatePortrait()
    self:UpdateAuras()
    self:UpdateUnitIndicator()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end

function UF:CreateTargetFrame(frame)
  local config = C.modules.unitframes.units[frame._unit]
  local level = frame:GetFrameLevel()

  E.SetBackdrop(frame, 2)
  E.CreateShadow(frame)

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  local portraitParent = CreateFrame("Frame", nil, frame)
  portraitParent:SetSize(config.portrait.width, config.portrait.height)
  E:SetPosition(portraitParent, config.portrait.point, frame)
  E.SetBackdrop(portraitParent, 2)
  E.CreateShadow(portraitParent)

  local health = self:CreateHealthBar(frame, textParent)
  self:CreateHealthPrediction(frame, health, textParent)
  self:CreatePowerBar(frame, textParent)
  self:CreateName(frame, textParent)
  self:CreatePortrait(frame, portraitParent)
  self:CreateCastbar(frame)
  self:CreateAuras(frame, "target")
  self:CreateUnitIndicator(frame, portraitParent)

  -- Level and Race
  local info = textParent:CreateFontString(nil, "ARTWORK")
  info:SetFont(M.fonts.condensed, 14, "OUTLINE")
  info:SetTextColor(E:GetRGB(C.colors.light_gray))
  info:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 0, 5)
  frame:Tag(info, "[lum:color_difficulty][lum:level]|r [lum:race] [lum:color_unit][lum:class]")

  frame.Update = frame_Update

  isInit = true
end
