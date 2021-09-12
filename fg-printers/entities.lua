--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]
local GroupDonator = { "superadmin", "admin", "moderator", "doantor" }

--[[---------------------------------------------------------
	Name: Printers
-----------------------------------------------------------]]
DarkRP.createEntity("Amber Printer", {
	ent = "fg_amber_printer",
	model = "models/props_c17/consolebox01a.mdl",
	price = 5000,
	max = 4,
	cmd = "buyamberprinter"
})

DarkRP.createEntity("Sapphire Printer", {
	ent = "fg_sapphire_printer",
	model = "models/props_c17/consolebox01a.mdl",
	price = 10000,
	max = 4,
	cmd = "buysapphireprinter"
})

DarkRP.createEntity("Ruby Printer", {
	ent = "fg_ruby_printer",
	model = "models/props_c17/consolebox01a.mdl",
	price = 25000,
	max = 4,
	cmd = "buyrubyprinter"
})

DarkRP.createEntity("Emerald Printer", {
	ent = "fg_emerald_printer",
	model = "models/props_c17/consolebox01a.mdl",
	price = 50000,
	max = 4,
	cmd = "buyemeraldprinter",
	customCheck = function(ply) return
		table.HasValue(GroupDonator, ply:GetNWString("usergroup"))
	end,
	customCheckFailMsg = "This entity is restricted to donator and higher!",	
})