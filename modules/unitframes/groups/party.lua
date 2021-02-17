local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local isInit = false

function UF:HasPartyFrame()
  return isInit
end

local function frame_Update(self)
  self:UpdateConfig()
  if self._config.enabled then
    self:UpdateHealth()
    self:UpdatePower()
    self:UpdateHealthPrediction()
    self:UpdateName()
    self:UpdateRaidTargetIndicator()
    self:UpdateThreatIndicator()
  end
end

function UF:CreatePartyFrame(frame)
  local config = C.db.profile.unitframes.units[frame._layout or frame._unit]
  local level = frame:GetFrameLevel()

  local textParent = CreateFrame("Frame", nil, frame)
  textParent:SetFrameLevel(level + 9)
  textParent:SetAllPoints()
  frame.TextParent = textParent

  local health = self:CreateHealthBar(frame, textParent)
  local power = self:CreatePowerBar(frame, textParent, C.db.global.statusbar.texture)

  self:CreateHealthPrediction(frame, health, textParent)

  self:CreateName(frame, textParent)
  self:CreateRaidTargetIndicator(frame)
  self:CreateThreatIndicator(frame)

  frame.Update = frame_Update

  isInit = true
end
