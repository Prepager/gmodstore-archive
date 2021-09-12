--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
TCBScoreboardSettings = TCBScoreboardSettings or {}
TCBScoreboardSettings.trans = TCBScoreboardSettings.trans or {}

--[[---------------------------------------------------------
	Name: Settings
-----------------------------------------------------------]]
TCBScoreboardSettings.name = "CommunityName - Scoreboard"
TCBScoreboardSettings.offlineMdl = "models/player.mdl"

TCBScoreboardSettings.useWorkshop = true

TCBScoreboardSettings.staffGroups = "superadmin,admin,moderator"

TCBScoreboardSettings.staffReplace = {}
TCBScoreboardSettings.staffReplace["superadmin"] = "Superadmin"
TCBScoreboardSettings.staffReplace["admin"] = "Admin"
TCBScoreboardSettings.staffReplace["moderator"] = "Moderator"

--[[---------------------------------------------------------
	Name: Collection
-----------------------------------------------------------]]
TCBScoreboardSettings.collectionID = "286538224"

--[[---------------------------------------------------------
	Name: Translate
-----------------------------------------------------------]]
TCBScoreboardSettings.trans.online = "Online"
TCBScoreboardSettings.trans.friends = "Friends"
TCBScoreboardSettings.trans.staff = "Staff"
TCBScoreboardSettings.trans.collection = "Steam Collection"

TCBScoreboardSettings.trans.refresh = "Refresh"
TCBScoreboardSettings.trans.close = "Close"
TCBScoreboardSettings.trans.loading = "Loading..."
TCBScoreboardSettings.trans.downloading = "Downloading..."
TCBScoreboardSettings.trans.mounting = "Mounting..."
TCBScoreboardSettings.trans.collection = "Workshop Collection"
TCBScoreboardSettings.trans.viewOnline = "View Online"

TCBScoreboardSettings.trans.added = "You added % to your friends list!"
TCBScoreboardSettings.trans.removed = "You removed % from your friends list!"
TCBScoreboardSettings.trans.alreadySubed = "You are already subscribed to this addon!"

TCBScoreboardSettings.trans.showPlayers = "Showing % players."
TCBScoreboardSettings.trans.showFriends = "Showing % friends."
TCBScoreboardSettings.trans.showStaff = "Showing % staff members."
TCBScoreboardSettings.trans.showAddons = "Showing % addons."

TCBScoreboardSettings.trans.playerOffline = "This player is offline."