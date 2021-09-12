--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'TechPrint - Core'
ENT.Author = 'TheCodingBeast'

ENT.Spawnable = false
ENT.AdminSpawnable = false

--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]

--[[---------------------------------------------------------

	pColor: The color of the printer entity.
	pHealth: The printer health.
	pPrice: The pinter price. Automatically updated when spawned.

	pRate: The default amount of money spawned every second.
	> Formula: math.Round(pRate*math.pow(pUpgrade/100+1, SpeedLevel-1), 2)
	pUpgrade: The upgrade price in percentage of the original price.
	> Formula: (BuyPrice/100*pUpgrade)*(NewLevel-OldLevel)
	pMaxStore: The max amount of money that can be stored in the printer.
	> Disabled: 0

	pTempLow + pTempHigh: The amount the temperature will increase/decrease when printing.
	> Formula Temperature+(math.random(pTempLow, pTempHigh)/100)
	pTempDecrease: The percentage chance of the temperature decreasing when turned off.
	pTempExplode: The temperature where the printer may explode.
	pExplodeChance: The percentage risk of the printer exploding when it's above pTempExplode.

	pStealTime: The time (seconds) it takes to steal the printer.
	pStealDistance: The max distance you can walk away from the printer while stealing it.
	pStealDisNotify: The distance where it will start warning you while stealing the printer.

	pNotifyPrice: The notify upgrade price in percentage of the original price.
	> Formula: BuyPrice/100*pNotifyPrice

	pFadeStop: The distance where the ui will start fading in.
	pFadeStart: The distance where ui will start fading out.

-----------------------------------------------------------]]

ENT.pColor = Color(52, 152, 219, 255)
ENT.pHealth = 100
ENT.pPrice = 1000

ENT.pRate = 1		
ENT.pUpgrade = 35
ENT.pMaxStore = 0

ENT.pTempLow = -1
ENT.pTempHigh = 4
ENT.pTempDecrease = 50

ENT.pTempExplode = 110
ENT.pExplodeChance = 10

ENT.pStealTime = 90
ENT.pStealDistance = 300
ENT.pStealDisNotify = 250

ENT.pNotifyPrice = 10

ENT.pFadeStop = 225
ENT.pFadeStart = 150

--[[---------------------------------------------------------
	Name: SetupDataTables
-----------------------------------------------------------]]
function ENT:SetupDataTables()

	--> Owner
	self:NetworkVar('Entity', 1, 'owning_ent')

	--> Speed
	self:NetworkVar('Int', 2, 'SpeedLevel')

	--> Stored
	self:NetworkVar('Int', 3, 'StoredMoney')

	--> Temperature
	self:NetworkVar('Float', 4, 'Temperature')

	--> Power
	self:NetworkVar('Bool', 5, 'Power')

	--> Noise
	self:NetworkVar('Float', 6, 'NoiceLevel')

	--> Health
	self:NetworkVar('Int', 7, 'PrinterHealth')

	--> Capture
	self:NetworkVar('Int', 8, 'CaptureTime')
	self:NetworkVar('Entity', 9, 'CapturePlayer')

	--> Owner
	self:NetworkVar('Int', 10, 'BuyPrice')

	--> Notify
	self:NetworkVar('Bool', 11, 'NotifyUpgrade')

	--> MaxStore
	self:NetworkVar('Int', 12, 'MaxStore')

end