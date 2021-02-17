local _, ns = ...

local E, C, D, L, M, P, oUF = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P, ns.oUF

-- Lua
local _G = getfenv(0)

local IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted

E.DEVS = {
  ["Kreoss - Quel'Thalas"] = true,
  ["Lumen - Quel'Thalas"] = true,
  ["Elun - Quel'Thalas"] = true,
  ["Lua - Quel'Thalas"] = true
}

local function isDeveloper()
  return E.DEVS[E.NAME_REALM]
end

E.IS_DEVELOPER = isDeveloper()

--- -------------
--  Tools
--- -------------

-- /rl, Reload UI
-- /lt, get gametooltip names
-- /lf, get frame names
-- /ls, get spell name and description
-- /lcq, get if quest is completed by quest id

SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI

SlashCmdList["LUMUI_ENUMTIP"] = function()
  local enumf = EnumerateFrames()
  while enumf do
    if
      (enumf:IsObjectType("GameTooltip") or strfind((enumf:GetName() or ""):lower(), "tip")) and enumf:IsVisible() and
        enumf:GetPoint()
     then
      print(enumf:GetName())
    end
    enumf = EnumerateFrames(enumf)
  end
end
SLASH_LUMUI_ENUMTIP1 = "/lt"

SlashCmdList["LUMUI_ENUMFRAME"] = function()
  local frame = EnumerateFrames()
  while frame do
    if (frame:IsVisible() and MouseIsOver(frame)) then
      print(frame:GetName() or format(UNKNOWN .. ": [%s]", tostring(frame)))
    end
    frame = EnumerateFrames(frame)
  end
end
SLASH_LUMUI_ENUMFRAME1 = "/lf"

SlashCmdList["LUMUI_DUMPSPELL"] = function(arg)
  local name = GetSpellInfo(arg)
  if not name then
    return
  end
  local des = GetSpellDescription(arg)
  print("|cff70C0F5------------------------")
  print(
    " \124T" .. GetSpellTexture(arg) .. ":16:16:::64:64:5:59:5:59\124t",
    E:WrapText(D.global.colors.light_amber, arg)
  )
  print(NAME .. ":", E:WrapText(D.global.colors.blue, (name or "nil")))
  print(DESCRIPTION .. ":", E:WrapText(D.global.colors.light_blue, (des or "nil")))
  print("|cff70C0F5------------------------")
end
SLASH_LUMUI_DUMPSPELL1 = "/ls"

SlashCmdList["LUMUI_CHECK_QUEST"] = function(msg)
  if not msg then
    return
  end
  print("QuestID " .. msg .. " complete:", IsQuestFlaggedCompleted(tonumber(msg)))
end
SLASH_LUMUI_CHECK_QUEST1 = "/lcq"
