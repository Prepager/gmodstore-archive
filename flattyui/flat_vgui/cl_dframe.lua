--[[---------------------------------------------------------
	Setup Table
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	PANEL: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Theme
	self.titleBColor = FlattySettings.frame.titleBColor
	self.titleFColor = FlattySettings.frame.titleFColor

	--> Setup
	self:SetFocusTopLevel(true)
	self:SetPaintShadow(true)

	--> Defaults
	self:SetDraggable(true)
	self:SetSizable(false)
	self:SetScreenLock(true)
	self:SetDeleteOnClose(true)

	self:SetTitle("Untitled Frame")
	self:DockPadding(6, 40+6, 6, 6)

	self:SetMinWidth(50)
	self:SetMinHeight(50)
	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)

	--> Close
	self.closeBtn = vgui.Create("flatButton", self)
	self.closeBtn:SetText("CLOSE")
	self.closeBtn:SetTheme("red")
	self.closeBtn.DoClick = function(button) self:Close() end

end

--[[---------------------------------------------------------
	PANEL: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--> Remove
	self.btnClose:Remove()
	self.btnMaxim:Remove()
	self.btnMinim:Remove()
	self.lblTitle:Remove()

	--> Close
	self.closeBtn:SetPos(self:GetWide() - 65 - 9, 41/2 - 24/2)
	self.closeBtn:SetSize(65, 26)

end

--[[---------------------------------------------------------
	PANEL: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Blur
	if self.m_bBackgroundBlur then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	--> Background
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	draw.RoundedBox(0, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

	--> Title
	draw.RoundedBox(0, 1, 1, w-2, 40, self.titleBColor)
	draw.SimpleText(self.titleText, "FlatUI_24", 11, 41-20, self.titleFColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

end

--[[---------------------------------------------------------
	PANEL: SetTitle
-----------------------------------------------------------]]
function PANEL:SetTitle(title)

	--> Title
	self.titleText = FlattySettings.frame.title.." - "..title

end

--[[---------------------------------------------------------
	PANEL: Center
-----------------------------------------------------------]]
function PANEL:Center()

	--> Layout
	self:InvalidateLayout(true)

	--> Position
	self:SetPos(ScrW()/2 - self:GetWide()/2, ScrH())

	--> Move
	self:MoveTo(ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2, 0.2, 0, -1)

end

--[[---------------------------------------------------------
	PANEL: Close
-----------------------------------------------------------]]
function PANEL:Close()

	--> Position
	local x, _ = self:GetPos()

	--> Move
	self:MoveTo(x, ScrH(), 0.2, 0, -1, function()

		--> Hide
		self:SetVisible(false)

		--> DeleteOnClose
		if self:GetDeleteOnClose() then
			self:Remove()
		end

		--> OnClose
		self:OnClose()

	end)

end


--[[---------------------------------------------------------
	PANEL: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--> Variables
	local mouseX = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mouseY = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

	--> Dragging
	if self.Dragging then
		local x = mouseX - self.Dragging[1]
		local y = mouseY - self.Dragging[2]

		if self:GetScreenLock() then
			x = math.Clamp(x, 0, ScrW() - self:GetWide())
			y = math.Clamp(y, 0, ScrH() - self:GetTall())
		end

		self:SetPos(x, y)
	end

	--> Draggable
	if self.Hovered and self:GetDraggable() and mouseY < (self.y + 41) then
		self:SetCursor("sizeall")
		return
	else
		self:SetCursor("arrow")
	end

end

--[[---------------------------------------------------------
	PANEL: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed()
	if self:GetDraggable() and gui.MouseY() < (self.y + 41) then

		--> Dragging
		self.Dragging = {gui.MouseX() - self.x, gui.MouseY() - self.y}
		self:MouseCapture(true)

		--> Return
		return

	end
end

--[[---------------------------------------------------------
	Register VGUI
-----------------------------------------------------------]]
vgui.Register("flatFrame", PANEL, "DFrame")
