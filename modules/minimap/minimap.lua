-- Credits: ls_UI

local _, ns = ...
local E, C = ns.E, ns.C

local M = E:AddModule("Minimap")

local isInit = false

local cfg = C.modules.minimap

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local select = _G.select

local s_match = _G.string.match

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

		local level = Minimap:GetFrameLevel()
		local holder = CreateFrame("Frame", "LumMinimapHolder", UIParent)
		holder:SetSize(1, 1)
		holder:SetPoint(unpack(cfg.pos))

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

		Minimap.UpdateSize = minimap_UpdateSize

		isInit = true

		self:Update()
	end
end

function M:Update()
	if isInit then
		Minimap:UpdateSize()
	end
end
