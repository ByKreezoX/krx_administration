ESX = nil
local inAnim = false

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			Text("~r~X~s~: " .. playerPos.x .. " ~b~Y~s~: " .. playerPos.y .. " ~g~Z~s~: " .. playerPos.z .. " ~y~Angle~s~: " .. playerHeading)
		end
		
		Citizen.Wait(0)
	end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function give_bank()
	local amount = KeyboardInput("KREEZOX_BOX_AMOUNT", 'Somme', "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KrX-Personalmenu:Admin_giveBank', amount)
		end
	end
end

function admin_no_clip()
	noclip = not noclip

	if noclip then
		SetEntityInvincible(plyPed, true)
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification("NoClip", "Administration", "NoClip ~g~Activé")
	else
		SetEntityInvincible(plyPed, false)
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification("NoClip", "Administration", "NoClip ~r~Désactivé")
	end
end

function admin_tp_playertome()
	local plyId = KeyboardInput("KREEZOX_BOX_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('KrX-Personalmenu:Admin_BringS', plyId, plyPedCoords)
		end
	end
end

function admin_tp_toplayer()
	local plyId = KeyboardInput("KREEZOX_BOX_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end
-- F

function admin_no_clip()
	return noclip
end

function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification("Mode Fantôme ~g~Activé")
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification("Mode Fantôme ~r~Désactivé")
	end
end

function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end

function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification("GodMode ~g~Activé")
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification("GodMode ~r~Désactivé")
	end
end

function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("KREEZOX_BOX_VEHICLE_NAME", 'Nom du véhicule', "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(0)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
			end)
		end
	end
end

function admin_give_dirty()
	local amount = KeyboardInput("KREEZOX_BOX_AMOUNT", 'Quantité', "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KrX-Personalmenu:Admin_giveDirtyMoney', amount)
		end
	end
end

function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(0)
		end

		ESX.ShowNotification("Téléportation ~g~Effectuée")
	else
		ESX.ShowNotification("Aucun ~r~Marqueur")
	end
end

function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function changer_skin()
	Citizen.Wait(100)
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function show_coord()
	showcoord = not showcoord
end

function admin_heal_player()
	local plyId = KeyboardInput("KREEZOX_BOX_ID", 'ID du joueur', "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esxambulancejob:revive', plyId)
		end
	end
end

RegisterNetEvent('KrX-Personalmenu:Admin_BringC')
AddEventHandler('KrX-Personalmenu:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

function modo_showname()
	showname = not showname
end

local Admin = {

    Base = {Title = "Administration"},
    Data = {currentMenu = "Menu Interaction"},
    Events = {

        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentSlt, result)
        	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            if btn.name == "TP un joueur sur moi" then
                admin_tp_playertome()
            elseif btn.name == "Se TP sur un joueur" then
                admin_tp_toplayer()
            elseif btn.name == "S'octroyer de l'argent (banque)" then
                give_bank()
            elseif btn.name == "Modifier mon apparence" then
                changer_skin()
                self:CloseMenu(true)
            elseif btn.name == "Afficher les coordonnées" then
                show_coord()
            elseif btn.name == "Revive un joueur" then
                admin_heal_player()
            elseif btn.name == "Sauvegarder mon apparence" then
            elseif btn.name == "Se TP sur le marker" then
                admin_tp_marker()
            elseif btn.name == "Se give de l'argent sale" then
                admin_give_dirty()
            elseif btn.name == "Mode invisible" then 
                admin_mode_fantome()
            elseif btn.name == "Mode invincible" then
                admin_godmode()
            elseif btn.name == "Réparer mon véhicule" then
                admin_vehicle_repair()
            elseif btn.name == "Faire spawn un véhicule" then
                admin_vehicle_spawn()
            end
        end,
    },

    Menu = {
        ["Menu Interaction"] = {
            b = {
                {name = "TP un joueur sur moi", ask = "→", askX = true},
                {name = "Se TP sur un joueur", ask = "→", askX = true},
                {name = "Mode invisible", ask = "→", askX = true},
                {name = "Mode invincible", ask = "→", askX = true},
                {name = "Faire spawn un véhicule", ask = "→", askX = true},
                {name = "Réparer mon véhicule", ask = "→", askX = true},
                {name = "S'octroyer de l'argent (banque)", ask = "→", askX = true},
                {name = "Se give de l'argent sale", ask = "→", askX = true},
                {name = "Se TP sur le marker", ask = "→", askX = true},
                {name = "Revive un joueur", ask = "→", askX = true},
                {name = "Afficher les coordonnées", ask = "→", askX = true},
                {name = "Modifier mon apparence", ask = "→", askX = true},
                {name = "Sauvegarder mon apparence", ask = "→", askX = true},
            }
        },
    }
}

RegisterCommand("staff", function()
    CreateMenu(Admin)
end)
