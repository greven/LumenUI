local _, ns = ...
local E, D, C = ns.E, ns.D, ns.C

-- ---------------

local function rgb(r, g, b)
	return E:SetRGB({}, r, g, b)
end

local b = {
  black = rgb(0, 0, 0), white = rgb(255, 255, 255),
  light_gray = rgb(210, 210, 210), gray = rgb(82, 82, 82), dark_gray = rgb(26, 26, 26),
  light_red = rgb(252, 165, 165), red = rgb(220, 38, 38), dark_red = rgb(185, 28, 28),
  light_orange = rgb(253, 186, 116), orange = rgb(249, 115, 22), dark_orange = rgb(194, 65, 12),
  light_amber = rgb(252, 211, 77), amber = rgb(245, 158, 11), dark_amber = rgb(180, 83, 9),
  light_yellow = rgb(253, 224, 71), yellow = rgb(234, 179, 8), dark_yellow = rgb(161, 98, 7),
  light_green = rgb(134, 239, 172), green = rgb(34, 197, 94), dark_green = rgb(21, 128, 61),
  light_emerald = rgb(110, 231, 183), emerald = rgb(16, 185, 129), dark_emerald = rgb(4, 120, 87),
  light_cyan = rgb(103, 232, 249), cyan = rgb(6, 182, 212), dark_cyan = rgb(14, 116, 144),
  light_blue = rgb(147, 197, 253), blue = rgb(59, 130, 246), dark_blue = rgb(29, 78, 216),
  light_purple = rgb(216, 180, 254), purple = rgb(168, 85, 247), dark_purple = rgb(126, 34, 206),
}

D.colors = {
  text = rgb(250, 250, 250),
  disconnected = b.gray,
  gain = b.light_green,
  loss = b.dark_red,

  class = {
    HUNTER = rgb(170, 211, 114),
    WARLOCK = rgb(135, 135, 237),
    PRIEST = rgb(255, 255, 255),
    PALADIN = rgb(244, 140, 186),
    MAGE = rgb(63, 198, 234),
    ROGUE = rgb(255, 244, 104),
    DRUID = rgb(255, 124, 10),
    SHAMAN = rgb(0, 112, 221),
    WARRIOR = rgb(198, 155, 109),
    DEATHKNIGHT = rgb(196, 30, 58),
    MONK = rgb(0, 255, 150),
    DEMONHUNTER = rgb(163, 48, 201)
  },
  threat = {
    [1] = rgb(175, 175, 175),
    [2] = rgb(254, 254, 118),
    [3] = rgb(254, 152, 0),
    [4] = rgb(254, 0, 0),
  },
  reaction = {
    [1] = b.red, -- Hated
    [2] = b.red, -- Hostile
    [3] = b.orange, -- Unfriendly
    [4] = b.amber, -- Neutral
    [5] = b.green, -- Friendly
    [6] = b.green, -- Honored
    [7] = b.green, -- Revered
    [8] = b.green, -- Exalted
  },
  power = {
    MANA = rgb(15, 135, 235),
    RAGE = rgb(240, 26, 48),
    FOCUS = rgb(242, 128, 64),
    ENERGY = rgb(246, 190, 50),
    COMBO_POINTS = rgb(240, 26, 48),
    RUNES = rgb(0, 200, 228),
    RUNIC_POWER = rgb(134, 239, 254),
    SOUL_SHARDS = rgb(162, 92, 244),
    LUNAR_POWER = rgb(90, 152, 235),
    HOLY_POWER = rgb(245, 245, 124),
    MAELSTROM = rgb(25, 160, 240),
    INSANITY = rgb(136, 72, 210),
    CHI = rgb(10, 205, 155),
    ARCANE_CHARGES = rgb(112, 75, 250),
    FURY = rgb(240, 34, 45),
    PAIN = rgb(243, 157, 0),
    AMMOSLOT = rgb(217, 140, 0),
    FUEL = rgb(12, 125, 125),
    STAGGER = {
      [1] = rgb(132, 181, 26), -- Low
      [2] = rgb(220, 180, 52), -- Medium
      [3] = rgb(182, 34, 32), -- High
    },
  },
  runes = {
    [1] = rgb(225, 75, 75), -- Blood
    [2] = rgb(50, 160, 250), -- Frost
    [3] = rgb(100, 225, 125), -- Unholy
  },
}

E:CopyTable(b, D.colors)
