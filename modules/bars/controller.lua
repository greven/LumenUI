-- Credits: ls_UI
local _, ns = ...
local E, C, L, M, P = ns.E, ns.C, ns.L, ns.M, ns.P

local BARS = P:GetModule("Bars")

-- Lua
local _G = getfenv(0)
local next = _G.next
local unpack = _G.unpack

-- Blizz
local CreateFrame = _G.CreateFrame
local C_Timer = _G.C_Timer

-- ---------------

local isInit = false
local barController

local WIDGETS = {
    ACTION_BAR = {
        frame_level_offset = 2,
        point = {"BOTTOM", "LumActionBarControllerBottom", "BOTTOM", 0, 15},
        children = {
            "LumActionBar2",
            "LumActionBar3",
            "LumActionBar4",
            "LumActionBar5",
            "LumPetBar",
            "LumStanceBar"
        },
        attributes = {
            ["_childupdate-numbuttons"] = [[
				self:Hide()
				self:SetWidth(36 * message)
				self:Show()

				for i = 7, 12 do
					if message == 6 then
						buttons[i]:SetAttribute("statehidden", true)
						buttons[i]:Hide()
					else
						buttons[i]:SetAttribute("statehidden", nil)
						buttons[i]:Show()
					end
				end
			]]
        }
    },
    PET_BATTLE_BAR = {
        frame_level_offset = 2,
        point = {"BOTTOM", "LumActionBarControllerBottom", "BOTTOM", 0, 15}
    },
    XP_BAR = {
        frame_level_offset = 3,
        point = {"BOTTOM", "LumActionBarControllerBottom", "BOTTOM", 0, 0},
        on_play = function(frame, newstate)
            frame:UpdateSize(newstate == 6 and 756 / 2 or 1188 / 2, 12)
        end
    }
}

function BARS.ActionBarController_AddWidget(_, frame, slot)
    if isInit then
        local widget = WIDGETS[slot]
        if widget and not widget.frame then
            frame:SetParent(barController)
            frame:SetFrameLevel(barController:GetFrameLevel() + widget.frame_level_offset)
            frame:ClearAllPoints()
            frame:SetPoint(unpack(widget.point))

            if widget.attributes then
                for attr, body in next, widget.attributes do
                    frame:SetAttribute(attr, body)
                end
            end

            widget.frame = frame

            if
                not barController.isDriverRegistered and WIDGETS.ACTION_BAR.frame and WIDGETS.PET_BATTLE_BAR.frame and
                    WIDGETS.XP_BAR.frame
             then
                -- _"childupdate-numbuttons" is executed in barController's environment
                for i = 1, 12 do
                    barController:SetFrameRef("button" .. i, _G["LumActionBar1Button" .. i])
                end

                barController:Execute(
                    [[
					top = self:GetFrameRef("top")
					bottom = self:GetFrameRef("bottom")
					buttons = table.new()

					for i = 1, 12 do
						table.insert(buttons, self:GetFrameRef("button" .. i))
					end
				]]
                )

                barController:SetAttribute(
                    "_onstate-mode",
                    [[
					if newstate ~= self:GetAttribute("numbuttons") then
						self:SetAttribute("numbuttons", newstate)
						self:ChildUpdate("numbuttons", newstate)
						self:CallMethod("Update")

						top:SetWidth(newstate == 6 and 0.001 or 216)
						bottom:SetWidth(newstate == 6 and 0.001 or 216)
					end
				]]
                )

                RegisterStateDriver(barController, "mode", "[vehicleui][petbattle][overridebar][possessbar] 6; 12")

                barController.isDriverRegistered = true
            end
        end
    end
end

function BARS.IsRestricted()
    return isInit
end

function BARS.SetupActionBarController()
    if not isInit and C.db.profile.modules.bars.restricted then
        barController = CreateFrame("Frame", "LumActionBarController", UIParent, "SecureHandlerStateTemplate")
        barController:SetSize(32, 32)
        barController:SetPoint("BOTTOM", 0, 0)
        barController:SetAttribute("numbuttons", 12)
        barController.Update = function()
            if barController.Shuffle:IsPlaying() then
                barController.Shuffle:Stop()
            end

            barController.Shuffle:Play()
        end

        -- These frames are used as anchors/parents for secure/protected frames
        local top = CreateFrame("Frame", "$parentTop", barController, "SecureHandlerBaseTemplate")
        top:SetFrameLevel(barController:GetFrameLevel() + 1)
        top:SetPoint("BOTTOM", 0, 28 / 2)
        top:SetSize(432 / 2, 90 / 2)
        barController.Top = top
        barController:SetFrameRef("top", top)

        local bottom = CreateFrame("Frame", "$parentBottom", barController, "SecureHandlerBaseTemplate")
        bottom:SetFrameLevel(barController:GetFrameLevel() + 7)
        bottom:SetPoint("BOTTOM", 0, 0)
        bottom:SetSize(432 / 2, 46 / 2)
        barController.Bottom = bottom
        barController:SetFrameRef("bottom", bottom)

        -- These frames are used as anchors/parents for textures because I'm using C_Timer.After,
        -- so I can't resize protected frames while in combat
        local animController = CreateFrame("Frame", nil, UIParent)
        animController:SetFrameLevel(barController:GetFrameLevel())
        animController:SetAllPoints(barController)

        top = CreateFrame("Frame", nil, animController)
        top:SetFrameLevel(animController:GetFrameLevel() + 1)
        top:SetPoint("BOTTOM", 0, 28 / 2)
        top:SetSize(432 / 2, 90 / 2)
        animController.Top = top

        local ag = animController:CreateAnimationGroup()
        ag:SetScript(
            "OnPlay",
            function()
                local newstate = barController:GetAttribute("numbuttons")

                for _, widget in next, WIDGETS do
                    if widget.frame then
                        E:FadeOut(widget.frame)

                        if widget.children then
                            for _, child in next, widget.children do
                                E:FadeOut(_G[child], nil, nil, nil, _G[child]:GetAlpha())
                            end
                        end
                    end
                end

                C_Timer.After(
                    0.02,
                    function()
                        for _, widget in next, WIDGETS do
                            if widget.frame and widget.on_play then
                                widget.on_play(widget.frame, newstate)
                            end
                        end
                    end
                )

                C_Timer.After(
                    0.25,
                    function()
                        animController.Top:SetWidth(newstate == 6 and 0.001 or 216)
                        animController.Bottom:SetWidth(newstate == 6 and 0.001 or 216)
                    end
                )
            end
        )
        ag:SetScript(
            "OnFinished",
            function()
                for _, widget in next, WIDGETS do
                    if widget.frame then
                        if widget.frame:IsShown() then
                            E:FadeIn(widget.frame)
                        else
                            widget.frame:SetAlpha(1)
                        end

                        if widget.children then
                            for _, child in next, widget.children do
                                child = _G[child]
                                if child:IsShown() then
                                    E:FadeIn(child)

                                    if child.UpdateFading then
                                        C_Timer.After(
                                            0.15,
                                            function()
                                                child:UpdateFading()
                                            end
                                        )
                                    end
                                else
                                    child:SetAlpha(1)
                                end
                            end
                        end
                    end
                end
            end
        )
        barController.Shuffle = ag

        local anim = ag:CreateAnimation("Translation")
        anim:SetChildKey("Top")
        anim:SetOrder(1)
        anim:SetOffset(0, -55)
        anim:SetStartDelay(0.02)
        anim:SetDuration(0.15)

        anim = ag:CreateAnimation("Translation")
        anim:SetChildKey("Bottom")
        anim:SetOrder(2)
        anim:SetOffset(0, -23)
        anim:SetDuration(0.1)

        anim = ag:CreateAnimation("Translation")
        anim:SetChildKey("Bottom")
        anim:SetOrder(3)
        anim:SetOffset(0, 23)
        anim:SetDuration(0.1)

        anim = ag:CreateAnimation("Translation")
        anim:SetChildKey("Top")
        anim:SetOrder(4)
        anim:SetOffset(0, 55)
        anim:SetDuration(0.15)

        isInit = true
    end
end
