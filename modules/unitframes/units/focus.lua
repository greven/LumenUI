local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local isInit = false

function UF:HasFocusFrame()
    return isInit
end

local function frame_Update(self)
    self:UpdateConfig()

    if self._config.enabled then
        UF:SetStateVisibility(self)

        self:UpdateSize()
        self:UpdateHealth()
        self:UpdateHealthPrediction()
        self:UpdatePower()
        self:UpdateName()
        self:UpdateCastbar()
        self:UpdateAuras()
        self:UpdateRaidTargetIndicator()
        self:UpdateThreatIndicator()
    else
        if self:IsEnabled() then
            self:Disable()
        end
    end
end

function UF:CreateFocusFrame(frame)
    local config = C.db.profile.unitframes.units[frame._layout or frame._unit]
    local level = frame:GetFrameLevel()

    local textParent = CreateFrame("Frame", nil, frame)
    textParent:SetFrameLevel(level + 9)
    textParent:SetAllPoints()
    frame.TextParent = textParent

    local health = self:CreateHealthBar(frame, textParent)
    self:CreateHealthPrediction(frame, health, textParent)

    self:CreatePowerBar(frame, textParent)
    self:CreateName(frame, textParent)
    self:CreateCastbar(frame)
    self:CreateAuras(frame, "focus")
    self:CreateRaidTargetIndicator(frame)
    self:CreateThreatIndicator(frame)

    frame.Update = frame_Update

    isInit = true
end
