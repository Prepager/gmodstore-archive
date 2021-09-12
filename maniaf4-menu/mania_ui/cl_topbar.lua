--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.linkTable = {}

	--> Close
	self.close = vgui.Create('DButton', self)
	self.close:Dock(RIGHT)
	self.close.icon = Material('mania_icons/close.png', 'noclamp smooth')
	self.close:SetText('')
	self.close.Paint = function(pnl, w, h)

		--> Background
		if pnl.Hovered then
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 25))
		end

		--> Icon
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetMaterial(pnl.icon)
		surface.DrawTexturedRect(pnl:GetWide()/2-22/2, pnl:GetTall()/2-22/2, 22, 22)

	end
	self.close.DoClick = self:GetParent():GetCloseFunction()

	--> Input
	self.input = vgui.Create('DTextEntry', self)
	self.input:SetWide(200)
	self.input:SetZPos(1)
	self.input:SetFont('ManiaUI_regular_18')
	self.input:SetPos(-self.input:GetWide(), 0)
	self.input.shown = false
	self.input.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(0, 0, 0, w, h, Color(254, 254, 254, 255))
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 25))

		--> Text
		pnl:DrawTextEntryText(Color(0, 0, 0, 200), Mania.f4.settings.theme, Color(0, 0, 0, 200))

	end
	self.input.OnChange = function()

		--> Variables
		local text = self.input:GetText()

		--> Blacklist
		local blacklist = {'%%', '%(', '%)'}
		for k, v in pairs(blacklist) do
			text = string.gsub(text, v, '')
		end

		--> Search
		self:GetParent():DoSearch(text)

	end

	--> Search
	self.search = vgui.Create('DButton', self)
	self.search.icon = Material('mania_icons/search.png', 'noclamp smooth')
	self.search:SetText('')
	self.search:SetZPos(2)
	self.search.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(0, 0, 0, w, h, Color(254, 254, 254, 255))
		if pnl.Hovered or self.input.shown then
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 25))
		end

		--> Icon
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetMaterial(pnl.icon)
		surface.DrawTexturedRect(pnl:GetWide()/2-22/2, pnl:GetTall()/2-22/2, 22, 22)

	end
	self.search.DoClick = function()

		--> Entry
		if self.input.shown then

			--> Move
			self.input:MoveTo(-self.input:GetWide(), 0, 0.2)

			--> Search
			self.input:SetText('')
			self:GetParent():DoSearch('')

		else

			--> Move
			self.input:MoveTo(self.search:GetWide(), 0, 0.2)

			--> Focus
			self.input:RequestFocus()

		end

		--> Shown
		self.input.shown = !self.input.shown

	end

	--> Menu
	self.menu = vgui.Create('DPanel', self)
	self.menu.Paint = function() return end

end

--[[---------------------------------------------------------
	Function: SetLinks
-----------------------------------------------------------]]
function PANEL:SetLinks(links)

	--> Same
	if self.links == links then
		return
	end

	--> Variables
	self.links = links

	--> None
	if table.Count(self.links) == 0 then
		
		--> Move
		local curX, curY = self.menu:GetPos()
		self.menu:MoveTo(curX, -self:GetTall(), 0.2, 0, -1, function()

			--> Remove
			for k, v in pairs(self.linkTable) do

				--> Remove
				v:Remove()

			end

		end)

		--> Return
		return

	end

	--> Elements
	for k, v in pairs(self.linkTable) do

		--> Remove
		v:Remove()

	end

	--> Create
	local tempColor = Mania.f4.settings.theme
	local link = nil
	for k, v in pairs(links) do

		--> Link
		link = vgui.Create('DButton', self.menu)
		link:Dock(LEFT)
		link:SetText(v[1])
		link:SetWide(100)
		link:SetFont('ManiaUI_black_18')
		link:SetColor(Color(tempColor.r, tempColor.g, tempColor.b, 200))
		link.Paint = function(pnl, w, h)
			if pnl.Hovered then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 40))
			end
		end
		link.DoClick = function()
			gui.OpenURL(v[2])
		end

		--> Save
		self.linkTable[k] = link
		
	end

	--> Menu
	if IsValid(link) then

		--> Width
		self.menu:SetWide(link:GetWide()*table.Count(links))

		--> Move
		self.menu:MoveTo(self:GetWide()/2-self.menu:GetWide()/2, 0, 0.2)

	end

end

--[[---------------------------------------------------------
	Function: SetSearch
-----------------------------------------------------------]]
function PANEL:SetSearch(bool)
	if bool then

		--> Move
		self.search:MoveTo(0, 0, 0.2)

		--> Input
		if self.input.shown and self.input:GetText() == '' then

			--> Remove
			self.search:DoClick()


		elseif self.input.shown then
			
			--> Search
			self:GetParent():DoSearch(self.input:GetText())

		end

	else

		--> Move
		self.search:MoveTo(0, -self:GetTall(), 0.2)

		--> Search
		self:GetParent():DoSearch('')

		--> Input
		if self.input.shown then
			self.search:DoClick()
		end

	end
end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBoxEx(4, 0, 0, w, h, Color(254, 254, 254, 255), false, true, false, false)

end


--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--> Close
	self.close:SetSize(self:GetTall(), self:GetTall())

	--> Search
	self.search:SetSize(self:GetTall(), self:GetTall())

	--> Input
	self.input:SetSize(self.input:GetWide(), self:GetTall())

	--> Menu
	self.menu:SetTall(self:GetTall())

end

--[[---------------------------------------------------------
	Define: ManiaSidebar
-----------------------------------------------------------]]
derma.DefineControl('ManiaTopbar', 'ManiaTopbar', PANEL, 'DPanel')