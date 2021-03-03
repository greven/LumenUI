local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local FILTERS = P:AddModule("Filters")

-- Lua
local _G = getfenv(0)
local next = _G.next
local t_wipe = _G.table.wipe

-- ---------------

local isInit = false

local aura_filters = {
    ["Blacklist"] = {
        state = false,
        [8326] = true, -- Ghost
        [26013] = true, -- Deserter
        [39953] = true, -- A'dal's Song of Battle
        [57819] = true, -- Argent Champion
        [57820] = true, -- Ebon Champion
        [57821] = true, -- Champion of the Kirin Tor
        [71041] = true, -- Dungeon Deserter
        [72968] = true, -- Precious's Ribbon
        [85612] = true, -- Fiona's Lucky Charm
        [85613] = true, -- Gidwin's Weapon Oil
        [85614] = true, -- Tarenar's Talisman
        [85615] = true, -- Pamela's Doll
        [85616] = true, -- Vex'tul's Armbands
        [85617] = true, -- Argus' Journal
        [85618] = true, -- Rimblat's Stone
        [85619] = true, -- Beezil's Cog
        [93337] = true, -- Champion of Ramkahen
        [93339] = true, -- Champion of the Earthen Ring
        [93341] = true, -- Champion of the Guardians of Hyjal
        [93347] = true, -- Champion of Therazane
        [93368] = true, -- Champion of the Wildhammer Clan
        [93795] = true, -- Stormwind Champion
        [93805] = true, -- Ironforge Champion
        [93806] = true, -- Darnassus Champion
        [93811] = true, -- Exodar Champion
        [93816] = true, -- Gilneas Champion
        [93821] = true, -- Gnomeregan Champion
        [93825] = true, -- Orgrimmar Champion
        [93827] = true, -- Darkspear Champion
        [93828] = true, -- Silvermoon Champion
        [93830] = true, -- Bilgewater Champion
        [94158] = true, -- Champion of the Dragonmaw Clan
        [94462] = true, -- Undercity Champion
        [94463] = true, -- Thunder Bluff Champion
        [97340] = true, -- Guild Champion
        [97341] = true, -- Guild Champion
        [126434] = true, -- Tushui Champion
        [126436] = true, -- Huojin Champion
        [143625] = true, -- Brawling Champion
        [170616] = true, -- Pet Deserter
        [182957] = true, -- Treasures of Stormheim
        [182958] = true, -- Treasures of Azsuna
        [185719] = true, -- Treasures of Val'sharah
        [186401] = true, -- Sign of the Skirmisher
        [186403] = true, -- Sign of Battle
        [186404] = true, -- Sign of the Emissary
        [186406] = true, -- Sign of the Critter
        [188741] = true, -- Treasures of Highmountain
        [199416] = true, -- Treasures of Suramar
        [225787] = true, -- Sign of the Warrior
        [225788] = true, -- Sign of the Emissary
        [227723] = true, -- Mana Divining Stone
        [231115] = true, -- Treasures of Broken Shore
        [233641] = true, -- Legionfall Commander
        [237137] = true, -- Knowledgeable
        [237139] = true, -- Power Overwhelming
        [239966] = true, -- War Effort
        [239967] = true, -- Seal Your Fate
        [239968] = true, -- Fate Smiles Upon You
        [239969] = true, -- Netherstorm
        [240979] = true, -- Reputable
        [240980] = true, -- Light As a Feather
        [240985] = true, -- Reinforced Reins
        [240986] = true, -- Worthy Champions
        [240987] = true, -- Well Prepared
        [240989] = true, -- Heavily Augmented
        [245686] = true, -- Fashionable!
        [264408] = true, -- Soldier of the Horde
        [264420] = true, -- Soldier of the Alliance
        [269083] = true -- Enlisted
    },
    ["M+ Affixes"] = {
        state = true,
        [178658] = true, -- Raging
        [196376] = true, -- Grievous Tear
        [209858] = true, -- Necrotic
        [209859] = true, -- Bolster
        [226510] = true, -- Sanguine
        [226512] = true, -- Sanguine
        [240443] = true, -- Bursting
        [240559] = true, -- Grievous
        [277242] = true, -- Symbiote of G'huun (Infested)
        [288388] = true, -- Reap Soul
        [288694] = true, -- Shadow Smash
        [290026] = true, -- Queen's Decree: Blowback
        [290027] = true, -- Queen's Decree: Blowback
        [302417] = true, -- Queen's Decree: Unstoppable
        [302419] = true, -- Void Sight
        [302421] = true, -- Queen's Decree: Hide
        [303632] = true -- Enchanted
    }
}

local class_buffs = {
    ["DEATHKNIGHT"] = {
        state = true
    },
    ["DEMONHUNTER"] = {
        state = true
    },
    ["DRUID"] = {
        state = true,
        [1850] = true, -- Dash
        [191034] = true, -- Starfall
        [192081] = true, -- Iron Fur
        [77764] = true, -- Stampeding Roar
        [774] = true, -- Rejuvenation
        [8936] = true, -- Regrowth
        [194223] = true, -- Celestial Alignment
        [106951] = true, -- Berserk
    },
    ["HUNTER"] = {
        state = true
    },
    ["MAGE"] = {
        state = true
    },
    ["MONK"] = {
        state = true
    },
    ["PALADIN"] = {
        state = true
    },
    ["PRIEST"] = {
        state = true,
        [17] = true, -- Power Word: Shield
        [194249] = true, -- Voidform
        [343144] = true -- Dissonant Echoes
    },
    ["ROGUE"] = {
        state = true,
        [315496] = true, -- Slice and Dice
        [13750] = true, -- Adrenaline Rush
        [13877] = true, -- Blade Flurry
        [31224] = true, -- Cloak of Shadows
        [5277] = true, -- Evasion
        [193356] = true, -- Broadside (Roll the Bones)
        [199600] = true, -- Buried Treasure (Roll the Bones)
        [193358] = true, -- Grand Melee (Roll the Bones)
        [193357] = true, -- Ruthless Precision (Roll the Bones)
        [199603] = true, -- Skull and Crossbones (Roll the Bones)
        [193359] = true, -- True Bearing (Roll the Bones)
        [199754] = true, -- Riposte
        [121471] = true, -- Shadow Blades
        [185422] = true, -- Shadow Dance
        [114018] = true, -- Shroud of Concealment
        [2983] = true, -- Sprint
        [212283] = true, -- Symbols of Death
        [11327] = true -- Vanish
        -- [32645] = true, -- Envenom
        -- [121153] = true, -- Blindside
    },
    ["SHAMAN"] = {
        state = true,
        [77762] = true -- Lava Surge
    },
    ["WARLOCK"] = {
        state = true
    },
    ["WARRIOR"] = {
        state = true
    }
}

local class_debuffs = {
    ["DEATHKNIGHT"] = {
        state = true,
        onlyShowPlayer = true,
        [55078] = true, -- Blood Plague
        [194310] = true, -- Festering Wound
        [191587] = true -- Virulent Plague
    },
    ["DEMONHUNTER"] = {
        state = true,
        onlyShowPlayer = true
    },
    ["DRUID"] = {
        state = true,
        onlyShowPlayer = true,
        [203123] = true, -- Maim
        [164812] = true, -- Moonfire
        [155722] = true, -- Rake
        [1079] = true, -- Rip
        [164815] = true, -- Sunfire
        [106830] = true -- Thrash
    },
    ["HUNTER"] = {
        state = true,
        onlyShowPlayer = true,
        [217200] = true, -- Barbed Shot
        [5116] = true, --- Concussive Shot
        [3355] = true, -- Freezing Trap
        [259491] = true -- Serpent Sting
    },
    ["MAGE"] = {
        state = true,
        onlyShowPlayer = true,
        [12654] = true, -- Ignite
        -- [205708] = true, -- Chilled
        [122] = true, -- Frost Nova
        [228358] = true -- Winter's Chill
    },
    ["MONK"] = {
        state = true,
        onlyShowPlayer = true
    },
    ["PALADIN"] = {
        state = true,
        onlyShowPlayer = true,
        [853] = true, -- Hammer of Justice
        [197277] = true -- Judgment
    },
    ["PRIEST"] = {
        state = true,
        onlyShowPlayer = true,
        [335467] = true, -- Devouring Plague
        [204213] = true, -- Purge the Wicked
        [214621] = true, -- Schism
        [64044] = true, -- Psychic Horror
        [589] = true, -- Shadow Word: Pain
        [34914] = true -- Vampiric Touch
    },
    ["ROGUE"] = {
        state = true,
        onlyShowPlayer = true,
        [2094] = true, -- Blind
        [199804] = true, -- Between the Eyes
        [1833] = true, -- Cheap Shot
        [703] = true, -- Garrote
        [1330] = true, -- Garrote - Silence
        [1776] = true, -- Gouge
        [408] = true, -- Kidney Shot
        [195452] = true, -- Knight Blade
        -- [185763] = true, -- Pistol Shot
        [1943] = true, -- Rupture
        [6770] = true, -- Sap
        [79140] = true -- Vendetta
    },
    ["SHAMAN"] = {
        state = true,
        onlyShowPlayer = true,
        [188389] = true, -- Flame Shock
        [196840] = true -- Frost Shock
    },
    ["WARLOCK"] = {
        state = true,
        onlyShowPlayer = true,
        [980] = true, -- Agony
        [146739] = true, -- Corruption
        [1714] = true, -- Curse of Tongues
        [603] = true, -- Doom
        [1098] = true, -- Enslave Demon
        [118699] = true, -- Fear
        [80240] = true, -- Havoc
        [157736] = true, -- Immolate
        [205179] = true, -- Phantom Singularity
        [27243] = true, -- Seed of Corruption
        [63106] = true, -- Siphon Life
        [30108] = true, -- Unstable Affliction
        [48181] = true -- Haunt
    },
    ["WARRIOR"] = {
        state = true,
        onlyShowPlayer = true
    }
}

function FILTERS.CreateAuraFilters()
    for filter, v in next, aura_filters do
        if not C.db.global.aura_filters[filter].is_init then
            E:CopyTable(v, C.db.global.aura_filters[filter])
            C.db.global.aura_filters[filter].is_init = true
        end
    end
    -- Class Debuffs filters
    if not C.db.global.aura_filters["Class Debuffs"].is_init then
        E:CopyTable(class_debuffs, C.db.global.aura_filters["Class Debuffs"])
        C.db.global.aura_filters["Class Debuffs"].is_init = true
    end
    -- Class Buffs filters
    if not C.db.global.aura_filters["Class Buffs"].is_init then
        E:CopyTable(class_buffs, C.db.global.aura_filters["Class Buffs"])
        C.db.global.aura_filters["Class Buffs"].is_init = true
    end
end

function FILTERS:IsInit()
    return isInit
end

function FILTERS:Init()
    if not isInit then
        FILTERS.CreateAuraFilters()

        isInit = true
    end
end

function FILTERS:ResetAuraFilter(filter)
    if aura_filters[filter] then
        t_wipe(C.db.global.aura_filters[filter])

        E:CopyTable(aura_filters[filter], C.db.global.aura_filters[filter])

        C.db.global.aura_filters[filter].is_init = true
    end
end
