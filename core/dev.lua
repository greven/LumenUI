local _, ns = ...

local E, C, D, L, M, P, oUF = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P, ns.oUF

-- Lua
local _G = getfenv(0)

--- -------------
--  PLAYGROUND
--- -------------

if E.IS_DEVELOPER then
  E:RegisterEvent(
    "PLAYER_ENTERING_WORLD",
    function(initLogin, isReload)
      print(E:WrapText(D.global.colors.cyan, "---------------------------------"))
      E:Print("DEV - Version: " .. E.VER.number)
      print(E.NAME_REALM)

      -- ----

      -- Recrate DB when in DEV
      -- C.db = LibStub("AceDB-3.0"):New("LUMUI_GLOBAL_CONFIG", D, true)

      print(E:WrapText(D.global.colors.emerald, "---------------------------------"))
    end
  )
end
