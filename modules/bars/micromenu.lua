local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Bars")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next
local select = _G.select
local t_insert = _G.table.insert
local t_sort = _G.table.sort
local t_wipe = _G.table.wipe
local unpack = _G.unpack

-- Blizz
local C_CurrencyInfo = _G.C_CurrencyInfo
local C_Timer = _G.C_Timer
local Kiosk = _G.Kiosk

-- ---------------

local isInit = false

function M:CreateMicroMenu()
    if not isInit then
        local bar1 = CreateFrame("Frame", "LumMicroMenu1", UIParent)
        bar1._id = "micromenu1"
        bar1._buttons = {}

        M:AddBar(bar1._id, bar1)

        bar1.Update = bar_Update
        bar1.UpdateButtonList = bar_UpdateButtonList
        bar1.UpdateConfig = bar_UpdateConfig
        bar1.UpdateCooldownConfig = nil

        local bar2 = CreateFrame("Frame", "LumMicroMenu2", UIParent)
        bar2._id = "micromenu2"
        bar2._buttons = {}

        M:AddBar(bar2._id, bar2)

        bar2.Update = bar_Update
        bar2.UpdateButtonList = bar_UpdateButtonList
        bar2.UpdateConfig = bar_UpdateConfig
        bar2.UpdateCooldownConfig = nil

        self:UpdateMicroMenu()

        isInit = true
    end
end

function M:UpdateMicroMenu()
    -- Update
end
