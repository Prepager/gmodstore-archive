--[[---------------------------------------------------------
	Setup Table
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	PANEL: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Theme
	self.btnBColor = FlattySettings.button.colors["red"][1]
	self.btnFColor = FlattySettings.button.colors["red"][2]

	--> Defaults
	self:SetContentAlignment(5)

	self:SetDrawBorder(true)
	self:SetDrawBackground(true)

	self:SetTall(26)
	self:SetWide(100)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	self:SetCursor("hand")
	self:SetFont("FlatUI_16")
	self:SetTextColor(self.btnFColor)

end

--[[---------------------------------------------------------
	PANEL: SetTheme
-----------------------------------------------------------]]
function PANEL:SetTheme(theme)
	if istable(FlattySettings.button.colors[theme]) then
		self.btnBColor = FlattySettings.button.colors[theme][1]
		self.btnFColor = FlattySettings.button.colors[theme][2]

		self:SetTextColor(self.btnFColor)
	end
end

--[[---------------------------------------------------------
	PANEL: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBox(3, 0, 0, w, h, self.btnBColor)

	--> Hover
	if self.Hovered then
		draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
	end

end

--[[---------------------------------------------------------
	Register VGUI
-----------------------------------------------------------]]
vgui.Register("flatButton", PANEL, "DButton")