local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.URL = ""

	--> HTML
	self.HTML = vgui.Create("HTML", self)
	self.HTML:Dock(FILL)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	draw.SimpleText("Loading...", "segoe_semibold_38", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

--[[---------------------------------------------------------
	Function: SetWebsite
-----------------------------------------------------------]]
function PANEL:SetWebsite(URL)

	--> Variables
	self.URL = URL

	--> Website
	self.HTML:OpenURL(URL)

end

--[[---------------------------------------------------------
	Function: ReloadData
-----------------------------------------------------------]]
function PANEL:ReloadData()

	--> Website
	self:SetWebsite(self.URL)

end

--[[---------------------------------------------------------
	Define: windowsWebsite
-----------------------------------------------------------]]
derma.DefineControl( "windowsWebsite", "windowsWebsite", PANEL, "DPanel" )