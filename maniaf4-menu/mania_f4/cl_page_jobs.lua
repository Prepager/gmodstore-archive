--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Categories
	self:SetCategories(DarkRP.getCategories().jobs)

	--> Variables
	self.actionText = Mania.f4.language.become

	--> Name
	self:SetNameCallback(function(item)
		return {
			text = item.name,
			color = team.GetColor(item.team)
		}

	end)

	--> Money
	self:SetMoneyCallback(function(item)
		return {
			text = DarkRP.formatMoney(item.salary),
			color = Color(0, 0, 0, 255)
		}
	end)

	--> Model
	self:SetModelCallback(function(item)

		--> Single
		if not istable(item.model) then return item.model end

		--> Return
		return table.Random(item.model)

	end)

	--> Maximum
	self:SetMaximumCallback(function(item)

		--> None
		if not item.max or item.max == 0 then
			return ''
		end
		
		--> Max
		local max = 0
		if item.max % 1 == 0 then
			max = tostring(item.max)
		else
			max = tostring(math.floor(item.max * #player.GetAll()))
		end

		--> Return
		return ' ['..team.NumPlayers(item.team)..'/'..max..']'

	end)

	--> Action
	self:SetActionCallback(function(item)

		--> Click
		local onClick = function(job)

			--> Vote
			if job.vote or job.RequiresVote and job.RequiresVote(LocalPlayer(), job.team) then
				RunConsoleCommand("darkrp", "vote" .. job.command)
			else
				RunConsoleCommand("darkrp", job.command)
			end

			--> Close
			if self.tab.shouldClose then
				hook.Call('ShowSpare2')
			end

		end

		--> Model
		if not istable(item.model) or table.Count(item.model) == 1 then

			--> Click
			onClick(item)

		else

			--> Disable
			self:SetMouseInputEnabled(false)

			--> Holder
			local holder = vgui.Create('DPanel', self:GetParent())
			holder:SetSize(self:GetWide(), self:GetTall())
			holder.Paint = function(pnl, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
			end

			--> Panel
			local pnl = vgui.Create('DPanel', holder)
			pnl:SetSize(352, 230)
			pnl:SetPos(self:GetWide()/2-pnl:GetWide()/2, self:GetTall()/2-pnl:GetTall()/2)
			pnl.Paint = function(pnl, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(225, 225, 225, 255))
				draw.RoundedBox(4, 1, 1, w-2, h-2, Color(255, 255, 255, 255))
			end

			--> Close
			local close = vgui.Create('DButton', holder)
			close:SetSize(125, 30)
			close:SetPos(self:GetWide()/2-close:GetWide()/2, self:GetTall()/2+pnl:GetTall()/2+15)
			close:SetColor(Color(255, 255, 255, 255))
			close:SetFont('ManiaUI_regular_18')
			close:SetText('Close')
			close.Paint = function(pnl, w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(231, 76, 60, 255))
				if pnl.Hovered then
					draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 40))
				end
			end
			close.DoClick = function()

				--> Remove
				holder:Remove()

				--> Enable
				self:SetMouseInputEnabled(true)

			end

			--> Scroll
			local scroll = vgui.Create('ManiaScrollPanel', pnl)
			scroll:SetSize(pnl:GetWide(), pnl:GetTall())
			scroll:SetMouseInputEnabled(true)

			--> Models
			local count = 1
			local posX = 10
			local posY = 10
			for k, v in pairs(item.model) do
				
				--> Rounded
				local rounded = vgui.Create('ManiaRounded', scroll)
				rounded:SetSize(100, 100)
				rounded:SetPos(posX, posY)
				rounded:AllowItemInput(true)

				--> Static
				local face = nil
				if self.tab.displayStatic then
					face = vgui.Create('ManiaImage', rounded)
				else
					face = vgui.Create('ManiaFace', rounded)
				end

				--> Item
				face:SetModel(v)
				face:SetPaintedManually(true)
				face.DoClick = function()

					--> Preferred
					DarkRP.setPreferredJobModel(item.team, v)

					--> Run
					onClick(item)

					--> Close
					close:DoClick()

				end

				--> Paint
				local defaultPaint = baseclass.Get("DModelPanel")
				face.Paint = function(pnl, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
					defaultPaint.Paint(pnl, w, h )
				end

				--> Rounded
				rounded.item = face

				--> Count f57aea660da7c02a56b1986c263e88c1f2cd0a630c74d837948d365878c3480b
				if count != 3 then
					posX = posX+rounded:GetWide()+10
					count = count+1
				else
					posX = 10
					posY = posY+rounded:GetTall()+10
					count = 1
				end

			end

		end

	end)

	--> Info
	self:SetInfoCallback(function(item)

		--> Disable
		self:SetMouseInputEnabled(false)

		--> Holder
		local holder = vgui.Create('DPanel', self:GetParent())
		holder:SetSize(self:GetWide(), self:GetTall())
		holder.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		end

		--> Panel
		local pnl = vgui.Create('DPanel', holder)
		pnl:SetSize(352, 230)
		pnl:SetPos(self:GetWide()/2-pnl:GetWide()/2, self:GetTall()/2-pnl:GetTall()/2)
		pnl.Paint = function(pnl, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(225, 225, 225, 255))
			draw.RoundedBox(4, 1, 1, w-2, h-2, Color(255, 255, 255, 255))
		end

		--> Close
		local close = vgui.Create('DButton', holder)
		close:SetSize(125, 30)
		close:SetPos(self:GetWide()/2-close:GetWide()/2, self:GetTall()/2+pnl:GetTall()/2+15)
		close:SetColor(Color(255, 255, 255, 255))
		close:SetFont('ManiaUI_regular_18')
		close:SetText('Close')
		close.Paint = function(pnl, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(231, 76, 60, 255))
			if pnl.Hovered then
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 40))
			end
		end
		close.DoClick = function()

			--> Remove
			holder:Remove()

			--> Enable
			self:SetMouseInputEnabled(true)

		end

		--> Scroll
		local scroll = vgui.Create('ManiaScrollPanel', pnl)
		scroll:SetSize(pnl:GetWide(), pnl:GetTall())
		scroll:SetMouseInputEnabled(true)

		--> Description
	    local description = vgui.Create('DLabel', scroll)
	    description:Dock(FILL)
	    description:SetFont('ManiaUI_regular_18')
	    description:SetColor(Color(0, 0, 0, 245))
	    description:SetAutoStretchVertical(true)

	    --> Text
		local desc = DarkRP.textWrap(DarkRP.deLocalise(item.description or ''):gsub('  +', '- '), 'ManiaUI_regular_18', 320)
		surface.SetFont('ManiaUI_regular_18')
		local _, h = surface.GetTextSize(desc)

		description:SetText(desc)
		description:SetTall(h)

	end)

	--> Validation
	self:SetValidationCallback(function(job)

		--> Variables
	    local ply = LocalPlayer()

	    --> Search
	    local failSearch = self:GetSearchCallback()(job)
	    if failSearch then
	    	return false, true, true
	    end

	    --> Checks
	    if isnumber(job.NeedToChangeFrom) and ply:Team() ~= job.NeedToChangeFrom then return false, true end
	    if istable(job.NeedToChangeFrom) and not table.HasValue(job.NeedToChangeFrom, ply:Team()) then return false, true end
	    if job.customCheck and not job.customCheck(ply) then return false, true end
	    if ply:Team() == job.team then return false, true end
	    if job.max ~= 0 and ((job.max % 1 == 0 and team.NumPlayers(job.team) >= job.max) or (job.max % 1 ~= 0 and (team.NumPlayers(job.team) + 1) / #player.GetAll() > job.max)) then return false, false end
	    if job.admin == 1 and not ply:IsAdmin() then return false, true end
	    if job.admin > 1 and not ply:IsSuperAdmin() then return false, true end

	    --> Return
	    return true

	end)

	--> Disabled
	self:SetDisabledCallback(function(panel, can, isImportant, _, _, isSearch)

		--> Search
		if isSearch then
			panel:SetVisible(false)
			return false
		end

		--> Defaults
	    if can and (GAMEMODE.Config.hideNonBuyable or (important and GAMEMODE.Config.hideTeamUnbuyable)) then
	        panel:SetVisible(false)
	        return false
	    else
	        panel:SetVisible(true)
	        return true
	    end

	end)

	--> Info
	self.infoText = Mania.f4.language.info
	self:SetInfo(function() return end)

	--> Reload 5c4ae23e57e13cd8272ca3b5a13780fd25b4fd032da8207deb0125f7647e101e
	self:ReloadContent()

end

--[[---------------------------------------------------------
	Define: ManiaPage-jobs
-----------------------------------------------------------]]
derma.DefineControl('ManiaPage-jobs', 'ManiaPage-jobs', PANEL, 'ManiaPage-base')