local _, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

-- Lua
local _G = getfenv(0)

-- ---------------

-- Blizz strings
L["ADD"] = _G.ADD
L["ARCANE_CHARGES"] = _G.POWER_TYPE_ARCANE_CHARGES
L["CALENDAR_EVENT_ALARM_MESSAGE"] = _G.CALENDAR_EVENT_ALARM_MESSAGE
L["CALENDAR_PENDING_INVITES_TOOLTIP"] = _G.GAMETIME_TOOLTIP_CALENDAR_INVITES
L["CALENDAR_TOGGLE_TOOLTIP"] = _G.GAMETIME_TOOLTIP_TOGGLE_CALENDAR
L["CALL_TO_ARMS_TOOLTIP"] = _G.LFG_CALL_TO_ARMS
L["CAST_ON_KEY_DOWN_DESC"] = _G.OPTION_TOOLTIP_ACTION_BUTTON_USE_KEY_DOWN
L["CHARACTER_BUTTON"] = _G.CHARACTER_BUTTON
L["CHI"] = _G.CHI
L["CLASS"] = _G.CLASS
L["COLLECTIONS"] = _G.COLLECTIONS
L["COMBO_POINTS"] = _G.COMBO_POINTS
L["CONTESTED_TERRITORY"] = _G.CONTESTED_TERRITORY:gsub("[()]", "")
L["CURRENCY"] = _G.CURRENCY
L["CURRENCY_COLON"] = _G.CURRENCY .. ":"
L["DAMAGER_RED"] = E:WrapText(D.global.colors.red, _G.DAMAGER)
L["DELETE"] = _G.DELETE
L["DURABILITY_COLON"] = _G.DURABILITY .. ":"
L["ENABLE"] = _G.ENABLE
L["ENERGY"] = _G.ENERGY
L["ERROR_RED"] = E:WrapText(D.global.colors.red, _G.ERROR_CAPS)
L["FACTION"] = _G.FACTION
L["FACTION_ALLIANCE"] = _G.FACTION_ALLIANCE
L["FACTION_HORDE"] = _G.FACTION_HORDE
L["FEATURE_BECOMES_AVAILABLE_AT_LEVEL"] = _G.FEATURE_BECOMES_AVAILABLE_AT_LEVEL
L["FEATURE_NOT_AVAILBLE_NEUTRAL"] = _G.FEATURE_NOT_AVAILBLE_PANDAREN
L["FOCUS"] = _G.FOCUS
L["FOREIGN_SERVER_LABEL"] = _G.FOREIGN_SERVER_LABEL:gsub("%s", "")
L["FURY"] = _G.FURY
L["GENERAL"] = _G.GENERAL_LABEL
L["GARRISON"] = _G.GARRISON_LOCATION_TOOLTIP
L["HEALER_GREEN"] = E:WrapText(D.global.colors.green, _G.HEALER)
L["HIDE"] = _G.HIDE
L["HOLY_POWER"] = _G.HOLY_POWER
L["INSANITY"] = _G.INSANITY
L["LOOT"] = _G.LOOT_NOUN
L["LUA_ERROR"] = _G.LUA_ERROR .. ": %s"
L["LUNAR_POWER"] = _G.LUNAR_POWER
L["MAELSTROM"] = _G.MAELSTROM
L["MAIL"] = _G.MAIL_LABEL
L["MAINMENU_BUTTON"] = _G.MAINMENU_BUTTON
L["MANA"] = _G.MANA
L["MINIMAP"] = _G.MINIMAP_LABEL
L["MISC"] = _G.MISCELLANEOUS
L["NEW"] = _G.NEW
L["NONE"] = _G.NONE
L["OFFLINE"] = _G.PLAYER_OFFLINE
L["PAIN"] = _G.PAIN
L["PET"] = _G.PET
L["RAGE"] = _G.RAGE
L["RAID_INFO_COLON"] = _G.RAID_INFO .. ":"
L["RELOAD_UI"] = _G.RELOADUI
L["REPUTATION"] = _G.REPUTATION
L["RUNES"] = _G.RUNES
L["RUNIC_POWER"] = _G.RUNIC_POWER
L["SANCTUARY"] = _G.SANCTUARY_TERRITORY:gsub("[()]", "")
L["SHOW"] = _G.SHOW
L["SOUL_SHARDS"] = _G.SOUL_SHARDS_POWER
L["SPELLBOOK_ABILITIES_BUTTON"] = _G.SPELLBOOK_ABILITIES_BUTTON
L["TANK_BLUE"] = E:WrapText(D.global.colors.blue, _G.TANK)
L["TOTAL"] = _G.TOTAL
L["TRACKING"] = _G.TRACKING
L["UNIT_FRAME"] = _G.UNITFRAME_LABEL
L["UNKNOWN"] = _G.UNKNOWN
L["WORLD_BOSS"] = _G.RAID_INFO_WORLD_BOSS
L["ZONE"] = _G.ZONE
L["YOU"] = _G.YOU

-- ---------------

L["ARTIFACT_LEVEL_TOOLTIP"] = "Artifact Level: |cffffffff%s|r"
L["ARTIFACT_POWER"] = "Artifact Power"
L["CHARACTER_BUTTON_DESC"] = "Show equipment durability information."
L["BONUS_XP_TOOLTIP"] = "Bonus XP: |cffffffff%s|r"
L["DAILY_QUEST_RESET_TIME_TOOLTIP"] = "Daily Quest Reset Time: |cffffffff%s|r"
L["EXPERIENCE"] = "Experience"
L["FREE_BAG_SLOTS_TOOLTIP"] = "Free Bag Slots: |cffffffff%s|r"
L["GOLD"] = "Gold"
L["HONOR"] = "Honor"
L["HONOR_LEVEL_TOOLTIP"] = "Honor Level: |cffffffff%d|r"
L["INVENTORY_BUTTON"] = "Inventory"
L["INVENTORY_BUTTON_RCLICK_TOOLTIP"] = "|cffffffffRight-Click|r to toggle bag slots."
L["ITEMS_REPAIRED"] = "Repair Cost: %s"
L["ITEMS_REPAIRED_GUILD_FUNDS"] = "Repair Cost: %s (Guild Funds)"
L["LATENCY"] = "Latency"
L["LATENCY_HOME"] = "Home"
L["LATENCY_WORLD"] = "World"
L["LEVEL_TOOLTIP"] = "Level: |cffffffff%d|r"
L["MAINMENU_BUTTON_HOLD_TOOLTIP"] = "|cffffffffHold Shift|r to show memory usage."
L["MINIMAP_BUTTONS"] = "Minimap Buttons"
L["MINIMAP_BUTTONS_TOOLTIP"] = "Click to show minimap buttons."
L["NOT_ENOUGH_MONEY_TO_REPAIR"] = "You don't have enough money to repair."
L["SOLD_GRAY_ITEMS_FOR"] = "Sold gray items for: %s"
L["UNSPENT_TRAIT_POINTS_TOOLTIP"] = "Unspent Trait Points: |cffffffff%s|r"
L["VENDORING_GRAYS"] = "Vendoring Grays"
