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
local function CanUseItem( job )

	local ply = LocalPlayer()

	if isnumber(job.NeedToChangeFrom) and ply:Team() ~= job.NeedToChangeFrom then return false, true end
	if istable(job.NeedToChangeFrom) and not table.HasValue(job.NeedToChangeFrom, ply:Team()) then return false, true end
	if job.customCheck and not job.customCheck(ply) then return false, true end
	if ply:Team() == job.team then return true, true end
	if job.max ~= 0 and ((job.max % 1 == 0 and team.NumPlayers(job.team) >= job.max) or (job.max % 1 ~= 0 and (team.NumPlayers(job.team) + 1) / #player.GetAll() > job.max)) then return true, true end
	if job.admin == 1 and not ply:IsAdmin() then return false, true end
	if job.admin > 1 and not ply:IsSuperAdmin() then return false, true end

	return true

end


--[[---------------------------------------------------------
	Name: UseItem
-----------------------------------------------------------]]
local function UseItem( item, object, close )
	if item.vote or item.RequiresVote and item.RequiresVote( LocalPlayer(), item.team ) then
		
		--> Create Vote
		RunConsoleCommand( "darkrp", "vote" .. item.command )

		--> Close
		close()

	else

		--> Change Job
		RunConsoleCommand( "darkrp", item.command )

		--> Close
		close()

	end
end


--[[---------------------------------------------------------
	Name: FillData
-----------------------------------------------------------]]
function PANEL:FillData()

	local ItemCount = 0

	for k, v in ipairs( RPExtraTeams ) do
		
		--> Checks
		local CanGet, Disabled = CanUseItem( v )
		if !CanGet then continue end

		ItemCount = ItemCount + 1

		--> Variables
		local objectTitle 	= v.name 			or ""
		local objectDescr	= v.description 	or ""
		local objectMax 	= v.max 			or 0
		local objectModel 	= v.model 			or {}
		local objectPly 	= team.NumPlayers( v.team ) or 0

		local objectTextTitle 	= objectTitle
		local objectTextPly 	= "Players: " .. objectPly .. "/" .. objectMax

		--> Model
		if type( objectModel ) == "table" then
			objectModel = table.Random( objectModel )
		end

		--> Text Size
		surface.SetFont( "FG_JaapokkiRegular_19" )
		local tw, th = surface.GetTextSize( objectTextTitle )
		local pw, pt = surface.GetTextSize( objectTextPly )

		--> Object
		local object = self.ScrollLayout:Add( "DPanel" )
		object:SetSize( self.ScrollLayout:GetWide() / 2 - 47, 185 )

		object.Paint = function( pnl, w, h )

			--> Background			
			draw.RoundedBox( 4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color( 200, 200, 200, 255 ) )
			draw.RoundedBox( 4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color( 240, 240, 240, 255 ) )

			--> Border
			draw.RoundedBox( 0, 20-2, 35-2, 100+4, 100+4, Color( 200, 200, 200, 255 ) )
			draw.RoundedBox( 0, 20-1, 35-1, 100+2, 100+2, Color( 240, 240, 240, 255 ) )

			--> Title
			draw.RoundedBox( 4, 10, 0, tw + 8, 21, v.color )
			draw.DrawText( objectTextTitle, "FG_JaapokkiRegular_19", 14, 3, Color( 255, 255, 255, 255 ) )

			--> Players
			draw.RoundedBox( 4, w - pw - 18, 0, pw + 8, 21, Color( 180, 180, 180, 255 ) )
			draw.DrawText( objectTextPly, "FG_JaapokkiRegular_19", w - pw - 14, 3, Color( 255, 255, 255, 255 ) )

		end

		local objectImage = vgui.Create( "ModelImage", object )
		objectImage:SetSize( 100, 100 )
		objectImage:SetPos( 20, 35 )
		objectImage:SetModel( objectModel )

		local objectButton = vgui.Create( "FG-DButton", object )
		objectButton:SetSize( 100 + 4, 25 )
		objectButton:SetPos( 20 - 2, 35 + 10 + objectImage:GetTall() )
		objectButton:SetText( "Select" )

		if Disabled then

			objectButton.ButtonColor = Color( 150, 150, 150, 255 )

		else

			objectButton.ButtonColor = Color( 52, 152, 219, 255 )
			objectButton.DoClick = function( pnl ) 

				if istable( v.model ) and #v.model >= 2 then
				
					local Frame = vgui.Create( "FG-Frame" )
					Frame:SetSize( 360, 200 )
					Frame:SetTitle( "FlawlessGaming - Model Panel" )
					Frame:SetVisible( true )
					Frame:SetDraggable( true )
					Frame:ShowCloseButton( true )
					Frame:SetBackgroundBlur( true )
					Frame:Center()
					Frame:MakePopup()

					Frame.Think = function()
						if not object:IsVisible() then
							
							Frame:Close()

						end
					end

					local InsideBox 	= Frame.InsideBox
					local InsideBoxW	= Frame:GetWide() - 20 * 2
					local InsideBoxH	= Frame:GetTall() - 30 - 36 * 2

					local modelx = 10
					local modely = 10
					local modeli = 0

					for _,plymodel in pairs( v.model ) do
						
						local modelbtn = vgui.Create( "DButton", InsideBox )
						modelbtn:SetSize( 70, 70 )
						modelbtn:SetPos( modelx, modely )
						modelbtn.Paint = function( pnl, w, h )

							draw.RoundedBox( 0, 0, 0, w-0, h-0, Color( 200, 200, 200, 255 ) )
							draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 240, 240, 240, 255 ) )

						end
						modelbtn.DoClick = function()

							DarkRP.setPreferredJobModel( v.team, plymodel )
							UseItem( v, objectButton, function() RunConsoleCommand( "fg_f4menu_close" ) end ) 
							Frame:Close()

						end

						local model = vgui.Create( "ModelImage", InsideBox )
						model:SetSize( 70-4, 70-4 )
						model:SetPos( modelx+2, modely+2 )
						model:SetModel( plymodel )
						model:SetMouseInputEnabled( false)

						modelx = modelx + model:GetWide() + 10
						modeli = modeli + 1

						if modeli == 4 or modeli == 8 or modeli == 12 then
							
							modelx = 10
							modely = modely + model:GetTall() + 10

						end

						if modeli == #v.model then
							
							modely = modely + model:GetTall() + 10

						end

					end

					Frame:SetHeight( 75 + modely )

				else

					UseItem( v, objectButton, function() RunConsoleCommand( "fg_f4menu_close" ) end ) 

				end

				

			end

		end
		

		local objectDescription = vgui.Create( "DLabel", object )
		objectDescription:SetSize( object:GetWide() - 100 - 50, object:GetTall() - 35 - 15 )
		objectDescription:SetPos( 130, 35 )
		objectDescription:SetFont( "FG_JaapokkiRegular_20" )
		objectDescription:SetTextColor( Color( 50, 50, 50, 255 ) )
		objectDescription:SetAutoStretchVertical( true )
		objectDescription:SetText( DarkRP.textWrap( DarkRP.deLocalise( objectDescr ):gsub( '\t', '' ), "FG_JaapokkiRegular_20", objectDescription:GetWide() ) )

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
derma.DefineControl( "FG-F4Menu-Jobs", "FG-F4Menu-Jobs", PANEL, "FG-DScrollPanel" )