-- Multi-Warp-Tool "MWT" is fully created by -ffs-AbodyRulez & eXecuteR, we decided not to compile the lua file, hoping it might be useful for further learning about lua scripting --
-- All the rights belong to us "-ffs-AbodyRulez & eXecuteR", stealing other people's effort is a bad thing to do --

local window, helpWindow, mainLabel1, mainLabel2, helpScriptLabel, helpCMDLabel, helpCMDELabel, grid, nameCol, warpCol = nil
local saveBut, loadBut, helpBut, deleteBut, deleteAllBut = nil
local vis, his = false

function GUI()
	window = guiCreateWindow( 0.789, 0.6, 0.21, 0.4, "Multi Warp Tool Database", true)
	helpWindow = guiCreateWindow( 0.789, 0.202, 0.21, 0.4, "Multi Warp Tool Commands", true, window)
	guiSetVisible(window, false)
	guiSetVisible(helpWindow, false)
	guiWindowSetSizable (window, false)
	guiWindowSetSizable (helpWindow, false)
	mainLabel1 = guiCreateLabel( 0.04, 0.353, 0.3, 0.4,"     -ffs-\nAbodyRulez", true, window)
	mainLabel2 =  guiCreateLabel(0.04, 0.59, 0.3, 0.4,"  eXecuteR\n  MWT V.1", true, window)
	helpScriptLabel = guiCreateLabel( 0.11,0.1, 1, 0.2, "Scripted by: -ffs-AbodyRulez & eXecuteR", true, helpWindow)
	helpCMDLabel = guiCreateLabel( 0.04,0.2, 1, 1, "/save\n \n/save [No.]\n\n/load\n\n/load [No.]\n\n/load [Name]\n\n/load [Name] [No.]\n\n/deletewarp [No.]\n\n/deletewarps", true, helpWindow)
	helpCMDELabel = guiCreateLabel( 0.44,0.2, 1, 1, "Save primary warp\n\nSave No. assigned warp\n\nLoad primary warp\n\nLoad No. assigned warp\n\nLoad a player's primary warp\n\nLoad a player's No. warp\n\nDelete No. assigned warp\n\nDelete all warps [Admin]", true, helpWindow)
	guiLabelSetColor(helpCMDLabel,255, 191, 0)
	guiLabelSetColor(mainLabel1, 255, 191, 0)
	guiLabelSetColor(mainLabel2, 255, 191, 0)
	guiLabelSetColor(helpScriptLabel, 255, 191, 0)
	grid = guiCreateGridList(0.3, 0.087 , 0.66, 0.87, true, window)
	guiGridListSetSortingEnabled(grid, true)
	nameCol = guiGridListAddColumn(grid, "Player Name", 0.58)
	warpCol = guiGridListAddColumn(grid, "Warp No.", 0.25)
	saveBut = guiCreateButton( 0.04, 0.087, 0.23, 0.1, "Save", true, window)	
	loadBut = guiCreateButton( 0.04, 0.227, 0.23, 0.1, "Load", true, window)
	helpBut = guiCreateButton( 0.04, 0.472, 0.23, 0.1, "Help", true, window)
	deleteBut = guiCreateButton( 0.04, 0.717, 0.23, 0.1, "Delete", true, window)
	deleteAllBut = guiCreateButton( 0.04, 0.857, 0.23, 0.1, "Delete All", true, window)
	outputChatBox("#FF9E00MWT: -ffs-#ffffffAbodyRulez #FF9E00&#ffffff eXecuteR's MWT #FF9E00\"Multi-Warp-Tool\" #0EA124Activated!", 255, 255, 255, true)
	outputChatBox("#FF9E00MWT: #ffffffPress #FF9E00'K'#ffffff to toggle Multi-Warp-Tool window", 255, 255, 255, true)
	triggerServerEvent("onDownloadCompleted", resourceRoot)
end
addEventHandler("onClientResourceStart", resourceRoot, GUI)

function buttonHandler(button, state)
	if(button == "left" and state =="up") then
		local x, y = guiGridListGetSelectedItem(grid)	
		if(source == saveBut) then
			executeCommandHandler("save",tostring(guiGridListGetItemText(grid,x, y+1)).." "..tostring(guiGridListGetItemText(grid,x, y)))
		elseif(source == loadBut) then
			executeCommandHandler("load",tostring(guiGridListGetItemText(grid,x, y)).." "..tostring(guiGridListGetItemText(grid,x, y+1)))
			showCursor(false)
			guiSetVisible(window, false)
			guiSetVisible(helpWindow, false)
		elseif(source == deleteBut) then
			executeCommandHandler("deletewarp",tostring(guiGridListGetItemText(grid,x, y)).." "..tostring(guiGridListGetItemText(grid,x, y+1)))
		elseif(source == deleteAllBut) then
			executeCommandHandler("deletewarps",1)
			showCursor(false)
			guiSetVisible(window, false)
			guiSetVisible(helpWindow, false)
		elseif(source == helpBut) then
			toggleHelp()
		end
	end
end
addEventHandler("onClientGUIClick", root, buttonHandler)

function toggleHelp()
	his = not his
	guiSetVisible(helpWindow, his)
end

function toggleVisibility()
	vis = not vis
	guiSetVisible(window, vis)
	showCursor(vis)
	if(vis == false) then
		guiSetVisible(helpWindow,false)
		his = false
	end
end
bindKey("k", "down", toggleVisibility)

function updateList(list)
	guiGridListClear(grid)
	if(nameCol and warpCol) then
		for k, v in pairs(list) do 
			local row = guiGridListAddRow(grid)
	    	guiGridListSetItemText(grid, row, nameCol, v.playerName, false, false)
	    	guiGridListSetItemText(grid, row, warpCol, v.warpNumber, false, true)
		end
	else
		outputChatBox("#ff0000MWT Syncing Error: #ffffffTry restarting MWT resource, Use /restart mwt", 255, 255, 255, true)
	end
end
addEvent("onServerListUpdate", true)
addEventHandler("onServerListUpdate", root, updateList)