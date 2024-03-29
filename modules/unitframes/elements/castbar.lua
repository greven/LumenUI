local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local m_abs = _G.math.abs
local m_min = _G.math.min
local m_max = _G.math.max

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local function updateFont(fontString, config)
    fontString:SetFont(C.db.global.fonts.units.font, config.size, config.outline and "THINOUTLINE" or nil)
    fontString:SetWordWrap(false)

    if config.shadow then
        fontString:SetShadowOffset(1, -1)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

local function element_PostCastStart(self)
    local unit = self.__owner.unit

    if self.notInterruptible and unit ~= "player" then
        self:SetStatusBarColor(E:GetRGB(C.db.global.colors.castbar.notinterruptible))
        self:GetStatusBarTexture():SetDesaturated(true)

        if self.Icon then
            self.Icon:SetDesaturated(true)
        end
    else
        if self.casting then
            if self._config.color_by_class then
                self:SetStatusBarColor(E:GetRGB(C.db.global.colors.castbar.class[E.PLAYER_CLASS]))
            else
                self:SetStatusBarColor(E:GetRGB(C.db.global.colors.castbar.casting))
            end
        elseif self.channeling then
            self:SetStatusBarColor(E:GetRGB(C.db.global.colors.castbar.channeling))
        end

        if self.Icon then
            self.Icon:SetDesaturated(false)
        end
    end
end

local function element_PostCastFail(self)
    self:SetMinMaxValues(0, 1)
    self:SetValue(1)
    self:SetStatusBarColor(E:GetRGB(C.db.global.colors.castbar.failed))

    self.Time:SetText("")
    if self.Time.max then
        self.Time.max:SetText("")
    end
end

local function element_UpdateConfig(self)
    local unit = self.__owner._layout or self.__owner._unit
    self._config = E:CopyTable(C.db.profile.unitframes.units[unit].castbar, self._config)
end

local function element_UpdateFonts(self)
    updateFont(self.Text, self._config.text)
    self.Text:SetJustifyH("LEFT")

    updateFont(self.Time, self._config.text)
    self.Time:SetJustifyH("RIGHT")

    if self._config.max then
        updateFont(self.Time.max, {size = self._config.text.size - 3, outline = true})
        self.Time:SetJustifyH("RIGHT")
    end
end

local function element_UpdateIcon(self)
    local config = self._config
    local height = config.height

    local iconHeight = m_max(height * 1.75, 32)
    local thinBarHeight = E:Clamp(height, height / 6, height / 4)

    if config.icon.position == "LEFT" then
        self.Icon = self.LeftIcon

        self.IconParent:SetPoint("TOPLEFT", self.Holder, 1, 0)
        self.IconParent:SetPoint("BOTTOMRIGHT", self.Holder, "BOTTOMLEFT", iconHeight, 0)
        self.LeftIcon:SetAllPoints(self.IconParent)
        self.RightIcon:SetSize(0.0001, height)

        if config.thin then
            self:SetPoint("TOPLEFT", self.Holder, "BOTTOMLEFT", config.icon.gap + iconHeight, thinBarHeight)
            self:SetPoint("BOTTOMRIGHT", 0, 0)
        else
            self:SetPoint("TOPLEFT", config.icon.gap + iconHeight, 0)
            self:SetPoint("BOTTOMRIGHT", 0, 0)
        end

        E:SetBackdrop(self.Icon, E.SCREEN_SCALE * 3)
        E:CreateShadow(self.Icon)
    elseif config.icon.position == "RIGHT" then
        self.Icon = self.RightIcon

        self.IconParent:SetPoint("TOPRIGHT", self.Holder, -1, 0)
        self.IconParent:SetPoint("BOTTOMLEFT", self.Holder, "BOTTOMRIGHT", -iconHeight, 0)
        self.RightIcon:SetAllPoints(self.IconParent)
        self.LeftIcon:SetSize(0.0001, height)

        if config.thin then
            self:SetPoint("TOPLEFT", self.Holder, "BOTTOMLEFT", 0, thinBarHeight)
            self:SetPoint("BOTTOMRIGHT", -config.icon.gap - iconHeight, 0)
        else
            self:SetPoint("TOPLEFT", 0, 0)
            self:SetPoint("BOTTOMRIGHT", -config.icon.gap - iconHeight, 0)
        end

        E:SetBackdrop(self.Icon, E.SCREEN_SCALE * 3)
        E:CreateShadow(self.Icon)
    else
        self.Icon = nil

        self.LeftIcon:SetSize(0.0001, height)
        self.RightIcon:SetSize(0.0001, height)

        if config.thin then
            self:SetPoint("TOPLEFT", self.Holder, "BOTTOMLEFT", 0, thinBarHeight)
            self:SetPoint("BOTTOMRIGHT", 0, 0)
        else
            self:SetPoint("TOPLEFT", 0, 0)
            self:SetPoint("BOTTOMRIGHT", 0, 0)
        end
    end
end

local function element_UpdateColors(self)
    if self._config.color_by_class then
        self:SetStatusBarColor(E:GetRGB(C.db.global.colors.castbar.class[E.PLAYER_CLASS]))
    end
end

local function element_UpdateLatency(self)
    if self._config.latency then
        self.SafeZone = self.SafeZone_
        self.SafeZone_:Show()
    else
        self.SafeZone = nil
        self.SafeZone_:Hide()
    end
end

local function element_UpdateSize(self)
    local holder = self.Holder
    local frame = self.__owner

    local config = self._config
    local width = config.width
    local height = config.height

    holder:SetSize(width, height)
    holder._width = width

    local point = config.point
    if point and point.p then
        self:ClearAllPoints()
        holder:SetPoint(point.p, E:ResolveAnchorPoint(frame, point.anchor), point.ap, point.x, point.y)
    end
end

local function element_CustomTimeText(self, duration)
    if self.max > 600 then
        return self.Time:SetText("")
    end

    if self.casting then
        duration = self.max - duration
    end

    self.Time:SetFormattedText("%.1f", duration)

    if self.Time.max then
        self.Time.max:SetText(("%.1f"):format(self.max))
        self.Time.max:Show()
    end
end

local function element_CustomDelayText(self, duration)
    if self.casting then
        duration = self.max - duration
    end

    if self.casting then
        self.Time:SetFormattedText("%.1f|cffdc4436+%.1f|r ", duration, m_abs(self.delay))
    elseif self.channeling then
        self.Time:SetFormattedText("%.1f|cffdc4436-%.1f|r ", duration, m_abs(self.delay))
    end
end

local function frame_UpdateCastbar(self)
    local element = self.Castbar
    element:UpdateConfig()
    element:UpdateSize()
    element:UpdateFonts()
    element:UpdateColors()
    element:UpdateIcon()
    element:UpdateLatency()

    if element._config.enabled and not self:IsElementEnabled("Castbar") then
        self:EnableElement("Castbar")
    elseif not element._config.enabled and self:IsElementEnabled("Castbar") then
        self:DisableElement("Castbar")

        if self._unit == "player" then
            CastingBarFrame_SetUnit(CastingBarFrame, nil)
            CastingBarFrame_SetUnit(PetCastingBarFrame, nil)
        end
    end

    if self:IsElementEnabled("Castbar") then
        element:ForceUpdate()
    end
end

function UF:CreateCastbar(frame)
    local config = C.db.profile.unitframes.units[frame._layout or frame._unit].castbar

    local holder = CreateFrame("Frame", "$parentCastbarHolder", frame)
    holder._width = 0

    local element = CreateFrame("StatusBar", nil, holder)
    element:SetStatusBarTexture(C.db.global.castbar.texture)
    element:SetStatusBarColor(E:GetRGB(config.color))
    element:SetFrameLevel(holder:GetFrameLevel())
    element:SetFrameStrata("HIGH")
    E:SetBackdrop(element, E.SCREEN_SCALE * 3)
    E:CreateShadow(element)

    local bg = element:CreateTexture(nil, "BACKGROUND", nil)
    bg:SetAllPoints()
    bg:SetTexture(C.db.global.castbar.bg, "REPEAT", "REPEAT")
    bg:SetHorizTile(true)
    bg:SetVertTile(true)
    bg:SetVertexColor(E:GetRGB(C.db.global.colors.dark_gray))
    bg:SetAlpha(0.5)
    element.bg = bg

    local iconParent = CreateFrame("Frame", nil, element)
    element.IconParent = iconParent

    local icon = iconParent:CreateTexture(nil, "BACKGROUND", nil, 0)
    icon:SetTexCoord(8 / 64, 56 / 64, 9 / 64, 41 / 64)
    element.LeftIcon = icon

    icon = iconParent:CreateTexture(nil, "BACKGROUND", nil, 0)
    icon:SetTexCoord(8 / 64, 56 / 64, 9 / 64, 41 / 64)
    element.RightIcon = icon

    local safeZone = element:CreateTexture(nil, "ARTWORK", nil, 1)
    safeZone:SetTexture("Interface\\BUTTONS\\WHITE8X8")
    safeZone:SetVertexColor(E:GetRGBA(C.db.global.colors.red, 0.4))
    element.SafeZone_ = safeZone

    local textParent = CreateFrame("Frame", nil, element)
    textParent:SetPoint("TOPLEFT", holder, "TOPLEFT", 3, 0)
    textParent:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -3, 0)
    element.TextParent = textParent

    local text = textParent:CreateFontString(nil, "ARTWORK")
    text:SetWordWrap(false)
    text:SetJustifyH("LEFT")
    text:SetPoint("TOP", element, "TOP", 0, 0)
    text:SetPoint("BOTTOM", element, "BOTTOM", 0, 0)
    text:SetPoint("LEFT", element, "LEFT", 4, 0)
    text:SetPoint("RIGHT", time, "LEFT", -8, 0)
    element.Text = text

    local time = textParent:CreateFontString(nil, "ARTWORK")
    time:SetWordWrap(false)
    time:SetPoint("TOP", element, "TOP", 0, 0)
    time:SetPoint("BOTTOM", element, "BOTTOM", 0, 0)
    time:SetPoint("RIGHT", element, "RIGHT", -4, 0)
    element.Time = time

    if config.max then
        local max = element:CreateFontString(nil, "BACKGROUND")
        max:SetPoint("RIGHT", element.Time, "LEFT", -1, 0)
        max:SetTextColor(0.5, 0.5, 0.5)
        max:SetWordWrap(false)
        element.Time.max = max
    end

    if config.thin then
        text:SetPoint("TOP", holder, "TOP", 0, 0)
        text:SetPoint("BOTTOM", holder, "BOTTOM", 0, config.height / 2)
        text:SetPoint("LEFT", element, "LEFT", 0, 0)
        text:SetPoint("RIGHT", time, "LEFT", -8, 0)

        time:SetPoint("TOP", holder, "TOP", 0, 0)
        time:SetPoint("BOTTOM", holder, "BOTTOM", 0, config.height / 2)
        time:SetPoint("RIGHT", element, "RIGHT", 0, 0)
    end

    element.Holder = holder
    element.CustomTimeText = element_CustomTimeText
    element.CustomDelayText = element_CustomDelayText
    element.PostCastFail = element_PostCastFail
    element.PostCastStart = element_PostCastStart
    element.timeToHold = 0.5
    element.UpdateConfig = element_UpdateConfig
    element.UpdateFonts = element_UpdateFonts
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize
    element.UpdateIcon = element_UpdateIcon
    element.UpdateLatency = element_UpdateLatency

    frame.UpdateCastbar = frame_UpdateCastbar
    frame.Castbar = element

    return element
end
