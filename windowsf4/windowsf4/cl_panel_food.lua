--[[---------------------------------------------------------
	Panel: windowsFoodItem
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: canPurchase
-----------------------------------------------------------]]
function PANEL:canPurchase(food)
    local ply = LocalPlayer()

    if (food.requiresCook == nil or food.requiresCook == true) and not ply:isCook() then return false, true end
    if food.customCheck and not food.customCheck(LocalPlayer()) then return false, false end

    if not ply:canAfford(food.price) then return false, false end

    return true
end

--[[---------------------------------------------------------
	Function: UpdateData
-----------------------------------------------------------]]
function PANEL:UpdateData(item, parentPanel)

	--> Self
	self.localItem = item

	--> Can
	local canGet, important = self:canPurchase(item)
	if important then
		self:Remove()
	elseif !canGet then
		self.purchase:SetScheme("Steel")
	end

	--> Model
	self.image:SetModel(item.model)

	--> Title
	self.title:SetText(item.name)
	self.title:SetFont("segoe_semibold_28")

	--> Description
	self.description:SetText("Energy: "..item.energy)
	self.description:SetFont("segoe_22")
	self.description:SetContentAlignment(4)

	--> Salary
	self.price:SetText(DarkRP.formatMoney(item.price))

	--> Become
	self.purchase.DoClick = function()
		RunConsoleCommand("darkrp", "buyfood", item.name)
		parentPanel:SetVisible(false)
		parentPanel:Hide()
	end

end

--[[---------------------------------------------------------
	Define: windowsFoodItem
-----------------------------------------------------------]]
derma.DefineControl("windowsFoodItem", "windowsFoodItem", PANEL, "windowsGenericItem")

--[[---------------------------------------------------------
	Panel: windowsFood
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: ReloadData
-----------------------------------------------------------]]
function PANEL:ReloadData()

	--> Clear
	self.list:Clear()

	--> Close
	local parentPanel = self:GetParent():GetParent()

	--> Food
	local count = 0
	local items = {}
	for _, food in pairs(FoodItems) do

		--> Item
		local item = vgui.Create("windowsFoodItem", self.list)
		item:Dock(TOP)
		item:UpdateData(food, parentPanel)

		--> Count
		if IsValid(item) then
			count = count+1
			table.Add(items, {item})
		end

	end

	--> Count
	if count == 0 then
		function self.list.Paint(pnl, w, h)
			draw.SimpleText("Nothing was found!", "segoe_semibold_38", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		function self.list.Paint(pnl, w, h)
		end
	end

	if count <= 6 then
		for _, v in pairs(items) do
			v:DockMargin(0, 0, 0, 10)
		end
	end

end

--[[---------------------------------------------------------
	Define: windowsFood
-----------------------------------------------------------]]
derma.DefineControl("windowsFood", "windowsFood", PANEL, "windowsGeneric")