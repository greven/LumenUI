-- Credits: ls_UI

local _, ns = ...
local E, C = ns.E, ns.C

local M = E:AddModule("Minimap")

local isInit = false
local isSquare = false

local cfg = C.modules.minimap

-- Lua
local _G = getfenv(0)

local next = _G.next
local select = _G.select
local unpack = _G.unpack
local hooksecurefunc = _G.hooksecurefunc

local m_atan2 = _G.math.atan2
local m_cos = _G.math.cos
local m_deg = _G.math.deg
local m_floor = _G.math.floor
local m_max = _G.math.max
local m_min = _G.math.min
local m_rad = _G.math.rad
local m_sin = _G.math.sin
local s_match = _G.string.match
local t_insert = _G.table.insert
local t_sort = _G.table.sort
local t_wipe = _G.table.wipe

-- Blizz
local C_Calendar = _G.C_Calendar
local C_DateAndTime = _G.C_DateAndTime
local C_Garrison = _G.C_Garrison
local C_Timer = _G.C_Timer
local GetCursorPosition = _G.GetCursorPosition

local BLIZZ_BUTTONS = {
	["MiniMapTracking"] = true,
	["QueueStatusMinimapButton"] = true,
	["MiniMapMailFrame"] = true,
	["GameTimeFrame"] = true,
	["GarrisonLandingPageMinimapButton"] = true,
}

local PVP_COLOR_MAP = {
	["arena"] = "hostile",
	["combat"] = "hostile",
	["contested"] = "contested",
	["friendly"] = "friendly",
	["hostile"] = "hostile",
	["sanctuary"] = "sanctuary",
}

-- ---------------

local function hasTrackingBorderRegion(self)
	for i = 1, select("#", self:GetRegions()) do
		local region = select(i, self:GetRegions())

		if region:IsObjectType("Texture") then
			local texture = region:GetTexture()
			if texture and (texture == 136430 or s_match(texture, "[tT][rR][aA][cC][kK][iI][nN][gG][bB][oO][rR][dD][eE][rR]")) then
				return true
			end
		end
	end

	return false
end

local function isMinimapButton(self)
	if BLIZZ_BUTTONS[self] then
		return true
	end

	if hasTrackingBorderRegion(self) then
		return true
	end

	for i = 1, select("#", self:GetChildren()) do
		if hasTrackingBorderRegion(select(i, self:GetChildren())) then
			return true
		end
	end

	return false
end

local function updatePosition(button, degrees)
	local angle = m_rad(degrees)
	local w = Minimap:GetWidth() / 2 + 5
	local h = Minimap:GetHeight() / 2 + 5

	if isSquare then
		button:SetPoint("CENTER", Minimap, "CENTER",
			m_max(-w, m_min(m_cos(angle) * (1.4142135623731 * w - 10), w)),
			m_max(-h, m_min(m_sin(angle) * (1.4142135623731 * h - 10), h))
		)
	else
		button:SetPoint("CENTER", Minimap, "CENTER",
			m_cos(angle) * w,
			m_sin(angle) * h
		)
	end
end

local function minimap_UpdateConfig(self)
	self._config = E:CopyTable(C.modules.minimap, self._config)
	self._config.buttons = E:CopyTable(C.modules.minimap.buttons, self._config.buttons)
	self._config.collect = E:CopyTable(C.modules.minimap.collect, self._config.collect)
	self._config.color = E:CopyTable(C.modules.minimap.color, self._config.color)
	self._config.size = C.modules.minimap.size
end

local function minimap_UpdateSize(self)
	Minimap:SetSize(cfg.size, cfg.size)
	LumMinimapHolder:SetSize(cfg.size, cfg.size + 20)
end

function M:IsInit()
	return isInit
end

function M:Init()
	if not isInit and cfg.enabled then
		if not IsAddOnLoaded("Blizzard_TimeManager") then
			LoadAddOn("Blizzard_TimeManager")
		end

		isSquare = C.modules.minimap.square

		local level = Minimap:GetFrameLevel()
		local holder = CreateFrame("Frame", "LumMinimapHolder", UIParent)
		holder:SetSize(1, 1)
		holder:SetPoint(unpack(cfg.point))

		Minimap:EnableMouseWheel()
		Minimap:ClearAllPoints()
		Minimap:SetParent(holder)

		Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
		Minimap:SetPoint("BOTTOM", 0, 0)

		Minimap:RegisterEvent("ZONE_CHANGED")
		Minimap:RegisterEvent("ZONE_CHANGED_INDOORS")
		Minimap:RegisterEvent("ZONE_CHANGED_NEW_AREA")

		Minimap:HookScript("OnEvent", function(self, event)
			if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
				-- print(event)
			end
		end)

		RegisterStateDriver(Minimap, "visibility", "[petbattle] hide; show")

		local textureParent = CreateFrame("Frame", nil, Minimap)
		textureParent:SetFrameLevel(level + 1)
		textureParent:SetPoint("BOTTOMRIGHT", 0, 0)
		Minimap.TextureParent = textureParent

		if isSquare then
			Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
			Minimap:SetPoint("BOTTOM", 0, 0)

			textureParent:SetPoint("TOPLEFT", 0, 0)

			local border = E:CreateBorder(textureParent)
			border:SetTexture(C.media.textures.border)
			border:SetVertexColor(E:GetRGB(C.global.border.color))
			border:SetOffset(-5)
			Minimap.Border = border

			E:SetBackdrop(textureParent, 2)
			E:CreateShadow(Minimap)
		else
			Minimap:SetMaskTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
			Minimap:SetPoint("BOTTOM", 0, 10)

			textureParent:SetPoint("TOPLEFT", 0, 0)
		end

		Minimap.UpdateConfig = minimap_UpdateConfig
		Minimap.UpdateSize = minimap_UpdateSize

		isInit = true

		self:Update()
	end
end

function M:Update()
	if isInit then
		Minimap:UpdateConfig()
		Minimap:UpdateSize()
	end
end
