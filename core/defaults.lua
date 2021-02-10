local _, ns = ...
local E, D, C = ns.E, ns.D, ns.C

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local playerHeight = 24
local playerWidth = 212
local playerPlateHeight = 11
local playerPlateWidth = 200
local targetWidth = 296
local targetHeight = 28
local targetPlateWidth = 153
local targetPlateHeight = playerPlateHeight

local function rgb(r, g, b)
    return E:SetRGB({}, r, g, b)
end

local function auraWidth(frameWidth, count, spacing)
    return (frameWidth - (spacing * (count - 1))) / count
end

-- ---------------

D.media = {
    fonts = {
        normal = Media .. "fonts\\Oswald.ttf",
        light = Media .. "fonts\\Oswald-Light.ttf",
        medium = Media .. "fonts\\Oswald-Medium.ttf",
        condensed = Media .. "fonts\\BigNoodleTitling.ttf"
    },
    textures = {
        statusbar = Media .. "textures\\statusbar",
        statusbar_bg = Media .. "textures\\statusbar-bg",
        statusbar_azerite = Media .. "textures\\statusbar-azerite",
        flat = Media .. "textures\\statusbar",
        neon = Media .. "textures\\neon",
        mint = Media .. "textures\\mint",
        vertlines = Media .. "textures\\vertlines",
        glow = Media .. "textures\\glow",
        spark = Media .. "textures\\spark",
        absorb = Media .. "textures\\absorb",
        border = Media .. "textures\\border",
        border_thick = Media .. "textures\\border-thick",
        border = Media .. "textures\\border",
        backdrop_border = Media .. "textures\\backdrop-border",
        button_backdrop = Media .. "textures\\button-backdrop",
        button_normal = Media .. "textures\\button-normal",
        button_highlight = Media .. "textures\\button-highlight",
        button_checked = Media .. "textures\\button-checked",
        arrow = Media .. "textures\\arrow",
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
            [""] = {1 / 128, 33 / 128, 67 / 128, 99 / 128} -- Enrage
            -- ["TEMP"] = {34 / 128, 66 / 128, 67 / 128, 99 / 128},
            -- ["TEMP"] = {67 / 128, 99 / 128, 67 / 128, 99 / 128},
        }
    }
}

-- ---------------

D.global = {
    fonts = {
        bars = {font = D.media.fonts.normal, outline = true, shadow = false},
        units = {font = D.media.fonts.condensed, outline = false, shadow = true},
        cooldown = {font = D.media.fonts.normal, outline = true, shadow = false}
    },
    backdrop = {color = rgb(5, 8, 12), alpha = 0.9},
    border = {color = rgb(20, 20, 20)},
    statusbar = {
        texture = D.media.textures.statusbar,
        color = D.colors.dark_gray
    },
    buttons = {
        border = {texture = D.media.textures.border, size = 16, offset = -4},
        texture = {
            normal = D.media.textures.button_normal, -- normal = "",
            highlight = D.media.textures.button_highlight,
            checked = D.media.textures.button_checked
        }
    },
    shadows = {enabled = true, alpha = 0.3},
    castbar = {
        texture = D.media.textures.neon,
        bg = D.media.textures.statusbar_bg
    },
    aura_bars = {texture = D.media.textures.statusbar},
    aura_filters = {
        ["Blacklist"] = {is_init = false},
        ["M+ Affixes"] = {is_init = false},
        ["Class Debuffs"] = {is_init = false},
        ["Class Buffs"] = {is_init = false}
    }
}

D.modules = {
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
                text = {enabled = true, size = 12, v_alignment = "BOTTOM"}
            },
            type = {size = 12, position = "TOPLEFT", debuff_type = false},
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
                text = {enabled = true, size = 12, v_alignment = "BOTTOM"}
            },
            type = {size = 12, position = "TOPLEFT", debuff_type = false},
            point = {
                p = "TOPRIGHT",
                anchor = "UIParent",
                ap = "TOPRIGHT",
                x = -8,
                y = -114
            }
        },
        TOTEM = {
            num = 4,
            size = 32,
            spacing = 6,
            x_growth = "LEFT",
            y_growth = "DOWN",
            per_row = 4,
            cooldown = {
                text = {enabled = true, size = 12, v_alignment = "BOTTOM"}
            },
            point = {
                p = "TOPRIGHT",
                anchor = "UIParent",
                ap = "TOPRIGHT",
                x = -182,
                y = -148
            }
        }
    },
    bags = {enabled = true},
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
        desaturation = {unusable = true, mana = true, range = true},
        bar1 = {
            -- MainMenuBar
            flyout_dir = "UP",
            grid = false,
            num = 12,
            per_row = 6,
            size = 28,
            spacing = 6,
            visibility = "[petbattle] hide; [vehicleui][harm,nodead][combat][group][mod:alt] show; [] hide; show",
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
            hotkey = {enabled = true, size = 12},
            macro = {enabled = false, size = 12},
            count = {enabled = true, size = 12},
            cooldown = {
                text = {enabled = true, size = 13, v_alignment = "MIDDLE"}
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
            hotkey = {enabled = true, size = 12},
            macro = {enabled = false, size = 12},
            count = {enabled = true, size = 12},
            cooldown = {
                text = {enabled = true, size = 13, v_alignment = "MIDDLE"}
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 23
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
            hotkey = {enabled = true, size = 12},
            macro = {enabled = false, size = 12},
            count = {enabled = true, size = 12},
            cooldown = {
                text = {enabled = true, size = 13, v_alignment = "MIDDLE"}
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 24 + 36
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
            hotkey = {enabled = true, size = 12},
            macro = {enabled = false, size = 12},
            count = {enabled = true, size = 12},
            cooldown = {
                text = {enabled = true, size = 13, v_alignment = "MIDDLE"}
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
            hotkey = {enabled = true, size = 12},
            macro = {enabled = false, size = 12},
            count = {enabled = true, size = 12},
            cooldown = {
                text = {enabled = true, size = 13, v_alignment = "MIDDLE"}
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
            size = 26,
            spacing = 6,
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
            hotkey = {enabled = true, size = 10},
            cooldown = {
                text = {enabled = true, size = 10, v_alignment = "MIDDLE"}
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 142
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
            hotkey = {enabled = true, size = 10},
            cooldown = {
                text = {enabled = true, size = 10, v_alignment = "MIDDLE"}
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
            hotkey = {enabled = true, size = 12},
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
            hotkey = {enabled = true, size = 14},
            cooldown = {
                text = {enabled = true, size = 14, v_alignment = "MIDDLE"}
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
                text = {enabled = true, size = 14, v_alignment = "MIDDLE"}
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
                enabled = false,
                out_delay = 0.75,
                out_duration = 0.15,
                in_delay = 0,
                in_duration = 0.15,
                min_alpha = 0,
                max_alpha = 1
            },
            bars = {
                micromenu1 = {
                    enabled = true,
                    num = 13,
                    per_row = 13,
                    width = 18,
                    height = 24,
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
                    num = 13,
                    per_row = 13,
                    width = 18,
                    height = 24,
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
                    size = 32,
                    spacing = 4,
                    point = {
                        p = "BOTTOMRIGHT",
                        anchor = "UIParent",
                        ap = "BOTTOMRIGHT",
                        x = -4,
                        y = 32
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
                spellbook = {enabled = true, parent = "micromenu1"},
                talent = {enabled = true, parent = "micromenu1"},
                achievement = {enabled = true, parent = "micromenu1"},
                quest = {enabled = true, parent = "micromenu1", tooltip = true},
                guild = {enabled = true, parent = "micromenu1"},
                lfd = {enabled = true, parent = "micromenu1", tooltip = true},
                collection = {enabled = true, parent = "micromenu1"},
                ej = {enabled = true, parent = "micromenu1", tooltip = true},
                store = {enabled = false, parent = "micromenu1"},
                main = {enabled = true, parent = "micromenu1", tooltip = true},
                help = {enabled = false, parent = "micromenu1"}
            }
        },
        xpbar = {
            enabled = true,
            visible = true,
            width = 427,
            height = 18,
            texture = D.media.textures.statusbar,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            spark = true,
            text = {
                size = 10,
                format = "NUM_PERC", -- "NUM or NUM_PERC"
                visibility = 2, -- 1 - always, 2 - mouseover
                position = "TOP" -- "TOP", "CENTER"
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 0
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
        }
    },
    blizzard = {
        enabled = true,
        character_frame = {enabled = true, ilvl = true, enhancements = true},
        durability = {enabled = true, point = {"TOPRIGHT", -4, -196}},
        errors_frame = {
            enabled = true,
            width = 512,
            height = 60,
            text = {
                font = D.media.fonts.normal,
                size = 14,
                outline = false,
                shadow = true
            },
            point = {p = "TOP", x = 0, y = -250}
        },
        objective_tracker = {
            enabled = true,
            height = 600,
            point = {"TOPRIGHT", -192, -192}
        },
        player_alt_power_bar = {enabled = true},
        talking_head = {enabled = true, hide = false},
        vehicle = {enabled = true, size = 100, point = {"TOPLEFT", 4, -196}}
    },
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
            MiniMapTrackingButton = 22.5,
            GameTimeFrame = 45,
            MiniMapMailFrame = 135,
            GarrisonLandingPageMinimapButton = 210,
            QueueStatusMinimapButton = 320
        },
        color = {border = false, zone_text = true},
        point = {"BOTTOMRIGHT", -20, 100}
    },
    misc = {
        enabled = true,
        bindings = {enabled = true},
        merchant = {
            enabled = true,
            auto_repair = {enabled = true, use_guild_funds = true},
            vendor_grays = {enabled = true}
        }
    },
    panel = {
        enabled = true,
        visible = true,
        width = 420,
        height = 16,
        visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
        text = {size = 10},
        point = {
            p = "BOTTOM",
            anchor = "UIParent",
            ap = "BOTTOM",
            x = 0,
            y = -2
        }
    },
    tooltips = {
        enabled = true,
        scale = 1,
        alpha = 0.9,
        border = {size = 10, color_quality = true, color_class = false},
        health = {
            height = 5,
            color_class = true,
            text = {show = false, size = 12}
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
            anchor = "UIParent",
            ap = "BOTTOMRIGHT",
            x = -76,
            y = 126
        }
    },
    unitframes = {
        enabled = true,
        shadows = {enabled = true, alpha = D.global.shadows.alpha},
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
                    p = "BOTTOMLEFT",
                    anchor = "UIParent",
                    ap = "BOTTOMLEFT",
                    x = 83 + 43,
                    y = 0 + 45
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
                        size = 14,
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
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 2,
                    gap = 1,
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
                    prediction = {enabled = true}
                },
                class_power = {enabled = false, prediction = {enabled = false}},
                additional_power = {
                    enabled = true,
                    width = playerWidth,
                    height = 2,
                    prediction = {enabled = true},
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
                    text = {size = 15, outline = true, shadow = false},
                    point = {
                        p = "BOTTOM",
                        anchor = "UIParent",
                        ap = "BOTTOM",
                        x = 0,
                        y = 24 + 82
                    }
                },
                name = {
                    tag = "[lum:color_difficulty][lum:level]|r [lum:name(24)]",
                    size = 20,
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
                    }
                },
                portrait = {
                    enabled = true,
                    style = "3D",
                    width = 64,
                    height = 64,
                    model_alpha = 1.0,
                    desaturation = 0,
                    point = {
                        p = "BOTTOMRIGHT",
                        anchor = "",
                        ap = "BOTTOMLEFT",
                        x = -8,
                        y = 0
                    },
                    text = {
                        tag = "",
                        size = 12,
                        outline = true,
                        shadow = false,
                        h_alignment = "CENTER",
                        v_alignment = "MIDDLE",
                        point = {
                            p = "BOTTOM",
                            anchor = "",
                            ap = "TOP",
                            x = 0,
                            y = 0
                        }
                    }
                },
                unitIndicator = {
                    enabled = true,
                    width = 2.5,
                    height = 64,
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
                    animate = {buff = false, debuff = false},
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
                        custom = {["Blacklist"] = true, ["M+ Affixes"] = true},
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
                threat = {enabled = true}
            },
            target = {
                enabled = true,
                width = targetWidth,
                height = targetHeight,
                point = {
                    p = "TOP",
                    anchor = "UIParent",
                    ap = "TOP",
                    x = 0,
                    y = -111
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
                        tag = "[lum:health_cur(true,true)]",
                        size = 17,
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
                    text = {size = 13, outline = true, shadow = false},
                    point = {
                        p = "TOPLEFT",
                        anchor = "Health",
                        ap = "BOTTOMLEFT",
                        x = 0,
                        y = -76
                    }
                },
                name = {
                    tag = "[lum:name(32)]",
                    size = 17,
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
                    height = targetHeight,
                    hide_out_of_combat = false,
                    point = {
                        p = "RIGHT",
                        anchor = "Portrait",
                        ap = "LEFT",
                        x = -6,
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
                    size_override = auraWidth(targetWidth, 10, 5),
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
                    animate = {buff = false, debuff = false},
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
                        custom = {["Blacklist"] = true, ["M+ Affixes"] = true},
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
                threat = {enabled = true, feedback_unit = "player"}
            },
            targettarget = {
                enabled = true,
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
                threat = {enabled = true, feedback_unit = "player"}
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
                    height = 6,
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
                        color = D.colors.light_gray,
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
                    height = 3,
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
                    prediction = {enabled = true}
                },
                castbar = {
                    enabled = true,
                    width = targetPlateWidth + 34,
                    height = 18,
                    thin = true,
                    color = D.colors.dark_blue,
                    class_colored = false,
                    max = false,
                    latency = false,
                    icon = {
                        position = "LEFT", -- "LEFT", "RIGHT" or "NONE"
                        gap = 4
                    },
                    text = {size = 12, outline = true, shadow = false},
                    point = {
                        p = "BOTTOMRIGHT",
                        anchor = "Health",
                        ap = "TOPRIGHT",
                        x = 0,
                        y = 28
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
                    animate = {buff = false, debuff = false},
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
                        custom = {["Blacklist"] = true, ["M+ Affixes"] = true},
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
                    size = 20,
                    point = {
                        p = "RIGHT",
                        anchor = "Health",
                        ap = "LEFT",
                        x = -8,
                        y = 20
                    }
                },
                threat = {enabled = true, feedback_unit = "player"}
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
                    color = D.colors.dark_blue,
                    class_colored = false,
                    max = false,
                    latency = false,
                    icon = {
                        position = "NONE", -- "LEFT", "RIGHT" or "NONE"
                        gap = 4
                    },
                    text = {size = 13, outline = true, shadow = false},
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
                threat = {enabled = true, feedback_unit = "player"}
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
                        color = D.colors.light_gray,
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
                    color = D.colors.dark_blue,
                    class_colored = false,
                    max = false,
                    latency = false,
                    icon = {
                        position = "NONE", -- "LEFT", "RIGHT" or "NONE"
                        gap = 4
                    },
                    text = {size = 12, outline = true, shadow = false},
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
                    animate = {buff = false, debuff = false},
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
                        custom = {["Blacklist"] = true, ["M+ Affixes"] = true},
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
                    y = -250
                },
                health = {
                    enabled = true,
                    height = 6,
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
                        }
                    }
                },
                power = {
                    enabled = true,
                    height = 3,
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
                    prediction = {enabled = true}
                },
                class_power = {
                    enabled = true,
                    width = playerPlateWidth,
                    height = 3,
                    change_threshold = 0.01,
                    orientation = "HORIZONTAL",
                    prediction = {enabled = true},
                    runes = {color_by_spec = true, sort_order = "none"},
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
                    prediction = {enabled = false},
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
                    disable_mouse = false,
                    spark = true,
                    sort = false, -- Sort by remaining time
                    name = {text = {size = 13, outline = true, shadow = false}},
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
                        custom = {["Class Buffs"] = true},
                        friendly = {
                            buff = {
                                boss = false,
                                tank = false,
                                healer = false,
                                mount = false,
                                selfcast = false,
                                selfcast_permanent = false,
                                player = true,
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
                enabled = true,
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
                    height = 6,
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
                        color = D.colors.light_gray,
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
                    height = 3,
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
                    prediction = {enabled = true}
                },
                castbar = {
                    enabled = true,
                    width = 153,
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
                    text = {size = 13, outline = true, shadow = false},
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "Health",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 28
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
                    animate = {buff = false, debuff = true},
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
                    size = 20,
                    point = {
                        p = "LEFT",
                        anchor = "Health",
                        ap = "RIGHT",
                        x = 2,
                        y = 20
                    }
                }
            }
        }
    }
}

-- Copy defaults to the config table
E:CopyTable(D, C)
