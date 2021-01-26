local _, ns = ...
local E, C = ns.E, ns.C

local M = E:GetModule("Bars")

-- Lua
local _G = getfenv(0)
local next = _G.next

-- ---------------

local LibKeyBound = LibStub("LibKeyBound-1.0")
local isInit = false

local BUTTONS = {
    StanceButton1, StanceButton2, StanceButton3, StanceButton4, StanceButton5,
    StanceButton6, StanceButton7, StanceButton8, StanceButton9, StanceButton10
}

local function button_Update(self)
    if self:IsShown() then
        local id = self:GetID()
        local texture, isActive, isCastable = GetShapeshiftFormInfo(id)

        self.icon:SetTexture(texture)

        if texture then
            self.cooldown:Show()
        else
            self.cooldown:Hide()
        end

        self:SetChecked(isActive)

        if isCastable then
            self.icon:SetDesaturated(false)
            self.icon:SetVertexColor(E:GetRGB(C.colors.button.normal))
        else
            self.icon:SetDesaturated(true)
            self.icon:SetVertexColor(E:GetRGB(C.colors.button.unusable))
        end

        self.HotKey:SetVertexColor(E:GetRGB(C.colors.button.normal))

        self:UpdateHotKey()
        self:UpdateCooldown()
    end
end

local function button_UpdateHotKey(self, state)
    if state ~= nil then self._parent._config.hotkey.enabled = state end

    if self._parent._config.hotkey.enabled then
        self.HotKey:SetParent(self)
        self.HotKey:SetFormattedText("%s", self:GetHotkey())
        self.HotKey:Show()
    else
        self.HotKey:SetParent(E.HIDDEN_PARENT)
    end
end

local function button_UpdateHotKeyFont(self)
    local config = self._parent._config.hotkey

    self.HotKey:SetFont(C.global.fonts.bars.font, config.size,
                        config.outline and "THINOUTLINE" or nil)
    self.HotKey:SetWordWrap(false)

    if config.shadow then
        self.HotKey:SetShadowOffset(1, -1)
    else
        self.HotKey:SetShadowOffset(0, 0)
    end
end

local function button_UpdateCooldown(self)
    CooldownFrame_Set(self.cooldown, GetShapeshiftFormCooldown(self:GetID()))
end

local function button_OnEnter(self) if LibKeyBound then LibKeyBound:Set(self) end end

function M.CreateStanceBar()
    if not isInit then
        local bar = CreateFrame("Frame", "LumStanceBar", UIParent,
                                "SecureHandlerStateTemplate")
        bar._id = "bar7"
        bar._buttons = {}

        M:AddBar(bar._id, bar)

        bar.Update = function(self)
            self:UpdateConfig()
            self:UpdateVisibility()
            self:UpdateForms()
            self:UpdateButtons("UpdateHotKeyFont")
            self:UpdateCooldownConfig()
            self:UpdateFading()
            E:UpdateBarLayout(self)
        end

        bar.UpdateForms = function(self)
            local numStances = GetNumShapeshiftForms()

            for i, button in next, self._buttons do
                if i <= numStances then
                    button:Show()
                    button:Update()
                else
                    button:Hide()
                end
            end
        end

        for i = 1, #BUTTONS do
            local button = CreateFrame("CheckButton", "$parentButton" .. i, bar,
                                       "StanceButtonTemplate")
            button:SetID(i)
            button:SetScript("OnEvent", nil)
            button:SetScript("OnUpdate", nil)
            button:HookScript("OnEnter", button_OnEnter)
            button:UnregisterAllEvents()
            button._parent = bar
            button._command = "SHAPESHIFTBUTTON" .. i

            button.Update = button_Update
            button.UpdateCooldown = button_UpdateCooldown
            button.UpdateHotKey = button_UpdateHotKey
            button.UpdateHotKeyFont = button_UpdateHotKeyFont

            BUTTONS[i]:SetAllPoints(button)
            BUTTONS[i]:SetAttribute("statehidden", true)
            BUTTONS[i]:SetParent(E.HIDDEN_PARENT)
            BUTTONS[i]:SetScript("OnEvent", nil)
            BUTTONS[i]:SetScript("OnUpdate", nil)
            BUTTONS[i]:UnregisterAllEvents()

            E:SkinStanceButton(button)

            bar._buttons[i] = button
        end

        bar:SetScript("OnEvent", function(self, event)
            if event == "UPDATE_SHAPESHIFT_COOLDOWN" then
                self:UpdateButtons("Update")
            elseif event == "PLAYER_REGEN_ENABLED" then
                if self.needsUpdate and not InCombatLockdown() then
                    self.needsUpdate = nil
                    self:UpdateForms()
                end
            else
                if InCombatLockdown() then
                    self.needsUpdate = true
                    self:UpdateButtons("Update")
                else
                    self:UpdateForms()
                end
            end
        end)

        bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
        bar:RegisterEvent("PLAYER_ENTERING_WORLD")
        bar:RegisterEvent("PLAYER_REGEN_ENABLED")
        bar:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
        bar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
        bar:RegisterEvent("UPDATE_POSSESS_BAR")
        bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
        bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
        bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
        bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
        bar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")

        local point = C.modules.bars.bar7.point
        bar:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
        -- E.Movers:Create(bar)

        bar:Update()

        isInit = true
    end
end
