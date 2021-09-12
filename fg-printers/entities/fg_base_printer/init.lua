--[[---------------------------------------------------------
	Name: Files
-----------------------------------------------------------]]
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

--[[---------------------------------------------------------
	Name: Network
-----------------------------------------------------------]]
util.AddNetworkString('fg_printer_menu')

util.AddNetworkString('fg_printer_power')
util.AddNetworkString('fg_printer_money')

util.AddNetworkString('fg_printer_upgrade_speed')
util.AddNetworkString('fg_printer_upgrade_quality')
util.AddNetworkString('fg_printer_upgrade_cooler')

--[[---------------------------------------------------------
	Name: Initialize
-----------------------------------------------------------]]
function ENT:Initialize()

	--> Base Settings
	self:SetModel('models/props_c17/consolebox01a.mdl')
	self:SetColor(self.pColor)
	self:SetMaterial('metal2a')
	self:SetUseType(SIMPLE_USE)

	--> Physics Settings
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	--> Physics Wake
	local phys = self:GetPhysicsObject()
	phys:Wake()

	--> Printer
	self.Printer = true

	--> Health
	self.PHealth = 100

	--> Levels
	self:Setlvl_speed(1)
	self:Setlvl_quality(1)
	self:Setlvl_cooler(1)

	--> Data
	self:Setdata_money(0)
	self:Setdata_power(0)
	self:Setdata_temp(self.pTemp)

	--> Noise
	self.Noise = CreateSound(self, Sound('ambient/levels/labs/equipment_printer_loop1.wav'))
	self.Noise:SetSoundLevel(55)

	--> Start Printer
	self:ManageTimer()

end

--[[---------------------------------------------------------
	Name: PrintMoney
-----------------------------------------------------------]]
function ENT:PrintMoney()

	--> Power
	if self:Getdata_power() == 1 then
		
		--> Money
		local newMoney = self:Getdata_money() + (self.pQuality / 100 * self.pLevelQuality[self:Getlvl_quality()][1])
		if newMoney < self.pStorage or self.pStorage == 0 then
			self:Setdata_money(newMoney)
		else
			self:Setdata_money(self.pStorage)
		end

		--> Temp
		if self:Getlvl_speed() > self:Getlvl_cooler() or self:Getlvl_quality() > self:Getlvl_cooler() then
		
			self:Setdata_temp(math.Round(self:Getdata_temp() + self.pTempChange['both-above'](), 1))

		elseif self:Getlvl_cooler() > self:Getlvl_speed() and self:Getlvl_cooler() > self:Getlvl_quality() then

			self:Setdata_temp(math.Round(self:Getdata_temp() + self.pTempChange['both-below'](), 1))

		else

			self:Setdata_temp(math.Round(self:Getdata_temp() + self.pTempChange['other'](), 1))

		end

	else

		--> Temp
		if self:Getdata_temp() > self.pTemp then
			
			local NewTemp = self:Getdata_temp() - self.pTempChange['power-off']()
			
			if NewTemp > self.pTemp then
				
				self:Setdata_temp(math.Round(NewTemp, 1))

			else

				self:Setdata_temp(math.Round(self.pTemp, 1))

			end

		end

	end

	--> Explode
	if self:Getdata_temp() >= 75 then
		if self.pTempChange['blow-chance']() == 1 then

			if math.random(1, 10) < 3 then
				
				self:BurstIntoFlames()

			else

				self:Destruct()
				self:Remove()

			end

		end
	end

	--> Check
	if not IsValid(self) then return end

	--> Restart
	self:ManageTimer()

end

--[[---------------------------------------------------------
	Name: ManageTimer
-----------------------------------------------------------]]
function ENT:ManageTimer()

	--> Timer
	timer.Simple((self.pSpeed / 100 * self.pLevelSpeed[self:Getlvl_speed()][1]), function() 
		
		--> Check
		if not IsValid(self) then return end

		--> Print
		self:PrintMoney() 

	end)

end

--[[---------------------------------------------------------
	Name: OnTakeDamage
-----------------------------------------------------------]]
function ENT:OnTakeDamage(damage)

	--> Burning
	if self.Burning then return end

	--> Variables
	self.PHealth = self.PHealth - damage:GetDamage()

	--> Health
	if self.PHealth <= 0 then
		if math.random(1, 10) < 3 then
			
			self:BurstIntoFlames()

		else

			self:Destruct()
			self:Remove()

		end		
	end

end

--[[---------------------------------------------------------
	Name: Destruct
-----------------------------------------------------------]]
function ENT:Destruct()

	--> Variables
	local vPoint = self:GetPos()
	local effectdata = EffectData()

	--> Effect Data
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)

	--> Effect Run
	util.Effect('Explosion', effectdata)

	--> Notify
	DarkRP.notify(self:Getowning_ent(), 1, 4, self.pMessages['explode'])

end

--[[---------------------------------------------------------
	Name: BurstIntoFlames
-----------------------------------------------------------]]
function ENT:BurstIntoFlames()

	--> Burning
	self.Burning = true

	--> Variables
	local BurnTime = math.random(8, 18)

	--> Ignit
	self:Ignite(BurnTime, 0)

	--> Fireball
	timer.Simple(BurnTime, function() self:Fireball() end)

end

--[[---------------------------------------------------------
	Name: Fireball
-----------------------------------------------------------]]
function ENT:Fireball()

	--> Fire
	if not self:IsOnFire() then
		self.Burning = false
	end

	--> Variables
	local distance = math.random(20, 250)

	--> Explode
	self:Destruct()

	--> Radius
	for k,v in pairs(ents.FindInSphere(self:GetPos(), distance)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= 'predicted_viewmodel' and not v.Printer then

			v:Ignite(math.random(5, 22), 0)

		elseif v:IsPlayer() then

			local dist = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(dist / distance * 100, self, self)

		end
	end

	--> Remove
	self:Remove()

end

--[[---------------------------------------------------------
	Name: OnRemove
-----------------------------------------------------------]]
function ENT:OnRemove()

	--> Noise
	self.Noise:Stop()

end

--[[---------------------------------------------------------
	Name: Use
-----------------------------------------------------------]]
function ENT:Use(entity, player)

	--> Open Menu
	timer.Simple(0.2, function()
		net.Start('fg_printer_menu')
			net.WriteEntity(self)
		net.Send(player)
	end)

end

--[[---------------------------------------------------------
	Name: Upgrade
-----------------------------------------------------------]]
function ENT:Upgrade(type, level)

	--> Data
	if !level then level = 1 end

	--> Level
	if type == 'speed' then
		
		self:Setlvl_speed(self:Getlvl_speed() + level)

	elseif type == 'quality' then
		
		self:Setlvl_quality(self:Getlvl_quality() + level)

	elseif type == 'cooler' then
	
		self:Setlvl_cooler(self:Getlvl_cooler() + level)

	end

end

--[[---------------------------------------------------------
	Name: SpeedUpgrade
-----------------------------------------------------------]]
function ENT:SpeedUpgrade(ply)

	--> Checks
	if ply:GetPos():Distance(self:GetPos()) > 200 then return end

	--> Variables
	local NewLevel = self:Getlvl_speed() + 1

	--> Upgrade
	if !self.pLevelSpeed[NewLevel] then return end

	--> Price
	local upgradeCost = self.pQuality / 100 * self.pLevelSpeed[NewLevel][2]
	if !ply:canAfford(upgradeCost) then 
		DarkRP.notify(ply, 1, 4, self.pMessages['money'])
		return
	elseif self.pLevelSpeed[NewLevel][3] != 0 then
		if self.pLevelSpeed[NewLevel][3] == 1 then
			if not table.HasValue(self.pGroupDonator, ply:GetNWString('usergroup')) then
				DarkRP.notify(ply, 1, 4, self.pMessages['rank'])
				return
			end
		elseif self.pLevelSpeed[NewLevel][3] == 2 then
			if not table.HasValue(self.pGroupStaff, ply:GetNWString('usergroup')) then
				DarkRP.notify(ply, 1, 4, self.pMessages['rank'])
				return
			end
		end
	end

	--> Money
	ply:addMoney(-upgradeCost)

	--> Upgrade	
	self:Upgrade('speed', 1)

end

net.Receive('fg_printer_upgrade_speed', function(_, ply)
	local printer = net.ReadEntity()
	if !printer or !IsValid(printer) then return end
	printer:SpeedUpgrade(ply)
end)

--[[---------------------------------------------------------
	Name: QualityUpgrade
-----------------------------------------------------------]]
function ENT:QualityUpgrade(ply)

	--> Checks
	if ply:GetPos():Distance(self:GetPos()) > 200 then return end

	--> Variables
	local NewLevel 	= self:Getlvl_quality() + 1

	--> Upgrade
	if !self.pLevelQuality[NewLevel] then return end

	--> Price
	local upgradeCost = self.pQuality / 100 * self.pLevelQuality[NewLevel][2]
	if !ply:canAfford(upgradeCost) then 
		DarkRP.notify(ply, 1, 4, self.pMessages['money'])
		return
	elseif self.pLevelQuality[NewLevel][3] != 0 then
		if self.pLevelQuality[NewLevel][3] == 1 then
			if not table.HasValue(self.pGroupDonator, ply:GetNWString('usergroup')) then
				DarkRP.notify(ply, 1, 4, self.pMessages['rank'])
				return
			end
		elseif self.pLevelQuality[NewLevel][3] == 2 then
			if not table.HasValue(self.pGroupStaff, ply:GetNWString('usergroup')) then
				DarkRP.notify(ply, 1, 4, self.pMessages['rank'])
				return
			end
		end
	end

	--> Money
	ply:addMoney(-upgradeCost)

	--> Upgrade	
	self:Upgrade('quality', 1)

end

net.Receive('fg_printer_upgrade_quality', function(_, ply)
	local printer = net.ReadEntity()
	if !printer or !IsValid(printer) then return end
	printer:QualityUpgrade(ply)
end)

--[[---------------------------------------------------------
	Name: CoolerUpgrade
-----------------------------------------------------------]]
function ENT:CoolerUpgrade(ply)

	--> Checks
	if ply:GetPos():Distance(self:GetPos()) > 200 then return end

	--> Variables
	local NewLevel 	= self:Getlvl_cooler() + 1

	--> Upgrade
	if !self.pLevelCooler[NewLevel] then return end

	--> Price
	local upgradeCost = self.pQuality / 100 * self.pLevelCooler[NewLevel][2]
	if !ply:canAfford(upgradeCost) then 
		DarkRP.notify(ply, 1, 4, self.pMessages['money'])
		return
	elseif self.pLevelCooler[NewLevel][3] != 0 then
		if self.pLevelCooler[NewLevel][3] == 1 then
			if not table.HasValue(self.pGroupDonator, ply:GetNWString('usergroup')) then
				DarkRP.notify(ply, 1, 4, self.pMessages['rank'])
				return
			end
		elseif self.pLevelCooler[NewLevel][3] == 2 then
			if not table.HasValue(self.pGroupStaff, ply:GetNWString('usergroup')) then
				DarkRP.notify(ply, 1, 4, self.pMessages['rank'])
				return
			end
		end
	end

	--> Money
	ply:addMoney(-upgradeCost)

	--> Upgrade	
	self:Upgrade('cooler', 1)

end

net.Receive('fg_printer_upgrade_cooler', function(_, ply)
	local printer = net.ReadEntity()
	if !printer or !IsValid(printer) then return end
	printer:CoolerUpgrade(ply)
end)

--[[---------------------------------------------------------
	Name: PowerChange
-----------------------------------------------------------]]
function ENT:PowerChange(ply)

	--> Checks
	if ply:GetPos():Distance(self:GetPos()) > 200 then return end

	--> Variables
	local power = self:Getdata_power()

	--> Power
	if power == 1 then
		
		--> Variables
		self:Setdata_power(0)

		--> Noise
		self.Noise:Stop()

	else

		--> Variables
		self:Setdata_power(1)

		--> Noise
		self.Noise:PlayEx(1, 100)

	end

end

net.Receive('fg_printer_power', function(_, ply)
	local printer = net.ReadEntity()
	if !printer or !IsValid(printer) then return end
	printer:PowerChange(ply)
end)

--[[---------------------------------------------------------
	Name: CollectMoney
-----------------------------------------------------------]]
function ENT:CollectMoney(ply)

	--> Checks
	if ply:GetPos():Distance(self:GetPos()) > 200 then return end

	--> Variables
	local money = self:Getdata_money()

	--> Power
	if money > 0 then
		
		--> Reset
		self:Setdata_money(0)

		--> Give Money
		ply:addMoney(money)

		--> Notify
		DarkRP.notify(ply, 3, 4, string.Replace(self.pMessages['collect'], '%', tostring(money)))

	end

end

net.Receive('fg_printer_money', function(_, ply)
	local printer = net.ReadEntity()
	if !printer or !IsValid(printer) then return end
	printer:CollectMoney(ply)
end)