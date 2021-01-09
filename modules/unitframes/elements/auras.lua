local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

--Lua
local _G = getfenv(0)

local m_max = _G.math.max
local m_min = _G.math.min
local next = _G.next
local select = _G.select
local unpack = _G.unpack

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function element_UpdateConfig(self)
	local unit = self.__owner._unit
	self._config = E:CopyTable(C.modules.unitframes.units[unit].auras, self._config)
end

local function frame_UpdateAuras(self)
  local element = self.Auras
end

function UF:CreateAuras(frame, unit)
  local element = CreateFrame("Frame", nil, frame)

  element.UpdateConfig = element_UpdateConfig

  frame.UpdateAuras = frame_UpdateAuras
  frame.Auras = element

  return element
end
