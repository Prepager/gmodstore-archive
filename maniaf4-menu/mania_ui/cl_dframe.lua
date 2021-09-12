--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Functions
-----------------------------------------------------------]]
AccessorFunc(PANEL, 'settings', 'Settings')

AccessorFunc(PANEL, 'items', 'Items')
AccessorFunc(PANEL, 'activetab', 'ActiveTab')

AccessorFunc(PANEL, 'show_topbar', 'ShowTopbar')
AccessorFunc(PANEL, 'show_sidebar', 'ShowSidebar')
AccessorFunc(PANEL, 'show_pages', 'ShowPages')

AccessorFunc(PANEL, 'close_func', 'CloseFunction')

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Defaults
	self:SetTitle('')
	self:SetDraggable(false)
	self:DockPadding(0, 0, 0, 0)
	self:ShowCloseButton(false)

	--> Panels
	self:SetShowTopbar(true)
	self:SetShowSidebar(true)
	self:SetShowPages(true)

	--> Delay
	timer.Simple(0, function()

		--> Sidebar
		if self:GetShowSidebar() then
			self.sidebar = vgui.Create('ManiaSidebar', self)
			self.sidebar:Dock(LEFT)
			self.sidebar:SetItems(self:GetItems())
		end

		--> Topbar
		if self:GetShowTopbar() then
			self.topbar = vgui.Create('ManiaTopbar', self)
			//self.topbar:Dock(TOP)
		end

		--> Content
		if self:GetShowPages() then
			self.content = vgui.Create('ManiaPages', self)
		end

		--> Ready
		self.ready = 1

	end)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--> Ready
	if !self.ready then

		--> Timer
		timer.Simple(0, function()
			self:PerformLayout()
		end)

		--> Return
		return

	end

	--> Variables
	local settings = self:GetSettings()

	--> Values
	local posX = 0
	local posY = 0

	--> Sidebar
	if self:GetShowSidebar() then
		posX = (self:GetWide()/100)*settings.sidebar.width
		if settings.sidebar.maxWidth and posX > settings.sidebar.maxWidth then posX = settings.sidebar.maxWidth end
		self.sidebar:SetWide(posX)
	end

	--> Topbar
	if self:GetShowTopbar() then
		posY = settings.topbar.height
		self.topbar:SetSize(self:GetWide()-posX, posY)
		self.topbar:SetPos(posX, 0)
	end

	--> Content
	if self:GetShowPages() then
		self.content:SetSize(self:GetWide()-posX, self:GetTall()-posY)
		self.content:SetPos(posX, posY)
	end

end

--[[---------------------------------------------------------
	Function: TabChange
-----------------------------------------------------------]]
function PANEL:TabChange(panel, searchable, tab)

	--> Searchable
	if self:GetShowTopbar() then
		self.topbar:SetSearch(searchable)
		if tab.links then
			self.topbar:SetLinks(tab.links)
		else
			self.topbar:SetLinks({})
		end
	end

	--> Content
	if self:GetShowPages() then
		self.content:SetTab(tab)
		self.content:SetPanel(panel)
		self.content:ReloadActive()
	end

	--> Active
	if tab.unique then
		self:SetActiveTab(tab.unique)
	else
		self:SetActiveTab(panel)
	end

end

--[[---------------------------------------------------------
	Function: DoSearch
-----------------------------------------------------------]]
function PANEL:DoSearch(text)
	if self:GetShowPages() and self.search != text then

		--> Variables
		self.search = text

		--> Reload
		self.content:ReloadActive()

	end
end

--[[---------------------------------------------------------
	Define: ManiaFrame
-----------------------------------------------------------]]
derma.DefineControl('ManiaFrame', 'ManiaFrame', PANEL, 'DFrame')