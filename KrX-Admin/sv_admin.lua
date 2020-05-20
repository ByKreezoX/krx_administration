ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("KrX-Personalmenu:Admin_BringS")
AddEventHandler("KrX-Personalmenu:Admin_BringS", function(plyId, plyPedCoords)
	TriggerClientEvent('KrX-Personalmenu:Admin_BringC', plyId, plyPedCoords)
end)

RegisterServerEvent("KrX-Personalmenu:Admin_giveBank")
AddEventHandler("KrX-Personalmenu:Admin_giveBank", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('bank', total)

	local item = '$ ~s~en banque'
	local message = 'Give de ~g~'
	TriggerClientEvent('esx:showNotification', _source, message .. total .. item)
	TriggerEvent("esx:admingivemoneyalert",xPlayer.name,total)
end)

RegisterServerEvent("KrX-Personalmenu:Admin_giveDirtyMoney")
AddEventHandler("KrX-Personalmenu:Admin_giveDirtyMoney", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	
	xPlayer.addAccountMoney('black_money', total)

	local item = '$ ~s~sale.'
	local message = 'Give de ~r~'
	TriggerClientEvent('esx:showNotification', _source, message..total..item)
	TriggerEvent("esx:admingivemoneyalert",xPlayer.name,total)
end)