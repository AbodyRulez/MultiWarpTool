-- Multi-Warp-Tool "MWT" is fully created by -ffs-AbodyRulez & eXecuteR, we decided not to compile the lua file, hoping it might be useful for further learning about lua scripting --
-- All the rights belong to us "-ffs-AbodyRulez & eXecuteR", stealing other people's effort is a bad thing to do --

local db = nil

function connectDB()
	db = dbConnect( "sqlite", "warps.db")
	dbExec( db, "CREATE TABLE IF NOT EXISTS Warps (warpNumber NUMBER, playerName TEXT, playerSerial TEXT, vehicleID NUMBER, px NUMBER, py NUMBER, pz NUMBER, vx NUMBER, vy NUMBER, vz NUMBER, rx NUMBER, ry NUMBER, rz NUMBER)")	
end
addEventHandler("onPlayerJoin", root, connectDB)
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), connectDB)

function updateList()
	if not (db) then return outputChatBox("#ff0000MWT Database Error: #ffffffPlease contact -ffs-AbodyRulez or eXecuteR!",getRootElement(), 255, 255, 255, true) end
	
	local query = dbQuery( db, "SELECT playerName, warpNumber FROM Warps")
	local result = dbPoll( query, -1)
	triggerClientEvent("onServerListUpdate", resourceRoot, result)
end
addEvent("onDownloadCompleted", true)
addEventHandler("onDownloadCompleted", resourceRoot, updateList)

function setWarp(player, warpNum, playerName, playerSerial, vehicleID, px, py, pz, vx, vy, vz, rx, ry, rz)
	if not (db) then return outputChatBox("#ff0000MWT Database Error: #ffffffPlease contact -ffs-AbodyRulez or eXecuteR!", player, 255, 255, 255, true) end
	
	local nameQuery = dbQuery(db, "SELECT playerName, playerSerial from Warps")
	local nameResult = dbPoll( nameQuery, -1)

	for k, v in pairs(nameResult) do
		if(string.lower(playerName) == string.lower(v.playerName) and playerSerial ~= v.playerSerial) then
			return outputChatBox("#ff0000MWT Save Error:#ffffff The name #ff0000"..v.playerName.." #ffffffis already taken!", player,255, 255,255, true)
		end
	end

	local query = dbQuery( db, "SELECT * FROM Warps WHERE playerSerial=? and warpNumber=?", playerSerial, warpNum)
	local result = dbPoll( query, -1)

	if(tonumber(warpNum) == 0 and #result == 0) then
		if(dbExec( db, "INSERT INTO Warps VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)", warpNum, playerName, playerSerial, vehicleID, px, py, pz, vx, vy, vz, rx, ry, rz)) then
			outputChatBox("#FF9E00MWT: #ffffffPrimary warp saved.", player, 255, 255, 255, true)
		else 
			outputChatBox("#ff0000MWT Save Error: #ffffffSaving primary warp failed!", player, 255, 255, 255, true)
		end
	elseif(tonumber(warpNum) == 0 and #result ==1) then
		if(dbExec(db, "UPDATE Warps SET playerName=?, vehicleID=?, px=?, py=?, pz=?, vx=?, vy=?, vz=?, rx=?, ry=?, rz=? WHERE playerSerial=? and warpNumber = '0' ", playerName, vehicleID, px, py, pz, vx, vy, vz, rx, ry, rz, playerSerial)) then
			outputChatBox("#FF9E00MWT: #ffffffPrimary warp updated.", player, 255, 255, 255, true)
		else 
			outputChatBox("#ff0000MWT Save Error: #ffffffUpdating primary warp failed!", player, 255, 255, 255, true)
		end
	elseif(tonumber(warpNum) and #result == 0) then
		if(dbExec( db, "INSERT INTO Warps VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)", warpNum, playerName, playerSerial, vehicleID, px, py, pz, vx, vy, vz, rx, ry, rz)) then
			outputChatBox("#FF9E00MWT: #ffffffWarp No.#FF9E00\""..warpNum.."\"#ffffff saved.", player, 255, 255, 255, true)
		else
			outputChatBox("#ff0000MWT Save Error: #ffffffSaving warp No.#FF9E00\""..warpNum.."\"#ffffff failed!", player, 255, 255, 255, true)
		end
	elseif(tonumber(warpNum) and #result == 1) then
		if(dbExec(db, "UPDATE Warps SET playerName=?, vehicleID=?, px=?, py=?, pz=?, vx=?, vy=?, vz=?, rx=?, ry=?, rz=? WHERE playerSerial=? and warpNumber =?", playerName, vehicleID, px, py, pz, vx, vy, vz, rx, ry, rz, playerSerial, warpNum)) then
			outputChatBox("#FF9E00MWT: #ffffffwarp No.#FF9E00\""..warpNum.."\"#ffffff updated.", player, 255, 255, 255, true)
		else 
			outputChatBox("#ff0000MWT Save Error: #ffffffUpdating warp No.#FF9E00\""..warpNum.."\"#ffffff failed!", player, 255, 255, 255, true) 
		end
	end
	updateList()
end
addEvent("onClientSaveWarp", true)
addEventHandler("onClientSaveWarp" , resourceRoot, setWarp)


function getWarp(player, playerName, warpNumber)
	if not (db) then return outputChatBox("#ff0000MWT Database Error: #ffffffPlease contact -ffs-AbodyRulez or eXecuteR!", player, 255, 255, 255, true) end

	local query = dbQuery(db, "SELECT * FROM Warps WHERE warpNumber=?", warpNumber)
	local names = dbPoll(query, -1)
	if(#names == 0) then
		return outputChatBox("#ff0000MWT Load Error: #ffffffCould not find warp No.#ff0000\""..warpNumber.."\"#ffffff!", player, 255, 255, 255, true)
	end
	for k, v in pairs(names) do
		if(playerName == v.playerName or string.find(string.lower(v.playerName), string.lower(playerName))) then
			if(string.lower(playerName) == string.lower(getPlayerName(player):gsub('#%x%x%x%x%x%x', ''))) then
				if(tonumber(warpNumber) ==  0) then
					outputChatBox("#FF9E00MWT: #ffffffPrimary warp loaded.", player, 255, 255, 255, true)
				elseif(tonumber(warpNumber) ~= 0) then
					outputChatBox("#FF9E00MWT: #ffffffWarp No.#FF9E00\""..warpNumber.."\"#ffffff loaded.", player, 255, 255, 255, true)
				end
				return triggerClientEvent("onClientVariablesRequest", resourceRoot, player, v.vehicleID, v.px, v.py, v.pz, v.vx, v.vy, v.vz, v.rx, v.ry, v.rz)
			else
				if(tonumber(warpNumber) == 0) then
					outputChatBox("#FF9E00MWT: #ffffffLoaded #ff9e00"..v.playerName.."#ffffff's #ffffffPrimary warp.", player, 255, 255, 255, true)
				elseif(tonumber(warpNumber) ~= 0) then
					outputChatBox("#FF9E00MWT: #ffffffLoaded #ff9e00"..v.playerName.."#ffffff's warp No.#FF9E00\""..warpNumber.."\".", player, 255, 255, 255, true)
				end
				return triggerClientEvent("onClientVariablesRequest", resourceRoot, player, v.vehicleID, v.px, v.py, v.pz, v.vx, v.vy, v.vz, v.rx, v.ry, v.rz)
			end
		end
	end
	if(tonumber(warpNumber) == 0) then
		outputChatBox("#ff0000MWT Load Error: #ffffffCould not find primary warp!", player, 255, 255, 255, true)
	else
		outputChatBox("#ff0000MWT Load Error: #ffffffCould not find player!", player, 255, 255, 255, true)
	end
end
addEvent("onClientLoadWarp", true)
addEventHandler("onClientLoadWarp", resourceRoot, getWarp)

function getDeletedWarp(player, warpNumber, playerName)
	if not (db) then return outputChatBox("#ff0000MWT Database Error: #ffffffPlease contact -ffs-AbodyRulez or eXecuteR!", player, 255, 255, 255, true) end
	if(tonumber(warpNumber) == 0) then return outputChatBox("#ff0000MWT Delete Error: #ffffffDeleting primary warps is not possible!", player, 255, 255, 255, true) end
	
	local serial = getPlayerSerial(player)
	local query = dbQuery(db, "SELECT * FROM Warps WHERE warpNumber=?", warpNumber)
	local result = dbPoll(query, -1)
	if(#result == 0) then
		return outputChatBox("#ff0000MWT Delete Error: #ffffffCould not find warp No.#FF9E00\""..warpNumber.."\"#ffffff.", player, 255, 255, 255, true)
	end
	for k, v in pairs(result) do
		if(serial == v.playerSerial or isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Admin"))) then
			if(playerName == v.playerName or string.find(string.lower(v.playerName), string.lower(playerName))) then
				if(dbExec(db, "DELETE FROM Warps WHERE playerName=? and warpNumber=?", v.playerName, warpNumber)) then
					outputChatBox("#FF9E00MWT: #ffffffDeleted #ff9e00"..v.playerName.."#ffffff's Warp No.#FF9E00\""..warpNumber.."\"#ffffff.", player, 255, 255, 255, true)
				else
					outputChatBox("#ff0000MWT Delete Error: #ffffffCould not delete #ff0000"..v.playerName.."#ffffff's warp No.#ff0000\""..warpNumber.."\"#ffffff!", player, 255, 255, 255, true)
				end
			end
		else
			outputChatBox("#ff0000MWT Authentication Error: #ffffffYou do not have Admin rights to delete other's warp!", player, 255, 255, 255, true)	
		end
	end
	updateList()
end
addEvent("onClientDeleteWarp", true)
addEventHandler("onClientDeleteWarp", resourceRoot, getDeletedWarp)

function getDeletedWarps(player)
	if not (isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Admin"))) then
		return outputChatBox("#ff0000MWT Authentication Error: #ffffffYou do not have Admin rights!", player, 255, 255, 255, true)
	else
		if not (db) then return outputChatBox("#ff0000MWT Database Error: #ffffffPlease contact -ffs-AbodyRulez or eXecuteR!", player, 255, 255, 255, true) end
		if(dbExec(db, "DROP TABLE Warps")) then
			if(dbExec( db, "CREATE TABLE IF NOT EXISTS Warps (warpNumber NUMBER, playerName TEXT, playerSerial TEXT, vehicleID NUMBER, px NUMBER, py NUMBER, pz NUMBER, vx NUMBER, vy NUMBER, vz NUMBER, rx NUMBER, ry NUMBER, rz NUMBER)")) then
				outputChatBox("#FF9E00MWT: #ffffffWarps successfully deleted.", player, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000MWT Delete Error: #ffffffCould not delete warps!", player, 255, 255, 255, true)
		end
	end
	updateList()
end
addEvent("onClientDeleteWarps", true)
addEventHandler("onClientDeleteWarps", resourceRoot, getDeletedWarps)

function disconnectDB()
	if(getPlayerCount() == 0) then
		destroyElement(db)
	end
end
addEventHandler("onPlayerQuit", root, disconnectDB)