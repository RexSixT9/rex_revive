local allowReviveCommand = true
local QBX = exports.qbx_core

-- /reviveplayer [id] (admin only)
if allowReviveCommand then
    RegisterCommand("reviveplayer", function(source, args)
        local src = source
        local Player = QBX:GetPlayer(src)
        if not Player then return end

        if not exports.qbx_core:HasPermission(src, "admin") then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Access Denied',
                description = 'You do not have permission to use this command.',
                type = 'error'
            })
            return
        end

        local targetId = tonumber(args[1]) or src
        local targetPed = GetPlayerPed(targetId)

        if not targetPed or not DoesEntityExist(targetPed) then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error',
                description = 'No player found with that ID.',
                type = 'error'
            })
            return
        end

        TriggerClientEvent("rexrevive:revivePlayerClient", targetId)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Revive Successful',
            description = ('Player [%d] revived.'):format(targetId),
            type = 'success'
        })
    end, false)
end

-- /respawn [id] (admin only)
RegisterCommand("respawn", function(source, args)
    local src = source
    local Player = QBX:GetPlayer(src)
    if not Player then return end

    if not exports.qbx_core:HasPermission(src, "admin") then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Access Denied',
            description = 'You do not have permission to use this command.',
            type = 'error'
        })
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Usage',
            description = '/respawn [playerId]',
            type = 'info'
        })
        return
    end

    local coords = { x = 226.0371, y = -854.9874, z = 29.9661, heading = 344.3221 }
    TriggerClientEvent("rexrevive:respawn", targetId, coords)

    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Respawn',
        description = ('Player [%d] respawned at hospital.'):format(targetId),
        type = 'success'
    })
end, false)
