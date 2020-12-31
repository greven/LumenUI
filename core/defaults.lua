local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local function rgb(r, g, b)
	return E:SetRGB({}, r, g, b)
end

-- ---------------

M.fonts = {
  main = Media.."fonts\\Oswald.ttf",
  big = Media.."fonts\\BigNoodleTitling.ttf"
}

M.textures = {
  backdrop = "Interface\\ChatFrame\\ChatFrameBackground",
  bg = Media.."textures\\bg",
  statusbar = Media.."textures\\statusbar",
  gradient = Media.."textures\\gradient",
  glow = Media.."textures\\glow",
  lines = Media.."textures\\lines",
}

-- ---------------

D.global = {
  fonts = {
    units = M.fonts.main
  },
  backdrop = {
    color = rgb(0, 0, 0),
    alpha = 0.85
  },
  statusbar = {
    bg = {
      alpha = 0.25,
      mult = 0.25
    }
  },
  shadows = {
    alpha = 0.4
  }
}

D.modules = {
  minimap = {
    enabled = true,
    size = 200,
    point = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -20, 40}
  },
  unitframes = {
    enabled = true,
    shadows = {
      enabled = true,
      alpha = D.global.shadows.alpha
    },
    units = {
      player = {
        enabled = false,
        width = 160,
        height = 20,
        point = {"CENTER", "UIParent", "CENTER", 0, -200},
        health = {
          color = {
            class = true,
            reaction = false
          }
        },
        power = {
          height = 2,
          gap = 1
        },
        portrait = {
          enabled = false
        }
      },
      target = {
        enabled = true,
        width = 320,
        height = 30,
        point = {"TOP", "UIParent", "TOP", 0, -60},
        health = {
          color = {
            class = true,
            reaction = true
          },
          -- text = {
          --   tag = "",
          --   size = "",
          --   h_alignment = "CENTER",
          --   v_alignment = "MIDDLE",
          --   point = {p = "BOTTOM", anchor = "", ap = "TOP", x = 0, y = 6},
          -- },
        },
        power = {
          height = 2,
          gap = 2,
          -- text = {
          --   tag = "",
          --   size = "",
          --   h_alignment = "CENTER",
          --   v_alignment = "MIDDLE",
          --   point = {p = "BOTTOM", anchor = "", ap = "TOP", x = 0, y = 0},
          -- },
        },
        name = {
          tag = "[lum:name(upcase)]",
          size = 16,
          outline = true,
          h_alignment = "CENTER",
          v_alignment = "MIDDLE",
          word_wrap = false,
          point = {
            p = "BOTTOM",
            anchor = "Health",
            ap = "TOP",
            x = 0,
            y = 6
          },
          background = {
            enabled = true,
            width = 220,
            height = 16,
            texture = M.textures.lines,
            point = {
              p = "CENTER",
              anchor = "Name",
              ap = "CENTER",
              x = 0,
              y = 1
            },
          }
        },
        portrait = {
          enabled = true,
          modelAlpha = 0.25,
          desaturation = 1.0
        }
      },
    }
  },
  misc = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
