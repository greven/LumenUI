local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

local UF = E:AddModule("UnitFrames")

local isInit = false

local cfg = C.modules.unitframes

-- ---------------

local objects = {}
local units = {}

function UF:CreateUnitFrame(unit, name)
  if not units[unit] then
    if unit == "boss" then
      -- Boss spawning here
    else
      local object = oUF:Spawn(unit, name .. "Frame")
			objects[unit] = object
    end
  end
end

function UF:UpdateUnitFrame(unit, method, ...)
end

function UF:IsInit()
	return isInit
end

function UF:Init()
  if not isInit and cfg.enabled then
    oUF:Factory(function()
      oUF:RegisterStyle("Lumen", function(frame, unit)
        if unit == "player" then
          UF:CreatePlayerFrame(frame, unit)
        end
      end)
    end)
    oUF:SetActiveStyle("Lumen")

    if cfg.units.player.enabled then
      UF:CreateUnitFrame("player", "LumenPlayer")
    end

    isInit = true
  end
end

function UF:Update()
	if isInit then
		for unit in next, units do
			self:UpdateUnitFrame(unit, "Update")
		end
	end
end
