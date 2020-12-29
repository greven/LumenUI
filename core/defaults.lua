local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

M.fonts = {
  main = "Interface\\AddOns\\LumenUI\\media\\fonts\\BigNoodleTitling.ttf"
}

M.textures = {
  backdrop = "Interface\\ChatFrame\\ChatFrameBackground",
  glow = "Interface\\AddOns\\LumenUI\\media\\textures\\glow"
}

D.colors = {
  text = {1, 1, 1},
  backdrop = {0, 0, 0, 0.9}
}

D.theme = {
  shadows = true
}

D.modules = {
  minimap = {
    enabled = true,
    size = 200,
    pos = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -20, 40}
  },
  unitframes = {
    enabled = true,
    units = {
      player = {
        enabled = true,
      }
    }
  },
  misc = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
