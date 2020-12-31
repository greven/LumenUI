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
  line = Media.."textures\\line",
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

D.colors = {
  text = rgb(255, 255, 255),
  disconnected = rgb(136, 136, 136),
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
    [9] = rgb(0, 110, 255) -- Paragon (Reputation)
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
          text = {
            tag = "",
            size = "",
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            point1 = {p = "BOTTOM", anchor = "", ap = "TOP", x = 0, y = 6},
          },
        },
        power = {
          height = 2,
          gap = 2,
          text = {
            tag = "",
            size = "",
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            -- point1 = {p = "BOTTOM", anchor = "", ap = "TOP", x = 0, y = 0},
          },
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
            height = 12,
            texture = M.textures.line,
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
