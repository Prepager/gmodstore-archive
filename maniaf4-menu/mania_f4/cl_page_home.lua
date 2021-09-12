--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Variables
	self.cats = {}

	--> Holder
	self.holder = vgui.Create('ManiaCategory', self)
	self.holder:Dock(TOP)
	self.holder:SetLabel(Mania.f4.language.commands)

	--> Reload
	self:ReloadContent()
	
end

--[[---------------------------------------------------------
	Function: ReloadCount
-----------------------------------------------------------]]
function PANEL:ReloadCount()

end

--[[---------------------------------------------------------
	Function: ReloadContent
-----------------------------------------------------------]]
function PANEL:ReloadContent()

	--> Clear
	for k,v in pairs(self.holder:GetChildren()) do
		if v:GetName() == 'DPanel' then
			v:Remove()
		end
	end

	--> Variables
	local size = (self:GetParent():GetWide()-(40+14))/3
	local countCorner = {
		[1] = {
			default = {true, false, true, false},
			last = {true, true, true, true}
		},
		[2] = {
			default = {false, false, false, false},
			last = {false, true, false, true}
		},
		[0] = {
			default = {false, true, false, true},
			last = {false, true, false, true}
		}

	}

	--> Total
	local cmdTotal = 0
	for k,v in pairs(Mania.f4.settings.commands) do

		--> Check
		if v.display != nil and !v.display(LocalPlayer()) then continue end

		--> Count
		cmdTotal = cmdTotal+1

	end

	--> Categories
	local cmdCount = 0
	for k, v in pairs(Mania.f4.settings.commands) do

		--> Check
		if v.display != nil and !v.display(LocalPlayer()) then continue end

		--> Count
		cmdCount = cmdCount+1
		
		--> Panel
		local holder = vgui.Create('DPanel', self.holder)
		holder:Dock(TOP)
		holder.Last = (cmdCount == cmdTotal)
		if cmdCount == 1 then
			holder:DockMargin(10, 10, 10, 10)
		elseif holder.Last then
			holder:DockMargin(10, 0, 10, 0)
		else
			holder:DockMargin(10, 0, 10, 10)
		end
		holder.Paint = function(pnl, w, h) 
			if !pnl.Last then
				draw.RoundedBox(0, 0, h-1, w, 1, Color(0, 0, 0, 25))
			end
		end

		--> Buttons
		local count = 0
		local posY = 0
		local posX = 0
		local posH = 0
		for k2, v2 in pairs(v.cmds or {}) do

			--> Count
			count = count+1
			
			--> Button
			local btn = vgui.Create('DButton', holder)
			btn:SetPos(posX, posY)
			btn:SetSize(size, 28)
			btn:SetColor(Color(255, 255, 255, 255))
			btn:SetFont('ManiaUI_regular_18')
			btn:SetText(v2.name)
			btn.Last = (k2 == table.Count(v.cmds))
			btn.Corner = countCorner[count%3]
			btn.Paint = function(pnl, w, h)

				--> Corners
				local corners = pnl.Corner.default
				if pnl.Last then
					corners = pnl.Corner.last
				end

				--> Background
				draw.RoundedBoxEx(4, 0, 0, w, h, v.color, corners[1], corners[2], corners[3], corners[4])

				--> Hover
				if pnl.Hovered then
					draw.RoundedBoxEx(4, 0, 0, w, h, Color(0, 0, 0, 40), true, true, false, false)
				end

			end
			btn.DoClick = function()

				--> Variables
				local params = {}

				--> Params
				if !v2.params then

					--> Click
					v2.click()

					--> Return
					return
					
				end

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
				close:SetPos(self:GetWide()/2-(close:GetWide()+5), self:GetTall()/2+pnl:GetTall()/2+15)
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

				--> Confirm
				local confirm = vgui.Create('DButton', holder)
				confirm:SetSize(125, 30)
				confirm:SetPos(self:GetWide()/2+5, self:GetTall()/2+pnl:GetTall()/2+15)
				confirm:SetColor(Color(255, 255, 255, 255))
				confirm:SetFont('ManiaUI_regular_18')
				confirm:SetText('Confirm')
				confirm.Paint = function(pnl, w, h)
					draw.RoundedBox(4, 0, 0, w, h, Color(46, 204, 113, 255))
					if pnl.Hovered then
						draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 40))
					end
				end
				confirm.DoClick = function()

					--> Click
					v2.click(params)

					--> Close
					close:DoClick()

				end

				--> Scroll
				local scroll = vgui.Create('ManiaScrollPanel', pnl)
				scroll:SetSize(pnl:GetWide(), pnl:GetTall())
				scroll:SetMouseInputEnabled(true)

				--> Params
				for k3, v3 in pairs(v2.params) do
					
					--> Label
					local label = vgui.Create('DLabel', scroll)
					label:Dock(TOP)
					label:SetColor(Color(0, 0, 0, 200))
					label:SetFont('ManiaUI_regular_18')
					label:SetText(v3[1]..':')

					if k3 != 1 then
						label:DockMargin(0, 10, 0, 0)
					end

					--> Type
					if v3[2] == 'string' or v3[2] == 'integer' then
						
						--> Input
						local labelInput = vgui.Create('DTextEntry', scroll)
						labelInput:Dock(TOP)
						labelInput:SetTall(30)
						labelInput:SetFont('ManiaUI_regular_18')
						labelInput:DockMargin(0, 5, 0, 0)
						labelInput.Paint = function(pnl, w, h)

							--> Background
							draw.RoundedBox(4, 0, 0, w, h, Color(225, 225, 225, 255))
							draw.RoundedBox(4, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

							--> Text
							pnl:DrawTextEntryText(Color(0, 0, 0, 200), Mania.f4.settings.theme, Color(0, 0, 0, 200))

						end
						labelInput.OnTextChanged = function()
							params[k3] = labelInput:GetText()
						end

						--> First
						if k3 == 1 then
							labelInput:RequestFocus()
						end

						--> Integer
						if v3[2] == 'integer' then
							labelInput:SetNumeric(true)
						end

					elseif v3[2] == 'player' then
						
						--> Combo
						local labelInput = vgui.Create('DComboBox', scroll)
						labelInput:Dock(TOP)
						labelInput:SetTall(30)
						labelInput:SetFont('ManiaUI_regular_18')
						labelInput:DockMargin(0, 5, 0, 0)
						labelInput.Paint = function(pnl, w, h)

							--> Background
							draw.RoundedBox(4, 0, 0, w, h, Color(225, 225, 225, 255))
							draw.RoundedBox(4, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

							--> Text 2a55b13a0d7bbd39654642c0dd430a84dde59260afe99bf6c7c9f9d65af463af
							//pnl:DrawTextEntryText(Color(0, 0, 0, 200), Mania.f4.settings.theme, Color(0, 0, 0, 200))

						end

						--> Players
						for k, v in pairs(player.GetAll()) do
							labelInput:AddChoice(v:Nick())
						end

						--> Select
						labelInput.OnSelect = function(panel, index, value)
							params[k3] = value
						end

					end

				end

			end

			--> Offset
			local offset = table.Count(v.cmds) % 3
			if offset != 0 and (count%3) != 0 and (count == table.Count(v.cmds) or count == table.Count(v.cmds)-1) then
				if offset == 1 then
					btn:SetWide(size*3)
				else
					btn:SetWide(size*1.5)
				end
			end

			--> Clear
			posX = posX+btn:GetWide()
			posH = posY+btn:GetTall()
			if (count % 3) == 0 then
				posY = posY+btn:GetTall()+5
				posX = 0
			end

		end

		--> Height
		holder:SetHeight(posH+11)

	end

end

--[[---------------------------------------------------------
	Function: ReloadCount
-----------------------------------------------------------]]
function PANEL:ReloadCount()

	--> Reload
	self:ReloadContent()

end

--[[---------------------------------------------------------
	Define: ManiaPage-home
-----------------------------------------------------------]]
derma.DefineControl('ManiaPage-home', 'ManiaPage-home', PANEL, 'ManiaScrollPanel')