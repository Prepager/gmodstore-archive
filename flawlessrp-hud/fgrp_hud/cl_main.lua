--[[---------------------------------------------------------
	Variable Setup
-----------------------------------------------------------]]
local hudSettings = {}

--[[---------------------------------------------------------
	Settings
-----------------------------------------------------------]]
hudSettings.staminaEnabled = true
hudSettings.hungerEnabled = true
hudSettings.levelEnabled = true

--[[---------------------------------------------------------
	Hide
-----------------------------------------------------------]]
local hudHideElements = {
	["DarkRP_HUD"]				= true,
	["DarkRP_EntityDisplay"] 	= false,
	["DarkRP_ZombieInfo"] 		= false,
	["DarkRP_LocalPlayerHUD"] 	= true,
	["DarkRP_Hungermod"] 		= true,
	["DarkRP_Agenda"] 			= true,

	["CHudHealth"]				= true,
	["CHudBattery"]				= true,
	["CHudSuitPower"]			= true,
	["CHudAmmo"]				= true,
}

--[[---------------------------------------------------------
	Fonts
-----------------------------------------------------------]]
surface.CreateFont("FG_Font_HUD_24", {
	font = "FTY SKRADJHUWN NCV 3",
	size = 24,
})

--[[---------------------------------------------------------
	Element Draw
-----------------------------------------------------------]]
local function hideElements( element )
	if hudHideElements[ element ] then
		
		--> Return
		return false

	end
end
hook.Add("HUDShouldDraw", "hideElements", hideElements)

--[[---------------------------------------------------------
	HUDPaint
-----------------------------------------------------------]]
local function DrawFGHUD()

	--> Vehicle Speed & Ammo
	local weapon = LocalPlayer():GetActiveWeapon()
	if LocalPlayer():InVehicle() then

		local VehicleSpeed = math.ceil( LocalPlayer():GetVehicle():GetVelocity():Length() / (39370.0787 / 3600) )

		if VehicleSpeed == 1 then VehicleSpeed = 0 end

		local DrawBoxesValY = ScrH() - 38

		draw.RoundedBox(0, ScrW()/2-300/2+0, DrawBoxesValY-40-8+0, 300-0, 46-0, Color(0, 0, 0, 255))
		draw.RoundedBox(0, ScrW()/2-300/2+2, DrawBoxesValY-40-8+2, 300-4, 46-4, Color(60, 60, 60, 255))
		draw.RoundedBox(0, ScrW()/2-300/2+4, DrawBoxesValY-40-8+4, 300-8, 46-8, Color(40, 40, 40, 255))
	
		draw.RoundedBox(0, ScrW()/2-250/2+0, DrawBoxesValY-40+0, 250-0, 30-0, Color(0, 0, 0, 255))
		draw.RoundedBox(0, ScrW()/2-250/2+2, DrawBoxesValY-40+2, 250-4, 30-4, Color(115, 115, 115, 255))
		draw.RoundedBox(0, ScrW()/2-250/2+4, DrawBoxesValY-40+4, 250-8, 30-8, Color(90, 90, 90, 255))
		
		draw.DrawText("Vehicle Speed: " .. VehicleSpeed .. " KM/H", "FG_Font_HUD_24", ScrW()/2+1, DrawBoxesValY-40+4+1, Color(0,0,0,255), 1)
		draw.DrawText("Vehicle Speed: " .. VehicleSpeed .. " KM/H", "FG_Font_HUD_24", ScrW()/2+0, DrawBoxesValY-40+4+0, Color(255,255,255,255), 1)

	elseif weapon and IsValid( weapon ) then

		local clip = weapon:Clip1()
		local ammo = LocalPlayer():GetAmmoCount( weapon:GetPrimaryAmmoType() )
		
		if clip != -1 then
			local DrawBoxesValY = ScrH() - 38

			draw.RoundedBox(0, ScrW()/2-300/2+0, DrawBoxesValY-40-8+0, 300-0, 46-0, Color(0, 0, 0, 255))
			draw.RoundedBox(0, ScrW()/2-300/2+2, DrawBoxesValY-40-8+2, 300-4, 46-4, Color(60, 60, 60, 255))
			draw.RoundedBox(0, ScrW()/2-300/2+4, DrawBoxesValY-40-8+4, 300-8, 46-8, Color(40, 40, 40, 255))
		
			draw.RoundedBox(0, ScrW()/2-250/2+0, DrawBoxesValY-40+0, 250-0, 30-0, Color(0, 0, 0, 255))
			draw.RoundedBox(0, ScrW()/2-250/2+2, DrawBoxesValY-40+2, 250-4, 30-4, Color(115, 115, 115, 255))
			draw.RoundedBox(0, ScrW()/2-250/2+4, DrawBoxesValY-40+4, 250-8, 30-8, Color(90, 90, 90, 255))
			
			draw.DrawText("Ammo: "..clip.."/"..ammo, "FG_Font_HUD_24", ScrW()/2+1, DrawBoxesValY-40+4+1, Color(0,0,0,255), 1)
			draw.DrawText("Ammo: "..clip.."/"..ammo, "FG_Font_HUD_24", ScrW()/2+0, DrawBoxesValY-40+4+0, Color(255,255,255,255), 1)
		end

	end

	--> Top
	draw.RoundedBox(0, 0, 0, ScrW(), 46-0, Color(0, 0, 0, 255))
	draw.RoundedBox(0, 0, 2, ScrW(), 46-4, Color(60, 60, 60, 255))
	draw.RoundedBox(0, 0, 4, ScrW(), 46-8, Color(40, 40, 40, 255))

	--> Variables
	local PlayerHealth		= LocalPlayer():Health() or 0
	local PlayerArmor		= LocalPlayer():Armor()	or 0

	local PlayerStamina 	= LocalPlayer():GetNWInt( "tcb_stamina" ) or 0
	local PlayerHunger 		= math.ceil( LocalPlayer():getDarkRPVar( "Energy" ) or 0 )

	local PlayerLevel = LocalPlayer():getDarkRPVar('level') or 0
	local PlayerXP = LocalPlayer():getDarkRPVar('xp') or 0

	--> Function Variables
	local topCount = 2
	if hudSettings.staminaEnabled then
		topCount = topCount + 1
	end

	if hudSettings.hungerEnabled then
		topCount = topCount + 1
	end

	if hudSettings.levelEnabled then
		topCount = topCount + 1
	end

	local DrawBoxesBarX = 20
	local DrawBoxesBarY = 8
	local DrawBowesBarW	= (ScrW() -  25) / topCount - 20

	--> Draw Function
	function HUDPlayerVal( text, color1, color2, value, drawvalue, extra, percentage, colred )

		draw.RoundedBox(0, DrawBoxesBarX+0, DrawBoxesBarY+0, DrawBowesBarW-0, 30-0, Color(0, 0, 0, 255))
		draw.RoundedBox(0, DrawBoxesBarX+2, DrawBoxesBarY+2, DrawBowesBarW-4, 30-4, Color(115, 115, 115, 255))
		draw.RoundedBox(0, DrawBoxesBarX+4, DrawBoxesBarY+4, DrawBowesBarW-8, 30-8, Color(90, 90, 90, 255))
		
		local echo_value 	= value
		local draw_value	= value
		
		if draw_value > 100 then draw_value = 100 	end
		if draw_value < 0	then draw_value = 0		end
		
		if value > 0 then
			draw.RoundedBox(0, DrawBoxesBarX+2, DrawBoxesBarY+2, drawvalue-4, 30-4, color1)
			draw.RoundedBox(0, DrawBoxesBarX+4, DrawBoxesBarY+4, drawvalue-8, 30-8, color2)
		end

		local pSymbol = "%"
		if percentage then
			pSymbol = ""
		end

		if extra == 0 then

			draw.DrawText(text..echo_value..pSymbol, "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+1, DrawBoxesBarY+3+1, Color(0,0,0,255), 1)

			if !colred and echo_value <= 15 then
				draw.DrawText(text..echo_value..pSymbol, "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+0, DrawBoxesBarY+3+0, Color(255,100,100,255), 1)
			else
				draw.DrawText(text..echo_value..pSymbol, "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+0, DrawBoxesBarY+3+0, Color(255,255,255,255), 1)
			end

		elseif extra == 1 then

			if echo_value <= 0 then
				draw.DrawText(text.."Dead", "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+1, DrawBoxesBarY+3+1, Color(0,0,0,255), 1)
			else
				draw.DrawText(text..echo_value..pSymbol, "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+1, DrawBoxesBarY+3+1, Color(0,0,0,255), 1)
			end

			if echo_value <= 15 and echo_value > 0 then
				draw.DrawText(text..echo_value..pSymbol, "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+0, DrawBoxesBarY+3+0, Color(255,100,100,255), 1)
			elseif echo_value > 15 then
				draw.DrawText(text..echo_value..pSymbol, "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+0, DrawBoxesBarY+3+0, Color(255,255,255,255), 1)
			elseif echo_value <= 0 then
				draw.DrawText(text.."Dead", "FG_Font_HUD_24", DrawBoxesBarX + DrawBowesBarW/2+0, DrawBoxesBarY+3+0, Color(255,100,100,255), 1)
			end

		end
		
		DrawBoxesBarX 	= DrawBoxesBarX + DrawBowesBarW + 20

	end

	--> Make Elements
	HUDPlayerVal("Health: ", Color(255, 25, 25, 255), Color(0, 0, 0, 125), PlayerHealth, DrawBowesBarW * PlayerHealth / 100, 1 )
	HUDPlayerVal("Armor: ", Color(40, 175, 255, 255), Color(0, 0, 0, 125), PlayerArmor, DrawBowesBarW * PlayerArmor / 100, 0 )

	if hudSettings.staminaEnabled then
		HUDPlayerVal("Stamina: ", Color(75, 255, 50, 255), Color(0, 0, 0, 125), PlayerStamina, DrawBowesBarW * PlayerStamina/ 100, 0 )
	end

	if hudSettings.hungerEnabled then
		HUDPlayerVal("Hunger: ", Color(220, 0, 255, 255), Color(0, 0, 0, 125), PlayerHunger, DrawBowesBarW * PlayerHunger/ 100, 0 )
	end

	if hudSettings.levelEnabled then
		local percentage = ((PlayerXP or 0)/(((10+(((PlayerLevel or 1)*((PlayerLevel or 1)+1)*90))))*LevelSystemConfiguration.XPMult))
		HUDPlayerVal("Level: ", Color(230, 160, 34, 255), Color(0, 0, 0, 125), PlayerLevel, DrawBowesBarW * percentage, 0, true, true )
	end

	--> Lockdown
	if GetGlobalBool("DarkRP_LockDown") then
		local cin = (math.sin(CurTime()) + 1) / 2
		draw.DrawNonParsedText(DarkRP.getPhrase("lockdown_started"), "FG_Font_HUD_24", ScrW()/2, 60, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_CENTER)
	end

	--> Agenda
	local agenda = LocalPlayer():getAgendaTable()
	if agenda then
		agendaText = DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "FG_Font_HUD_24", 440)

		draw.RoundedBox(0, 10, 60, 460, 110-0, Color(0, 0, 0, 150))
		draw.RoundedBox(0, 12, 62, 456, 110-4, Color(60, 60, 60, 150))
		draw.RoundedBox(0, 14, 64, 452, 110-8, Color(40, 40, 40, 150))

		draw.DrawNonParsedText(agenda.Title, "FG_Font_HUD_24", 25, 65, Color(255, 0, 0, 255), 0)
		draw.DrawNonParsedText(agendaText, "FG_Font_HUD_24", 25, 90, Color(255, 255, 255, 255), 0)
	end

	--> Bottom
	draw.RoundedBox(0, 0, ScrH() - 46 + 0, ScrW(), 46-0, Color(0, 0, 0, 255))
	draw.RoundedBox(0, 0, ScrH() - 46 + 2, ScrW(), 46-4, Color(60, 60, 60, 255))
	draw.RoundedBox(0, 0, ScrH() - 46 + 4, ScrW(), 46-8, Color(40, 40, 40, 255))

	--> Function Variables
	local DrawBoxesValX = 20
	local DrawBoxesValY = ScrH() - 38
	local DrawBowesValW	= (ScrW() -  25) / 4 - 20

	--> Draw Function
	function HUDPlayerVal( text, value )

		draw.RoundedBox(0, DrawBoxesValX+0, DrawBoxesValY+0, DrawBowesValW-0, 30-0, Color(0, 0, 0, 255))
		draw.RoundedBox(0, DrawBoxesValX+2, DrawBoxesValY+2, DrawBowesValW-4, 30-4, Color(115, 115, 115, 255))
		draw.RoundedBox(0, DrawBoxesValX+4, DrawBoxesValY+4, DrawBowesValW-8, 30-8, Color(90, 90, 90, 255))
		
		draw.DrawText(text..value, "FG_Font_HUD_24", DrawBoxesValX + DrawBowesValW/2+1, DrawBoxesValY+4+1, Color(0,0,0,255), 1)
		draw.DrawText(text..value, "FG_Font_HUD_24", DrawBoxesValX + DrawBowesValW/2+0, DrawBoxesValY+4+0, Color(255,255,255,255), 1)
		
		DrawBoxesValX 	= DrawBoxesValX + DrawBowesValW + 20

	end

	--> Make Elements
	HUDPlayerVal("Name: ", LocalPlayer():Nick() or "")
	HUDPlayerVal("Job: ", LocalPlayer():getDarkRPVar("job") or "")
	HUDPlayerVal("Wallet: ", DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money") or 0))
	HUDPlayerVal("Salary: ", DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary") or 0))

end
hook.Add("HUDPaint", "DrawFGHUD", DrawFGHUD)