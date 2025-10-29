local reviveWait = 5
local timer = reviveWait
local isPlayerDead = false
local notificationShown = false
local reviveKeyAllowed = true

-- Helper notification function (ox_lib)
function NotifyPlayer(title, message, messageType, position, duration)
    TriggerEvent('ox_lib:notify', {
        title = title,
        type = messageType or 'info',
        description = message or '',
        position = position or 'bottom-right',
        duration = duration or 4000,
    })
end

function ShowNotify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(true, true)
end

-- Respawn logic
function respawnPed(coords)
    local ped = PlayerPedId()
    if IsEntityDead(ped) then
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
        ClearPedBloodDamage(ped)
        SetPlayerInvincible(ped, false)
        TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
    end
end

RegisterNetEvent('rexrevive:respawn', function(coords)
    respawnPed(coords)
end)

RegisterNetEvent("rexrevive:revivePlayerClient", function()
    local ped = PlayerPedId()
    revivePed(ped)
    notificationShown = false
end)

-- Revive logic
function revivePed(ped)
    local playerPos = GetEntityCoords(ped)
    isPlayerDead = false
    timer = reviveWait
    SetPlayerInvincible(ped, false)
    NetworkResurrectLocalPlayer(playerPos.x, playerPos.y, playerPos.z, GetEntityHeading(ped), true, false)
    ClearPedBloodDamage(ped)
end

-- /selfRevive command
RegisterCommand('selfRevive', function()
    local ped = PlayerPedId()
    if IsEntityDead(ped) and reviveKeyAllowed then
        if timer <= 0 then
            revivePed(ped)
        else
            NotifyPlayer('Cooldown', ('Wait %d seconds before Revive'):format(timer), 'error', 'bottom-right', 2000)
        end
    end
end, false)

RegisterKeyMapping('selfRevive', 'Revive Key', 'keyboard', 'E')

-- Death detection loop
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsEntityDead(ped) then
            isPlayerDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)
            if not notificationShown then
                if reviveKeyAllowed then
                    ShowNotify("Use ~y~E ~w~to Revive")
                    NotifyPlayer('You are Dead', 'Wait 5 seconds. Press Revive Key', 'error', 'bottom-right', 5000)
                end
                notificationShown = true
            end
        else
            isPlayerDead = false
            notificationShown = false
        end
    end
end)

-- Cooldown timer
CreateThread(function()
    while true do
        if isPlayerDead then
            timer = timer - 1
        end
        Wait(1000)
    end
end)
