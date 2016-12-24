-- Multi-Warp-Tool "MWT" is fully created by -ffs-AbodyRulez & eXecuteR, we decided not to compile the lua file, hoping it might be useful for further learning about lua scripting --
-- All the rights belong to us "-ffs-AbodyRulez & eXecuteR", stealing other people's effort is a bad thing to do --

local serial, name, px, py, pz, vx, vy, vz, rx, ry, rz, vid, warpn = nil

function saveWarp(cmd, arg, arg2)
	if(isPedInVehicle(getLocalPlayer()) == false or isPedDead(getLocalPlayer())) then return outputChatBox("#ff0000MWT Save Error: #ffffffPlayer is not in a vehicle!", 255, 255, 255, true) end
	
	local warpNumber = 0
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	px, py, pz = getElementPosition(vehicle)
	rx, ry, rz = getElementRotation(vehicle)
	vx, vy, vz = getElementVelocity(vehicle)
	vid = getElementModel(vehicle)
	serial = getPlayerSerial()
	if(arg2 == nil) then 
		name = getPlayerName(getLocalPlayer()):gsub('#%x%x%x%x%x%x', '')
	else
		name = arg2
	end

	if(arg == nil) then
		triggerServerEvent( "onClientSaveWarp", resourceRoot, getLocalPlayer(), warpNumber, name, serial, vid ,px, py, pz, vx, vy, vz, rx, ry, rz)
	elseif(tonumber(arg)) then
		triggerServerEvent( "onClientSaveWarp", resourceRoot, getLocalPlayer(), arg, name, serial, vid ,px, py, pz, vx, vy, vz, rx, ry, rz)
	else
		return outputChatBox("#ff0000MWT Syntax Error: #ffffffUse /save or /save [warp number].", 255, 255, 255, true)
	end
end
addCommandHandler("save", saveWarp)

function loadWarp(cmd, arg, arg2)
	if(isPedInVehicle(getLocalPlayer()) == false or isPedDead(getLocalPlayer())) then return outputChatBox("#ff0000MWT Load Error: #ffffffPlayer is not in a vehicle!", 255, 255, 255, true) end
	local warpNumber, playerName = nil

	if(arg == nil and arg2 == nil) or (tonumber(arg) and arg2 == nil) then 
		if(arg == nil) then warpNumber = 0 else warpNumber = arg end
		playerName = getPlayerName(getLocalPlayer()):gsub('#%x%x%x%x%x%x', '')
	elseif not(tonumber(arg)) and (arg2 == nil) or not(tonumber(arg)) and (tonumber(arg2)) then 
		if(arg2 == nil) then warpNumber = 0 else warpNumber = arg2 end
		playerName = arg
	else
		return outputChatBox("#ff0000MWT Syntax Error: #ffffffUse /load [warp number] #ff0000or /load [player name] [warp number]")
	end
	triggerServerEvent("onClientLoadWarp", resourceRoot, getLocalPlayer(), playerName, warpNumber)	
end
addCommandHandler("load", loadWarp)

function deleteWarp(cmd, arg, arg2)
	if(arg == nil) then return outputChatBox("#ff0000MWT Syntax Error: #ffffffUse /deletewarp [warp number]!", 255, 255, 255, true) end
	local warpNumber, playerName = nil
	if(tonumber(arg) and arg2 == nil) then
		warpNumber = arg
		playerName = getPlayerName(getLocalPlayer()):gsub('#%x%x%x%x%x%x', '') 
	elseif not(tonumber(arg)) and (tonumber(arg2)) then
		warpNumber = arg2
		playerName = arg
	else
		return outputChatBox("#ff0000MWT Syntax Error: #ffffffUse /deletewarp [warp number] #ff0000or #ffffff/deletewarp [player name] [warp number]!", 255, 255, 255, true)
	end
	triggerServerEvent("onClientDeleteWarp", resourceRoot, getLocalPlayer(), warpNumber, playerName)
end
addCommandHandler("deletewarp", deleteWarp)

function getSQLVariables(player, vid_, px_, py_, pz_, vx_, vy_, vz_, rx_, ry_, rz_)
	vid =vid_
	px = px_
	py = py_
	pz = pz_
	vx = vx_
	vy = vy_
	vz = vz_
	rx = rx_
	ry = ry_
	rz = rz_
	local vehicle = getPedOccupiedVehicle(player)
	if (vid ~=nil and px~=nil and py~=nil and pz~=nil and rx~=nil and ry~=nil and rz~=nil and vx~=nil and vy~=nil and vz~=nil) then
		setElementFrozen (vehicle, true)
		setElementModel(vehicle, vid)
		setElementRotation(vehicle, rx, ry, rz)
		setElementPosition(vehicle, px, py, pz)
		fixVehicle(vehicle)
		addVehicleUpgrade(vehicle, 1010)
		setTimer(setElementFrozen, 400, 1, vehicle, false)
		setTimer(setElementVelocity, 500, 1, vehicle, vx, vy, vz)
	end
end
addEvent("onClientVariablesRequest", true)
addEventHandler("onClientVariablesRequest", resourceRoot, getSQLVariables)

function deleteWarps(cmd, arg)
	if(arg == nil) then
		outputChatBox("#FF9E00MWT: #ffffffAre you sure you want to delete all warps?\n#FF9E00'Yes'#ffffff [/deletewarps 1]\n#FF9E00'No' #ffffff[/deletewarps 0]", 255, 255, 255, true)
	elseif(tonumber(arg) == 0) then
		outputChatBox("#FF9E00MWT: #ffffffDeleting has been cancelled.", 255, 255, 255, true)
	elseif(tonumber(arg) == 1) then
		triggerServerEvent("onClientDeleteWarps", resourceRoot, getLocalPlayer())
	else
		outputChatBox("#ff0000MWT Syntax Error: #ffffffUse /deletewarps!", 255, 255, 255, true)
	end
end
addCommandHandler("deletewarps", deleteWarps)