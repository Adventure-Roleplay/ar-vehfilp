local QBCore = exports['qb-core']:GetCoreObject()
function PreventRollingVehicle(vehicle)
	local vehiclee = GetVehiclePedIsIn(PlayerPedId())
	local rotation = GetEntityRotation(vehicle)

	if (rotation.x > 75.0 or rotation.x < -75.0 or rotation.y > 75.0 or rotation.y < -75.0) then
		SetVehicleEngineHealth(vehiclee, -4000.0)
		DisableControlAction(0, 59)
		DisableControlAction(0, 60)
		DisableControlAction(0, 61)
		DisableControlAction(0, 62)
	end
end

local isVehicleFlipped = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local roll = GetEntityRoll(vehicle)
            PreventRollingVehicle(vehicle)
            if (roll > 75.0 or roll < -75.0) and not isVehicleFlipped then
                isVehicleFlipped = true
		SetVehicleUndriveable(vehicle, true)
		SetVehicleEngineHealth(vehicle, -4000)
		QBCore.Functions.Notify('Your Car has Been Flipped! Wait in the Car for Help!', 'info', 7500) -- Change to your Notify!
                SetVehicleEngineOn(vehicle, false, true, true) -- Disables the Engine FULLY
            elseif (roll <= 75.0 and roll >= -75.0) and isVehicleFlipped then
                SetVehicleEngineOn(vehicle, true, true, true) -- F Disables the Engine FULLY
		SetVehicleUndriveable(vehicle, true)
		SetVehicleEngineHealth(vehicle, -4000)
                isVehicleFlipped = true
            end
        else
            isVehicleFlipped = false
        end
    end
end)
