--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: LayoutEntity
-----------------------------------------------------------]]
function PANEL:LayoutEntity()

	--> Player
	local bone = self.Entity:LookupBone("ValveBiped.Bip01_Head1") or false
	if bone then
		
		--> Camera
		local eyepos = self.Entity:GetBonePosition(bone)
		eyepos:Add(Vector(0, 0, 2))

		self:SetLookAt(eyepos-Vector(0, 0, 2))
		self:SetCamPos(eyepos-Vector(-14, -4, 2))
		self.Entity:SetEyeTarget(eyepos-Vector(-14, -4, 2))

	else

		--> Camera
		local mn, mx = self.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

		self:SetFOV(45)
		self:SetCamPos(Vector(size, size, size))
		self:SetLookAt((mn + mx) * 0.5)

	end

end

--[[---------------------------------------------------------
	Function: SetPlayer
-----------------------------------------------------------]]
function PANEL:SetPlayer(ply)

	--> Variables
	self.player = ply

	--> Model
	self:SetModel(ply:GetModel())

end

--[[---------------------------------------------------------
	Function: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--> Player
	local ply = self.player
	if IsValid(ply) and self:GetModel() != ply:GetModel() then
		self:SetModel(ply:GetModel())
	end

end

--[[---------------------------------------------------------
	Define: ManiaFrame
-----------------------------------------------------------]]
derma.DefineControl('ManiaFace', 'ManiaFace', PANEL, 'DModelPanel')