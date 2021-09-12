local PANEL = {}
PANEL.Ready = false

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Frame
	self:DockPadding(1, 1, 1, 1)

	--> Topbar
	self.topbar = vgui.Create("DPanel", self)
	self.topbar:Dock(TOP)
	self.topbar:SetTall(32)
	self.topbar:DockPadding(10, 0, 0, 0)
	self.topbar.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 255))
	end

	--> Sidebar
	self.sidebar = vgui.Create("DPanel", self)
	self.sidebar:Dock(LEFT)
	self.sidebar:SetWide(225)
	self.sidebar.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(33, 33, 33, 255))
	end

	--> body
	self.body = vgui.Create("DPanel", self)
	self.body:Dock(FILL)
	self.body:DockPadding(10, 10, 10, 10)
	self.body.Paint = function(pnl, w, h) end

	--> Title
	self.title = vgui.Create("DLabel", self.topbar)
	self.title:Dock(LEFT)
	self.title:SetWide(300)
	self.title:SetFont("segoe_20")
	self.title:SetTextColor(Color(0, 0, 0, 255))

	--> Close
	self.close = vgui.Create("DButton", self.topbar)
	self.close:Dock(RIGHT)
	self.close:SetWide(40)
	self.close:SetText("")
	self.close.Paint = function(pnl, w, h)

		--> Background
		local iconColor = 0
		if pnl.Hovered then
			draw.RoundedBox(0, 0, 0, w, h, windowsSettings.data.scheme('Red'))
			iconColor = 255
		end

		--> Icon
		surface.SetDrawColor(iconColor, iconColor, iconColor, 255)
		surface.SetMaterial(windowsSettings.icons.close)
		surface.DrawTexturedRect(9, 4, 22, 22)

	end
	self.close.DoClick = function()
		self:SetVisible(false)
		self:Hide()
	end

	--> Remove
	self.btnClose:Remove()
	self.btnMaxim:Remove()
	self.btnMinim:Remove()
	self.lblTitle:Remove()

end

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:SetTitle( strTitle )

	self.title:SetText( strTitle )

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )

	--> Border
	local border = windowsSettings.data.scheme()
	draw.RoundedBox(0, 0, 0, w, h, Color(border.r, border.g, border.b, 100))

	--> Background
	draw.RoundedBox(0, 1, 1, w-2, h-2, Color(235, 235, 235, 255))

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

end

--[[---------------------------------------------------------
	Function: Hide
-----------------------------------------------------------]]
function PANEL:Hide()

	self.Ready = false

end

--[[---------------------------------------------------------
	Function: Show
-----------------------------------------------------------]]
function PANEL:Show()
	if self.Ready != true then

		--> Ready
		timer.Simple(0.2, function()
			if IsValid(self) then
				self.Ready = true
			end
		end)

	end
end

--[[---------------------------------------------------------
	Function: Think
-----------------------------------------------------------]]
function PANEL:Think()
	if self.Ready and input.IsKeyDown(KEY_F4) then

		--> Hide
		self:SetVisible(false)
		self:Hide()

		--> Ready
		self.Ready = false

	end
end

--[[---------------------------------------------------------
	Define: windowsFrame
-----------------------------------------------------------]]
derma.DefineControl( "windowsFrame", "windowsFrame", PANEL, "DFrame" )
