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

local spawnedCabe = 0
local cabePlants = {}
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

local CurrentCheckPoint = 0
local LastCheckPoint    = -1

local CheckPoints = {
    {
        Pos = {x = 281.47, y = 6480.55, z = 29.50},
    },
    {
        Pos = {x = 215.21, y = 6474.93, z = 31.30},
    },
    {
        Pos = {x = 280.63, y = 6472.02, z = 31.30},
    },
    {
        Pos = {x = 236.72, y = 6458.71, z = 31.30},
    },
    {
        Pos = {x = 287.61, y = 6448.83, z = 31.30},
    },
}

local onDutyCabe = 0
local blipcabe = nil
local countcabutcabe = 0


CreateThread(function()
	while true do
		Wait(0)
		local letSleep = true
        local coords = GetEntityCoords(PlayerPedId())
		local ambil = '[E] Mengambil Traktor (Cabe)'
		local showUI2
		
        for k, v in pairs(Config.CircleZones)
			for i=1, #v.CabeField, 1 do
				local distCabeShop = #(coords - v.CabeField[i])
				
				if onDutyCabe == 2 then
					
					if distCabeShop < 50 then
						if ESX.PlayerData.job == 'petani' then
							letSleep = false
							SpawnTanamanCabe()
						end
					end
				end
			end

            if IsControlJustReleased(0, 38) and onDutyCabe == 0 and ESX.PlayerData.job == 'petani' and showUI2 ~= 0 then
				local distCabefield = #(coords - v.cabe[i])

				if distCabeShop < 3 then
					letSleep = false
					DrawMarker(39, Config.Field.cabe, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
					lib.showTextUI(ambil)
					showUI2 = 0
						lib.callback('esx_skin:getPlayerSkin', false, function(skin, jobSkin)
							if skin.sex == 0 then
								TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
							elseif skin.sex == 1 then
								TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
							end
						end)
						Wait(500)
						ESX.Game.SpawnVehicle('tractor',{ x = 426.31, y = 6463.42, z = 28.78}, 319.98, function(callback_vehicle)
							onDutyCabe = 1
							TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
						end)
					end
				elseif showUI2 then
					lib.hideTextUI()
					showUI = nil
				end
            end
		end
		if letSleep then 
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(cabePlants) do
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
		local nextCheckPoint = CurrentCheckPoint + 1

		if onDutyCabe == 1 then 
			if CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(blipcabe) then
					RemoveBlip(blipcabe)
				end

				vehicle = cache.vehicle
				ESX.Game.DeleteVehicle(vehicle)
				onDutyCabe = 2
			else
				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(blipcabe) then
						RemoveBlip(blipcabe)
					end

					blipcabe = AddBlipForCoord(CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(blipcabe, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(20, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3 then
					vehicle = cache.vehicle
					if GetHashKey('tractor') == GetEntityModel(vehicle) then
						CurrentCheckPoint = CurrentCheckPoint + 1
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

		for i=1, #cabePlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(cabePlants[i]), false) < 1 then
				nearbyObject, nearbyID = cabePlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp and showUI ~= 0 then
				lib.showTextUI(lockDoor)
				showUI = 0
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
                if countcabutcabe >= 80 then 
                    onDutyCabe = 0
					countcabutcabe = 0
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
		
							table.remove(cabePlants, nearbyID)
                            spawnedCabe = spawnedCabe - 1
                            countcabutcabe = countcabutcabe + 1
		
							TriggerServerEvent('lp-farmer:pickedUpCabe')
						else
							lib.notify({
								title = 'Penuh',
								description = 'Melebihi Batas',
								type = 'error'
							})
						end

						isPickingUp = false

					end, 'cabe')
				end
			end

		elseif showUI then
			lib.hideTextUI()
			showUI = nil
		end
		
		Wait(500)

	end

end)

function SpawnTanamanCabe()
	while spawnedCabe < 20 do
		Wait(0)
		local cabeCoords = GenerateCabeCoords()

		ESX.Game.SpawnLocalObject('prop_veg_crop_02', cabeCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(cabePlants, obj)
			spawnedCabe = spawnedCabe + 1
		end)
	end
end

function ValidateCabeCoord(plantCoord)
	if spawnedCabe > 0 then
		local validate = true

		for k, v in pairs(cabePlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CabeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCabeCoords()
	while true do
		Wait(1)

		local cabeCoordX, cabeCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-30, 30)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		cabeCoordX = Config.CircleZones.CabeField.coords.x + modX
		cabeCoordY = Config.CircleZones.CabeField.coords.y + modY

		local coordZ = GetCoordZ(cabeCoordX, cabeCoordY)
		local coord = vector3(cabeCoordX, cabeCoordY, coordZ)

		if ValidateCabeCoord(coord) then
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