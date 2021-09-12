--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
Mania = Mania or {}
Mania.f4 = Mania.f4 or {}

--[[---------------------------------------------------------
	Function: triggerF4
-----------------------------------------------------------]]
function Mania.f4.triggerF4()

	--> Variables
	local frame = Mania.f4.frame

	--> Exists
	if !IsValid(frame) then
		Mania.f4.createF4()
		return
	end

	--> Visibility
	if frame:IsVisible() then
		Mania.f4.hideF4()
	else
		Mania.f4.showF4()
	end

end
hook.Add('ShowSpare2', 'triggerF4', Mania.f4.triggerF4)

--[[---------------------------------------------------------
	Function: showF4
-----------------------------------------------------------]]
function Mania.f4.showF4()

	--> Variables
	local frame = Mania.f4.frame

	--> Show
	frame:SetVisible(true)
	frame:Show()

	--> Reload
	frame.content:ReloadActive()

end

--[[---------------------------------------------------------
	Function: hideF4
-----------------------------------------------------------]]
function Mania.f4.hideF4()

	--> Variables
	local frame = Mania.f4.frame

	--> Show
	frame:SetVisible(false)
	frame:Hide()

end

--[[---------------------------------------------------------
	Function: createF4
-----------------------------------------------------------]]
function Mania.f4.createF4()

	--> Variables
	local settings = Mania.f4.settings

	--> Frame
	local frame = vgui.Create('ManiaFrame')
	frame:SetSettings(settings)
	frame:SetSize(settings.width, settings.height)
	frame:Center()

	--> Close
	frame:SetCloseFunction(function() 

		--> Hook
		hook.Call('ShowSpare2')

	end)

	--> Trigger
	frame.OnKeyCodePressed = function(pnl, key)
		if key == KEY_F4 then
			
			--> Hook
			hook.Call('ShowSpare2')

		end
	end

	--> Popup
	frame:MakePopup()

	--> Table
	Mania.f4.frame = frame

end

--[[---------------------------------------------------------
	Function: reloadF4 5301ad8238c6706e98e391af0b6bce248b17e5c94c9cd0854fd9425b07760cb2
-----------------------------------------------------------]]
function Mania.f4.reloadF4()

	--> Variables
	local frame = Mania.f4.frame
	local settings = Mania.f4.settings

	--> Frame
	if IsValid(frame) then
		frame:Remove()
	end

end
hook.Add('OnReloaded', 'reloadF4', Mania.f4.reloadF4)