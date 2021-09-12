--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: DrawCircle
-----------------------------------------------------------]]
function PANEL:AllowItemInput(bool)

	--> Variables
	self.itemInput = bool

end

--[[---------------------------------------------------------
	Function: DrawCircle
-----------------------------------------------------------]]
function PANEL:DrawCircle( x, y, radius, seg )

	local cir = {}
	table.insert(cir, {x = x, y = y})

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius})
	end

	local a = math.rad( 0 )
	table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius})

	surface.DrawPoly(cir)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Valid
	if !IsValid(self.item) then return end

	--> Stencils
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	draw.NoTexture()
	surface.SetDrawColor(Color(0, 0, 0, 255))

	self:DrawCircle(w/2, h/2, h/2, math.max(w,h)/2)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	self.item:PaintManual()

	render.SetStencilEnable(false)
	render.ClearStencil()

end

--[[---------------------------------------------------------
	Function: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--> Valid
	if !IsValid(self.item) then

		--> Timer
		timer.Simple(1, function() 
			self:PerformLayout()
		end)

		--> Return
		return

	end

	--> Item
	self.item:SetSize(self:GetWide(), self:GetTall())

	--> Input
	if self.itemInput then
		self.item:SetMouseInputEnabled(true)
	else
		self.item:SetMouseInputEnabled(false)
	end

end

--[[---------------------------------------------------------
	Define: ManiaFrame
-----------------------------------------------------------]]
derma.DefineControl('ManiaRounded', 'ManiaRounded', PANEL, 'DPanel')