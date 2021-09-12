--[[---------------------------------------------------------
	Fonts: Font
-----------------------------------------------------------]]
fontsTable = {
	{
		file = 'Segoe UI Semibold',
		name = 'segoe_semibold',
		weight = 400,
		from = 0,
		to = 5
	},
	{
		file = 'Segoe UI',
		name = 'segoe_bold',
		weight = 700,
		from = 4,
		to = 10
	}
}

--[[---------------------------------------------------------
	Fonts: Create
-----------------------------------------------------------]]
for k,v in pairs(fontsTable) do
	for i = v.from, v.to do
		
		--> Size
		local fontSize = 14+i*2

		--> Font
		surface.CreateFont(v.name.."_"..fontSize, {
			font = v.file,
			size = fontSize,
			weight = v.weight,
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
			outline = false
		})

	end
end