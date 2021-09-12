--[[---------------------------------------------------------
	Function: Fonts
-----------------------------------------------------------]]
resource.AddSingleFile('resource/fonts/roboto-black.ttf')
resource.AddSingleFile('resource/fonts/roboto-regular.ttf')

--[[---------------------------------------------------------
	Function: Delay
-----------------------------------------------------------]]
timer.Simple(0, function()
	if !Mania.f4.download.workshop then

		--> Materials
		resource.AddFile('materials/mania_icons/home.png')
		resource.AddFile('materials/mania_icons/box.png')
		resource.AddFile('materials/mania_icons/jobs.png')
		resource.AddFile('materials/mania_icons/vehicles.png')
		resource.AddFile('materials/mania_icons/weapons.png')
		resource.AddFile('materials/mania_icons/entities.png')
		resource.AddFile('materials/mania_icons/food.png')

		resource.AddFile('materials/mania_icons/close.png')
		resource.AddFile('materials/mania_icons/search.png')

		resource.AddFile('materials/mania_icons/website.png')
		resource.AddFile('materials/mania_icons/commands.png')
		
	else

		--> Workshop
		resource.AddWorkshop(Mania.f4.download.workshopID)

	end
end)