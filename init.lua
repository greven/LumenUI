-- ----------------------------------------
-- > lumenUI (Kreoss @ Quel'Thalas EU) <
-- ----------------------------------------
local Addon, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

local function updateAll()
    P:UpdateModules()
    P.Movers:UpdateConfig()
end

E:RegisterEvent("ADDON_LOADED", function(addonName)
    if addonName ~= Addon then
        return
    end

    C.db = D

    -- Support AdiButtonAuras
    if AdiButtonAuras and AdiButtonAuras.RegisterLAB then
        AdiButtonAuras:RegisterLAB("LibActionButton-1.0-ls")
    end

    E:RegisterEvent("PLAYER_LOGIN", function()
        E:UpdateConstants()
        P:InitModules()
    end)

    E:RegisterEvent("PLAYER_ENTERING_WORLD", function(initLogin, isReload)
        E:CheckPlayerRoles()
    end)

    -- Hide namespaced tables
    ns.C, ns.D, ns.L, ns.P = nil, nil, nil, nil
end)
