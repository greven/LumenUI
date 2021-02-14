local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)

-- Blizz
local CreateFrame = _G.CreateFrame
local UnitIsPlayer = _G.UnitIsPlayer
local UnitReaction = _G.UnitReaction

-- ---------------

local isInit = false

function UF:HasTargetFrame()
    return isInit
end

-- Target Frame
do
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
            self:UpdatePortrait()
            self:UpdateAuras()
            self:UpdateUnitIndicator()
            self:UpdatePvPIndicator()
            self:UpdateRaidTargetIndicator()
            self:UpdateThreatIndicator()
        else
            if self:IsEnabled() then
                self:Disable()
            end
        end
    end

    function UF:CreateTargetFrame(frame)
        local config = C.db.profile.modules.unitframes.units[frame._layout or frame._unit]
        local level = frame:GetFrameLevel()

        local textParent = CreateFrame("Frame", nil, frame)
        textParent:SetFrameLevel(level + 9)
        textParent:SetAllPoints()
        frame.TextParent = textParent

        local portraitParent = CreateFrame("Frame", nil, frame)
        portraitParent:SetSize(config.portrait.width, config.portrait.height)
        E:SetPosition(portraitParent, config.portrait.point, frame)
        E:SetBackdrop(portraitParent, E.SCREEN_SCALE * 3)
        E:CreateShadow(portraitParent)

        local health = self:CreateHealthBar(frame, textParent)
        self:CreateHealthPrediction(frame, health, textParent)
        self:CreatePowerBar(frame, textParent)
        self:CreateName(frame, textParent)
        self:CreatePortrait(frame, portraitParent)
        self:CreateCastbar(frame)
        self:CreateAuras(frame, "target")
        self:CreateUnitIndicator(frame, portraitParent)
        self:CreateRaidTargetIndicator(frame)
        self:CreateThreatIndicator(frame)
        self:CreatePvPIndicator(frame, portraitParent)

        -- Level and Race
        local info = textParent:CreateFontString(nil, "ARTWORK")
        info:SetFont(C.db.global.fonts.units.font, 15, "OUTLINE")
        info:SetTextColor(E:GetRGB(C.db.global.colors.light_gray))
        info:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 0, 4)
        frame:Tag(info, "[lum:color_difficulty][lum:level]|r [lum:race] [lum:color_unit][lum:class]")

        frame.Update = frame_Update

        isInit = true
    end
end

-- Target Plate Frame
do
    local function frame_Update(self)
        self:UpdateConfig()

        if self._config.enabled then
            if self._config.visibility then
                self:Disable()
                RegisterAttributeDriver(self, "state-visibility", self._config.visibility)
            elseif not self:IsEnabled() then
                self:Enable()
            end

            self:UpdateSize()
            self:UpdateHealth()
            self:UpdateHealthPrediction()
            self:UpdatePower()
            self:UpdateName()
            self:UpdateCastbar()
            self:UpdateAuras()
            self:UpdateRaidTargetIndicator()
        else
            if self:IsEnabled() then
                self:Disable()
            end
        end
    end

    function UF:CreateTargetPlateFrame(frame)
        local level = frame:GetFrameLevel()

        local textParent = CreateFrame("Frame", nil, frame)
        textParent:SetFrameLevel(level + 9)
        textParent:SetAllPoints()
        frame.TextParent = textParent

        local health = self:CreateHealthBar(frame, textParent)
        local power = self:CreatePowerBar(frame, textParent)

        self:CreateHealthPrediction(frame, health, textParent)

        self:CreateName(frame, textParent)
        self:CreateCastbar(frame)
        self:CreateAuras(frame, "target")
        self:CreateRaidTargetIndicator(frame)

        -- Arrow indicator
        local arrow = frame:CreateTexture(nil, "ARTWORK")
        arrow:SetSize(18, 18)
        arrow:SetPoint("RIGHT", frame, "LEFT", -6, 0)
        arrow:SetTexture(M.textures.arrow)
        arrow:SetVertexColor(0, 0, 0)
        arrow:SetAlpha(0.8)
        frame.arrow = arrow

        frame.Update = frame_Update

        isInit = true
    end
end
