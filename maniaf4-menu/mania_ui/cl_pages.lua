--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.activePanel = false
	self.activeTab = false
	self.panels = {}

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBoxEx(4, 0, 0, w, h, Color(235, 235, 235, 255), false, false, false, true)

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

end

--[[---------------------------------------------------------
	Function: SetTab
-----------------------------------------------------------]]
function PANEL:SetTab(tab)

	--> Variables
	self.activeTab = tab

end

--[[---------------------------------------------------------
	Function: SetPanel
-----------------------------------------------------------]]
function PANEL:SetPanel(name)

	--> Active
	if self.activePanel == name then
		return
	end

	--> Current
	local old = nil
	if self.activePanel then
		
		--> Panel
		old = self.panels[self.activePanel]
		old:MoveTo(0, self:GetTall(), 0.5)

	end

	--> Panel
	local panel = nil
	if self.panels[name] then
		panel = self.panels[name]
	else
		panel = vgui.Create('ManiaPage-'..name, self)
	end

	--> Exists
	if !IsValid(panel) then
		return
	end

	--> Position
	panel:SetSize(self:GetWide(), self:GetTall())
	panel:SetPos(0, -self:GetTall())

	--> Move
	panel:MoveTo(0, 0, 0.5)

	--> Save
	self.activePanel = name
	self.panels[name] = panel

end

--[[---------------------------------------------------------
	Function: ReloadActive
-----------------------------------------------------------]]
function PANEL:ReloadActive()

	--> Variables
	local active = self.activePanel
	local array = self.panels[active]

	--> Check
	if active and IsValid(array) and array.cats then

		--> Reload
		for k, v in pairs(array.cats) do
			v:ReloadLimits()
		end

		--> Count
		array:ReloadCount()

	end

end


--[[---------------------------------------------------------
	Define: ManiaPages
-----------------------------------------------------------]]
derma.DefineControl('ManiaPages', 'ManiaPages', PANEL, 'DPanel')