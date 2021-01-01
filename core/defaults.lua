local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local function rgb(r, g, b)
	return E:SetRGB({}, r, g, b)
end

-- ---------------

M.fonts = {
  light = Media.."fonts\\Oswald-Light.ttf",
  normal = Media.."fonts\\Oswald.ttf",
  medium = Media.."fonts\\Oswald-Medium.ttf",
  big = Media.."fonts\\BigNoodleTitling.ttf"
}

M.textures = {
  backdrop = "Interface\\ChatFrame\\ChatFrameBackground",
  bg = Media.."textures\\bg",
  statusbar = Media.."textures\\statusbar",
  glow = Media.."textures\\glow",
  neon = Media.."textures\\neon",
  mint = Media.."textures\\mint",
  line = Media.."textures\\line",
}

-- ---------------

D.global = {
  fonts = {
    units = {
      font = M.fonts.medium,
      outline = false,
			shadow = true,
    }
  },
  backdrop = {
    color = rgb(0, 0, 0),
    alpha = 0.8
  },
  statusbar = {
    texture = M.textures.statusbar,
    color = rgb(30, 30, 30),
    bg = {
      texture = M.textures.bg,
      alpha = 0.4,
      multiplier = 0.4
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
        width = 280,
        height = 28,
        point = {"TOP", "UIParent", "TOP", 0, -60},
        health = {
          color = {
            health = true,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "",
            size = "",
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            point = {p = "BOTTOM", anchor = "", ap = "TOP", x = 0, y = 6},
          },
        },
        power = {
          height = 1,
          gap = 2,
          color = {
            power = true,
            tapping = true,
            disconnected = false,
            class = false
          },
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
          size = 14,
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
            width = 280,
            height = 14,
            texture = M.textures.line,
            alpha = 0.9,
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
          style = "3D",
          width = 50,
          modelAlpha = 1.0,
          desaturation = 0.0,
          point = {
            p = "RIGHT",
            anchor = "",
            ap = "LEFT",
            x = 16,
            y = 0
          },
        },
        unitIndicator = {
          enabled = true,
          width = 4,
          point = {
            p = "RIGHT",
            anchor = "",
            ap = "LEFT",
            x = -6,
            y = 0
          },
        }
      },
    }
  },
  misc = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
