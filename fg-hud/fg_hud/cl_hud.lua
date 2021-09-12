--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local HUD 		= {}

HUD.Settings 	= {}
HUD.Values 		= {}


--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]
HUD.Settings.Width 		= 350
HUD.Settings.Height 	= 28//88


--[[---------------------------------------------------------
	Name: Values
-----------------------------------------------------------]]
HUD.Values.PosX 		= 10
HUD.Values.PosY 		= ScrH() - 10--- HUD.Settings.Height


--[[---------------------------------------------------------
	Name: Modules
-----------------------------------------------------------]]
HUD.Modules = {
	["health"] 	= true,
	["armor"]	= true,
	["hunger"]	= false,	// Requirement: Hungermod enabled.
	["stamina"]	= false, 	// Requirement: TCB Stamina installed.	(http://www.thecodingbeast.com/products)
	["level"]	= false, 	// Requirement: Vrondakis level system. (https://github.com/vrondakis/DarkRP-Leveling-System)
}


--[[---------------------------------------------------------
	Name: Height
-----------------------------------------------------------]]
for k,v in pairs(HUD.Modules) do if v then HUD.Settings.Height = HUD.Settings.Height + 20 end end


--[[---------------------------------------------------------
	Name: Fonts
-----------------------------------------------------------]]
surface.CreateFont( "FG-HUD-12", {
	font = "TargetID",
	size = 12,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


--[[---------------------------------------------------------
	Name: HUDShouldDraw
-----------------------------------------------------------]]
local HideElements = { "DarkRP_HUD", "DarkRP_LocalPlayerHUD", "DarkRP_EntityDisplay", "DarkRP_Agenda", "DarkRP_Hungermod" }

local function HUDShouldDraw( Element )

	if table.HasValue( HideElements, Element ) then return false end

end
hook.Add( "HUDShouldDraw", "HUDShouldDraw", HUDShouldDraw )


--[[---------------------------------------------------------
	Name: FormatNumber
-----------------------------------------------------------]]
function FormatNumber( n )

	if not n then return "" end

	if n >= 1e14 then return tostring(n) end
	n = tostring(n)
	local sep = sep or ","
	local dp = string.find(n, "%.") or #n+1

	for i=dp-4, 1, -3 do

		n = n:sub(1, i) .. sep .. n:sub(i+1)

	end

	return n

end


--[[---------------------------------------------------------
	Name: BarDesign
-----------------------------------------------------------]]
local function BarDesign( value, title, x, y, w, h, color )

	--> Value
	local BarValue1 = value or 0
	local BarValue2 = value or 0
	if BarValue1 > 100 then BarValue1 = 100 end

	--> Background
	draw.RoundedBox( 0, x, y-3, w, 2, Color( 180, 180, 180, 255 ) )
	draw.RoundedBox( 0, x+65, y+2, w-110, 12, Color( 0, 0, 0, 30 ) )

	--> Title
	draw.DrawText( title, "FG_JaapokkiRegular_20", x+65/2, y-1, Color( 0, 0, 0, 255 ), 1 )

	--> Value
	if BarValue1 > 0 then
		draw.RoundedBox( 0, x+65, y+2, (w-110)/100*BarValue1, 12, color )
		draw.RoundedBox( 0, x+65, y+2, (w-110)/100*BarValue1, 12/2, Color( 255, 255, 255, 10 ) )
	end

	draw.DrawText( BarValue2 .. "%", "FG_JaapokkiRegular_17", x+65+w-85, y+1, Color( 50, 50, 50, 255 ), 1 )

end


--[[---------------------------------------------------------
	Name: Materials
-----------------------------------------------------------]]
local VoiceChatTexture 	= surface.GetTextureID("voice/icntlk_pl")
local GunLicenseTexture = Material("icon16/page_white_text.png")
local WantedTexture		= Material("icon16/exclamation.png")


--[[---------------------------------------------------------
	Name: Arrested
-----------------------------------------------------------]]
local Arrested = function() end

usermessage.Hook("GotArrested", function(msg)

	local StartArrested = CurTime()
	local ArrestedUntil = msg:ReadFloat()

	Arrested = function()
		if CurTime() - StartArrested <= ArrestedUntil and LocalPlayer():getDarkRPVar("Arrested") then

			--> Variables
			local cin = (math.sin(CurTime()) + 1) / 2

			--> Background
			draw.RoundedBox( 0, ScrW()/2-145, 75, 290, 30, Color(cin * 255, 0, 255 - (cin * 255), 255) )
			draw.DrawText( DarkRP.getPhrase( "youre_arrested", math.ceil( ArrestedUntil - ( CurTime() - StartArrested ) ) ), "FG_JaapokkiRegular_22", ScrW()/2, 82, Color( 255, 255, 255, 255 ), 1 )

		elseif not LocalPlayer():getDarkRPVar("Arrested") then

			Arrested = function() end

		end
	end

end)


--[[---------------------------------------------------------
	Name: HUDPaint
-----------------------------------------------------------]]
local function HUDPaint()

	--[[---------------------------------------------------------
		Name: Camera Support
	-----------------------------------------------------------]]
	if IsValid( LocalPlayer():GetActiveWeapon() ) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_camera" then return end


	--[[---------------------------------------------------------
		Name: Variables
	-----------------------------------------------------------]]
	local w = HUD.Settings.Width
	local h = HUD.Settings.Height

	local x = HUD.Values.PosX
	local y = HUD.Values.PosY


	--[[---------------------------------------------------------
		Name: Props
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x+w+10+0, y-20+0, 120-0, 20-0, Color( 0, 0, 0, 220 ) )
	draw.RoundedBox( 0, x+w+10+1, y-20+1, 120-2, 20-2, Color( 240, 240, 240, 220 ) )

	draw.DrawText( "PROPS:", "FG_JaapokkiRegular_20", x+w+14, y-20+2, Color( 0, 0, 0, 255 ), 0 )

	draw.DrawText( LocalPlayer():GetCount( "props" ) .. "/" .. cvars.Number( "sbox_maxprops" ), "FG_JaapokkiRegular_20", x+w+92, y-20+2, Color( 50, 50, 50, 255 ), 1 )


	--[[---------------------------------------------------------
		Name: Background
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x-1, y-h-1, w+2, h+2, Color( 0, 0, 0, 200 ) )
	draw.RoundedBox( 0, x-0, y-h-0, w+0, h+0, Color( 240, 240, 240, 220 ) )
	y = y - 17


	--[[---------------------------------------------------------
		Name: Stamina
	-----------------------------------------------------------]]
	if HUD.Modules["level"] then

		--> Value
		local PlayerXP 		= LocalPlayer():getDarkRPVar('xp') or 0
		local PlayerLevel 	= LocalPlayer():getDarkRPVar('level') or 0

		local value = math.Round(((PlayerXP or 0)/(((10+(((PlayerLevel or 1)*((PlayerLevel or 1)+1)*90))))*LevelSystemConfiguration.XPMult)) * 100)

		--> Bar
		BarDesign( value, "Level: " .. PlayerLevel, x, y, w, 12, Color( 142, 68, 173, 255 ) )

		--> Values
		y = y - 20


	end


	--[[---------------------------------------------------------
		Name: Stamina
	-----------------------------------------------------------]]
	if HUD.Modules["stamina"] then

		--> Value
		local value = LocalPlayer():GetNWInt( "tcb_stamina" ) or 0

		--> Bar
		BarDesign( value, "Stamina", x, y, w, 12, Color( 39, 174, 96, 255 ) )

		--> Values
		y = y - 20


	end


	--[[---------------------------------------------------------
		Name: Hunger
	-----------------------------------------------------------]]
	if HUD.Modules["hunger"] then

		--> Value
		local value = math.ceil( LocalPlayer():getDarkRPVar( "Energy" ) or 0 )

		--> Bar
		BarDesign( value, "Hunger", x, y, w, 12, Color( 211, 84, 0, 255 ) )

		--> Values
		y = y - 20


	end


	--[[---------------------------------------------------------
		Name: Armor
	-----------------------------------------------------------]]
	if HUD.Modules["armor"] then

		--> Value
		local value = LocalPlayer():Armor() or 0

		--> Bar
		BarDesign( value, "Armor", x, y, w, 12, Color( 41, 128, 185, 225 ) )

		--> Values
		y = y - 20


	end


	--[[---------------------------------------------------------
		Name: Health
	-----------------------------------------------------------]]
	if HUD.Modules["health"] then

		--> Value
		local value = LocalPlayer():Health() or 0


		--> Bar
		BarDesign( value, "Health", x, y, w, 12, Color( 192, 57, 43, 255 ) )

		--> Values
		y = y - 20


	end


	--[[---------------------------------------------------------
		Name: Title
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x, y-12, w, 30, Color( 40, 40, 50, 255 ) )
	draw.DrawText( LocalPlayer():Nick(), "FG_JaapokkiRegular_24", 10+w/2, y-8, Color( 225, 225, 225, 255 ), 1 )


	--[[---------------------------------------------------------
		Name: Variables
	-----------------------------------------------------------]]
	local y = y-108
	local h1 = h
	local h2 = 88


	--[[---------------------------------------------------------
		Name: Background
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x-1, y-1, w+2, h2+2, Color( 0, 0, 0, 200 ) )
	draw.RoundedBox( 0, x-0, y-0, w+0, h2+0, Color( 240, 240, 240, 220 ) )


	--[[---------------------------------------------------------
		Name: Money & Salary
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x+w/2-1, y+30, 2, h2-30, Color( 0, 0, 0, 30 ) )
	draw.RoundedBox( 0, x, y+55, w, 2, Color( 0, 0, 0, 30 ) )

	draw.DrawText( "Money", "FG_JaapokkiRegular_22", x+(w/2*1)/2, y+34, Color( 0, 0, 0, 255 ), 1 )
	draw.DrawText( "Salary", "FG_JaapokkiRegular_22", x+(w/2*3)/2, y+34, Color( 0, 0, 0, 255 ), 1 )

	draw.DrawText( "$" .. FormatNumber( LocalPlayer():getDarkRPVar( "money" ) or 0 ), "FG_JaapokkiRegular_20", x+(w/2*1)/2, y+65, Color( 50, 50, 50, 255 ), 1 )
	draw.DrawText( "$" .. FormatNumber( LocalPlayer():getDarkRPVar( "salary" ) or 0 ), "FG_JaapokkiRegular_20", x+(w/2*3)/2, y+65, Color( 50, 50, 50, 255 ), 1 )


	--[[---------------------------------------------------------
		Name: Title
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x, y, w, 30, Color( 40, 40, 50, 255 ) )
	draw.DrawText( LocalPlayer():getDarkRPVar( "job" ) or "", "FG_JaapokkiRegular_24", 10+w/2, y+4, Color( 225, 225, 225, 255 ), 1 )


	--[[---------------------------------------------------------
	Name: Lockdown
	-----------------------------------------------------------]]
	if GetGlobalBool("DarkRP_LockDown") then

		--> Variables
		local cin = (math.sin(CurTime()) + 1) / 2

		--> Background
		draw.RoundedBox( 0, ScrW()/2-130, 10, 260, 55, Color(cin * 255, 0, 255 - (cin * 255), 255) )
		draw.DrawText( "The mayor has initialized a lockdown!", "FG_JaapokkiRegular_22", ScrW()/2, 20, Color( 255, 255, 255, 255 ), 1 )
		draw.DrawText( "Return to your homes!", "FG_JaapokkiRegular_22", ScrW()/2, 40, Color( 255, 255, 255, 255 ), 1 )

	end


	--[[---------------------------------------------------------
	Name: Voice Icon
	-----------------------------------------------------------]]
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


	--[[---------------------------------------------------------
	Name: Arrested
	-----------------------------------------------------------]]
	Arrested()


	--[[---------------------------------------------------------
		Name: Icons
	-----------------------------------------------------------]]
	if LocalPlayer():getDarkRPVar("HasGunlicense") then
		surface.SetDrawColor(255, 255, 255, 255)
	else
		surface.SetDrawColor(25,25,25,255)
	end
	surface.SetMaterial(GunLicenseTexture)
	surface.DrawTexturedRect(x+w-25, y+5, 20, 20)


	if LocalPlayer():getDarkRPVar("wanted") then
		surface.SetDrawColor(255, 255, 255, 255)
	else
		surface.SetDrawColor(25,25,25,255)
	end
	surface.SetMaterial(WantedTexture)
	surface.DrawTexturedRect(x+w-50, y+5, 20, 20)


end
hook.Add( "HUDPaint", "FG-Local-HUDPaint", HUDPaint )


--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local plyMeta = FindMetaTable("Player")


--[[---------------------------------------------------------
	Name: drawPlayerInfo
-----------------------------------------------------------]]
plyMeta.drawPlayerInfo = function( self )

	--[[---------------------------------------------------------
		Name: Position
	-----------------------------------------------------------]]
	local pos = self:EyePos()
	pos.z = pos.z + 10
	pos = pos:ToScreen()


	--[[---------------------------------------------------------
		Name: Variables
	-----------------------------------------------------------]]
	local w = 200
	local h = 90

	local x = pos.x
	local y = pos.y

	local g = self:GetNWString( "usergroup" )


	--[[---------------------------------------------------------
		Name: Background
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x-w/2-1, y-h-1, w+2, h+2, Color( 0, 0, 0, 150 ) )
	draw.RoundedBox( 0, x-w/2-0, y-h-0, w+0, h+0, Color( 240, 240, 240, 170 ) )


	--[[---------------------------------------------------------
		Name: Name
	-----------------------------------------------------------]]
	draw.RoundedBox( 0, x-w/2, y-h, w, 30, Color( 40, 40, 50, 255 ) )
	draw.DrawText( self:Nick(), "FG_JaapokkiRegular_24", x, y-h+4, Color( 225, 225, 225, 255 ), 1 )


	--[[---------------------------------------------------------
		Name: Job
	-----------------------------------------------------------]]
	draw.DrawText( "Job: " .. team.GetName( self:Team() ), "FG_JaapokkiRegular_22", x, y-h+40, Color( 0, 0, 0, 255 ), 1 )
	draw.RoundedBox( 0, x-w/2, y-h+64, w-2, 2, Color( 0, 0, 0, 30 ) )

	draw.DrawText( "Rank: " .. string.upper( g ), "FG_JaapokkiRegular_20", x, y-h+69, Color( 50, 50, 50, 255 ), 1 )


	--[[---------------------------------------------------------
		Name: License
	-----------------------------------------------------------]]
	if self:getDarkRPVar("HasGunlicense") then
		surface.SetMaterial(GunLicenseTexture)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x-32/2, y+10, 32, 32)
	end


	--[[---------------------------------------------------------
		Name: Level
	-----------------------------------------------------------]]
	if HUD.Modules["level"] then
		local level = self:getDarkRPVar('level') or 0
		draw.DrawText( "Level: " .. level, "FG_JaapokkiRegular_24", x, y-h-25, Color( 255, 255, 255, 255 ), 1 )
	end


	--[[---------------------------------------------------------
		Name: Health
	-----------------------------------------------------------]]
	if GAMEMODE.Config.showhealth then

		local HealthValue 	= math.Clamp( self:Health(), 0, 100 )
		local HealthHeight 	= h / 100 * HealthValue

		draw.RoundedBox( 0, x-w/2-21-1, y-h-1, 16+1, h+2, Color( 0, 0, 0, 150 ) )
		draw.RoundedBox( 0, x-w/2-21-0, y-h-0, 16+0, h+0, Color( 240, 240, 240, 170 ) )

		draw.RoundedBox( 0, x-w/2-21-0, y-h+1+h-HealthHeight, 16+0, HealthHeight, Color( 2192, 57, 43, 230 ) )
		draw.DrawText( self:Health(), "FG_JaapokkiRegular_14", x-w/2-14-0, y-h/2-14/2, Color( 255, 255, 255, 255 ), 1 )
	end

end


--[[---------------------------------------------------------
	Name: drawWantedInfo
-----------------------------------------------------------]]
plyMeta.drawWantedInfo = function( self )

	--[[---------------------------------------------------------
		Name: Alive Check
	-----------------------------------------------------------]]
	if not self:Alive() then return end

	--[[---------------------------------------------------------
		Name: Position
	-----------------------------------------------------------]]
	local pos = self:EyePos()
	if not pos:isInSight({LocalPlayer(), self}) then return end

	pos.z = pos.z + 10
	pos = pos:ToScreen()


	--[[---------------------------------------------------------
		Name: Variables
	-----------------------------------------------------------]]
	local w = 200
	local h = 90

	local x = pos.x
	local y = pos.y


	--[[---------------------------------------------------------
		Name: Wanted
	-----------------------------------------------------------]]
	draw.DrawText( "WANTED", "FG_JaapokkiRegular_26", x+1, y-h-30+1, Color( 0, 0, 0, 255 ), 1 )
	draw.DrawText( "WANTED", "FG_JaapokkiRegular_26", x+1, y-h-30+0, Color( 0, 0, 0, 255 ), 1 )
	draw.DrawText( "WANTED", "FG_JaapokkiRegular_26", x+0, y-h-30+1, Color( 0, 0, 0, 255 ), 1 )
	draw.DrawText( "WANTED", "FG_JaapokkiRegular_26", x+0, y-h-30+0, Color( 0, 0, 0, 255 ), 1 )

	draw.DrawText( "WANTED", "FG_JaapokkiRegular_26", x, y-h-30, Color( 225, 0, 0, 255 ), 1 )

end


--[[---------------------------------------------------------
	Name: DrawEntityDisplay
-----------------------------------------------------------]]
local function DrawEntityDisplay()

	local shootPos = LocalPlayer():GetShootPos()
	local aimVec = LocalPlayer():GetAimVector()

	for k, ply in pairs(players or player.GetAll()) do
		if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then continue end
		local hisPos = ply:GetShootPos()
		if ply:getDarkRPVar("wanted") then ply:drawWantedInfo() end

		if hisPos:DistToSqr(shootPos) < 160000 then
			local pos = hisPos - shootPos
			local unitPos = pos:GetNormalized()
			if unitPos:Dot(aimVec) > 0.95 then
				local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
				if trace.Hit and trace.Entity ~= ply then return end
				ply:drawPlayerInfo()
			end
		end
	end

	local tr = LocalPlayer():GetEyeTrace()

	if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) < 40000 then
		tr.Entity:drawOwnableInfo()
	end

end
hook.Add( "HUDPaint", "FG-Entity-HUDPaint", DrawEntityDisplay )


--[[---------------------------------------------------------
	Name: DrawAgenda
-----------------------------------------------------------]]
local agendaText
local function DrawAgenda()

	--> Variables
	local agenda = LocalPlayer():getAgendaTable()
	if not agenda then return end

	--> Text
	agendaText = agendaText or DarkRP.textWrap( ( LocalPlayer():getDarkRPVar( "agenda" ) or "" ):gsub( "//", "\n" ):gsub( "\\n", "\n" ), "FG_JaapokkiRegular_26", 440 )

	--> Background
	draw.RoundedBox( 0, 10-1, 10-1, 460+2, 110+2, Color( 0, 0, 0, 200 ) )
	draw.RoundedBox( 0, 10-0, 10-0, 460+0, 110+0, Color( 240, 240, 240, 200 ) )

	--> Title
	draw.RoundedBox( 0, 10, 10, 460, 30, Color( 40, 40, 50, 255 ) )
	draw.DrawText( agenda.Title, "FG_JaapokkiRegular_24", 10+460/2, 15, Color( 225, 225, 225, 255 ), 1 )
	draw.DrawText( agendaText, "FG_JaapokkiRegular_24", 20, 44, Color( 0, 0, 0, 255 ) )

end
hook.Add( "HUDPaint", "DrawAgenda", DrawAgenda )


--[[---------------------------------------------------------
	Name: DrawAgenda
-----------------------------------------------------------]]
hook.Add( "DarkRPVarChanged", "AgendaUpdate", function( ply, var, _, new )

	--> Check
	if ply != LocalPlayer() then return end

	--> Agenda Update
	if var == "agenda" and new then

		agendaText = DarkRP.textWrap( new:gsub( "//", "\n" ):gsub( "\\n", "\n" ), "FG_JaapokkiRegular_26", 440 )
	else

		agendaText = nil

	end

end )
