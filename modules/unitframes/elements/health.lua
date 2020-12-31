local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

-- Health Bar
do
  -- local function element_PostUpdate(self)
  --   print("element_PostUpdate")
  -- end

  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit], self._config)
  end

  local function element_UpdateColors(self)
    local config = self._config
		self.colorClass = config.health.color.class
		self.colorReaction = config.health.color.reaction
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

  function UF:CreateHealthBar(frame)
    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("TOPLEFT", frame)
    element:SetPoint("TOPRIGHT", frame)
    element:SetStatusBarTexture(M.textures.statusbar)

    -- local bg = element:CreateTexture(nil, "BACKGROUND")
    -- bg:SetAllPoints()
    -- bg:SetTexture(M.textures.bg)
    -- bg:SetAlpha(C.global.statusbar.bg.alpha)
    -- bg.multiplier = C.global.statusbar.bg.mult
    -- element.bg = bg

    element.colorHealth = true
    element.colorTapping = true
    element.colorDisconnected = true
    -- element.PostUpdate = element_PostUpdate
    element.UpdateConfig = element_UpdateConfig
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize

    frame.UpdateHealth = frame_UpdateHealth
    frame.Health = element

    return element
  end
end
