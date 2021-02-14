local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local isInit = false

function UF:HasFocusTargetFrame()
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
        self:UpdateRaidTargetIndicator()
        self:UpdateThreatIndicator()
    else
        if self:IsEnabled() then
            self:Disable()
        end
    end
end

function UF:CreateFocusTargetFrame(frame)
    local config = C.db.profile.modules.unitframes.units[frame._layout or frame._unit]
    local level = frame:GetFrameLevel()

    local textParent = CreateFrame("Frame", nil, frame)
    textParent:SetFrameLevel(level + 9)
    textParent:SetAllPoints()
    frame.TextParent = textParent

    local health = self:CreateHealthBar(frame, textParent)
    self:CreatePowerBar(frame, textParent)
    self:CreateHealthPrediction(frame, health, textParent)
    self:CreateName(frame, textParent)
    self:CreateRaidTargetIndicator(frame)
    self:CreateThreatIndicator(frame)

    -- Arrow indicator
    local arrow = frame:CreateTexture(nil, "ARTWORK")
    arrow:SetSize(18, 18)
    arrow:SetPoint("RIGHT", frame, "LEFT", -10, 0)
    arrow:SetTexture(M.textures.arrow)
    arrow:SetVertexColor(0, 0, 0)
    arrow:SetAlpha(0.8)
    frame.arrow = arrow

    frame.Update = frame_Update

    isInit = true
end
