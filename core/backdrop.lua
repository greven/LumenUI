local _, ns = ...
local E, C = ns.E, ns.C

-- Lua
local _G = getfenv(0)

-- ---------------

function E:CreateBackdrop(frame, offset, alpha)
    if frame._backdrop then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    local level = frame:GetFrameLevel()
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetFrameLevel(level == 0 and 0 or level - 1)
    backdrop:SetOutside(frame, offset, offset)
    backdrop:SetBackdrop({
        bgFile = C.media.textures.flat,
        tile = false
    })
    if alpha then
        backdrop:SetBackdropColor(0, 0, 0, alpha)
    else
        backdrop:SetBackdropColor(E:GetRGBA(C.global.backdrop.color, C.global.backdrop.alpha))
    end

    frame._backdrop = backdrop
    return backdrop
end

function E:SetBackdrop(frame, offset, alpha, x1, y1, x2, y2)
    local bg = E:CreateBackdrop(frame, offset, alpha)

    if x1 then
        bg:SetPoint("TOPLEFT", frame, x1, y1)
        bg:SetPoint("BOTTOMRIGHT", frame, x2, y2)
    end
    return bg
end

function E:CreateShadow(frame, size, alpha)
    if frame._shadow then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    local shadowBackdrop = {
        edgeFile = C.media.textures.glow
    }
    shadowBackdrop.edgeSize = size or 6

    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetOutside(frame, size or 6, size or 6)
    shadow:SetBackdrop(shadowBackdrop)
    shadow:SetBackdropBorderColor(0, 0, 0, alpha or C.global.shadows.alpha)
    shadow:SetFrameLevel(1)

    frame._shadow = shadow
    return shadow
end

function E:CreateGlow(frame, size, drawLayer, drawSubLevel, offset)
    if frame._glow then
        return
    end

    local glow = E:CreateBorder(frame._backdrop or frame, drawLayer or "BACKGROUND", drawSubLevel or -7)
    glow:SetTexture(C.media.textures.glow)
    glow:SetOffset(offset or -4)
    glow:SetSize(size or 12)

    frame._glow = glow
    return glow
end
