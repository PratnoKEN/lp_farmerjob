local ox_inventory = exports.ox_inventory

RegisterServerEvent('lp-farmer:pickedUpCannabis')
AddEventHandler('lp-farmer:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'wood') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpBatu')
AddEventHandler('lp-farmer:pickedUpBatu', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'stone') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpCabe')
AddEventHandler('lp-farmer:pickedUpCabe', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'cabe') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpCoklat')
AddEventHandler('lp-farmer:pickedUpCoklat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'coklat') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpGaram')
AddEventHandler('lp-farmer:pickedUpGaram', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'garam') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpKopi')
AddEventHandler('lp-farmer:pickedUpKopi', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'kopi') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpPadi')
AddEventHandler('lp-farmer:pickedUpPadi', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'padi') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpTebu')
AddEventHandler('lp-farmer:pickedUpTebu', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'tebu') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

RegisterServerEvent('lp-farmer:pickedUpTeh')
AddEventHandler('lp-farmer:pickedUpTeh', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = ox_inventory:GetItem(source, 'teh') 
	local cime = math.round(5,10)

	if ox_inventory:CanCarryItem(source, xItem.name, cime) then
		ox_inventory:AddItem(source, xItem.name, cime)
	else
		TriggerClientEvent('ox_lib:notify', _source, {
			type = 'error',
			description = _U('weed_inventoryfull')
		})
	end
end)

lib.callback.register('lp-farmer:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canCarryItem(item, 1))
end)

ESX.RegisterUsableItem('clip', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('lp-farmer:weaclip', source)
end)

RegisterNetEvent('lp-farmer:removeweaclip', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		
	exports.ox_inventory:RemoveItem(_source, 'clip', 1)
	
end)

-- Bullet-Proof Vest
ESX.RegisterUsableItem('bulletproof', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('lp-farmer:bulletproof', source)

	exports.ox_inventory:RemoveItem(source, 'bulletproof', 1)
	TriggerClientEvent('ox_lib:notify', _source, {
		type = 'success',
		description = _U('using_armor')
	})
end)

-- Crafting
RegisterServerEvent('petani_crafting:CraftingSuccess', function(CraftItem)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = Crafting.Items[CraftItem]
    for itemname, v in pairs(item.needs) do
		exports.ox_inventory:RemoveItem(source, itemname, v.count)
		
    end
    if CraftItem == "weapon_pistol" or CraftItem == "weapon_combatpistol" then
        xPlayer.addWeapon(CraftItem, 0)
    else
		if ox_inventory:CanCarryItem(source, CraftItem, 1) then
            ox_inventory:AddItem(source, CraftItem, 1)
        end
    end
    
	TriggerClientEvent('ox_lib:notify', src, {
		type = 'success',
		description = _U('craft_berhasil')..item.label
	})
end)

-- Check if you have the items
lib.callback.register('petani_crafting:HasTheItems', function(source, cb, CraftItem)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = Crafting.Items[CraftItem]
    for itemname, v in pairs(item.needs) do
        if ox_inventory:GetItem(source, itemname).count < v.count then
            cb(false)
        end
    end
    cb(true)
end)