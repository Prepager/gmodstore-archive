local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> VBar - Paint
	self.VBar.Paint = function( pnl, w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(255, 255, 255, 255))
	end

	--> Vbar BtnGrip - Paint
	self.VBar.btnGrip.Paint = function( pnl, w, h )
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(225, 225, 225, 255))
	end

	--> VBar BtnUp - Paint
	self.VBar.btnUp.Paint = function( pnl, w, h )
		draw.RoundedBox(0, 2, 2, w-4, h-2, Color(225, 225, 225, 255))
	end

	--> VBar BtnDown - Paint
	self.VBar.btnDown.Paint = function( pnl, w, h )
		draw.RoundedBox(0, 2, 0, w-4, h-2, Color(225, 225, 225, 255))
	end

end

--[[---------------------------------------------------------
	Define: windowsScrollPanel
-----------------------------------------------------------]]
derma.DefineControl( "windowsScrollPanel", "windowsScrollPanel", PANEL, "DScrollPanel" )
