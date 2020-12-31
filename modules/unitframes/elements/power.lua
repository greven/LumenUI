local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

-- Power Bar
do

  function UF:CreatePowerBar(frame)
    local element = CreateFrame("StatusBar", nil, frame)
  end
end
