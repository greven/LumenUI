local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)
local select = _G.select
local next = _G.next
local ipairs = _G.ipairs

local m_floor = _G.math.floor
local s_format = _G.string.format
local s_len = _G.string.len
local tonumber = _G.tonumber

local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local UnitReaction = _G.UnitReaction
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsTapDenied = _G.UnitIsTapDenied
local UnitPowerType = _G.UnitPowerType
local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitLevel = _G.UnitLevel
local UnitRace = _G.UnitRace
local UnitCreatureFamily = _G.UnitCreatureFamily
local UnitCreatureType = _G.UnitCreatureType
local UnitIsWildBattlePet = _G.UnitIsWildBattlePet
local UnitIsBattlePetCompanion = _G.UnitIsBattlePetCompanion
local UnitEffectiveLevel = _G.UnitEffectiveLevel
local UnitClassification = _G.UnitClassification
local IsPVPTimerRunning = _G.IsPVPTimerRunning
local GetPVPTimer = _G.GetPVPTimer
local GetCreatureDifficultyColor = _G.GetCreatureDifficultyColor

-- ---------------

local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
local tagSharedEvents = tags.SharedEvents

local sharedEvents = {
  "PLAYER_TALENT_UPDATE",
}

local events = {
  class = "UNIT_CLASSIFICATION_CHANGED",
  color_difficulty = "UNIT_LEVEL PLAYER_LEVEL_UP",
  color_unit = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION",
  health_cur = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED",
  health_cur_perc = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED",
  health_perc = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED",
  level = "UNIT_LEVEL PLAYER_LEVEL_UP",
  name = "UNIT_NAME_UPDATE",
  npc_type = "UNIT_CLASSIFICATION_CHANGED UNIT_NAME_UPDATE",
  npc_type_short = "UNIT_CLASSIFICATION_CHANGED UNIT_NAME_UPDATE",
  power_cur = "UNIT_POWER_FREQUENT UNIT_POWER_UPDATE UNIT_MAXPOWER UNIT_CONNECTION PLAYER_FLAGS_CHANGED",
  race = "UNIT_CLASSIFICATION_CHANGED",
  spec = "PLAYER_TALENT_UPDATE PLAYER_ROLES_ASSIGNED",
}

local customTags = {
  -- Player Class
  class = function(unit)
    if UnitIsPlayer(unit) then
      local class = UnitClass(unit)
      if class then
        return class
      end
    end
    return ""
  end,

  -- Creature difficulty color
  color_difficulty = function(unit)
    return "|c" .. E:ToHex(GetCreatureDifficultyColor(UnitEffectiveLevel(unit)))
  end,

  -- Color unit by disconnected, tapped, class or reaction
  color_unit = function(unit)
    return "|c" .. E:ToHex(E:GetUnitColor(unit, true, true))
  end,

  -- Health current value
  health_cur = function(unit, _, colorCap)
    if not UnitIsConnected(unit) then
      return "Offline"
    elseif UnitIsDeadOrGhost(unit) then
      return "Dead"
    else
      return E:FormatNumber(UnitHealth(unit), colorCap) or ""
    end
  end,

  -- Health value or value - percentage when not max
  health_cur_perc = function(unit)
    if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
      return ""
    else
      local cur, max = UnitHealth(unit), UnitHealthMax(unit)

      if cur == max then
        return E:FormatNumber(cur)
      else
        return s_format("%s - %.1f%%", E:FormatNumber(cur), E:NumberToPerc(cur, max))
      end
    end
  end,

  -- Health percentage
  health_perc = function(unit)
    if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
      return ""
    else
      local cur, max = UnitHealth(unit), UnitHealthMax(unit)
      return s_format("%d%%", E:NumberToPerc(cur, max))
    end
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
  name = function(unit, realUnit, truncate)
    local name = UnitName(realUnit or unit) or ""
    local length = truncate and tonumber(truncate)
    -- name = "ASDASDADADADADADADAFWRBVXCBXCGDSGSGSGSGSD"
    if length then
      return name ~= "" and E:TruncateString(name, length) or name
    end

    return name
  end,

  -- Unit Classification (Rare, Elite, Boss, ...)
  npc_type = function(unit, realUnit, color)
    local classification = UnitClassification(realUnit or unit)

    if classification == "worldboss" or UnitLevel(realUnit or unit) <= 0 then
      return color and "|c" .. E:ToHex(C.colors.difficulty.impossible) .. "Boss|r" or "Boss"
    elseif classification == "rare" then
      return color and "|cff008FF7Rare|r" or "Rare"
    elseif classification == "rareelite" then
      return color and "|cff008FF7Rare|r |c" .. E:ToHex(C.colors.difficulty.difficult) .. "Elite|r" or "Rare Elite"
    elseif classification == "elite" then
      return color and "|c" .. E:ToHex(C.colors.difficulty.difficult) .. "Elite|r" or "Elite"
    end

    return ""
  end,

  -- Unit Classification (Rare (R), Elite(+), Boss(B), ...)
  npc_type_short = function(unit, realUnit)
    local classification = UnitClassification(realUnit or unit)

    if classification == "worldboss" or UnitLevel(realUnit or unit) <= 0 then
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
  end,

  -- Player pvp timer
  pvptimer = function()
    if IsPVPTimerRunning() then
      local remain = GetPVPTimer() / 1000
      if remain >= 1 then
        local time1, time2, format
        if remain >= 60 then
          time1, time2, format = E:SecondsToTime(remain, "x:xx")
        else
          time1, time2, format = E:SecondsToTime(remain)
        end
        return s_format(format, time1, time2)
      end
    end
  end,

  -- Player race or NPC creature type/family
  race = function(unit)
    if UnitIsPlayer(unit) then
      local race = UnitRace(unit)
      if race then
        return race
      end
    else
      local creature = UnitCreatureFamily(unit) or UnitCreatureType(unit)
      if creature then
        return creature
      end
    end
    return ""
  end,

  -- Player spec
  spec = function(unit)
    return E:GetUnitSpecializationInfo(unit)
  end,

  -- New Line
  nl = function()
    return "\n"
  end,
}

-- Register Shared Events
for _, tag in ipairs(sharedEvents) do
  tagSharedEvents[tag] = true
end

-- Register Custom tags and events
for tag, func in next, customTags do
  tagMethods["lum:" .. tag] = func
  tagEvents["lum:" .. tag] = events[tag]
end
