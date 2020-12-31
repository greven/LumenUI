local _, ns = ...
local E, D, C = ns.E, ns.D, ns.C

-- ---------------

local function rgb(r, g, b)
	return E:SetRGB({}, r, g, b)
end

D.colors = {
  text = rgb(255, 255, 255),
  disconnected = rgb(136, 136, 136),
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
  }
}
