--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'FG Printer - Base'
ENT.Author = 'TheCodingBeast'

ENT.Spawnable = false
ENT.AdminSpawnable = false

--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]

--[[---------------------------------------------------------

	pGroupDonator: The group(s) that should be able to purchase donator only upgrades.
	pGroupStaff: The group(s) that should be able to purchase staff only upgrades.

	pTitle: The title of the upgrade window.
	pName: The name of the printer shown on the top.
	pColor: The color of the printer.

	pSpeed: The default speed.
	pQuality: The default quality.
	pCooler: The default cooler.

	pTemp: The starting temperature.
	pTempChange:
	{
		both-above: Temperature change when both the speed and quality level is higher than the cooler level,
		both-below: Temperature change when both the speed and quality level is lower than the cooler level,
		other: Temperature change when when speed and or quality is the same as the cooler level or one is below or above,

		power-off: Temperature change when the printer is powered off,

		blow-chance: The chance of the printer blowing up when temperature is above 75C
	}

	pStorage: The max amount of money the printer should be able to hold (0: Unlimited).

	pMessages: The messages that should be display for each action.

	pLevelSpeed, pLevelQuality, pLevelCooler:
	{
		1: The percentage of the orginal value,
		2: The percentage price of the default upgrade price,
		3: The team required to buy the upgrade (1: Donator, 2: Staff)
	}

-----------------------------------------------------------]]

--> Groups
ENT.pGroupDonator = {'superadmin', 'admin', 'moderator', 'donator'}
ENT.pGroupStaff = {'superadmin', 'admin', 'moderator'}

--> Printer
ENT.pTitle = 'FlawlessGaming - Printer Menu'
ENT.pName = 'Base Printer'
ENT.pColor = Color(0, 0, 0, 255)

--> Defaults
ENT.pSpeed = 30
ENT.pQuality = 125
ENT.pCooler = 20

--> Temperature
ENT.pTemp = 20
ENT.pTempChange = {
	['both-above'] = function() return math.random(1.5, 5.5) end,
	['both-below'] = function() return math.random(0.1, 0.3) end,
	['other'] = function() return math.random(0.3, 0.6) end,

	['power-off'] = function() return math.random(0.2, 3.5) end,

	['blow-chance'] = function() return math.random(1, 8) end
}

--> Storage
ENT.pStorage = 0

--> Messages
ENT.pMessages = {
	['money'] = 'You don\'t have enough money for this upgrade!',
	['rank'] = 'You don\'t have the required rank for this upgrade!',
	['collect'] = 'You took $% from the printer!',
	['explode'] = 'Your printer exploded!'
}

--> Levels
ENT.pLevelSpeed = {
	{100, 0, 0},

	{95, 200, 0},
	{90, 250, 0},
	{80, 300, 0},
	{70, 400, 0},
	{60, 500, 0},
	{50, 700, 1},
	{40, 900, 1},
	{30, 1100, 1},
	{20, 1200, 2},
}

ENT.pLevelQuality = {
	{100, 0, 0},

	{110, 200, 0},
	{120, 250, 0},
	{140, 300, 0},
	{160, 400, 0},
	{180, 500, 0},
	{200, 700, 1},
	{230, 900, 1},
	{260, 1100, 1},
	{300, 1200, 2},
}

ENT.pLevelCooler = {
	{100, 0, 0},

	{110, 200, 0},
	{120, 250, 0},
	{130, 300, 0},
	{150, 400, 0},
	{175, 500, 0},
	{200, 700, 1},
	{225, 900, 1},
	{250, 1100, 1},
	{300, 1200, 2},
}

--[[---------------------------------------------------------
	Name: SetupDataTables
-----------------------------------------------------------]]
function ENT:SetupDataTables()

	--> Owner
	self:NetworkVar('Entity', 1, 'owning_ent')

	--> Levels
	self:NetworkVar('Int', 1, 'lvl_speed')
	self:NetworkVar('Int', 2, 'lvl_quality')
	self:NetworkVar('Int', 3, 'lvl_cooler')

	--> Data
	self:NetworkVar('Int', 4, 'data_power')
	self:NetworkVar('Int', 5, 'data_money')
	self:NetworkVar('Float', 6, 'data_temp')

end