local _, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

-- Lua
local _G = getfenv(0)

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")

local function WatchPixelSnap(frame, snap)
    if (frame and not frame:IsForbidden()) and frame.PixelSnapDisabled and snap then
        frame.PixelSnapDisabled = nil
    end
end

local function DisablePixelSnap(frame)
    if (frame and not frame:IsForbidden()) and not frame.PixelSnapDisabled then
        if frame.SetSnapToPixelGrid then
            frame:SetSnapToPixelGrid(false)
            frame:SetTexelSnappingBias(0)
        elseif frame.GetStatusBarTexture then
            local texture = frame:GetStatusBarTexture()
            if texture and texture.SetSnapToPixelGrid then
                texture:SetSnapToPixelGrid(false)
                texture:SetTexelSnappingBias(0)
            end
        end

        frame.PixelSnapDisabled = true
    end
end

local function SetInside(frame, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or E.SCREEN_SCALE
    yOffset = yOffset or E.SCREEN_SCALE
    anchor = anchor or frame:GetParent()

    DisablePixelSnap(frame)
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
    frame:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

local function SetOutside(frame, anchor, xOffset, yOffset, anchor2)
    xOffset = xOffset or E.SCREEN_SCALE
    yOffset = yOffset or E.SCREEN_SCALE
    anchor = anchor or frame:GetParent()

    DisablePixelSnap(frame)
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
    frame:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function addapi(object)
    local mt = getmetatable(object).__index
    if not object.SetInside then
        mt.SetInside = SetInside
    end
    if not object.SetOutside then
        mt.SetOutside = SetOutside
    end
    if not object.DisabledPixelSnap then
        if mt.SetTexture then
            hooksecurefunc(mt, "SetTexture", DisablePixelSnap)
        end
        if mt.SetTexCoord then
            hooksecurefunc(mt, "SetTexCoord", DisablePixelSnap)
        end
        if mt.CreateTexture then
            hooksecurefunc(mt, "CreateTexture", DisablePixelSnap)
        end
        if mt.SetVertexColor then
            hooksecurefunc(mt, "SetVertexColor", DisablePixelSnap)
        end
        if mt.SetColorTexture then
            hooksecurefunc(mt, "SetColorTexture", DisablePixelSnap)
        end
        if mt.SetSnapToPixelGrid then
            hooksecurefunc(mt, "SetSnapToPixelGrid", WatchPixelSnap)
        end
        if mt.SetStatusBarTexture then
            hooksecurefunc(mt, "SetStatusBarTexture", DisablePixelSnap)
        end
        mt.DisabledPixelSnap = true
    end
end

addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateMaskTexture())

object = EnumerateFrames()
while object do
    if not object:IsForbidden() and not handled[object:GetObjectType()] then
        addapi(object)
        handled[object:GetObjectType()] = true
    end

    object = EnumerateFrames(object)
end
