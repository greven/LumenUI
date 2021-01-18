local _, ns = ...
local E, C = ns.E, ns.C

local M = E:AddModule("Misc")

local isInit = false

local cfg = C.modules.misc

-- Lua
local _G = getfenv(0)

-- ---------------

function M:IsInit()
	return isInit
end

function M:Init()
	if not isInit and C.modules.misc.enabled then
		self:SetUpBindings()

		isInit = true
	end
end

function M:Update()
	if isInit then
		-- Update
	end
end

