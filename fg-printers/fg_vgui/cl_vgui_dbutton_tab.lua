--[[---------------------------------------------------------
   Name: Variables
-----------------------------------------------------------]]
local PANEL = {}


--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	-- Default
	draw.RoundedBox( 0, 0, 0, w, h, Color( 215, 215, 215, 255 ) )

	-- Last
	if self.Last == true then
		draw.RoundedBox( 0, 0, 0, w - 0, h - 0, Color( 255, 255, 255, 255 ) )
	else
		draw.RoundedBox( 0, 0, 0, w - 1, h - 1, Color( 255, 255, 255, 255 ) )
	end

	-- Active
	if self.Active == true then
		draw.RoundedBox( 0, 0, h - 4, w, 3, Color( 40, 40, 50, 255 ) )
		draw.DrawText( self.ButtonText, "FG_JaapokkiRegular_22", self:GetWide()/2, 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	else
		draw.RoundedBox( 0, 0, h - 4, w, 3, Color( 180, 180, 180, 255 ) )

		if self.Hovered == true then
			draw.RoundedBox( 0, 0, h - 4, w, 3, Color( 140, 140, 140, 255 ) )
		end

		draw.DrawText( self.ButtonText, "FG_JaapokkiRegular_22", self:GetWide()/2, 4, Color( 100, 100, 100, 255 ), TEXT_ALIGN_CENTER )
	end
	
	return false

end

--[[---------------------------------------------------------
   Name: vgui.Register
-----------------------------------------------------------]]
vgui.Register( "FG-DButton-Tab", PANEL, "DButton" )