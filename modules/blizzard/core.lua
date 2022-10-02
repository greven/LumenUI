local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BLIZZARD = P:AddModule("Blizzard")

-- ---------------

local isInit = false

function BLIZZARD:IsInit()
    return isInit
end

function BLIZZARD:Init()
    if not isInit and C.db.profile.blizzard.enabled then
        self:SetUpCharacterFrame()
        -- self:SetUpCommandBar()
        -- self:SetUpDigsiteBar()
        self:SetUpDurabilityFrame()
        -- self:SetUpGMFrame()
        -- self:SetUpMail()
        -- self:SetUpObjectiveTracker()
        self:SetUpAltPowerBar()
        self:SetUpTalkingHead()
        -- self:SetUpMirrorTimers()
        self:SetUpVehicleSeatFrame()
        self:SetUpErrorsFrame()

        isInit = true

        self:Update()
    end
end

function BLIZZARD:Update()
    if isInit then
        self:UpdateObjectiveTracker()
        self.UpdateVehicleSeatFrame()
    end
end
