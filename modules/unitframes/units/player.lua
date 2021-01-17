local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

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
      if not self:IsEnabled() then
        self:Enable()
      end

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
      self:UpdatePvPIndicator()
      -- self:UpdateThreatIndicator()
    else
      if self:IsEnabled() then
        self:Disable()
      end
    end
  end

  function UF:CreatePlayerFrame(frame)
    local config = C.modules.unitframes.units[frame._unit]
    local level = frame:GetFrameLevel()

    E.SetBackdrop(frame, 2)
    E.CreateShadow(frame)

    local textParent = CreateFrame("Frame", nil, frame)
    textParent:SetFrameLevel(level + 9)
    textParent:SetAllPoints()
    frame.TextParent = textParent

    local portraitParent = CreateFrame("Frame", nil, frame)
    portraitParent:SetSize(config.portrait.width, config.portrait.height)
    E:SetPosition(portraitParent, config.portrait.point, frame)
    E.SetBackdrop(portraitParent, 2)
    E.CreateShadow(portraitParent)

    self:CreateHealthBar(frame, textParent)
    self:CreateHealthPrediction(frame, frame.Health, textParent)

    self:CreatePowerBar(frame, textParent)
    local addPower = self:CreateAdditionalPower(frame)
    addPower:SetFrameLevel(frame:GetFrameLevel() + 3)
    self:CreatePowerPrediction(frame, frame.Power, addPower)

    self:CreateName(frame, textParent)
    self:CreateCastbar(frame)
    self:CreatePortrait(frame, portraitParent)
    self:CreateAuras(frame, "player")
    self:CreateUnitIndicator(frame, portraitParent)

    -- Level and Spec
    local info = textParent:CreateFontString(nil, "ARTWORK")
    info:SetFont(M.fonts.condensed, 15, "OUTLINE")
    info:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 1, 26)
    frame:Tag(info, "[lum:color_unit][lum:spec]")

    -- PvP Indicator and timer
    frame.PvPIndicator = self:CreatePvPIndicator(frame, portraitParent)
    local pvpTimer = portraitParent:CreateFontString(nil, "ARTWORK")
    pvpTimer:SetFont(M.fonts.condensed, 16, "OUTLINE")
		pvpTimer:SetPoint("TOPLEFT", portraitParent, "TOPRIGHT", 6, -1)
		pvpTimer:SetTextColor(1, 0.82, 0)
		pvpTimer:SetJustifyH("RIGHT")
    frame.PvPIndicator.Timer = pvpTimer

    -- self:CreateThreatIndicator(frame)

    -- local border = E:CreateBorder(parent or frame, "OVERLAY", 7)
    -- border:SetVertexColor(1, 0, 0.3)

    local glow = E:CreateGlow(parent or frame)
    glow:SetVertexColor(1, 0, 0.3)
    -- glow:SetOffset(-3)
    -- glow:SetSize(16)

    frame.Update = frame_Update

    isInit = true
  end
end

-- Player Plate Frame
do
  local function frame_Update(self)
    self:UpdateConfig()

    self:UpdateSize()
    self:UpdateHealth()
    self:UpdateHealthPrediction()
    self:UpdatePower()
    self:UpdatePowerPrediction()

    self:UpdateClassPower()

    if self.Runes then
      self:UpdateRunes()
    end

    if self.Stagger then
      self:UpdateStagger()
    end

    if self._config.enabled then
      if not self:IsEnabled() then
        self:Enable()
      end
    else
      if self:IsEnabled() then
        self:Disable()
      end
    end
  end

  function UF:CreatePlayerPlateFrame(frame)
    local config = C.modules.unitframes.units[frame._layout]
    local level = frame:GetFrameLevel()

    frame:RegisterForClicks()

    local textParent = CreateFrame("Frame", nil, frame)
    textParent:SetFrameLevel(level + 9)
    textParent:SetAllPoints()
    frame.TextParent = textParent

    local health = self:CreateHealthBar(frame, textParent)
    self:CreateHealthPrediction(frame, health, textParent)
    E.SetBackdrop(health, 2)
    E.CreateShadow(health)

    local power = self:CreatePowerBar(frame, textParent)
    self:CreatePowerPrediction(frame, frame.Power)
    E.SetBackdrop(power, 2)
    E.CreateShadow(power)

    -- Class Power
    if E.PLAYER_CLASS == "MONK" then
      self:CreateStagger(frame)
    elseif E.PLAYER_CLASS == "DEATHKNIGHT" then
      self:CreateRunes(frame)
    end
    self:CreateClassPower(frame)

    frame.Update = frame_Update

    isInit = true
  end
end
