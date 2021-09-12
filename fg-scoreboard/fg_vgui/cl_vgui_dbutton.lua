--[[---------------------------------------------------------
   Name: Variables
-----------------------------------------------------------]]
local PANEL = {}


--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	--> Background
	draw.RoundedBox( 0, 0, 0, w, h, self.ButtonColor )

	--> Border
	draw.RoundedBox( 0, 0, 0, w, 2, Color( 0, 0, 0, 50 ) )
	draw.RoundedBox( 0, 0, h - 2, w, 2, Color( 0, 0, 0, 50 ) )

	draw.RoundedBox( 0, 0, 2, 2, h-4, Color( 0, 0, 0, 50 ) )
	draw.RoundedBox( 0, w - 2, 2, 2, h-4, Color( 0, 0, 0, 50 ) )

	--> Hover
	if self.Hovered == true then

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 50 ) )

	end

	--> Text
	if self.Toffset then
		texty = self.Toffset
	else
		texty = 4
	end

	draw.DrawText( self:GetText(), "FG_JaapokkiRegular_22", self:GetWide()/2+0, texty, Color( 255, 255, 255, 255 ), 1 )
	
	--> Return
	return true

end

--[[---------------------------------------------------------
   Name: vgui.Register
-----------------------------------------------------------]]
vgui.Register( "FG-DButton", PANEL, "DButton" )