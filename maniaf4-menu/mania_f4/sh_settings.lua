--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
Mania = Mania or {}
Mania.f4 = Mania.f4 or {}

--[[---------------------------------------------------------
	Variables: Base
-----------------------------------------------------------]]
Mania.f4.settings = {
	width = 860,
	height = 700,
	theme = Color(40, 85, 175, 255),
}

--[[---------------------------------------------------------
	Variables: Topbar
-----------------------------------------------------------]]
Mania.f4.settings.topbar = {
	height = 50
}

--[[---------------------------------------------------------
	Variables: Download
-----------------------------------------------------------]]
Mania.f4.download = {
	workshop = false,
	workshopID = '757995941'
}

--[[---------------------------------------------------------
	Variables: Tabs
-----------------------------------------------------------]]
Mania.f4.tabs = {
	jobs = true,
	entities = true,
	weapons = true,
	shipments = true,
	ammo = true,
	food = true,
	vehicles = true
}

--[[---------------------------------------------------------
	Variables: Language
-----------------------------------------------------------]]
Mania.f4.language = {

	--> Tabs
	home = 'Home',
	jobs = 'Jobs',
	entities = 'Entities',
	weapons = 'Weapons',
	shipments = 'Shipments',
	ammo = 'Ammo',
	food = 'Food',
	vehicles = 'Vehicles',

	--> Buttons
	become = 'Become',
	info = 'Description',
	purchase = 'Purchase',

	--> Categories
	commands = 'Commands',

	--> Commands
	changeName = 'Change name',
	changeJob = 'Change job title',
	requestLicense = 'Request gun license',
	dropWeapon = 'Drop active weapon',
	sellAllDoors = 'Sell all doors',

	dropMoney = 'Drop money',
	giveMoney = 'Give money',

	requestSearchWarrant = 'Request search warrant',
	removeSearchWarrant = 'Remove search warrant',
	makeWanted = 'Make wanted',
	removeWanted = 'Remove wanted',

	startLockdown = 'Start lockdown',
	stopLockdown = 'Stop lockdown',
	addLaw = 'Add law',
	removeLaw = 'Remove law',
	placeLawboard = 'Place lawboard',

	--> Other
	nothing = 'Nothing was found...'
}

--[[---------------------------------------------------------
	Variables: Sidebar
-----------------------------------------------------------]]
Mania.f4.settings.sidebar = {
	width = 25, // %
	maxWidth = 250,
	avatarModel = true,
	displayStatic = false,

	items = {
		{
			name = Mania.f4.language.home,
			icon = 'home',
			panel = 'home',
			default = true,
			searchable = false,

			links = {
				{'Forum', 'https://www.google.com'},
				{'Donate', 'https://www.google.com'},
				{'Group', 'https://www.google.com'}
			}
		},
		{
			name = Mania.f4.language.jobs,
			icon = 'jobs',
			panel = 'jobs',
			searchable = true,

			shouldClose = true,
			displayStatic = true,

			display = function()
				return Mania.f4.tabs.jobs
			end
		},
		{
			name = Mania.f4.language.entities,
			icon = 'entities',
			panel = 'entities',
			searchable = true,

			shouldClose = true,
			displayStatic = false,

			display = function()
				return Mania.f4.tabs.entities
			end
		},
		{
			name = Mania.f4.language.weapons,
			icon = 'weapons',
			panel = 'weapons',
			searchable = true,

			shouldClose = true,
			displayStatic = false,

			display = function()
				return Mania.f4.tabs.weapons
			end
		},
		{
			name = Mania.f4.language.shipments,
			icon = 'box',
			panel = 'shipments',
			searchable = true,

			shouldClose = true,
			displayStatic = false,

			display = function()
				return Mania.f4.tabs.shipments
			end
		},
		{
			name = Mania.f4.language.ammo,
			icon = 'box',
			panel = 'ammo',
			searchable = true,

			shouldClose = false,
			displayStatic = false,

			display = function()
				return Mania.f4.tabs.ammo
			end
		},
		{
			name = Mania.f4.language.food,
			icon = 'food',
			panel = 'food',
			searchable = true,

			shouldClose = true,
			displayStatic = false,

			display = function(ply)
				return Mania.f4.tabs.food and !DarkRP.disabledDefaults['modules']['hungermod']
			end
		},
		{
			name = Mania.f4.language.vehicles,
			icon = 'vehicles',
			panel = 'vehicles',
			searchable = true,

			shouldClose = true,
			displayStatic = false,

			display = function()
				return Mania.f4.tabs.vehicles
			end
		}
	}
}

--[[---------------------------------------------------------
	Variables: Commands
-----------------------------------------------------------]]
Mania.f4.settings.commands = {

	--> General
	{
		color = Color(52, 152, 219, 255),
		cmds = {
			{
				name = Mania.f4.language.changeName,

				params = {{'Name', 'string'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'rpname', params[1])
				end
			},
			{
				name = Mania.f4.language.changeJob,

				params = {{'Title', 'string'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'job', params[1])
				end
			},
			{
				name = Mania.f4.language.requestLicense,

				click = function(params)
					RunConsoleCommand('DarkRP', 'requestlicense')
				end
			},
			{
				name = Mania.f4.language.dropWeapon,

				click = function(params)
					RunConsoleCommand('DarkRP', 'drop')
				end
			},
			{
				name = Mania.f4.language.sellAllDoors,

				click = function(params)
					RunConsoleCommand('DarkRP', 'unownalldoors')
				end
			}
		}
	},

	--> Money
	{
		color = Color(46, 204, 113, 255),
		cmds = {
			{
				name = Mania.f4.language.dropMoney,

				params = {{'Amount', 'integer'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'dropmoney', params[1])
				end
			},
			{
				name = Mania.f4.language.giveMoney,

				params = {{'Amount', 'integer'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'give', params[1])
				end
			}
		}
	},

	--> Police
	{
		color = Color(40, 85, 175, 255),
		display = function(ply) return ply:isCP() end,
		cmds = {
			{
				name = Mania.f4.language.requestSearchWarrant,

				params = {{'Player', 'player'}, {'Reason', 'string'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'warrant', params[1], params[2])
				end
			},
			{
				name = Mania.f4.language.removeSearchWarrant,

				params = {{'Player', 'player'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'unwarrant', params[1])
				end
			},

			{
				name = Mania.f4.language.makeWanted,

				params = {{'Player', 'player'}, {'Reason', 'string'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'wanted', params[1], params[2])
				end
			},
			{
				name = Mania.f4.language.removeWanted,

				params = {{'Player', 'player'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'unwanted', params[1])
				end
			}
		}
	},

	--> Mayor
	{
		color = Color(231, 76, 60, 255),
		display = function(ply) return ply:isMayor() end,
		cmds = {
			{
				name = Mania.f4.language.startLockdown,

				click = function(params)
					RunConsoleCommand('DarkRP', 'lockdown')
				end
			},
			{
				name = Mania.f4.language.stopLockdown,

				click = function(params)
					RunConsoleCommand('DarkRP', 'unlockdown')
				end
			},
			{
				name = Mania.f4.language.addLaw,

				params = {{'Law', 'string'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'addlaw', params[1])
				end
			},
			{
				name = Mania.f4.language.removeLaw,

				params = {{'Law Number', 'integer'}},
				click = function(params)
					RunConsoleCommand('DarkRP', 'removelaw', params[1])
				end
			},
			{
				name = Mania.f4.language.placeLawboard,

				click = function(params)
					RunConsoleCommand('DarkRP', 'placelaws')
				end
			}
		}
	}

}