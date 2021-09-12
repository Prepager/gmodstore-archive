--[[---------------------------------------------------------
	Name: Files
-----------------------------------------------------------]]
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	--> Settings
	self:SetModel('models/props_c17/consolebox01a.mdl')
	self:SetMaterial('phoenix_storms/wire/pcb_blue')
	self:SetColor(self.pColor)

	--> Use
	self:SetUseType(SIMPLE_USE)

	--> Physics
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	--> Wake
	local phys = self:GetPhysicsObject()
	phys:Wake()

	--> Defaults
	self:SetPower(true)
	self:SetBuyPrice(self.pPrice)
	self:SetSpeedLevel(1)
	self:SetStoredMoney(0)
	self:SetTemperature(20)
	self:SetNoiceLevel(0.15)
	self:SetPrinterHealth(self.pHealth)
	self:SetMaxStore(self.pMaxStore)

	--> Print
	self:Print()

	--> Noise
	self.Noise = CreateSound(self, Sound('ambient/levels/labs/equipment_printer_loop1.wav'))
	self.Noise:PlayEx(self:GetNoiceLevel(), 100)

	--> Price
	if self.DarkRPItem and self.DarkRPItem.price then
		self:SetBuyPrice(self.DarkRPItem.price)
	else

		--> Entities
		local entFound = false
		for i, item in ipairs(DarkRPEntities) do
			if item.ent == self:GetClass() then
				self:SetBuyPrice(item.price)
				entFound = true
				break
			end
		end

		--> Error
		if !entFound then
			ErrorNoHalt('The entity ('..self:GetClass()..') price couldn\'t be found!\n')
		end

	end

end

--[[---------------------------------------------------------
	Name: Print  6575c87eb19eb689c450e2aa38b80845ecc534bd95363f7f0377e12ca5ab14e7
-----------------------------------------------------------]]
function ENT:Print()

	--> Power
	if !self:GetPower() then 

		--> Tempature
		if self:GetTemperature() != 20 and math.random(1, 100) <= self.pTempDecrease then
			local newTemp = self:GetTemperature()-math.random(0, 25)/100
			if newTemp < 20 then newTemp = 20 end
			self:SetTemperature(newTemp)
		end

		--> Restart
		timer.Simple(1, function() if IsValid(self) then self:Print() end end)

		--> Return
		return

	end

	--> Temp
	local newTemp = self:GetTemperature()+math.random(self.pTempLow, self.pTempHigh)/100
	if newTemp < 20 then
		newTemp = 20
	elseif newTemp >= self.pTempExplode and math.random(1, 100) <= self.pExplodeChance then
		self:Destruct()
		self:Remove()
		return
	end
	self:SetTemperature(newTemp)

	--> Variables
	local rate = math.Round(self.pRate*math.pow((self.pUpgrade/100)+1, self:GetSpeedLevel()-1), 2)

	--> Store
	local newMoney = self:GetStoredMoney()+rate
	if newMoney > self:GetMaxStore() and self:GetMaxStore() != 0 then

		--> Max
		self:SetStoredMoney(self:GetMaxStore())

		--> Notify
		if self:GetNotifyUpgrade() and IsValid(self:Getowning_ent()) and (!self.notifyDelay or CurTime() > self.notifyDelay) then
			DarkRP.notify(self:Getowning_ent(), 1, 6, "Your printer is full! Money: $"..self:GetMaxStore())
			self.notifyDelay = CurTime()+10
		end


	else
		self:SetStoredMoney(newMoney)
	end

	--> Notify
	if self:GetNotifyUpgrade() and newTemp >= 95 and IsValid(self:Getowning_ent()) and (!self.notifyDelay or CurTime() > self.notifyDelay) then
		DarkRP.notify(self:Getowning_ent(), 1, 6, "Your printer is overheating! Temperature: "..math.Round(newTemp, 1).."°")
		self.notifyDelay = CurTime()+10
	end

	--> Restart
	timer.Simple(1, function() if IsValid(self) then self:Print() end end)

end

--[[---------------------------------------------------------
	Name: Use
-----------------------------------------------------------]]
function ENT:Use(_, ply)

	--> Variables
	local stored = self:GetStoredMoney()

	--> Player
	if !ply:IsPlayer() then return end

	--> Attack
	if ply:KeyDown(IN_ATTACK) then return end

	--> Check
	if stored > 0 then

		--> Give
		ply:addMoney(stored)

		--> Reset
		self:SetStoredMoney(0)

		--> Notify
		DarkRP.notify(ply, 3, 4, "You took $"..stored.." from the printer!")

	end

end

--[[---------------------------------------------------------
	Name: Destruct
-----------------------------------------------------------]]
function ENT:Destruct()

	--> Variables
    local vPoint = self:GetPos()

    --> Effect
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)

    --> Explode
    util.Effect("Explosion", effectdata)

end

--[[---------------------------------------------------------
	Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage(damage)

	--> Physics
	self:TakePhysicsDamage(damage)

	--> Variables
	local newHealth = self:GetPrinterHealth() - damage:GetDamage()*0.5

	--> Explode
	if newHealth <= 0 then
		self:Destruct()
		self:Remove()
		return
	end

	--> Health
	self:SetPrinterHealth(newHealth)

end

--[[---------------------------------------------------------
	Name: Speed Upgrade
-----------------------------------------------------------]]
function ENT:SpeedUpgrade(ply, lvl)

	--> Variables
	local price = (self:GetBuyPrice()/100*self.pUpgrade)*(lvl-self:GetSpeedLevel())

	--> Level
	if lvl < 2 then return end
	if lvl > 10 then return end

	--> Afford
	if !ply:canAfford(price) then
		DarkRP.notify(ply, 1, 4, "You can't afford this upgrade!")
		return
	end

	--> Money
	ply:addMoney(-price)

	--> Notify
	DarkRP.notify(ply, 3, 4, "You paid $"..price.." to upgrade your printer to level "..lvl.."!")

	--> Upgrade
	self:SetSpeedLevel(lvl)

end

--[[---------------------------------------------------------
	Name: Notify Upgrade
-----------------------------------------------------------]]
function ENT:NotifyUpgrade(ply)

	--> Variables
	local price = self:GetBuyPrice()/100*self.pNotifyPrice

	--> Status
	if self:GetNotifyUpgrade() then
		DarkRP.notify(ply, 1, 4, "You already own this upgrade!")
		return
	end

	--> Afford
	if !ply:canAfford(price) then
		DarkRP.notify(ply, 1, 4, "You can't afford this upgrade!")
		return
	end

	--> Money
	ply:addMoney(-price)

	--> Notify
	DarkRP.notify(ply, 3, 4, "You paid $"..price.." for the warning upgrade!")

	--> Upgrade
	self:SetNotifyUpgrade(true)

end

--[[---------------------------------------------------------
	Name: Upgrade
-----------------------------------------------------------]]
function ENT:Power(ply)

	--> Variables
	local newPower = !self:GetPower()

	--> Power
	self:SetPower(newPower)

	--> Noice
	if newPower then
		self.Noise:PlayEx(self:GetNoiceLevel(), 100)
	else
		self.Noise:Stop()
	end

end

--[[---------------------------------------------------------
	Name: Steal
-----------------------------------------------------------]]
function ENT:Steal(ply)

	--> Variables
	local timeLeft = self:GetCaptureTime()-CurTime()

	--> Cancel
	if timeLeft > 0 then

		--> Reset
		self:SetCaptureTime(CurTime())
		self:SetCapturePlayer(nil)

		--> Return
		return

	end

	--> Player
	if self:Getowning_ent() == ply then

		--> Notify
		DarkRP.notify(ply, 1, 4, "You can't steal your own printer!")

		--> Return
		return

	end

	--> Notify
	if self:GetNotifyUpgrade() and IsValid(self:Getowning_ent()) then
		DarkRP.notify(self:Getowning_ent(), 1, 6, "Your printer is being stolen! Stop them before it\'s too late.")
	end

	--> Capture
	self:SetCaptureTime(CurTime()+self.pStealTime)
	self:SetCapturePlayer(ply)

	--> Notify
	DarkRP.notify(ply, 3, 4, 'You must stay close to the printer for the next '..self.pStealTime..' seconds.')

	--> Timer
	local timerName = 'tcb_printer_steal_'..ply:SteamID64()..'_'..self:GetCreationID()
	timer.Create(timerName, 5, 0, function()

		--> Valid
		if !IsValid(self) or !IsValid(self:GetCapturePlayer()) then
			return
		end

		--> Distance
		local distance = self:GetCapturePlayer():GetPos():Distance(self:GetPos())
		local timeLeft = self:GetCaptureTime()-CurTime()

		--> Notify
		if distance >= self.pStealDisNotify and distance < self.pStealDistance then
			DarkRP.notify(ply, 1, 4, 'You are getting too far away from the printer ('..math.Round(distance)..'/'..self.pStealDistance..').')
		end

		--> Range
		if distance >= self.pStealDistance then
		
			--> Reset
			self:SetCaptureTime(CurTime())
			self:SetCapturePlayer(nil)

			--> Notify
			DarkRP.notify(ply, 1, 4, 'Failed! You went too far away from the printer.')

			--> Remove
			timer.Remove(timerName)

			--> Return
			return

		end

		--> Completed
		if timeLeft <= 0 then
			
			--> Owner
			self:Setowning_ent(ply)

			--> Reset
			self:SetCaptureTime(CurTime())
			self:SetCapturePlayer(nil)

			--> Notify
			DarkRP.notify(ply, 3, 4, 'You successfully stole the printer!')

			--> Remove
			timer.Remove(timerName)

		end

	end)

end

--[[---------------------------------------------------------
	Name: OnRemove
-----------------------------------------------------------]]
function ENT:OnRemove()

	--> Noise
	self.Noise:Stop()

end

--[[---------------------------------------------------------
	Name: SpeedUpgrade
-----------------------------------------------------------]]
util.AddNetworkString('tcb_upgrade_speed')
function SpeedUpgrade(_, ply)

	--> Variables
	local ent = ply:GetEyeTrace().Entity
	local lvl = net.ReadInt(32)

	--> Attack
	if ply:KeyDown(IN_ATTACK) then return end

	--> Distance
	if ent:GetPos():Distance(ply:GetPos()) > 150 then
		DarkRP.notify(ply, 1, 4, "You are not in range of the printer!")
		return
	end

	--> Upgrade
	ent:SpeedUpgrade(ply, lvl)

	--> Return
	return

end
net.Receive('tcb_upgrade_speed', SpeedUpgrade)

--[[---------------------------------------------------------
	Name: PowerToggle
-----------------------------------------------------------]]
util.AddNetworkString('tcb_printer_power')
function PowerToggle(_, ply)

	--> Variables
	local ent = ply:GetEyeTrace().Entity

	--> Attack
	if ply:KeyDown(IN_ATTACK) then return end

	--> Distance
	if ent:GetPos():Distance(ply:GetPos()) > 150 then
		DarkRP.notify(ply, 1, 4, "You are not in range of the printer!")
		return
	end

	--> Upgrade
	ent:Power(ply)

	--> Return
	return

end
net.Receive('tcb_printer_power', PowerToggle)

--[[---------------------------------------------------------
	Name: StealPrinter
-----------------------------------------------------------]]
util.AddNetworkString('tcb_printer_steal')
function StealPrinter(_, ply)

	--> Variables
	local ent = ply:GetEyeTrace().Entity

	--> Attack
	if ply:KeyDown(IN_ATTACK) then return end

	--> Distance
	if ent:GetPos():Distance(ply:GetPos()) > 150 then
		DarkRP.notify(ply, 1, 4, "You are not in range of the printer!")
		return
	end

	--> Upgrade 6575c87eb19eb689c450e2aa38b80845ecc534bd95363f7f0377e12ca5ab14e7
	ent:Steal(ply)

	--> Return
	return

end
net.Receive('tcb_printer_steal', StealPrinter)

--[[---------------------------------------------------------
	Name: NotifyUpgrade
-----------------------------------------------------------]]
util.AddNetworkString('tcb_upgrade_notify')
function NotifyUpgrade(_, ply)

	--> Variables
	local ent = ply:GetEyeTrace().Entity

	--> Attack
	if ply:KeyDown(IN_ATTACK) then return end

	--> Distance
	if ent:GetPos():Distance(ply:GetPos()) > 150 then
		DarkRP.notify(ply, 1, 4, "You are not in range of the printer!")
		return
	end

	--> Upgrade
	ent:NotifyUpgrade(ply)

	--> Return
	return

end
net.Receive('tcb_upgrade_notify', NotifyUpgrade)

--[[---------------------------------------------------------
	Name: Pocket
-----------------------------------------------------------]]
function PrinterPocket(ply, ent)
	if ent.Base == "tcb_techprint_base" then
		return false, "You cannot put this printer in your pocket!"
	end
end
hook.Add("canPocket", "PrinterPocket", PrinterPocket)