local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)
local select = _G.select

local m_floor = _G.math.floor
local s_format = _G.string.format
local s_upper = _G.string.upper

local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local UnitReaction = _G.UnitReaction
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsTapDenied = _G.UnitIsTapDenied
local UnitPowerType = _G.UnitPowerType
local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax

-- ---------------

local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
local tagSharedEvents = tags.SharedEvents

local events = {
  name = "UNIT_NAME_UPDATE",
  color = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION",
  power_cur = "UNIT_POWER_FREQUENT UNIT_MAXPOWER",
}

local _tags = {
  -- Unit name
  name = function(unit, rolf, upcase)
    local name = UnitName(rolf or unit)
    if upcase and name then return s_upper(name) end
    return name
  end,

  -- Color unit by disconnected, tapped, class or reaction
  color = function(unit)
    E:GetUnitColor(unit, true, true)
  end,

  -- Power value
  power_cur = function(unit)
    if E:GetUnitStatus(unit) then return end

    local type = UnitPowerType(unit)
    local max = UnitPowerMax(unit, type)
    if max and max ~= 0 then
      local cur = UnitPower(unit, type)
      if cur > 0 then return E:FormatNumber(cur) end
    end
  end,
}

for tag, func in next, _tags do
  tagMethods["lum:" .. tag] = func
  tagEvents["lum:" .. tag] = events[tag]
end
