local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

local UF = E:GetModule("UnitFrames")

local isInit = false

-- Lua
local _G = getfenv(0)

local UnitIsPlayer = _G.UnitIsPlayer
local UnitReaction = _G.UnitReaction

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
    self:UpdateHealth()
    self:UpdateName()
    self:UpdatePortrait()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end


function UF:CreateTargetFrame(frame)
  local level = frame:GetFrameLevel()

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  E.SetBackdrop(frame, 2)
  E.CreateShadow(frame)

  -- Health
  self:CreateHealthBar(frame)

  -- Name
  self:CreateName(frame, textParent)

  -- Portrait
  self:CreatePortrait(frame)

  frame.Update = frame_Update

  isInit = true
end
