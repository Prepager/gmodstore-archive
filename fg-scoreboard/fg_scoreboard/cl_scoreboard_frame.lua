--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local PANEL = {}


--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	local GroupModerator	= { "superadmin", "admin", "moderator" }

	--> Menu - Size
	local MenuWidth 	= ScrW() - 200
	local MenuHeight	= ScrH() - 200

	if MenuWidth 	> 950 then MenuWidth  = 950 end

	--> Menu - Create
	self:SetSize( MenuWidth, MenuHeight )
	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH() )
	self:MoveTo( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2, 0.2, 0 )

	--> Inside Box
	self.InsideBox = vgui.Create( "DPanel", self )
	self.InsideBox.Paint = function( pnl, w, h )

		--> Background
		draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240, 255 ) )

	end

	--> Players Box
	self.Players = vgui.Create( "FG-DScrollPanel", self.InsideBox )
	self.Players:Dock( FILL )

	--> Admin Box
	self.Admins = vgui.Create( "DPanel", self.InsideBox )
	self.Admins:Dock( BOTTOM )
	self.Admins:SetHeight( 30 )
	self.Admins:DockPadding( 4, 4, 4, 4 )
	self.Admins.Paint = function( pnl, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 230, 230, 230, 255 ) )
		draw.RoundedBox( 0, 0, 0, w, 1, Color( 215, 215, 215, 255 ) )

		draw.DrawText( "Players: " .. #player.GetAll() .. "/" .. game.MaxPlayers() .. ".   Map: " .. game.GetMap(), "FG_JaapokkiRegular_22", 6, 7, Color( 100, 100, 100, 255 ), 0, 1 )

	end

	self.AdminP = vgui.Create( "FG-DButton", self.Admins )
	self.AdminP:Dock( RIGHT )
	self.AdminP:SetWidth( 120 )
	self.AdminP:SetText( "Admin Actions" )
	self.AdminP.Toffset = 2

	if table.HasValue( GroupModerator, LocalPlayer():GetNWString( "usergroup" ) ) then
		self.AdminP.ButtonColor = Color( 52, 152, 219, 255 )
	else
		self.AdminP.ButtonColor = Color( 150, 150, 150, 255 )
	end
	
	self.AdminP.DoClick = function()
		if table.HasValue( GroupModerator, LocalPlayer():GetNWString( "usergroup" ) ) then

			AdminMenu = DermaMenu( self.AdminP )
			AdminMenu.Think = function() 
				if not AdminMenu:GetParent():IsVisible() then 
					AdminMenu:Remove() 
				end 
			end

			AdminMenu:AddOption( "Clear Decals", function() RunConsoleCommand( "_FAdmin", "ClearDecals" ) end ):SetIcon( "icon16/picture_delete.png" )
			AdminMenu:AddOption( "Stop Sounds", function() RunConsoleCommand( "_FAdmin", "StopSounds" ) end ):SetIcon( "icon16/sound_delete.png" )
			
			AdminMenu:AddSpacer()

			AdminMenu:AddOption( "Disconnected Props", function() RunConsoleCommand( "FPP_Cleanup", "disconnected" ) end ):SetIcon( "icon16/box.png" )

			AdminMenu:Open()

		end
	end

	--> Header
	self.Header = vgui.Create( "Panel", self )
	self.Header:Dock( TOP )
	self.Header:SetHeight( 40 )

	--> Server Name
	self.Name = self.Header:Add( "DLabel" )
	self.Name:SetFont( "FG_JaapokkiRegular_32" )
	self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.Name:Dock( TOP )
	self.Name:SetHeight( 46 )
	self.Name:SetContentAlignment( 5 )
	self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )

end


--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	--> Background
	draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240, 255 ) )

	--> Title
	draw.RoundedBox( 0, 0, 0, w, 40, Color( 40, 40, 50, 255 ) )

	--> Inside Border
	draw.RoundedBox( 0, 19, 40 + 19, w - 19 * 2, h - 40 - 19 * 2, Color( 215, 215, 215, 255 ) )

	--> Inside Box
	self.InsideBox:SetSize( w - 20 * 2, h - 40 - 20 * 2 )
	self.InsideBox:SetPos( 20, 40 + 20 )

end


--[[---------------------------------------------------------
	Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--> Variables
	self.PlayerList = {}

	--> Server Name
	self.Name:SetText( GetHostName() )

	--> Team Info
	if !ValidPanel( self.TeamInfo ) then
		
		--> Team Info
		self.TeamInfo = self.Players:Add( "DPanel" )
		self.TeamInfo:Dock( TOP )
		self.TeamInfo:SetHeight( 30 )
		self.TeamInfo:SetContentAlignment( 5 )
		self.TeamInfo.Paint = function( pnl, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240, 255 ) )

			draw.RoundedBox( 0, 0, h-1, w, 1, Color( 200, 200, 200, 255 ) )

		end

		--> Information
		local TeamAvatar = self.TeamInfo:Add( "DLabel" )
		TeamAvatar:Dock( LEFT )
		TeamAvatar:SetWidth( 42 )
		TeamAvatar:SetFont( "FG_JaapokkiRegular_20" )
		TeamAvatar:SetTextColor( Color( 100, 100, 100, 255 ) )
		TeamAvatar:SetText( "-" )
		TeamAvatar:SetContentAlignment( 5 )

		local TeamName = self.TeamInfo:Add( "DLabel" )
		TeamName:Dock( LEFT )
		TeamName:SetFont( "FG_JaapokkiRegular_20" )
		TeamName:SetTextColor( Color( 100, 100, 100, 255 ) )
		TeamName:SetText( "Name" )
		TeamName:SetContentAlignment( 5 )

		local TeamPing = self.TeamInfo:Add( "DLabel" )
		TeamPing:Dock( RIGHT )
		TeamPing:SetWidth( 60 )
		TeamPing:SetFont( "FG_JaapokkiRegular_20" )
		TeamPing:SetTextColor( Color( 100, 100, 100, 255 ) )
		TeamPing:SetText( "Ping" )
		TeamPing:SetContentAlignment( 5 )

		local TeamDeaths = self.TeamInfo:Add( "DLabel" )
		TeamDeaths:Dock( RIGHT )
		TeamDeaths:SetWidth( 60 )
		TeamDeaths:SetFont( "FG_JaapokkiRegular_20" )
		TeamDeaths:SetTextColor( Color( 100, 100, 100, 255 ) )
		TeamDeaths:SetText( "Deaths" )
		TeamDeaths:SetContentAlignment( 5 )

		local TeamKills = self.TeamInfo:Add( "DLabel" )
		TeamKills:Dock( RIGHT )
		TeamKills:SetWidth( 60 )
		TeamKills:SetFont( "FG_JaapokkiRegular_20" )
		TeamKills:SetTextColor( Color( 100, 100, 100, 255 ) )
		TeamKills:SetText( "Kills" )
		TeamKills:SetContentAlignment( 5 )

	end

	--> Loop Players
	for id, ply in pairs( player.GetAll() ) do

		--> Check Player
		if not IsValid( ply ) or not ply:IsPlayer() then return end

		--> Check Entry
		if IsValid( ply.ScoreEntry ) and ply.ScoreEntry.Team == ply:Team() then continue end

		--> Team
		if not self.PlayerList[ ply:Team() ] then

			self.PlayerList[ ply:Team() ] = {}

		end
			
		--> Insert
		table.insert( self.PlayerList[ ply:Team() ], ply )

	end

	--> Loop Teams
	for id, job in pairs( self.PlayerList ) do

		--> Team Display
		local TeamPanel = self.Players:Add( "DPanel" )
		TeamPanel:Dock( TOP )
		TeamPanel:SetHeight( 30 )
		TeamPanel.Think = function()
			if team.GetPlayers( id ) == 0 then
				TeamPanel:Remove()
			end
		end
		TeamPanel.Paint = function( pnl, w, h ) 

			draw.RoundedBox( 0, 0, 0, w, h, team.GetColor( id ) )

			draw.DrawText( team.GetName( id ), "FG_JaapokkiRegular_22", 10, 6, Color( 255, 255, 255, 255 ) )

		end

		--> Players
		for k,v in pairs( job ) do
			
			--> Create
			v.ScoreEntry = vgui.Create( "FG-Scoreboard-Player" )
			v.ScoreEntry:Setup( v )

			--> Add
			self.Players:AddItem( v.ScoreEntry )

		end

	end

end


--[[---------------------------------------------------------
	Name: DefineControl
-----------------------------------------------------------]]
derma.DefineControl( "FG-Scoreboard", "FG-Scoreboard", PANEL, "EditablePanel" )