local _, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

-- Lua
local _G = getfenv(0)

-- These rely on custom strings
L["LATENCY_COLON"] = L["LATENCY"] .. ":"
L["MEMORY_COLON"] = L["MEMORY"] .. ":"
