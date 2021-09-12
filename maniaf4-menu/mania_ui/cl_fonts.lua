--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
Mania = Mania or {}
Mania.font = Mania.font or {}

--[[---------------------------------------------------------
	Function: create
-----------------------------------------------------------]]
function Mania.font.create(sizes, font, name, weight)
	for k,v in pairs(sizes) do
		
		--> Font
		surface.CreateFont('ManiaUI_'..name..'_'..v, {
			font = font,
			size = v,
			weight = weight,
		})

	end
end

--[[---------------------------------------------------------
	Function: Fonts
-----------------------------------------------------------]]
Mania.font.create({14, 18}, 'Roboto', 'regular', 500)
Mania.font.create({14, 18, 26}, 'Roboto Black', 'black', 500)