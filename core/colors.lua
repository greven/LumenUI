local _, ns = ...
local E, D, C = ns.E, ns.D, ns.C

-- ---------------

local function rgb(r, g, b)
	return E:SetRGB({}, r, g, b)
end

D.colors = {
  dark_gray = rgb(30, 30, 30),
  text = rgb(250, 250, 250),
  disconnected = rgb(136, 136, 136),
  gain = rgb(120, 225, 107),
  loss = rgb(140, 29, 30),
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
    [1] = rgb(182, 34, 32), -- Hated
    [2] = rgb(182, 34, 32), -- Hostile
    [3] = rgb(182, 92, 32), -- Unfriendly
    [4] = rgb(220, 180, 52), -- Neutral
    [5] = rgb(132, 181, 26), -- Friendly
    [6] = rgb(132, 181, 26), -- Honored
    [7] = rgb(132, 181, 26), -- Revered
    [8] = rgb(132, 181, 26), -- Exalted
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
