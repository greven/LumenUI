local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack
local next = _G.next

-- ---------------

local UF = E:AddModule("UnitFrames")

local isInit = false

local cfg = C.modules.unitframes

-- ---------------

local objects = {}
local units = {}

local function frame_UpdateConfig(self)
  self._config = E:CopyTable(C.modules.unitframes.units[self._unit], self._config)
end

local function frame_UpdateSize(self)
  local width, height = self._config.width, self._config.height
  self:SetSize(width, height)
end

function UF:CreateUnitFrame(unit, name)
  if not units[unit] then
    if unit == "boss" then
      -- Boss spawning here
    else
      local object = oUF:Spawn(unit, name .. "Frame")
      object:UpdateConfig()
      object:SetPoint(unpack(object._config.pos))
			objects[unit] = object
    end

    units[unit] = true
  end
end

function UF:UpdateUnitFrame(unit, method, ...)
  if units[unit] then
    if unit == "boss" then
      -- Update boss frames here
    elseif objects[unit] then
      if objects[unit][method] then
				objects[unit][method](objects[unit], ...)
			end
    end
  end
end

function UF:IsInit()
	return isInit
end

function UF:Init()
  if not isInit and cfg.enabled then
    oUF:Factory(function()
      oUF:RegisterStyle("Lumen", function(frame, unit)
        frame:RegisterForClicks("AnyUp")
        frame._unit = unit:gsub("%d+", "")

        frame.UpdateConfig = frame_UpdateConfig
        frame.UpdateSize = frame_UpdateSize

        if unit == "player" then
          UF:CreatePlayerFrame(frame)
        elseif unit == "target" then
					UF:CreateTargetFrame(frame)
        end
      end)
    end)
    oUF:SetActiveStyle("Lumen")

    if cfg.units.player.enabled then
      UF:CreateUnitFrame("player", "LumenPlayer")
      UF:UpdateUnitFrame("player", "Update")
    end

    if cfg.units.target.enabled then
      UF:CreateUnitFrame("target", "LumenTarget")
      UF:UpdateUnitFrame("target", "Update")
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
