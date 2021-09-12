--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local Scoreboard


--[[---------------------------------------------------------
	Name: FAdmin
-----------------------------------------------------------]]
timer.Simple( 1, function()

	--> Remove FAdmin
	hook.Remove( "ScoreboardShow", "FAdmin_scoreboard" )
	hook.Remove( "ScoreboardHide", "FAdmin_scoreboard" )

end )


--[[---------------------------------------------------------
	Name: ScoreboardShow
-----------------------------------------------------------]]
hook.Add( "ScoreboardShow", "FG-Scoreboard", function()
	if Scoreboard and ValidPanel( Scoreboard ) then
		
		--> Show Scoreboard
		Scoreboard:Show()
		Scoreboard:MakePopup()
		Scoreboard:SetKeyBoardInputEnabled( false )

		--> Position Scoreboard
		Scoreboard:MoveTo( ScrW()/2 - Scoreboard:GetWide()/2, ScrH()/2 - Scoreboard:GetTall()/2, 0.2, 0 )

		--> Mouse
		gui.EnableScreenClicker( true )

		--> Reset
		for k,v in pairs( player.GetAll() ) do v.ScoreEntry = nil end
		Scoreboard.Players:Clear()

		--> Return
		return true

	else

		--> Create Scoreboard
		Scoreboard = vgui.Create( "FG-Scoreboard" )

		--> Show Scoreboard
		hook.Call( "ScoreboardShow", GM )

		--> Return
		return true

	end
end )


--[[---------------------------------------------------------
	Name: ScoreboardHide
-----------------------------------------------------------]]
hook.Add( "ScoreboardHide", "FG-Scoreboard", function()
	if Scoreboard and ValidPanel( Scoreboard ) then

		--> Position Scoreboard
		Scoreboard:SetPos( ScrW()/2 - Scoreboard:GetWide()/2, ScrH(), 0.2, 0 )

		--> Hide Scoreboard
		Scoreboard:SetVisible( false )
		Scoreboard:Hide()

		--> Mouse
		gui.EnableScreenClicker( false )

	end
end )


--[[---------------------------------------------------------
	Name: HUDDrawScoreBoard
-----------------------------------------------------------]]
hook.Add( "HUDDrawScoreBoard", "FG-Scoreboard", function()

	--> Return
	return true

end )