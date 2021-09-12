--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local FG = {}
local FGMenu


--[[---------------------------------------------------------
	Name: Menu - Open/Create
-----------------------------------------------------------]]
function FG:F4MenuOpen()
	if FGMenu and ValidPanel( FGMenu ) then
		
		--> Menu - Show
		FGMenu:SetVisible( true )
		FGMenu:Show()

		--> Menu - Position
		FGMenu:MoveTo( ScrW()/2 - FGMenu:GetWide()/2, ScrH()/2 - FGMenu:GetTall()/2, 0.2, 0 )

		--> Menu - Active Panel
		if FGMenu.TabsActivePanel and ValidPanel( FGMenu.TabsActivePanel ) then
			FGMenu.TabsActivePanel:ReFillData()
		end


	else

		--> Menu Create
		FGMenu = vgui.Create( "FG-F4Menu" )

		--> Menu - Show
		FGMenu:SetVisible( true )
		FGMenu:Show()

		--> Menu - Position
		FGMenu:MoveTo( ScrW()/2 - FGMenu:GetWide()/2, ScrH()/2 - FGMenu:GetTall()/2, 0.2, 0 )

		--> Menu - Active Panel
		if FGMenu.TabsActivePanel and ValidPanel( FGMenu.TabsActivePanel ) then
			FGMenu.TabsActivePanel:ReFillData()
		end

	end
end
concommand.Add( "fg_f4menu_open", function() FG:F4MenuOpen() end )


--[[---------------------------------------------------------
	Name: Menu - Close
-----------------------------------------------------------]]
function FG:F4MenuClose()
	if FGMenu then
		
		--> Menu - Position
		FGMenu:SetPos( ScrW()/2 - FGMenu:GetWide()/2, ScrH() )

		--> Menu - Hide
		FGMenu:SetVisible( false )
		FGMenu:Hide()

	else

		--> Menu - Create
		FG:F4MenuOpen()

	end
end
concommand.Add( "fg_f4menu_close", function() FG:F4MenuClose() end )


--[[---------------------------------------------------------
	Name: Menu - Handle
-----------------------------------------------------------]]
local CheckNext = CurTime()
function FG:HandleF4Menu()

	--> Time
	if CheckNext > CurTime() then return end

	--> F4Menu Check
	if not ValidPanel( FGMenu ) or not FGMenu:IsVisible() then
		
		--> Open Menu
		FG:F4MenuOpen()

		--> Time
		CheckNext = CurTime() + 0.5

	else

		--> Close Menu
		FG:F4MenuClose()

		--> Time
		CheckNext = CurTime() + 0.5

	end

end
hook.Add( "ShowSpare2", "FG.HandleF4Menu", FG.HandleF4Menu )