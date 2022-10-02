local _, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

-- ---------------

local playerHeight = 28
local playerWidth = 220
local playerPlateHeight = 11
local playerPlateWidth = 200
local targetWidth = playerWidth
local targetHeight = playerHeight
local targetPlateWidth = 153
local targetPlateHeight = playerPlateHeight

local function rgb(r, g, b)
    return E:SetRGB({}, r, g, b)
end

local function auraWidth(frameWidth, count, spacing)
    return (frameWidth - (spacing * (count - 1))) / count
end

-- Base colors
E.colors = {
    black = rgb(0, 0, 0),
    white = rgb(255, 255, 255),
    light_gray = rgb(210, 210, 210),
    gray = rgb(82, 82, 82),
    dark_gray = rgb(26, 26, 26),
    light_red = rgb(252, 165, 165),
    red = rgb(220, 38, 38),
    dark_red = rgb(185, 28, 28),
    light_orange = rgb(253, 186, 116),
    orange = rgb(249, 115, 22),
    dark_orange = rgb(194, 65, 12),
    light_amber = rgb(252, 211, 77),
    amber = rgb(245, 158, 11),
    dark_amber = rgb(180, 83, 9),
    light_yellow = rgb(253, 224, 71),
    yellow = rgb(234, 179, 8),
    dark_yellow = rgb(161, 98, 7),
    light_green = rgb(134, 239, 172),
    green = rgb(22, 163, 74),
    dark_green = rgb(21, 128, 61),
    light_emerald = rgb(110, 231, 183),
    emerald = rgb(16, 185, 129),
    dark_emerald = rgb(4, 120, 87),
    light_cyan = rgb(103, 232, 249),
    cyan = rgb(6, 182, 212),
    dark_cyan = rgb(14, 116, 144),
    light_blue = rgb(147, 197, 253),
    blue = rgb(59, 130, 246),
    dark_blue = rgb(29, 78, 216),
    light_violet = rgb(196, 181, 253),
    violet = rgb(139, 92, 246),
    dark_violet = rgb(109, 40, 217),
    light_purple = rgb(216, 180, 254),
    purple = rgb(168, 85, 247),
    dark_purple = rgb(126, 34, 206)
}

-- ---------------

D.global = {
    fonts = {
        bars = {
            font = M.fonts.normal,
            outline = true,
            shadow = false
        },
        units = {
            font = M.fonts.condensed,
            outline = false,
            shadow = true
        },
        cooldown = {
            font = M.fonts.normal,
            outline = true,
            shadow = false
        }
    },
    backdrop = {
        texture = M.textures.flat,
        color = rgb(5, 8, 12),
        alpha = 0.95
    },
    border = {
        texture = M.textures.border,
        color = rgb(20, 20, 20)
    },
    statusbar = {
        texture = M.textures.statusbar,
        color = E.colors.dark_gray
    },
    buttons = {
        border = {
            texture = M.textures.border,
            size = 16,
            offset = -4
        },
        texture = {
            normal = M.textures.button_normal, -- normal = "",
            highlight = M.textures.button_highlight,
            checked = M.textures.button_checked
        }
    },
    shadows = {
        enabled = true,
        alpha = 0.25
    },
    castbar = {
        texture = M.textures.neon,
        bg = M.textures.vertlines
    },
    aura_bars = {
        texture = M.textures.statusbar
    },
    aura_filters = {
        ["Blacklist"] = {
            is_init = false
        },
        ["M+ Affixes"] = {
            is_init = false
        },
        ["Class Debuffs"] = {
            is_init = false
        },
        ["Class Buffs"] = {
            is_init = false
        }
    },
    colors = {
        text = rgb(250, 250, 250),
        disconnected = E.colors.gray,
        tapped = E.colors.light_gray,
        health = E.colors.green,
        gain = E.colors.green,
        loss = E.colors.red,
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
            [4] = rgb(254, 0, 0)
        },
        quality = {
            [0] = rgb(157, 157, 157),
            [1] = rgb(255, 255, 255),
            [2] = rgb(30, 255, 0),
            [3] = rgb(0, 112, 221),
            [4] = rgb(163, 53, 238),
            [5] = rgb(255, 128, 0),
            [6] = rgb(230, 204, 128),
            [7] = rgb(0, 204, 255),
            [8] = rgb(0, 204, 255)
        },
        gyr = {
            [1] = rgb(22, 163, 74),
            [2] = rgb(253, 224, 71),
            [3] = rgb(220, 48, 38)
        },
        ryg = {
            [1] = rgb(220, 48, 38),
            [2] = rgb(253, 224, 71),
            [3] = rgb(22, 163, 74)
        },
        smooth = {185 / 255, 28 / 255, 28 / 255, -- rgb(185, 28, 28)
        253 / 255, 224 / 255, 71 / 255, -- rgb(253, 224, 71)
        22 / 255, 163 / 255, 74 / 255 -- rgb(22, 163, 74)
        },
        button = {
            normal = rgb(255, 255, 255),
            unusable = rgb(107, 108, 107),
            mana = rgb(32, 98, 165),
            range = rgb(140, 29, 30)
        },
        castbar = {
            casting = E.colors.amber,
            channeling = E.colors.green,
            failed = E.colors.red,
            notinterruptible = E.colors.gray,
            class = {
                HUNTER = E.colors.dark_green,
                WARLOCK = E.colors.dark_violet,
                PRIEST = E.colors.violet,
                PALADIN = E.colors.light_amber,
                MAGE = E.colors.dark_blue,
                ROGUE = E.colors.amber,
                DRUID = E.colors.amber,
                SHAMAN = E.colors.dark_blue,
                WARRIOR = E.colors.dark_red,
                DEATHKNIGHT = E.colors.dark_red,
                MONK = E.colors.emerald,
                DEMONHUNTER = E.colors.dark_purple
            }
        },
        cooldown = {
            expiration = rgb(240, 32, 30),
            second = rgb(246, 196, 66),
            minute = rgb(255, 255, 255),
            hour = rgb(255, 255, 255),
            day = rgb(255, 255, 255)
        },
        cooldown_gradient = {
            [1] = rgb(240, 32, 30),
            [2] = rgb(246, 196, 66),
            [3] = rgb(26, 26, 26)
        },
        reaction = {
            [1] = E.colors.dark_red, -- Hated
            [2] = E.colors.dark_red, -- Hostile
            [3] = E.colors.orange, -- Unfriendly
            [4] = E.colors.amber, -- Neutral
            [5] = E.colors.green, -- Friendly
            [6] = E.colors.green, -- Honored
            [7] = E.colors.green, -- Revered
            [8] = E.colors.green -- Exalted

        },
        difficulty = {
            impossible = rgb(230, 48, 54),
            very_difficult = rgb(230, 118, 47),
            difficult = rgb(246, 196, 66),
            standard = rgb(22, 163, 74),
            trivial = rgb(136, 137, 135)
        },
        faction = {
            Alliance = rgb(29, 114, 226),
            Horde = rgb(228, 24, 38),
            Neutral = rgb(233, 232, 231)
        },
        artifact = rgb(217, 202, 146),
        honor = rgb(255, 77, 35),
        xp = {
            [1] = rgb(0, 99, 224), -- rested
            [2] = rgb(147, 0, 140) -- normal
        },
        prediction = {
            my_heal = rgb(20, 228, 187),
            other_heal = rgb(11, 169, 139),
            damage_absorb = rgb(53, 187, 244),
            heal_absorb = rgb(178, 50, 43),
            power_cost = rgb(120, 181, 231)
        },
        zone = {
            contested = rgb(246, 196, 66),
            friendly = rgb(46, 172, 52),
            hostile = rgb(220, 68, 54),
            sanctuary = rgb(80, 219, 249)
        },
        debuff = {
            None = rgb(204, 0, 0),
            Magic = rgb(51, 153, 255),
            Curse = rgb(153, 0, 255),
            Disease = rgb(153, 102, 0),
            Poison = rgb(0, 153, 0)
        },
        buff = {
            Enchant = rgb(123, 44, 181)
        },
        power = {
            MANA = rgb(15, 135, 235),
            RAGE = rgb(240, 26, 48),
            FOCUS = rgb(242, 128, 64),
            ENERGY = rgb(246, 190, 50),
            COMBO_POINTS = rgb(240, 26, 48),
            RUNES = rgb(0, 200, 228),
            RUNIC_POWER = rgb(134, 239, 254),
            SOUL_SHARDS = rgb(162, 92, 244),
            LUNAR_POWER = rgb(90, 152, 235),
            HOLY_POWER = rgb(245, 245, 124),
            MAELSTROM = rgb(25, 160, 240),
            INSANITY = rgb(136, 72, 210),
            CHI = rgb(10, 205, 155),
            ARCANE_CHARGES = rgb(112, 75, 250),
            FURY = rgb(240, 34, 45),
            PAIN = rgb(243, 157, 0),
            AMMOSLOT = rgb(217, 140, 0),
            FUEL = rgb(12, 125, 125),
            STAGGER = {
                [1] = rgb(132, 181, 26), -- Low
                [2] = rgb(220, 180, 52), -- Medium
                [3] = rgb(182, 34, 32) -- High
            }
        },
        runes = {
            [1] = E.colors.red, -- Blood
            [2] = E.colors.blue, -- Frost
            [3] = E.colors.green -- Unholy

        }
    }
}

E:CopyTable(E.colors, D.global.colors)

D.profile = {
    auras = {
        enabled = true,
        cooldown = {
            exp_threshold = 5, -- [1; 10]
            m_ss_threshold = 600, -- [91; 3599]
            text = {
                enabled = true,
                size = 12,
                v_alignment = "BOTTOM"
                -- point = {p = "BOTTOM", x = 0, y = -18}
            }
        },
        HELPFUL = {
            size = 28,
            spacing = 6,
            -- row_gap = 20,
            x_growth = "LEFT",
            y_growth = "DOWN",
            per_row = 20,
            num_rows = 2,
            sep_own = 0,
            sort_method = "INDEX",
            sort_dir = "+",
            count = {
                enabled = true,
                size = 12,
                flag = "_Outline", -- "_Shadow", ""
                h_alignment = "RIGHT",
                v_alignment = "TOP"
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 12,
                    v_alignment = "BOTTOM"
                }
            },
            type = {
                size = 12,
                position = "TOPLEFT",
                debuff_type = false
            },
            point = {
                p = "TOPRIGHT",
                anchor = "UIParent",
                ap = "TOPRIGHT",
                x = -8,
                y = -8
            }
        },
        HARMFUL = {
            size = 28,
            spacing = 6,
            -- row_gap = 20,
            x_growth = "LEFT",
            y_growth = "DOWN",
            per_row = 16,
            num_rows = 1,
            sep_own = 0,
            sort_method = "INDEX",
            sort_dir = "+",
            count = {
                enabled = true,
                size = 12,
                flag = "_Outline", -- "_Shadow", ""
                h_alignment = "RIGHT",
                v_alignment = "TOP"
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 12,
                    v_alignment = "BOTTOM"
                }
            },
            type = {
                size = 12,
                position = "TOPLEFT",
                debuff_type = false
            },
            point = {
                p = "BOTTOMRIGHT",
                anchor = "Minimap",
                ap = "BOTTOMLEFT",
                x = -8,
                y = 0
            }
        },
        TOTEM = {
            num = 4,
            size = 28,
            spacing = 6,
            x_growth = "LEFT",
            y_growth = "UP",
            per_row = 4,
            cooldown = {
                text = {
                    enabled = true,
                    size = 12,
                    v_alignment = "BOTTOM"
                }
            },
            point = {
                p = "BOTTOMRIGHT",
                anchor = "Minimap",
                ap = "BOTTOMLEFT",
                x = -6,
                y = 34
            }
        }
    },
    bags = {
        enabled = true
    },
    bars = {
        enabled = true,
        restricted = false,
        mana_indicator = "button", -- hotkey
        range_indicator = "button", -- hotkey
        lock = true, -- watch: LOCK_ACTIONBAR
        rightclick_selfcast = true,
        click_on_down = false,
        blizz_vehicle = false,
        cooldown = {
            exp_threshold = 5,
            m_ss_threshold = 120 -- [91; 3599]
        },
        desaturation = {
            unusable = true,
            mana = true,
            range = true
        },
        bar1 = {
            -- MainMenuBar
            flyout_dir = "UP",
            grid = false,
            num = 12,
            per_row = 6,
            size = 28,
            spacing = 6,
            visibility = "[petbattle] hide; [vehicleui][overridebar][possessbar][harm,nodead][combat][group][mod:alt] show; [] hide; show",
            visible = true,
            x_growth = "RIGHT",
            y_growth = "DOWN",
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 12
            },
            macro = {
                enabled = false,
                size = 12
            },
            count = {
                enabled = true,
                size = 12
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 13,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "TOP",
                anchor = "LumPlayerPlateFrame",
                ap = "BOTTOM",
                x = 0,
                y = -8
            }
        },
        bar2 = {
            -- MultiBarBottomLeft
            flyout_dir = "UP",
            grid = true,
            num = 12,
            per_row = 12,
            size = 30,
            spacing = 6,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            x_growth = "RIGHT",
            y_growth = "DOWN",
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 12
            },
            macro = {
                enabled = false,
                size = 12
            },
            count = {
                enabled = true,
                size = 12
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 13,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 20
            }
        },
        bar3 = {
            -- MultiBarBottomRight
            flyout_dir = "UP",
            grid = true,
            num = 12,
            per_row = 12,
            size = 30,
            spacing = 6,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            x_growth = "RIGHT",
            y_growth = "DOWN",
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 12
            },
            macro = {
                enabled = false,
                size = 12
            },
            count = {
                enabled = true,
                size = 12
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 13,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 20 + 36
            }
        },
        bar4 = {
            -- MultiBarLeft
            flyout_dir = "LEFT",
            grid = false,
            num = 12,
            per_row = 1,
            size = 30,
            spacing = 6,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            x_growth = "LEFT",
            y_growth = "DOWN",
            fade = {
                enabled = true,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 12
            },
            macro = {
                enabled = false,
                size = 12
            },
            count = {
                enabled = true,
                size = 12
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 13,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "RIGHT",
                anchor = "UIParent",
                ap = "RIGHT",
                x = -40,
                y = 0
            }
        },
        bar5 = {
            -- MultiBarRight
            flyout_dir = "LEFT",
            grid = false,
            num = 12,
            per_row = 1,
            size = 30,
            spacing = 6,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            x_growth = "LEFT",
            y_growth = "DOWN",
            fade = {
                enabled = true,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 12
            },
            macro = {
                enabled = false,
                size = 12
            },
            count = {
                enabled = true,
                size = 12
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 13,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "RIGHT",
                anchor = "UIParent",
                ap = "RIGHT",
                x = -4,
                y = 0
            }
        },
        bar6 = {
            -- PetAction
            flyout_dir = "UP",
            grid = false,
            num = 10,
            per_row = 10,
            size = 24,
            spacing = 5,
            visibility = "[pet,nopetbattle,novehicleui,nooverridebar,nopossessbar] show; hide",
            visible = true,
            x_growth = "RIGHT",
            y_growth = "DOWN",
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 10
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 10,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 140
            }
        },
        bar7 = {
            -- Stance
            flyout_dir = "UP",
            num = 10,
            per_row = 10,
            size = 24,
            spacing = 6,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            x_growth = "RIGHT",
            y_growth = "DOWN",
            fade = {
                enabled = true,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 10
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 10,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = -16,
                y = 24 + 72
            }
        },
        pet_battle = {
            num = 6,
            per_row = 6,
            size = 30,
            spacing = 6,
            visibility = "[petbattle] show; hide",
            visible = true,
            x_growth = "RIGHT",
            y_growth = "DOWN",
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 12
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 20
            }
        },
        extra = {
            -- ExtraAction
            size = 30,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            hotkey = {
                enabled = true,
                size = 14
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 14,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = -248,
                y = 38
            }
        },
        zone = {
            -- ZoneAbility
            size = 40,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            visible = true,
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            cooldown = {
                text = {
                    enabled = true,
                    size = 14,
                    v_alignment = "MIDDLE"
                }
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 94,
                y = 250
            }
        },
        vehicle = {
            -- LeaveVehicle
            size = 32,
            visible = true,
            blizz_vehicle = true,
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 248,
                y = 38
            }
        },
        micromenu = {
            visible = true,
            fade = {
                enabled = true,
                out_delay = 4,
                out_duration = 0.2,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0.1,
                max_alpha = 1
            },
            bars = {
                micromenu1 = {
                    enabled = true,
                    -- visibility = "[mod:alt] show; hide",
                    num = 13,
                    per_row = 13,
                    width = 22,
                    height = 28,
                    spacing = 4,
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    point = {
                        p = "BOTTOMRIGHT",
                        anchor = "UIParent",
                        ap = "BOTTOMRIGHT",
                        x = -4,
                        y = 4
                    }
                },
                micromenu2 = {
                    enabled = true,
                    -- visibility = "[mod:alt] show; hide",
                    num = 13,
                    per_row = 13,
                    width = 22,
                    height = 28,
                    spacing = 4,
                    x_growth = "RIGHT",
                    y_growth = "DOWN"
                },
                bags = {
                    enabled = true,
                    num = 4,
                    per_row = 4,
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    size = 30,
                    spacing = 4,
                    point = {
                        p = "BOTTOMRIGHT",
                        anchor = "UIParent",
                        ap = "BOTTOMRIGHT",
                        x = -4,
                        y = 38
                    }
                }
            },
            buttons = {
                character = {
                    enabled = true,
                    parent = "micromenu1",
                    tooltip = false
                },
                inventory = {
                    enabled = true,
                    parent = "micromenu1",
                    tooltip = true,
                    currency = {}
                },
                spellbook = {
                    enabled = true,
                    parent = "micromenu1"
                },
                talent = {
                    enabled = true,
                    parent = "micromenu1"
                },
                achievement = {
                    enabled = true,
                    parent = "micromenu1"
                },
                quest = {
                    enabled = true,
                    parent = "micromenu1",
                    tooltip = true
                },
                guild = {
                    enabled = true,
                    parent = "micromenu1"
                },
                lfd = {
                    enabled = true,
                    parent = "micromenu1",
                    tooltip = true
                },
                collection = {
                    enabled = true,
                    parent = "micromenu1"
                },
                ej = {
                    enabled = true,
                    parent = "micromenu1",
                    tooltip = true
                },
                store = {
                    enabled = false,
                    parent = "micromenu1"
                },
                main = {
                    enabled = true,
                    parent = "micromenu1",
                    tooltip = true
                },
                help = {
                    enabled = false,
                    parent = "micromenu1"
                }
            }
        },
        xpbar = {
            enabled = true,
            visible = true,
            width = 427,
            height = 4,
            texture = M.textures.statusbar,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            spark = true,
            text = {
                size = 10,
                format = "NUM_PERC", -- "NUM or NUM_PERC"
                visibility = 2, -- 1 - always, 2 - mouseover
                position = "CENTER" -- "TOP", "CENTER"
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 10
            },
            fade = {
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            }
        },
        threatbar = {
            enabled = true,
            width = 426,
            height = 20,
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 0
            }
        }
    },
    blizzard = {
        enabled = true,
        character_frame = {
            enabled = true,
            ilvl = true,
            enhancements = true
        },
        durability = {
            enabled = true,
            point = {"TOPRIGHT", -4, -196}
        },
        errors_frame = {
            enabled = true,
            width = 512,
            height = 60,
            text = {
                font = M.fonts.normal,
                size = 14,
                outline = false,
                shadow = true
            },
            point = {
                p = "TOP",
                x = 0,
                y = -250
            }
        },
        objective_tracker = {
            enabled = true,
            height = 600,
            point = {"TOPRIGHT", "Minimap", "BOTTOMRIGHT", -132, -48}
        },
        player_alt_power_bar = {
            enabled = true
        },
        talking_head = {
            enabled = true,
            hide = false
        },
        vehicle = {
            enabled = true,
            size = 90,
            point = {"TOPRIGHT", "Minimap", "BOTTOMRIGHT", 8, -42}
        }
    },
    movers = {},
    minimap = {
        enabled = true,
        size = 200,
        square = true,
        collect = {
            enabled = true,
            tooltip = true,
            calendar = false,
            garrison = false,
            mail = false,
            queue = false,
            tracking = false
        },
        buttons = {
            MinimapButtonCollection = 0,
            MiniMapTrackingButton = 22,
            GameTimeFrame = 45,
            MiniMapMailFrame = 135,
            GarrisonLandingPageMinimapButton = 180,
            QueueStatusMinimapButton = 270
        },
        color = {
            border = false,
            zone_text = true
        },
        point = {"BOTTOMRIGHT", -8, 44}
    },
    misc = {
        enabled = true,
        bindings = {
            enabled = true
        },
        merchant = {
            enabled = true,
            auto_repair = {
                enabled = true,
                use_guild_funds = true
            },
            vendor_grays = {
                enabled = true
            }
        }
    },
    tooltips = {
        enabled = true,
        scale = 1,
        alpha = 0.9,
        border = {
            size = 10,
            color_quality = true,
            color_class = false
        },
        health = {
            height = 5,
            color_class = true,
            text = {
                show = false,
                size = 12
            }
        },
        id = true,
        spell_id = "SHOW", -- SHOW, HIDE, ON_SHIFT_DOWN
        aura_id = "ON_SHIFT_DOWN", -- SHOW, HIDE, ON_SHIFT_DOWN
        count = true,
        title = true,
        target = true,
        inspect = true,
        anchor_cursor = false,
        point = {
            p = "BOTTOMRIGHT",
            anchor = "Minimap",
            ap = "BOTTOMLEFT",
            x = -8,
            y = -1
        }
    },
    unitframes = {
        enabled = true,
        shadows = {
            enabled = true,
            alpha = D.global.shadows.alpha
        },
        cooldown = {
            exp_threshold = 5, -- [1; 10]
            m_ss_threshold = 600 -- [91; 3599]
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
                    x = -240,
                    y = -288
                },
                health = {
                    enabled = true,
                    kill_range = false,
                    change_threshold = 0.001,
                    reverse = false,
                    color = {
                        smooth = false,
                        health = false,
                        tapping = false,
                        disconnected = false,
                        class = true,
                        reaction = false
                    },
                    text = {
                        tag = "[lum:health_cur(true,true)]",
                        size = 16,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "MIDDLE",
                        hide_when_max = true,
                        point = {
                            p = "RIGHT",
                            anchor = "Health",
                            ap = "RIGHT",
                            x = -4,
                            y = 0
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            -- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "[lum:health_perc]",
                        size = 18,
                        color = E.colors.light_gray,
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
                        }
                    }
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
                        size = 13,
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
                        }
                    },
                    prediction = {
                        enabled = true
                    }
                },
                class_power = {
                    enabled = false,
                    prediction = {
                        enabled = false
                    }
                },
                additional_power = {
                    enabled = true,
                    width = playerWidth,
                    height = 3,
                    prediction = {
                        enabled = true
                    },
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = 0,
                        y = -12
                    }
                },
                castbar = {
                    enabled = true,
                    width = 427,
                    height = 26,
                    thin = true,
                    color = E.colors.dark_blue,
                    color_by_class = true,
                    max = true,
                    latency = false,
                    icon = {
                        position = "LEFT", -- "LEFT", "RIGHT" or "NONE"
                        gap = 6
                    },
                    text = {
                        size = 16,
                        outline = true,
                        shadow = false
                    },
                    point = {
                        p = "BOTTOM",
                        anchor = "UIParent",
                        ap = "BOTTOM",
                        x = 0,
                        y = 24 + 82
                    }
                },
                name = {
                    tag = "[lum:name(24)]",
                    size = 16,
                    outline = true,
                    shadow = false,
                    h_alignment = "LEFT",
                    v_alignment = "BOTTOM",
                    word_wrap = false,
                    point = {
                        p = "LEFT",
                        anchor = "",
                        ap = "LEFT",
                        x = 5,
                        y = 1.5
                    }
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
                        x = -7,
                        y = 0
                    },
                    text = {
                        tag = "[lum:npc_type(true)]",
                        size = 15,
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
                        }
                    }
                },
                unitIndicator = {
                    enabled = true,
                    width = 2,
                    height = playerHeight,
                    rested = true,
                    hide_out_of_combat = false,
                    point = {
                        p = "RIGHT",
                        anchor = "Portrait",
                        ap = "LEFT",
                        x = -7,
                        y = 0
                    }
                },
                pvp = {
                    enabled = true,
                    width = 30,
                    height = playerHeight,
                    alpha = 1,
                    point = {
                        p = "TOPRIGHT",
                        anchor = "Portrait",
                        ap = "TOPRIGHT",
                        x = 4,
                        y = 4
                    }
                },
                auras = {
                    enabled = false,
                    rows = 2,
                    per_row = 8,
                    spacing = 5,
                    size_override = auraWidth(playerWidth, 8, 5),
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
                    animate = {
                        buff = false,
                        debuff = false
                    },
                    count = {
                        size = 10,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "TOP"
                    },
                    cooldown = {
                        text = {
                            enabled = true,
                            size = 10,
                            v_alignment = "BOTTOM"
                        }
                    },
                    type = {
                        size = 10,
                        position = "TOPLEFT",
                        debuff_type = false
                    },
                    filter = {
                        custom = {
                            ["Blacklist"] = true,
                            ["M+ Affixes"] = true
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
                                misc = true
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                dispellable = false,
                                misc = false
                            }
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                misc = false
                            }
                        }
                    },
                    point = {
                        p = "TOPLEFT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = -72,
                        y = -12
                    }
                },
                threat = {
                    enabled = true
                }
            },
            target = {
                enabled = true,
                width = targetWidth,
                height = targetHeight,
                point = {
                    p = "CENTER",
                    anchor = "UIParent",
                    ap = "CENTER",
                    x = 240,
                    y = -288
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
                        class = false,
                        reaction = true
                    },
                    text = {
                        tag = "[lum:health_cur(true,true)]",
                        size = 16,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "MIDDLE",
                        hide_when_max = false,
                        point = {
                            p = "RIGHT",
                            anchor = "",
                            ap = "RIGHT",
                            x = -5,
                            y = 1.5
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            tag = "",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "[lum:health_perc]",
                        size = 18,
                        color = E.colors.light_gray,
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
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 2,
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
                        }
                    }
                },
                castbar = {
                    enabled = true,
                    width = 440,
                    height = 26,
                    thin = true,
                    color = E.colors.dark_blue,
                    class_colored = false,
                    max = false,
                    latency = false,
                    icon = {
                        position = "LEFT", -- "LEFT", "RIGHT" or "NONE"
                        gap = 6
                    },
                    text = {
                        size = 16,
                        outline = true,
                        shadow = false
                    },
                    point = {
                        p = "TOP",
                        anchor = "UIParent",
                        ap = "TOP",
                        x = 0,
                        y = -200
                    }
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
                        x = 5,
                        y = 1.5
                    }
                },
                portrait = {
                    enabled = true,
                    style = "3D",
                    width = targetHeight * 1.75,
                    height = targetHeight,
                    model_alpha = 1.0,
                    desaturation = 0,
                    point = {
                        p = "LEFT",
                        anchor = "",
                        ap = "RIGHT",
                        x = 7,
                        y = 0
                    },
                    text = {
                        tag = "[lum:npc_type(true)]",
                        size = 15,
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
                        }
                    }
                },
                unitIndicator = {
                    enabled = true,
                    width = 2,
                    height = targetHeight,
                    hide_out_of_combat = false,
                    point = {
                        p = "LEFT",
                        anchor = "Portrait",
                        ap = "RIGHT",
                        x = 6,
                        y = 0
                    }
                },
                pvp = {
                    enabled = true,
                    width = 30,
                    height = playerHeight,
                    alpha = 1,
                    point = {
                        p = "TOPRIGHT",
                        anchor = "Portrait",
                        ap = "TOPRIGHT",
                        x = 4,
                        y = 4
                    }
                },
                auras = {
                    enabled = true,
                    rows = 3,
                    per_row = 10,
                    spacing = 5,
                    size_override = auraWidth(targetWidth, 8, 4),
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
                    animate = {
                        buff = false,
                        debuff = false
                    },
                    count = {
                        size = 10,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "TOP"
                    },
                    cooldown = {
                        text = {
                            enabled = true,
                            size = 10,
                            v_alignment = "BOTTOM"
                        }
                    },
                    type = {
                        size = 10,
                        position = "TOPLEFT",
                        debuff_type = false
                    },
                    filter = {
                        custom = {
                            ["Blacklist"] = true,
                            ["M+ Affixes"] = true
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
                                misc = false
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
                                misc = false
                            }
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
                                misc = false
                            },
                            debuff = {
                                boss = true,
                                tank = true,
                                healer = true,
                                selfcast = true,
                                selfcast_permanent = true,
                                player = true,
                                player_permanent = true,
                                misc = false
                            }
                        }
                    },
                    point = {
                        p = "TOPLEFT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = 1,
                        y = -8
                    }
                },
                raid_target = {
                    enabled = true,
                    size = 24,
                    point = {
                        p = "RIGHT",
                        anchor = "Portrait",
                        ap = "LEFT",
                        x = -20,
                        y = 0
                    }
                },
                threat = {
                    enabled = true,
                    feedback_unit = "player"
                }
            },
            targettarget = {
                enabled = false,
                width = 144,
                height = 18,
                point = {
                    p = "LEFT",
                    anchor = "LumTargetFrame",
                    ap = "RIGHT",
                    x = 41,
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
                        class = false,
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
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            tag = "",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    }
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
                        }
                    }
                },
                name = {
                    tag = "[lum:color_difficulty][lum:level]|r [lum:name_abbr]",
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
                    }
                },
                raid_target = {
                    enabled = true,
                    size = 24,
                    point = {
                        p = "LEFT",
                        anchor = "",
                        ap = "RIGHT",
                        x = 12,
                        y = 0
                    }
                },
                threat = {
                    enabled = true,
                    feedback_unit = "player"
                }
            },
            focus = {
                enabled = true,
                width = targetPlateWidth,
                height = targetPlateHeight,
                point = {
                    p = "RIGHT",
                    anchor = "LumPlayerPlateFrame",
                    ap = "LEFT",
                    x = -31,
                    y = 0
                },
                health = {
                    enabled = true,
                    height = 7,
                    kill_range = false,
                    change_threshold = 0.001,
                    reverse = false,
                    color = {
                        smooth = false,
                        health = true,
                        tapping = true,
                        disconnected = true,
                        class = true,
                        reaction = true
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
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            -- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "[lum:health_cur_perc]",
                        size = 15,
                        color = E.colors.light_gray,
                        alpha = 0.9,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "MIDDLE",
                        hide_when_max = false,
                        point = {
                            p = "RIGHT",
                            anchor = "",
                            ap = "LEFT",
                            x = -6,
                            y = 0
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 2,
                    change_threshold = 0.01,
                    color = {
                        power = true,
                        tapping = true,
                        disconnected = false,
                        class = false
                    },
                    text = {
                        tag = "",
                        size = 16,
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
                        }
                    },
                    prediction = {
                        enabled = true
                    }
                },
                castbar = {
                    enabled = true,
                    width = targetPlateWidth + 34,
                    height = 18,
                    thin = true,
                    color = E.colors.dark_blue,
                    class_colored = false,
                    max = false,
                    latency = false,
                    icon = {
                        position = "LEFT", -- "LEFT", "RIGHT" or "NONE"
                        gap = 4
                    },
                    text = {
                        size = 12,
                        outline = true,
                        shadow = false
                    },
                    point = {
                        p = "BOTTOMRIGHT",
                        anchor = "Health",
                        ap = "TOPRIGHT",
                        x = 0,
                        y = 32
                    }
                },
                name = {
                    tag = "[lum:color_difficulty][lum:level]|r[lum:npc_type_short(true)] [lum:name_abbr]",
                    size = 13,
                    outline = true,
                    shadow = false,
                    h_alignment = "LEFT",
                    v_alignment = "MIDDLE",
                    word_wrap = false,
                    point = {
                        p = "LEFT",
                        anchor = "",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 10
                    }
                },
                auras = {
                    enabled = true,
                    rows = 2,
                    per_row = 5,
                    spacing = 5,
                    size_override = auraWidth(targetPlateWidth, 5, 5),
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
                    animate = {
                        buff = false,
                        debuff = false
                    },
                    count = {
                        size = 10,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "TOP"
                    },
                    cooldown = {
                        text = {
                            enabled = true,
                            size = 10,
                            v_alignment = "BOTTOM"
                        }
                    },
                    type = {
                        size = 10,
                        position = "TOPLEFT",
                        debuff_type = false
                    },
                    filter = {
                        custom = {
                            ["Blacklist"] = true,
                            ["M+ Affixes"] = true
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                dispellable = false,
                                misc = false
                            }
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = true,
                                player_permanent = false,
                                misc = false
                            }
                        }
                    },
                    point = {
                        p = "TOPLEFT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = 1,
                        y = -8
                    }
                },
                raid_target = {
                    enabled = true,
                    size = 18,
                    point = {
                        p = "RIGHT",
                        anchor = "Health",
                        ap = "LEFT",
                        x = -8,
                        y = 20
                    }
                },
                threat = {
                    enabled = true,
                    feedback_unit = "player"
                }
            },
            focustarget = {
                enabled = false,
                width = 143,
                height = 18,
                point = {
                    p = "LEFT",
                    anchor = "LumFocusFrame",
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
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            tag = "",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    }
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
                        }
                    }
                },
                castbar = {
                    enabled = true,
                    width = 143,
                    height = 16,
                    thin = true,
                    color = E.colors.dark_blue,
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
                        shadow = false
                    },
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "Health",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 28
                    }
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
                    }
                },
                raid_target = {
                    enabled = true,
                    size = 20,
                    point = {
                        p = "LEFT",
                        anchor = "",
                        ap = "RIGHT",
                        x = 10,
                        y = 1
                    }
                },
                threat = {
                    enabled = true,
                    feedback_unit = "player"
                }
            },
            pet = {
                enabled = true,
                width = 135,
                height = 17,
                visibility = "[vehicleui][petbattle][overridebar][possessbar][@pet,noexists] hide; [@pet,exists] show",
                point = {
                    p = "LEFT",
                    anchor = "LumPlayerFrame",
                    ap = "RIGHT",
                    x = 17,
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
                        hide_when_max = false,
                        point = {
                            p = "RIGHT",
                            anchor = "",
                            ap = "RIGHT",
                            x = -2,
                            y = 1.5
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            tag = "",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "",
                        size = 15,
                        color = E.colors.light_gray,
                        alpha = 0.9,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "MIDDLE",
                        hide_when_max = true,
                        point = {
                            p = "RIGHT",
                            anchor = "",
                            ap = "RIGHT",
                            x = 2,
                            y = 0
                        }
                    }
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
                        }
                    }
                },
                castbar = {
                    enabled = true,
                    width = 135,
                    height = 8,
                    thin = true,
                    color = E.colors.dark_blue,
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
                        shadow = false
                    },
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 10
                    }
                },
                name = {
                    tag = "[lum:color(gray)][lum:level]|r [lum:name(17)]",
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
                        x = 2,
                        y = 1.5
                    }
                },
                auras = {
                    enabled = true,
                    rows = 1,
                    per_row = 5,
                    spacing = 5,
                    size_override = 0,
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
                    animate = {
                        buff = false,
                        debuff = false
                    },
                    count = {
                        size = 10,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "TOP"
                    },
                    cooldown = {
                        text = {
                            enabled = true,
                            size = 10,
                            v_alignment = "BOTTOM"
                        }
                    },
                    type = {
                        size = 10,
                        position = "TOPLEFT",
                        debuff_type = false
                    },
                    filter = {
                        custom = {
                            ["Blacklist"] = true,
                            ["M+ Affixes"] = true
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
                                misc = false
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
                                misc = false
                            }
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
                                misc = false
                            },
                            debuff = {
                                boss = true,
                                tank = true,
                                healer = true,
                                selfcast = true,
                                selfcast_permanent = true,
                                player = true,
                                player_permanent = true,
                                misc = false
                            }
                        }
                    },
                    point = {
                        p = "TOPLEFT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = 1,
                        y = -8
                    }
                }
            },
            playerplate = {
                enabled = true,
                width = playerPlateWidth,
                height = playerPlateHeight,
                visibility = "[petbattle,overridebar,possessbar] hide; [vehicleui][harm,nodead][combat][group][mod:alt] show; [] hide; show",
                attached = true, -- Attach Position to Blizzard's Player nameplate
                point = {
                    p = "CENTER",
                    anchor = "UIParent",
                    ap = "CENTER",
                    x = 0,
                    y = -242
                },
                health = {
                    enabled = true,
                    height = 7,
                    kill_range = false,
                    change_threshold = 0.001,
                    reverse = true,
                    color = {
                        smooth = true,
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
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            -- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "",
                        size = 14,
                        color = E.colors.light_gray,
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
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 2,
                    change_threshold = 0.01,
                    color = {
                        power = true,
                        tapping = true,
                        disconnected = false,
                        class = false
                    },
                    text = {
                        tag = "[lum:power_cur]",
                        size = 16,
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
                        }
                    },
                    prediction = {
                        enabled = true
                    }
                },
                class_power = {
                    enabled = true,
                    width = playerPlateWidth,
                    height = 3,
                    change_threshold = 0.01,
                    orientation = "HORIZONTAL",
                    prediction = {
                        enabled = true
                    },
                    runes = {
                        color_by_spec = true,
                        sort_order = "none"
                    },
                    point = {
                        p = "BOTTOM",
                        anchor = "",
                        ap = "TOP",
                        x = 0,
                        y = 5
                    }
                },
                additional_power = {
                    enabled = false,
                    width = playerPlateWidth,
                    height = 1.5,
                    prediction = {
                        enabled = false
                    },
                    point = {
                        p = "TOPLEFT",
                        anchor = "Health",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 0
                    }
                },
                aura_bars = {
                    enabled = true,
                    width = playerPlateWidth,
                    height = 14,
                    spacing = 10,
                    gap = 6,
                    y_growth = "UP",
                    enable_mouse = true,
                    spark = true,
                    sort = false, -- Sort by remaining time
                    name = {
                        text = {
                            size = 13,
                            outline = true,
                            shadow = false
                        }
                    },
                    time = {
                        exp_threshold = 5, -- [1; 10]
                        m_ss_threshold = 600, -- [91; 3599]
                        text = {
                            font = D.global.fonts.cooldown.font,
                            size = 11,
                            outline = true,
                            shadow = false
                        }
                    },
                    filter = {
                        custom = {
                            ["Class Buffs"] = true
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                dispellable = false,
                                misc = false
                            }
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                misc = false
                            }
                        }
                    },
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 18
                    }
                }
            },
            targetplate = {
                enabled = false,
                width = targetPlateWidth,
                height = targetPlateHeight,
                visibility = "[petbattle,overridebar,possessbar] hide; [harm,nodead][exists,combat][exists,nocombat,mod:alt][vehicleui,exists] show; [] hide; show",
                point = {
                    p = "LEFT",
                    anchor = "LumPlayerPlateFrame",
                    ap = "RIGHT",
                    x = 31,
                    y = 0
                },
                health = {
                    enabled = true,
                    height = 7,
                    kill_range = false,
                    change_threshold = 0.001,
                    reverse = false,
                    color = {
                        smooth = false,
                        health = true,
                        tapping = true,
                        disconnected = true,
                        class = true,
                        reaction = true
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
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            -- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "[lum:health_cur(true,true)] [lum:color(gray)][lum:health_perc]",
                        size = 15,
                        color = E.colors.light_gray,
                        alpha = 0.9,
                        outline = true,
                        shadow = false,
                        h_alignment = "LEFT",
                        v_alignment = "MIDDLE",
                        hide_when_max = false,
                        point = {
                            p = "LEFT",
                            anchor = "",
                            ap = "RIGHT",
                            x = 6,
                            y = 0
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 2,
                    change_threshold = 0.01,
                    color = {
                        power = true,
                        tapping = true,
                        disconnected = false,
                        class = false
                    },
                    text = {
                        tag = "",
                        size = 16,
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
                        }
                    },
                    prediction = {
                        enabled = true
                    }
                },
                castbar = {
                    enabled = true,
                    width = targetPlateWidth + 34,
                    height = 18,
                    thin = true,
                    color = E.colors.dark_blue,
                    class_colored = false,
                    max = false,
                    latency = false,
                    icon = {
                        position = "RIGHT", -- "LEFT", "RIGHT" or "NONE"
                        gap = 4
                    },
                    text = {
                        size = 12,
                        outline = true,
                        shadow = false
                    },
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "Health",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 32
                    }
                },
                name = {
                    tag = "[lum:color_difficulty][lum:level]|r[lum:npc_type_short(true)] [lum:name_abbr]",
                    size = 13,
                    outline = true,
                    shadow = false,
                    h_alignment = "LEFT",
                    v_alignment = "MIDDLE",
                    word_wrap = false,
                    point = {
                        p = "LEFT",
                        anchor = "",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 10
                    }
                },
                auras = {
                    enabled = true,
                    rows = 2,
                    per_row = 5,
                    spacing = 5,
                    size_override = auraWidth(targetPlateWidth, 5, 4),
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
                    animate = {
                        buff = false,
                        debuff = true
                    },
                    sort = false, -- Sort by remaining time
                    count = {
                        size = 10,
                        outline = true,
                        shadow = false,
                        h_alignment = "RIGHT",
                        v_alignment = "TOP"
                    },
                    cooldown = {
                        text = {
                            enabled = true,
                            size = 12,
                            v_alignment = "BOTTOM"
                        }
                    },
                    filter = {
                        custom = {
                            ["Blacklist"] = false,
                            ["M+ Affixes"] = false,
                            ["Class Debuffs"] = true
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                dispellable = false,
                                misc = false
                            }
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
                                misc = false
                            },
                            debuff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = false,
                                player_permanent = false,
                                misc = false
                            }
                        }
                    },
                    point = {
                        p = "TOPLEFT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = 1,
                        y = -8
                    }
                },
                raid_target = {
                    enabled = true,
                    size = 18,
                    point = {
                        p = "LEFT",
                        anchor = "Health",
                        ap = "RIGHT",
                        x = 8,
                        y = 20
                    }
                }
            },
            party = {
                enabled = true,
                width = 82,
                height = 24,
                x_offset = 6,
                y_offset = 6,
                orientation = "HORIZONTAL", -- HORIZONTAL or VERTICAL
                show_solo = false,
                point = {
                    p = "CENTER",
                    anchor = "UIParent",
                    ap = "CENTER",
                    x = 0,
                    y = -390
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
                        disconnected = true,
                        class = true,
                        reaction = false
                    },
                    text = {
                        tag = "[lum:health_perc]",
                        size = 13,
                        alpha = 0.9,
                        outline = true,
                        shadow = false,
                        h_alignment = "CENTER",
                        v_alignment = "MIDDLE",
                        hide_when_max = true,
                        point = {
                            p = "CENTER",
                            anchor = "",
                            ap = "CENTER",
                            x = 4,
                            y = 0.5
                        }
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
                                ap = "TOP",
                                x = 0,
                                y = 2
                            }
                        },
                        heal_absorb_text = {
                            -- tag = "[lum:color_absorb_heal][lum:absorb_heal]|r",
                            size = 12,
                            h_alignment = "CENTER",
                            v_alignment = "MIDDLE",
                            point1 = {
                                p = "BOTTOM",
                                anchor = "Health.Text",
                                ap = "TOP",
                                x = 0,
                                y = 16
                            }
                        }
                    },
                    perc = {
                        tag = "",
                        size = 14,
                        color = E.colors.light_gray,
                        alpha = 0.9,
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
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 2,
                    gap = 2,
                    color = {
                        power = true,
                        tapping = false,
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
                        }
                    }
                },
                name = {
                    tag = "[lum:color_unit][lum:name(22)]",
                    size = 13,
                    outline = true,
                    shadow = false,
                    h_alignment = "CENTER",
                    v_alignment = "BOTTOM",
                    word_wrap = false,
                    point = {
                        p = "CENTER",
                        anchor = "",
                        ap = "TOP",
                        x = 2,
                        y = 10
                    }
                },
                raid_target = {
                    enabled = true,
                    size = 18,
                    point = {
                        p = "BOTTOM",
                        anchor = "",
                        ap = "TOP",
                        x = 0,
                        y = 24
                    }
                },
                threat = {
                    enabled = true
                }
            }
        }
    }
}
