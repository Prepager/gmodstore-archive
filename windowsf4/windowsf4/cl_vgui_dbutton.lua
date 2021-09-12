local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.color = windowsSettings.data.scheme()

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBox(0, 0, 0, w, h, self.color)

	--> Hover
	if self.Hovered then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
	end

end

--[[---------------------------------------------------------
	Function: SetScheme
-----------------------------------------------------------]]
function PANEL:SetScheme(scheme)

	--> Color
	self.color = windowsSettings.data.scheme(scheme)

end

--[[---------------------------------------------------------
	Define: windowsFrame
-----------------------------------------------------------]]
derma.DefineControl("windowsButton", "windowsButton", PANEL, "DButton")