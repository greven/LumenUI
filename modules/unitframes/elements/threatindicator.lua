local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)

local IsInGroup = _G.IsInGroup
local UnitExists = _G.UnitExists

-- ---------------

local function element_UpdateConfig(self)
    local unit = self.__owner._unit
    self._config = E:CopyTable(C.db.profile.unitframes.units[unit].threat, self._config)
end

local function element_PostUpdate(self, _, status)
    if not IsInGroup() then
        self:Hide()
        self.glow:Hide()
        return
    end

    if status and status > 0 then
        -- self.glow:Show()
        -- print(status)
        self:Show()
        -- self.glow:SetVertexColor(self:GetVertexColor())
        self.glow:SetVertexColor(E:GetRGB(C.db.global.colors.red))
    else
        self.glow:Hide()
    end
end

local function frame_UpdateThreatIndicator(self, event)
    local element = self.ThreatIndicator
    element:UpdateConfig()

    element.feedbackUnit = element._config.feedback_unit

    if event == "GROUP_JOINED" or event == "GROUP_LEFT" then
        element:ForceUpdate()
    end

    if element._config.enabled and not self:IsElementEnabled("ThreatIndicator") then
        self:EnableElement("ThreatIndicator")
    elseif not element._config.enabled and self:IsElementEnabled("ThreatIndicator") then
        self:UnregisterEvent("GROUP_JOINED")
        self:UnregisterEvent("GROUP_LEFT")
        self:DisableElement("ThreatIndicator")
    end

    if self:IsElementEnabled("ThreatIndicator") then
        element:ForceUpdate()
    end
end

function UF:CreateThreatIndicator(frame, parent)
    local holder = CreateFrame("Frame", nil, (parent or frame))
    holder:SetFrameLevel((parent or frame):GetFrameLevel() + 10)
    holder:SetAllPoints()

    local glowParent = CreateFrame("Frame", nil, holder)
    glowParent:SetFrameLevel(frame:GetFrameLevel() - 1)
    glowParent:SetAllPoints()

    local element = E:CreateBorder(holder, "OVERLAY")

    local glow = E:CreateGlow(glowParent, 10)
    element.glow = glow

    element.PostUpdate = element_PostUpdate
    element.UpdateConfig = element_UpdateConfig

    frame.UpdateThreatIndicator = frame_UpdateThreatIndicator

    frame:RegisterEvent("GROUP_JOINED", frame_UpdateThreatIndicator, true)
    frame:RegisterEvent("GROUP_LEFT", frame_UpdateThreatIndicator, true)

    frame.ThreatIndicator = element

    return element
end
