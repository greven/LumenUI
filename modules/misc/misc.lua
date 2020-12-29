local _, ns = ...
local E, C = ns.E, ns.C

local M = E:AddModule("Misc")

local isInit = false

local cfg = C.modules.misc

-- Lua
local _G = getfenv(0)

-- ---------------

local MISC_LIST = {}
function M:RegisterMisc(name, func)
	if not MISC_LIST[name] then
		MISC_LIST[name] = func
	end
end

function M:IsInit()
	return isInit
end

function M:Init()
	if not isInit then
		for name, func in next, MISC_LIST do
			if name and type(func) == "function" then
				func()
			end
		end

		isInit = true
	end
end

