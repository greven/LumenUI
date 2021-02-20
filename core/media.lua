local _, ns = ...
local M = ns.M

-- ---------------

local MediaPath = "Interface\\AddOns\\LumenUI\\media\\"

M.fonts = {
    normal = MediaPath .. "fonts\\Oswald.ttf",
    light = MediaPath .. "fonts\\Oswald-Light.ttf",
    medium = MediaPath .. "fonts\\Oswald-Medium.ttf",
    condensed = MediaPath .. "fonts\\BigNoodleTitling.ttf"
}

M.textures = {
    statusbar = MediaPath .. "textures\\statusbar",
    statusbar_azerite = MediaPath .. "textures\\statusbar-azerite",
    flat = MediaPath .. "textures\\flat",
    neon = MediaPath .. "textures\\neon",
    mint = MediaPath .. "textures\\mint",
    vertlines = MediaPath .. "textures\\vertlines",
    glow = MediaPath .. "textures\\glow",
    spark = MediaPath .. "textures\\spark",
    absorb = MediaPath .. "textures\\absorb",
    border = MediaPath .. "textures\\border",
    border_thick = MediaPath .. "textures\\border-thick",
    backdrop_border = MediaPath .. "textures\\backdrop-border",
    button_backdrop = MediaPath .. "textures\\button-backdrop",
    button_normal = MediaPath .. "textures\\button-normal",
    button_highlight = MediaPath .. "textures\\button-highlight",
    button_checked = MediaPath .. "textures\\button-checked",
    arrow = MediaPath .. "textures\\arrow",
    aura_icons = {
        -- line #1
        ["Buff"] = {1 / 128, 33 / 128, 1 / 128, 33 / 128},
        ["Debuff"] = {34 / 128, 66 / 128, 1 / 128, 33 / 128},
        ["Curse"] = {67 / 128, 99 / 128, 1 / 128, 33 / 128},
        -- line #2
        ["Disease"] = {1 / 128, 33 / 128, 34 / 128, 66 / 128},
        ["Magic"] = {34 / 128, 66 / 128, 34 / 128, 66 / 128},
        ["Poison"] = {67 / 128, 99 / 128, 34 / 128, 66 / 128},
        -- line #3
        [""] = {1 / 128, 33 / 128, 67 / 128, 99 / 128} -- Enrage
        -- ["TEMP"] = {34 / 128, 66 / 128, 67 / 128, 99 / 128},
        -- ["TEMP"] = {67 / 128, 99 / 128, 67 / 128, 99 / 128},
    }
}
