local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Bars")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc

-- ---------------

local LibKeyBound = LibStub("LibKeyBound-1.0")
local isInit = false

local function updateFont(fontString, config)
    fontString:SetFont(C.global.fonts.bars.font, config.size, config.outline and "THINOUTLINE" or nil)
    fontString:SetWordWrap(false)

    if config.shadow then
        fontString:SetShadowOffset(1, -1)
    else
        fontString:SetShadowOffset(0, 0)
    end
end

local function button_UpdateHotKey(self, state)
    if state ~= nil then
        self._parent._config.hotkey.enabled = state
    end

    if self._parent._config.hotkey.enabled then
        self.HotKey:SetParent(self)
        self.HotKey:SetFormattedText("%s", self:GetHotkey())
        self.HotKey:Show()
    else
        self.HotKey:SetParent(E.HIDDEN_PARENT)
    end
end

local function button_UpdateHotKeyFont(self)
    updateFont(self.HotKey, self._parent._config.hotkey)
end

local function button_OnEnter(self)
    if LibKeyBound then
        LibKeyBound:Set(self)
    end
end

function M.CreateExtraButton()
    if not isInit then
        local bar = CreateFrame("Frame", "LumExtraActionBar", UIParent, "SecureHandlerStateTemplate")
        bar._id = "extra"
        bar._buttons = {}

        M:AddBar("extra", bar)

        bar.Update = function(self)
            self:UpdateConfig()
            self:UpdateVisibility()
            self:UpdateButtons("UpdateHotKey")
            self:UpdateButtons("UpdateHotKeyFont")
            self:UpdateCooldownConfig()
            self:UpdateFading()

            ExtraActionBarFrame:ClearAllPoints()
            ExtraActionBarFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
            ExtraActionBarFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)

            local width, height = ExtraActionButton1:GetSize()
            self:SetSize((width > 0 and width or 52) + 4, (height > 0 and height or 52) + 4)
            -- E.Movers:Get(self):UpdateSize()
        end

        ExtraActionBarFrame.ignoreFramePositionManager = true
        UIPARENT_MANAGED_FRAME_POSITIONS["ExtraActionBarFrame"] = nil
        UIPARENT_MANAGED_FRAME_POSITIONS["ExtraAbilityContainer"] = nil

        ExtraActionBarFrame:EnableMouse(false)
        ExtraActionBarFrame:SetParent(bar)
        ExtraActionBarFrame.ignoreInLayout = true
        ExtraAbilityContainer.SetSize = E.NOOP

        ExtraActionButton1:HookScript("OnEnter", button_OnEnter)
        ExtraActionButton1._parent = bar
        ExtraActionButton1._command = "EXTRAACTIONBUTTON1"
        E:SkinExtraActionButton(ExtraActionButton1)
        bar._buttons[1] = ExtraActionButton1

        E:ForceHide(ExtraActionButton1.style)

        ExtraActionButton1.UpdateHotKey = button_UpdateHotKey
        ExtraActionButton1.UpdateHotKeyFont = button_UpdateHotKeyFont

        local point = C.profile.modules.bars.extra.point
        bar:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
        -- E.Movers:Create(bar)

        bar:Update()

        isInit = true
    end
end
