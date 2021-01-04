local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)

local unpack = _G.unpack
local next = _G.next

-- ---------------

local UF = E:AddModule("UnitFrames")

local isInit = false

local cfg = C.modules.unitframes

-- ---------------

local objects = {}
local units = {}

local function frame_UpdateConfig(self)
  self._config = E:CopyTable(C.modules.unitframes.units[self._unit], self._config)
end

local function frame_UpdateSize(self)
  local width, height = self._config.width, self._config.height
  self:SetSize(width, height)
end

function UF:UpdateHealthColors()
	local color = oUF.colors.health
	color[1], color[2], color[3] = E:GetRGB(C.colors.health)

	color = oUF.colors.tapped
	color[1], color[2], color[3] = E:GetRGB(C.colors.tapped)

	color = oUF.colors.disconnected
  color[1], color[2], color[3] = E:GetRGB(C.colors.disconnected)

  oUF.colors.smooth = C.colors.smooth
end

function UF:UpdateReactionColors()
  local color = oUF.colors.reaction
  for k, v in next, C.colors.reaction do
    color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
	end
end

function UF:UpdatePowerColors()
	local color = oUF.colors.power
	for k, myColor in next, C.colors.power do
		if type(k) == "string" then
			if not color[k] then
				color[k] = {}
			end

			if type(myColor[1]) == "table" then
				for i, myColor_ in next, myColor do
					color[k][i][1], color[k][i][2], color[k][i][3] = E:GetRGB(myColor_)
				end
			else
				color[k][1], color[k][2], color[k][3] = E:GetRGB(myColor)
			end
		end
	end

	color = oUF.colors.runes
	for k, v in next, C.colors.runes do
		color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
	end
end

function UF:CreateUnitFrame(unit, name)
  if not units[unit] then
    if unit == "boss" then
      -- Boss spawning here
    else
      local object = oUF:Spawn(unit, name .. "Frame")
      object:UpdateConfig()
      E:SetPosition(object, object._config.point)
			objects[unit] = object
    end

    units[unit] = true
  end
end

function UF:UpdateUnitFrame(unit, method, ...)
  if units[unit] then
    if unit == "boss" then
      -- Update boss frames here
    elseif objects[unit] then
      if objects[unit][method] then
				objects[unit][method](objects[unit], ...)
			end
    end
  end
end

function UF:IsInit()
	return isInit
end

function UF:Init()
  if not isInit and cfg.enabled then
    self:UpdateReactionColors()
    self:UpdateHealthColors()
    self:UpdatePowerColors()

    oUF:Factory(function()
      oUF:RegisterStyle("Lumen", function(frame, unit)
        frame:RegisterForClicks("AnyUp")
        frame._unit = unit:gsub("%d+", "")

        frame.UpdateConfig = frame_UpdateConfig
        frame.UpdateSize = frame_UpdateSize

        if unit == "player" then
          UF:CreatePlayerFrame(frame)
        elseif unit == "target" then
					UF:CreateTargetFrame(frame)
        end
      end)
    end)
    oUF:SetActiveStyle("Lumen")

    if cfg.units.player.enabled then
      UF:CreateUnitFrame("player", "LumenPlayer")
      UF:UpdateUnitFrame("player", "Update")
    end

    if cfg.units.target.enabled then
      UF:CreateUnitFrame("target", "LumenTarget")
      UF:UpdateUnitFrame("target", "Update")
    end

    isInit = true
  end
end

function UF:Update()
	if isInit then
		for unit in next, units do
			self:UpdateUnitFrame(unit, "Update")
		end
	end
end
