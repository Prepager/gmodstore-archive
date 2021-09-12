--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1

	self.btnGrip = vgui.Create("DScrollBarGrip", self)
	self.btnGrip.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))

	end

	self:SetSize( 12, 15 )

end

--[[---------------------------------------------------------
	Function: SetEnabled
-----------------------------------------------------------]]
function PANEL:SetEnabled( b )

	if ( !b ) then

		self.Offset = 0
		self:SetScroll( 0 )
		self.HasChanged = true

	end

	self:SetMouseInputEnabled( b )
	//self:SetVisible( b )

	-- We're probably changing the width of something in our parent
	-- by appearing or hiding, so tell them to re-do their layout.
	if ( self.Enabled != b ) then

		self:GetParent():InvalidateLayout()

		if ( self:GetParent().OnScrollbarAppear ) then
			self:GetParent():OnScrollbarAppear()
		end

	end

	self.Enabled = b

end

--[[---------------------------------------------------------
	Function: Value
-----------------------------------------------------------]]
function PANEL:Value()

	return self.Pos

end

--[[---------------------------------------------------------
	Function: BarScale
-----------------------------------------------------------]]
function PANEL:BarScale()

	if ( self.BarSize == 0 ) then return 1 end

	return self.BarSize / ( self.CanvasSize + self.BarSize )

end

--[[---------------------------------------------------------
	Function: SetUp
-----------------------------------------------------------]]
function PANEL:SetUp( _barsize_, _canvassize_ )

	self.BarSize = _barsize_
	self.CanvasSize = math.max( _canvassize_ - _barsize_ )

	self:SetEnabled( _canvassize_ > _barsize_ )

	self:InvalidateLayout()

end

--[[---------------------------------------------------------
	Function: OnMouseWheeled
-----------------------------------------------------------]]
function PANEL:OnMouseWheeled( dlta )

	if ( !self:IsVisible() ) then return false end

	-- We return true if the scrollbar changed.
	-- If it didn't, we feed the mousehweeling to the parent panel

	return self:AddScroll( dlta * -2 )

end

--[[---------------------------------------------------------
	Function: AddScroll
-----------------------------------------------------------]]
function PANEL:AddScroll( dlta )

	local OldScroll = self:GetScroll()

	dlta = dlta * 25
	self:SetScroll( self:GetScroll() + dlta )

	return OldScroll != self:GetScroll()

end

--[[---------------------------------------------------------
	Function: SetScroll
-----------------------------------------------------------]]
function PANEL:SetScroll( scrll )

	if ( !self.Enabled ) then self.Scroll = 0 return end

	self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )

	self:InvalidateLayout()

	-- If our parent has a OnVScroll function use that, if
	-- not then invalidate layout (which can be pretty slow)

	local func = self:GetParent().OnVScroll
	if ( func ) then

		func( self:GetParent(), self:GetOffset() )

	else

		self:GetParent():InvalidateLayout()

	end

end

--[[---------------------------------------------------------
	Function: AnimateTo
-----------------------------------------------------------]]
function PANEL:AnimateTo( scrll, length, delay, ease )

	local anim = self:NewAnimation( length, delay, ease )
	anim.StartPos = self.Scroll
	anim.TargetPos = scrll
	anim.Think = function( anim, pnl, fraction )

		pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )

	end

end

--[[---------------------------------------------------------
	Function: GetScroll
-----------------------------------------------------------]]
function PANEL:GetScroll()

	if ( !self.Enabled ) then self.Scroll = 0 end
	return self.Scroll

end

--[[---------------------------------------------------------
	Function: GetOffset
-----------------------------------------------------------]]
function PANEL:GetOffset()

	if ( !self.Enabled ) then return 0 end
	return self.Scroll * -1

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 20))

end

--[[---------------------------------------------------------
	Function: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed()

	local x, y = self:CursorPos()

	local PageSize = self.BarSize

	if ( y > self.btnGrip.y ) then
		self:SetScroll( self:GetScroll() + PageSize )
	else
		self:SetScroll( self:GetScroll() - PageSize )
	end

end

--[[---------------------------------------------------------
	Function: OnMouseReleased
-----------------------------------------------------------]]
function PANEL:OnMouseReleased()

	self.Dragging = false
	self.DraggingCanvas = nil
	self:MouseCapture( false )

	self.btnGrip.Depressed = false

end

--[[---------------------------------------------------------
	Function: OnCursorMoved
-----------------------------------------------------------]]
function PANEL:OnCursorMoved( x, y )

	if ( !self.Enabled ) then return end
	if ( !self.Dragging ) then return end

	local x, y = self:ScreenToLocal( 0, gui.MouseY() )

	-- Uck.
	y = y - self.HoldPos

	local TrackSize = self:GetTall() - self:GetWide() * 2 - self.btnGrip:GetTall()

	y = y / TrackSize

	self:SetScroll( y * self.CanvasSize )

end

--[[---------------------------------------------------------
	Function: Grip
-----------------------------------------------------------]]
function PANEL:Grip()

	if ( !self.Enabled ) then return end
	if ( self.BarSize == 0 ) then return end

	self:MouseCapture( true )
	self.Dragging = true

	local x, y = self.btnGrip:ScreenToLocal( 0, gui.MouseY() )
	self.HoldPos = y

	self.btnGrip.Depressed = true

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local Scroll = self:GetScroll() / self.CanvasSize
	local BarSize = math.max( self:BarScale() * ( self:GetTall() ), 10 )
	local Track = self:GetTall() - BarSize
	Track = Track + 1

	Scroll = Scroll * Track

	self.btnGrip:SetPos( 0, Scroll )
	self.btnGrip:SetSize( Wide, BarSize )

end

--[[---------------------------------------------------------
	Define: ManiaScrollBar
-----------------------------------------------------------]]
derma.DefineControl( "ManiaScrollBar", "ManiaScrollBar", PANEL, "Panel" )