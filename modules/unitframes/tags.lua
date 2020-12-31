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

-- ---------------

local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
local tagSharedEvents = tags.SharedEvents

local events = {
  name = "UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_ENTERING_VEHICLE UNIT_EXITING_VEHICLE",
  color = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED"
}

local _tags = {
  -- Unit name
  name = function(unit, rolf, upcase)
    local name = UnitName(rolf or unit)
    if upcase and name then return s_upper(name) end
    return name
  end,

  color = function(unit)
    local class = select(2, UnitClass(unit))
    local reaction = UnitReaction(unit, "player")

    if UnitIsTapDenied(unit) then
      return E:ToHex(oUF.colors.tapped)
    elseif UnitIsPlayer(unit) then
      return E:ToHex(oUF.colors.class[class])
    elseif reaction then
      return E:ToHex(oUF.colors.reaction[reaction])
    else
      return E:ToHex(1, 1, 1)
    end
  end,
}

for tag, func in next, _tags do
  tagMethods["lum:" .. tag] = func
  tagEvents["lum:" .. tag] = events[tag]
end
