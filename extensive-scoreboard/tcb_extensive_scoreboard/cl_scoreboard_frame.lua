--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.friends = {}
	self.friendsID = {}

	--> Frame
	self:SetSize(850, 700)
	self:Center()

	--> Status
	self.status = vgui.Create("DPanel", self)
	self.status:SetSize(self:GetWide()-40, 54)
	self.status:SetPos(20, 140-54/2)
	self.status.text = "test"
	self.status.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(6, 0, 0, w, h, Color(215, 215, 215, 255))
		draw.RoundedBox(6, 1, 1, w-2, h-2, Color(240, 240, 240, 255))

		--> Text
		draw.SimpleText(self.status.text, "TCB-Scoreboard-BoldFont-30", 15, h/2-1, Color(195, 210, 215, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	--> Reload
	self.reload = vgui.Create("DButton", self.status)
	self.reload:Dock(RIGHT)
	self.reload:DockMargin(10, 10, 10, 10)
	self.reload:SetWide(120)
	self.reload:SetText("")
	self.reload.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(6, 0, 0, w, h, Color(50, 190, 110, 255))

		--> Hover
		if pnl.Hovered then
			draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, 20))
		end

		--> Text
		draw.SimpleText(TCBScoreboardSettings.trans.refresh, "TCB-Scoreboard-BoldFont-22", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end
	self.reload.DoClick = function()

		--> Reload
		self:UpdatePanel(false, true)

	end

	--> Content
	self.content = vgui.Create("DScrollPanel", self)
	self.content:SetSize(self:GetWide()-40, self:GetTall()-170-(self.status:GetTall()/2))
	self.content:SetPos(20, 140+(self.status:GetTall()/2)+10)
	self.content.Paint = function(pnl, w, h)

		--> Variables
		w = w-25

		--> Background
		draw.RoundedBox(6, 0, 0, w, h, Color(215, 215, 215, 255))
		draw.RoundedBox(6, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

	end

	--> Scrollbar
	self.content.VBar.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(6, 0, 0, w, h, Color(215, 215, 215, 255))
		draw.RoundedBox(6, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

	end

	self.content.VBar.btnGrip.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(4, 3, 3, w-6, h-6, Color(215, 215, 215, 255))

	end

	self.content.VBar.btnUp.Paint = function(pnl, w, h)

		--> Border
		draw.RoundedBox(0, 0, h-1, w, 1, Color(215, 215, 215, 255))

		--> Text
		draw.SimpleText("▲", "TCB-Scoreboard-Font-16", (w/2)+2, (h/2), Color(215, 215, 215, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	self.content.VBar.btnDown.Paint = function(pnl, w, h)

		--> Border
		draw.RoundedBox(0, 0, 0, w, 1, Color(215, 215, 215, 255))

		--> Text
		draw.SimpleText("▼", "TCB-Scoreboard-Font-16", (w/2)+2, (h/2), Color(215, 215, 215, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	--> Content Scroll
	self.contentScroll = vgui.Create("DPanel", self.content)
	self.contentScroll:SetSize(1, self.content:GetTall()+1)
	self.contentScroll.Paint = function() end

	--> MenuItems
	self.menuItems = {}

	self.menuItems[0] = {
		name = TCBScoreboardSettings.trans.online,
		active = true,
		display = function()

			--> Variables
			local sizeH = math.Round(self.content:GetTall()/6)

			--> Clear
			self.content:Clear()
			self.content:GetVBar():SetScroll(0)

			--> Content Scroll
			self.contentScroll = vgui.Create("DPanel", self.content)
			self.contentScroll:SetSize(1, self.content:GetTall()+1)
			self.contentScroll.Paint = function() end

			--> Status
			self.status.text = string.Replace(TCBScoreboardSettings.trans.showPlayers, "%", tostring(#player.GetAll()))

			--> Loop
			for k, v in pairs(player.GetAll()) do

				--> Panel
				local panel = vgui.Create("TCB-Scoreboard-Player", self.content)
				panel:DockMargin(1, 0, 10, 0)
				panel:SetTall(sizeH)
				panel:Dock(TOP)
				panel:SetPlayer(v)

			end

		end
	}

	self.menuItems[1] = {
		name = TCBScoreboardSettings.trans.friends,
		active = false,
		display = function()

			--> Variables
			local sizeH = math.Round(self.content:GetTall()/6)

			--> Clear
			self.content:Clear()
			self.content:GetVBar():SetScroll(0)

			--> Content Scroll
			self.contentScroll = vgui.Create("DPanel", self.content)
			self.contentScroll:SetSize(1, self.content:GetTall()+1)
			self.contentScroll.Paint = function() end

			--> Status
			self.status.text = string.Replace(TCBScoreboardSettings.trans.showFriends, "%", tostring(#self.friends))

			--> Loop
			for k, v in pairs(self.friends) do

				--> Panel
				local panel = vgui.Create("TCB-Scoreboard-Player", self.content)
				panel:DockMargin(1, 0, 10, 0)
				panel:SetTall(sizeH)
				panel:Dock(TOP)
				panel:SetPlayer(v)

			end

		end
	}

	self.menuItems[2] = {
		name = TCBScoreboardSettings.trans.staff,
		active = false,
		display = function()

			--> Variables
			local sizeH = math.Round(self.content:GetTall()/6)

			--> Clear
			self.content:Clear()
			self.content:GetVBar():SetScroll(0)

			--> Content Scroll
			self.contentScroll = vgui.Create("DPanel", self.content)
			self.contentScroll:SetSize(1, self.content:GetTall()+1)
			self.contentScroll.Paint = function() end

			--> Loop
			local staffCount = 0
			for k, v in pairs(player.GetAll()) do

				--> Staff
				if !table.HasValue(string.Explode(",", TCBScoreboardSettings.staffGroups), v:GetUserGroup()) then continue end

				--> Count
				staffCount = staffCount+1

				--> Panel
				local panel = vgui.Create("TCB-Scoreboard-Player", self.content)
				panel:DockMargin(1, 0, 10, 0)
				panel:SetTall(sizeH)
				panel:Dock(TOP)
				panel:SetPlayer(v)
				panel.staffDisplay = true

			end

			--> Status
			self.status.text = string.Replace(TCBScoreboardSettings.trans.showStaff, "%", tostring(staffCount))

		end
	}

	if TCBScoreboardSettings.collectionID != "" then
		self.menuItems[3] = {
			name = TCBScoreboardSettings.trans.collection,
			active = false,
			display = function(force)

				--> Force
				if !force then return end

				--> Variables
				local sizeH = math.Round(self.content:GetTall()/6)

				--> Clear
				self.content:Clear()
				self.content:GetVBar():SetScroll(0)

				--> Content Scroll
				self.contentScroll = vgui.Create("DPanel", self.content)
				self.contentScroll:SetSize(1, self.content:GetTall()+1)
				self.contentScroll.Paint = function() end

				--> Variables
				local addons = {}

				--> Status
				self.status.text = TCBScoreboardSettings.trans.loading

				--> Collection
				http.Fetch("http://steamcommunity.com/sharedfiles/filedetails/?id="..TCBScoreboardSettings.collectionID, function(body, len, headers, code)

					--> Collection Info
					local collectionInfo = vgui.Create("DPanel", self.content)
					collectionInfo:DockMargin(1, 0, 10, 0)
					collectionInfo:SetTall(sizeH)
					collectionInfo:Dock(TOP)
					collectionInfo.Paint = function(pnl, w, h)

						--> Border
						draw.RoundedBox(0, 0, h-1, w, 1, Color(215, 215, 215, 200))

					end

					--> Collection Text
					local collectionText = vgui.Create("DPanel", collectionInfo)
					collectionText:Dock(LEFT)
					collectionText:DockMargin(30, 10, 10, 10)
					collectionText:SetWide(400)
					collectionText.Paint = function(pnl, w, h)

						--> Text
						draw.SimpleText(string.match(body, '<div class="workshopItemTitle">([^<]*)</div>'), "TCB-Scoreboard-BoldFont-20", 0, 24, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(TCBScoreboardSettings.trans.collection, "TCB-Scoreboard-BoldFont-16", 0, 44, Color(55, 75, 95, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

					end

					--> Collection View
					local collectionView = vgui.Create("DButton", collectionInfo)
					collectionView:Dock(RIGHT)
					collectionView:DockMargin(31, 29, 31, 29)
					collectionView:SetSize(125, 26)
					collectionView:SetText("")
					collectionView.Paint = function(pnl, w, h)

						--> Background
						draw.RoundedBox(4, 0, 0, w, h, Color(50, 150, 220, 255))

						--> Text
						draw.SimpleText(TCBScoreboardSettings.trans.viewOnline, "TCB-Scoreboard-BoldFont-18", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					end
					collectionView.DoClick = function()

						--> Open
						gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id="..TCBScoreboardSettings.collectionID)

					end

					--> Items
					addons = string.Explode('class="collectionItem">', body)

					--> Lopp
					for k,v in pairs(addons) do

						--> Skip
						if k == 1 then continue end

						--> Variables
						local item = {}

						--> Info
						item['id'] = string.match(v, 'SubscribeItemBtn([^"]*)')
						item['name'] = string.match(v, '<div class="workshopItemTitle">([^<]*)</div>')
						item['image'] = string.match(v, '<img class="workshopItemPreviewImage" src="([^"]*)">')
						item['author'] = string.match(v, '<span class="workshopItemAuthorName">[^>]*>([^<]*)')

						--> Panel
						local panel = vgui.Create("TCB-Scoreboard-Workshop", self.content)
						panel:DockMargin(1, 0, 10, 0)
						panel:SetTall(sizeH)
						panel:Dock(TOP)
						panel:SetItem(item)

					end

					--> Status
					self.status.text = string.Replace(TCBScoreboardSettings.trans.showAddons, "%", tostring(#addons))

				end)

			end
		}
	end

	--> Menu
	local tabY = (140-(60+54/2))/2
	local tabX = 20
	for k,v in pairs(self.menuItems) do

		--> Size
		surface.SetFont("TCB-Scoreboard-Font-18")
		local tabW = surface.GetTextSize(v.name)

		--> Tabs
		v.tab = vgui.Create("DButton", self)
		v.tab:SetSize(tabW+25, 30)
		v.tab:SetPos(tabX, 60+(tabY-v.tab:GetTall()/2))
		v.tab:SetText('')
		v.tab.Paint = function(pnl, w, h)

			--> Text
			if pnl.Hovered then
				draw.SimpleTextOutlined(v.name, "TCB-Scoreboard-Font-18", w/2, h/2, Color(150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 15))
			else
				draw.SimpleTextOutlined(v.name, "TCB-Scoreboard-Font-18", w/2, h/2, Color(120, 120, 120, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 15))
			end

			--> Active
			if v.active then
				draw.RoundedBox(0, ((w/2-tabW/2)+10/2)-1, h-4, (tabW-10)+2, 4, Color(0, 0, 0, 25))
				draw.RoundedBox(0, (w/2-tabW/2)+10/2, h-3, tabW-10, 2, Color(120, 120, 120, 100))
			end

		end
		v.tab.DoClick = function()

			--> Reset
			for k,v in pairs(self.menuItems) do
				v.active = false
			end

			--> Active
			v.active = true

			--> Display
			v.display(true)

		end

		--> Position
		tabX = tabX+v.tab:GetWide()+20

	end

end

--[[---------------------------------------------------------
	Name: UpdatePanel
-----------------------------------------------------------]]
function PANEL:UpdatePanel(friends, force)

	--> Friends
	if !friends then

		--> Network
		net.Start("scoreboard_friends")
		net.SendToServer()

	end

	--> Loop
	for k,v in pairs(self.menuItems) do

		--> Active
		if !v.active then continue end

		--> Display
		v.display(force)

	end

end

--[[---------------------------------------------------------
	Name: UpdateFriends
-----------------------------------------------------------]]
function PANEL:UpdateFriends(friends)

	--> Reset
	self.friendsID = {}

	--> Players
	for k,v in pairs(friends) do

		--> Table
		table.Add(self.friendsID, {v.steamID})

		--> Online
		local online = player.GetBySteamID(v.steamID)

		--> Set
		if online then
			friends[k] = online
		end

	end

	--> Friends
	self.friends = friends

	--> Update
	self:UpdatePanel(true)

end

--[[---------------------------------------------------------
	Name: GetFriends
-----------------------------------------------------------]]
function PANEL:GetFriends()

	--> Return
	return self.friendsID

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBoxEx(8, 0, 0, w, h, Color(220, 225, 230, 255), true, true, false, false)
	draw.RoundedBoxEx(8, 0, 0, w, 140, Color(50, 50, 50, 255), true, true, false, false)

	--> Header
	draw.RoundedBoxEx(8, 0, 0, w, 60, Color(30, 140, 200, 255), true, true, false, false)
	draw.RoundedBox(0, 0, 60-2, w, 2, Color(0, 0, 0, 100))

	--> Title
	draw.SimpleTextOutlined(TCBScoreboardSettings.name, "TCB-Scoreboard-Font-28", 20, 28, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 15))

end


--[[---------------------------------------------------------
	Name: Think
-----------------------------------------------------------]]
function PANEL:Think()
	--
end

--[[---------------------------------------------------------
	Name: DefineControl
-----------------------------------------------------------]]
derma.DefineControl("TCB-Scoreboard", "TCB-Scoreboard", PANEL, "EditablePanel")
