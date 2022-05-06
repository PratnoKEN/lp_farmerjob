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

local spawnedPadi = 0
local padiPlants = {}
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

local CurrentCheckPointPadi = 0
local LastCheckPointPadi   = -1

local CheckPointsPadi = {
    {
        Pos = {x = 615.79, y = 6458.89, z = 29.53},
    },
    {
        Pos = {x = 663.53, y = 6458.77, z = 31.05},
    },
    {
        Pos = {x = 620.14, y = 6468.25, z = 29.49},
    },
    {
        Pos = {x = 663.89, y = 6480.31, z = 29.85},
    },
    {
        Pos = {x = 613.65, y = 6494.16, z = 29.18},
    },
}

local onDutyPadi = 0
local blippadi = nil
local countcabutpadi = 0


CreateThread(function()
	while true do
		Wait(0)
		local letSleep = true
        local coords = GetEntityCoords(PlayerPedId())
		local ambil = '[E] Mengambil Traktor (Padi)'
		local showUI2
        
        if onDutyPadi == 2 then
		    if GetDistanceBetweenCoords(coords, Config.CircleZones.PadiField.coords, true) < 50 then
                if ESX.PlayerData.job == 'petani' then
                    letSleep = false
				    SpawnTanamanPadi()
                end
            end
        end

        if GetDistanceBetweenCoords(coords, 428.14, 6476.53, 28.32, true) < 3 then

            if ESX.PlayerData.job == 'petani' and showUI2 ~= 0 then
                letSleep = false
                DrawMarker(39, 428.14, 6476.53, 28.32, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
                lib.showTextUI(ambil)
				showUI2 = 0
                if IsControlJustReleased(0, 38) and onDutyPadi == 0 then 
                    lib.callback('esx_skin:getPlayerSkin', false, function(skin, jobSkin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                        end
                    end)
                    Wait(500)
                    ESX.Game.SpawnVehicle('tractor',{ x = 428.14, y = 6476.53, z = 28.32}, 138.74, function(callback_vehicle)
						onDutyPadi = 1
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
		for k, v in pairs(padiPlants) do
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
		local nextCheckPoint = CurrentCheckPointPadi + 1

		if onDutyPadi == 1 then 
			if CheckPointsPadi[nextCheckPoint] == nil then
				if DoesBlipExist(blippadi) then
					RemoveBlip(blippadi)
				end

				vehicle = GetVehiclePedIsIn(playerPed, false)
				ESX.Game.DeleteVehicle(vehicle)
				onDutyPadi = 2
			else
				if CurrentCheckPointPadi ~= LastCheckPointPadi then
					if DoesBlipExist(blippadi) then
						RemoveBlip(blippadi)
					end

					blippadi = AddBlipForCoord(CheckPointsPadi[nextCheckPoint].Pos.x, CheckPointsPadi[nextCheckPoint].Pos.y, CheckPointsPadi[nextCheckPoint].Pos.z)
					SetBlipRoute(blippadi, 1)

					LastCheckPointPadi = CurrentCheckPointPadi
				end

				local distance = GetDistanceBetweenCoords(coords, CheckPointsPadi[nextCheckPoint].Pos.x, CheckPointsPadi[nextCheckPoint].Pos.y, CheckPointsPadi[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(20, CheckPointsPadi[nextCheckPoint].Pos.x, CheckPointsPadi[nextCheckPoint].Pos.y, CheckPointsPadi[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3 then
					vehicle = GetVehiclePedIsIn(playerPed, false)
					if GetHashKey('tractor') == GetEntityModel(vehicle) then
						CurrentCheckPointPadi = CurrentCheckPointPadi + 1
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

		for i=1, #padiPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(padiPlants[i]), false) < 1 then
				nearbyObject, nearbyID = padiPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showUI ~= 0 then
				lib.showTextUI(lockDoor)
				showUI = 0
			endingUp  then
				lib.showTextUI(lockDoor)
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
                if countcabutpadi >= 80 then 
                    onDutyPadi = 0
					countcabutpadi = 0
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
		
							table.remove(padiPlants, nearbyID)
                            spawnedPadi = spawnedPadi - 1
                            countcabutpadi = countcabutpadi + 1
		
							TriggerServerEvent('lp-farmer:pickedUpPadi')
						else
							lib.notify({
								title = 'Penuh',
								description = 'Melebihi Batas',
								type = 'error'
							})
						end

						isPickingUp = false

					end, 'padi')
				end
			end

		else
			Wait(500)
		end

	end

end)

function SpawnTanamanPadi()
	while spawnedPadi < 20 do
		Wait(0)
		local padiCoords = GeneratePadiCoords()

		ESX.Game.SpawnLocalObject('prop_veg_crop_05', padiCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(padiPlants, obj)
			spawnedPadi = spawnedPadi + 1
		end)
	end
end

function ValidatePadiCoord(plantCoord)
	if spawnedPadi > 0 then
		local validate = true

		for k, v in pairs(padiPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.PadiField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratePadiCoords()
	while true do
		Wait(1)

		local padiCoordX, padiCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-30, 30)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		padiCoordX = Config.CircleZones.PadiField.coords.x + modX
		padiCoordY = Config.CircleZones.PadiField.coords.y + modY

		local coordZ = GetCoordZ(padiCoordX, padiCoordY)
		local coord = vector3(padiCoordX, padiCoordY, coordZ)

		if ValidatePadiCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 30.0, 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end