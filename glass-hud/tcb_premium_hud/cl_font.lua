--[[---------------------------------------------------------
	Name: Fonts
-----------------------------------------------------------]]
local function CreateHUDFonts( i, font, name, weight )

	--> Size
	local CurrentFontSize = 12 + i * 2

	--> Create
	surface.CreateFont( name .. CurrentFontSize, {

		font 		= font,
		size 		= CurrentFontSize,
		weight 		= weight,
		blursize 	= 0,
		scanlines	= 0,
		antialias 	= true,
		underline 	= false,
		italic 		= false,
		strikeout 	= false,
		symbol 		= false,
		rotary 		= false,
		shadow 		= false,
		additive 	= false,
		outline 	= false,

	})

end


--[[---------------------------------------------------------
	Name: Font Loop
-----------------------------------------------------------]]
for i=1,20 do
	
	--> Crete Fonts
	CreateHUDFonts( i, "Fairview Small Caps", "TCB_Premium_Fairview_", 100 )

end


--[[---------------------------------------------------------
	Name: Trebuchet22
-----------------------------------------------------------]]
surface.CreateFont("Trebuchet22", {
	size 		= 22,
	weight 		= 500,
	antialias 	= true,
	shadow 		= false,
	font 		= "Trebuchet MS"
})