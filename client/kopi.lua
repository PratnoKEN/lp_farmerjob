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

local spawnedKopi = 0
local kopiPlants = {}
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

local CurrentCheckPointKopi = 0
local LastCheckPointKopi   = -1

local CheckPointsKopi = {
    {
        Pos = {x = -1670.65, y = 2306.04, z = 58.62},
    },
    {
        Pos = {x = -1592.19, y = 2182.33, z = 76.14},
    },
    {
        Pos = {x = -1628.52, y = 2256.31, z = 77.94},
    },
}

local onDutyKopi = 0
local blipkopi = nil
local countcabutkopi = 0


CreateThread(function()
	while true do
		Wait(0)
		local letSleep = true
        local coords = GetEntityCoords(PlayerPedId())
		local ambil = '[E] Mengambil Traktor (Kopi)'
		local showUI2
        
        if onDutyKopi == 2 then
		    if GetDistanceBetweenCoords(coords, Config.CircleZones.KopiField.coords, true) < 50 then
                if ESX.PlayerData.job == 'petani' then
                    letSleep = false
				    SpawnTanamanKopi()
                end
            end
        end

        if GetDistanceBetweenCoords(coords, -1140.39, 2671.08, 18.22, true) < 3 then

            if ESX.PlayerData.job == 'petani' and showUI2 ~= 0 then
                letSleep = false
                DrawMarker(39, -1140.39, 2671.08, 18.22, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
                lib.showTextUI(ambil)
				showUI2 = 0
                if IsControlJustReleased(0, 38) and onDutyKopi == 0 then 
                    lib.callback('esx_skin:getPlayerSkin', false, function(skin, jobSkin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                        end
                    end)
                    Wait(500)
                    ESX.Game.SpawnVehicle('tractor2',{ x = -1140.39, y = 2671.08, z = 18.22}, 221.13, function(callback_vehicle)
						onDutyKopi = 1
						TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
					end)
                end
            elseif showUI2 then
				lib.hideTextUI()
				showUI = nil
			end
        end
		if letSleep then 
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(kopiPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

CreateThread(function()
	while true do
        Wait(0)
        local letSleep = true
		local playerPed      = cache.ped
		local coords         = GetEntityCoords(playerPed)
		local nextCheckPoint = CurrentCheckPointKopi + 1

		if onDutyKopi == 1 then 
			if CheckPointsKopi[nextCheckPoint] == nil then
				if DoesBlipExist(blipkopi) then
					RemoveBlip(blipkopi)
				end

				vehicle = GetVehiclePedIsIn(playerPed, false)
				ESX.Game.DeleteVehicle(vehicle)
				onDutyKopi = 2
			else
				if CurrentCheckPointKopi ~= LastCheckPointKopi then
					if DoesBlipExist(blipkopi) then
						RemoveBlip(blipkopi)
					end

					blipkopi = AddBlipForCoord(CheckPointsKopi[nextCheckPoint].Pos.x, CheckPointsKopi[nextCheckPoint].Pos.y, CheckPointsKopi[nextCheckPoint].Pos.z)
					SetBlipRoute(blipkopi, 1)

					LastCheckPointKopi = CurrentCheckPointKopi
				end

				local distance = GetDistanceBetweenCoords(coords, CheckPointsKopi[nextCheckPoint].Pos.x, CheckPointsKopi[nextCheckPoint].Pos.y, CheckPointsKopi[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(20, CheckPointsKopi[nextCheckPoint].Pos.x, CheckPointsKopi[nextCheckPoint].Pos.y, CheckPointsKopi[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3 then
					vehicle = GetVehiclePedIsIn(playerPed, false)
					if GetHashKey('tractor2') == GetEntityModel(vehicle) then
						CurrentCheckPointKopi = CurrentCheckPointKopi + 1
					end
				end
			end
			
		end
	end
end)

CreateThread(function()
	while true do
        Wait(0)
        local letSleep = true
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		local lockDoor = '[E] Mengambil'
		local showUI

		for i=1, #kopiPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(kopiPlants[i]), false) < 1 then
				nearbyObject, nearbyID = kopiPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showUI ~= 0 then
				lib.showTextUI(lockDoor)
				showUI = 0
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
                if countcabutkopi >= 80 then 
                    onDutyKopi = 0
					countcabutkopi = 0
				else
					isPickingUp = true

					lib.callback('lp-farmer:canPickUp', false, function(canPickUp)

						if canPickUp then
							lib.progressCircle({
								duration = 2500,
								useWhileDead = true,
								canCancel = false,
								disable = {
									move = true,
									car = true,
									combat = true,
								},
								anim = {
									dict = 'creatures@rottweiler@tricks@',
									clip = 'petting_franklin',
									flags = 49,
								},
							})

							Wait(2500)
		
							ESX.Game.DeleteObject(nearbyObject)
		
							table.remove(kopiPlants, nearbyID)
                            spawnedKopi = spawnedKopi - 1
                            countcabutkopi = countcabutkopi + 1
		
							TriggerServerEvent('lp-farmer:pickedUpKopi')
						else
							lib.notify({
								title = 'Penuh',
								description = 'Melebihi Batas',
								type = 'error'
							})
						end

						isPickingUp = false

					end, 'kopi')
				end
			end

		elseif showUI then
			lib.hideTextUI()
			showUI = nil
		end
		
		Wait(500)

	end

end)

function SpawnTanamanKopi()
	while spawnedKopi < 30 do
		Wait(0)
		local kopiCoords = GenerateKopiCoords()

		ESX.Game.SpawnLocalObject('prop_veg_crop_04_leaf', kopiCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(kopiPlants, obj)
			spawnedKopi = spawnedKopi + 1
		end)
	end
end

function ValidateKopiCoord(plantCoord)
	if spawnedKopi > 0 then
		local validate = true

		for k, v in pairs(kopiPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.KopiField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateKopiCoords()
	while true do
		Wait(1)

		local kopiCoordX, kopiCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-15, 15)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-15, 15)

		kopiCoordX = Config.CircleZones.KopiField.coords.x + modX
		kopiCoordY = Config.CircleZones.KopiField.coords.y + modY

		local coordZ = GetCoordZ(kopiCoordX, kopiCoordY)
		local coord = vector3(kopiCoordX, kopiCoordY, coordZ)

		if ValidateKopiCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 75.0, 76.0, 77.0, 78.0, 79.0, 80.0, 81.0, 82.0, 83.0, 84.0, 85.0}

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 76.00
end