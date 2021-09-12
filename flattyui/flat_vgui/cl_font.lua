--[[---------------------------------------------------------
	Fonts
-----------------------------------------------------------]]
for i=0,24 do

	--> Size
	local size = 10+i

	--> Font
	surface.CreateFont("FlatUI_"..size, {
		font = "Trebuchet24",
		size = size,
	})

end