local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

--Lua
local _G = getfenv(0)

local UnitHealthMax = _G.UnitHealthMax
local UnitStagger = _G.UnitStagger

-- ---------------

local UF = E:GetModule("UnitFrames")

-- ---------------

local function bar_OnValueChanged(self, value)
	local _, max = self:GetMinMaxValues()

	if value == max then
		if not self._active then
			if not self.InAnim:IsPlaying() then
				self.InAnim:Play()
			end

			self:SetAlpha(1)

			self._active = true
		end
	else
		self.InAnim:Stop()

		if self._active then
			self:SetAlpha(0.65)

			self._active = false
		end
	end
end

local function createElement(parent, num, name)
	local element = CreateFrame("Frame", nil, parent)
	local level = element:GetFrameLevel()

	for i = 1, num do
		local bar = CreateFrame("StatusBar", "$parent" .. name .. i, element)
		bar:SetFrameLevel(level)
		bar:SetStatusBarTexture(M.textures.flat)
    bar:SetScript("OnValueChanged", bar_OnValueChanged)
    E.SetBackdrop(bar, 2)
    E.CreateShadow(bar)
		element[i] = bar

		local hl = element:CreateTexture(nil, "BACKGROUND", nil, -8)
		hl:SetAllPoints(bar)
		hl:SetColorTexture(0, 0, 0, 0)
		bar.Highlight = hl

		local glow = bar:CreateTexture(nil, "ARTWORK", nil, 7)
		glow:SetAllPoints()
		glow:SetColorTexture(1, 1, 1)
		glow:SetAlpha(0)
		bar.Glow = glow

		local ag = glow:CreateAnimationGroup()
		bar.InAnim = ag

		local anim = ag:CreateAnimation("Alpha")
		anim:SetOrder(1)
		anim:SetDuration(0.25)
		anim:SetFromAlpha(0)
		anim:SetToAlpha(1)
		anim:SetSmoothing("OUT")

		anim = ag:CreateAnimation("Alpha")
		anim:SetOrder(2)
		anim:SetDuration(0.25)
		anim:SetFromAlpha(1)
		anim:SetToAlpha(0)
		anim:SetSmoothing("IN")
	end

	return element
end

-- ClassPower
do
  local ignoredKeys = {
		prediction = true,
		runes = true,
  }

  local function element_PostUpdate(self, _, max, maxChanged, powerType, chargedIdx)
		if self._active ~= self.__isEnabled or self._powerID ~= powerType or maxChanged then
			if not self.__isEnabled then
				self:Hide()
			else
				self:Show()

				local orientation = self[1]:GetOrientation()
				local layout

				if orientation == "HORIZONTAL" then
					layout = E:CalcSegmentsSizes(self:GetWidth(), self._config.gap or 2, max)
				else
					layout = E:CalcSegmentsSizes(self:GetHeight(), self._config.gap or 2, max)
				end

				for i = 1, max do
					if orientation == "HORIZONTAL" then
						self[i]:SetWidth(layout[i])
					else
						self[i]:SetHeight(layout[i])
					end

					if i == chargedIdx then
						self[i]:SetStatusBarColor(E:GetRGB(C.colors.power.CHI))
						self[i].Highlight:SetColorTexture(E:GetRGBA(C.colors.power.CHI, 0.4))
					else
						self[i]:SetStatusBarColor(E:GetRGB(C.colors.power[powerType]))
						self[i].Highlight:SetColorTexture(0, 0, 0, 0)
					end
				end
			end

			self._active = self.__isEnabled
			self._chargedIdx = chargedIdx
			self._powerID = powerType
		elseif self._active and self._chargedIdx ~= chargedIdx then
			for i = 1, max do
				if i == chargedIdx then
					self[i]:SetStatusBarColor(E:GetRGB(C.colors.power.CHI))
					self[i].Highlight:SetColorTexture(E:GetRGBA(C.colors.power.CHI, 0.4))
				else
					self[i]:SetStatusBarColor(E:GetRGB(C.colors.power[powerType]))
					self[i].Highlight:SetColorTexture(0, 0, 0, 0)
				end
			end

			self._chargedIdx = chargedIdx
		end
  end

  local function element_UpdateConfig(self)
    local unit = self.__owner._unit
    self._config = E:CopyTable(C.modules.unitframes.units[unit].class_power, self._config, ignoredKeys)
  end

  local function element_UpdateSize(self)
    local frame = self.__owner
    local config = self._config
    local width = config.width
    local height = config.height

    self:SetSize(width, height)

    local point = config.point
    if point and point.p then
      self:ClearAllPoints()
      self:SetPoint(point.p, E:ResolveAnchorPoint(frame, point.anchor), point.ap, point.x, point.y)
    end
  end

	local function element_UpdateColors(self)
		if self._powerID then
			for i = 1, 10 do
				self[i]:SetStatusBarColor(E:GetRGB(C.colors.power[self._powerID]))
			end
		end
  end

  local function frame_UpdateClassPower(self)
		local element = self.ClassPower
    element:UpdateConfig()
    element:UpdateSize()

		local orientation = element._config.orientation
		local max = element.__max
		local layout

		if max then
			if orientation == "HORIZONTAL" then
				layout = E:CalcSegmentsSizes(element:GetWidth(), element._config.gap or 2, max)
			else
				layout = E:CalcSegmentsSizes(element:GetHeight(), element._config.gap or 2, max)
			end
		end

		for i = 1, 10 do
			local bar = element[i]
			bar:SetOrientation(orientation)
			bar:ClearAllPoints()

			if orientation == "HORIZONTAL" then
				if layout and i <= max then
					bar:SetWidth(layout[i])
				end

				bar:SetPoint("TOP", 0, 0)
				bar:SetPoint("BOTTOM", 0, 0)

				if i == 1 then
					bar:SetPoint("LEFT", 0, 0)
				else
					bar:SetPoint("LEFT", element[i - 1], "RIGHT", element._config.gap, 0)
				end
			else
				if layout and i <= max then
					bar:SetHeight(layout[i])
				end

				bar:SetPoint("LEFT", 0, 0)
				bar:SetPoint("RIGHT", 0, 0)

				if i == 1 then
					bar:SetPoint("BOTTOM", 0, 0)
				else
					bar:SetPoint("BOTTOM", element[i - 1], "TOP", 0, element._config.gap)
				end
			end
		end

		element:UpdateColors()

		if element._config.enabled and not self:IsElementEnabled("ClassPower") then
			self:EnableElement("ClassPower")
		elseif not element._config.enabled and self:IsElementEnabled("ClassPower") then
			self:DisableElement("ClassPower")
		end

		if self:IsElementEnabled("ClassPower") then
			element:ForceUpdate()
		else
			element._active = nil
			element._powerID = nil

			element:Hide()
		end
  end

	function UF:CreateClassPower(frame)
		local element = createElement(frame, 10, "ClassPower")
		element:Hide()

		element.PostUpdate = element_PostUpdate
		element.UpdateColors = element_UpdateColors
		element.UpdateConfig = element_UpdateConfig
		element.UpdateSize = element_UpdateSize

    frame.UpdateClassPower = frame_UpdateClassPower
    frame.ClassPower = element

		return element
	end
end
