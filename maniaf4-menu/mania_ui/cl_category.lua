--[[---------------------------------------------------------
	Variables
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Function: Init
-----------------------------------------------------------]]
function PANEL:Init()

	--> Header
	self.Header:SetTall(35)
	self.Header:SetColor(Color(0, 0, 0, 245))
	self.Header:SetFont('ManiaUI_black_18')
	self.Header:SetTextInset(10, 0)
	self.Header.Paint = function(pnl, w, h)

		--> Background
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(0, 0, 0, 10), true, true, false, false)

		--> Hover
		if pnl.Hovered then
			draw.RoundedBoxEx(4, 0, 0, w, h, Color(0, 0, 0, 20), true, true, false, false)
		end

		--> Border
		draw.RoundedBox(0, 0, h-1, w, 1, Color(225, 225, 225, 255))

	end

	--> List
	local catList = vgui.Create('DPanelList')
	catList:SetAutoSize(true)
	self:SetContents(catList)

	self.Contents.pnlCanvas:DockPadding(10, 5, 10, 5)

end

--[[---------------------------------------------------------
	Function: Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)

	--> Header
	self.Header:SetExpensiveShadow(0)

	--> Background
	draw.RoundedBox(4, 0, 0, w, h, Color(225, 225, 225, 255))
	draw.RoundedBox(4, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

end

--[[---------------------------------------------------------
	Define: ManiaCategory
-----------------------------------------------------------]]
derma.DefineControl('ManiaCategory', 'ManiaCategory', PANEL, 'DCollapsibleCategory')