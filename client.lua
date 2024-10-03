local leftBlinker = false
local rightBlinker = false
local hazardLights = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
                -- Blinkersteuerung
                if Config.EnableBlinker then
                    if IsControlJustReleased(0, Config.BlinkerRight) then
                        rightBlinker = not rightBlinker
                        leftBlinker = false
                        hazardLights = false
                        SetVehicleIndicatorLights(vehicle, 0, rightBlinker) -- Setze die rechten Blinkerlichter (0 für rechts, 1 für links)
                        SetVehicleIndicatorLights(vehicle, 1, leftBlinker)  -- Setze die linken Blinkerlichter (1 für links, 0 für rechts)
                    elseif IsControlJustReleased(0, Config.BlinkerLeft) then
                        leftBlinker = not leftBlinker
                        rightBlinker = false
                        hazardLights = false
                        SetVehicleIndicatorLights(vehicle, 1, leftBlinker)  -- Setze die linken Blinkerlichter (1 für links, 0 für rechts)
                        SetVehicleIndicatorLights(vehicle, 0, rightBlinker) -- Setze die rechten Blinkerlichter (0 für rechts, 1 für links)
                    elseif IsControlJustReleased(0, Config.HazardLights) then
                        hazardLights = not hazardLights
                        leftBlinker = false
                        rightBlinker = false
                        SetVehicleIndicatorLights(vehicle, 0, hazardLights)  -- Setze die rechten Blinkerlichter (0 für rechts, 1 für links)
                        SetVehicleIndicatorLights(vehicle, 1, hazardLights)  -- Setze die linken Blinkerlichter (1 für links, 0 für rechts)
                    end
                end

                -- Fenstersteuerung, nur vom Fahrer
                if Config.EnableFensterSteuerung and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    if IsControlJustReleased(0, Config.FensterVorneLinksToggle) then
                        local windowState = IsVehicleWindowIntact(vehicle, 0)
                        if windowState then RollDownWindow(vehicle, 0) else RollUpWindow(vehicle, 0) end
                    elseif IsControlJustReleased(0, Config.FensterVorneRechtsToggle) then
                        local windowState = IsVehicleWindowIntact(vehicle, 1)
                        if windowState then RollDownWindow(vehicle, 1) else RollUpWindow(vehicle, 1) end
                    end
                end

                -- Motorsteuerung
                if Config.EnableMotorSteuerung and IsControlJustReleased(0, Config.MotorToggle) then
                    local engineStatus = not GetIsVehicleEngineRunning(vehicle)
                    SetVehicleEngineOn(vehicle, engineStatus, false, true)
                end
            end
        end
    end
end)
