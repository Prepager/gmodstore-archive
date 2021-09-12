local PANEL = {}


--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetSize( self:GetParent():GetParent():GetWide(), self:GetParent():GetParent():GetTall() )

	self.ScrollLayout = vgui.Create( "DIconLayout" )
	self.ScrollLayout:SetSize( self:GetWide(), self:GetTall() )
	self.ScrollLayout:SetPos( 0, 0 )
	self.ScrollLayout:SetSpaceY( 10 )
	self.ScrollLayout:SetSpaceX( 10 )

	self:AddItem( self.ScrollLayout )

end


--[[---------------------------------------------------------
	Name: FillData
-----------------------------------------------------------]]
function PANEL:FillData()

	--> Commands
	local Cmds = {
		
		{ "Spacer" },

		{ "Drop Money", 1, 1, "/dropmoney", "Amount" },
		{ "Give Money", 1, 1, "/give", "Amount" },

		{ "Spacer" },

		{ "Drop Weapon", 2, 0, "/drop" },
		{ "Make Shipment", 2, 0, "/makeshipment" },
		{ "Sell All Doors", 2, 0, "/unownalldoors" },
		{ "Request Gun License", 2, 0, "/requestlicense" },

		{ "Spacer" },

	}

	if LocalPlayer():isMayor() then
		table.insert(Cmds, { "Start Lockdown", 3, 0, "/lockdown" })
		table.insert(Cmds, { "Stop Lockdown", 3, 0, "/unlockdown" })
		table.insert(Cmds, { "Add Law", 3, 1, "/addlaw", "New Law" })
		table.insert(Cmds, { "Remove Law", 3, 1, "/removelaw", "Law Number" })
		table.insert(Cmds, { "Place Lawboard", 3, 0, "/placelaws" })
		table.insert(Cmds, { "Broadcast Message", 3, 1, "/broadcast", "Message" })
		table.insert(Cmds, { "Spacer" })
	end

	if LocalPlayer():isCP() then
		table.insert(Cmds, { "Search Warrant", 4, 2, "/warrant", "Player", "Reason" })
		table.insert(Cmds, { "Wanted Player", 4, 2, "/wanted", "Player", "Reason" })
		table.insert(Cmds, { "Remove Wanted Status", 4, 1, "/unwanted", "Player" })
		table.insert(Cmds, { "Spacer" })
	end

	--> Colors
	local CmdColor = {}
	CmdColor[1] = Color( 46, 204, 113, 255 )
	CmdColor[2] = Color( 52, 152, 219, 255 )
	CmdColor[3] = Color( 150, 20, 20, 255 )
	CmdColor[4] = Color( 25, 25, 225, 255 )

	--> Loop
	for k,v in pairs( Cmds ) do
		
		--> Spacer
		if v[1] == "Spacer" then
			
			local Spacer = self.ScrollLayout:Add( "DPanel" )
			Spacer:SetSize( self.ScrollLayout:GetWide() - 84, 2 )
			Spacer.Paint = function( pnl, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 200, 200, 255 ) )
			end 

			continue

		end

		--> Object
		local object = self.ScrollLayout:Add( "FG-DButton" )
		object:SetSize( self.ScrollLayout:GetWide() / 2 - 47, 30 )
		object:SetText( v[1] )

		object.Toffset = 6
		object.ButtonColor = CmdColor[v[2]]

		object.DoClick = function()
			if v[3] == 0 then
			
				RunConsoleCommand( "say", v[4] )
				RunConsoleCommand( "fg_f4menu_close" )

			else

				local Frame = vgui.Create( "FG-Frame" )
				Frame:SetSize( 350, 200 )
				Frame:SetTitle( "FlawlessGaming - Command Panel" )
				Frame:SetVisible( true )
				Frame:SetDraggable( true )
				Frame:ShowCloseButton( true )
				Frame:SetBackgroundBlur( true )
				Frame:Center()
				Frame:MakePopup()

				Frame.Think = function()
					if not object:IsVisible() then
						
						Frame:Close()

					end
				end

				local InsideBox 	= Frame.InsideBox
				local InsideBoxW	= Frame:GetWide() - 20 * 2
				local InsideBoxH	= Frame:GetTall() - 30 - 36 * 2

				local Arg1 = vgui.Create( "DTextEntry", InsideBox )
				Arg1:SetSize( InsideBoxW - 20, 25 )
				Arg1:SetPos( 10, 10 )
				Arg1:SetText( v[5] )

				local ArgY = 10 + Arg1:GetTall() + 10

				local Arg2
				if v[3] == 2 then
					
					Arg2 = vgui.Create( "DTextEntry", InsideBox )
					Arg2:SetSize( InsideBoxW - 20, 25 )
					Arg2:SetPos( 10, ArgY )
					Arg2:SetText( v[6] )

					ArgY = ArgY + Arg2:GetTall() + 10

				end

				local button = vgui.Create( "FG-DButton", InsideBox )
				button:SetSize( InsideBoxW - 20, 25 )
				button:SetPos( 10, ArgY )
				button:SetText( "Finish" )

				button.ButtonColor = Color( 46, 204, 113, 255 )

				button.DoClick = function()

					if v[3] == 1 then
						RunConsoleCommand( "say", v[4] .. " " .. Arg1:GetValue() )
					else
						RunConsoleCommand( "say", v[4] .. " " .. Arg1:GetValue() .. " " .. Arg2:GetValue() )
					end
					
					RunConsoleCommand( "fg_f4menu_close" )
					Frame:Close()

				end

				ArgY = ArgY + button:GetTall() + 10

				Frame:SetHeight( 70 + ArgY )

			end
		end

	end

end


--[[---------------------------------------------------------
	Name: ReFillData
-----------------------------------------------------------]]
function PANEL:ReFillData()

	--> Clear
	self.ScrollLayout:Clear()

	--> Fill Data
	self:FillData()

end


--[[---------------------------------------------------------
	Name: Define
-----------------------------------------------------------]]
derma.DefineControl( "FG-F4Menu-Cmds", "FG-F4Menu-Cmds", PANEL, "FG-DScrollPanel" )