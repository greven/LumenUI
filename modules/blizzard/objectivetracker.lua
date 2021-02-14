local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

local M = E:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)

-- Blizz
local IsAltKeyDown = _G.IsAltKeyDown
local IsControlKeyDown = _G.IsControlKeyDown
local IsShiftKeyDown = _G.IsShiftKeyDown

-- ---------------

local isInit = false

function M.HasObjectiveTracker()
    return isInit
end

function M.SetUpObjectiveTracker()
    if not isInit and C.profile.modules.blizzard.objective_tracker.enabled then
        local holder = CreateFrame("Frame", "LumOTFrameHolder", UIParent)
        holder:SetFrameStrata("LOW")
        holder:SetFrameLevel(ObjectiveTrackerFrame:GetFrameLevel() + 1)
        holder:SetSize(199, 25)
        holder:SetPoint(unpack(C.profile.modules.blizzard.objective_tracker.point))

        ObjectiveTrackerFrame:SetMovable(true)
        ObjectiveTrackerFrame:SetUserPlaced(true)
        ObjectiveTrackerFrame:SetParent(holder)
        ObjectiveTrackerFrame:ClearAllPoints()
        ObjectiveTrackerFrame:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 47, 0)
        ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:HookScript(
            "OnClick",
            function()
                if ObjectiveTrackerFrame.collapsed then
                    ObjectiveTrackerFrame:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 26, 0)
                else
                    ObjectiveTrackerFrame:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 47, 0)
                end
            end
        )

        isInit = true
    end
end

function M.UpdateObjectiveTracker()
    if isInit then
        ObjectiveTrackerFrame:SetHeight(C.profile.modules.blizzard.objective_tracker.height)
    end
end
