function FG_DrawBackgroundBlur( panel, starttime, blur )

	local matBlurScreen = Material( "pp/blurscreen" )

	local Fraction = 1

	if ( starttime ) then
		Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
	end

	local x, y = panel:LocalToScreen( 0, 0 )

	DisableClipping( true )
	
	surface.SetMaterial( matBlurScreen )	
	surface.SetDrawColor( 255, 255, 255, 255 )
		
	for i=0.33, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
		matBlurScreen:Recompute()
		if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
	
	surface.SetDrawColor( 10, 10, 10, blur * Fraction )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
	
	DisableClipping( false )

end