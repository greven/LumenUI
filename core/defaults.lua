local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

local Media = "Interface\\AddOns\\LumenUI\\media\\"

M.fonts = {
  main = Media.."fonts\\Oswald.ttf",
  bib = Media.."fonts\\BigNoodleTitling.ttf"
}

M.textures = {
  backdrop = "Interface\\ChatFrame\\ChatFrameBackground",
  bg = Media.."textures\\bg",
  statusbar = Media.."textures\\statusbar",
  glow = Media.."textures\\glow"
}

D.colors = {
  text = {1, 1, 1},
  backdrop = {0, 0, 0, 0.85}
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
        width = 120,
        height = 20,
        pos = {"CENTER", "UIParent", "CENTER", 0, -200},
        health = {
          color = {
            class = true,
            reaction = false
          }
        },
        power = {
          height = 2,
          gap = 2
        }
      },
      target = {
        enabled = true,
        width = 300,
        height = 26,
        pos = {"TOP", "UIParent", "TOP", 0, -50},
        health = {
          color = {
            class = true,
            reaction = true
          }
        },
        power = {
          height = 2,
          gap = 2
        }
      },
    }
  },
  misc = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
