local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

local UF = E:GetModule("UnitFrames")

-- ---------------

-- Health Bar
do
  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit], self._config)
		-- self._config.text = E:CopyTable(C.db.global.fonts.units, self._config.text)
  end

  local function element_UpdateColors(self)
    local cfg = self._config
		self.colorClass = cfg.health.color.class
		self.colorReaction = cfg.health.color.reaction
    self:ForceUpdate()
  end

  local function element_UpdateSize(self)
    local frame = self:GetParent()
    local cfg = self._config

    self:SetPoint("TOP", frame, 0, 0)
    self:SetPoint("BOTTOM", frame, 0, cfg.power.height + cfg.power.gap)
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

  function UF:CreateHealthBar(frame)
    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("TOPLEFT", frame)
    element:SetPoint("TOPRIGHT", frame)
    element:SetStatusBarTexture(M.textures.statusbar)

    local bg = element:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(M.textures.bg)
    bg:SetAlpha(0.3)
    bg.multiplier = .3
    element.bg = bg

    element.colorHealth = true
    element.colorTapping = true
    element.colorDisconnected = true
    element.UpdateConfig = element_UpdateConfig
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize

    frame.UpdateHealth = frame_UpdateHealth
    frame.Health = element

    return element
  end
end
