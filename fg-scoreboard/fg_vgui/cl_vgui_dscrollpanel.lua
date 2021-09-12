local PANEL = {}


--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> VBar - Paint
	self.VBar.Paint = function( pnl, w, h ) 
		
		draw.RoundedBox( 4, 0, 0, w - 0, h - 0, Color( 180, 180, 180, 255 ) ) 

	end

	--> Vbar BtnGrip - Paint
	self.VBar.btnGrip.Paint = function( pnl, w, h )

		draw.RoundedBox( 4, 2, 2, w - 4, h - 4, Color( 40, 40, 50, 255 ) )

	end

	--> VBar BtnUp - Remove
	self.VBar.btnUp.Paint = function( pnl, w, h )

		draw.RoundedBox( 4, 2, 2, w - 4, h - 4, Color( 40, 40, 50, 255 ) )
		
		--derma.SkinHook( "Paint", "ButtonUp", pnl, w, h )

	end

	--> VBar BtnDown - Remove
	self.VBar.btnDown.Paint = function( pnl, w, h )

		draw.RoundedBox( 4, 2, 2, w - 4, h - 4, Color( 40, 40, 50, 255 ) )

		--derma.SkinHook( "Paint", "ButtonDown", pnl, w, h )
		
	end

end


--[[---------------------------------------------------------
	Name: Define
-----------------------------------------------------------]]
derma.DefineControl( "FG-DScrollPanel", "FG-DScrollPanel", PANEL, "DScrollPanel" )