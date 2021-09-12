--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local crashTimer = CurTime()
local crashMenu = nil

--[[---------------------------------------------------------
	serverResponse
-----------------------------------------------------------]]
local function serverResponse()

	--> Variable
	crashTimer = CurTime()

	--> Menu
	if IsValid(crashMenu) then
		
		--> Remove
		crashMenu:Close()

	end

end
net.Receive("flattyCrashScreen", serverResponse)

--[[---------------------------------------------------------
	clientCheck
-----------------------------------------------------------]]
local function clientCheck()

	--> Variables
	local timeDifference = math.Round(crashTimer - CurTime())

	--> Offline
	if !IsValid(crashMenu) and timeDifference >= FlattySettings.crashmenu.timeout then
		
		--> Open
		RunConsoleCommand("serverCrashMenu")

	end

end
timer.Create("flattyCrashClientTimer", 1, 0, clientCheck)

--[[---------------------------------------------------------
	serverCrashMenu
-----------------------------------------------------------]]
local function serverCrashMenu()

	--> Variables
	local timeReconnect = CurTime()

	--> Timeout
	RunConsoleCommand("cl_timeout", FlattySettings.crashmenu.reconnect+10)

	--> Frame
	crashMenu = vgui.Create("flatFrame")
	crashMenu:SetSize(500, 170)
	crashMenu:Center()
	crashMenu:SetDraggable(true)
	crashMenu:MakePopup()
	crashMenu:DockPadding(6, 46, 6, 6)
	crashMenu:SetTitle("Crash Menu")

	crashMenu.Think = function()
		if math.Round(CurTime() - timeReconnect) >= FlattySettings.crashmenu.reconnect then
			
			--> Reconnect
			RunConsoleCommand("retry")

		end
	end

	--> Panel
	local panel = vgui.Create("DPanel", crashMenu)
	panel:Dock(FILL)

	panel.Paint = function(pnl, w, h)
		draw.SimpleText("We are currently experiencing some connection issues!", "FlatUI_22", w/2, 20, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("We will attempt to reconnect you in "..math.Round(FlattySettings.crashmenu.reconnect - (CurTime() - timeReconnect)).." seconds.", "FlatUI_22", w/2, 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	--> Reconnect
	local reconnect = vgui.Create("flatButton", crashMenu)
	reconnect:SetSize(100, 26)
	reconnect:SetPos(crashMenu:GetWide()/2-100/2, 120)
	reconnect:SetTheme("red")
	reconnect:SetText("Reconnect")
	
	reconnect.DoClick = function()

		--> Reconnect
		RunConsoleCommand("retry")

	end	

end
concommand.Add("serverCrashMenu", serverCrashMenu)