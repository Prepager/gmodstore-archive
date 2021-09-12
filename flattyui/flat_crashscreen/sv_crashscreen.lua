--[[---------------------------------------------------------
	Network
-----------------------------------------------------------]]
util.AddNetworkString("flattyCrashScreen")

--[[---------------------------------------------------------
	connectionCheck
-----------------------------------------------------------]]
local function connectionCheck()

	--> Network
	net.Start("flattyCrashScreen")
	net.Broadcast()

end

--[[---------------------------------------------------------
	Timer
-----------------------------------------------------------]]
timer.Create("flattyCrashTimer", 1, 0, connectionCheck)