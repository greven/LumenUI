local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)
local select = _G.select

local m_floor = _G.math.floor
local s_format = _G.string.format

local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local UnitReaction = _G.UnitReaction
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsTapDenied = _G.UnitIsTapDenied
local UnitPowerType = _G.UnitPowerType
local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax
local UnitLevel = _G.UnitLevel
local UnitIsWildBattlePet = _G.UnitIsWildBattlePet
local UnitIsBattlePetCompanion = _G.UnitIsBattlePetCompanion
local GetCreatureDifficultyColor = _G.GetCreatureDifficultyColor
local UnitEffectiveLevel = _G.UnitEffectiveLevel
local UnitClassification = _G.UnitClassification

-- ---------------

local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
local tagSharedEvents = tags.SharedEvents

local events = {
  color = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION",
  color_difficulty = "UNIT_LEVEL PLAYER_LEVEL_UP",
  level = "UNIT_LEVEL PLAYER_LEVEL_UP",
  name = "UNIT_NAME_UPDATE",
  npc_type = "UNIT_CLASSIFICATION_CHANGED UNIT_NAME_UPDATE",
  npc_type_short = "UNIT_CLASSIFICATION_CHANGED UNIT_NAME_UPDATE",
  power_cur = "UNIT_POWER_FREQUENT UNIT_MAXPOWER",
}

local _tags = {
  -- Color unit by disconnected, tapped, class or reaction
  color = function(unit)
    E:GetUnitColor(unit, true, true)
  end,

  color_difficulty = function(unit)
    return "|c" .. E:ToHex(GetCreatureDifficultyColor(UnitEffectiveLevel(unit)))
  end,

  -- Unit level
  level = function(unit)
    local level
    if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
      level = UnitBattlePetLevel(unit)
    else
      level = UnitLevel(unit)
    end

    return level > 0 and level or "??"
  end,

  -- Unit name
  name = function(unit)
    return UnitName(unit) or ""
  end,

  -- Unit Classification (Rare, Elite, Boss, ...)
  npc_type = function(unit, _, color)
    local classification = UnitClassification(unit)

    if classification == "worldboss" or UnitLevel(unit) <= 0 then
      return color and "|c"..E:ToHex(C.colors.difficulty.impossible).."Boss|r" or "Boss"
    elseif classification == "rare" then
      return color and "|cff008FF7Rare|r" or "Rare"
    elseif classification == "rareelite" then
      return color and "|cff008FF7Rare|r |c"..E:ToHex(C.colors.difficulty.difficult).."Elite|r" or "Rare Elite"
    elseif classification == "elite" then
      return color and "|c"..E:ToHex(C.colors.difficulty.difficult).."Elite|r" or "Elite"
    end

    return ""
  end,

  -- Unit Classification (Rare (R), Elite(+), Boss(B), ...)
  npc_type_short = function(unit)
    local classification = UnitClassification(unit)

    if classification == "worldboss" or UnitLevel(unit) <= 0 then
      return "B"
    elseif classification == "rare" then
      return  "R"
    elseif classification == "rareelite" then
      return "R+"
    elseif classification == "elite" then
      return "+"
    elseif classification == "minus" then
      return "-" end
    return ""
  end,

  -- Power value
  power_cur = function(unit)
    if E:UnitIsDisconnectedOrDeadOrGhost(unit) then return end

    local type = UnitPowerType(unit)
    local max = UnitPowerMax(unit, type)
    if max and max ~= 0 then
      local cur = UnitPower(unit, type)
      if cur > 0 then return E:FormatNumber(cur) end
    end
  end
}

for tag, func in next, _tags do
  tagMethods["lum:" .. tag] = func
  tagEvents["lum:" .. tag] = events[tag]
end
