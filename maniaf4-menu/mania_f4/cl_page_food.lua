--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Category (No category support for Hungermod)
	local foodCat = {
		{
			name = 'Other',
			startExpanded = true,
			members = FoodItems
		}
	}


	--> Categories
	self:SetCategories(foodCat) // (DarkRP.getCategories().food)

	--> Variables
	self.actionText = Mania.f4.language.purchase

	--> Name
	self:SetNameCallback(function(item)
		return {
			text = item.name,
			color = Color(0, 0, 0, 245)
		}

	end)

	--> Money
	self:SetMoneyCallback(function(item)
		return {
			text = DarkRP.formatMoney(item.price),
			color = Color(0, 0, 0, 255)
		}
	end)

	--> Model
	self:SetModelCallback(function(item)

		--> Return
		return item.model

	end)

	--> Maximum
	self:SetMaximumCallback(function(item)

		--> Return
		return ''

	end)

	--> Action
	self:SetActionCallback(function(item)

		--> Purchase
		RunConsoleCommand('DarkRP', 'buyfood', item.name)

		--> Close
		if self.tab.shouldClose then
			hook.Call('ShowSpare2')
		end

	end)

	--> Validation
	self:SetValidationCallback(function(item)

		--> Variables
	    local ply = LocalPlayer()

	    --> Search
	    local failSearch = self:GetSearchCallback()(item)
	    if failSearch then
	    	return false, true, nil, nil, true
	    end

	    --> Checks
	    if (item.requiresCook == nil or item.requiresCook == true) and not ply:isCook() then return false, true end
	    if item.customCheck and not item.customCheck(LocalPlayer()) then return false, false end

	    if not ply:canAfford(item.price) then return false, false end

	    --> Return
	    return true, nil, message, cost

	end)

	--> Disabled
	self:SetDisabledCallback(function(panel, can, important, _, _, isSearch)

		--> Search
		if isSearch then
			panel:SetVisible(false)
			return false
		end

		--> Defaults
	    if can and (GAMEMODE.Config.hideNonBuyable or (important and GAMEMODE.Config.hideTeamUnbuyable)) then
	        panel:SetVisible(false)
	        return false
	    else
	        panel:SetVisible(true)
	        return true
	    end

	end)

	--> Reload
	self:ReloadContent()

end

--[[---------------------------------------------------------
	Define: ManiaPage-food
-----------------------------------------------------------]]
derma.DefineControl('ManiaPage-food', 'ManiaPage-food', PANEL, 'ManiaPage-base')