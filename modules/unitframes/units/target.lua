local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- Lua
local _G = getfenv(0)

local UnitIsPlayer = _G.UnitIsPlayer
local UnitReaction = _G.UnitReaction

-- ---------------

local UF = E:GetModule("UnitFrames")

local isInit = false

-- ---------------

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
    self:UpdatePower()
    self:UpdateHealth()
    self:UpdateName()
    self:UpdatePortrait()
    self:UpdateUnitIndicator()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end

-- local function frame_PostUpdate(self)
-- end


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
  -- portraitParent:SetPoint(config.portrait.point.p,
  --   E:ResolveAnchorPoint(frame, config.portrait.point.anchor),
  --   config.portrait.point.ap, config.point.x, config.point.y)
  -- portraitParent:SetSize(config.portrait.width, config.portrait.height)
  portraitParent:SetPoint("TOPRIGHT", frame, "TOPLEFT", -6, 0)
  portraitParent:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -6, 0)
  portraitParent:SetWidth(config.portrait.width)
  E.SetBackdrop(portraitParent, 2)
  E.CreateShadow(portraitParent)

  -- Health
  self:CreateHealthBar(frame)

  -- Power
  self:CreatePowerBar(frame)

  -- Name
  self:CreateName(frame, textParent)

  -- Portrait
  self:CreatePortrait(frame, portraitParent)
  self:CreateUnitIndicator(frame, portraitParent)

  frame.Update = frame_Update
  -- frame.PostUpdate = frame_PostUpdate

  isInit = true
end
