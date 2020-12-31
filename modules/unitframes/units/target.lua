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
    self:UpdateHealth()
    self:UpdateName()
    self:UpdatePortrait()
  else
    if self:IsEnabled() then
      self:Disable()
    end
  end
end

local function frame_PostUpdate(self)
  self:UpdateName()
end


function UF:CreateTargetFrame(frame)
  local level = frame:GetFrameLevel()

  local textParent = CreateFrame("Frame", nil, frame)
	textParent:SetFrameLevel(level + 9)
	textParent:SetAllPoints()
  frame.TextParent = textParent

  -- Health
  self:CreateHealthBar(frame)

  -- Name
  self:CreateName(frame, textParent)

  -- Portrait
  self:CreatePortrait(frame)

  E.SetBackdrop(frame, 2)
  E.CreateShadow(frame)

  frame.Update = frame_Update
  frame.PostUpdate = frame_PostUpdate

  isInit = true
end
