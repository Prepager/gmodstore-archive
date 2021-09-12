--[[---------------------------------------------------------
	Panel: windowsJobs
-----------------------------------------------------------]]
local PANEL = {}
PANEL.localItem = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Self
	self:SetTall(82)
	self:DockMargin(0, 0, 10, 10)
	self:DockPadding(5, 5, 5, 5)

	--> Image
	self.image = vgui.Create("ModelImage", self)
	self.image:Dock(LEFT)
	self.image:SetWide(72)
	self.image.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
	end

	--> Actions
	self.actions = vgui.Create("DPanel", self)
	self.actions:Dock(RIGHT)
	self.actions:SetWide(100)
	self.actions.Paint = function(pnl, w, h) end

	--> Description
	self.description = vgui.Create("DLabel", self)
	self.description:Dock(FILL)
	self.description:SetFont("segoe_18")
	self.description:SetTextColor(Color(0, 0, 0, 255))
	self.description:DockMargin(10, 0, 10, 0)
	self.description:SetContentAlignment(7)
	self.description:SetWrap(true)

	--> Title
	self.title = vgui.Create("DLabel", self)
	self.title:Dock(TOP)
	self.title:SetFont("segoe_semibold_20")
	self.title:SetTextColor(Color(0, 0, 0, 255))
	self.title:DockMargin(10, 0, 10, 0)
	self.title:SetContentAlignment(4)
	self.title:SetAutoStretchVertical(true)

	--> Purchase
	self.purchase = vgui.Create("windowsButton", self.actions)
	self.purchase:Dock(BOTTOM)
	self.purchase:SetTall(30)
	self.purchase:SetText("Purchase")
	self.purchase:SetFont("segoe_semibold_20")
	self.purchase:SetTextColor(Color(255, 255, 255, 255))

	--> Price
	self.price = vgui.Create("DLabel", self.actions)
	self.price:Dock(FILL)
	self.price:SetFont("segoe_semibold_28")
	self.price:SetTextColor(windowsSettings.data.scheme("Emerald"))
	self.price:SetContentAlignment(5)
	self.price:DockMargin(0, 0, 0, 5)
	self.price.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(250, 250, 250, 255))
	end

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
	draw.RoundedBox(0, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

end

--[[---------------------------------------------------------
	Define: windowsGenericItem
-----------------------------------------------------------]]
derma.DefineControl( "windowsGenericItem", "windowsGenericItem", PANEL, "DPanel" )

--[[---------------------------------------------------------
	Panel: windowsJobs
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> List
	self.list = vgui.Create("windowsScrollPanel", self)
	self.list:Dock(FILL)
	self.list:InvalidateParent(true)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

end

--[[---------------------------------------------------------
	Define: windowsGeneric
-----------------------------------------------------------]]
derma.DefineControl( "windowsGeneric", "windowsGeneric", PANEL, "DPanel" )