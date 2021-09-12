--[[---------------------------------------------------------
	Name: CreateFont
-----------------------------------------------------------]]
local function CreateFont( i, Font, Name, Weight )

	local CurSize = i

	surface.CreateFont( Name .. CurSize, {
		font = Font,
		size = CurSize,
		weight = Weight,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

end


--[[---------------------------------------------------------
	Name: CreateFont - JaapokkiRegular
-----------------------------------------------------------]]
for i=1,50 do
	
	CreateFont( i, "JaapokkiRegular", "FG_JaapokkiRegular_", 500 )

end