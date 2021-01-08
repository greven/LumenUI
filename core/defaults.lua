local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local playerHeight = 18

local function rgb(r, g, b)
	return E:SetRGB({}, r, g, b)
end

-- ---------------

M.fonts = {
  normal = Media.."fonts\\Oswald.ttf",
  light = Media.."fonts\\Oswald-Light.ttf",
  medium = Media.."fonts\\Oswald-Medium.ttf",
  condensed = Media.."fonts\\BebasNeue.ttf",
  big = Media.."fonts\\BigNoodleTitling.ttf"
}

M.textures = {
  statusbar = Media.."textures\\statusbar",
  flat = Media.."textures\\statusbar",
  vertlines = Media.."textures\\vertlines",
  neon = Media.."textures\\neon",
  mint = Media.."textures\\mint",
  glow = Media.."textures\\glow",
  vertstatus = Media.."textures\\vertstatus",
  line = Media.."textures\\line",
}

-- ---------------

D.global = {
  fonts = {
    units = {
      font = {
        text = M.fonts.normal,
        number = M.fonts.condensed,
      },
      outline = false,
			shadow = true,
    }
  },
  backdrop = {
    color = rgb(0, 0, 0),
    alpha = 0.85
  },
  statusbar = {
    texture = M.textures.statusbar,
    color = D.colors.dark_gray
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
        enabled = true,
        width = 180,
        height = playerHeight,
        point = {
          p = "CENTER",
          anchor = "UIParent",
          ap = "CENTER",
          x = 0,
          y = -260
        },
        health = {
          enabled = true,
          hideTextWhenMax = true,
          killRange = false,
          change_threshold = 0.001,
          color = {
            reverse = true,
            smooth = true,
            health = true,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "[lum:health_cur(true)]",
            size = 11,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            point = {
              p = "RIGHT",
              anchor = "",
              ap = "RIGHT",
              x = -4,
              y = 1
            },
          },
        },
        power = {
          enabled = true,
          height = 1.5,
          gap = 1.5,
          change_threshold = 0.01,
          color = {
            power = true,
            tapping = true,
            disconnected = false,
            class = false
          },
          text = {
            tag = "[lum:power_cur]",
            size = 12,
            outline = true,
            shadow = false,
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            point = {
              p = "CENTER",
              anchor = "Power",
              ap = "CENTER",
              x = 0,
              y = 0
            },
          },
        },
        castbar = {
          enabled = true,
          width = 100,
          height = 20,
          latency = false,
          icon = {
            position = "LEFT", -- "RIGHT", "NONE"
          },
          text = {
            size = 12,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            point = {
              p = "RIGHT",
              anchor = "",
              ap = "RIGHT",
              x = -4,
              y = 1
            },
          },
          point = {
            p = "CENTER",
            anchor = "",
            ap = "CENTER",
            x = 0,
            y = -60
          },
        },
        name = {
          tag = "[lum:name]",
          size = 14,
          outline = true,
          shadow = false,
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
        unitIndicator = {
          enabled = true,
          width = 1.5,
          height = playerHeight,
          hideOutOfCombat = true,
          point = {
            p = "RIGHT",
            anchor = "",
            ap = "LEFT",
            x = -5,
            y = 0
          },
        }
      },
      target = {
        enabled = true,
        width = 280,
        height = 28,
        point = {
          p = "TOP",
          anchor = "UIParent",
          ap = "TOP",
          x = 25,
          y = -80
        },
        health = {
          enabled = true,
          hideTextWhenMax = false,
          killRange = false,
          color = {
            reverse = false,
            smooth = false,
            health = true,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "[lum:health_cur(true)]",
            size = 14,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            point = {
              p = "RIGHT",
              anchor = "",
              ap = "RIGHT",
              x = -6,
              y = 0
            },
          },
          perc = {
            tag = "[lum:health_perc]",
            size = 14,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            point = {
              p = "RIGHT",
              anchor = "Health.Text",
              ap = "LEFT",
              x = -4,
              y = 0
            },
          },
        },
        power = {
          enabled = true,
          height = 1,
          gap = 2,
          color = {
            power = true,
            tapping = true,
            disconnected = false,
            class = false
          },
          text = {
            tag = "",
            size = 14,
            outline = true,
            shadow = false,
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            point = {
              p = "BOTTOM",
              anchor = "",
              ap = "TOP",
              x = 0,
              y = 6
            },
          },
        },
        name = {
          tag = "[lum:color_difficulty][lum:level]|r [lum:name]",
          size = 17,
          outline = true,
          shadow = false,
          h_alignment = "CENTER",
          v_alignment = "MIDDLE",
          word_wrap = false,
          point = {
            p = "BOTTOM",
            anchor = "Health",
            ap = "TOP",
            x = 0,
            y = 4
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
          height = 28,
          modelAlpha = 1.0,
          desaturation = 0.0,
          point = {
            p = "RIGHT",
            anchor = "",
            ap = "LEFT",
            x = -6,
            y = 0
          },
          text = {
            tag = "[lum:npc_type(true)]",
            size = 13,
            outline = true,
            shadow = false,
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            point = {
              p = "BOTTOM",
              anchor = "",
              ap = "TOP",
              x = 0,
              y = 4
            },
          },
        },
        unitIndicator = {
          enabled = true,
          width = 2,
          height = 28,
          hideOutOfCombat = false,
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
