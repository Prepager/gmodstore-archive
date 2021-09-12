--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Functions
-----------------------------------------------------------]]
AccessorFunc(PANEL, 'items', 'Items')

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Avatar
	self.rounded = vgui.Create('ManiaRounded', self)

	--> Menu
	self.menu = vgui.Create('DPanel', self)
	self.menu.Paint = function(pnl, w, h) return end

	--> Settings
	timer.Simple(0, function()

		--> Variables
		local settings = self:GetParent():GetSettings()

		--> Avatar
		if settings.sidebar.displayStatic then

			--> Static
			self.rounded.item = vgui.Create('ManiaImage', self.rounded)
			self.rounded.item:SetPaintedManually(true)
			self.rounded.item:SetPlayer(LocalPlayer())
			self.rounded.item.Paint = function(pnl, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
			end
			
		elseif !settings.sidebar.avatarModel then

			--> Image
			self.rounded.item = vgui.Create('AvatarImage', self.rounded)
			self.rounded.item:SetPaintedManually(true)
			if IsValid(LocalPlayer()) then
				self.rounded.item:SetPlayer(LocalPlayer(), 96)
			else
				timer.Simple(1, function()
					self.rounded.item:SetPlayer(LocalPlayer(), 96)
				end)
			end

		else

			--> Face
			self.rounded.item = vgui.Create('ManiaFace', self.rounded)
			self.rounded.item:SetPaintedManually(true)
			if IsValid(LocalPlayer()) then
				self.rounded.item:SetPlayer(LocalPlayer())
			else
				timer.Simple(1, function()
					self.rounded.item:SetPlayer(LocalPlayer())
				end)
			end

			local defaultPaint = baseclass.Get("DModelPanel")
			self.rounded.item.Paint = function(pnl, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
				defaultPaint.Paint(pnl, w, h )
			end

		end

		--> Items
		self.items = {}
		for k,v in pairs(settings.sidebar.items) do

			--> Display
			if v.display and !v.display(ply) then
				continue
			end

			--> Button
			local button = vgui.Create('DButton', self.menu)
			button:Dock(TOP)
			button:SetTall(65)
			button:SetText('')
			button.active = false
			button.icon = Material('mania_icons/'..v.icon..'.png', 'noclamp smooth')
			button.tab = v
			button.Paint = function(pnl, w, h)

				--> Background
				if pnl.Hovered or
					(self:GetParent():GetActiveTab() == string.lower(button.tab.name)) or
					(button.tab.unique and self:GetParent():GetActiveTab() == string.lower(button.tab.unique))
				then
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
				end

				--> Icon
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(pnl.icon)
				surface.DrawTexturedRect(pnl:GetWide()/2-26/2, 10, 26, 26)

				--> Shadow
				surface.SetDrawColor(0, 0, 0, 100)
				surface.SetMaterial(pnl.icon)
				surface.DrawTexturedRect((pnl:GetWide()/2-26/2)+1, 10+1, 26, 26)

				--> Text
				draw.TextShadow({
					text = string.upper(button.tab.name),
					font = 'ManiaUI_black_14',
					pos = {pnl:GetWide()/2, 40},
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_TOP,
					color = Color(245, 245, 245, 255)
				}, 1, 100)

			end
			button.DoClick = function(pnl)

				--> Searchable
				local searchable = pnl.tab.searchable

				--> Change
				self:GetParent():TabChange(button.tab.panel, searchable, button.tab)

			end

			--> Default
			if v.default then
				button.active = true
				button:DoClick()
			end

			--> Save
			self.items[k] = button

		end

	end)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Variables
	local settings = self:GetParent():GetSettings()

	--> Background
	draw.RoundedBoxEx(4, 0, 0, w, h, settings.theme, true, false, true, false)

	--> Name
	draw.TextShadow({
		text = LocalPlayer():Nick(),
		font = 'ManiaUI_black_18',
		pos = {self:GetWide()/2, self.rounded:GetTall()+40},
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		color = Color(245, 245, 245, 255)
	}, 1, 100)

	--> Job
	draw.TextShadow({
		text = LocalPlayer():getDarkRPVar('job'),
		font = 'ManiaUI_regular_18',
		pos = {self:GetWide()/2, self.rounded:GetTall()+60},
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
		color = team.GetColor(LocalPlayer():Team())
	}, 1, 100)

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--> Avatar
	self.rounded:SetSize(96, 96)
	self.rounded:SetPos((self:GetWide()-self.rounded:GetWide())/2, 20)

	--> Menu
	local menuY = self.rounded:GetTall()+80
	self.menu:SetSize(self:GetWide(), self:GetTall()-menuY)
	self.menu:SetPos(0, menuY)

end

--[[---------------------------------------------------------
	Define: ManiaSidebar
-----------------------------------------------------------]]
derma.DefineControl('ManiaSidebar', 'ManiaSidebar', PANEL, 'DPanel')