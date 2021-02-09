-- Credits: ls_UI
local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:AddModule("Blizzard")

-- ---------------

local isInit = false

function M:IsInit()
    return isInit
end

function M:Init()
    if not isInit and C.modules.blizzard.enabled then
        self:SetUpCharacterFrame()
        -- self:SetUpCommandBar()
        -- self:SetUpDigsiteBar()
        self:SetUpDurabilityFrame()
        -- self:SetUpGMFrame()
        -- self:SetUpMail()
        self:SetUpObjectiveTracker()
        self:SetUpAltPowerBar()
        self:SetUpTalkingHead()
        -- self:SetUpMirrorTimers()
        self:SetUpVehicleSeatFrame()
        self:SetUpErrorsFrame()

        isInit = true

        self:Update()
    end
end

function M:Update()
    if isInit then
        self:UpdateObjectiveTracker()
        self.UpdateVehicleSeatFrame()
    end
end
