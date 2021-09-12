local PANEL = {}


--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self:SetSize( self:GetParent():GetParent():GetWide(), self:GetParent():GetParent():GetTall() )

	self.ScrollLayout = vgui.Create( "DIconLayout" )
	self.ScrollLayout:SetSize( self:GetWide(), self:GetTall() )
	self.ScrollLayout:SetPos( 0, 0 )
	self.ScrollLayout:SetSpaceY( 10 )
	self.ScrollLayout:SetSpaceX( 10 )

	self:AddItem( self.ScrollLayout )

end


--[[---------------------------------------------------------
	Name: CanUseItem
-----------------------------------------------------------]]
local function CanUseItem( item )

	--> Variables
	local ply = LocalPlayer()

	--> Checks
	if istable( item.allowed ) and table.Count(item.allowed) != 0 and not table.HasValue( item.allowed, ply:Team() ) then
		return false, false
	end

	if item.customCheck and not item.customCheck( ply ) then
		print("item.customCheck")
		return false, false
	end

	if not ply:canAfford( item.price ) then
		print("item.canAfford")
		return true, true
	end

	print("item.good")
	--> Final Return
	return true, false

end


--[[---------------------------------------------------------
	Name: UseItem
-----------------------------------------------------------]]
local function UseItem( item, object, close )

	--> Purchase
	RunConsoleCommand( "darkrp", "buyshipment", item.name )

	--> Close
	close()

end


--[[---------------------------------------------------------
	Name: FillData
-----------------------------------------------------------]]
function PANEL:FillData()

	local ItemCount = 0 

	for k, v in pairs( fn.Filter(fn.Compose{fn.Not, fn.Curry(fn.GetValue, 2)("noship")}, CustomShipments) ) do
		
		--> Checks
		local CanGet, Disabled = CanUseItem( v )
		if not CanGet then continue end

		ItemCount = ItemCount + 1

		--> Variables
		local objectTitle 	= v.name 			or ""
		local objectModel 	= v.model 			or ""
		local objectLevel 	= v.level 			or 0
		local objectPrice 	= v.price  			or 0

		local objectTextTitle = objectTitle
		local objectTextLevel = "Level: " .. objectLevel

		--> Text Size
		surface.SetFont( "FG_JaapokkiRegular_19" )
		local tw, th = surface.GetTextSize( objectTextTitle )
		local lw, lt = surface.GetTextSize( objectTextLevel )

		--> Object
		local object = self.ScrollLayout:Add( "DPanel" )
		object:SetSize( self.ScrollLayout:GetWide() / 2 - 47, 155 )

		object.Paint = function( pnl, w, h )

			--> Background			
			draw.RoundedBox( 4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color( 200, 200, 200, 255 ) )
			draw.RoundedBox( 4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color( 240, 240, 240, 255 ) )

			--> Border
			draw.RoundedBox( 0, 20-2, 35-2, 100+4, 100+4, Color( 200, 200, 200, 255 ) )
			draw.RoundedBox( 0, 20-1, 35-1, 100+2, 100+2, Color( 240, 240, 240, 255 ) )

			--> Title
			draw.RoundedBox( 4, 10, 0, tw + 8, 21, Color( 100, 100, 100, 255 ) )
			draw.DrawText( objectTextTitle, "FG_JaapokkiRegular_19", 14, 3, Color( 255, 255, 255, 255 ) )

			--> Level
			--draw.RoundedBox( 4, w - lw - 18, 0, lw + 8, 21, Color( 180, 180, 180, 255 ) )
			--draw.DrawText( objectTextLevel, "FG_JaapokkiRegular_19", w - lw - 14, 3, Color( 255, 255, 255, 255 ) )

			--> Info
			draw.DrawText( "Price: $" .. objectPrice, "FG_JaapokkiRegular_32", 135 + ( object:GetWide() - 155 ) / 2, 35 + 12, Color( 50, 50, 50, 255 ), 1 )
			draw.DrawText( "-", "FG_JaapokkiRegular_24", 135 + ( object:GetWide() - 155 ) / 2, 35 + 40, Color( 100, 100, 100, 255 ), 1 )

		end

		local objectImage = vgui.Create( "ModelImage", object )
		objectImage:SetSize( 100, 100 )
		objectImage:SetPos( 20, 35 )
		objectImage:SetModel( objectModel )

		local objectButton = vgui.Create( "FG-DButton", object )
		objectButton:SetSize( object:GetWide() - 100 - 55, 25 )
		objectButton:SetPos( 135, 10 + objectImage:GetTall() )
		objectButton:SetText( "Purchase" )

		if Disabled then

			objectButton.ButtonColor = Color( 150, 150, 150, 255 )

		else

			objectButton.ButtonColor = Color( 46, 204, 113, 255 )
			objectButton.DoClick = function( pnl ) UseItem( v, objectButton, function() RunConsoleCommand( "fg_f4menu_close" ) end ) end

		end
	
	end

	if ItemCount == 0 then
		
		--> NoItems
		local NoItems = self.ScrollLayout:Add( "DPanel" )
		NoItems:SetSize( self.ScrollLayout:GetWide() - 84, 155 )
		NoItems.Paint = function( pnl, w, h )

			--> Background			
			draw.RoundedBox( 4, 0 + 0, 0, w - 0, h - 0, Color( 200, 200, 200, 255 ) )
			draw.RoundedBox( 4, 0 + 1, 1, w - 2, h - 2, Color( 240, 240, 240, 255 ) )

			--> Info
			draw.DrawText( "Nothing was found.", "FG_JaapokkiRegular_24", w/2, h/2-24/2, Color( 100, 100, 100, 255 ), 1 )

		end

	end

end


--[[---------------------------------------------------------
	Name: ReFillData
-----------------------------------------------------------]]
function PANEL:ReFillData()

	--> Clear
	self.ScrollLayout:Clear()

	--> Fill Data
	self:FillData()

end


--[[---------------------------------------------------------
	Name: Define
-----------------------------------------------------------]]
derma.DefineControl( "FG-F4Menu-Shipments", "FG-F4Menu-Shipments", PANEL, "FG-DScrollPanel" )