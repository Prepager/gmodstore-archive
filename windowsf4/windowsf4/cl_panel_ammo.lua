--[[---------------------------------------------------------
	Panel: windowsAmmoItem
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: canPurchase
-----------------------------------------------------------]]
function PANEL:canPurchase(item)
    local ply = LocalPlayer()

    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyAmmo", nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
    if not ply:canAfford(cost) then return false, false, cost end

    if canbuy == false then
        return false, suppress, price
    end

    return true, nil, price
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
	self.description:SetText("Bullets: "..item.amountGiven)
	self.description:SetFont("segoe_22")
	self.description:SetContentAlignment(4)

	--> Salary
	self.price:SetText(DarkRP.formatMoney(item.price))

	--> Become
	self.purchase.DoClick = function()
		RunConsoleCommand("darkrp", "buyammo", item.ammoType)
	end

end

--[[---------------------------------------------------------
	Define: windowsAmmoItem
-----------------------------------------------------------]]
derma.DefineControl("windowsAmmoItem", "windowsAmmoItem", PANEL, "windowsGenericItem")

--[[---------------------------------------------------------
	Panel: windowsAmmo
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

	--> Ammo
	local count = 0
	local items = {}
	for _, ammo in pairs(GAMEMODE.AmmoTypes) do

		--> Item
		local item = vgui.Create("windowsAmmoItem", self.list)
		item:Dock(TOP)
		item:UpdateData(ammo, parentPanel)

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
	Define: windowsAmmo
-----------------------------------------------------------]]
derma.DefineControl("windowsAmmo", "windowsAmmo", PANEL, "windowsGeneric")