local _, ns = ...
local E, D, C = ns.E, ns.D, ns.C

local Media = "Interface\\AddOns\\LumenUI\\media\\"

local playerHeight = 24
local playerWidth = 212
local playerPlateHeight = 11
local playerPlateWidth = 200
local targetWidth = 296
local targetHeight = 28

local function rgb(r, g, b) return E:SetRGB({}, r, g, b) end

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
        flat = Media .. "textures\\statusbar",
        neon = Media .. "textures\\neon",
        mint = Media .. "textures\\mint",
        glow = Media .. "textures\\glow",
        vertlines = Media .. "textures\\vertlines",
        border = Media .. "textures\\border",
        border_thick = Media .. "textures\\border-thick",
        border = Media .. "textures\\border",
        button_backdrop = Media .. "textures\\button-backdrop",
        button_highlight = Media .. "textures\\button-highlight",
        button_checked = Media .. "textures\\button-checked",
        absorb = Media .. "textures\\absorb",
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
    backdrop = {color = rgb(0, 0, 0), alpha = 0.9},
    border = {color = rgb(20, 20, 20)},
    statusbar = {
        texture = D.media.textures.statusbar,
        color = D.colors.dark_gray
    },
    shadows = {enabled = true, alpha = 0.3},
    castbar = {
        texture = D.media.textures.statusbar,
        bg = D.media.textures.statusbar_bg
    },
    aura_filters = {
        ["Blacklist"] = {is_init = false},
        ["M+ Affixes"] = {is_init = false}
    }
}

D.modules = {
    auras = {
        enabled = true,
        cooldown = {
            exp_threshold = 5, -- [1; 10]
            m_ss_threshold = 600 -- [91; 3599]
        },
        HELPFUL = {
            size = 32,
            spacing = 6,
            x_growth = "LEFT",
            y_growth = "DOWN",
            per_row = 16,
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
                x = -184,
                y = -6
            }
        },
        HARMFUL = {
            size = 32,
            spacing = 6,
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
                x = -184,
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
        bar1 = { -- MainMenuBar
            flyout_dir = "UP",
            grid = false,
            num = 12,
            per_row = 6,
            size = 28,
            spacing = 6,
            visibility = "[petbattle] hide; [vehicleui][harm,nodead][combat][mod:alt] show; [] hide; show",
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
                text = {enabled = true, size = 12, v_alignment = "MIDDLE"}
            },
            point = {
                p = "TOP",
                anchor = "LumenPlayerPlateFrame",
                ap = "BOTTOM",
                x = 0,
                y = -8
            }
        },
        bar2 = { -- MultiBarBottomLeft
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
                text = {enabled = true, size = 12, v_alignment = "MIDDLE"}
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 24
            }
        },
        bar3 = { -- MultiBarBottomRight
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
                text = {enabled = true, size = 12, v_alignment = "MIDDLE"}
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 24 + 36
            }
        },
        bar4 = { -- MultiBarLeft
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
                text = {enabled = true, size = 12, v_alignment = "MIDDLE"}
            },
            point = {
                p = "RIGHT",
                anchor = "UIParent",
                ap = "RIGHT",
                x = -40,
                y = 0
            }
        },
        bar5 = { -- MultiBarRight
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
                text = {enabled = true, size = 12, v_alignment = "MIDDLE"}
            },
            point = {
                p = "RIGHT",
                anchor = "UIParent",
                ap = "RIGHT",
                x = -4,
                y = 0
            }
        },
        bar6 = { -- PetAction
            flyout_dir = "UP",
            grid = false,
            num = 10,
            per_row = 10,
            size = 30,
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
            }
        },
        bar7 = { -- Stance
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
        extra = { -- ExtraAction
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
            hotkey = {enabled = true, size = 14},
            cooldown = {
                text = {enabled = true, size = 14, v_alignment = "MIDDLE"}
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = -94,
                y = 250
            }
        },
        zone = { -- ZoneAbility
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
        vehicle = { -- LeaveVehicle
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
            height = 4,
            texture = D.media.textures.neon,
            visibility = "[vehicleui][petbattle][overridebar][possessbar] hide; show",
            text = {
                size = 10,
                format = "NUM_PERC", -- "NUM or NUM_PERC"
                visibility = 2 -- 1 - always, 2 - mouseover
            },
            point = {
                p = "BOTTOM",
                anchor = "UIParent",
                ap = "BOTTOM",
                x = 0,
                y = 22 - 10
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
    minimap = {
        enabled = false,
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
        point = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -20, 40}
    },
    misc = {enabled = true, bindings = {enabled = true}},
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
                    p = "TOPLEFT",
                    anchor = "UIParent",
                    ap = "TOPLEFT",
                    x = 83 + 13,
                    y = -42 - 13
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
                        y = -13
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
                        y = 24 + 115
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
                    spacing = 6,
                    size_override = 30,
                    x_growth = "RIGHT",
                    y_growth = "DOWN",
                    disable_mouse = false,
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
                        size = 12,
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
                    x = -20,
                    y = -51
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
                    point = {p = "LEFT", anchor = "", ap = "LEFT", x = 6, y = 1}
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
                        size = 12,
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
                    tag = "[lum:color_difficulty][lum:level]|r [lum:name(23)]",
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
                width = 173,
                height = 18,
                point = {
                    p = "LEFT",
                    anchor = "LumenPlayerPlateFrame",
                    ap = "RIGHT",
                    x = 31,
                    y = 100
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
                            anchor = "Health",
                            ap = "RIGHT",
                            x = -4,
                            y = 0
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
                    tag = "[lum:color_difficulty][lum:level]|r [lum:name(22)]",
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
                        x = 0,
                        y = 4
                    }
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
                        size = 12,
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
            focustarget = {
                enabled = false,
                width = 143,
                height = 18,
                point = {
                    p = "LEFT",
                    anchor = "LumenFocusFrame",
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
                    text = {size = 12, outline = true, shadow = false},
                    point = {
                        p = "BOTTOMLEFT",
                        anchor = "Health",
                        ap = "TOPLEFT",
                        x = 0,
                        y = 28
                    }
                },
                name = {
                    tag = "[lum:name(20)]",
                    size = 12,
                    outline = true,
                    shadow = false,
                    h_alignment = "LEFT",
                    v_alignment = "MIDDLE",
                    word_wrap = false,
                    point = {p = "LEFT", anchor = "", ap = "LEFT", x = 4, y = 1}
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
                        size = 12,
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
                visibility = "[petbattle] hide; [harm,nodead][combat][mod:alt] show; [] hide; show",
                attached = true, -- Attach Position to Blizzard's Player nameplate
                point = {
                    p = "CENTER",
                    anchor = "UIParent",
                    ap = "CENTER",
                    x = 0,
                    y = -215
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
                    height = 2,
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
                }
            },
            targetplate = {
                enabled = true,
                width = 153,
                height = playerPlateHeight,
                visibility = "[harm,nodead][combat] show; hide;",
                point = {
                    p = "LEFT",
                    anchor = "LumenPlayerPlateFrame",
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
                name = {
                    tag = "[lum:color_difficulty][lum:level]|r[lum:npc_type_short(true)] [lum:name(24)]",
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
                }
            }
        }
    }
}

-- Copy defaults to the config table
E:CopyTable(D, C)
