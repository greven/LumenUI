-- Credits: ls_UI
local A, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local m_abs = _G.math.abs
local next = _G.next
local unpack = _G.unpack
local GetTime = _G.GetTime

-- ---------------

E.Cooldowns = {}
local handledCooldowns = {}
local activeCooldowns = {}

local defaults = {
    exp_threshold = 5, -- [1; 10]
    m_ss_threshold = 0, -- [91; 3599]
    text = {enabled = true, size = 12, v_alignment = "MIDDLE"}
}

local updateTime = 0
local time1, time2, format, color
E.Cooldowns.Updater = CreateFrame("Frame")
E.Cooldowns.Updater:SetScript("OnUpdate", function(_, elapsed)
    updateTime = updateTime + elapsed
    if updateTime >= 0.1 then
        for cooldown, expiration in next, activeCooldowns do
            if cooldown:IsVisible() and cooldown.Timer:IsVisible() then
                local remain = expiration - GetTime()
                if remain <= 0 then
                    cooldown.Timer:SetText("")
                    activeCooldowns[cooldown] = nil
                    return
                end

                color = C.colors.white

                if remain >= 86400 then
                    time1, time2, format = E:SecondsToTime(remain, "abbr")
                    color = C.colors.cooldown.day
                elseif remain >= 3600 then
                    time1, time2, format = E:SecondsToTime(remain, "abbr")
                    color = C.colors.cooldown.hour
                elseif remain >= 60 then
                    if cooldown.config.m_ss_threshold == 0 or remain >
                        cooldown.config.m_ss_threshold then
                        time1, time2, format = E:SecondsToTime(remain, "abbr")
                    else
                        time1, time2, format = E:SecondsToTime(remain, "x:xx")
                    end

                    color = C.colors.cooldown.minute
                elseif remain >= 1 then
                    if remain > cooldown.config.exp_threshold then
                        time1, time2, format = E:SecondsToTime(remain, "abbr")
                    else
                        time1, time2, format = E:SecondsToTime(remain, "frac")
                    end

                    color = C.colors.cooldown.second
                elseif remain >= 0.001 then
                    time1, time2, format = E:SecondsToTime(remain)
                    color = C.colors.cooldown.second
                end

                if remain <= cooldown.config.exp_threshold then
                    color = C.colors.cooldown.expiration
                end

                if time1 then
                    cooldown.Timer:SetFormattedText(format, time1, time2)
                    cooldown.Timer:SetVertexColor(E:GetRGB(color))
                end
            end
        end

        updateTime = 0
    end
end)

local function cooldown_Clear(self)
    self.Timer:SetText("")
    activeCooldowns[self] = nil
end

local function cooldown_SetCooldown(self, start, duration)
    if self.config.text.enabled then
        if duration > 1.5 then
            activeCooldowns[self] = start + duration
            return
        end
    end

    self.Timer:SetText("")
    activeCooldowns[self] = nil
end

local function cooldown_UpdateFont(self)
    local config = self.config.text

    self.Timer:SetFont(config.font or C.media.fonts.normal, config.size,
                       config.outline and "OUTLINE" or nil)
    self.Timer:SetJustifyH("CENTER")
    self.Timer:SetJustifyV(config.v_alignment)
    self.Timer:SetShown(config.enabled)
    self.Timer:SetWordWrap(false)

    if config.shadow then
        self.Timer:SetShadowOffset(1, -1)
    else
        self.Timer:SetShadowOffset(0, 0)
    end

    local point = config.point
    if point then self.Timer:SetPoint(point.p, point.x, point.y) end
end

local function cooldown_UpdateConfig(self, config)
    if config then
        self.config = E:CopyTable(defaults, self.config)
        self.config = E:CopyTable(config, self.config)
    end

    self.config.text = E:CopyTable(C.global.fonts.cooldown, self.config.text)

    if self.config.m_ss_threshold ~= 0 and self.config.m_ss_threshold < 91 then
        self.config.m_ss_threshold = 0
    end
end

function E.Cooldowns.Handle(cooldown)
    if E.OMNICC or handledCooldowns[cooldown] then return cooldown end

    cooldown:SetDrawBling(false)
    cooldown:SetDrawEdge(false)
    cooldown:SetHideCountdownNumbers(true)
    cooldown:GetRegions():SetAlpha(0) -- Default CD timer is region #1

    local textParent = CreateFrame("Frame", nil, cooldown)
    textParent:SetAllPoints()

    local timer = textParent:CreateFontString(nil, "ARTWORK")
    timer:SetPoint("TOPLEFT", -8, -1)
    timer:SetPoint("BOTTOMRIGHT", 8, 1)
    cooldown.Timer = timer

    hooksecurefunc(cooldown, "Clear", cooldown_Clear)
    hooksecurefunc(cooldown, "SetCooldown", cooldown_SetCooldown)

    cooldown.UpdateConfig = cooldown_UpdateConfig
    cooldown.UpdateFont = cooldown_UpdateFont

    cooldown:UpdateConfig(defaults)
    cooldown:UpdateFont()

    handledCooldowns[cooldown] = true

    local start, duration = cooldown:GetCooldownTimes()
    if start > 0 or duration > 0 then
        cooldown_SetCooldown(cooldown, start / 1000, duration / 1000)
    end

    return cooldown
end

function E.Cooldowns.Create(parent)
    local cooldown = CreateFrame("Cooldown", nil, parent,
                                 "CooldownFrameTemplate")
    cooldown:SetPoint("TOPLEFT", 0, 0)
    cooldown:SetPoint("BOTTOMRIGHT", 0, 0)

    E.Cooldowns.Handle(cooldown)

    return cooldown
end

function E.Cooldowns:ForEach(method, ...)
    for cooldown in next, handledCooldowns do
        if cooldown[method] then cooldown[method](cooldown, ...) end
    end
end
