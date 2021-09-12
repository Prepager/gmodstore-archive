local PANEL = {}


--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	local MenuCreated = CurTime() + 1

	--> Menu - Size
	local MenuWidth 	= ScrW() - 200
	local MenuHeight	= ScrH() - 200

	if MenuWidth 	> 950 then MenuWidth  = 950 end
	if MenuHeight 	> 700 then MenuHeight = 700 end

	--> Menu - Create
	self:SetSize( MenuWidth, MenuHeight )
	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH() )
	self:SetTitle( "FlawlessGaming - F4 Menu" )
	self:SetVisible( true )
	self:SetDraggable( true )
	self:ShowCloseButton( true )
	self:SetBackgroundBlur( true )
	self:MakePopup()
	self:MoveTo( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2, 0.2, 0 )

	--> Menu - Variables
	self.InsideBox 	= self.InsideBox
	self.InsideBoxW	= self:GetWide() - 20 * 2
	self.InsideBoxH	= self:GetTall() - 30 - 36 * 2

	--> Panels
	self.PanelDefault = vgui.Create( "DPanel", self.InsideBox )
	self.PanelDefault:SetPos( 0 + 10, 32 + 10 )
	self.PanelDefault:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelDefault:SetVisible( false )

	--> Menu - Tabs Panels
	self.PanelCmds = vgui.Create( "FG-F4Menu-Cmds", self.InsideBox )
	self.PanelCmds:SetPos( 0 + 10, 32 + 10 )
	self.PanelCmds:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelCmds:SetVisible( false )
	self.PanelCmds:FillData()

	self.PanelJobs = vgui.Create( "FG-F4Menu-Jobs", self.InsideBox )
	self.PanelJobs:SetPos( 0 + 10, 32 + 10 )
	self.PanelJobs:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelJobs:SetVisible( false )
	self.PanelJobs:FillData()

	self.PanelEntities = vgui.Create( "FG-F4Menu-Entities", self.InsideBox )
	self.PanelEntities:SetPos( 0 + 10, 32 + 10 )
	self.PanelEntities:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelEntities:SetVisible( false )
	self.PanelEntities:FillData()

	self.PanelWeapons = vgui.Create( "FG-F4Menu-Weapons", self.InsideBox )
	self.PanelWeapons:SetPos( 0 + 10, 32 + 10 )
	self.PanelWeapons:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelWeapons:SetVisible( false )
	self.PanelWeapons:FillData()

	self.PanelShipments = vgui.Create( "FG-F4Menu-Shipments", self.InsideBox )
	self.PanelShipments:SetPos( 0 + 10, 32 + 10 )
	self.PanelShipments:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelShipments:SetVisible( false )
	self.PanelShipments:FillData()

	self.PanelAmmo = vgui.Create( "FG-F4Menu-Ammo", self.InsideBox )
	self.PanelAmmo:SetPos( 0 + 10, 32 + 10 )
	self.PanelAmmo:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelAmmo:SetVisible( false )
	self.PanelAmmo:FillData()

	self.PanelFood = vgui.Create( "FG-F4Menu-Food", self.InsideBox )
	self.PanelFood:SetPos( 0 + 10, 32 + 10 )
	self.PanelFood:SetSize( self.InsideBoxW - 20, self.InsideBoxH - 20 )
	self.PanelFood:SetVisible( false )
	self.PanelFood:FillData()

	--> Menu - Tabs Settings
	self.TabsActivePanel 	= nil
	self.TabsActiveButton	= nil

	local TabsButtonPosX 	= 0
	local TabsButtonID 		= 0

	local Tabs = {
		{ "Commands", 	self.PanelCmds },
		{ "Jobs", 		self.PanelJobs },
		{ "Entities", 	self.PanelEntities },
		{ "Weapons", 	self.PanelWeapons },
		{ "Shipments",	self.PanelShipments },
		{ "Ammo",		self.PanelAmmo },
	}

	--> Hungermod
	if !DarkRP.disabledDefaults["modules"]["hungermod"] then
		table.insert(Tabs, {"Food", self.PanelFood})
	end

	--> Menu - Tabs
	for k,v in pairs( Tabs ) do
		
		--> Variables
		TabsButtonID = TabsButtonID + 1

		--> Create Button
		local ButtonTab = vgui.Create( "FG-DButton-Tab", self.InsideBox )
		ButtonTab:SetPos( TabsButtonPosX, 0 )
		ButtonTab:SetSize( self.InsideBoxW / #Tabs, 32 )
		ButtonTab:SetText( "" )

		--> Button - DoClick
		ButtonTab.DoClick = function()

			--> Active Panel
			if ValidPanel( self.TabsActivePanel ) and self.TabsActivePanel != nil then
				self.TabsActivePanel:SetVisible( false )
			end

			self.TabsActivePanel = v[2]
			self.TabsActivePanel:SetVisible( true )

			self.TabsActivePanel:ReFillData()

			--> Active Button
			if ValidPanel( self.TabsActiveButton ) and self.TabsActiveButton != nil then
				self.TabsActiveButton.Active = false
			end

			self.TabsActiveButton = ButtonTab
			self.TabsActiveButton.Active = true

		end

		--> Button - Settings
		ButtonTab.ButtonText 	= tostring( v[1] )
		ButtonTab.Active 		= false
		ButtonTab.Last 			= false

		--> Button - Modify
		if TabsButtonID == #Tabs then
			ButtonTab.Last = true
		end

		if TabsButtonID == 1 then
			
			--> Active Panel
			self.TabsActivePanel = v[2]
			self.TabsActivePanel:SetVisible( true )

			--> Active Button
			self.TabsActiveButton = ButtonTab
			self.TabsActiveButton.Active = true

		end

		--> Variables 
		TabsButtonPosX = TabsButtonPosX + ButtonTab:GetWide()

	end

end


--[[---------------------------------------------------------
	Name: Define
-----------------------------------------------------------]]
derma.DefineControl( "FG-F4Menu", "FG-F4Menu", PANEL, "FG-Frame" )