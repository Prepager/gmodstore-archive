--[[---------------------------------------------------------
	Name: Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Name: Player
-----------------------------------------------------------]]
PANEL.varPlayer = nil

PANEL.varID = ""
PANEL.varJob = ""
PANEL.varNick = ""
PANEL.varColor = ""
PANEL.varModel = "models/player/gman_high.mdl"
PANEL.varGroup = ""

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
	self.icon = vgui.Create("DModelPanel", self.iconHolder)
	self.icon:Dock(FILL)
	self.icon:SetModel(self.varModel)
	self.icon.LayoutEntity = function(ent) return end

	--> Icon Camera
	local eyepos = self.icon.Entity:GetBonePosition(self.icon.Entity:LookupBone("ValveBiped.Bip01_Head1"))
	eyepos:Add(Vector(0, 0, 2))

	self.icon:SetLookAt(eyepos-Vector(0, 0, 2))
	self.icon:SetCamPos(eyepos-Vector(-14, -4, 2))
	self.icon.Entity:SetEyeTarget(eyepos-Vector(-14, -4, 2))

	--> Info
	self.info = vgui.Create("DPanel", self)
	self.info:Dock(LEFT)
	self.info:DockMargin(5, 10, 10, 10)
	self.info:SetWide(400)
	self.info.Paint = function(pnl, w, h)

		--> Text
		draw.SimpleText(self.varNick, "TCB-Scoreboard-BoldFont-20", 0, 24, Color(200, 200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		--> Staff
		if self.staffDisplay then
			local group = self.varGroup
			if TCBScoreboardSettings.staffReplace[self.varGroup] then
				group = TCBScoreboardSettings.staffReplace[self.varGroup]
			end
			draw.SimpleText(group, "TCB-Scoreboard-BoldFont-16", 0, 44, self.varColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(self.varJob, "TCB-Scoreboard-BoldFont-16", 0, 44, self.varColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

	end

	--> Friend
	self.friends = vgui.Create("DButton", self)
	self.friends:Dock(RIGHT)
	self.friends:DockMargin(31, 31, 31, 31)
	self.friends:SetSize(22, 22)
	self.friends:SetText("")
	self.friends.current = table.HasValue(self:GetParent():GetParent():GetParent():GetFriends(), self.varID)
	self.friends.changed = false
	self.friends.changedVal = false
	self.friends.Paint = function(pnl, w, h)

		--> Variables
		self.current = table.HasValue(self:GetParent():GetParent():GetParent():GetFriends(), self.varID)

		--> Current
		if (!self.changed and self.current) or (self.changed and self.changedVal) then

			--> Background
			draw.RoundedBox(4, 0, 0, w, h, Color(240, 65, 65, 255))

			--> Text
			draw.SimpleText("-", "TCB-Scoreboard-BoldFont-20", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		else

			--> Background
			draw.RoundedBox(4, 0, 0, w, h, Color(50, 190, 110, 255))

			--> Text
			draw.SimpleText("+", "TCB-Scoreboard-BoldFont-20", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end

	end
	self.friends.DoClick = function()

		--> Network
		net.Start("scoreboard_friend")
		net.WriteString(self.varID)
		net.WriteString(self.varNick)
		net.SendToServer()

		--> Paint
		if self.changed then
			self.changedVal = !self.changedVal
		else
			self.changedVal = !self.current
		end

		--> Changed
		self.changed = true

	end

	--> Separator
	self.separator = vgui.Create("DPanel", self)
	self.separator:Dock(RIGHT)
	self.separator:DockMargin(0, 20, 0, 20)
	self.separator:SetSize(1, 0)

	--> info
	self.info = vgui.Create("DButton", self)
	self.info:Dock(RIGHT)
	self.info:DockMargin(31, 31, 31, 31)
	self.info:SetSize(22, 22)
	self.info:SetText("")
	self.info.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBox(4, 0, 0, w, h, Color(30, 140, 200, 255))

		--> Text
		draw.SimpleText("i", "TCB-Scoreboard-BoldFont-18", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end
	self.info.DoClick = function()

		--> Frame
		local frame = vgui.Create("DPanel", self:GetParent():GetParent():GetParent())
		frame:SetSize(400, 260)
		frame:Center()
		frame.name = self.varNick
		frame.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBoxEx(8, 0, 0, w, h, Color(220, 225, 230, 255), true, true, false, false)
			draw.RoundedBoxEx(8, 1, 1, w-2, h-2, Color(255, 255, 255, 255), true, true, false, false)

			--> Header
			draw.RoundedBoxEx(8, 0, 0, w, 50, Color(30, 140, 200, 255), true, true, false, false)
			draw.RoundedBox(0, 0, 50-2, w, 2, Color(0, 0, 0, 100))

			--> Title
			draw.SimpleTextOutlined(pnl.name, "TCB-Scoreboard-Font-28", w/2, 50/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 15))

		end

		--> Online
		if IsValid(self.varPlayer) and self.varPlayer:IsPlayer() then

			--> Online
			local onlineTop = vgui.Create("DPanel", frame)
			onlineTop:Dock(TOP)
			onlineTop:DockMargin(10, 60, 10, 10)
			onlineTop:SetTall(128)
			onlineTop.Paint = function(pnl, w, h) end

			--> Avatar
			local avatar = vgui.Create("AvatarImage", onlineTop)
			avatar:Dock(LEFT)
			avatar:SetSize(128, 128)
			avatar:SetPos(10, 10)
			avatar:SetPlayer(self.varPlayer, 128)

			--> Info
			local info = vgui.Create("DPanel", onlineTop)
			info:Dock(FILL)
			info:DockMargin(10, 0, 0, 0)
			info.Paint = function(pnl, w, h) end

			--> Values
			local values = {
				{"Name", function(ply) return ply:Nick() end},
				{"Rank", function(ply) return ply:GetUserGroup() end},
				{"SteamID", function(ply) return ply:SteamID() end},
				{"SteamID (64)", function(ply) return ply:SteamID64() end}
			}

			--> Buttons
			for k, v in pairs(values) do

				--> Button
				local button = vgui.Create("DButton", info)
				button:Dock(TOP)
				button:SetTall(128/#values)
				button:SetText("")
				button.value = v[2](self.varPlayer) or ""
				button.Paint = function(pnl, w, h)

					--> Text
					draw.SimpleText(v[1]..": "..pnl.value, "TCB-Scoreboard-BoldFont-14", 0, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				end
				button.DoClick = function(pnl)

					--> Copy
					SetClipboardText(pnl.value)

				end

			end

			--> Seperator
			local sep = vgui.Create("DPanel", frame)
			sep:Dock(TOP)
			sep:DockMargin(10, 0, 10, 0)
			sep:SetTall(2)
			sep.Paint = function(pnl, w, h)

				--> Background
				draw.RoundedBox(0, 0, 0, w, h, Color(220, 225, 230, 255))

			end

		else

			--> Offline
			local offline = vgui.Create("DPanel", frame)
			offline:Dock(FILL)
			offline:DockMargin(0, 50, 0, 0)
			offline.Paint = function(pnl, w, h)

				--> Text
				draw.SimpleText(TCBScoreboardSettings.trans.playerOffline, "TCB-Scoreboard-BoldFont-24", w/2, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			end

		end

		--> Close
		local close = vgui.Create("DButton", frame)
		close:SetHeight(40)
		close:Dock(BOTTOM)
		close:DockMargin(10, 0, 10, 10)
		close:SetText("")
		close.Paint = function(pnl, w, h)

			--> Background
			draw.RoundedBox(6, 0, 0, w, h, Color(230, 75, 60, 255))

			--> Text
			draw.SimpleText(TCBScoreboardSettings.trans.close, "TCB-Scoreboard-BoldFont-20", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		end
		close.DoClick = function()

			--> Close
			frame:Remove()

		end

	end

end

--[[---------------------------------------------------------
	Name: SetPlayer
-----------------------------------------------------------]]
function PANEL:SetPlayer(ply)

	--> Variables
	self.varPlayer = ply

	--> Think
	self:Think(self)

end

--[[---------------------------------------------------------
	Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	-- Border
	draw.RoundedBox(0, 0, h-1, w, 1, Color(215, 215, 215, 200))

end


--[[---------------------------------------------------------
	Name: Think
-----------------------------------------------------------]]
function PANEL:Think()

	--> Checks
	if !IsValid(self.varPlayer) and !self.varPlayer.steamID then self:Remove() return end

	--> Variables
	if IsValid(self.varPlayer) and self.varPlayer:IsPlayer() then
		self.varID = self.varPlayer:SteamID()
		self.varJob = self.varPlayer:getDarkRPVar("job")
		self.varNick = self.varPlayer:Nick()
		self.varColor = team.GetColor(self.varPlayer:Team())
		self.varModel = self.varPlayer:GetModel()
		self.varGroup = self.varPlayer:GetUserGroup()
	else
		self.varID = self.varPlayer.steamID
		self.varJob = "Offline"
		self.varNick = self.varPlayer.username
		self.varColor = Color(255, 0, 0, 255)
		self.varModel = TCBScoreboardSettings.offlineMdl
		self.varGroup = "Offline"
	end

	--> Model
	if self.icon:GetModel() != self.varModel then
		self.icon:SetModel(self.varModel)
	end

end

--[[---------------------------------------------------------
	Name: DefineControl
-----------------------------------------------------------]]
derma.DefineControl("TCB-Scoreboard-Player", "TCB-Scoreboard-Player", PANEL, "EditablePanel")
