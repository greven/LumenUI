local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

local UF = E:GetModule("UnitFrames")

-- ---------------

local function UF:CreateHealth(frame, unit)
  local element = CreateFrame("StatusBar", nil, frame)
end
