local _, ns = ...
local E, C, L = ns.E, ns.C, ns.L

-- Lua
local _G = getfenv(0)

-- ---------------

function E:CreateBackdrop(frame, offset, alpha, color, backdrop)
    if frame._backdrop then return end

    if frame:GetObjectType() == "Texture" then frame = frame:GetParent() end

    local level = frame:GetFrameLevel()
    local bg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    bg:SetFrameLevel(level == 0 and 0 or level - 1)
    bg:SetOutside(frame, offset, offset)
    bg:SetBackdrop({bgFile = C.media.textures.flat, tile = false})
    bg:SetBackdropColor(E:GetRGBA(C.global.backdrop.color))
    bg:SetAlpha(alpha or C.global.backdrop.alpha)

    if backdrop then bg:SetBackdrop(backdrop) end
    if color then bg:SetBackdropColor(E:GetRGB(color)) end

    frame._backdrop = bg

    return bg
end

function E:SetBackdrop(frame, offset, alpha, color, backdrop, x1, y1, x2, y2)
    local bg = E:CreateBackdrop(frame, offset, alpha, color, backdrop)

    if x1 then
        bg:SetPoint("TOPLEFT", frame, x1, y1)
        bg:SetPoint("BOTTOMRIGHT", frame, x2, y2)
    end

    return bg
end

function E:HandleBackdrop(self, offset, alpha, color, backdrop, x1, y1, x2, y2)
    if self.handled then return end

    if self.SetBackdrop then self:SetBackdrop(nil) end
    self:DisableDrawLayer("BACKGROUND")

    self.bg =
        E:SetBackdrop(self, offset, alpha, color, backdrop, x1, y1, x2, y2)
    self.bg:SetInside(self)
    self.bg:SetFrameLevel(self:GetFrameLevel())

    self.handled = true

    return bg
end

function E:CreateShadow(frame, size, alpha)
    if frame._shadow then return end

    if frame:GetObjectType() == "Texture" then frame = frame:GetParent() end

    local shadowBackdrop = {edgeFile = C.media.textures.glow}
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
    if frame._glow then return end

    local glow = E:CreateBorder(frame._backdrop or frame,
                                drawLayer or "BACKGROUND", drawSubLevel or -7)
    glow:SetTexture(C.media.textures.glow)
    glow:SetOffset(offset or -4)
    glow:SetSize(size or 12)

    frame._glow = glow
    return glow
end
