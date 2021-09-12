--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Base
	self:SetText('')

	--> Icon
	self.icon = vgui.Create('ModelImage', self)
	self.icon:Dock(FILL)
	self.icon:SetMouseInputEnabled(false)
	self.icon:SetKeyboardInputEnabled(false)

end

--[[---------------------------------------------------------
	Function: SetModel
-----------------------------------------------------------]]
function PANEL:SetModel(model)

	--> Model
	self.icon:SetModel(model)

end

--[[---------------------------------------------------------
	Function: SetPlayer
-----------------------------------------------------------]]
function PANEL:SetPlayer(ply)

	--> Variables
	self.player = ply

	--> Model
	self.icon:SetModel(ply:GetModel())

end

--[[---------------------------------------------------------
	Function: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--> Player
	local ply = self.player
	if IsValid(ply)  then
		self.icon:SetModel(ply:GetModel())
	end

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

end

--[[---------------------------------------------------------
	Define: ManiaFrame
-----------------------------------------------------------]]
derma.DefineControl('ManiaImage', 'ManiaImage', PANEL, 'DButton')