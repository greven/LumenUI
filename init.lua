-- ----------------------------------------
-- > lumenUI (Kreoss @ Quel'Thalas EU) <
-- ----------------------------------------
local _, ns = ...
local E = ns.E

E:RegisterEvent("ADDON_LOADED", function(addonName)
    if addonName ~= E.ADDON_NAME then
        return
    end

    E:RegisterEvent("PLAYER_LOGIN", function()
        E:UpdateConstants()
        E:InitModules()
    end)
end)
