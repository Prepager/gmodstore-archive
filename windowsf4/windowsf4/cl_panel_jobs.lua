--[[---------------------------------------------------------
	Panel: windowsJobs
-----------------------------------------------------------]]
local PANEL = {}
PANEL.localItem = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Self
	self:SetTall(82)
	self:DockMargin(0, 0, 10, 10)
	self:DockPadding(5, 5, 5, 5)

	--> Image
	self.image = vgui.Create("ModelImage", self)
	self.image:Dock(LEFT)
	self.image:SetWide(72)
	self.image.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
	end

	--> Actions
	self.actions = vgui.Create("DPanel", self)
	self.actions:Dock(RIGHT)
	self.actions:SetWide(100)
	self.actions.Paint = function(pnl, w, h) end

	--> Description
	self.description = vgui.Create("DLabel", self)
	self.description:Dock(FILL)
	self.description:SetFont("segoe_18")
	self.description:SetTextColor(Color(0, 0, 0, 255))
	self.description:DockMargin(10, 0, 10, 0)
	self.description:SetContentAlignment(7)
	self.description:SetWrap(true)

	--> Title
	self.title = vgui.Create("DLabel", self)
	self.title:Dock(TOP)
	self.title:SetFont("segoe_semibold_20")
	self.title:SetTextColor(Color(0, 0, 0, 255))
	self.title:DockMargin(10, 0, 10, 0)
	self.title:SetContentAlignment(4)

	--> Become
	self.become = vgui.Create("windowsButton", self.actions)
	self.become:Dock(BOTTOM)
	self.become:SetTall(30)
	self.become:SetText("Become")
	self.become:SetFont("segoe_semibold_20")
	self.become:SetTextColor(Color(255, 255, 255, 255))

	--> Salary
	self.salary = vgui.Create("DLabel", self.actions)
	self.salary:Dock(FILL)
	self.salary:SetFont("segoe_semibold_28")
	self.salary:SetTextColor(windowsSettings.data.scheme("Emerald"))
	self.salary:SetContentAlignment(5)
	self.salary:DockMargin(0, 0, 0, 5)
	self.salary.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(250, 250, 250, 255))
	end

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Background
	draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
	draw.RoundedBox(0, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

end

--[[---------------------------------------------------------
	Function: canGetJob
-----------------------------------------------------------]]
function PANEL:canGetJob(job)
    local ply = LocalPlayer()

    if isnumber(job.NeedToChangeFrom) and ply:Team() ~= job.NeedToChangeFrom then return false, true end
    if istable(job.NeedToChangeFrom) and not table.HasValue(job.NeedToChangeFrom, ply:Team()) then return false, true end
    if job.customCheck and not job.customCheck(ply) then return false, true end
    if ply:Team() == job.team then return false, true end
    if job.max ~= 0 and ((job.max % 1 == 0 and team.NumPlayers(job.team) >= job.max) or (job.max % 1 ~= 0 and (team.NumPlayers(job.team) + 1) / #player.GetAll() > job.max)) then return false, false end
    if job.admin == 1 and not ply:IsAdmin() then return false, true end
    if job.admin > 1 and not ply:IsSuperAdmin() then return false, true end


    return true
end

--[[---------------------------------------------------------
	Function: UpdateData
-----------------------------------------------------------]]
function PANEL:UpdateData(item, parentPanel)

	--> Self
	self.localItem = item

	--> Can
	local canGet, important = self:canGetJob(item)
	if important then
		self:Remove()
	elseif !canGet then
		self.become:SetScheme("Steel")
	end

	--> Model
	if istable(item.model) then
		self.image:SetModel(item.model[math.random(#item.model)])
	else
		self.image:SetModel(item.model)
	end

	--> Title
	self.title:SetText(item.name.." ("..team.NumPlayers(item.team).."/"..(item.max)..")")

	--> Description
	self.description:SetText(item.description)

	--> Salary
	self.salary:SetText(DarkRP.formatMoney(item.salary))

	--> Become
	self.become.DoClick = function()
		if istable(item.model) then
			
			--> Clear
			self:Clear()

			--> Actions
			local actions = vgui.Create("DPanel", self)
			actions:Dock(RIGHT)
			actions:SetWide(100)
			actions.Paint = function(pnl, w, h) end
			actions:InvalidateParent(true)

			--> Cancel
			local cancel = vgui.Create("windowsButton", actions)
			cancel:Dock(BOTTOM)
			cancel:SetTall(30)
			cancel:SetText("Cancel")
			cancel:SetFont("segoe_semibold_20")
			cancel:SetScheme("Red")
			cancel:SetTextColor(Color(255, 255, 255, 255))
			cancel.DoClick = function()

				--> Clear
				self:Clear()

				--> Rebuild
				self:Init()
				self:UpdateData(self.localItem, parentPanel)

			end

			--> Count
			local count = vgui.Create("DLabel", actions)
			count:Dock(FILL)
			count:SetFont("segoe_semibold_28")
			count:SetTextColor(windowsSettings.data.scheme("Emerald"))
			count:SetContentAlignment(5)
			count:DockMargin(0, 0, 0, 5)
			count:SetText(table.Count(item.model))
			count.Paint = function(pnl, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
				draw.RoundedBox(0, 1, 1, w-2, h-2, Color(250, 250, 250, 255))
			end

			--> Models
			local models = vgui.Create("DPanel", self)
			models:Dock(FILL)
			models:DockMargin(0, 0, 5, 0)
			models.Paint = function(pnl, w, h) end
			models:InvalidateParent(true)

			--> Models
			local mdlX, mdlY, mdlC = 0, 0, 0
			for _, mdl in pairs(item.model) do

				local model = vgui.Create("ModelImage", models)
				model:SetPos(mdlX, mdlY)
				model:SetSize(34, 34)
				model:SetModel(mdl)
				model.Paint = function(pnl, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225, 255))
				end
				model.OnMousePressed = function()
					DarkRP.setPreferredJobModel(item.team, mdl)
					if item.vote then
						RunConsoleCommand("darkrp", "vote" .. item.command)
					else
						RunConsoleCommand("darkrp", item.command)
					end
					parentPanel:SetVisible(false)
					parentPanel:Hide()
				end
				model.Think = function()
					model:SetCursor("hand")
				end

				mdlX = mdlX + model:GetWide() + 5
				mdlC = mdlC + 1
				if mdlC == 13 then
					mdlC = 0
					mdlX = 0
					mdlY = mdlY + model:GetTall() + 5
				end

			end

		else
			if item.vote then
				RunConsoleCommand("darkrp", "vote" .. item.command)
			else
				RunConsoleCommand("darkrp", item.command)
			end
			parentPanel:SetVisible(false)
			parentPanel:Hide()
		end
	end

end

--[[---------------------------------------------------------
	Define: windowsJobsItem
-----------------------------------------------------------]]
derma.DefineControl( "windowsJobsItem", "windowsJobsItem", PANEL, "DPanel" )

--[[---------------------------------------------------------
	Panel: windowsJobs
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> List
	self.list = vgui.Create("windowsScrollPanel", self)
	self.list:Dock(FILL)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

end

--[[---------------------------------------------------------
	Function: ReloadData
-----------------------------------------------------------]]
function PANEL:ReloadData()

	--> Clear
	self.list:Clear()

	--> Close
	local parentPanel = self:GetParent():GetParent()

	--> Jobs
	for _, job in pairs(RPExtraTeams) do

		--> Item
		local item = vgui.Create("windowsJobsItem", self.list)
		item:Dock(TOP)
		item:UpdateData(job, parentPanel)

	end

end

--[[---------------------------------------------------------
	Define: windowsJobs
-----------------------------------------------------------]]
derma.DefineControl( "windowsJobs", "windowsJobs", PANEL, "DPanel" )