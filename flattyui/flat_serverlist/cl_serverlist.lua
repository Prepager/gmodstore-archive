--[[---------------------------------------------------------
	serverListMenu
-----------------------------------------------------------]]
local function serverListMenu()

	--> Frame
	local frame = vgui.Create("flatFrame")
	frame:SetSize(400, 500)
	frame:Center()
	frame:SetDraggable(true)
	frame:MakePopup()
	frame:DockPadding(1, 41, 1, 1)
	frame:SetTitle("Server List")

	--> Scroll
	local scroll = vgui.Create("flatScrollPanel", frame)
	scroll:Dock(FILL)

	--> Servers
	for k, v in pairs(FlattySettings.serverlist.servers) do
		
		--> Panel
		local panel = vgui.Create("DPanel", scroll)
		panel:Dock(TOP)
		panel:SetTall(65)
		panel.count = k
		panel.Paint = function(pnl, w, h)

			--> Stripe
			if math.mod(pnl.count, 2) == 0 then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 15))
			end

			--> Text
			draw.SimpleText(v[1], "FlatUI_24", w/2-90/2, 10, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(v[2], "FlatUI_16", w/2-90/2, 38, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		end

		--> Join
		local join = vgui.Create("flatButton", panel)
		join:SetSize(80, 26)
		join:SetPos(frame:GetWide()-scroll.VBar:GetWide()-80-7, panel:GetTall()/2-26/2)
		join:SetText("Join Server")
		join:SetTheme("green")
		join.DoClick = function()
			LocalPlayer():ConCommand("connect " .. v[3])
		end

	end

end
concommand.Add("serverListMenu", serverListMenu)

--[[---------------------------------------------------------
	serverListChat
-----------------------------------------------------------]]
local function serverListChat(ply, text)
	if string.find(text, "^[!/]"..FlattySettings.serverlist.command) then
		
		--> Menu
		if ply == LocalPlayer() then
			RunConsoleCommand("serverListMenu")
		end

		--> Return
		return true

	end
end
hook.Add("OnPlayerChat", "serverListChat", serverListChat)