--[[---------------------------------------------------------
	Table Setup
-----------------------------------------------------------]]
FlattySettings = FlattySettings or {}

FlattySettings.frame = {}
FlattySettings.button = {}

FlattySettings.serverlist = {}
FlattySettings.crashmenu = {}
FlattySettings.escapemenu = {}

--[[---------------------------------------------------------
	Menu - Server List
-----------------------------------------------------------]]
FlattySettings.serverlist.command = "servers"

FlattySettings.serverlist.servers = {
	{"Server Name #1", "Server Description #1", "10.0.0.2"},
	{"Server Name #2", "Server Description #2", "10.0.0.2"},
}

--[[---------------------------------------------------------
	Menu - Crash Menu
-----------------------------------------------------------]]
FlattySettings.crashmenu.timeout = 2
FlattySettings.crashmenu.reconnect = 30

--[[---------------------------------------------------------
	Menu - Escape Menu
-----------------------------------------------------------]]
FlattySettings.escapemenu.closeTime = 5
FlattySettings.escapemenu.motdCommand = "!motd"
FlattySettings.escapemenu.donateUrl = "https://www.google.com"

FlattySettings.escapemenu.buttons = {
	{"Resume Game", "blue", function(button) button:GetParent():Close() end},
	{"div"},
	{"Servers", "green", function(button) button:GetParent():Close() RunConsoleCommand("serverListMenu") end},
	{"MOTD", "green", function(button) RunConsoleCommand("say", FlattySettings.escapemenu.motdCommand) button:GetParent():Close() end},
	{"Donate", "green", function(button) gui.OpenURL(FlattySettings.escapemenu.donateUrl) end},
	{"div"},
	{"ui", "Enable UI", "yellow"},
	{"div"},
	{"Disconnect", "red", function(button) RunConsoleCommand("disconnect") end},
}

--[[---------------------------------------------------------
	VGUI - Frame
-----------------------------------------------------------]]
FlattySettings.frame.title = "FlattyUI"

FlattySettings.frame.titleBColor = Color(63, 81, 181, 255)
FlattySettings.frame.titleFColor = Color(255, 255, 255, 255)

--[[---------------------------------------------------------
	VGUI - Button
-----------------------------------------------------------]]
FlattySettings.button.colors = {
	red 	= {Color(231, 76, 60, 255), Color(255, 255, 255, 255)},
	green 	= {Color(46, 204, 113, 255), Color(255, 255, 255, 255)},
	blue 	= {Color(52, 152, 219, 255), Color(255, 255, 255, 255)},
	yellow 	= {Color(241, 196, 15, 255), Color(255, 255, 255, 255)},
	orange 	= {Color(230, 126, 34, 255), Color(255, 255, 255, 255)},
	purple 	= {Color(155, 89, 182, 255), Color(255, 255, 255, 255)},
	asphalt = {Color(52, 73, 94, 255), Color(255, 255, 255, 255)},
	red 	= {Color(231, 76, 60, 255), Color(255, 255, 255, 255)},
}