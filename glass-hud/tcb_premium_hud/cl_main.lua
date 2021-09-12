--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]
local TCBSettings 	= {}

--> HUD Postion
TCBSettings.PosX 	= "left"	// left, right, center
TCBSettings.PosY 	= "bottom"	// top, bottom, center

--> Colors
TCBSettings.MainC 	= Color( 0, 0, 0 )		// Background

TCBSettings.Health 	= Color( 192, 57, 43 ) 	// Health
TCBSettings.Armor 	= Color( 41, 128, 185 ) // Armor
TCBSettings.Hunger 	= Color( 211, 84, 0 ) 	// Hunger
TCBSettings.Stamina = Color( 39, 174, 96 ) 	// Stamina
TCBSettings.Level 	= Color( 142, 68, 173 ) // Level

--> Modules
TCBSettings.Modules = {
	["health"] 	= true,
	["armor"]	= true,
	["hunger"]	= false,	// Requirement: Hungermod enabled.
	["stamina"]	= false, 	// Requirement: TCB Stamina installed.	(http://www.thecodingbeast.com/products)
	["level"]	= false, 	// Requirement: Vrondakis level system. (https://github.com/vrondakis/DarkRP-Leveling-System)

	["ammo"]	= true,

	["head"]	= true,
	["head_d"]	= false, 	// Default DarkRP overhead display.
}

--> Language
TCBSettings.Language = {
	["wallet"]	= "wallet",
	["salary"]	= "salary",
	["job"]		= "job",

	["health"]	= "health",
	["armor"]	= "armor",
	["hunger"]	= "hunger",
	["stamina"]	= "stamina",
	["level"]	= "lvl:",

	["ammo"]	= "ammo",

	["lockdo"]	= "lockdown: please return to your homes",
}

--> Max Values
TCBSettings.MaxValues = {
	["health"] 	= 100,
	["armor"]	= 100,
	["hunger"]	= 100,
	["stamina"]	= 100,
}

/* ---------------------------------------------------------------- */
/* DON'T CHANGE ANYTHING BELOW IF YOU DON'T KNOW WHAT YOU ARE DOING */
/* ---------------------------------------------------------------- */

--> Size
TCBSettings.Height 	= 95
TCBSettings.Width 	= 300

--> Spacing
TCBSettings.Space 	= 5


--[[---------------------------------------------------------
	Name: HUD Position
-----------------------------------------------------------]]
if( TCBSettings.PosX == "left" ) then
	TCBSettings.X = 10
elseif( TCBSettings.PosX == "right" ) then
	TCBSettings.X = ScrW() - TCBSettings.Width - 10
elseif( TCBSettings.PosX == "center" ) then
	TCBSettings.X = ScrW() / 2 - TCBSettings.Width / 2
end

if( TCBSettings.PosY == "top" ) then
	TCBSettings.Y = 10
elseif( TCBSettings.PosY == "bottom" ) then
	TCBSettings.Y = ScrH() - TCBSettings.Height - 10
elseif( TCBSettings.PosY == "center" ) then
	TCBSettings.Y = ScrH() / 2 - TCBSettings.Height / 2
end

--[[---------------------------------------------------------
	Name: TextOverflow
-----------------------------------------------------------]]
function TextOverflow( text, font, width )

	surface.SetFont(font)

	local ellipsissize = surface.GetTextSize("...")

	for len = 1, #text do 
		local substr = text:sub(1, len)

		local subsize = surface.GetTextSize(substr)

		if(subsize > width - ellipsissize) then
			return text:sub(1, len - 1) .. "..."
		end
	end

	return text

end


--[[---------------------------------------------------------
	Name: TextOverflow
-----------------------------------------------------------]]
function FormatNumber( n )

	if not n then return "" end

	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or "."
	local dp = string.find(n, "%.") or #n+1

	for i=dp-4, 1, -3 do

		n = n:sub(1, i) .. sep .. n:sub(i+1)
		
	end

	return n

end


--[[---------------------------------------------------------
	Name: Hide Elements
-----------------------------------------------------------]]
local HideElementsTable = {
	
	--> DarkRP
	["DarkRP_HUD"]				= true,
	["DarkRP_EntityDisplay"] 	= true,
	["DarkRP_ZombieInfo"] 		= true,
	["DarkRP_LocalPlayerHUD"] 	= true,
	["DarkRP_Hungermod"] 		= true,
	["DarkRP_Agenda"] 			= true,

	--> GMod
	["CHudHealth"]				= true,
	["CHudBattery"]				= true,
	["CHudSuitPower"]			= true,

	--> Module
	["CHudAmmo"]				= TCBSettings.Modules["ammo"],

}

local function HideElements( element )
	if HideElementsTable[ element ] then
		return false
	end
end
hook.Add( "HUDShouldDraw", "HideElements", HideElements )


--[[---------------------------------------------------------
	Name: draw.TCBBorderBox
-----------------------------------------------------------]]
function draw.TCBBorderBox( bordersize, x, y, w, h, color )

	--> Background
	draw.RoundedBox( 0, x, y, w, h, Color( color.r, color.g, color.b, 100 ) )

	--> Border - Side
	draw.RoundedBox( 0, x-1, y-1, 1, h+2, Color( color.r, color.g, color.b, 250 ) )
	draw.RoundedBox( 0, x+w, y-1, 1, h+2, Color( color.r, color.g, color.b, 250 ) )

	--> Border - Top
	draw.RoundedBox( 0, x, y-1, w, 1, Color( color.r, color.g, color.b, 250 ) )
	draw.RoundedBox( 0, x, y+h, w, 1, Color( color.r, color.g, color.b, 250 ) )

end


--[[---------------------------------------------------------
	Name: Materials
-----------------------------------------------------------]]
local VoiceChatTexture = surface.GetTextureID("voice/icntlk_pl")
local Page = Material("icon16/page_white_text.png")

--[[---------------------------------------------------------
	Name: Arrested
-----------------------------------------------------------]]
local Arrested = function() end

usermessage.Hook("GotArrested", function(msg)

	local StartArrested = CurTime()
	local ArrestedUntil = msg:ReadFloat()

	--> Variables
	local MainColor 	= Color( TCBSettings.MainC.r, TCBSettings.MainC.g, TCBSettings.MainC.b, 100 )
	local BorderColor 	= Color( TCBSettings.MainC.r, TCBSettings.MainC.g, TCBSettings.MainC.b, 250 )

	local MainX 	= TCBSettings.X
	local MainY 	= TCBSettings.Y
	local MainW 	= TCBSettings.Width
	local MainH 	= TCBSettings.Height

	Arrested = function()
		if CurTime() - StartArrested <= ArrestedUntil and LocalPlayer():getDarkRPVar("Arrested") then

			--> Variables
			local cin = (math.sin(CurTime()) + 1) / 2
			local posy = 65

			--> Background
			draw.TCBBorderBox(0, MainX, MainY-posy, MainW, 30, TCBSettings.MainC)
			draw.TCBBorderBox(0, MainX+5, MainY-posy+5, MainW-10, 20, Color(cin * 255, 0, 255 - (cin * 255), 255))

			--> Text
			draw.DrawText( string.lower( DarkRP.getPhrase( "youre_arrested", math.ceil( ArrestedUntil - ( CurTime() - StartArrested ) ) ) ), "TCB_Premium_Fairview_22", MainX+MainW/2, MainY-posy+4, Color( 255, 255, 255, 255 ), 1 )

		elseif not LocalPlayer():getDarkRPVar("Arrested") then

			Arrested = function() end

		end
	end

end)


--[[---------------------------------------------------------
	Name: AdminTell
-----------------------------------------------------------]]
local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
	timer.Destroy("DarkRP_AdminTell")
	local Message = msg:ReadString()

	AdminTell = function()
		draw.RoundedBox(4, 10, 10, ScrW() - 20, 110, Color( 0, 0, 0, 200 ))
		draw.DrawNonParsedText(string.lower(DarkRP.getPhrase("listen_up")), "TCB_Premium_Fairview_50", ScrW() / 2 + 10, 10, Color( 255, 255, 255, 255 ), 1)
		draw.DrawNonParsedText(string.lower(Message), "TCB_Premium_Fairview_30", ScrW() / 2 + 10, 70, Color( 255, 255, 255, 255 ), 1)
	end

	timer.Create("DarkRP_AdminTell", 10, 1, function()
		AdminTell = function() end
	end)
end)


--[[---------------------------------------------------------
	Name: Main HUD
-----------------------------------------------------------]]
local function MainHUD()

	--> Variables
	local MainColor 	= Color( TCBSettings.MainC.r, TCBSettings.MainC.g, TCBSettings.MainC.b, 100 )
	local BorderColor 	= Color( TCBSettings.MainC.r, TCBSettings.MainC.g, TCBSettings.MainC.b, 250 )

	local MainX 	= TCBSettings.X
	local MainY 	= TCBSettings.Y
	local MainW 	= TCBSettings.Width
	local MainH 	= TCBSettings.Height

	--> Background
	draw.TCBBorderBox( 0, MainX, MainY, MainW, MainH, TCBSettings.MainC )

	--> Avatar
	draw.TCBBorderBox( 0, MainX+TCBSettings.Space, MainY+TCBSettings.Space, MainH-TCBSettings.Space*2, MainH-TCBSettings.Space*2, TCBSettings.MainC )

	local AvatarWidth 	= MainH-TCBSettings.Space*2
	local TextWidth 	= MainW-AvatarWidth-20

	--> Divider
	draw.TCBBorderBox( 0, MainX+AvatarWidth+12, MainY+MainH/2-1, MainW-AvatarWidth-20, 2, TCBSettings.MainC )

	--> Rank
	draw.TCBBorderBox(0, MainX, MainY-25, AvatarWidth+4, 15, TCBSettings.MainC)
	draw.DrawText( LocalPlayer():GetNWString("usergroup"), "TCB_Premium_Fairview_18", MainX+AvatarWidth/2, MainY-28, Color( 255, 255, 255, 255 ), 1 )

	--> Name
	draw.TCBBorderBox(0, MainX+AvatarWidth+12, MainY-25, MainW-AvatarWidth-12, 15, TCBSettings.MainC)
	draw.DrawText( TextOverflow(string.lower( LocalPlayer():Nick() ), "TCB_Premium_Fairview_18", TextWidth ), "TCB_Premium_Fairview_18", MainX+AvatarWidth+TextWidth/2+12, MainY-28, Color( 255, 255, 255, 255 ), 1 )

	--> Money
	draw.DrawText( string.lower(TCBSettings.Language["wallet"]), "TCB_Premium_Fairview_18", MainX+AvatarWidth*1+TextWidth/4+12*1, MainY, Color( 255, 255, 255, 255 ), 1 )
	draw.DrawText( TextOverflow( "$"..FormatNumber(LocalPlayer():getDarkRPVar( "money" ) or 0), "TCB_Premium_Fairview_24", TextWidth/2), "TCB_Premium_Fairview_24", MainX+AvatarWidth*1+TextWidth/4+12*1, MainY+18, Color( 255, 255, 255, 255 ), 1 )

	--> Salery
	draw.DrawText( string.lower(TCBSettings.Language["salary"]), "TCB_Premium_Fairview_18", MainX+AvatarWidth*2+TextWidth/4+12*2, MainY, Color( 255, 255, 255, 255 ), 1 )
	draw.DrawText( TextOverflow( "$"..FormatNumber(LocalPlayer():getDarkRPVar( "salary" ) or 0), "TCB_Premium_Fairview_24", TextWidth/2), "TCB_Premium_Fairview_24", MainX+AvatarWidth*2+TextWidth/4+12*2, MainY+18, Color( 255, 255, 255, 255 ), 1 )

	--> Job
	draw.DrawText( string.lower(TCBSettings.Language["job"]), "TCB_Premium_Fairview_18", MainX+AvatarWidth*1.5+TextWidth/4+12*1.5, MainY+MainH/2+2, Color( 255, 255, 255, 255 ), 1 )
	draw.DrawText( TextOverflow(string.lower(LocalPlayer():getDarkRPVar( "job" ) or ""), "TCB_Premium_Fairview_24", TextWidth ) , "TCB_Premium_Fairview_24", MainX+AvatarWidth*1.5+TextWidth/4+12*1.5, MainY+MainH/2+18+2, Color( 255, 255, 255, 255 ), 1 )

	--> Lockdown
	if GetGlobalBool("DarkRP_LockDown") then

		--> Variables
		local cin = (math.sin(CurTime()) + 1) / 2
		local posy = 65

		if LocalPlayer():getDarkRPVar("Arrested") then
			posy = 100
		end

		--> Background
		draw.TCBBorderBox(0, MainX, MainY-posy, MainW, 30, TCBSettings.MainC)
		draw.TCBBorderBox(0, MainX+5, MainY-posy+5, MainW-10, 20, Color(cin * 255, 0, 255 - (cin * 255), 255))

		--> Text
		draw.DrawText( string.lower(TCBSettings.Language["lockdo"]), "TCB_Premium_Fairview_22", MainX+MainW/2, MainY-posy+2, Color( 255, 255, 255, 255 ), 1 )

	end

	--> Arrested
	Arrested()

	--> AdminTell
	AdminTell()

	--> Wanted
	if LocalPlayer():getDarkRPVar('wanted') then

		--> Variables
		local cin = (math.sin(CurTime()) + 1) / 2
		local posy = 65

		--> Background
		draw.TCBBorderBox(0, MainX, MainY-posy, MainW, 30, TCBSettings.MainC)
		draw.TCBBorderBox(0, MainX+5, MainY-posy+5, MainW-10, 20, Color(cin * 255, 0, 255 - (cin * 255), 255))

		--> Text
		draw.DrawText(string.lower('Wanted: '..LocalPlayer():getDarkRPVar("wantedReason")), "TCB_Premium_Fairview_22", MainX+MainW/2, MainY-posy+3, Color( 255, 255, 255, 255 ), 1 )
	end

	--> License
	if LocalPlayer():getDarkRPVar('HasGunlicense') then
        surface.SetMaterial(Page)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(MainX, MainY-65, 32, 32)
	end

	--> Voice
	if LocalPlayer().DRPIsTalking then

		local chbxX, chboxY = chat.GetChatBoxPos()

		local Rotating = math.sin( CurTime() * 3 )
		local backwards = 0
		if Rotating < 0 then
			Rotating = 1-( 1 + Rotating )
			backwards = 180
		end

		surface.SetTexture( VoiceChatTexture )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRectRotated( ScrW() - 100, chboxY, Rotating*96, 96, backwards )

	end

	--> Bar
	local BarX 	= MainX + MainW + 10
	local BarY 	= MainY + 12
	local BarH 	= MainH - 12
	local BarM 	= { "health", "armor", "hunger", "stamina", "level" }

	--> Loop
	for k,v in pairs( BarM ) do
		if TCBSettings.Modules[v] then
			
			--> Variables
			local BarValue 	= 0
			local BarHeight = 0
			local BarColor 	= Color( 0, 0, 0 )
			local BarCustom = ""
			local BarOrigi 	= false
			local BarTitle  = ""

			--> Types
			if v == "health" then
				BarValue = LocalPlayer():Health() or 0
				BarColor = TCBSettings.Health
				BarTitle = string.lower(TCBSettings.Language["health"])
				BarMax 	 = TCBSettings.MaxValues["health"]
			elseif v == "armor" then
				BarValue = LocalPlayer():Armor() or 0
				BarColor = TCBSettings.Armor
				BarTitle = string.lower(TCBSettings.Language["armor"])
				BarMax 	 = TCBSettings.MaxValues["armor"]
			elseif v == "hunger" then
				BarValue = math.ceil( LocalPlayer():getDarkRPVar( "Energy" ) or 0 )
				BarColor = TCBSettings.Hunger
				BarTitle = string.lower(TCBSettings.Language["hunger"])
				BarMax 	 = TCBSettings.MaxValues["hunger"]
			elseif v == "stamina" then
				BarValue = LocalPlayer():GetNWInt( "tcb_stamina" ) or 0
				BarColor = TCBSettings.Stamina
				BarTitle = string.lower(TCBSettings.Language["stamina"])
				BarMax 	 = TCBSettings.MaxValues["stamina"]
			elseif v == "level" then
				local PlayerXP 		= LocalPlayer():getDarkRPVar('xp') or 0
				local PlayerLevel 	= LocalPlayer():getDarkRPVar('level') or 0
				BarValue = 700
				BarValue = ((PlayerXP or 0)/(((10+(((PlayerLevel or 1)*((PlayerLevel or 1)+1)*90))))*LevelSystemConfiguration.XPMult)) * 100
				BarColor = TCBSettings.Level
				BarOrigi = true
				BarTitle = string.lower(TCBSettings.Language["level"]) .. " " .. PlayerLevel
			else
				BarValue = 0
				BarColor = TCBSettings.Health
				BarMax 	 = 100
			end

			--> Title
			draw.TCBBorderBox(0, BarX, BarY-25, 40, 15, TCBSettings.MainC)

			--> Background
			draw.TCBBorderBox(0, BarX, BarY, 40, BarH, TCBSettings.MainC)
			draw.TCBBorderBox(0, BarX+5, BarY+5, 30, BarH-10, TCBSettings.MainC)

			--> Variable
			BarEchoVal	= BarValue
			BarValue 	= math.Clamp( BarValue, 0, BarMax )
			BarHeight 	= (BarH - 10) / BarMax * BarValue

			if not BarOrigi then
				BarEchoVal = BarValue
			end

			if BarTitle != "" then
				BarTitle = BarTitle
			else
				BarTitle = v
			end

			--> Value
			draw.RoundedBox( 0, BarX+5, BarY+(BarH-10-BarHeight)+5, 30, BarHeight, BarColor )

			--> Text
			draw.DrawText( math.Round( BarValue ), "TCB_Premium_Fairview_24", BarX+20, BarY+BarH/2-24/2, Color( 255, 255, 255, 255 ), 1 )
			draw.DrawText( BarTitle, "TCB_Premium_Fairview_18", BarX+20, BarY-28, Color( 255, 255, 255, 255 ), 1 )

			--> Position
			BarX = BarX + 40 + 10

		end
	end

end
hook.Add( "HUDPaint", "MainHUD", MainHUD )


--[[---------------------------------------------------------
	Name: Ammo HUD
-----------------------------------------------------------]]
local function AmmoHUD()

	--> Enabled
	if not TCBSettings.Modules['ammo'] then return end

	--> Variables
	local BoxW	= 100
	local BoxH 	= 80
	local BoxX 	= ScrW() - BoxW - 10
	local BoxY 	= ScrH() - BoxH - 10

	--> Checks
	local weapon = LocalPlayer():GetActiveWeapon()
	if not weapon or not IsValid( weapon ) or not LocalPlayer():Alive() then return end

	local clip = weapon:Clip1()
	local ammo = LocalPlayer():GetAmmoCount( weapon:GetPrimaryAmmoType() )
	if clip == -1 or clip <= 0 and ammo <= 0 then return end

	--> Background
	draw.TCBBorderBox( 0, BoxX, BoxY, BoxW, BoxH, TCBSettings.MainC )

	--> Clip
	draw.TCBBorderBox( 0, BoxX+5, BoxY+30+5, BoxW/2-8, 50-10, TCBSettings.MainC )
	draw.DrawText( clip, "TCB_Premium_Fairview_28", BoxX+BoxW/4, BoxY+30+12, Color( 255, 255, 255, 255 ), 1 )

	--> Ammo
	draw.TCBBorderBox( 0, BoxX+BoxW/2+3, BoxY+30+5, BoxW/2-8, 50-10, TCBSettings.MainC )
	draw.DrawText( ammo, "TCB_Premium_Fairview_28", BoxX+BoxW/2+25, BoxY+30+12, Color( 255, 255, 255, 255 ), 1 )

	--> Title
	draw.TCBBorderBox( 0, BoxX+5, BoxY+5, BoxW-10, BoxH-55, TCBSettings.MainC )
	draw.DrawText( TCBSettings.Language["ammo"], "TCB_Premium_Fairview_28", BoxX+BoxW/2, BoxY+2, Color( 255, 255, 255, 255 ), 1 )

end
hook.Add( "HUDPaint", "AmmoHUD", AmmoHUD )


--[[---------------------------------------------------------
	Name: PlayerModel
-----------------------------------------------------------]]
local function PlayerModel()

	PlayerModel = vgui.Create("DModelPanel")
	function PlayerModel:LayoutEntity( Entity ) return end
	PlayerModel:SetModel( LocalPlayer():GetModel() )
	PlayerModel:SetPos( TCBSettings.X+TCBSettings.Space, TCBSettings.Y+TCBSettings.Space )
	PlayerModel:SetSize( TCBSettings.Height-TCBSettings.Space*2, TCBSettings.Height-TCBSettings.Space*2 )
	PlayerModel:SetCamPos(Vector( 16, 0, 65 ))
	PlayerModel:SetLookAt(Vector( 0, 0, 65 ))
	PlayerModel:ParentToHUD()
   
	timer.Create( "UpdatePlayerModel", 0.5, 0, function()
			if LocalPlayer():GetModel() != PlayerModel.Entity:GetModel() then
					PlayerModel:Remove()
					PlayerModel = vgui.Create("DModelPanel")
					function PlayerModel:LayoutEntity( Entity ) return end         
					PlayerModel:SetModel( LocalPlayer():GetModel())
					PlayerModel:SetPos( TCBSettings.X+TCBSettings.Space, TCBSettings.Y+TCBSettings.Space )
					PlayerModel:SetSize( TCBSettings.Height-TCBSettings.Space*2, TCBSettings.Height-TCBSettings.Space*2 )
					PlayerModel:SetCamPos(Vector( 16, 0, 65 ))
					PlayerModel:SetLookAt(Vector( 0, 0, 65 ))
					PlayerModel:ParentToHUD()
			end
	end)

end
hook.Add("InitPostEntity", "PlayerModel", PlayerModel)


--[[---------------------------------------------------------
	Name: Agenda
-----------------------------------------------------------]]
local agendaText
local function Agenda()

	--> Variables
	local agenda = LocalPlayer():getAgendaTable()
	if not agenda then return end

	agendaText = agendaText or DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 440)

	--> Background
	draw.TCBBorderBox( 0, 10, 10, 460, 110, TCBSettings.MainC )
	draw.TCBBorderBox( 0, 15, 15, 460-10, 20, TCBSettings.MainC )

	--> Text
	draw.DrawText( string.lower( agenda.Title ), "TCB_Premium_Fairview_24", 10+460/2, 11, Color( 255, 255, 255, 255 ), 1 )
	draw.DrawNonParsedText( string.lower( agendaText ), "TCB_Premium_Fairview_22", 20, 40, Color( 255, 255, 255, 255 ), 0)

end
hook.Add( "HUDPaint", "Agenda", Agenda )


--[[---------------------------------------------------------
	Name: DarkRPVarChanged
-----------------------------------------------------------]]
hook.Add("DarkRPVarChanged", "tcb_agendaHUD", function(ply, var, _, new)

	if ply ~= LocalPlayer() then return end
	if var == "agenda" and new then
		agendaText = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "TCB_Premium_Fairview_22", 440)
	else
		agendaText = nil
	end

end)


--[[---------------------------------------------------------
	Name: Default - TCBdrawPlayerInfo
-----------------------------------------------------------]]
local Page = Material("icon16/page_white_text.png")
local plyMeta = FindMetaTable("Player")
plyMeta.TCBdrawPlayerInfo = function(self) // plyMeta.TCBdrawPlayerInfo or
	local pos = self:EyePos()

	pos.z = pos.z + 10
	pos = pos:ToScreen()

	--> Background
	draw.TCBBorderBox( 0, pos.x-175/2+0, pos.y-60/2+0, 175-0, 60, TCBSettings.MainC )
	draw.TCBBorderBox( 0, pos.x-175/2+5, pos.y-60/2+5, 175-10, 20, TCBSettings.MainC )

	--> Health
	if GAMEMODE.Config.showhealth then

		draw.TCBBorderBox( 0, pos.x-175/2-20, pos.y-60/2+0, 15, 60, TCBSettings.MainC )

		HealthValue 	= math.Clamp( self:Health(), 0, 100 )
		HealthHeight 	= 60 / 100 * HealthValue
		draw.RoundedBox( 0, pos.x-175/2-20, (pos.y-60/2)+60-HealthHeight, 15, HealthHeight, Color( TCBSettings.Health.r, TCBSettings.Health.g, TCBSettings.Health.b, 255 ) )
		draw.DrawText( HealthValue, "TCB_Premium_Fairview_14", pos.x-175/2-14, pos.y-14/2, Color( 255, 255, 255, 255 ), 1 )

	end

	--> Level
	if TCBSettings.Modules["level"] then
		
		draw.TCBBorderBox( 0, pos.x+93, pos.y-60/2+0, 15, 60, TCBSettings.MainC )

		local PlayerXP 		= self:getDarkRPVar('xp') or 0
		local PlayerLevel 	= self:getDarkRPVar('level') or 0

		LevelValue 		= PlayerLevel
		LevelHeight 	= 60/100*math.Clamp(LevelValue, 0, 100)
		draw.RoundedBox( 0, pos.x+93, (pos.y-60/2)+60-LevelHeight, 15, LevelHeight, Color( TCBSettings.Level.r, TCBSettings.Level.g, TCBSettings.Level.b, 255 ) )
		draw.DrawText( LevelValue, "TCB_Premium_Fairview_14", pos.x+99, pos.y-14/2, Color( 255, 255, 255, 255 ), 1 )

	end

	--> Name
	draw.DrawText( TextOverflow(string.lower( self:Nick() ), "TCB_Premium_Fairview_18", 170 ), "TCB_Premium_Fairview_18", pos.x, pos.y-60/2+4, Color( 255, 255, 255, 255 ), 1 )
	
	--> Job
	local teamname = self:getDarkRPVar("job") or team.GetName(self:Team())
	draw.DrawText( TextOverflow(string.lower( teamname ), "TCB_Premium_Fairview_24", 170 ), "TCB_Premium_Fairview_24", pos.x, pos.y, Color( 255, 255, 255, 255 ), 1 )

	--> License
	if self:getDarkRPVar("HasGunlicense") then
		surface.SetMaterial(Page)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(pos.x-16, pos.y + 60, 32, 32)
	end
end


--[[---------------------------------------------------------
	Name: Default - TCBdrawWantedInfo
-----------------------------------------------------------]]
plyMeta.TCBdrawWantedInfo = plyMeta.TCBdrawWantedInfo or function(self)
	if not self:Alive() then return end

	local pos = self:EyePos()
	if not pos:isInSight({LocalPlayer(), self}) then return end

	pos.z = pos.z + 10
	pos = pos:ToScreen()

	local wantedText = DarkRP.getPhrase("wanted", tostring(self:getDarkRPVar("wantedReason")))

	draw.DrawNonParsedText(string.lower(wantedText), "TCB_Premium_Fairview_24", pos.x, pos.y - 85, Color( 255, 0, 0, 255 ), 1)
end


--[[---------------------------------------------------------
	Name: Default - DrawTCBEntityDisplay
-----------------------------------------------------------]]
local function DrawTCBEntityDisplay()
	local shootPos = LocalPlayer():GetShootPos()
	local aimVec = LocalPlayer():GetAimVector()

	if TCBSettings.Modules["head"] then
		for k, ply in pairs(player.GetAll()) do
			if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then continue end
			local hisPos = ply:GetShootPos()
			if ply:getDarkRPVar("wanted") then ply:TCBdrawWantedInfo() end

			if GAMEMODE.Config.globalshow then
				ply:TCBdrawPlayerInfo()
			elseif hisPos:DistToSqr(shootPos) < 160000 then
				local pos = hisPos - shootPos
				local unitPos = pos:GetNormalized()
				if unitPos:Dot(aimVec) > 0.95 then
					local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
					if trace.Hit and trace.Entity ~= ply then return end
					ply:TCBdrawPlayerInfo()
				end
			end
		end
	elseif TCBSettings.Modules["head_d"] then
		for k, ply in pairs(player.GetAll()) do
			if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then continue end
			local hisPos = ply:GetShootPos()
			if ply:getDarkRPVar("wanted") then ply:drawWantedInfo() end

			if GAMEMODE.Config.globalshow then
				ply:drawPlayerInfo()
			elseif hisPos:DistToSqr(shootPos) < 160000 then
				local pos = hisPos - shootPos
				local unitPos = pos:GetNormalized()
				if unitPos:Dot(aimVec) > 0.95 then
					local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
					if trace.Hit and trace.Entity ~= ply then return end
					ply:drawPlayerInfo()
				end
			end
		end
	end

	local tr = LocalPlayer():GetEyeTrace()

	if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) < 40000 then
		tr.Entity:drawOwnableInfo()
	end
end


--[[---------------------------------------------------------
	Name: Default - DisplayNotify
-----------------------------------------------------------]]
local function DisplayNotify(msg)
	local txt = msg:ReadString()
	GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("buttons/lightswitch2.wav")
	print(txt)
end
usermessage.Hook("_Notify", DisplayNotify)


--[[---------------------------------------------------------
	Name: DisplayDefaults
-----------------------------------------------------------]]
local function DisplayDefaults()
	DrawTCBEntityDisplay()
end
hook.Add( "HUDPaint", "DisplayDefaults", DisplayDefaults )