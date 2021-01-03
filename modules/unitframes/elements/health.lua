local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- Lua
local _G = getfenv(0)

local UnitGUID = _G.UnitGUID
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local CreateColor = _G.CreateColor

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

-- Health
do
	local function element_PostUpdate(self, unit, cur, max)
    local unitGUID = UnitGUID(unit)
    local config = self._config

		self.GainLossIndicators:Update(cur, max, unitGUID == self.GainLossIndicators._UnitGUID)
		self.GainLossIndicators._UnitGUID = unitGUID

		if not (self:IsShown() and max and max ~= 0) or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
			self:SetMinMaxValues(0, 1)
			self:SetValue(0)
    end

    if config.color.reverse and config.color.smooth then
      local color = CreateColor(oUF:ColorGradient(cur, max, unpack(self.smoothGradient)))
      self.bg:SetVertexColor(E:GetRGB(color))
    end
	end

  local function element_PostUpdateColor(self)
    local unit = self.__owner._unit
    local config = self._config

    if config.color.reverse then
      self:SetStatusBarTexture(M.textures.vertlines)
      self:SetAlpha(0.92)

      self.bg:SetAlpha(0.9)
      if not config.color.smooth then
        self.bg:SetVertexColor(E:GetUnitColor(unit))
      end
    end
  end

  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit].health, self._config)
		self._config.power = E:CopyTable(C.modules.unitframes.units[unit].power, self._config.power)
  end

  local function element_UpdateColors(self)
    local config = self._config

    -- Red, Yellow, Class Color
    self.smoothGradient = {
      0.86, 0.15, 0.15,
      0.92, 0.70, 0.03,
      E:GetRGB(E.CLASS_COLOR)
    }

    self.colorSmooth = config.color.smooth
    self.colorHealth = not config.color.reverse and config.color.health
    self.colorTapping = not config.color.reverse and config.color.tapping
    self.colorDisconnected = not config.color.reverse and config.color.disconnected
		self.colorClass = not config.color.smooth and config.color.class
    self.colorReaction = not config.color.smooth and not config.color.reverse and config.color.reaction

    if config.color.reverse then
      self.colorClass = false
      self.colorSmooth = false
      self.bg:SetTexture(C.global.statusbar.texture)
      self.bg:SetAlpha(0.9)
    end

    self:ForceUpdate()
  end

  local function element_UpdateSize(self)
    local frame = self:GetParent()
    local config = self._config

    self:SetPoint("TOP", frame, 0, 0)
    self:SetPoint("BOTTOM", frame, 0, config.power.height + config.power.gap)
    self:SetPoint("LEFT", frame, 0, 0)
    self:SetPoint("RIGHT", frame, 0, 0)
    self:ForceUpdate()
	end

  local function frame_UpdateHealth(self)
    local element = self.Health
    element:UpdateConfig()
    element:UpdateColors()
    element:UpdateSize()
  end

  function UF:CreateHealthBar(frame, textParent)
    local config = C.modules.unitframes.units[frame._unit].health

    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("TOPLEFT", frame)
    element:SetPoint("TOPRIGHT", frame)
    element:SetStatusBarTexture(C.global.statusbar.texture)
    element:SetStatusBarColor(E:GetRGB(C.global.statusbar.color))
    E:SmoothBar(element)

    element.GainLossIndicators = E:CreateGainLossIndicators(element)
		element.GainLossIndicators.Gain = nil

    local bg = element:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(M.textures.vertlines)
    bg:SetAlpha(0.5)
    bg.multiplier = 0.3
    element.bg = bg

    element.PostUpdate = element_PostUpdate
    element.PostUpdateColor = element_PostUpdateColor
    element.UpdateConfig = element_UpdateConfig
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize

    frame.UpdateHealth = frame_UpdateHealth
    frame.Health = element

    return element
  end
end
