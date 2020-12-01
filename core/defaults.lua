local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

M.fonts = {
  main = "Interface\\AddOns\\LumenUI\\media\\fonts\\BigNoodleTitling.ttf"
}

M.textures = {}

D.colors = {}

D.modules = {
  minimap = {
    enabled = true,
    size = 200,
    pos = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -20, 40}
  },
  unitframes = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
