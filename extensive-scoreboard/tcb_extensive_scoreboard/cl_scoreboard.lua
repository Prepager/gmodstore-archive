--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local scoreboardFrame

--[[---------------------------------------------------------
	Name: Fonts
-----------------------------------------------------------]]
local function createScoreboardFont(amount, font, name, weight)

	--> Loop
	for i=1,amount do

		--> Size
		local size = 10+i*2

		--> Create
		surface.CreateFont(name..size, {
			font = font,
			size = size,
			weight = weight,
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
		})

	end

end

createScoreboardFont(10, 'Lato', 'TCB-Scoreboard-Font-', 500)
createScoreboardFont(10, 'Lato', 'TCB-Scoreboard-BoldFont-', 600)

--[[---------------------------------------------------------
	Name: FAdmin
-----------------------------------------------------------]]
timer.Simple(1, function()

	--> Remove FAdmin
	hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
	hook.Remove("ScoreboardHide", "FAdmin_scoreboard")

end)

--[[---------------------------------------------------------
	Name: ScoreboardShow
-----------------------------------------------------------]]
hook.Add("ScoreboardShow", "TCB-Scoreboard", function()
	if scoreboardFrame and ValidPanel(scoreboardFrame) then

		--> Show Scoreboard
		scoreboardFrame:Show()
		scoreboardFrame:MakePopup()
		scoreboardFrame:SetKeyBoardInputEnabled(false)
		scoreboardFrame:UpdatePanel()

		--> Mouse
		gui.EnableScreenClicker(true)

		--> Return
		return true

	else

		--> Create Scoreboard
		scoreboardFrame = vgui.Create("TCB-Scoreboard")

		--> Show Scoreboard
		hook.Call("ScoreboardShow", GM)

		--> Return
		return true

	end
end)

--[[---------------------------------------------------------
	Name: ScoreboardHide
-----------------------------------------------------------]]
hook.Add("ScoreboardHide", "FG-Scoreboard", function()
	if scoreboardFrame and ValidPanel(scoreboardFrame) then

		--> Hide Scoreboard
		scoreboardFrame:SetVisible(false)
		scoreboardFrame:Hide()

		--> Mouse
		gui.EnableScreenClicker(false)

	end
end)

--[[---------------------------------------------------------
	Name: HUDDrawScoreBoard
-----------------------------------------------------------]]
hook.Add("HUDDrawScoreBoard", "FG-Scoreboard", function()

	--> Return
	return true

end)

--[[---------------------------------------------------------
	Name: Receive
-----------------------------------------------------------]]
net.Receive("scoreboard_receive_friends", function()

	--> Variables
	local friends = net.ReadTable()

	--> Update
	scoreboardFrame:UpdateFriends(friends)

end)
