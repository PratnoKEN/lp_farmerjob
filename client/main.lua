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

RegisterNetEvent('lp-farmer:weaclip')
AddEventHandler('lp-farmer:weaclip', function()
	local playerPed = PlayerPedId()
    local hash      = GetSelectedPedWeapon(playerPed)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
        if IsPedArmed(playerPed, 4) then
            lib.progressCircle({
                duration = 5000,
                useWhileDead = true,
                canCancel = false,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                },
                anim = {
                    dict = 'mp_arresting',
                    clip = 'a_uncuff',
                    flags = 49,
                },
            })
           Wait(5000)
            AddAmmoToPed(playerPed, hash, 99999)
            TriggerServerEvent('lp-farmer:removeweaclip')
        else
            lib.notify({
                title = '',
                description = 'Kamu harus memegang senjata',
                type = 'error'
            })
        end
end)

-- Start of Bullet Proof Vest
RegisterNetEvent('lp-farmer:bulletproof')
AddEventHandler('lp-farmer:bulletproof', function()
	local playerPed = PlayerPedId()
    lib.progressCircle({
        duration = 5000,
        useWhileDead = true,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'rcmfanatic3',
            clip = 'kneel_idle_a',
        },
        prop = {
            model = `prop_bodyarmour_02`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5) 
        },
    })
	Wait(5000)
	SetPedComponentVariation(playerPed, 9, 10, 0, 0)
	AddArmourToPed(playerPed, 100)
	SetPedArmour(playerPed, 100)
end)
-- End of Bullet Proof Vest

-- Crafting

local CurrentCraft = nil
-- Location Loop
CreateThread(function()
    local lockDoor = '[E] Mengolah Bahan'
	local showUI

    while true do
       Wait(7)
        if ESX ~= nil and Crafting.Locations ~= nil then
            local pos = GetEntityCoords(PlayerPedId(), true)
            for i=1, #Crafting.Locations, 1 do
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Crafting.Locations[i].x, Crafting.Locations[i].y, Crafting.Locations[i].z, true) < 2.5 then
                    if ESX.PlayerData.job == 'petani' and showUI ~= 0 then
                        lib.showTextUI(lockDoor)
				        showUI = 0
                        if IsControlJustReleased(0, Keys["E"]) then
                            OpenCraftMenu()
                        end
                    end
                end
            end
        elseif showUI then
			lib.hideTextUI()
			showUI = nil
		end
    end
end)

-- NUI that get triggered on success
RegisterNUICallback('CraftingSuccess', function()
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(),false)
    TriggerServerEvent("petani_crafting:CraftingSuccess", CurrentCraft)
end)

function OpenCraftMenu()
    local elements = {}
    for item, v in pairs(Crafting.Items) do
        local elementlabel = v.label .. ": "
        local somecount = 1
        for k, need in pairs(v.needs) do
            if somecount == 1 then
                somecount = somecount + 1
                elementlabel = elementlabel .. need.label .. " ("..need.count..")"
            else
                elementlabel = elementlabel .. " - "..need.label .. " ("..need.count..")"
            end
        end
        table.insert(elements, {value = item, label = elementlabel})
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_actions', {
        title    = "Pengolahan Bahan Pangan",
        elements = elements,
        align    = 'center',
    }, function(data, menu)
        menu.close()
        CurrentCraft = data.current.value
        lib.callback('petani_crafting:HasTheItems', false, function(result)
            if result then
                lib.progressCircle({
                    duration = 15000,
                    useWhileDead = true,
                    canCancel = false,
                    disable = {
                        move = true,
                        car = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                        clip = 'machinic_loop_mechandplayer',
                        flags = 49,
                    },
                })
               Wait(15000)
                TriggerServerEvent("petani_crafting:CraftingSuccess", CurrentCraft)
            else
                lib.notify({
                    title = '',
                    description = 'Kamu tidak memiliki cukup bahan',
                    type = 'error'
                })
            end
        end, CurrentCraft)

    end, function(data, menu)
        menu.close()
    end)
end

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	--DrawText(_x,_y)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	--DrawRect(_x,_y+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 68)
	ClearDrawOrigin()
end