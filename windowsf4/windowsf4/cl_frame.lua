--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local frame = frame or nil
local active = active or nil
local panels = panels or {}

--[[---------------------------------------------------------
	Panel: TCBF4Frame
-----------------------------------------------------------]]
local function TCBF4Frame()

	--> Exist
	if IsValid(frame) and !frame:IsVisible() then
		frame:SetVisible(true)
		frame:Show()
		if IsValid(panels[active]) then
			panels[active]:ReloadData()
		end
		return
	elseif IsValid(frame) then
		frame:SetVisible(false)
		frame:Hide()
		return
	end

	--> Frame
	frame = vgui.Create("windowsFrame")
	frame:SetTitle(windowsSettings.design.title)
	frame:SetSize(850, 600)
	frame:Center()
	frame:MakePopup()
	frame:Show()

	local server = vgui.Create("DPanel", frame.sidebar)
	server:Dock(TOP)
	server:SetTall(50)
	server:DockMargin(0, 4, 0, 4)
	server.Paint = function(pnl, w, h)
		draw.SimpleText(windowsSettings.design.server, 'segoe_28', w/2, h/2, windowsSettings.data.scheme(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	for k,v in pairs(windowsSettings.design.tabs) do
		
		--> Divider
		if v.type and v.type == "div" then
			
			local div = vgui.Create("DPanel", frame.sidebar)
			div:Dock(TOP)
			div:SetTall(2)
			div:DockMargin(0, 4, 0, 4)
			div.Paint = function(pnl, w, h)
				draw.RoundedBox(0, w*0.125, 0, w*0.75, h, Color(50, 50, 50, 255))
			end

			continue

		end

		--> Tab
		local tab = vgui.Create("DButton", frame.sidebar)
		tab:Dock(TOP)
		tab:SetTall(38)
		tab:SetText('')
		tab.Paint = function(pnl, w, h)

			--> Background
			if pnl.Hovered or active == v.name then
				draw.RoundedBox(0, 0, 0, w, h, windowsSettings.data.scheme())
			end

			--> Icon
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(v.icon)
			surface.DrawTexturedRect(w*0.125, 8, 22, 22)

			--> Text
			draw.SimpleText(v.name, 'segoe_20', w*0.125+22+6, 18, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		end
		tab.DoClick = function()

			--> Active
			active = v.name

			--> Hide
			for _, panel in pairs(panels) do
				if IsValid(panel) then
					panel:SetVisible(false)
					panel:Hide()
				end
			end

			--> Exists
			if IsValid(panels[v.name]) then
				panels[v.name]:SetVisible(true)
				panels[v.name]:Show()
				panels[v.name]:ReloadData()
				return
			end

			--> Panel
			if v.type and v.type == "web" then
				
				--> Website
				local website = vgui.Create("windowsWebsite", frame.body)
				website:Dock(FILL)
				website:SetWebsite(v.url)

				--> Save
				panels[v.name] = website

			else

				--> Panel
				local panel = vgui.Create(v.panel, frame.body)
				panel:Dock(FILL)
				panel:ReloadData()

				--> Save
				panels[v.name] = panel

			end

		end

		--> Empty
		if v.default and !active then
			tab.DoClick()
		end 

	end

end
hook.Add("ShowSpare2", "TCBF4Frame", TCBF4Frame)
//timer.Create("testDesign", 10, 0, testDesign)