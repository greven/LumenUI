local _, ns = ...
local E, C, M, oUF = ns.E, ns.C, ns.M, ns.oUF

local UF = E:GetModule("UnitFrames")

-- ---------------

-- Health Bar
do
  local function element_UpdateConfig(self)
		local unit = self.__owner._unit
		self._config = E:CopyTable(C.modules.unitframes.units[unit].health, self._config)
		-- self._config.text = E:CopyTable(C.db.global.fonts.units, self._config.text)
  end

  local function element_UpdateColors(self)
		self.colorClass = self._config.color.class
		self.colorReaction = self._config.color.reaction
    self:ForceUpdate()
	end

  local function frame_UpdateHealth(self)
    local element = self.Health
    element:UpdateConfig()
    element:UpdateColors()
  end

  function UF:CreateHealthBar(frame)
    local element = CreateFrame("StatusBar", nil, frame)
    element:SetPoint("TOPLEFT", frame)
    element:SetPoint("TOPRIGHT", frame)
    element:SetStatusBarTexture(M.textures.statusbar)

    -- local bg = element:CreateTexture(nil, "BACKGROUND")
    -- bg:SetAllPoints()
    -- bg:SetTexture(M.textures.backdrop)
    -- bg:SetVertexColor(.3, .3, .3)
    -- bg:SetAlpha(0.8)
    -- bg.multiplier = .1
    -- element.bg = bg

    element.colorHealth = true
    element.colorTapping = true
    element.colorDisconnected = true
    element.UpdateConfig = element_UpdateConfig
    element.UpdateColors = element_UpdateColors

    frame.UpdateHealth = frame_UpdateHealth
    frame.Health = element

    return element
  end
end
