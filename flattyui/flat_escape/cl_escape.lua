--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local escapeFrame = nil
local escapeSkip = false
local escapeTime = CurTime()

--[[---------------------------------------------------------
	escapeMenu
-----------------------------------------------------------]]
local function escapeMenu()
	if gui.IsGameUIVisible() then

		--> Hide
		if !escapeSkip then
			gui.HideGameUI()
		end

		--> Check
		if !escapeSkip and (!IsValid(escapeFrame) or !escapeFrame:IsVisible()) then

			--> Frame
			escapeFrame = vgui.Create("flatFrame")
			escapeFrame:SetSize(400, 550)
			escapeFrame:SetDraggable(true)
			escapeFrame:MakePopup()
			escapeFrame:DockPadding(6, 41, 6, 1)
			escapeFrame:SetTitle("Escape Menu")
			escapeFrame:SetBackgroundBlur(true)

			--> Buttons
			escapeSize = 42
			for k, v in pairs(FlattySettings.escapemenu.buttons) do

				--> Divider
				if v[1] == "div" then

					--> Panel
					local divider = vgui.Create("DPanel", escapeFrame)
					divider:Dock(TOP)
					divider:SetTall(2)
					divider:DockMargin(0, 5, 0, 5)

					divider.Paint = function(pnl, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 25))
					end

					--> Continue
					escapeSize = escapeSize+divider:GetTall()+10
					continue

				end

				--> Enable UI
				if v[1] == "ui" then

					--> Button
					local button = vgui.Create("flatButton", escapeFrame)
					button:Dock(TOP)
					button:SetTall(36)
					button:SetTheme(v[3])
					button:SetText(v[2])
					button:SetFont("FlatUI_18")
					button:DockMargin(0, 5, 0, 5)

					button.DoClick = function()

						// Variable
						escapeSkip = true
						escapeTime = CurTime()+FlattySettings.escapemenu.closeTime

						// Close
						escapeFrame:Close()

						// Open
						gui.ActivateGameUI()

					end

					--> Size
					escapeSize = escapeSize+button:GetTall()+10
					continue

				end

				--> Button
				local button = vgui.Create("flatButton", escapeFrame)
				button:Dock(TOP)
				button:SetTall(36)
				button:SetTheme(v[2] or "green")
				button:SetText(v[1])
				button:SetFont("FlatUI_18")
				button:DockMargin(0, 5, 0, 5)

				button.DoClick = v[3]

				--> Size
				escapeSize = escapeSize+button:GetTall()+10

			end

			--> Size
			escapeFrame:SetTall(escapeSize)
			escapeFrame:Center()

		else

			--> Remove
			if IsValid(escapeFrame) then
				escapeFrame:Close()
			end

		end

	else

		--> Skip
		if escapeTime < CurTime() then
			escapeSkip = false
		end

	end
end
hook.Add("PreRender", "escapeMenu", escapeMenu)
