--[[---------------------------------------------------------
	Name: Files
-----------------------------------------------------------]]
include('shared.lua')

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	--> Item
	self.item = nil
	self.item = ClientsideModel('models/freeman/moneyprinters/coolers/cooler_2.mdl', RENDERGROUP_OPAQUE)

end

--[[---------------------------------------------------------
	Name: Draw
-----------------------------------------------------------]]
function ENT:Draw()

	--> Variables
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	--> Check Cooler
	if !IsValid(self.item) then
		self.item = ClientsideModel('models/freeman/moneyprinters/coolers/cooler_2.mdl', RENDERGROUP_OPAQUE)
	end

	--> Cooler
	local CoolerPos = Pos + (Ang:Forward() * 17.5) + (Ang:Right() * -11.8) + (Ang:Up() * 3.8)

	self.item:SetPos(CoolerPos)
	self.item:SetAngles(Ang)
	self.item:SetRenderOrigin(CoolerPos)
	self.item:SetRenderAngles(Ang)
	self.item:SetupBones()
	self.item:DrawModel()
	self.item:SetRenderOrigin()
	self.item:SetRenderAngles()

	--> Base
	self:DrawModel()

	--> Variables
	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or 'Unknown'

	local AngTop = self:GetAngles()
	local AngBot = self:GetAngles()

	local money = self:Getdata_money()
	if money == 0 then moneycolor = self.pColor else moneycolor = Color(0, 255, 0, 255) end

	if self.pStorage != 0 then
		money = money..'/'..self.pStorage
	end

	--> Angle
	AngTop:RotateAroundAxis(AngTop:Up(), 90)
	
	--> Panel - Top
	cam.Start3D2D(Pos + AngTop:Up() * 10.7, AngTop, 0.1)

		draw.RoundedBox(0, -152, -164, 308, 308, Color(0, 0, 0, 150))

		draw.RoundedBox(0, -152, -70, 308, 10, Color(0, 0, 0, 30))
		draw.RoundedBox(0, -152, 0, 308, 10, Color(0, 0, 0, 30))


		draw.DrawText(self.pName, 'FG_JaapokkiRegular_50', -164+308/2+12, -135, Color(255, 255, 255, 255), 1)
		draw.DrawText(owner, 'FG_JaapokkiRegular_42', -164+308/2+12, -50, Color(255, 255, 255, 255), 1)
		draw.DrawText('$'..money, 'FG_JaapokkiRegular_50', -164+308/2+12, 55, moneycolor, 1)

	cam.End3D2D()

	--> Angle
	AngBot:RotateAroundAxis(AngBot:Right(), 270)
	AngBot:RotateAroundAxis(AngBot:Up(), 90)
	
	--> Panel - Front (Large)
	cam.Start3D2D(Pos + AngBot:Up() * 16.3, AngBot, 0.1)
		draw.RoundedBox(0, -145, -102, 220, 96, Color(0, 0, 0, 200))

		draw.DrawText('Speed:', 'FG_JaapokkiRegular_24', -145 + 34, -92+26*0, Color(255, 255, 255, 255), 1)
		draw.DrawText('Quality:', 'FG_JaapokkiRegular_24', -145 + 34, -92+26*1, Color(255, 255, 255, 255), 1)
		draw.DrawText('Cooler:', 'FG_JaapokkiRegular_24', -145 + 34, -92+26*2, Color(255, 255, 255, 255), 1)

		draw.RoundedBox(0, -75, -92+26*0+2, 140, 20, Color(0, 0, 0, 30))
		draw.RoundedBox(0, -75, -92+26*1+2, 140, 20, Color(0, 0, 0, 30))
		draw.RoundedBox(0, -75, -92+26*2+2, 140, 20, Color(0, 0, 0, 30))

		draw.RoundedBox(0, -75, -92+26*0+2, (140)/10*self:Getlvl_speed(), 20, Color(self.pColor.r, self.pColor.g, self.pColor.b, 150))
		draw.RoundedBox(0, -75, -92+26*1+2, (140)/10*self:Getlvl_quality(), 20, Color(self.pColor.r, self.pColor.g, self.pColor.b, 150))
		draw.RoundedBox(0, -75, -92+26*2+2, (140)/10*self:Getlvl_cooler(), 20, Color(self.pColor.r, self.pColor.g, self.pColor.b, 150))

		draw.DrawText(self:Getlvl_speed(), 'FG_JaapokkiRegular_24', -75 + 140/2, -92+26*0+2, Color(255, 255, 255, 255), 1)
		draw.DrawText(self:Getlvl_quality(), 'FG_JaapokkiRegular_24', -75 + 140/2, -92+26*1+2, Color(255, 255, 255, 255), 1)
		draw.DrawText(self:Getlvl_cooler(), 'FG_JaapokkiRegular_24', -75 + 140/2, -92+26*2+2, Color(255, 255, 255, 255), 1)

	cam.End3D2D()

	--> Panel - Front (Small)
	cam.Start3D2D(Pos + AngBot:Up() * 16.7, AngBot, 0.1)

		draw.RoundedBox(0, 80, -94, 70, 22, Color(0, 0, 0, 200))

		local tempColor = Color(255, 255, 255, 255)

		if self:Getdata_temp() >= 50 then
			tempColor = Color(200, 225, 0, 255)
		elseif self:Getdata_temp() >= 75 then
			tempColor = Color(220, 0, 0, 255)
		end

		draw.DrawText(math.Round(self:Getdata_temp(), 2)..' °C', 'FG_JaapokkiRegular_24', 80+40, -92, tempColor, 1)

	cam.End3D2D()

end

--[[---------------------------------------------------------
	Name: OnRemove
-----------------------------------------------------------]]
function ENT:OnRemove()

	--> Remove
	self.item:Remove()

end

--[[---------------------------------------------------------
	Name: Menu
-----------------------------------------------------------]]
function ENT:PrinterMenu()

	--> Frame
	local Frame = vgui.Create('FG-Frame')
	Frame:SetSize(400, 610)
	Frame:SetPos(ScrW()/2 - Frame:GetWide()/2, ScrH())
	Frame:SetTitle(self.pTitle)
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:SetBackgroundBlur(true)
	Frame:MakePopup()
	Frame:MoveTo(ScrW()/2 - Frame:GetWide()/2, ScrH()/2 - Frame:GetTall()/2, 0.2, 0)

	--> Frame - Variables
	local InsideBox 	= Frame.InsideBox
	local InsideBoxW	= Frame:GetWide() - 20 * 2
	local InsideBoxH 	= Frame:GetTall() - 30 - 36 * 2

	local MenuY 		= 10

	--> Levels
	local lvl_speed		= self:Getlvl_speed()	or 0
	local lvl_quality	= self:Getlvl_quality()	or 0
	local lvl_cooler	= self:Getlvl_cooler()	or 0

	local data_power	= self:Getdata_power()	or 0
	local data_money	= self:Getdata_money()	or 0

	--> Valid
	Frame.Think = function()
		if !self or !IsValid(self) then Frame:Close() end
	end

	--[[==========================================================================================]]--

	--> Text
	surface.SetFont('FG_JaapokkiRegular_19')
	local powerTW, powerTH = surface.GetTextSize('Power')

	--> Power
	local Power = vgui.Create('DPanel', InsideBox)
	Power:SetSize(InsideBoxW - 20, 92)
	Power:SetPos(10, MenuY)
	Power.Paint = function(pnl, w, h)

		--> Variables
		local varPower = self:Getdata_power() or 0

		--> Background			
		draw.RoundedBox(4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color(200, 200, 200, 255))
		draw.RoundedBox(4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color(240, 240, 240, 255))

		--> Title
		draw.RoundedBox(4, 10, 0, powerTW + 8, 21, Color(100, 100, 100, 255))
		draw.DrawText('Power', 'FG_JaapokkiRegular_19', 14, 3, Color(255, 255, 255, 255))

		--> Status
		if varPower == 0 then
			draw.DrawText('Status: Stopped', 'FG_JaapokkiRegular_22', w/2, 66, Color(50, 50, 50, 255), 1)
		else
			draw.DrawText('Status: Running', 'FG_JaapokkiRegular_22', w/2, 66, Color(50, 50, 50, 255), 1)
		end

	end

	--> Start
	local startButton = vgui.Create('DButton', Power)
	startButton:SetSize(Power:GetWide()/2-15, 24)
	startButton:SetPos(10, 35)
	startButton:SetText('')
	startButton.Paint = function(pnl, w, h)

		--> Variables
		local varPower = self:Getdata_power() or 0

		--> Background
		if varPower == 1 then
			draw.RoundedBox(4, 0, 0, w, h, Color(150, 150, 150, 255))
		else
			draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))
		end

		--> Hover
		if startButton.Hovered == true then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 50))
		end

		--> Text
		draw.DrawText('Start Printer', 'FG_JaapokkiRegular_22', w/2, 3, Color(255, 255, 255, 255), 1)

	end
	startButton.DoClick = function()
		if self:Getdata_power() == 0 then

			net.Start('fg_printer_power')
				net.WriteEntity(self)
			net.SendToServer(LocalPlayer())

		end
	end

	--> Stop
	local stopButton = vgui.Create('DButton', Power)
	stopButton:SetSize(Power:GetWide()/2-15, 24)
	stopButton:SetPos(10+Power:GetWide()/2-5, 35)
	stopButton:SetText('')
	stopButton.Paint = function(pnl, w, h)

		--> Variables
		local varPower = self:Getdata_power() or 0

		--> Background
		if varPower == 0 then
			draw.RoundedBox(4, 0, 0, w, h, Color(150, 150, 150, 255))
		else
			draw.RoundedBox(4, 0, 0, w, h, Color(231, 76, 60, 255))
		end

		--> Hover
		if stopButton.Hovered == true then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 50))
		end

		--> Text
		draw.DrawText('Stop Printer', 'FG_JaapokkiRegular_22', w/2, 3, Color(255, 255, 255, 255), 1)

	end
	stopButton.DoClick = function()
		if self:Getdata_power() == 1 then

			net.Start('fg_printer_power')
				net.WriteEntity(self)
			net.SendToServer(LocalPlayer())
			
		end
	end

	--> Menu Y
	MenuY = MenuY + Power:GetTall() + 10

	--[[==========================================================================================]]--

	--> Text
	surface.SetFont('FG_JaapokkiRegular_19')
	local moneyTW, moneyTH = surface.GetTextSize('Money')

	--> Power
	local Money = vgui.Create('DPanel', InsideBox)
	Money:SetSize(InsideBoxW - 20, 92)
	Money:SetPos(10, MenuY)
	Money.Paint = function(pnl, w, h)

		--> Variables
		local varMoney = self:Getdata_money() or 0

		--> Background			
		draw.RoundedBox(4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color(200, 200, 200, 255))
		draw.RoundedBox(4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color(240, 240, 240, 255))

		--> Title
		draw.RoundedBox(4, 10, 0, moneyTW + 8, 21, Color(100, 100, 100, 255))
		draw.DrawText('Money', 'FG_JaapokkiRegular_19', 14, 3, Color(255, 255, 255, 255))

		--> Money
		draw.DrawText('Money: $' .. varMoney, 'FG_JaapokkiRegular_22', w/2, 66, Color(50, 50, 50, 255), 1)

	end

	--> Start
	local collectButton = vgui.Create('DButton', Money)
	collectButton:SetSize(Money:GetWide()-20, 24)
	collectButton:SetPos(10, 35)
	collectButton:SetText('')
	collectButton.Paint = function(pnl, w, h)

		--> Variables
		local varMoney = self:Getdata_money() or 0

		--> Background
		if varMoney == 0 then
			draw.RoundedBox(4, 0, 0, w, h, Color(150, 150, 150, 255))
		else
			draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))
		end

		--> Hover
		if collectButton.Hovered == true then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 50))
		end

		--> Text
		draw.DrawText('Collect Money', 'FG_JaapokkiRegular_22', w/2, 3, Color(255, 255, 255, 255), 1)

	end
	collectButton.DoClick = function()
		if self:Getdata_money() != 0 then

			net.Start('fg_printer_money')
				net.WriteEntity(self)
			net.SendToServer(LocalPlayer())

		end
	end

	--> Menu Y
	MenuY = MenuY + Money:GetTall() + 10

	--[[==========================================================================================]]--


	--> Variables
	local speedTitle = 'Upgrade - Speed'
	local speedLevel = 'Level: '..lvl_speed
	local speedPrice = 'Price: $0'

	local speedNextP = 0
	local speedStars = {}
	local speedStarX = 10

	--> Upgrade Price
	if self.pLevelSpeed[lvl_speed + 1] then
		local speedNextP = self.pQuality / 100 * self.pLevelSpeed[lvl_speed + 1][2]
		speedPrice = 'Price: $'..speedNextP
	else
		speedPrice = 'Max Level Reached'
	end

	--> Text
	surface.SetFont('FG_JaapokkiRegular_19')
	local speedTW, speedTH = surface.GetTextSize(speedTitle)
	local speedLW, speedLH = surface.GetTextSize(speedLevel)

	--> Panel
	local LevelSpeed = vgui.Create('DPanel', InsideBox)
	LevelSpeed:SetSize(InsideBoxW - 20, 85)
	LevelSpeed:SetPos(10, MenuY)
	LevelSpeed.Paint = function(pnl, w, h)

		--> Background			
		draw.RoundedBox(4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color(200, 200, 200, 255))
		draw.RoundedBox(4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color(240, 240, 240, 255))

		--> Title
		draw.RoundedBox(4, 10, 0, speedTW + 8, 21, Color(100, 100, 100, 255))
		draw.DrawText(speedTitle, 'FG_JaapokkiRegular_19', 14, 3, Color(255, 255, 255, 255))

		--> Level
		draw.RoundedBox(4, w - speedLW - 18, 0, speedLW + 8, 21, Color(180, 180, 180, 255))
		draw.DrawText(speedLevel, 'FG_JaapokkiRegular_19', w - speedLW - 14, 3, Color(255, 255, 255, 255))

		--> Level
		draw.DrawText(speedPrice, 'FG_JaapokkiRegular_22', w/2, 62, Color(50, 50, 50, 255), 1)

	end

	--> Stars
	for i = 1,10 do
		
		--> Panel
		local star = vgui.Create('DPanel', LevelSpeed)
		star:SetSize(20, 20)
		star:SetPos(speedStarX, 35)
		star.Active = false
		star.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 30))

			--> Count
			if self.pLevelSpeed[i][3] == 1 then
				draw.RoundedBox(4, 4, 4, w-8, h-8, Color(155, 89, 182, 150))
			elseif self.pLevelSpeed[i][3] == 2 then
				draw.RoundedBox(4, 4, 4, w-8, h-8, Color(231, 76, 60, 150))
			end

			--> Active
			if star.Active == true then
				draw.RoundedBox(4, 0, 0, w, h, Color(52, 152, 219, 255))
			end

		end

		--> Active
		if i <= lvl_speed then star.Active = true end

		--> Table
		table.insert(speedStars, {i, star})

		--> Star X
		speedStarX = speedStarX + star:GetWide() + 10

	end

	--> Upgrade
	local speedUpgrade = vgui.Create('DButton', LevelSpeed)
	speedUpgrade:SetSize(20, 20)
	speedUpgrade:SetPos(speedStarX, 35)
	speedUpgrade:SetText('')
	speedUpgrade.Paint = function(pnl, w, h)

		draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))

		if speedUpgrade.Hovered == true then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 50))
		end

		draw.DrawText('+', 'FG_JaapokkiRegular_34', w/2, -7, Color(255, 255, 255, 255), 1)

	end
	speedUpgrade.DoClick = function()

		net.Start('fg_printer_upgrade_speed')
			net.WriteEntity(self)
		net.SendToServer(LocalPlayer())

		timer.Simple(0.5, function()
			
			for k,v in pairs(speedStars) do
				if v[1] <= self:Getlvl_speed() then
					
					v[2].Active = true

				end
			end

			surface.SetFont('FG_JaapokkiRegular_19')
			speedLevel = 'Level: ' .. self:Getlvl_speed()
			speedLW, speedLH = surface.GetTextSize(speedLevel)

			--> Upgrade Price
			if self.pLevelSpeed[self:Getlvl_speed()+1] then
				local speedNextP = self.pQuality / 100 * self.pLevelSpeed[self:Getlvl_speed()+1][2]
				speedPrice = 'Price: $' .. speedNextP
			else
				speedPrice = 'Max Level Reached'
			end

		end)

	end

	--> Menu Y
	MenuY = MenuY + LevelSpeed:GetTall() + 10

	--[[==========================================================================================]]--

	--> Variables
	local qualityTitle = 'Upgrade - Quality'
	local qualityLevel = 'Level: ' .. lvl_quality
	local qualityPrice = 'Price: $0'

	local qualityNextP = 0
	local qualityStars = {}
	local qualityStarX = 10

	--> Upgrade Price
	if self.pLevelQuality[lvl_quality + 1] then
		local qualityNextP = self.pQuality / 100 * self.pLevelQuality[lvl_quality + 1][2]
		qualityPrice = 'Price: $' .. qualityNextP
	else
		qualityPrice = 'Max Level Reached'
	end

	--> Text
	surface.SetFont('FG_JaapokkiRegular_19')
	local qualityTW, qualityTH = surface.GetTextSize(qualityTitle)
	local qualityLW, qualityLH = surface.GetTextSize(qualityLevel)

	--> Panel
	local LevelQuality = vgui.Create('DPanel', InsideBox)
	LevelQuality:SetSize(InsideBoxW - 20, 85)
	LevelQuality:SetPos(10, MenuY)
	LevelQuality.Paint = function(pnl, w, h)

		--> Background			
		draw.RoundedBox(4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color(200, 200, 200, 255))
		draw.RoundedBox(4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color(240, 240, 240, 255))

		--> Title
		draw.RoundedBox(4, 10, 0, qualityTW + 8, 21, Color(100, 100, 100, 255))
		draw.DrawText(qualityTitle, 'FG_JaapokkiRegular_19', 14, 3, Color(255, 255, 255, 255))

		--> Level
		draw.RoundedBox(4, w - qualityLW - 18, 0, qualityLW + 8, 21, Color(180, 180, 180, 255))
		draw.DrawText(qualityLevel, 'FG_JaapokkiRegular_19', w - qualityLW - 14, 3, Color(255, 255, 255, 255))

		--> Level
		draw.DrawText(qualityPrice, 'FG_JaapokkiRegular_22', w/2, 62, Color(50, 50, 50, 255), 1)

	end

	--> Stars
	for i = 1,10 do
		
		--> Panel
		local star = vgui.Create('DPanel', LevelQuality)
		star:SetSize(20, 20)
		star:SetPos(qualityStarX, 35)
		star.Active = false
		star.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 30))

			--> Count
			if self.pLevelQuality[i][3] == 1 then
				draw.RoundedBox(4, 4, 4, w-8, h-8, Color(155, 89, 182, 150))
			elseif self.pLevelQuality[i][3] == 2 then
				draw.RoundedBox(4, 4, 4, w-8, h-8, Color(231, 76, 60, 150))
			end

			--> Active
			if star.Active == true then
				draw.RoundedBox(4, 0, 0, w, h, Color(52, 152, 219, 255))
			end

		end

		--> Active
		if i <= lvl_quality then star.Active = true end

		--> Table
		table.insert(qualityStars, {i, star})

		--> Star X
		qualityStarX = qualityStarX + star:GetWide() + 10

	end

	--> Upgrade
	local qualityUpgrade = vgui.Create('DButton', LevelQuality)
	qualityUpgrade:SetSize(20, 20)
	qualityUpgrade:SetPos(qualityStarX, 35)
	qualityUpgrade:SetText('')
	qualityUpgrade.Paint = function(pnl, w, h)

		draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))

		if qualityUpgrade.Hovered == true then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 50))
		end

		draw.DrawText('+', 'FG_JaapokkiRegular_34', w/2, -7, Color(255, 255, 255, 255), 1)

	end
	qualityUpgrade.DoClick = function()

		net.Start('fg_printer_upgrade_quality')
			net.WriteEntity(self)
		net.SendToServer(LocalPlayer())

		timer.Simple(0.5, function()
			
			for k,v in pairs(qualityStars) do
				if v[1] <= self:Getlvl_quality() then
					
					v[2].Active = true

				end
			end

			surface.SetFont('FG_JaapokkiRegular_19')
			qualityLevel = 'Level: ' .. self:Getlvl_quality()
			qualityLW, qualityLH = surface.GetTextSize(qualityLevel)

			--> Upgrade Price
			if self.pLevelQuality[self:Getlvl_quality() + 1] then
				local qualityNextP = self.pQuality / 100 * self.pLevelQuality[self:Getlvl_quality() + 1][2]
				qualityPrice = 'Price: $' .. qualityNextP
			else
				qualityPrice = 'Max Level Reached'
			end

		end)

	end

	--> Menu Y
	MenuY = MenuY + LevelQuality:GetTall() + 10

	--[[==========================================================================================]]--

	--> Variables
	local coolerTitle = 'Upgrade - Cooler'
	local coolerLevel = 'Level: ' .. lvl_cooler
	local coolerPrice = 'Price: $0'

	local coolerNextP = 0
	local coolerStars = {}
	local coolerStarX = 10

	--> Upgrade Price
	if self.pLevelCooler[lvl_cooler + 1] then
		local coolerNextP = self.pQuality / 100 * self.pLevelCooler[lvl_cooler + 1][2]
		coolerPrice = 'Price: $' .. coolerNextP
	else
		coolerPrice = 'Max Level Reached'
	end

	--> Text
	surface.SetFont('FG_JaapokkiRegular_19')
	local coolerTW, coolerTH = surface.GetTextSize(coolerTitle)
	local coolerLW, coolerLH = surface.GetTextSize(coolerLevel)

	--> Panel
	local LevelCooler = vgui.Create('DPanel', InsideBox)
	LevelCooler:SetSize(InsideBoxW - 20, 85)
	LevelCooler:SetPos(10, MenuY)
	LevelCooler.Paint = function(pnl, w, h)

		--> Background			
		draw.RoundedBox(4, 0 + 0, 10 + 0, w - 0, h - 10 - 0, Color(200, 200, 200, 255))
		draw.RoundedBox(4, 0 + 1, 10 + 1, w - 2, h - 10 - 2, Color(240, 240, 240, 255))

		--> Title
		draw.RoundedBox(4, 10, 0, coolerTW + 8, 21, Color(100, 100, 100, 255))
		draw.DrawText(coolerTitle, 'FG_JaapokkiRegular_19', 14, 3, Color(255, 255, 255, 255))

		--> Level
		draw.RoundedBox(4, w - coolerLW - 18, 0, coolerLW + 8, 21, Color(180, 180, 180, 255))
		draw.DrawText(coolerLevel, 'FG_JaapokkiRegular_19', w - coolerLW - 14, 3, Color(255, 255, 255, 255))

		--> Level
		draw.DrawText(coolerPrice, 'FG_JaapokkiRegular_22', w/2, 62, Color(50, 50, 50, 255), 1)

	end

	--> Stars
	for i = 1,10 do
		
		--> Panel
		local star = vgui.Create('DPanel', LevelCooler)
		star:SetSize(20, 20)
		star:SetPos(coolerStarX, 35)
		star.Active = false
		star.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 30))

			--> Count
			if self.pLevelCooler[i][3] == 1 then
				draw.RoundedBox(4, 4, 4, w-8, h-8, Color(155, 89, 182, 150))
			elseif self.pLevelCooler[i][3] == 2 then
				draw.RoundedBox(4, 4, 4, w-8, h-8, Color(231, 76, 60, 150))
			end

			--> Active
			if star.Active == true then
				draw.RoundedBox(4, 0, 0, w, h, Color(52, 152, 219, 255))
			end

		end

		--> Active
		if i <= lvl_cooler then star.Active = true end

		--> Table
		table.insert(coolerStars, {i, star})

		--> Star X
		coolerStarX = coolerStarX + star:GetWide() + 10

	end

	--> Upgrade
	local coolerUpgrade = vgui.Create('DButton', LevelCooler)
	coolerUpgrade:SetSize(20, 20)
	coolerUpgrade:SetPos(coolerStarX, 35)
	coolerUpgrade:SetText('')
	coolerUpgrade.Paint = function(pnl, w, h)

		draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))

		if coolerUpgrade.Hovered == true then
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 50))
		end

		draw.DrawText('+', 'FG_JaapokkiRegular_34', w/2, -7, Color(255, 255, 255, 255), 1)

	end
	coolerUpgrade.DoClick = function()

		net.Start('fg_printer_upgrade_cooler')
			net.WriteEntity(self)
		net.SendToServer(LocalPlayer())

		timer.Simple(0.5, function()
			
			for k,v in pairs(coolerStars) do
				if v[1] <= self:Getlvl_cooler() then
					
					v[2].Active = true

				end
			end

			surface.SetFont('FG_JaapokkiRegular_19')
			coolerLevel = 'Level: ' .. self:Getlvl_cooler()
			coolerLW, coolerLH = surface.GetTextSize(coolerLevel)

			--> Upgrade Price
			if self.pLevelCooler[self:Getlvl_cooler() + 1] then
				local coolerNextP = self.pQuality / 100 * self.pLevelCooler[self:Getlvl_cooler() + 1][2]
				coolerPrice = 'Price: $' .. coolerNextP
			else
				coolerPrice = 'Max Level Reached'
			end

		end)

	end

	--> Menu Y
	MenuY = MenuY + LevelCooler:GetTall() + 10

	--[[==========================================================================================]]--

	--> Upgrade Info
	local UpgradeInfo = vgui.Create('DPanel', InsideBox)
	UpgradeInfo:SetSize(InsideBoxW - 20, 30)
	UpgradeInfo:SetPos(10, MenuY)
	UpgradeInfo.Paint = function(pnl, w, h)

		--> Background			
		draw.RoundedBox(4, 0 + 0, 0, w - 0, h - 0, Color(200, 200, 200, 255))
		draw.RoundedBox(4, 0 + 1, 1, w - 2, h - 2, Color(240, 240, 240, 255))

		--> Border
		draw.RoundedBox(0, w/2-1, 1, 2, h-2, Color(200, 200, 200, 255))

		--> Ranks
		draw.RoundedBox(4, w/2-26, 5, 20-0, 20-0, Color(0, 0, 0, 30))
		draw.RoundedBox(4, w/2-22, 9, 20-8, 20-8, Color(155, 89, 182, 150))

		draw.DrawText('Donator Only', 'FG_JaapokkiRegular_22', (w/2-26)/2, 6, Color(30, 30, 30, 255), 1)

		draw.RoundedBox(4, w/2+6, 5, 20, 20, Color(0, 0, 0, 30))
		draw.RoundedBox(4, w/2+10, 9, 20-8, 20-8, Color(231, 76, 60, 150))

		draw.DrawText('Staff Only', 'FG_JaapokkiRegular_22', (w/2+6)*1.5, 6, Color(30, 30, 30, 255), 1)

	end

end

--> PrinterMenu
local function PrinterMenu()

	--> Variables
	local printer = net.ReadEntity()
	if !printer or !IsValid(printer) then return end
	
	--> Open
	printer:PrinterMenu()

end
net.Receive('fg_printer_menu', PrinterMenu)