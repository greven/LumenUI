local _, ns = ...
local E, D, C, M = ns.E, ns.D, ns.C, ns.M

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local playerHeight = 24
local playerWidth = 228
local playerPlateHeight = 11
local playerPlateWidth = 180
local targetWidth = 287
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
  border = Media.."textures\\border",
  border_thick = Media.."textures\\border-thick",
  border = Media.."textures\\border",
  absorb = Media.."textures\\absorb",
  arrow = Media.."textures\\arrow",
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
      font = M.fonts.condensed,
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
    alpha = 0.84
  },
  border = {
    color = rgb(30, 30, 30)
  },
  statusbar = {
    texture = M.textures.statusbar,
    color = D.colors.dark_gray
  },
  shadows = {
    enabled = true,
    alpha = 0.3
  },
  castbar = {
    texture = M.textures.statusbar,
    bg = M.textures.vertlines
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
          p = "BOTTOMLEFT",
          anchor = "UIParent",
          ap = "BOTTOMLEFT",
          x = 98 + 53,
          y = 2 + 68
        },
        health = {
          enabled = true,
          kill_range = false,
          change_threshold = 0.001,
          reverse = true,
          color = {
            smooth = false,
            health = true,
            tapping = false,
            disconnected = false,
            class = false,
            reaction = false
          },
          text = {
            tag = "[lum:health_cur(true)]",
            size = 13,
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
              y = 0
            },
          },
          prediction = {
						enabled = true,
						absorb_text = {
							-- tag = "[lum:color_absorb_damage][lum_absorb_damage]|r",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 2,
							},
						},
						heal_absorb_text = {
							-- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 16,
							},
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
          prediction = {
						enabled = true,
					},
        },
        class_power = {
          enabled = false,
          prediction = {
						enabled = false,
					},
        },
        additional_power = {
          enabled = true,
          width = playerWidth,
          height = 1.5,
          prediction = {
						enabled = true,
					},
          point = {
            p = "TOPLEFT",
            anchor = "Health",
            ap = "TOPLEFT",
            x = 0,
            y = 0
          },
        },
        castbar = {
          enabled = true,
          width = 300,
          height = 24,
          thin = true,
          color = D.colors.dark_blue,
          color_by_class = true,
          max = true,
          latency = false,
          icon = {
            position = "LEFT", -- "LEFT", "RIGHT" or "NONE"
            gap = 6
          },
          text = {
            size = 15,
            outline = true,
            shadow = false,
          },
          point = {
            p = "CENTER",
            anchor = "UIParent",
            ap = "BOTTOM",
            x = 0,
            y = 250
          },
        },
        name = {
          tag = "[lum:color_difficulty][lum:level]|r [lum:name(22)]",
          size = 22,
          outline = true,
          shadow = false,
          h_alignment = "LEFT",
          v_alignment = "BOTTOM",
          word_wrap = false,
          point = {
            p = "BOTTOMLEFT",
            anchor = "Health",
            ap = "TOPLEFT",
            x = 0,
            y = 4
          },
        },
        portrait = {
          enabled = true,
          style = "3D",
          width = 82,
          height = 82,
          model_alpha = 1.0,
          desaturation = 0,
          point = {
            p = "BOTTOMRIGHT",
            anchor = "",
            ap = "BOTTOMLEFT",
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
          height = 82,
          rested = true,
          hide_out_of_combat = false,
          point = {
            p = "RIGHT",
            anchor = "Portrait",
            ap = "LEFT",
            x = -8,
            y = 0
          },
        },
        pvp = {
          enabled = true,
          width = 32,
          height = playerHeight,
          alpha = 1,
          point = {
            p = "TOPRIGHT",
            anchor = "Portrait",
            ap = "TOPRIGHT",
            x = 5,
            y = 5
          },
        },
        auras = {
          enabled = true,
          rows = 2,
          per_row = 8,
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
                boss = false,
                tank = false,
                healer = false,
                mount = false,
                selfcast = false,
                selfcast_permanent = false,
                player = false,
                player_permanent = false,
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
                misc = true,
              },
            },
            enemy = {
              buff = {
                boss = false,
                tank = false,
                healer = false,
                mount = false,
                selfcast = false,
                selfcast_permanent = false,
                player = false,
                player_permanent = false,
                dispellable = false,
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
        },
        threat = {
					enabled = true,
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
          reverse = false,
          color = {
            smooth = false,
            health = false,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "[lum:health_cur(true)]",
            size = 15,
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
          prediction = {
						enabled = true,
						absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 2,
							},
						},
						heal_absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 16,
							},
						},
					},
          perc = {
            tag = "[lum:health_perc]",
            size = 18,
            color = D.colors.light_gray,
            alpha = 0.9,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            hide_when_max = true,
            point = {
              p = "BOTTOMRIGHT",
              anchor = "",
              ap = "TOPRIGHT",
              x = 2,
              y = 4
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
          height = 20,
          thin = true,
          color = D.colors.dark_blue,
          class_colored = false,
          max = false,
          latency = false,
          icon = {
            position = "LEFT", -- "LEFT", "RIGHT" or "NONE"
            gap = 5
          },
          text = {
            size = 13,
            outline = true,
            shadow = false,
          },
          point = {
            p = "TOPLEFT",
            anchor = "Health",
            ap = "BOTTOMLEFT",
            x = 0,
            y = -76
          },
        },
        name = {
          tag = "[lum:name(32)]",
          size = 16,
          outline = true,
          shadow = false,
          h_alignment = "LEFT",
          v_alignment = "MIDDLE",
          word_wrap = false,
          point = {
            p = "LEFT",
            anchor = "",
            ap = "LEFT",
            x = 6,
            y = -1
          },
        },
        portrait = {
          enabled = true,
          style = "3D",
          width = targetHeight * 1.75,
          height = targetHeight,
          model_alpha = 1.0,
          desaturation = 0,
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
            anchor = "Portrait",
            ap = "LEFT",
            x = -8,
            y = 0
          },
        },
        auras = {
          enabled = true,
          rows = 3,
          per_row = 10,
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
        },
        raid_target = {
          enabled = true,
          size = 24,
          point = {
            p = "RIGHT",
            anchor = "Portrait",
            ap = "LEFT",
            x = -20,
            y = 0,
          },
        },
        threat = {
          enabled = true,
          feedback_unit = "player",
        },
      },
      targettarget = {
        enabled = true,
        width = 143,
        height = 18,
        point = {
          p = "LEFT",
          anchor = "LumenTargetFrame",
          ap = "RIGHT",
          x = 40,
          y = 0
        },
        health = {
          enabled = true,
          kill_range = false,
          reverse = false,
          color = {
            smooth = false,
            health = false,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "[lum:health_perc]",
            size = 12,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            hide_when_max = false,
            point = {
              p = "RIGHT",
              anchor = "",
              ap = "RIGHT",
              x = -4,
              y = 1
            },
          },
          prediction = {
						enabled = true,
						absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 2,
							},
						},
						heal_absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 16,
							},
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
        name = {
          tag = "[lum:color_difficulty][lum:level]|r [lum:name(21)]",
          size = 13,
          outline = true,
          shadow = false,
          h_alignment = "LEFT",
          v_alignment = "MIDDLE",
          word_wrap = false,
          point = {
            p = "BOTTOMLEFT",
            anchor = "",
            ap = "TOPLEFT",
            x = 4,
            y = 4
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
      },
      focus = {
        enabled = true,
        width = 173,
        height = 18,
        point = {
          p = "LEFT",
          anchor = "LumenPlayerPlateFrame",
          ap = "RIGHT",
          x = 31,
          y = 0
        },
        health = {
          enabled = true,
          kill_range = false,
          reverse = false,
          color = {
            smooth = false,
            health = false,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "[lum:health_cur]",
            size = 12,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            hide_when_max = false,
            point = {
              p = "RIGHT",
              anchor = "",
              ap = "RIGHT",
              x = -4,
              y = 1
            },
          },
          prediction = {
						enabled = true,
						absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 2,
							},
						},
						heal_absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 16,
							},
						},
          },
          perc = {
            tag = "[lum:health_perc]",
            size = 15,
            color = D.colors.light_gray,
            alpha = 0.9,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            hide_when_max = true,
            point = {
              p = "BOTTOMRIGHT",
              anchor = "",
              ap = "TOPRIGHT",
              x = 2,
              y = 4
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
          width = 173,
          height = 16,
          thin = true,
          color = D.colors.dark_blue,
          class_colored = false,
          max = false,
          latency = false,
          icon = {
            position = "NONE", -- "LEFT", "RIGHT" or "NONE"
            gap = 4
          },
          text = {
            size = 13,
            outline = true,
            shadow = false,
          },
          point = {
            p = "BOTTOMLEFT",
            anchor = "Health",
            ap = "TOPLEFT",
            x = 0,
            y = 28
          },
        },
        name = {
          tag = "[lum:color_difficulty][lum:level]|r [lum:name(21)]",
          size = 13,
          outline = true,
          shadow = false,
          h_alignment = "LEFT",
          v_alignment = "MIDDLE",
          word_wrap = false,
          point = {
            p = "BOTTOMLEFT",
            anchor = "",
            ap = "TOPLEFT",
            x = 4,
            y = 4
          },
        },
        auras = {
          enabled = true,
          rows = 2,
          per_row = 6,
          spacing = 4,
          size_override = 25,
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
        },
        raid_target = {
          enabled = true,
          size = 24,
          point = {
            p = "LEFT",
            anchor = "",
            ap = "RIGHT",
            x = 12,
            y = 0,
          },
        },
        threat = {
          enabled = true,
          feedback_unit = "player",
        },
      },
      pet = {
        enabled = true,
        width = 135,
        height = 17,
        point = {
          p = "LEFT",
          anchor = "LumenPlayerFrame",
          ap = "RIGHT",
          x = 16,
          y = 0
        },
        health = {
          enabled = true,
          kill_range = false,
          reverse = true,
          color = {
            smooth = false,
            health = false,
            tapping = true,
            disconnected = true,
            class = true,
            reaction = true
          },
          text = {
            tag = "[lum:health_perc]",
            size = 12,
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
          prediction = {
						enabled = true,
						absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 2,
							},
						},
						heal_absorb_text = {
							tag = "",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 16,
							},
						},
          },
          perc = {
            tag = "[lum:health_perc]",
            size = 15,
            color = D.colors.light_gray,
            alpha = 0.9,
            outline = true,
            shadow = false,
            h_alignment = "RIGHT",
            v_alignment = "MIDDLE",
            hide_when_max = true,
            point = {
              p = "BOTTOMRIGHT",
              anchor = "",
              ap = "TOPRIGHT",
              x = 2,
              y = 4
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
          width = 135,
          height = 12,
          thin = true,
          color = D.colors.dark_blue,
          class_colored = false,
          max = false,
          latency = false,
          icon = {
            position = "NONE", -- "LEFT", "RIGHT" or "NONE"
            gap = 4
          },
          text = {
            size = 12,
            outline = true,
            shadow = false,
          },
          point = {
            p = "BOTTOMLEFT",
            anchor = "Health",
            ap = "TOPLEFT",
            x = 0,
            y = 28
          },
        },
        name = {
          tag = "[lum:name(20)]",
          size = 12,
          outline = true,
          shadow = false,
          h_alignment = "LEFT",
          v_alignment = "MIDDLE",
          word_wrap = false,
          point = {
            p = "LEFT",
            anchor = "",
            ap = "LEFT",
            x = 4,
            y = 1
          },
        },
        auras = {
          enabled = true,
          rows = 1,
          per_row = 5,
          spacing = 4,
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
      playerplate = {
        enabled = true,
        width = playerPlateWidth,
        height = playerPlateHeight,
        visibility = "[harm,nodead][combat][group,noflying] show; hide;",
        point = {
          p = "CENTER",
          anchor = "UIParent",
          ap = "CENTER",
          x = 0,
          y = -245
        },
        health = {
          enabled = true,
          height = 4,
          kill_range = false,
          change_threshold = 0.001,
          reverse = true,
          color = {
            smooth = false,
            health = true,
            tapping = false,
            disconnected = false,
            class = false,
            reaction = false
          },
          text = {
            tag = "",
            size = 14,
            outline = true,
            shadow = false,
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            hide_when_max = true,
            point = {
              p = "CENTER",
              anchor = "",
              ap = "CENTER",
              x = 0,
              y = 0
            },
          },
          prediction = {
						enabled = true,
						absorb_text = {
							-- tag = "[lum:color_absorb_damage][lum_absorb_damage]|r",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 2,
							},
						},
						heal_absorb_text = {
							-- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
							size = 12,
							h_alignment = "CENTER",
							v_alignment = "MIDDLE",
							point1 = {
								p = "BOTTOM",
								anchor = "Health.Text",
								rP = "TOP",
								x = 0,
								y = 16,
							},
						},
					},
        },
        power = {
          enabled = true,
          height = 4,
          change_threshold = 0.01,
          color = {
            power = true,
            tapping = true,
            disconnected = false,
            class = false
          },
          text = {
            tag = "[lum:power_cur]",
            size = 15,
            outline = true,
            shadow = false,
            h_alignment = "CENTER",
            v_alignment = "MIDDLE",
            point = {
              p = "CENTER",
              anchor = "Power",
              ap = "CENTER",
              x = 0,
              y = -1
            },
          },
          prediction = {
						enabled = true,
					},
        },
        class_power = {
          enabled = true,
          width = playerPlateWidth,
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
        additional_power = {
          enabled = false,
          width = playerPlateWidth,
          height = 1.5,
          prediction = {
						enabled = false,
					},
          point = {
            p = "TOPLEFT",
            anchor = "Health",
            ap = "TOPLEFT",
            x = 0,
            y = 0
          },
        },
      },
    }
  },
  misc = {}
}

-- Copy defaults to the config table
E:CopyTable(D, C)
