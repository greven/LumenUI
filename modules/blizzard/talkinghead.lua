local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BLIZZARD = P:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next
local t_remove = _G.table.remove

-- ---------------

local isInit = false

local function closeTalkingHead()
    if C.db.profile.blizzard.talking_head.hide then
        TalkingHeadFrame_CloseImmediately()
    end
end

function BLIZZARD.HasTalkingHead()
    return isInit
end

function BLIZZARD.SetUpTalkingHead()
    if not isInit and C.db.profile.blizzard.talking_head.enabled then
        local isLoaded = true

        if not IsAddOnLoaded("Blizzard_TalkingHeadUI") then
            isLoaded = LoadAddOn("Blizzard_TalkingHeadUI")
        end

        if isLoaded then
            TalkingHeadFrame.ignoreFramePositionManager = true
            UIPARENT_MANAGED_FRAME_POSITIONS["TalkingHeadFrame"] = nil

            for i, subSystem in next, AlertFrame.alertFrameSubSystems do
                if subSystem.anchorFrame and subSystem.anchorFrame == TalkingHeadFrame then
                    t_remove(AlertFrame.alertFrameSubSystems, i)
                end
            end

            TalkingHeadFrame:ClearAllPoints()
            TalkingHeadFrame:SetPoint("TOP", "UIParent", "TOP", 0, -200)
            -- E.Movers:Create(TalkingHeadFrame)

            hooksecurefunc("TalkingHeadFrame_PlayCurrent", closeTalkingHead)

            isInit = true
        end
    end
end
