--[[---------------------------------------------------------
	Variable Setup
-----------------------------------------------------------]]
local hudElements = {}
local hudSettings = {}

--[[---------------------------------------------------------
	Settings
-----------------------------------------------------------]]
hudSettings.placement 	= 'Right'
hudSettings.offset_x 	= '25'
hudSettings.offset_y 	= '25'
hudSettings.spacing 	= '5'
hudSettings.size 		= '1'

--[[---------------------------------------------------------
	Convars
-----------------------------------------------------------]]
CreateClientConVar('rusthud_placement', hudSettings.placement, true)
CreateClientConVar('rusthud_offset_x', hudSettings.offset_x, true)
CreateClientConVar('rusthud_offset_y', hudSettings.offset_y, true)
CreateClientConVar('rusthud_spacing', hudSettings.spacing, true)
CreateClientConVar('rusthud_size', hudSettings.size, true)

--[[---------------------------------------------------------
	Hide
-----------------------------------------------------------]]
local hudHideElements = {
	["DarkRP_HUD"]				= false,
	["DarkRP_EntityDisplay"] 	= false,
	["DarkRP_ZombieInfo"] 		= false,
	["DarkRP_LocalPlayerHUD"] 	= true,
	["DarkRP_Hungermod"] 		= true,
	["DarkRP_Agenda"] 			= false,

	["CHudHealth"]				= true,
	["CHudBattery"]				= true,
	["CHudSuitPower"]			= true,
	["CHudAmmo"]				= true,
}

--[[---------------------------------------------------------
	Materials
-----------------------------------------------------------]]
local iconHealth 	= Material("rusthud/health.png", "smooth unlitgeneric")
local iconArmor 	= Material("rusthud/armor.png", "smooth unlitgeneric")
local iconStamina 	= Material("rusthud/stamina.png", "smooth unlitgeneric")
local iconHunger 	= Material("rusthud/hunger.png", "smooth unlitgeneric")
local iconMoney 	= Material("rusthud/money.png", "smooth unlitgeneric")
local iconSalary 	= Material("rusthud/salary.png", "smooth unlitgeneric")

--[[---------------------------------------------------------
	Fonts
-----------------------------------------------------------]]
for i=0,34 do

	--> Size
	local size = 12+i

	--> Font
	surface.CreateFont("RustHUD_"..size, {
		font = "Trebuchet24",
		size = size,
	})

end

--[[---------------------------------------------------------
	Elements Setup
-----------------------------------------------------------]]
table.Add(hudElements, {{
	name = "Health",
	icon = iconHealth,
	color = Color(231, 76, 60),
	bar = true,
	hide = true,
	min = function(ply) return 0 end,
	max = function(ply) return ply:GetMaxHealth() or 100 end,
	value = function(ply) return ply:Health() or 0 end
}})

table.Add(hudElements, {{
	name = "Armor",
	icon = iconArmor,
	color = Color(52, 152, 219),
	bar = true,
	hide = true,
	min = function(ply) return 0 end,
	max = function(ply) return 100 end,
	value = function(ply) return ply:Armor() or 0 end
}})

table.Add(hudElements, {{
	name = "Stamina",
	icon = iconStamina,
	color = Color(46, 204, 113),
	bar = true,
	hide = true,
	min = function(ply) return 0 end,
	max = function(ply) return 100 end,
	value = function(ply) return LocalPlayer():GetNWInt( "tcb_stamina" ) or 10 end
}})

table.Add(hudElements, {{
	name = "Hunger",
	icon = iconHunger,
	color = Color(230, 126, 34),
	bar = true,
	hide = true,
	min = function(ply) return 0 end,
	max = function(ply) return 100 end,
	value = function(ply) return math.ceil( LocalPlayer():getDarkRPVar( "Energy" ) or 0 ) end
}})

table.Add(hudElements, {{
	name = "Money",
	icon = iconMoney,
	color = Color(46, 204, 113),
	bar = false,
	hide = false,
	value = function(ply) return DarkRP.formatMoney(ply:getDarkRPVar( "money" )) or 0 end
}})

table.Add(hudElements, {{
	name = "Salary",
	icon = iconSalary,
	color = Color(46, 204, 113),
	bar = false,
	hide = false,
	value = function(ply) return DarkRP.formatMoney(ply:getDarkRPVar("salary")) or 0 end
}})

hudElements = table.Reverse(hudElements)

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
local function DrawRustHUD()

	--> Convars
	local hudM = 1
	local hudS = 5
	local hudP = "right"
	local hudOX = 25
	local hudOY = 25

	if ConVarExists('rusthud_size') then hudM = GetConVar('rusthud_size'):GetFloat() end

	if ConVarExists('rusthud_offset_x') then hudOX = GetConVar('rusthud_offset_x'):GetInt() end
	if ConVarExists('rusthud_offset_y') then hudOY = GetConVar('rusthud_offset_y'):GetInt() end
	if ConVarExists('rusthud_spacing') then hudS = GetConVar('rusthud_spacing'):GetInt() end

	if ConVarExists('rusthud_placement') then hudP = GetConVar('rusthud_placement'):GetString() end

	--> Variables
	local hudY = (42*hudM) + hudOY

	--> Elements
	for _,v in ipairs(hudElements) do

		--> Hide
		if v.hide and v.value(LocalPlayer()) == v.min(LocalPlayer()) then continue end

		--> Variables
		local curX = ScrW() - (300*hudM) - hudOX
		local curY = ScrH() - hudY

		--> Convars
		if hudP == "left" or hudP == "Left" then
			curX = hudOX
			curY = ScrH() - hudY
		end

		--> Background
		draw.RoundedBox(math.Round(2*hudM), curX+0, curY+0, (300*hudM)-0, (42*hudM)-0, Color(0, 0, 0, 25))
		draw.RoundedBox(math.Round(2*hudM), curX+1, curY+1, (300*hudM)-2, (42*hudM)-2, Color(0, 0, 0, 125))

		--> Icon
		if v.icon != "" then
			surface.SetDrawColor(255, 255, 255, 225)
			surface.SetMaterial(v.icon)
			surface.DrawTexturedRect( curX+(7*hudM), curY+(6*hudM), 30*hudM, 30*hudM)
		else
			draw.RoundedBox(0, curX+(7*hudM), curY+(6*hudM), 30*hudM, 30*hudM, Color(0, 0, 0, 225))
		end

		--> Text
		draw.SimpleText(v.value(LocalPlayer()), "RustHUD_"..math.Round(24*hudM), curX+(50*hudM)-(6*hudM)+(250*hudM)/2, curY+(21*hudM), Color(255, 255, 255, 240), 1, 1)

		--> Bar
		if v.bar then
			
			--> Values
			local curVal = v.value(LocalPlayer())
			local curMin = v.min(LocalPlayer())
			local curMax = v.max(LocalPlayer())

			if curVal > curMax then curVal = curMax elseif curVal < curMin then curVal = curMin end

			--> Variables
			local curW = 250*hudM / curMax * curVal

			--> Draw
			draw.RoundedBox(math.Round(2*hudM), curX+(50*hudM)-(6*hudM), curY+(6*hudM), curW, 30*hudM, Color( v.color.r, v.color.g, v.color.b, 150 ))

		else

			--> Draw
			draw.RoundedBox(math.Round(2*hudM), curX+(50*hudM)-(6*hudM), curY+(6*hudM), 250*hudM, 30*hudM, Color( v.color.r, v.color.g, v.color.b, 150 ))

		end

		--> Variables
		hudY = hudY + hudS + (40*hudM)

	end

	--> Variables
	local curX = hudOX
	local curY = ScrH() - (60*hudM) - hudOY

	--> Convars
	if hudP == "left" or hudP == "Left" then
		curX = ScrW() - (100*hudM) - hudOX
	end

	--> Ammo
	local weapon = LocalPlayer():GetActiveWeapon()
	if weapon and IsValid( weapon ) then

		local clip = weapon:Clip1()
		local ammo = LocalPlayer():GetAmmoCount( weapon:GetPrimaryAmmoType() )
		if clip == -1 or clip <= 0 and ammo <= 0 then return end

		draw.RoundedBox(math.Round(2*hudM), curX+0, curY+0, (100*hudM)-0, (60*hudM)-0, Color(0, 0, 0, 25))
		draw.RoundedBox(math.Round(2*hudM), curX+1, curY+1, (100*hudM)-2, (60*hudM)-2, Color(0, 0, 0, 125))
		draw.SimpleText(clip.."/"..ammo, "RustHUD_"..math.Round(28*hudM), curX+(50*hudM), curY+(28*hudM), Color(255, 255, 255, 240), 1, 1)

	end

end
hook.Add("HUDPaint", "DrawRustHUD", DrawRustHUD)

--[[---------------------------------------------------------
	HUDMenu
-----------------------------------------------------------]]
local function HUDMenu()

	--> Frame
	local frame = vgui.Create('DFrame')
	frame:SetPos(-275, 25)
	frame:MoveTo(25, 25, 0.4)
	frame:SetSize(275, 380)
	frame:SetTitle("RustHUD - Settings")
	frame:SetDraggable(true)
	frame:MakePopup()
	frame.Paint = function(pnl, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(149, 165, 166, 225))
		draw.RoundedBoxEx(2, 0, 0, w, 25, Color(189, 195, 199, 255), true, true, false, false)
	end

	--> Position
	local txt_position = vgui.Create('DLabel', frame)
	txt_position:Dock(TOP)
	txt_position:SetText('HUD Position:')
	txt_position:SetFont('Trebuchet18')
	txt_position:SetTextColor(Color(255, 255, 255))

	local position = vgui.Create('DComboBox', frame)
	position:Dock(TOP)
	position:SetValue(GetConVar('rusthud_placement'):GetString())
	position:AddChoice('Left')
	position:AddChoice('Right')
	position.OnSelect = function( panel, index, value )
		RunConsoleCommand('rusthud_placement', value)
	end

	local spc_position = vgui.Create('DPanel', frame)
	spc_position:Dock(TOP)
	spc_position:SetHeight(14)
	spc_position.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 8, w, 2, Color(127, 140, 141, 225))
	end

	--> Size
	local txt_size = vgui.Create('DLabel', frame)
	txt_size:Dock(TOP)
	txt_size:SetText('HUD Size:')
	txt_size:SetFont('Trebuchet18')
	txt_size:SetTextColor(Color(255, 255, 255))

	local size = vgui.Create('DNumSlider', frame)
	size:Dock(TOP)
	size:SetMin(0.5)
	size:SetMax(1.5)
	size:SetDecimals(1)
	size:SetValue(GetConVar('rusthud_size'):GetInt())
	size:SetConVar('rusthud_size')
	size.Label:Hide()

	size.TextArea:SetWide(20)
	size.TextArea:SetTextColor(Color(255, 255, 255))
	size.TextArea:SetFont('Trebuchet18')

	local spc_size = vgui.Create('DPanel', frame)
	spc_size:Dock(TOP)
	spc_size:SetHeight(14)
	spc_size.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 8, w, 2, Color(127, 140, 141, 225))
	end

	--> Spacing
	local txt_spacing = vgui.Create('DLabel', frame)
	txt_spacing:Dock(TOP)
	txt_spacing:SetText('Element Spacing:')
	txt_spacing:SetFont('Trebuchet18')
	txt_spacing:SetTextColor(Color(255, 255, 255))

	local spacing = vgui.Create('DNumSlider', frame)
	spacing:Dock(TOP)
	spacing:SetMin(0)
	spacing:SetMax(25)
	spacing:SetDecimals(0)
	spacing:SetValue(GetConVar('rusthud_spacing'):GetInt())
	spacing:SetConVar('rusthud_spacing')
	spacing.Label:Hide()

	spacing.TextArea:SetWide(20)
	spacing.TextArea:SetTextColor(Color(255, 255, 255))
	spacing.TextArea:SetFont('Trebuchet18')

	local spc_spacing = vgui.Create('DPanel', frame)
	spc_spacing:Dock(TOP)
	spc_spacing:SetHeight(14)
	spc_spacing.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 8, w, 2, Color(127, 140, 141, 225))
	end

	--> Vertical Offset
	local txt_vertical = vgui.Create('DLabel', frame)
	txt_vertical:Dock(TOP)
	txt_vertical:SetText('Vertical Offset (Y):')
	txt_vertical:SetFont('Trebuchet18')
	txt_vertical:SetTextColor(Color(255, 255, 255))

	local vertical = vgui.Create('DNumSlider', frame)
	vertical:Dock(TOP)
	vertical:SetMin(0)
	vertical:SetMax(100)
	vertical:SetDecimals(0)
	vertical:SetValue(GetConVar('rusthud_offset_y'):GetInt())
	vertical:SetConVar('rusthud_offset_y')
	vertical.Label:Hide()

	vertical.TextArea:SetWide(20)
	vertical.TextArea:SetTextColor(Color(255, 255, 255))
	vertical.TextArea:SetFont('Trebuchet18')

	local spc_vertical = vgui.Create('DPanel', frame)
	spc_vertical:Dock(TOP)
	spc_vertical:SetHeight(14)
	spc_vertical.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 8, w, 2, Color(127, 140, 141, 225))
	end

	--> Horizontal Offset
	local txt_horizontal = vgui.Create('DLabel', frame)
	txt_horizontal:Dock(TOP)
	txt_horizontal:SetText('Horizontal Offset (X):')
	txt_horizontal:SetFont('Trebuchet18')
	txt_horizontal:SetTextColor(Color(255, 255, 255))

	local horizontal = vgui.Create('DNumSlider', frame)
	horizontal:Dock(TOP)
	horizontal:SetMin(0)
	horizontal:SetMax(100)
	horizontal:SetDecimals(0)
	horizontal:SetValue(GetConVar('rusthud_offset_x'):GetInt())
	horizontal:SetConVar('rusthud_offset_x')
	horizontal.Label:Hide()

	horizontal.TextArea:SetWide(20)
	horizontal.TextArea:SetTextColor(Color(255, 255, 255))
	horizontal.TextArea:SetFont('Trebuchet18')

	local spc_horizontal = vgui.Create('DPanel', frame)
	spc_horizontal:Dock(TOP)
	spc_horizontal:SetHeight(14)
	spc_horizontal.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 8, w, 2, Color(127, 140, 141, 225))
	end

	--> Reset
	local reset = vgui.Create('DButton', frame)
	reset:Dock(TOP)
	reset:SetHeight(26)
	reset:SetText('Reset')
	reset.DoClick = function()

		RunConsoleCommand('rusthud_placement', hudSettings.placement)
		RunConsoleCommand('rusthud_offset_x', hudSettings.offset_x)
		RunConsoleCommand('rusthud_offset_y', hudSettings.offset_y)
		RunConsoleCommand('rusthud_spacing', hudSettings.spacing)
		RunConsoleCommand('rusthud_size', hudSettings.size)

		frame:Close()

	end

end
concommand.Add('rusthud', HUDMenu)

--[[---------------------------------------------------------
	HUDChat
-----------------------------------------------------------]]
local function HUDChat(ply, text)
	if string.find(text, '^[!/]hud') then
		
		--> Menu
		if ply == LocalPlayer() then
			RunConsoleCommand('rusthud')
		end

		--> Return
		return true

	end
end
hook.Add('OnPlayerChat', 'HUDChat', HUDChat)