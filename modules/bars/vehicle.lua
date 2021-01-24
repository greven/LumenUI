local _, ns = ...
local E, C = ns.E, ns.C

local M = E:GetModule("Bars")

-- Lua
local _G = getfenv(0)

-- ---------------

local isInit = false

local function button_onEvent(self)
    if UnitOnTaxi("player") or CanExitVehicle() then
        self:Show()
        self.Icon:SetDesaturated(false)
        self:Enable()
    else
        self:Hide()
    end
end

local function button_onClick(self)
    if UnitOnTaxi("player") then
        TaxiRequestEarlyLanding()

        self:SetButtonState("NORMAL")
        self.Icon:SetDesaturated(true)
        self:Disable()
    else
        VehicleExit()
    end
end

local function bar_Update(self)
    self:UpdateConfig()
    self:UpdateFading()

    self:SetSize(self._config.size + 4, self._config.size + 4)
    -- E.Movers:Get(self):UpdateSize()
end

function M.CreateVehicleExitButton()
    if not isInit then
        local bar = CreateFrame("Frame", "LumVehicleExitFrame", UIParent)
        bar._id = "vehicle"
        bar._buttons = {}

        M:AddBar(bar._id, bar)

        bar.Update = bar_Update
        bar.UpdateCooldownConfig = nil

        local button = E:CreateButton(bar)
        button:SetPoint("TOPLEFT", 2, -2)
        button:SetPoint("BOTTOMRIGHT", -2, 2)
        button:SetScript("OnClick", button_onClick)
        button:SetScript("OnEvent", button_onEvent)
        button:RegisterEvent("UNIT_ENTERED_VEHICLE")
        button:RegisterEvent("UNIT_EXITED_VEHICLE")
        button:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
        button:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
        button:RegisterEvent("VEHICLE_UPDATE")
        bar._buttons[1] = button

        button.Icon:SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
        button.Icon:SetTexCoord(12 / 64, 52 / 64, 12 / 64, 52 / 64)

        button.Border:SetVertexColor(E:GetRGB(C.colors.red))

        button_onEvent(button)

        local point = C.modules.bars.vehicle.point
        bar:SetPoint(point.p, point.anchor, point.ap, point.x, point.y)
        -- E.Movers:Create(bar)

        bar:Update()

        isInit = true
    end
end