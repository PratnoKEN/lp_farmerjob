local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local spawnedBatu = 0
local batuPlants = {}
local isPickingUp = false

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

CreateThread(function()
	while true do
		Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.BatuField.coords, true) < 50 then
			if ESX.PlayerData.job == 'miner' then
				SpawnBatuPlants()
				Wait(500)
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #batuPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(batuPlants[i]), false) < 1 then
				nearbyObject, nearbyID = batuPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showUI ~= 0 then
				lib.showTextUI(lockDoor)
				showUI = 0
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				if ESX.PlayerData.job == 'miner' then
					isPickingUp = true

					lib.callback('lp-farmer:canPickUp', false, function(canPickUp)

						if canPickUp then
							lib.progressCircle({
								duration = 10000,
								useWhileDead = true,
								canCancel = false,
								disable = {
									move = true,
									car = true,
									combat = true,
								},
								anim = {
									clip = 'WORLD_HUMAN_CONST_DRILL',
								},
							})

							Wait(10000)
		
							ESX.Game.DeleteObject(nearbyObject)
		
							table.remove(batuPlants, nearbyID)
							spawnedBatu = spawnedBatu - 1
		
							TriggerServerEvent('lp-farmer:pickedUpBatu')
						else
							lib.notify({
								title = 'Penuh',
								description = 'Melebihi Batas',
								type = 'error'
							})
						end

						isPickingUp = false

					end, 'stone')
				end
			end

		else
			Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(batuPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnBatuPlants()
	while spawnedBatu < 10 do
		Wait(0)
		local batuCoords = GenerateBatuCoords()

		ESX.Game.SpawnLocalObject('prop_rock_1_g', batuCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(batuPlants, obj)
			spawnedBatu = spawnedBatu + 1
		end)
	end
end

function ValidateBatuCoord(plantCoord)
	if spawnedBatu > 0 then
		local validate = true

		for k, v in pairs(batuPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.BatuField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateBatuCoords()
	while true do
		Wait(1)

		local batuCoordX, batuCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-25, 25)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-25, 25)

		batuCoordX = Config.CircleZones.BatuField.coords.x + modX
		batuCoordY = Config.CircleZones.BatuField.coords.y + modY

		local coordZ = GetCoordZ(batuCoordX, batuCoordY)
		local coord = vector3(batuCoordX, batuCoordY, coordZ)

		if ValidateBatuCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0}

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end