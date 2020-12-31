local _, ns = ...
local E, C, oUF = ns.E, ns.C, ns.oUF

-- Lua
local _G = getfenv(0)

local next = _G.next

-- ---------------

local UF = E:GetModule("UnitFrames")

function UF:UpdateReactionColors()
	local color = oUF.colors.reaction
	for k, v in next, C.colors.reaction do
		color[k][1], color[k][2], color[k][3] = E:GetRGB(v)
	end
end
