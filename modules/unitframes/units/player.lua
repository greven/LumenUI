local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local isInit = false

function UF:HasPlayerFrame()
	return isInit
end

do
  local function frame_Update(self)
    self:UpdateConfig()

    if self._config.enabled then
      if not self:IsEnabled() then
        self:Enable()
      end

      self:UpdateSize()
      self:UpdateHealth()
      self:UpdatePower()
      self:UpdateName()
      self:UpdateCastbar()
      self:UpdatePortrait()
      self:UpdateAuras()
      self:UpdateUnitIndicator()
      self:UpdatePvPIndicator()
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
    self:CreatePowerBar(frame, textParent)
    self:CreateName(frame, textParent)
    self:CreateCastbar(frame)
    self:CreatePortrait(frame, portraitParent)
    self:CreateAuras(frame, "player")
    self:CreateUnitIndicator(frame, portraitParent)
    self:CreatePvPIndicator(frame, portraitParent)

    -- Level and Spec
    local info = textParent:CreateFontString(nil, "ARTWORK")
    info:SetFont(M.fonts.condensed, 16, "OUTLINE")
    info:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", 0, 2)
    frame:Tag(info, "[lum:color][lum:spec] [class]")

    frame.Update = frame_Update

    isInit = true
  end
end

do
  local function frame_Update(self)
    self:UpdateConfig()

    self:UpdateSize()
    self:UpdatePower()

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
    E.SetBackdrop(frame, 2)
    E.CreateShadow(frame)

    local textParent = CreateFrame("Frame", nil, frame)
    textParent:SetFrameLevel(level + 9)
    textParent:SetAllPoints()
    frame.TextParent = textParent

    local power = self:CreatePowerBar(frame, textParent)
    power:SetAllPoints()

    frame.Update = frame_Update

    isInit = true
  end
end
