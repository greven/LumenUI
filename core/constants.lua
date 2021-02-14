local A, ns = ...
local E, D, L = ns.E, ns.D, ns.L

-- Lua
local _G = getfenv(0)
local select = _G.select
local m_min = _G.math.min
local m_max = _G.math.max

local UnitGUID = _G.UnitGUID
local UnitName = _G.UnitName
local GetRealmName = _G.GetRealmName

-- ---------------

E.ADDON_NAME = A
E.LUMEN = "|cFF0d87d5L|r|cFF3f6abdu|r|cFF85419cm|r|cFFc81a7de|r|cFFf20269n|r"

-- Player Specific
E.PLAYER_CLASS = select(2, UnitClass("player"))
E.PLAYER_NAME = UnitName("player")
E.NAME_REALM = UnitName("player") .. " - " .. GetRealmName()
E.CLASS_COLOR = D.global.colors.class[E.PLAYER_CLASS]

-- !ClassColors addon
if (IsAddOnLoaded("!ClassColors") and CUSTOM_CLASS_COLORS) then
    E.CLASS_COLOR = CUSTOM_CLASS_COLORS[E.PLAYER_CLASS]
end

local hidden = _G.CreateFrame("Frame", nil, UIParent)
hidden:Hide()
E.HIDDEN_PARENT = hidden

E.NOA = hidden:CreateAnimationGroup()
E.NOOP = function()
end

E.DAY, E.HOUR, E.MINUTE = 86400, 3600, 60

-- Screen Size and UI Scale
do
    local function GetBestScale()
        local _, screenHeight = GetPhysicalScreenSize()
        local scale = m_max(0.4, m_min(1.15, 768 / screenHeight))
        return E:Round(scale)
    end

    local function UpdateScreenConstants()
        E.SCREEN_WIDTH, E.SCREEN_HEIGHT = GetPhysicalScreenSize()

        local pixel = 1
        local scale = GetBestScale()
        local ratio = 768 / E.SCREEN_HEIGHT

        E.SCREEN_SCALE = (pixel / scale) - ((pixel - ratio) / scale)
    end

    UpdateScreenConstants()

    E:RegisterEvent("DISPLAY_SIZE_CHANGED", UpdateScreenConstants)
    E:RegisterEvent("UI_SCALE_CHANGED", UpdateScreenConstants)
end

-- Constants not available at ADDON_LOADED
function E:UpdateConstants()
    E.PLAYER_GUID = UnitGUID("player")
end

local function PlayerSpecializationChanged()
    E:CheckPlayerRoles()
end

local function PlayerRolesAssigned()
    E:CheckPlayerRoles()
end

E:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecializationChanged)
E:RegisterEvent("PLAYER_ROLES_ASSIGNED", PlayerRolesAssigned)
