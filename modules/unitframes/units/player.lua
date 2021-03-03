local _, ns = ...
local E, C, L, M, P, oUF = ns.E, ns.C, ns.L, ns.M, ns.P, ns.oUF

local UF = P:GetModule("UnitFrames")

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local isInit = false

function UF:HasPlayerFrame()
    return isInit
end

-- Player Frame
do
    local function frame_Update(self)
        self:UpdateConfig()

        if self._config.enabled then
            UF:SetStateVisibility(self)

            self:UpdateSize()
            self:UpdateHealth()
            self:UpdateHealthPrediction()
            self:UpdatePower()
            self:UpdateAdditionalPower()
            self:UpdatePowerPrediction()
            self:UpdateName()
            self:UpdateCastbar()
            self:UpdatePortrait()
            self:UpdateAuras()
            self:UpdateUnitIndicator()
            self:UpdateThreatIndicator()
            self:UpdatePvPIndicator()
        else
            if self:IsEnabled() then
                self:Disable()
            end
        end
    end

    function UF:CreatePlayerFrame(frame)
        local config = C.db.profile.unitframes.units[frame._layout or frame._unit]
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

        self:CreateHealthBar(frame, textParent)
        self:CreatePowerBar(frame, textParent)

        local addPower = self:CreateAdditionalPower(frame)
        addPower:SetFrameLevel(frame:GetFrameLevel() + 3)
        E:SetBackdrop(addPower, E.SCREEN_SCALE * 3)
        E:CreateShadow(addPower)

        self:CreateHealthPrediction(frame, frame.Health, textParent)
        self:CreatePowerPrediction(frame, frame.Power, addPower)

        self:CreateName(frame, textParent)
        self:CreateCastbar(frame)
        self:CreatePortrait(frame, portraitParent)
        self:CreateAuras(frame, "player")
        self:CreateUnitIndicator(frame, portraitParent)

        local threatBorder = self:CreateThreatIndicator(frame, portraitParent)
        threatBorder:SetOffset(-5)

        -- Level and Spec
        local info = textParent:CreateFontString(nil, "ARTWORK")
        info:SetFont(C.db.global.fonts.units.font, 14, "OUTLINE")
        info:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 1, 24)
        frame:Tag(info, "[lum:color_unit][lum:spec]")

        -- PvP Indicator and timer
        local pvpIndicator = self:CreatePvPIndicator(frame, portraitParent)
        local pvpTimer = textParent:CreateFontString(nil, "ARTWORK")
        pvpTimer:SetFont(C.db.global.fonts.units.font, 15, "OUTLINE")
        pvpTimer:SetPoint("TOPLEFT", portraitParent, "TOPLEFT", 0, 0)
        pvpTimer:SetTextColor(1, 0.82, 0)
        pvpTimer:SetJustifyH("RIGHT")
        pvpIndicator.Timer = pvpTimer
        frame.PvPIndicator = pvpIndicator

        frame.Update = frame_Update

        isInit = true
    end
end

-- Player Plate Frame
do
    local AttachHolderFrame

    local function onNamePlateUpdate(frame, event, nameplate)
        -- TODO: Remember why the player plate isn't being caught here, we need to get the event on spawn...
        -- print(event, nameplate)
        -- print(frame, event, nameplate)
        -- if event == "NAME_PLATE_UNIT_ADDED" then
        --     if UnitIsUnit(nameplate, "player") then
        --         print(frame, event, nameplate)
        --     end
        -- end
    end

    local function frame_Update(self)
        self:UpdateConfig()

        if self._config.enabled then
            UF:SetStateVisibility(self)

            self:UpdateSize()
            self:UpdateHealth()
            self:UpdateHealthPrediction()
            self:UpdatePower()
            self:UpdatePowerPrediction()
            self:UpdateClassPower()
            self:UpdateAuraBars()

            if self.Runes then
                self:UpdateRunes()
            end
            if self.Stagger then
                self:UpdateStagger()
            end
        else
            if self:IsEnabled() then
                self:Disable()
                self:UnregisterEvent("NAME_PLATE_UNIT_ADDED", onNamePlateUpdate)
            end
        end
    end

    function UF:CreatePlayerPlateFrame(frame)
        local config = C.db.profile.unitframes.units[frame._layout or frame._unit]
        local level = frame:GetFrameLevel()

        local textParent = CreateFrame("Frame", nil, frame)
        textParent:SetFrameLevel(level + 9)
        textParent:SetAllPoints()
        frame.TextParent = textParent

        local health = self:CreateHealthBar(frame, textParent)
        local power = self:CreatePowerBar(frame, textParent)

        self:CreateHealthPrediction(frame, health, textParent)
        self:CreatePowerPrediction(frame, frame.Power)

        -- Class Power
        if E.PLAYER_CLASS == "MONK" then
            self:CreateStagger(frame)
        elseif E.PLAYER_CLASS == "DEATHKNIGHT" then
            self:CreateRunes(frame)
        end
        self:CreateClassPower(frame)

        self:CreateAuraBars(frame)

        -- TODO: Attach to Blizzard's Personal Resource Display
        -- Attach PlayerPlate to Blizzard's Personal Resource Display
        -- if config.attached and not AttachHolderFrame then
        --     SetCVar("nameplateShowSelf", 1)
        --     SetCVar("nameplatePersonalShowAlways", 1)
        --     SetCVar("nameplateSelfAlpha", 0)

        --     AttachHolderFrame = CreateFrame("Frame",
        --                                     "LumPlayerPlateAttachHolder",
        --                                     UIParent)
        --     AttachHolderFrame:SetSize(5, 5)
        --     E:SetPosition(AttachHolderFrame, config.point)

        --     frame:RegisterEvent("NAME_PLATE_UNIT_ADDED", onNamePlateUpdate, true)
        -- else
        --     SetCVar("nameplateSelfAlpha", 1)
        --     SetCVar("nameplatePersonalShowAlways", 0)
        --     frame:UnregisterEvent("NAME_PLATE_UNIT_ADDED", onNamePlateUpdate)
        -- end

        frame.Update = frame_Update

        isInit = true
    end
end
