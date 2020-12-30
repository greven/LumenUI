local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- Fontstring
function E:CreateString(text, size, color, anchor, x, y)
  local fs = self:CreateFontString(nil, "OVERLAY")
  fs:SetFont(M.fonts.main, size, "THINOUTLINE")
  fs:SetText(text)
  fs:SetWordWrap(false)

  if color and type(color) == "boolean" then
    fs:SetTextColor(unpack(E.CLASS_COLOR))
  else
    fs:SetTextColor(unpack(C.colors.text))
  end

  if anchor and x and y then
    fs:SetPoint(anchor, x, y)
  else
    fs:SetPoint("CENTER", 1, 0)
  end

  return fs
end

function E:CreateBackdrop(offset, alpha)
  local frame = self
  if self:GetObjectType() == "Texture" then frame = self:GetParent() end

  if not frame._backdrop then
    local lvl = frame:GetFrameLevel()
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
    backdrop:SetOutside(frame, offset, offset)
    backdrop:SetBackdrop({bgFile = M.textures.backdrop, tile = false})
    if alpha then
      backdrop:SetBackdropColor(0, 0, 0, alpha)
    else
      backdrop:SetBackdropColor(unpack(C.colors.backdrop))
    end

    frame._backdrop = backdrop
    return backdrop
  end
end

function E:CreateBorder(parent, drawLayer, drawLevel)
end

-- Backdrop shadow
function E:CreateShadow(size, override)
  if not override and not C.theme.shadows then return end
  if self._shadow then return end

  local frame = self
  if self:GetObjectType() == "Texture" then frame = self:GetParent() end

  local shadowBackdrop = {edgeFile = M.textures.glow}
  shadowBackdrop.edgeSize = size or 5
  self._shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  self._shadow:SetOutside(self, size or 4, size or 4)
  self._shadow:SetBackdrop(shadowBackdrop)
  self._shadow:SetBackdropBorderColor(0, 0, 0, size and 1 or .4)
  self._shadow:SetFrameLevel(1)

	return self._shadow
end

-- Glow parent
function E:CreateGlow(size)
  local frame = CreateFrame("Frame", nil, self)
  frame:SetPoint("CENTER")
  frame:SetSize(size+8, size+8)
  return frame
end

function E:SetBackdrop(offset, alpha, x1, y1, x2, y2)
  local bg = E.CreateBackdrop(self, offset, alpha)
  if x1 then
    bg:SetPoint("TOPLEFT", self, x1, y1)
		bg:SetPoint("BOTTOMRIGHT", self, x2, y2)
  end
  return bg
end

-- Add API (Credits: NDui)
do
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
		if not object.SetInside then mt.SetInside = SetInside end
    if not object.SetOutside then mt.SetOutside = SetOutside end
		if not object.DisabledPixelSnap then
			if mt.SetTexture then hooksecurefunc(mt, "SetTexture", DisablePixelSnap) end
			if mt.SetTexCoord then hooksecurefunc(mt, "SetTexCoord", DisablePixelSnap) end
			if mt.CreateTexture then hooksecurefunc(mt, "CreateTexture", DisablePixelSnap) end
			if mt.SetVertexColor then hooksecurefunc(mt, "SetVertexColor", DisablePixelSnap) end
			if mt.SetColorTexture then hooksecurefunc(mt, "SetColorTexture", DisablePixelSnap) end
			if mt.SetSnapToPixelGrid then hooksecurefunc(mt, "SetSnapToPixelGrid", WatchPixelSnap) end
			if mt.SetStatusBarTexture then hooksecurefunc(mt, "SetStatusBarTexture", DisablePixelSnap) end
			mt.DisabledPixelSnap = true
		end
  end

  local handled = {["Frame"] = true}
	local object = CreateFrame("Frame")
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
end
