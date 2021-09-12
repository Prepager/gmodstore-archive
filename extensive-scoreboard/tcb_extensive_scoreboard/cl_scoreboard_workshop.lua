--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Name: Player
-----------------------------------------------------------]]
PANEL.varItem = nil

--[[---------------------------------------------------------
	Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Icon Holder
	self.iconHolder = vgui.Create("DPanel", self)
	self.iconHolder:Dock(LEFT)
	self.iconHolder:DockMargin(10, 10, 10, 10)
	self.iconHolder.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(230, 230, 230, 255), true, true, false, false)

	end

	--> Icon
	self.icon = vgui.Create("HTML", self.iconHolder)
	self.icon:Dock(FILL)

	--> Info
	self.info = vgui.Create("DPanel", self)
	self.info:Dock(LEFT)
	self.info:DockMargin(5, 10, 10, 10)
	self.info:SetWide(400)
	self.info.Paint = function(pnl, w, h)

		--> Text
		draw.SimpleText(self.varItem['name'], "TCB-Scoreboard-BoldFont-20", 0, 24, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.varItem['author'], "TCB-Scoreboard-BoldFont-16", 0, 44, Color(55, 75, 95, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	--> Subscribe
	self.subscribe = vgui.Create("DButton", self)
	self.subscribe:Dock(RIGHT)
	self.subscribe:DockMargin(31, 29, 31, 29)
	self.subscribe:SetSize(125, 26)
	self.subscribe:SetText("")
	self.subscribe.subbed = false
	self.subscribe.status = false
	self.subscribe.Paint = function(pnl, w, h)

		--> Status
		if self.subscribe.status != false then

			--> Background
			draw.RoundedBox(4, 0, 0, w, h, Color(150, 165, 165, 255))

			--> Text
			draw.SimpleText(self.subscribe.status, "TCB-Scoreboard-BoldFont-18", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else

			--> Subscribed
			if self.subscribe.subbed then

				--> Background
				draw.RoundedBox(4, 0, 0, w, h, Color(150, 165, 165, 255))

				--> Text
				draw.SimpleText("Subscribed", "TCB-Scoreboard-BoldFont-18", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			else

				--> Background
				draw.RoundedBox(4, 0, 0, w, h, Color(50, 190, 110, 255))

				--> Text
				draw.SimpleText("Subscribe", "TCB-Scoreboard-BoldFont-18", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			end

		end

	end
	self.subscribe.DoClick = function()

		--> Subscribed
		if steamworks.IsSubscribed(self.varItem['id']) then

			--> Subscribed
			GAMEMODE:AddNotify(TCBScoreboardSettings.trans.alreadySubed, 1, 4)
			surface.PlaySound("buttons/lightswitch2.wav")

		else

			--> Button
			self.subscribe.subbed = true

			--> Subscribe
			self.subscribe.status = TCBScoreboardSettings.trans.downloading
			steamworks.FileInfo(self.varItem['id'], function(result)
				steamworks.Download(result.fileid, true, function(name)

					--> Save
					LocalPlayer():SetNWString("scoreboard_subscribed", LocalPlayer():GetNWString("scoreboard_subscribed", "")..self.varItem['id'].." ")

					--> Mount
					self.subscribe.status = TCBScoreboardSettings.trans.mounting
					game.MountGMA(name)
					self.subscribe.status = false

				end)
			end)

		end

	end

end

--[[---------------------------------------------------------
	Name: SetItem
-----------------------------------------------------------]]
function PANEL:SetItem(item)

	--> Variables
	self.varItem = item

	--> Icon
	self.icon:SetHTML('<body style="overflow:hidden;"><div style="width:49px;height:49px;"><img src="'..self.varItem['image']..'" style="width:100%;height:100%;"></div></body>')

	--> Subbed
	self.subscribe.subbed = steamworks.IsSubscribed(self.varItem['id']) or table.HasValue(string.Explode(" ", LocalPlayer():GetNWString("scoreboard_subscribed", "")), self.varItem['id'])

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Border
	draw.RoundedBox(0, 0, h-1, w, 1, Color(215, 215, 215, 200))

end

--[[---------------------------------------------------------
	Name: DefineControl
-----------------------------------------------------------]]
derma.DefineControl("TCB-Scoreboard-Workshop", "TCB-Scoreboard-Workshop", PANEL, "EditablePanel")
