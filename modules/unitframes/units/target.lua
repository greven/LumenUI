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
    self:UpdatePower()
    self:UpdateName()
    self:UpdatePortrait()
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

  self:CreateHealthBar(frame, textParent)
  self:CreatePowerBar(frame, textParent)
  self:CreateName(frame, textParent)
  self:CreatePortrait(frame, portraitParent)
  self:CreateUnitIndicator(frame, portraitParent)

  frame.Update = frame_Update

  isInit = true
end
