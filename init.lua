-- ----------------------------------------
-- > lumenUI (Kreoss @ Quel'Thalas EU) <
-- ----------------------------------------
local Addon, ns = ...
local E, C, D = ns.E, ns.C, ns.D

E:RegisterEvent(
    "ADDON_LOADED",
    function(addonName)
        if addonName ~= Addon then
            return
        end

        C.db = LibStub("AceDB-3.0"):New("LUM_UI_GLOBAL_CONFIG", D)

        -- Support AdiButtonAuras
        if AdiButtonAuras and AdiButtonAuras.RegisterLAB then
            AdiButtonAuras:RegisterLAB("LibActionButton-1.0-ls")
        end

        E:RegisterEvent(
            "PLAYER_LOGIN",
            function()
                E:UpdateConstants()
                E:InitModules()
            end
        )
    end
)

E:RegisterEvent(
    "PLAYER_ENTERING_WORLD",
    function(initLogin, isReload)
        E:CheckPlayerRoles()
    end
)
