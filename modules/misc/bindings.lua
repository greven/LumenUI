local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local MISC = P:GetModule("Misc")

-- Lua
local _G = getfenv(0)
local next = _G.next

local m_rand = _G.math.random
local t_wipe = _G.table.wipe
local t_insert = _G.table.insert

-- Blizz
local CreateFrame = _G.CreateFrame
local InCombatLockdown = _G.InCombatLockdown
local PlayerHasToy = _G.PlayerHasToy

-- ---------------

local isInit = false

local toys = {}

local hearthstoneToys = {
    93672, -- Dark Portal
    54452, -- Ethereal Portal
    142542, -- Tome of Town Portal
    64488, -- The Innkeeper's Daughter
    163045, -- Headless Horeseman's Hearthstone
    162973, -- Greatfather Winter's Hearthstone
    165669, -- Lunar Elder's Hearthstone
    166747, -- Brewfest Reveler's Hearthstone
    166746, -- Fire Eater's Hearthstone
    168907, -- Holographic Digitalization Hearthstone
    165802, -- Noble Gardener's Hearthstone
    165670, -- Peddlefeet's Lovely Hearthstone
    172179, -- Eternal Traveler's Hearthstone
    184353, -- Kyrian Hearthstone
    183716, -- Venthyr Sinstone
    182773, -- Necrolord Hearthstone
    180290 -- Night Fae Hearthstone
}

local function setBindings()
    -- Keybinds
    SetBinding("END", "DISMOUNT") -- Dismount

    -- Buttons
    SetBindingClick("ALT-W", E.ADDON_NAME .. "SummonRandomMount") -- Summon Random Mount
    SetBindingClick("ALT-S", E.ADDON_NAME .. "SummonYak") -- Summon Grand Expedition Yak
    SetBindingClick("HOME", E.ADDON_NAME .. "HearthstoneButton") -- Hearthstone
    SetBindingClick("F12", E.ADDON_NAME .. "ReloadButton") -- Reload UI

    -- Spells
    SetBindingSpell("CTRL-SHIFT-Z", GetSpellInfo(131474)) -- Fishing
    SetBindingSpell("CTRL-SHIFT-X", GetSpellInfo(80451)) -- Survey (Archaelogy)
end

local function setHearthstoneCustomText()
    local Button = CreateFrame("Button", E.ADDON_NAME .. "HearthstoneButton", nil, "SecureActionButtonTemplate")

    Button:SetAttribute("type", "macro")
    Button:SetScript(
        "PreClick",
        function()
            if (InCombatLockdown()) then
                return
            end

            t_wipe(toys)
            for _, itemID in next, hearthstoneToys do
                if (PlayerHasToy(itemID)) then
                    t_insert(toys, itemID)
                end
            end

            if (#toys > 0) then
                -- Pick a random toy
                Button:SetAttribute("macrotext", "/cast item:" .. toys[m_rand(#toys)])
            else
                -- Hearthstone
                Button:SetAttribute("macrotext", "/cast item:" .. 6948)
            end
        end
    )
end

local function PLAYER_LOGIN()
    setHearthstoneCustomText()
    setBindings()
end

function MISC.HasBindings()
    return isInit
end

function MISC.SetUpBindings()
    if not isInit and C.db.profile.misc.bindings.enabled then
        -- Summon Grand Expedition Yak
        local YakID = 0 -- Fallback to Random Mounts
        for i, v in pairs(C_MountJournal.GetMountIDs()) do
            if C_MountJournal.GetMountInfoByID(v) == "Grand Expedition Yak" then
                YakID = v
            end
        end

        -- Reload UI
        CreateFrame("Button", E.ADDON_NAME .. "ReloadButton"):SetScript("OnClick", ReloadUI)

        -- Summon Random Mount
        CreateFrame("Button", E.ADDON_NAME .. "SummonRandomMount"):SetScript(
            "OnClick",
            function()
                C_MountJournal.SummonByID(0)
            end
        )

        CreateFrame("Button", E.ADDON_NAME .. "SummonYak"):SetScript(
            "OnClick",
            function()
                C_MountJournal.SummonByID(YakID)
            end
        )

        E:RegisterEvent("PLAYER_LOGIN", PLAYER_LOGIN)

        isInit = true
    end
end
