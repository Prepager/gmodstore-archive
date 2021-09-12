--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Functions
-----------------------------------------------------------]]
AccessorFunc( PANEL, "Padding", "Padding" )
AccessorFunc( PANEL, "pnlCanvas", "Canvas" )

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> VBar
	self.VBar = vgui.Create("ManiaScrollBar", self)
	self.VBar:Dock(RIGHT)
	self.VBar:SetZPos(1)

	--> Canvas
	self.pnlCanvas = vgui.Create("Panel", self)
	self.pnlCanvas.OnMousePressed = function(self, code) self:GetParent():OnMousePressed(code) end
	self.pnlCanvas:SetMouseInputEnabled(true)
	self.pnlCanvas:DockPadding(10, 10, 10+self.VBar:GetWide(), 10)
	self.pnlCanvas.PerformLayout = function(pnl)

		self:PerformLayout()
		self:InvalidateParent()

	end

	--> Defaults
	self:SetPadding(0)
	self:SetMouseInputEnabled(true)

	--> Drawing
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPaintBackground(false)

end

--[[---------------------------------------------------------
	Function: AddItem
-----------------------------------------------------------]]
function PANEL:AddItem( pnl )

	pnl:SetParent( self:GetCanvas() )

end

--[[---------------------------------------------------------
	Function: OnChildAdded
-----------------------------------------------------------]]
function PANEL:OnChildAdded( child )

	self:AddItem( child )

end

--[[---------------------------------------------------------
	Function: SizeToContents
-----------------------------------------------------------]]
function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )

end

--[[---------------------------------------------------------
	Function: GetVBar
-----------------------------------------------------------]]
function PANEL:GetVBar()

	return self.VBar

end

--[[---------------------------------------------------------
	Function: GetCanvas
-----------------------------------------------------------]]
function PANEL:GetCanvas()

	return self.pnlCanvas

end

--[[---------------------------------------------------------
	Function: InnerWidth
-----------------------------------------------------------]]
function PANEL:InnerWidth()

	return self:GetCanvas():GetWide()

end

--[[---------------------------------------------------------
	Function: Rebuild
-----------------------------------------------------------]]
function PANEL:Rebuild()

	self:GetCanvas():SizeToChildren( false, true )

	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, ( self:GetTall() - self:GetCanvas():GetTall() ) * 0.5 )

	end

end

--[[---------------------------------------------------------
	Function: OnMouseWheeled
-----------------------------------------------------------]]
function PANEL:OnMouseWheeled( dlta )

	return self.VBar:OnMouseWheeled( dlta )

end

--[[---------------------------------------------------------
	Function: OnVScroll
-----------------------------------------------------------]]
function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )

end

--[[---------------------------------------------------------
	Function: ScrollToChild
-----------------------------------------------------------]]
function PANEL:ScrollToChild( panel )

	self:PerformLayout()

	local x, y = self.pnlCanvas:GetChildPosition( panel )
	local w, h = panel:GetSize()

	y = y + h * 0.5
	y = y - self:GetTall() * 0.5

	self.VBar:AnimateTo( y, 0.5, 0, 0.5 )

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	local Tall = self.pnlCanvas:GetTall()
	local Wide = self:GetWide()
	local YPos = 0

	self:Rebuild()

	self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
	YPos = self.VBar:GetOffset()

	//if ( self.VBar.Enabled ) then Wide = Wide - self.VBar:GetWide() end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )

	self:Rebuild()

	if ( Tall != self.pnlCanvas:GetTall() ) then
		self.VBar:SetScroll( self.VBar:GetScroll() ) -- Make sure we are not too far down!
	end

end

--[[---------------------------------------------------------
	Function: Clear
-----------------------------------------------------------]]
function PANEL:Clear()

	return self.pnlCanvas:Clear()

end

--[[---------------------------------------------------------
	Define: ManiaScrollPanel
-----------------------------------------------------------]]
derma.DefineControl( "ManiaScrollPanel", "ManiaScrollPanel", PANEL, "DPanel" )