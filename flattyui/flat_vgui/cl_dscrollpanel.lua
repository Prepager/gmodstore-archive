--[[---------------------------------------------------------
	Setup Table
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	PANEL: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--> Rebuild
	self:Rebuild()

	--> Height
	local height = self.pnlCanvas:GetTall()
	if self.pnlCanvas:GetTall() < self:GetTall() then
		height = self:GetTall() + 1
	end

	--> Settings
	self.VBar:SetUp(self:GetTall(), height)
	YPos = self.VBar:GetOffset()

	--> VBar
	self.VBar.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 50))
	end

	--> BtnGrip
	self.VBar.btnUp.Paint = function(pnl, w, h) 
		draw.RoundedBox(2, 2, 2, w - 4, h - 4, Color(63, 81, 181, 255)) 
		draw.DrawText("▲", "HudHintTextSmall", 3, 2, Color(255, 255, 255, 255)) 
	end

	--> BtnUp
	self.VBar.btnDown.Paint = function(pnl, w, h)
		draw.RoundedBox(2, 2, 2, w - 4, h - 4, Color(63, 81, 181, 255)) 
		draw.DrawText("▼", "HudHintTextSmall", 3, 2, Color(255, 255, 255, 255)) 
	end

	--> BtnDown
	self.VBar.btnGrip.Paint = function(pnl, w, h)
		draw.RoundedBox(4, 3, 2, w - 6, h - 4, Color(63, 81, 181, 255))
	end

	--> Canvas
	self.pnlCanvas:SetPos(0, YPos)
	self.pnlCanvas:SetWide(self:GetWide() - self.VBar:GetWide())

	--> Rebuild
	self:Rebuild()

end

--[[---------------------------------------------------------
	Register VGUI
-----------------------------------------------------------]]
vgui.Register("flatScrollPanel", PANEL, "DScrollPanel")