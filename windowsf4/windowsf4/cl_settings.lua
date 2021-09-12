--[[---------------------------------------------------------
	Variable Setup
-----------------------------------------------------------]]
windowsSettings = windowsSettings or {}
windowsSettings.design = {}
windowsSettings.icons = {}
windowsSettings.data = {}

--[[---------------------------------------------------------
	Settings
-----------------------------------------------------------]]
windowsSettings.design.scheme = "Cyan"
windowsSettings.design.title = "Main Menu"
windowsSettings.design.server = "ServerName"

--[[---------------------------------------------------------
	Table: Icons
-----------------------------------------------------------]]
windowsSettings.icons.close 	= Material('windows_icons/close.png', 'noclamp smooth')
windowsSettings.icons.box 		= Material('windows_icons/box.png', 'noclamp smooth')
windowsSettings.icons.job 		= Material('windows_icons/job.png', 'noclamp smooth')
windowsSettings.icons.vehicles 	= Material('windows_icons/vehicles.png', 'noclamp smooth')
windowsSettings.icons.weapons 	= Material('windows_icons/weapons.png', 'noclamp smooth')
windowsSettings.icons.entities 	= Material('windows_icons/entities.png', 'noclamp smooth')
windowsSettings.icons.food 		= Material('windows_icons/food.png', 'noclamp smooth')
windowsSettings.icons.website	= Material('windows_icons/website.png', 'noclamp smooth')

--[[---------------------------------------------------------
	Table: Tabs
-----------------------------------------------------------]]
windowsSettings.design.tabs = {
	{
		type = "div"
	},
	{
		name = "Forum",
		icon = windowsSettings.icons.website,
		type = "web",
		url = "http://www.google.com"
	},
	{
		name = "Donate",
		icon = windowsSettings.icons.website,
		type = "web",
		url = "http://www.facepunch.com"
	},
	{
		type = "div"
	},
	{
		name = "Jobs",
		icon = windowsSettings.icons.job,
		panel = "windowsJobs",
		default = true
	},
	{
		name = "Entities",
		icon = windowsSettings.icons.entities,
		panel = "windowsEntities"
	},
	{
		name = "Weapons",
		icon = windowsSettings.icons.weapons,
		panel = "windowsWeapons"
	},
	{
		name = "Shipments",
		icon = windowsSettings.icons.box,
		panel = "windowsShipments"
	},
	{
		name = "Ammo",
		icon = windowsSettings.icons.box,
		panel = "windowsAmmo"
	},
	{
		name = "Food",
		icon = windowsSettings.icons.food,
		panel = "windowsFood"
	},
	{
		name = "Vehicles",
		icon = windowsSettings.icons.vehicles,
		panel = "windowsVehicles"
	}
}

--[[---------------------------------------------------------
	Table: Schemes
-----------------------------------------------------------]]
windowsSettings.design.schemes = {
	Lime 	= Color(164, 196, 0, 255),
	Green 	= Color(96, 169, 23, 255),
	Emerald = Color(0, 138, 0, 255),
	Teal 	= Color(0, 171, 169, 255),
	Cyan 	= Color(27, 161, 226, 255),
	Cobalt 	= Color(0, 80, 239, 255),
	Indigo 	= Color(106, 0, 255, 255),
	Violet 	= Color(170, 0, 255, 255),
	Pink 	= Color(244, 114, 208, 255),
	Magenta = Color(216, 0, 115, 255),
	Crimson = Color(162, 0, 37, 255),
	Red 	= Color(229, 20, 0, 255),
	Orange 	= Color(250, 104, 0, 255),
	Amber 	= Color(240, 163, 10, 255),
	Yellow	= Color(227, 200, 0, 255),
	Brown	= Color(130, 90, 44, 255),
	Olive	= Color(109, 135, 100, 255),
	Steel 	= Color(100, 118, 135, 255),
	Mauve 	= Color(118, 96, 138, 255),
	Taupe 	= Color(135, 121, 78, 255)
}

--[[---------------------------------------------------------
	Function: Scheme
-----------------------------------------------------------]]
windowsSettings.data.scheme = function(scheme)
	if !scheme then scheme = windowsSettings.design.scheme end
	if !windowsSettings.design.schemes[scheme] then
		return windowsSettings.design.schemes['Cyan']
	else
		return windowsSettings.design.schemes[scheme]
	end
end

--[[---------------------------------------------------------
	Fonts: Table
-----------------------------------------------------------]]
windowsSettings.fontsTable = {
	{
		file = 'Segoe UI',
		name = 'segoe',
		weight = 500,
		from = 0,
		to = 14
	},
	{
		file = 'Segoe UI Light',
		name = 'segoe_light',
		weight = 400,
		from = 0,
		to = 14
	},
	{
		file = 'Segoe UI Semibold',
		name = 'segoe_semibold',
		weight = 400,
		from = 0,
		to = 24
	},
	{
		file = 'Segoe UI',
		name = 'segoe_bold',
		weight = 700,
		from = 0,
		to = 14
	}
}

--[[---------------------------------------------------------
	Fonts: Create
-----------------------------------------------------------]]
for k,v in pairs(windowsSettings.fontsTable) do
	for i = v.from, v.to do
		
		--> Size
		local fontSize = 14+i

		--> Font
		surface.CreateFont(v.name.."_"..fontSize, {
			font = v.file,
			size = fontSize,
			weight = v.weight,
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
			outline = false
		})

	end
end