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

local spawnedGaram = 0
local garamPlants = {}
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

local CurrentCheckPointGaram = 0
local LastCheckPointGaram   = -1

local CheckPointsGaram = {
    {
        Pos = {x = 457.81, y = 6700.09, z = 7.42},
    },
    {
        Pos = {x = 428.66, y = 6717.38, z = 6.15},
    },
    {
        Pos = {x = 460.85, y = 6707.88, z = 6.43},
    },
    {
        Pos = {x = 442.20, y = 6734.12, z = 4.55},
    },
    {
        Pos = {x = 463.51, y = 6730.31, z = 3.2},
    },
}

local onDutyGaram = 0
local blipgaram = nil
local countcabutgaram = 0


CreateThread(function()
	while true do
		Wait(0)
		local letSleep = true
        local coords = GetEntityCoords(PlayerPedId())
		local ambil = '[E] Mengambil Traktor (Garam)'
		local showUI2
        
        if onDutyGaram == 2 then
		    if GetDistanceBetweenCoords(coords, Config.CircleZones.GaramField.coords, true) < 50 then
                if ESX.PlayerData.job == 'petani' then
                    letSleep = false
				    SpawnTanamanGaram()
                end
            end
        end

        if GetDistanceBetweenCoords(coords, 421.65, 6468.73, 28.35, true) < 3 then

            if ESX.PlayerData.job == 'petani' and showUI2 ~= 0 then
                letSleep = false
                DrawMarker(39, 421.65, 6468.73, 28.35, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				lib.showTextUI(ambil)
				showUI2 = 0
                if IsControlJustReleased(0, 38) and onDutyGaram == 0 then 
                    lib.callback('esx_skin:getPlayerSkin', false, function(skin, jobSkin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                        end
                    end)
                    Wait(500)
                    ESX.Game.SpawnVehicle('tractor',{ x = 421.65, y = 6468.73, z = 28.35}, 319.73, function(callback_vehicle)
						onDutyGaram = 1
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
		for k, v in pairs(garamPlants) do
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
		local nextCheckPoint = CurrentCheckPointGaram + 1

		if onDutyGaram == 1 then 
			if CheckPointsGaram[nextCheckPoint] == nil then
				if DoesBlipExist(blipgaram) then
					RemoveBlip(blipgaram)
				end

				vehicle = GetVehiclePedIsIn(playerPed, false)
				ESX.Game.DeleteVehicle(vehicle)
				onDutyGaram = 2
			else
				if CurrentCheckPointGaram ~= LastCheckPointGaram then
					if DoesBlipExist(blipgaram) then
						RemoveBlip(blipgaram)
					end

					blipgaram = AddBlipForCoord(CheckPointsGaram[nextCheckPoint].Pos.x, CheckPointsGaram[nextCheckPoint].Pos.y, CheckPointsGaram[nextCheckPoint].Pos.z)
					SetBlipRoute(blipgaram, 1)

					LastCheckPointGaram = CurrentCheckPointGaram
				end

				local distance = GetDistanceBetweenCoords(coords, CheckPointsGaram[nextCheckPoint].Pos.x, CheckPointsGaram[nextCheckPoint].Pos.y, CheckPointsGaram[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(20, CheckPointsGaram[nextCheckPoint].Pos.x, CheckPointsGaram[nextCheckPoint].Pos.y, CheckPointsGaram[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3 then
					vehicle = GetVehiclePedIsIn(playerPed, false)
					if GetHashKey('tractor') == GetEntityModel(vehicle) then
						CurrentCheckPointGaram = CurrentCheckPointGaram + 1
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

		for i=1, #garamPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(garamPlants[i]), false) < 1 then
				nearbyObject, nearbyID = garamPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showUI ~= 0 then
				lib.showTextUI(lockDoor)
				showUI = 0
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
                if countcabutgaram >= 80 then 
                    onDutyGaram = 0
					countcabutgaram = 0
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
									clip = 'world_human_gardener_plant',
								},
							})

							Wait(2500)
		
							ESX.Game.DeleteObject(nearbyObject)
		
							table.remove(garamPlants, nearbyID)
                            spawnedGaram = spawnedGaram - 1
                            countcabutgaram = countcabutgaram + 1
		
							TriggerServerEvent('lp-farmer:pickedUpGaram')
						else
							lib.notify({
								title = 'Penuh',
								description = 'Melebihi Batas',
								type = 'error'
							})
						end

						isPickingUp = false

					end, 'garam')
				end
			end

		elseif showUI then
			lib.hideTextUI()
			showUI = nil
		end
		
		Wait(500)
	end

end)

function SpawnTanamanGaram()
	while spawnedGaram < 30 do
		Wait(0)
		local garamCoords = GenerateGaramCoords()

		ESX.Game.SpawnLocalObject('bkr_prop_coke_powder_01', garamCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(garamPlants, obj)
			spawnedGaram = spawnedGaram + 1
		end)
	end
end

function ValidateGaramCoord(plantCoord)
	if spawnedGaram > 0 then
		local validate = true

		for k, v in pairs(garamPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.GaramField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateGaramCoords()
	while true do
		Wait(1)

		local garamCoordX, garamCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-15, 15)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-15, 15)

		garamCoordX = Config.CircleZones.GaramField.coords.x + modX
		garamCoordY = Config.CircleZones.GaramField.coords.y + modY

		local coordZ = GetCoordZ(garamCoordX, garamCoordY)
		local coord = vector3(garamCoordX, garamCoordY, coordZ)

		if ValidateGaramCoord(coord) then
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