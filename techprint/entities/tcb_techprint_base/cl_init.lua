--[[---------------------------------------------------------
	Name: Files
-----------------------------------------------------------]]
include('shared.lua')

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	--> Colors
	self._colors = {
		Color(self.pColor.r, self.pColor.g, self.pColor.b, 255),
		Color(self.pColor.r, self.pColor.g, self.pColor.b, 100),

		Color(0, 0, 0, 40),
		Color(0, 0, 0, 50),
		Color(0, 0, 0, 80),
		Color(0, 0, 0, 100),
		Color(0, 0, 0, 125),
		Color(0, 0, 0, 150),
		Color(0, 0, 0, 240),

		Color(255, 255, 255, 255),
		Color(255, 0, 0, 200),
		Color(0, 255, 0, 255),
		Color(0, 255, 0, 200)
	}

	self.colors = table.Copy(self._colors)

end

--[[---------------------------------------------------------
	Name: Draw
-----------------------------------------------------------]]
function ENT:Draw()
	
	--self:Initialize() 
	self:DrawModel()

	--> Distance
	local playerPos = LocalPlayer():GetPos()
	local distance = playerPos:Distance(self:GetPos())

	--> Fade
	local fadeStart = self.pFadeStart
	local fadeStop = self.pFadeStop
	local fadeDist = fadeStop-fadeStart

	if distance >= fadeStart and distance <= fadeStop then
		for k,v in pairs(self._colors) do

			--> Alpha
			local alphaColor = self._colors[k].a/fadeDist
			alphaColor = alphaColor*(fadeStop-distance)

			--> Save
			self.colors[k].a = math.Round(alphaColor)

		end
	else

		--> Color
		self.colors = table.Copy(self._colors)

	end

	--> Draw
	if distance <= fadeStop then

		--> Top
		self:DrawPanelTop()

		--> Front
		self:DrawPanelFront()

		--> Display
		self:DrawPanelDisplay()

		--> Power
		self:DrawPanelPower()

		--> Sides
		self:DrawPanelSideLeft()
		self:DrawPanelSideRight()

	end

end

--[[---------------------------------------------------------
	Name: WorldToScreen
-----------------------------------------------------------]]
local function WorldToScreen(vPos, vScale, aRot)
	local hit = LocalPlayer():GetEyeTrace().HitPos

	hit = hit - vPos
    hit:Rotate(Angle(0, -aRot.y, 0))
    hit:Rotate(Angle(-aRot.p, 0, 0))
    hit:Rotate(Angle(0, 0, -aRot.r))

    return hit.x / vScale, (-hit.y) / vScale
end

--[[---------------------------------------------------------
	Name: DrawPanelTop
-----------------------------------------------------------]]
function ENT:DrawPanelTop()

	--> Variables
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), 90)
	pos = pos + ang:Up() * 10.6 - ang:Forward() * 15.2 - ang:Right() * 16.4

	--> Panel
	local posX, posY = WorldToScreen(pos, 0.1, ang)
	local mouseUse = LocalPlayer():KeyDown(IN_USE) and !LocalPlayer():KeyDown(IN_ATTACK)
	cam.Start3D2D(pos, ang, 0.1)

		--> Variables
		local boxWidth = 307
		local boxHeight = 309

		--> Background
		draw.RoundedBox(0, 0, 0, boxWidth, boxHeight, self.colors[2])

		--> Printer
		local printerH = 60
		local printerY = 10

		draw.RoundedBox(4, 8, printerY, boxWidth-16, printerH, self.colors[6])
		draw.RoundedBox(4, 10, printerY+2, boxWidth-20, printerH-4, self.colors[8])
		draw.SimpleTextOutlined(self.PrintName, 'segoe_bold_34', boxWidth/2, (printerH+15)/2, self.colors[10], 1, 1, 2, self.colors[3])

		--> Player
		local playerH = 50
		local playerY = boxHeight-playerH-10
		local playerT = (IsValid(self:Getowning_ent()) and self:Getowning_ent():Nick()) or DarkRP.getPhrase("unknown")

		draw.RoundedBox(4, 8, playerY, boxWidth-16, playerH, self.colors[6])
		draw.RoundedBox(4, 10, playerY+2, boxWidth-20, playerH-4, self.colors[8])
		draw.SimpleTextOutlined(playerT, 'segoe_semibold_24', boxWidth/2, playerY+playerH/2, self.colors[10], 1, 1, 2, self.colors[3])

		--> Body 6575c87eb19eb689c450e2aa38b80845ecc534bd95363f7f0377e12ca5ab14e7
		local bodyH = boxHeight-printerH-playerH-40
		local bodyY = printerY+printerH+10

		draw.RoundedBox(4, 8, bodyY, boxWidth-16, bodyH, self.colors[4])
		draw.RoundedBox(4, 10, bodyY+2, boxWidth-20, bodyH-4, self.colors[7])
		draw.RoundedBox(0, 10, bodyY+(bodyH/2)-1, boxWidth-20, 2, self.colors[6])
		draw.RoundedBox(0, boxWidth/2-1, bodyY+2, 2, boxHeight/4, self.colors[6])

		--> Stored
		local storedT = self:GetStoredMoney() or 0

		local maxStore = self:GetMaxStore() or 0
		if maxStore != 0 then
			storedT = storedT..'/'..self:GetMaxStore()
		end

		draw.SimpleTextOutlined('STORED', 'segoe_semibold_24', boxWidth/4+5, bodyY+30, self.colors[10], 1, 1, 2, self.colors[3])
		draw.SimpleTextOutlined('$'..storedT, 'segoe_semibold_24', boxWidth/4+5, bodyY+50, self.colors[12], 1, 1, 2, self.colors[3])

		--> Rate
		local rateT = math.Round(self.pRate*math.pow((self.pUpgrade/100)+1, self:GetSpeedLevel()-1), 2)
		draw.SimpleTextOutlined('RATE', 'segoe_semibold_24', boxWidth/4*3-5, bodyY+30, self.colors[10], 1, 1, 2, self.colors[3])
		draw.SimpleTextOutlined('$'..rateT..'/Sec', 'segoe_semibold_24', boxWidth/4*3-5, bodyY+50, self.colors[12], 1, 1, 2, self.colors[3])

		--> Speed
		local speedY = bodyY+bodyH/2
		local speedX = 26
		local speedL = self:GetSpeedLevel() or 0
		local speedH = 0
		draw.SimpleTextOutlined('SPEED', 'segoe_semibold_24', boxWidth/2, speedY+14, self.colors[10], 1, 1, 2, self.colors[3])

		for i=1,10 do
			draw.RoundedBox(4, speedX, speedY+26, 20, 20, self.colors[6])
			if speedL >= i then
				draw.RoundedBox(4, speedX+2, speedY+28, 20-4, 20-4, self.colors[1])
			elseif posX >= speedX and posX <= speedX+20 and posY >= speedY+26 and posY <= speedY+46 then
				draw.SimpleTextOutlined('E', 'segoe_bold_22', speedX+20/2, speedY+35, self.colors[10], 1, 1, 2, self.colors[3])
				speedH = i
				if mouseUse and (!self.mouseDelay or CurTime() > self.mouseDelay) then
					net.Start('tcb_upgrade_speed')
						net.WriteInt(speedH, 32)
					net.SendToServer()
					self.mouseDelay = CurTime()+1
				end
			end
			speedX = speedX+26
		end

		draw.RoundedBox(4, boxWidth/2-75, speedY+50, 150, 24, self.colors[6])

		if speedL != 10 then
			if speedH == 0 then
				draw.SimpleTextOutlined('PRICE: HOVER SLOT', 'segoe_semibold_18', boxWidth/2, speedY+63, self.colors[10], 1, 1, 2, self.colors[3])
			else
				local price = (self:GetBuyPrice()/100*self.pUpgrade)*(speedH-self:GetSpeedLevel())
				draw.SimpleTextOutlined('PRICE: $'..price, 'segoe_semibold_18', boxWidth/2, speedY+63, self.colors[10], 1, 1, 2, self.colors[3])
			end
		else
			draw.SimpleTextOutlined('MAXED OUT', 'segoe_semibold_18', boxWidth/2, speedY+63, self.colors[10], 1, 1, 2, self.colors[3])
		end


	cam.End3D2D()

end

--[[---------------------------------------------------------
	Name: DrawPanelFront
-----------------------------------------------------------]]
function ENT:DrawPanelFront()

	--> Variables
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos + ang:Up() * 16.2 - ang:Forward() * 14.4 - ang:Right() * 10.2

	--> Panel
	local posX, posY = WorldToScreen(pos, 0.1, ang)
	local mouseUse = LocalPlayer():KeyDown(IN_USE) and !LocalPlayer():KeyDown(IN_ATTACK)
	cam.Start3D2D(pos, ang, 0.1)

		--> Variables
		local boxWidth = 220
		local boxHeight = 95

		--> Background
		draw.RoundedBox(0, 0, 0, boxWidth, boxHeight, self.colors[2])

		--> Health
		local healthW = (boxWidth-16)/2-5
		local healthH = (boxHeight-16)/2-5
		local healthC = Color(self.colors[13].r, self.colors[13].g, self.colors[13].b, self.colors[13].a)
		local healthV = self:GetPrinterHealth()

		if healthV > 50 then
			healthC.r = (255/50)*(self.pHealth-healthV)
			healthC.g = 255
		else
			local colorG = (255/50)*healthV
			if colorG < 0 then colorG = 0 end
			healthC.r = 255
			healthC.g = colorG
		end

		draw.RoundedBox(2, 8, 8, healthW, healthH, self.colors[6])
		draw.RoundedBox(2, 10, 10, healthW-4, healthH-4, healthC)

		draw.SimpleTextOutlined('HP: '..healthV..'%', 'segoe_semibold_18', (healthW+5)/2+5, (healthH+10)/2+2, self.colors[10], 1, 1, 1, self.colors[5])

		--> Takeover
		local takeoverW = (boxWidth-16)/2-5
		local takeoverH = (boxHeight-16)/2-5
		local takeoverX = 8+takeoverW+10
		local takeoverC = Color(self.colors[11].r, self.colors[11].g, self.colors[11].b, self.colors[11].a)
		local takeoverV = self:GetCaptureTime()
		local takeoverF = takeoverV-CurTime()
		local takeoverT = 0

		if takeoverF <= 0 then
			takeoverC.r = 0
			takeoverC.g = 255
		elseif takeoverF > (self.pStealTime/2) then
			takeoverC.r = (255/(self.pStealTime/2))*(self.pStealTime-takeoverF)
			takeoverC.g = 255
		else
			local colorG = (255/(self.pStealTime/2))*takeoverF
			if colorG < 0 then colorG = 0 end
			takeoverC.r = 255
			takeoverC.g = colorG
		end

		draw.RoundedBox(2, takeoverX, 8, takeoverW, takeoverH, self.colors[6])
		draw.RoundedBox(2, takeoverX+2, 10, takeoverW-4, takeoverH-4, takeoverC)

		if takeoverF > 0 then
			takeoverT = takeoverF
		else
			takeoverT = 0
		end

		draw.SimpleTextOutlined('TIME: '..string.FormattedTime(takeoverT, '%02i:%02i'), 'segoe_semibold_18', takeoverX+(takeoverW+5)/2-2, (takeoverH+10)/2+2, self.colors[10], 1, 1, 1, self.colors[5])

		--> Notify
		local notifyW = (boxWidth-16)/2-5
		local notifyH = (boxHeight-16)/2-5
		local notifyY = 8+notifyH+10
		local notifyC = self.colors[11]
		local notifyT = "WARN $"..self:GetBuyPrice()/100*self.pNotifyPrice

		if self:GetNotifyUpgrade() then
			notifyC = self.colors[13]
			notifyT = "ENABLED"
		end

		draw.RoundedBox(2, 8, notifyY, notifyW, notifyH, self.colors[6])
		draw.RoundedBox(2, 10, notifyY+2, notifyW-4, notifyH-4, notifyC)

		if posX >= 10 and posX <= 10+notifyW-4 and posY >= notifyY+2 and posY <= notifyY+2+notifyH-4 then
			draw.RoundedBox(2, 10, notifyY+2, notifyW-4, notifyH-4, self.colors[6])
			if mouseUse and (!self.mouseDelay or CurTime() > self.mouseDelay) then
				net.Start('tcb_upgrade_notify')
				net.SendToServer()
				self.mouseDelay = CurTime()+1
			end
		end

		draw.SimpleTextOutlined(notifyT, 'segoe_semibold_18', 10+(notifyW)/2-2, notifyY+(notifyH+10)/2-6, self.colors[10], 1, 1, 1, self.colors[5])

		--> Start Takeover
		local stakeoverW = (boxWidth-16)/2-5
		local stakeoverH = (boxHeight-16)/2-5
		local stakeoverX = 8+stakeoverW+10
		local stakeoverY = 8+stakeoverH+10
		local stakeoverC = self.colors[11]
		local stakeoverT = 'STEAL'

		draw.RoundedBox(2, stakeoverX, stakeoverY, stakeoverW, stakeoverH, self.colors[6])
		draw.RoundedBox(2, stakeoverX+2, stakeoverY+2, stakeoverW-4, stakeoverH-4, stakeoverC)

		if posX >= stakeoverX+2 and posX <= stakeoverX+stakeoverW-4 and posY >= stakeoverY+2 and posY <= stakeoverY+2+stakeoverH-4 then
			draw.RoundedBox(2, stakeoverX+2, stakeoverY+2, stakeoverW-4, stakeoverH-4, self.colors[6])
			if mouseUse and (!self.mouseDelay or CurTime() > self.mouseDelay) then
				net.Start('tcb_printer_steal')
				net.SendToServer()
				self.mouseDelay = CurTime()+1
			end
		end

		if takeoverF > 0 then
			stakeoverT = 'ABORT'
		end

		draw.SimpleTextOutlined(stakeoverT, 'segoe_semibold_18', stakeoverX+(stakeoverW+5)/2-2, stakeoverY+(stakeoverH+10)/2-6, self.colors[10], 1, 1, 1, self.colors[5])

	cam.End3D2D()


end

--[[---------------------------------------------------------
	Name: DrawPanelDisplay
-----------------------------------------------------------]]
function ENT:DrawPanelDisplay()

	--> Variables
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos + ang:Up() * 16.7 + ang:Forward() * 8.5 - ang:Right() * 9.4

	--> Panel
	cam.Start3D2D(pos, ang, 0.1)

		--> Variables
		local boxWidth = 65
		local boxHeight = 22
		local boxTemp = math.Round(self:GetTemperature(), 1)
		local boxColor = Color(self.colors[13].r, self.colors[13].g, self.colors[13].b, self.colors[13].a)

		--> Color
		if boxTemp <= 60 then
			boxColor.r = (255/40)*(boxTemp-20)
			boxColor.g = 255
		elseif boxTemp > 60 then
			local colorG = (255/40)*(40-(boxTemp-60))
			if colorG < 0 then colorG = 0 end
			boxColor.r = 255
			boxColor.g = colorG
		end

		--> Background
		draw.RoundedBox(0, 0, 0, boxWidth, boxHeight, self.colors[2])
		draw.RoundedBox(2, 2, 2, boxWidth-4, boxHeight-4, self.colors[6])
		draw.RoundedBox(2, 4, 4, boxWidth-8, boxHeight-8, boxColor)

		draw.SimpleTextOutlined(boxTemp..'°', 'segoe_semibold_14', boxWidth/2, (boxHeight-2)/2, self.colors[10], 1, 1, 1, self.colors[5])

	cam.End3D2D()


end

--[[---------------------------------------------------------
	Name: DrawPanelPower
-----------------------------------------------------------]]
function ENT:DrawPanelPower()

	--> Variables
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos + ang:Up() * 16.9 + ang:Forward() * 8.5 - ang:Right() * 5.8

	--> Panel 6575c87eb19eb689c450e2aa38b80845ecc534bd95363f7f0377e12ca5ab14e7
	local posX, posY = WorldToScreen(pos, 0.1, ang)
	local mouseUse = LocalPlayer():KeyDown(IN_USE) and !LocalPlayer():KeyDown(IN_ATTACK)
	cam.Start3D2D(pos, ang, 0.1)

		--> Variables
		local boxWidth = 65
		local boxHeight = 30
		local boxColor = Color(self.colors[11].r, self.colors[11].g, self.colors[11].b, self.colors[11].a)

		--> Color
		if !self:GetPower() then
			boxColor.r = 0
			boxColor.g = 255
		end

		--> Background
		draw.RoundedBox(0, 0, 0, boxWidth, boxHeight, self.colors[2])
		draw.RoundedBox(2, 2, 2, boxWidth-4, boxHeight-4, self.colors[6])
		draw.RoundedBox(2, 4, 4, boxWidth-8, boxHeight-8, boxColor)

		if posX >= 2 and posX <= boxWidth-4 and posY >= 2 and posY <= boxHeight-4 then
			draw.RoundedBox(2, 4, 4, boxWidth-8, boxHeight-8, self.colors[6])
			if mouseUse and (!self.mouseDelay or CurTime() > self.mouseDelay) then
				net.Start('tcb_printer_power')
				net.SendToServer()
				self.mouseDelay = CurTime()+1
			end
		end

		draw.SimpleTextOutlined('Power', 'segoe_semibold_14', boxWidth/2, (boxHeight-2)/2, self.colors[10], 1, 1, 1, self.colors[5])

	cam.End3D2D()


end

--[[---------------------------------------------------------
	Name: DrawPanelSideLeft
-----------------------------------------------------------]]
function ENT:DrawPanelSideLeft()

	--> Variables
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos + ang:Up() * 14.9 - ang:Forward() * 16.3 - ang:Right() * 10.5

	--> Panel
	cam.Start3D2D(pos, ang, 0.1)

		--> Variables
		local boxWidth = 309
		local boxHeight = 105

		--> Background
		draw.RoundedBox(0, 0, 0, boxWidth, boxHeight, self.colors[9])

	cam.End3D2D()


end

--[[---------------------------------------------------------
	Name: DrawPanelSideRight 6575c87eb19eb689c450e2aa38b80845ecc534bd95363f7f0377e12ca5ab14e7
-----------------------------------------------------------]]
function ENT:DrawPanelSideRight()

	--> Variables
	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos - ang:Up() * 15.3 - ang:Forward() * 16.3 - ang:Right() * 10.5

	--> Panel
	cam.Start3D2D(pos, ang, 0.1)

		--> Variables
		local boxWidth = 309
		local boxHeight = 105

		--> Background
		draw.RoundedBox(0, 0, 0, boxWidth, boxHeight, self.colors[9])

	cam.End3D2D()


end