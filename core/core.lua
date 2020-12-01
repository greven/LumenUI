-- Credits: ls_UI

local A, ns = ...

local E = {}  -- Engine
local D = {}  -- Defaults
local C = {}  -- Config
local M = {}  -- Media
local DB = {} -- Database

local E, D, C, M, DB = {}, {}, {}, {}, {} -- Engine, Defaults, Config, Media, Database
ns.E, ns.D, ns.C, ns.M, ns.DB = E, D, C, M, DB

_G[A] = {
	[1] = ns.E,
	[2] = ns.D,
	[3] = ns.C,
	[4] = ns.M,
	[5] = ns.DB
}

-- Lua
local _G = getfenv(0)

local assert = _G.assert
local next = _G.next
local pairs = _G.pairs
local geterrorhandler = _G.geterrorhandler
local xpcall = _G.xpcall

local s_format = _G.string.format

-- ---------------

local function errorHandler(err)
  return geterrorhandler()(err)
end

function E:Call(func, ...)
  return xpcall(func, errorHandler, ...)
end

-- ---------------
-- > Modules
-- ---------------

do
  local modules = {}

  function E:AddModule(name)
    modules[name] = {}
    return modules[name]
  end

  function E:GetModule(name)
		return modules[name]
  end

  function E:InitModules()
		for _, module in next, modules do
			E:Call(module.Init, module)
		end
	end

  function E:UpdateModules()
    for _, module in next, modules do
      if module.Update then
        E:Call(module.Update, module)
      end
    end
  end
end

-- ---------------
-- > Events
-- ---------------

do
  local oneTimeEvents = {ADDON_LOADED = false, PLAYER_LOGIN = false}
  local registeredEvents = {}

  local dispatcher = CreateFrame("Frame")
  dispatcher:SetScript("OnEvent", function(_, event, ...)
		for func in pairs(registeredEvents[event]) do
			func(...)
		end

		if oneTimeEvents[event] == false then
			oneTimeEvents[event] = true
		end
  end)

  function E:RegisterEvent(event, func)
		assert(not oneTimeEvents[event], s_format("Failed to register for '%s' event, already fired!", event))

		if not registeredEvents[event] then
			registeredEvents[event] = {}

			dispatcher:RegisterEvent(event)
		end

		registeredEvents[event][func] = true
	end

	function E:UnregisterEvent(event, func)
		local funcs = registeredEvents[event]

		if funcs and funcs[func] then
			funcs[func] = nil

			if not next(funcs) then
				registeredEvents[event] = nil

				dispatcher:UnregisterEvent(event)
			end
		end
	end
end
