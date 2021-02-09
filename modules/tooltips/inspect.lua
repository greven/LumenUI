local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Tooltips")

local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next
local s_format = _G.string.format
local s_upper = _G.string.upper
local type = _G.type

-- Blizz
local C_Timer = _G.C_Timer
local GetTime = _G.GetTime
local CanInspect = _G.CanInspect
local NotifyInspect = _G.NotifyInspect
local UnitExists = _G.UnitExists
local UnitGUID = _G.UnitGUID

-- ---------------

local ITEM_LEVEL = "|cffffd100" .. _G.ITEM_LEVEL_ABBR .. ":|r |cffffffff%s|r"
local SPECIALIZATION = "|cffffd100" .. _G.SPECIALIZATION .. ":|r |cffffffff%s|r"

local inspectGUIDCache = {}
local lastGUID

local function INSPECT_READY(unitGUID)
    if UnitExists("mouseover") and UnitGUID("mouseover") == unitGUID then
        if not inspectGUIDCache[unitGUID] then
            inspectGUIDCache[unitGUID] = {}
        end

        inspectGUIDCache[unitGUID].time = GetTime()
        inspectGUIDCache[unitGUID].specName = E:GetUnitSpecializationInfo("mouseover")
        inspectGUIDCache[unitGUID].itemLevel = E:GetUnitAverageItemLevel("mouseover")

        GameTooltip:SetUnit("mouseover")
    end

    E:UnregisterEvent("INSPECT_READY", INSPECT_READY)
end

function M:AddInspectInfo(tooltip, unit, numTries)
    if not CanInspect(unit, true) or numTries > 3 then
        return
    end

    local unitGUID = UnitGUID(unit)
    if unitGUID == E.PLAYER_GUID then
        tooltip:AddLine(SPECIALIZATION:format(E:GetUnitSpecializationInfo(unit)), 1, 1, 1)
        tooltip:AddLine(ITEM_LEVEL:format(E:GetUnitAverageItemLevel(unit)), 1, 1, 1)
    elseif inspectGUIDCache[unitGUID] and inspectGUIDCache[unitGUID].time then
        if
            not (inspectGUIDCache[unitGUID].specName and inspectGUIDCache[unitGUID].itemLevel) or
                GetTime() - inspectGUIDCache[unitGUID].time > 120
         then
            inspectGUIDCache[unitGUID].time = nil
            inspectGUIDCache[unitGUID].specName = nil
            inspectGUIDCache[unitGUID].itemLevel = nil

            return C_Timer.After(
                0.33,
                function()
                    M.AddInspectInfo(tooltip, unit, numTries + 1)
                end
            )
        end

        tooltip:AddLine(SPECIALIZATION:format(inspectGUIDCache[unitGUID].specName), 1, 1, 1)
        tooltip:AddLine(ITEM_LEVEL:format(inspectGUIDCache[unitGUID].itemLevel), 1, 1, 1)
    else
        if lastGUID ~= unitGUID then
            lastGUID = unitGUID

            NotifyInspect(unit)
            E:RegisterEvent("INSPECT_READY", INSPECT_READY)
        else
            lastGUID = nil

            INSPECT_READY(unitGUID)
        end
    end
end
