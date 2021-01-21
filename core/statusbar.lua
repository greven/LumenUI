-- Credits: ls_UI
local A, ns = ...
local E, C = ns.E, ns.C

-- Lua
local _G = getfenv(0)
local m_abs = _G.math.abs
local m_max = _G.math.max
local m_min = _G.math.min

local next = _G.next
local unpack = _G.unpack

-- ---------------

function E:CreateStatusBar(parent, name, orientation)
    local bar = CreateFrame("StatusBar", name, parent)
    bar:SetOrientation(orientation)
    bar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")

    local bg = bar:CreateTexture(nil, "BACKGROUND")
    bg:SetColorTexture(E:GetRGB(C.colors.dark_gray))
    bg:SetAllPoints()
    bar.Bg = bg

    local text = bar:CreateFontString("$parentText", "ARTWORK", C.media.fonts.normal)
    text:SetWordWrap(false)
    bar.Text = text

    bar.handled = true

    return bar
end

do
    local function clamp(v, min, max)
        return m_min(max or 1, m_max(min or 0, v))
    end

    local function attachGainToVerticalBar(self, object, prev, max)
        local offset = object:GetHeight() * (1 - clamp(prev / max))

        self:SetPoint("BOTTOMLEFT", object, "TOPLEFT", 0, -offset)
        self:SetPoint("BOTTOMRIGHT", object, "TOPRIGHT", 0, -offset)
    end

    local function attachLossToVerticalBar(self, object, prev, max)
        local offset = object:GetHeight() * (1 - clamp(prev / max))

        self:SetPoint("TOPLEFT", object, "TOPLEFT", 0, -offset)
        self:SetPoint("TOPRIGHT", object, "TOPRIGHT", 0, -offset)
    end

    local function attachGainToHorizontalBar(self, object, prev, max)
        local offset = object:GetWidth() * (1 - clamp(prev / max))

        self:SetPoint("TOPLEFT", object, "TOPRIGHT", -offset, 0)
        self:SetPoint("BOTTOMLEFT", object, "BOTTOMRIGHT", -offset, 0)
    end

    local function attachLossToHorizontalBar(self, object, prev, max)
        local offset = object:GetWidth() * (1 - clamp(prev / max))

        self:SetPoint("TOPRIGHT", object, "TOPRIGHT", -offset, 0)
        self:SetPoint("BOTTOMRIGHT", object, "BOTTOMRIGHT", -offset, 0)
    end

    local function update(self, cur, max, condition)
        if max and max ~= 0 and (condition == nil or condition) then
            local prev = (self._prev or cur) * max / (self._max or max)
            local diff = cur - prev

            if m_abs(diff) / max < self.threshold then
                diff = 0
            end

            if diff > 0 then
                if self.Gain and self.Gain:GetAlpha() == 0 then
                    if self.orientation == "VERTICAL" then
                        attachGainToVerticalBar(self.Gain, self.__owner, prev, max)
                    else
                        attachGainToHorizontalBar(self.Gain, self.__owner, prev, max)
                    end

                    self.Gain:SetAlpha(1)
                    self.Gain.FadeOut:Play()
                end
            elseif diff < 0 then
                if self.Gain then
                    self.Gain.FadeOut:Stop()
                    self.Gain:SetAlpha(0)
                end

                if self.Loss then
                    if self.Loss:GetAlpha() <= 0.33 then
                        if self.orientation == "VERTICAL" then
                            attachLossToVerticalBar(self.Loss, self.__owner, prev, max)
                        else
                            attachLossToHorizontalBar(self.Loss, self.__owner, prev, max)
                        end

                        self.Loss:SetAlpha(1)
                        self.Loss.FadeOut:Restart()
                    elseif self.Loss.FadeOut.Alpha:IsDelaying() or self.Loss:GetAlpha() >= 0.66 then
                        self.Loss.FadeOut:Restart()
                    end
                end
            end
        else
            if self.Gain then
                self.Gain.FadeOut:Stop()
                self.Gain:SetAlpha(0)
            end

            if self.Loss then
                self.Loss.FadeOut:Stop()
                self.Loss:SetAlpha(0)
            end
        end

        if max and max ~= 0 then
            self._prev = cur
            self._max = max
        else
            self._prev = nil
            self._max = nil
        end
    end

    local function updateColors(self)
        self.Gain_:SetColorTexture(E:GetRGB(C.colors.gain))
        self.Loss_:SetColorTexture(E:GetRGB(C.colors.loss))
    end

    local function updatePoints(self, orientation)
        orientation = orientation or "HORIZONTAL"
        if orientation == "HORIZONTAL" then
            self.Gain_:ClearAllPoints()
            self.Gain_:SetPoint("TOPRIGHT", self.__owner:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
            self.Gain_:SetPoint("BOTTOMRIGHT", self.__owner:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)

            self.Loss_:ClearAllPoints()
            self.Loss_:SetPoint("TOPLEFT", self.__owner:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
            self.Loss_:SetPoint("BOTTOMLEFT", self.__owner:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
        else
            self.Gain_:ClearAllPoints()
            self.Gain_:SetPoint("TOPLEFT", self.__owner:GetStatusBarTexture(), "TOPLEFT", 0, 0)
            self.Gain_:SetPoint("TOPRIGHT", self.__owner:GetStatusBarTexture(), "TOPRIGHT", 0, 0)

            self.Loss_:ClearAllPoints()
            self.Loss_:SetPoint("BOTTOMLEFT", self.__owner:GetStatusBarTexture(), "TOPLEFT", 0, 0)
            self.Loss_:SetPoint("BOTTOMRIGHT", self.__owner:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        end

        self.orientation = orientation
    end

    local function updateThreshold(self, value)
        self.threshold = value or 0.01
    end

    function E:CreateGainLossIndicators(object)
        local gainTexture = object:CreateTexture(nil, "ARTWORK", nil, 1)
        gainTexture:SetAlpha(0)

        local ag = gainTexture:CreateAnimationGroup()
        ag:SetToFinalAlpha(true)
        gainTexture.FadeOut = ag

        local anim = ag:CreateAnimation("Alpha")
        anim:SetOrder(1)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)
        anim:SetStartDelay(0.25)
        anim:SetDuration(0.1)
        ag.Alpha = anim

        local lossTexture = object:CreateTexture(nil, "BACKGROUND")
        lossTexture:SetAlpha(0)

        ag = lossTexture:CreateAnimationGroup()
        ag:SetToFinalAlpha(true)
        lossTexture.FadeOut = ag

        anim = ag:CreateAnimation("Alpha")
        anim:SetOrder(1)
        anim:SetFromAlpha(1)
        anim:SetToAlpha(0)
        anim:SetStartDelay(0.25)
        anim:SetDuration(0.1)
        ag.Alpha = anim

        return {
            __owner = object,
            threshold = 0.01,
            Gain = gainTexture,
            Gain_ = gainTexture,
            Loss = lossTexture,
            Loss_ = lossTexture,
            Update = update,
            UpdateColors = updateColors,
            UpdatePoints = updatePoints,
            UpdateThreshold = updateThreshold
        }
    end
end

do
    local activeObjects = {}
    local handledObjects = {}

    local TARGET_FPS = 60
    local AMOUNT = 0.33

    local function clamp(v, min, max)
        min = min or 0
        max = max or 1

        if v > max then
            return max
        elseif v < min then
            return min
        end

        return v
    end

    local function isCloseEnough(new, target, range)
        if range > 0 then
            return m_abs((new - target) / range) <= 0.001
        end

        return true
    end

    local frame = CreateFrame("Frame", "LumBarSmoother")

    local function onUpdate(_, elapsed)
        for object, target in next, activeObjects do
            local new = Lerp(object._value, target, clamp(AMOUNT * elapsed * TARGET_FPS))
            if isCloseEnough(new, target, object._max - object._min) then
                new = target
                activeObjects[object] = nil
            end

            object:SetValue_(new)
            object._value = new
        end
    end

    local function bar_SetSmoothedValue(self, value)
        self._value = self:GetValue()
        activeObjects[self] = clamp(value, self._min, self._max)
    end

    local function bar_SetSmoothedMinMaxValues(self, min, max)
        self:SetMinMaxValues_(min, max)

        if self._max and self._max ~= max then
            local ratio = 1
            if max ~= 0 and self._max and self._max ~= 0 then
                ratio = max / (self._max or max)
            end

            local target = activeObjects[self]
            if target then
                activeObjects[self] = target * ratio
            end

            local cur = self._value
            if cur then
                self:SetValue_(cur * ratio)
                self._value = cur * ratio
            end
        end

        self._min = min
        self._max = max
    end

    function E:SmoothBar(bar)
        bar._min, bar._max = bar:GetMinMaxValues()
        bar._value = bar:GetValue()

        bar.SetValue_ = bar.SetValue
        bar.SetMinMaxValues_ = bar.SetMinMaxValues
        bar.SetValue = bar_SetSmoothedValue
        bar.SetMinMaxValues = bar_SetSmoothedMinMaxValues

        handledObjects[bar] = true

        if not frame:GetScript("OnUpdate") then
            frame:SetScript("OnUpdate", onUpdate)
        end
    end

    function E:DesmoothBar(bar)
        if activeObjects[bar] then
            bar:SetValue_(activeObjects[bar])
            activeObjects[bar] = nil
        end

        if bar.SetValue_ then
            bar.SetValue = bar.SetValue_
            bar.SetValue_ = nil
        end

        if bar.SetMinMaxValues_ then
            bar.SetMinMaxValues = bar.SetMinMaxValues_
            bar.SetMinMaxValues_ = nil
        end

        handledObjects[bar] = nil

        if not next(handledObjects) then
            frame:SetScript("OnUpdate", nil)
        end
    end

    function E:SetSmoothingAmount(amount)
        AMOUNT = clamp(amount, 0.3, 0.6)
    end
end
