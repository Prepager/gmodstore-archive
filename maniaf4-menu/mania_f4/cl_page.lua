--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Functions
-----------------------------------------------------------]]
AccessorFunc(PANEL, 'categories', 'Categories')

AccessorFunc(PANEL, 'name_callback', 'NameCallback')
AccessorFunc(PANEL, 'money_callback', 'MoneyCallback')
AccessorFunc(PANEL, 'model_callback', 'ModelCallback')
AccessorFunc(PANEL, 'maximum_callback', 'MaximumCallback')

AccessorFunc(PANEL, 'search_callback', 'SearchCallback')
AccessorFunc(PANEL, 'disabled_callback', 'DisabledCallback')
AccessorFunc(PANEL, 'validation_callback', 'ValidationCallback')

AccessorFunc(PANEL, 'action_callback', 'ActionCallback')
AccessorFunc(PANEL, 'info_callback', 'InfoCallback')

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.cats = {}
	self.tab = self:GetParent().activeTab

	--> Nothing
	self.nothing = vgui.Create('DPanel', self)
	self.nothing:Dock(TOP)
	self.nothing:SetTall(100)
	self.nothing.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(4, 0, 0, w, h, Color(225, 225, 225, 255))
		draw.RoundedBox(4, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

		--> Text
		draw.SimpleText(Mania.f4.language.nothing, 'ManiaUI_black_26', w/2, h/2, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	--> Search
	self:SetSearchCallback(function(item)

		--> Variables
		local searchText = self:GetParent():GetParent().search

		--> Valid
		if searchText and searchText != '' then
			
			--> Regex
			local match = string.match(string.lower(item.name or item.title or ''), string.lower(searchText))

			--> Unmatched 2a55b13a0d7bbd39654642c0dd430a84dde59260afe99bf6c7c9f9d65af463af
			if !match then
				return true
			end

		end

		--> Return
		return false

	end)

end

--[[---------------------------------------------------------
	Function: SetInfo
-----------------------------------------------------------]]
function PANEL:SetInfo(func)

	--> Variables
	self.info = true
	self.infoFunc = func

end

--[[---------------------------------------------------------
	Function: ReloadContent
-----------------------------------------------------------]]
function PANEL:ReloadContent()

	--> Categories
	for k,v in pairs(self:GetCategories()) do

		--> Category
		local category = vgui.Create('ManiaF4Category', self)
		category:Dock(TOP)
		category:DockMargin(0, 0, 0, 10)
		category:SetCategory(v)

		self.cats[k] = category

	end

end

--[[---------------------------------------------------------
	Function: ReloadCount
-----------------------------------------------------------]]
function PANEL:ReloadCount()

	--> Loop
	local count = 0
	for k,v in pairs(self.cats) do
		if v:IsVisible() then
			
			--> Count
			count = count+1

		end
	end

	--> None
	if count == 0 then
		
		--> Show
		self.nothing:SetVisible(true)

	else

		--> Hide
		self.nothing:SetVisible(false)

	end

end

--[[---------------------------------------------------------
	Define: ManiaPage-base
-----------------------------------------------------------]]
derma.DefineControl('ManiaPage-base', 'ManiaPage-base', PANEL, 'ManiaScrollPanel')