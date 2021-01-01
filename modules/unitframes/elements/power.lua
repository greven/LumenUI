local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

-- Power Bar
do
  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit], self._config)
  end

  local function element_UpdateColors(self)
    local config = self._config
    self.colorPower = config.power.color.power
    self.colorTapping = config.power.color.tapping
    self.colorDisconnected = config.power.color.disconnected
		self.colorClass = config.power.color.class
    self:ForceUpdate()
  end

  local function element_UpdateSize(self)
    local frame = self:GetParent()
    local config = self._config

    self:SetPoint("TOP", frame, "BOTTOM", 0, config.power.height)
    self:SetPoint("BOTTOM", frame, 0, 0)
    self:SetPoint("LEFT", frame, 0, 0)
    self:SetPoint("RIGHT", frame, 0, 0)
    self:ForceUpdate()
	end

  local function frame_UpdatePower(self)
    local element = self.Power
    element:UpdateConfig()
    element:UpdateColors()
    element:UpdateSize()
  end

  function UF:CreatePowerBar(frame)
    local config = C.modules.unitframes.units[frame._unit].power

    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("BOTTOMLEFT", frame)
    element:SetPoint("BOTTOMRIGHT", frame)
    element:SetStatusBarTexture(M.textures.neon)
    element:GetStatusBarTexture():SetHorizTile(false)

    element.UpdateConfig = element_UpdateConfig
    element.UpdateColors = element_UpdateColors
    element.UpdateSize = element_UpdateSize

    frame.UpdatePower = frame_UpdatePower
    frame.Power = element

    return element
  end
end
