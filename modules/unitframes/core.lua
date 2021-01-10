local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack
local next = _G.next

-- ---------------

local UF = E:AddModule("UnitFrames")

-- ---------------

local isInit = false
local objects = {}
local units = {}

local function frame_OnEnter(self)
  self = self.__owner or self
	UnitFrame_OnEnter(self)
end

local function frame_OnLeave(self)
  self = self.__owner or self
	UnitFrame_OnLeave(self)
end

local function frame_UpdateConfig(self)
  self._config = E:CopyTable(C.modules.unitframes.units[self._unit], self._config)
end

local function frame_UpdateSize(self)
  local width, height = self._config.width, self._config.height

  self:SetSize(width, height)

  if self.TextParent then
		self.TextParent:SetSize(width - 8, height)
  end
end

local function frame_ForElement(self, element, method, ...)
	if self[element] and self[element][method] then
		self[element][method](self[element], ...)
	end
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

function UF:UpdateReactionColors()
  local color = oUF.colors.reaction
  for k, v in next, C.colors.reaction do
    color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
	end
end

function UF:CreateUnitFrame(unit, name)
  if not units[unit] then
    if unit == "boss" then
      -- TODO: Boss spawning here
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
      -- TODO: Update boss frames here
    elseif objects[unit] then
      if objects[unit][method] then
				objects[unit][method](objects[unit], ...)
			end
    end
  end
end

function UF:UpdateUnitFrames(method, ...)
	for unit in next, units do
		self:UpdateUnitFrame(unit, method, ...)
	end
end

function UF:ForEach(method, ...)
	for unit in next, units do
		self:UpdateUnitFrame(unit, method, ...)
	end
end

function UF:GetUnits(ignoredUnits)
	local temp = {}

	for unit in next, units do
		if not ignoredUnits or not ignoredUnits[unit] then
			temp[unit] = unit
		end
	end

	return temp
end

function UF:IsInit()
	return isInit
end

function UF:Init()
  local config = C.modules.unitframes

  if not isInit and config.enabled then
    self:UpdateHealthColors()
    self:UpdatePowerColors()
    self:UpdateReactionColors()

    oUF:Factory(function()
      oUF:RegisterStyle("Lumen", function(frame, unit)
        frame:RegisterForClicks("AnyUp")
        frame:SetScript("OnEnter", frame_OnEnter)
				frame:SetScript("OnLeave", frame_OnLeave)
        frame._unit = unit:gsub("%d+", "")

        frame.ForElement = frame_ForElement
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

    if config.units.player.enabled then
      UF:CreateUnitFrame("player", "LumenPlayer")
      UF:UpdateUnitFrame("player", "Update")
    end

    if config.units.target.enabled then
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
