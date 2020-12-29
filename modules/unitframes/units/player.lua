local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

local UF = E:GetModule("UnitFrames")

-- ---------------

function UF:CreatePlayerFrame(frame, unit)
  if not unit then return end

  local cfg = C.modules.unitframes.units[unit]
end
