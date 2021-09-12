--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()

	--> Padding
	self.Contents.pnlCanvas:DockPadding(10, 2, 10, 0)

end

--[[---------------------------------------------------------
	Function: SetCategory
-----------------------------------------------------------]]
function PANEL:SetCategory(category)

	--> Variables
	self.category = category

	--> Header
	self:SetLabel(category.name)

	--> Fill
	self:Fill()

	--> Expanded
	self:SetExpanded(category.startExpanded)

end

--[[---------------------------------------------------------
	Function: Fill
-----------------------------------------------------------]]
function PANEL:Fill()

	--> Clear
	self.Contents:Clear(true)

	--> Items
	for k, v in ipairs(self.category.members) do

		--> Item
		local item = self:CreateItem(v)

		--> Content
		self.Contents:AddItem(item)

	end

	--> Limits
	self:ReloadLimits()

end

--[[---------------------------------------------------------
	Function: CreateItem
-----------------------------------------------------------]]
function PANEL:CreateItem(item)

	--> Variables
	local relParent = self:GetParent():GetParent()

	--> Create
	local panel = vgui.Create('DPanel')
	panel:Dock(TOP)
	panel:SetTall(80)
	panel.item = item
	panel.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, h-1, w, 1, Color(0, 0, 0, 25))
	end
	panel.SetDisabled = relParent:GetDisabledCallback()

	--> Rounded
	local rounded = vgui.Create('ManiaRounded', panel)
	rounded:SetSize(55, 55)
	local rPos = (panel:GetTall()-rounded:GetTall())/2
	rounded:SetPos(rPos, rPos)

	--> Static
	local model = nil
	if relParent.tab.displayStatic then
		model = vgui.Create('ModelImage', rounded)
	else
		model = vgui.Create('ManiaFace', rounded)
	end

	--> Model
	model:SetPaintedManually(true)
	model:SetModel(relParent:GetModelCallback()(item))

	local defaultPaint = baseclass.Get("DModelPanel")
	model.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
		defaultPaint.Paint(pnl, w, h )
	end

	--> Item
	rounded.item = model

	--> Info
	local info = vgui.Create('DPanel', panel)
	info:SetPos(rPos*2+rounded:GetWide(), rPos)
	info:SetSize(relParent:GetParent():GetWide()-265, rounded:GetTall())
	info.Paint = function(pnl, w, h)

		--> Name
		local name = relParent:GetNameCallback()(item)
		draw.TextShadow({
			text = name.text,
			font = 'ManiaUI_black_26',
			pos = {0, 15},
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			color = name.color
		}, 1, 100)

		--> Money
		local money = relParent:GetMoneyCallback()(item)
		draw.TextShadow({
			text = money.text,
			font = 'ManiaUI_regular_18',
			pos = {0, 38},
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_CENTER,
			color = money.color
		}, 1, 100)

	end

	--> Buttons
	local buttons = vgui.Create('DPanel', panel)
	buttons:Dock(RIGHT)
	buttons:SetSize(125, rounded:GetTall())
	buttons.Paint = function(pnl, w, h) return end

	--> Action
	local action = vgui.Create('DButton', buttons)
	action:SetSize(125, rounded:GetTall()/2)
	action:SetColor(Color(255, 255, 255, 255))
	action:SetFont('ManiaUI_regular_18')
	action:SetText(relParent.actionText..relParent:GetMaximumCallback()(item))
	action.two = false
	action.DoClick = function()
		relParent:GetActionCallback()(item)
	end
	action.Paint = function(pnl, w, h)
		if pnl.two then
			
			--> Background Two
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(46, 204, 113, 255), true, true, false, false)
			if pnl.Hovered then
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(0, 0, 0, 40), true, true, false, false)
			end

		else

			--> Background Single
			draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))
			if pnl.Hovered then
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 40))
			end

		end
	end

	--> Enabled
	if relParent.info then
		
		--> Info
		local info = vgui.Create('DButton', buttons)
		info:SetSize(125, rounded:GetTall()/2)
		info:SetColor(Color(0, 0, 0, 150))
		info:SetFont('ManiaUI_regular_14')
		info:SetText(relParent.infoText)
		info.DoClick = function()
			relParent:GetInfoCallback()(item)
		end
		info.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(225, 225, 225, 255), false, false, true, true)
			if pnl.Hovered then
				draw.RoundedBoxEx(4, 0, 0, w, h, Color(0, 0, 0, 40), false, false, true, true)
			end

		end

		--> Position
		action.two = true
		action:SetPos(0, rPos)
		info:SetPos(0, rPos+action:GetTall())

	else

		--> Position
		action:SetPos(0, rPos+(rounded:GetTall()/2)-action:GetTall()/2)

	end

	--> Return
	return panel

end

--[[---------------------------------------------------------
	Function: ReloadLimits
-----------------------------------------------------------]]
function PANEL:ReloadLimits()

	--> Variables
	local relParent = self:GetParent():GetParent()

	--> Loop
	local count = table.Count(self.Contents:GetItems())
	local disabled = 0
	for k, v in pairs(self.Contents:GetItems()) do
		
		--> Variables
		local item = v.item

		--> Can
		local canGet, important, message, price, isSearch = relParent:GetValidationCallback()(item)
		local dis = v:SetDisabled(not canGet, important, message, price, isSearch)

		--> Disabled
		if !dis then
			disabled = disabled+1
		end

	end

	--> Category
	if count == disabled then
		self:SetVisible(false)
	else
		self:SetVisible(true)
	end

	--> Layout
	self:InvalidateLayout(true)
	self:GetParent():InvalidateLayout(true)

end

--[[---------------------------------------------------------
	Define: ManiaF4Category
-----------------------------------------------------------]]
derma.DefineControl('ManiaF4Category', 'ManiaF4Category', PANEL, 'ManiaCategory')