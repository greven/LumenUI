local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local playerHeight = 18
local playerWidth = 180
local targetWidth = 280
local targetHeight = 28

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
  line = Media.."textures\\line",
  border_thin = Media.."textures\\border-thin",
  border_thick = Media.."textures\\border-thick",
  border = Media.."textures\\border",
	aura_icons = {
		-- line #1
		["Buff"] = {1 / 128, 33 / 128, 1 / 128, 33 / 128},
		["Debuff"] = {34 / 128, 66 / 128, 1 / 128, 33 / 128},
		["Curse"] = {67 / 128, 99 / 128, 1 / 128, 33 / 128},
		-- line #2
		["Disease"] = {1 / 128, 33 / 128, 34 / 128, 66 / 128},
		["Magic"] = {34 / 128, 66 / 128, 34 / 128, 66 / 128},
		["Poison"] = {67 / 128, 99 / 128, 34 / 128, 66 / 128},
		-- line #3
		[""] = {1 / 128, 33 / 128, 67 / 128, 99 / 128}, -- Enrage
		-- ["TEMP"] = {34 / 128, 66 / 128, 67 / 128, 99 / 128},
		-- ["TEMP"] = {67 / 128, 99 / 128, 67 / 128, 99 / 128},
	},
}

-- ---------------

D.global = {
  fonts = {
    units = {
      font = {
        text = M.fonts.condensed,
        number = M.fonts.condensed,
      },
      outline = false,
			shadow = true,
    },
		cooldown = {
			font = M.fonts.normal,
			outline = true,
			shadow = false,
		},
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
  },
  aura_filters = {
		["Blacklist"] = {
			is_init = false,
		},
		["M+ Affixes"] = {
			is_init = false,
		},
	},
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
    cooldown = {
			exp_threshold = 5, -- [1; 10]
			m_ss_threshold = 600, -- [91; 3599]
		},
    units = {
      player = {
        enabled = true,
        width = playerWidth,
        height = playerHeight,
        point = {
          p = "CENTER",
          anchor = "UIParent",
          ap = "CENTER",
          x = 0,
          y = -240
        },
        health = {
          enabled = true,
          kill_range = false,
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
            hide_when_max = true,
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
          height = 2,
          gap = 2,
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
        class_power = {
          enabled = true,
          width = playerWidth,
          height = 2,
          gap = 5,
					change_threshold = 0.01,
					orientation = "HORIZONTAL",
					prediction = {
						enabled = true,
					},
					runes = {
						color_by_spec = true,
						sort_order = "none",
          },
          point = {
            p = "TOPLEFT",
            anchor = "",
            ap = "BOTTOMLEFT",
            x = 0,
            y = -8
          },
				},
        castbar = {
          enabled = true,
          width = 300,
          height = 22,
          color = D.colors.dark_blue,
          color_by_class = true,
          max = true,
          latency = false,
          icon = {
            position = "LEFT", -- "RIGHT", "NONE"
            gap = 6
          },
          text = {
            size = 13,
            outline = true,
            shadow = false,
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
          width = 2.5,
          height = playerHeight,
          hide_out_of_combat = true,
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
        width = targetWidth,
        height = targetHeight,
        point = {
          p = "TOP",
          anchor = "UIParent",
          ap = "TOP",
          x = -20,
          y = -50
        },
        health = {
          enabled = true,
          kill_range = false,
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
            hide_when_max = false,
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
          height = 1.5,
          gap = 1.5,
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
        castbar = {
          enabled = true,
          width = targetWidth,
          height = 18,
          color = D.colors.dark_blue,
          class_colored = false,
          max = false,
          latency = false,
          icon = {
            position = "LEFT", -- "RIGHT", "NONE"
            gap = 5
          },
          text = {
            size = 11,
            outline = true,
            shadow = false,
          },
          point = {
            p = "BOTTOMLEFT",
            anchor = "Health",
            ap = "TOPLEFT",
            x = 0,
            y = 7
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
          width = targetHeight * 1.75,
          height = targetHeight,
          model_alpha = 1.0,
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
          height = targetHeight,
          hide_out_of_combat = false,
          point = {
            p = "RIGHT",
            anchor = "",
            ap = "LEFT",
            x = -6,
            y = 0
          },
        },
        auras = {
          enabled = true,
          rows = 2,
          per_row = 12,
          spacing = 5,
          size_override = 0,
          x_growth = "RIGHT",
          y_growth = "DOWN",
          disable_mouse = false,
          count = {
            size = 10,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "TOP",
          },
          cooldown = {
            text = {
              enabled = true,
              size = 10,
              v_alignment = "BOTTOM",
            },
          },
          type = {
            size = 12,
            position = "TOPLEFT",
            debuff_type = false,
          },
          filter = {
            custom = {
              ["Blacklist"] = true,
              ["M+ Affixes"] = true,
            },
            friendly = {
              buff = {
                boss = true,
                tank = true,
                healer = true,
                mount = true,
                selfcast = true,
                selfcast_permanent = true,
                player = true,
                player_permanent = true,
                misc = false,
              },
              debuff = {
                boss = true,
                tank = true,
                healer = true,
                selfcast = true,
                selfcast_permanent = true,
                player = true,
                player_permanent = true,
                dispellable = true,
                misc = false,
              },
            },
            enemy = {
              buff = {
                boss = true,
                tank = true,
                healer = true,
                mount = true,
                selfcast = true,
                selfcast_permanent = true,
                player = true,
                player_permanent = true,
                dispellable = true,
                misc = false,
              },
              debuff = {
                boss = true,
                tank = true,
                healer = true,
                selfcast = true,
                selfcast_permanent = true,
                player = true,
                player_permanent = true,
                misc = false,
              },
            },
          },
          point = {
            p = "TOPLEFT",
            anchor = "",
            ap = "BOTTOMLEFT",
            x = 1,
            y = -8
          },
        }
      },
    }
  },
  misc = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
