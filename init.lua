-- ----------------------------------------
-- > lumenUI (Kreoss @ Quel'Thalas EU) <
-- ----------------------------------------
local Addon, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

local function updateAll()
    P:UpdateModules()
    P.Movers:UpdateConfig()
end

E:RegisterEvent(
    "ADDON_LOADED",
    function(addonName)
        if addonName ~= Addon then
            return
        end

        C.db = LibStub("AceDB-3.0"):New("LUMUI_GLOBAL_CONFIG", D, true)

        -- Support AdiButtonAuras
        if AdiButtonAuras and AdiButtonAuras.RegisterLAB then
            AdiButtonAuras:RegisterLAB("LibActionButton-1.0-ls")
        end

        C.db:RegisterCallback(
            "OnDatabaseShutdown",
            function()
                P.Movers:CleanUpConfig()
            end
        )

        C.db:RegisterCallback(
            "OnProfileShutdown",
            function()
                P.Movers:CleanUpConfig()
            end
        )

        C.db:RegisterCallback("OnProfileChanged", updateAll)
        C.db:RegisterCallback("OnProfileCopied", updateAll)
        C.db:RegisterCallback("OnProfileReset", updateAll)

        E:RegisterEvent(
            "PLAYER_LOGIN",
            function()
                E:UpdateConstants()
                P:InitModules()
            end
        )

        E:RegisterEvent(
            "PLAYER_ENTERING_WORLD",
            function(initLogin, isReload)
                E:CheckPlayerRoles()
            end
        )

        -- Hide namespaced tables
        ns.C, ns.D, ns.L, ns.P = nil, nil, nil, nil
    end
)
