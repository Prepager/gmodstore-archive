--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local PANEL = {}


--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Panel Settings
	self:Dock( TOP )
	self:SetHeight( 32 + 6 * 2 )
	self:DockPadding( 6, 6, 6, 6 )
	self:SetText( "" )

	--> Player Settings	
	self.Avatar = self:Add( "AvatarImage" )
	self.Avatar:Dock( LEFT )
	self.Avatar:SetSize( 32, 32 )
	self.Avatar:SetMouseInputEnabled( false )

	self.Name = self:Add( "DLabel" )
	self.Name:Dock( FILL )
	self.Name:SetFont( "FG_JaapokkiRegular_22" )
	self.Name:SetTextColor( Color( 0, 0, 0, 255 ) )
	self.Name:DockMargin( 10, 0, 0, 0 )

	self.Ping = self:Add( "DLabel" )
	self.Ping:Dock( RIGHT )
	self.Ping:SetWidth( 60 )
	self.Ping:SetFont( "FG_JaapokkiRegular_22" )
	self.Ping:SetTextColor( Color( 0, 0, 0, 255 ) )
	self.Ping:SetContentAlignment( 5 )

	self.Deaths = self:Add( "DLabel" )
	self.Deaths:Dock( RIGHT )
	self.Deaths:SetWidth( 60 )
	self.Deaths:SetFont( "FG_JaapokkiRegular_22" )
	self.Deaths:SetTextColor( Color( 0, 0, 0, 255 ) )
	self.Deaths:SetContentAlignment( 5 )

	self.Kills = self:Add( "DLabel" )
	self.Kills:Dock( RIGHT )
	self.Kills:SetWidth( 60 )
	self.Kills:SetFont( "FG_JaapokkiRegular_22" )
	self.Kills:SetTextColor( Color( 0, 0, 0, 255 ) )
	self.Kills:SetContentAlignment( 5 )

end


--[[---------------------------------------------------------
	Name: DoClick
-----------------------------------------------------------]]
function PANEL:DoClick()

	--> Variables
	local GroupModerator	= { "superadmin", "admin", "moderator" }

	--> Create Menu
	local Option = DermaMenu()

	Option.Think = function() 
		if not self:GetParent():GetParent():GetParent():GetParent():IsVisible() then 
			Option:Remove() 
		end 
	end

	--> User
	local user, user_pnl = Option:AddSubMenu( "User" ) 
	user_pnl:SetIcon( "icon16/user.png" )

		user:AddOption( "View Profile", function() gui.OpenURL( FAdmin.SteamToProfile( self.Player ) ) end ):SetIcon( "icon16/information.png" )
		user:AddOption( "Copy SteamID", function() SetClipboardText( self.Player:SteamID() ) end ):SetIcon( "icon16/application_go.png" )
		user:AddOption( "Copy Name", function() SetClipboardText( self.Player:Nick() ) end ):SetIcon( "icon16/user_go.png" )

	Option:AddSpacer()

	--> Admin
	if table.HasValue( GroupModerator, LocalPlayer():GetNWString( "usergroup" ) ) then

		--> Gag
		local gag, gag_pnl = Option:AddSubMenu( "Gag" )
		gag_pnl:SetIcon( "icon16/sound.png" )

			gag:AddOption( "Gag", function() RunConsoleCommand( "_FAdmin", "Voicemute", self.Player:UserID() ) end ):SetIcon( "icon16/sound_delete.png" )
			gag:AddOption( "Ungag", function() RunConsoleCommand( "_FAdmin", "UnVoicemute", self.Player:UserID() ) end ):SetIcon( "icon16/sound_add.png" )

		--> Mute
		local mute, mute_pnl = Option:AddSubMenu( "Mute" )
		mute_pnl:SetIcon( "icon16/email.png" )

			mute:AddOption( "Mute", function() RunConsoleCommand( "_FAdmin", "chatmute", self.Player:UserID() ) end ):SetIcon( "icon16/email_delete.png" )
			mute:AddOption( "Unmute", function() RunConsoleCommand( "_FAdmin", "UnChatmute", self.Player:UserID() ) end ):SetIcon( "icon16/email_add.png" )

		Option:AddSpacer()

		--> Cloak
		local cloak, cloak_pnl = Option:AddSubMenu( "Cloak" )
		cloak_pnl:SetIcon( "icon16/contrast.png" )

			cloak:AddOption( "Cloak", function() RunConsoleCommand( "_FAdmin", "Cloak", self.Player:UserID() ) end ):SetIcon( "icon16/contrast_low.png" )
			cloak:AddOption( "Uncloak", function() RunConsoleCommand( "_FAdmin", "Uncloak", self.Player:UserID() ) end ):SetIcon( "icon16/contrast_high.png" )

		--> Freeze
		local freeze, freeze_pnl = Option:AddSubMenu( "Freeze" )
		freeze_pnl:SetIcon( "icon16/mouse.png" )

			freeze:AddOption( "Freeze", function() RunConsoleCommand( "_FAdmin", "freeze", self.Player:UserID() ) end ):SetIcon( "icon16/mouse_delete.png" )
			freeze:AddOption( "Unfreeze", function() RunConsoleCommand( "_FAdmin", "unfreeze", self.Player:UserID() ) end ):SetIcon( "icon16/mouse_add.png" )

		--> God
		local god, god_pnl = Option:AddSubMenu( "God" )
		god_pnl:SetIcon( "icon16/shield.png" )

			god:AddOption( "God", function() RunConsoleCommand( "_FAdmin", "god", self.Player:UserID() ) end ):SetIcon( "icon16/shield_add.png" )
			god:AddOption( "Ungod", function() RunConsoleCommand( "_FAdmin", "ungod", self.Player:UserID() ) end ):SetIcon( "icon16/shield_delete.png" )

		Option:AddSpacer()

		--> Spectate
		local spec = Option:AddOption( "Spectate", function() RunConsoleCommand( "FSpectate", self.Player:UserID() ) end ):SetIcon( "icon16/eye.png" )

		Option:AddSpacer()

		--> Unarrest
		local unarrest = Option:AddOption( "Unarrest", function() RunConsoleCommand( "darkrp", "unarrest", self.Player:Nick() ) end ):SetIcon( "icon16/link_break.png" )

		--> Set Job
		local setjob, setjob_pnl = Option:AddSubMenu( "Set Job" )
		setjob_pnl:SetIcon( "icon16/user_edit.png" )

			for k,v in SortedPairsByMemberValue( RPExtraTeams, "name" ) do
				setjob:AddOption( v.name, function() RunConsoleCommand( "_FAdmin", "setteam", self.Player:UserID(), k ) end )
			end

		--> Ban Job
		local banjob, banjob_pnl = Option:AddSubMenu( "Ban Job" )
		banjob_pnl:SetIcon( "icon16/user_delete.png" )

			for k,v in SortedPairsByMemberValue( RPExtraTeams, "name" ) do
				local jobban = banjob:AddSubMenu( v.name )
				jobban:AddOption( "2 minutes",     function() RunConsoleCommand( "darkrp", "teamban", self.Player:UserID(), k, 120 )  end )
				jobban:AddOption( "Half an hour",  function() RunConsoleCommand( "darkrp", "teamban", self.Player:UserID(), k, 1800 ) end )
				jobban:AddOption( "An hour",       function() RunConsoleCommand( "darkrp", "teamban", self.Player:UserID(), k, 3600 ) end )
				jobban:AddOption ("Until restart", function() RunConsoleCommand( "darkrp", "teamban", self.Player:UserID(), k, 0 )    end )
			end

		--> UnBan Job
		local unbanjob, unbanjob_pnl = Option:AddSubMenu( "Unban Job" )
		unbanjob_pnl:SetIcon( "icon16/user_add.png" )

			for k,v in SortedPairsByMemberValue( RPExtraTeams, "name" ) do
				unbanjob:AddOption( v.name, function() RunConsoleCommand( "darkrp", "teamunban", self.Player:UserID(), k ) end )
			end

		Option:AddSpacer()

		--> Teleport
		local tele, tele_pnl = Option:AddSubMenu( "Teleport" )
		tele_pnl:SetIcon( "icon16/arrow_out.png" )

			tele:AddOption( "Bring", function() RunConsoleCommand( "_FAdmin", "bring", self.Player:UserID(), LocalPlayer():UserID() ) end ):SetIcon( "icon16/arrow_left.png" )
			tele:AddOption( "Goto", function() RunConsoleCommand( "_FAdmin", "goto", self.Player:UserID() ) end ):SetIcon( "icon16/arrow_right.png" )
			tele:AddOption( "Teleport", function() RunConsoleCommand( "_FAdmin", "Teleport", self.Player:UserID() ) end ):SetIcon( "icon16/arrow_up.png" )

	end

	--> Open Menu
	Option:Open()

end


--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
function PANEL:Setup( ply )

	--> Settings
	self.Player = ply
	self.Team 	= ply:Team()
	self.Rank 	= ply:GetNWString( "usergroup" )
	self.RankI 	= "icon16/user"

	--> Ranks
	/*local ServerRanks 			= {}
	ServerRanks['user'] 		= ""
	ServerRanks['moderator']	= ""
	ServerRanks['admin']		= ""
	ServerRanks['superadmin']	= ""*/

	--> Avatar
	self.Avatar:SetPlayer( ply )

	--> Think
	self:Think( self )

end


--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	--> Border
	draw.RoundedBox( 0, 0, h - 1, w, 1, Color( 200, 200, 200, 255 ) )

end


--[[---------------------------------------------------------
	Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--> Check Player
	if !IsValid( self.Player ) then self:Remove() return end
	if self.Team != self.Player:Team() then self:Remove() return end

	--> Variables
	local TempPlayername = self.Player:Nick()

	--> Check Name
	if self.PName == nil or self.PName != TempPlayername then
		self.PName = TempPlayername
		self.Name:SetText( self.PName )
	end

	--> Check Kills
	if self.NumKills == nil or self.NumKills != self.Player:Frags() then
		self.NumKills = self.Player:Frags()
		self.Kills:SetText( self.NumKills )
	end

	--> Check Deaths
	if self.NumDeaths == nil or self.NumDeaths != self.Player:Deaths() then
		self.NumDeaths = self.Player:Deaths()
		self.Deaths:SetText( self.NumDeaths )
	end

	--> Check Ping
	if self.NumPing == nil or self.NumPing != self.Player:Ping() then
		self.NumPing = self.Player:Ping()
		self.Ping:SetText( self.NumPing )
	end

end


--[[---------------------------------------------------------
	Name: DefineControl
-----------------------------------------------------------]]
derma.DefineControl( "FG-Scoreboard-Player", "FG-Scoreboard-Player", PANEL, "DButton" )