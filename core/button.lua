-- Credits: ls_UI

local A, ns = ...
local E, C, M = ns.E, ns.C, ns.M

-- Lua
local _G = getfenv(0)

-- ---------------

local function setPushedTexture(button)
	if not button.SetPushedTexture then return end

	button:SetPushedTexture("Interface\\Buttons\\ButtonHilight-Square")
	button:GetPushedTexture():SetBlendMode("ADD")
	button:GetPushedTexture():SetDesaturated(true)
	button:GetPushedTexture():SetVertexColor(E:GetRGB(C.colors.yellow))
	button:GetPushedTexture():SetAllPoints()
end

local function setHighlightTexture(button)
	if not button.SetHighlightTexture then return end

	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	button:GetHighlightTexture():SetAllPoints()
end

local function setCheckedTexture(button)
	if not button.SetCheckedTexture then return end

	button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
	button:GetCheckedTexture():SetBlendMode("ADD")
	button:GetCheckedTexture():SetAllPoints()
end

local function setIcon(button, texture, l, r, t, b)
	local icon

	if button.CreateTexture then
		icon = button:CreateTexture(nil, "BACKGROUND", nil, 0)
	else
		icon = button
		icon:SetDrawLayer("BACKGROUND", 0)
	end

	icon:SetAllPoints()
	icon:SetTexCoord(l or 0.0625, r or 0.9375, t or 0.0625, b or 0.9375)

	if texture then
		icon:SetTexture(texture)
	end

	return icon
end

function E:CreateButton(parent, name, hasCount, hasCooldown, isSandwich, isSecure)
	local button = CreateFrame("Button", name, parent, isSecure and "SecureActionButtonTemplate")
	button:SetSize(28, 28)

	button.Icon = setIcon(button)

	local border = E:CreateBorder(button)
	border:SetSize(16)
	border:SetOffset(-4)
	button.Border = border

	setHighlightTexture(button)
	setPushedTexture(button)

	if hasCount then
		local count = button:CreateFontString(nil, "ARTWORK", "NumberFontNormal")
		count:SetJustifyH("RIGHT")
		count:SetPoint("TOPRIGHT", 2, 0)
		count:SetWordWrap(false)
		button.Count = count
	end

	if hasCooldown then
		button.CD = E.Cooldowns.Create(button)
	end

	if isSandwich then
		local fgParent = CreateFrame("Frame", nil, button)
		fgParent:SetFrameLevel(button:GetFrameLevel() + 2)
		fgParent:SetAllPoints()
		button.FGParent = fgParent

		if hasCount then
			button.Count:SetParent(fgParent)
		end
	end

	return button
end
