--[[---------------------------------------------------------
	Name: Simplerr
-----------------------------------------------------------]]
// #NoSimplerr#

--[[---------------------------------------------------------
	Name: Network
-----------------------------------------------------------]]
util.AddNetworkString("scoreboard_friend")
util.AddNetworkString("scoreboard_friends")
util.AddNetworkString("scoreboard_receive_friends")

--[[---------------------------------------------------------
	Name: Fonts
-----------------------------------------------------------]]
if TCBScoreboardSettings.useWorkshop then
	resource.AddWorkshop("630986769")
else
	resource.AddSingleFile("resource/fonts/lato-bold.ttf")
	resource.AddSingleFile("resource/fonts/lato-regular.ttf")
	resource.AddSingleFile("resource/fonts/lato-thin.ttf")
end

--[[---------------------------------------------------------
	Name: Database
-----------------------------------------------------------]]
function scoreboardInitializeDatabase()

	--> Compatibility
	local AUTOINCREMENT = MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"

	--> Table
	MySQLite.query([[
		CREATE TABLE IF NOT EXISTS scoreboard_friends (
			id INTEGER NOT NULL PRIMARY KEY ]]..AUTOINCREMENT..[[,
			account VARCHAR(50) NOT NULL,
			steamID VARCHAR(50) NOT NULL,
			username VARCHAR(255)
		)
	]])

end
hook.Add("DarkRPDBInitialized", "scoreboardInitializeDatabase", scoreboardInitializeDatabase)

--[[---------------------------------------------------------
	Name: Toggle Friend
-----------------------------------------------------------]]
local function scoreboardToggleFriend(length, ply)

	--> Variables
	local account = net.ReadString()
	local username = net.ReadString()

	--> Check
	if string.match(account, "STEAM_(%d+):(%d+):(%d+)") then

		--> Database
		MySQLite.queryValue(string.format([[SELECT COUNT(*) FROM scoreboard_friends WHERE account = %s AND steamID = %s]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(account)), function(data)

			--> Name
			local name = account
			if username != "" then
				name = username
			end

			--> Exist
			if tonumber(data or 0) > 0 then

				--> Delete
				MySQLite.query(string.format([[DELETE FROM scoreboard_friends WHERE account = %s AND steamID = %s]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(account)))

				--> Notify
				DarkRP.notify(ply, 3, 4, string.Replace(TCBScoreboardSettings.trans.removed, "%", name))

			else

				--> Insert
				MySQLite.query(string.format([[INSERT INTO scoreboard_friends (account, steamID, username) VALUES (%s, %s, %s)]], MySQLite.SQLStr(ply:SteamID()), MySQLite.SQLStr(account), MySQLite.SQLStr(username)))

				--> Notify
				DarkRP.notify(ply, 3, 4, string.Replace(TCBScoreboardSettings.trans.added, "%", name))

			end

		end)

	end

end
net.Receive("scoreboard_friend", scoreboardToggleFriend)

--[[---------------------------------------------------------
	Name: Receive Friends
-----------------------------------------------------------]]
local function scoreboardReceiveFriends(length, ply)

	--> Database
	MySQLite.query(string.format([[SELECT * FROM scoreboard_friends WHERE account = %s]], MySQLite.SQLStr(ply:SteamID())), function(data)

		--> Send
		net.Start("scoreboard_receive_friends")
			net.WriteTable(data or {})
		net.Send(ply)

	end)

end
net.Receive("scoreboard_friends", scoreboardReceiveFriends)
