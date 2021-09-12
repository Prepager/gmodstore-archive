local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable", 			"Draggable", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable", 				"Sizable", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock", 			"ScreenLock", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose", 		"DeleteOnClose", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow", 			"PaintShadow", 		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth", 			"MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight", 			"MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur", 		"BackgroundBlur", 	FORCE_BOOL )


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self:SetFocusTopLevel( true )
	self:SetPaintShadow( true )

	self.InsideBox = vgui.Create( "DPanel", self )	-- Custom

	self.closeBtn = vgui.Create( "DButton", self )
	self.closeBtn:SetText( "" )
	self.closeBtn.DoClick = function( button ) self:Close() end
	self.closeBtn:SetDisabled( true )
	self.closeBtn.Paint = function( pnl, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 192, 57, 43, 255 ) )

		if pnl.Hovered then draw.RoundedBox( 0, 0, 0, w, h, Color( 231, 76, 60, 255 ) ) end

		draw.DrawText( "X", "FG_JaapokkiRegular_24", self.closeBtn:GetWide()/2, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		
	end

	self.lblTitle = vgui.Create( "DLabel", self )
	self.lblTitle:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.lblTitle:SetFont( "FG_JaapokkiRegular_24" )
	self.lblTitle:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
	
	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )
	self:SetTitle( "Window" )
	
	self:SetMinWidth( 50 );
	self:SetMinHeight( 50 );
	
	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self.m_fCreateTime = SysTime()
	
	self:DockPadding( 5, 24 + 5, 5, 5 )

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:ShowCloseButton( bShow )

	self.closeBtn:SetVisible( bShow )
	if bShow == true then self.closeBtn:SetDisabled( false ) end

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:SetTitle( strTitle )

	self.lblTitle:SetText( strTitle )

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Close()

	self:SetVisible( false )

	if ( self:GetDeleteOnClose() ) then
		self:Remove()
	end

	self:OnClose()

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnClose()

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Center()

	self:InvalidateLayout( true )
	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 )

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Think()

	--> Default
	local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )
		
	if ( self.Dragging ) then
		
		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then
		
			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )
		
		end
		
		self:SetPos( x, y )
	
	end
	
	
	if ( self.Sizing ) then
	
		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]	
		local px, py = self:GetPos()
		
		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px and self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py and self:GetScreenLock() ) then y = ScrH() - py end
	
		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return
	
	end
	
	if ( self.Hovered &&
		 self.m_bSizable &&
		 mousex > (self.x + self:GetWide() - 20) &&
		 mousey > (self.y + self:GetTall() - 20) ) then	

		self:SetCursor( "sizenwse" )
		return
		
	end
	
	if ( self.Hovered && self:GetDraggable() && mousey < (self.y + 24) ) then
		self:SetCursor( "sizeall" )
		return
	end
	
	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end
	
end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		FG_DrawBackgroundBlur( self, self.m_fCreateTime, 50 )
	end

	-- Background
	draw.RoundedBox( 0, 0, 0, w, h, Color( 240, 240, 240, 255 ) )

	-- Title Bar
	draw.RoundedBox( 0, 0, 0, w, 30, Color( 40, 40, 50, 255 ) )

	-- Inside Border
	draw.RoundedBox( 0, 19, 30 + 19, w - 19 * 2, h - 30 - 19 * 2, Color( 215, 215, 215, 255 ) )

	-- Inside Box
	self.InsideBox:SetSize( w - 20 * 2, h - 30 - 20 * 2 )
	self.InsideBox:SetPos( 20, 30 + 20 )
	self.InsideBox.Paint = function( pnl, width, height )

		draw.RoundedBox( 0, 0, 0, width, height, Color( 255, 255, 255, 255 ) )

	end

	return true

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnMousePressed()

	if ( self.m_bSizable ) then
	
		if ( gui.MouseX() > (self.x + self:GetWide() - 20) &&
			gui.MouseY() > (self.y + self:GetTall() - 20) ) then			
	
			self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
			self:MouseCapture( true )
			return
		end
		
	end
	
	if ( self:GetDraggable() && gui.MouseY() < (self.y + 24) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end
	


end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:OnMouseReleased()

	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:PerformLayout()

	self.closeBtn:SetPos( self:GetWide() - 46 - 5, 5 )
	self.closeBtn:SetSize( 46, 20 )
	
	self.lblTitle:SetPos( 8, 6 )
	self.lblTitle:SetSize( self:GetWide() - 25, 20 )

end


--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:IsActive()

	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end
	
	return false

end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
derma.DefineControl( "FG-Frame", "FG-Frame", PANEL, "EditablePanel" )