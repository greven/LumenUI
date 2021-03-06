local _, ns = ...
local E, C, D, L, M, P = ns.E, ns.C, ns.D, ns.L, ns.M, ns.P

-- Lua
local _G = getfenv(0)

-- Blizz
local CreateFrame = _G.CreateFrame

-- ---------------

function E:SetBackdrop(frame, offset, alpha, color, backdrop)
    if frame._backdrop then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    local level = frame:GetFrameLevel()
    local bg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    bg:SetFrameLevel(level == 0 and 0 or level - 1)
    bg:SetOutside(frame, offset, offset)

    if backdrop then
        bg:SetBackdrop(backdrop)
        if color then
            bg:SetBackdropColor(E:GetRGB(color))
        end
    else
        bg:SetBackdrop({bgFile = C.db.global.backdrop.texture, tile = false})
        if color then
            bg:SetBackdropColor(E:GetRGB(color))
        else
            bg:SetBackdropColor(E:GetRGBA(C.db.global.backdrop.color))
        end
    end

    bg:SetAlpha(alpha or C.db.global.backdrop.alpha)

    frame._backdrop = bg

    return bg
end

function E:HandleBackdrop(self, offset, alpha, color, backdrop)
    if self.handled then
        return
    end

    if self.SetBackdrop then
        self:SetBackdrop(nil)
    end
    self:DisableDrawLayer("BACKGROUND")

    self.bg = E:SetBackdrop(self, offset, alpha, color, backdrop)
    self.bg:SetFrameLevel(self:GetFrameLevel())
    self.bg:SetInside(self)

    self.handled = true

    return bg
end

function E:CreateShadow(frame, size, alpha)
    if frame._shadow then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    local shadowBackdrop = {edgeFile = M.textures.glow}
    shadowBackdrop.edgeSize = size or 6

    local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    shadow:SetOutside(frame, size or 6, size or 6)
    shadow:SetBackdrop(shadowBackdrop)
    shadow:SetBackdropBorderColor(0, 0, 0, alpha or C.db.global.shadows.alpha)
    shadow:SetFrameLevel(1)

    frame._shadow = shadow
    return shadow
end

function E:CreateGlow(frame, size, drawLayer, drawSubLevel, offset)
    if frame._glow then
        return
    end

    local glow = E:CreateBorder(frame._backdrop or frame, drawLayer or "BACKGROUND", drawSubLevel or -7)
    glow:SetTexture(M.textures.glow)
    glow:SetOffset(offset or -4)
    glow:SetSize(size or 12)

    frame._glow = glow
    return glow
end
