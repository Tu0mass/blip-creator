ESX = exports['es_extended']:getSharedObject()

local blips = {}

local function LoadBlips()
    local file = LoadResourceFile(GetCurrentResourceName(), "data/blips.json")
    if file then
        blips = json.decode(file) or {}
    end
end

local function SaveBlips()
    SaveResourceFile(GetCurrentResourceName(), "data/blips.json", json.encode(blips, { indent = true }), -1)
end

RegisterNetEvent('blipCreator:addBlip', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        table.insert(blips, data)
        SaveBlips()
        TriggerClientEvent('blipCreator:syncBlips', -1, blips)
    end
end)

RegisterNetEvent('blipCreator:removeBlip', function(index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        table.remove(blips, index)
        SaveBlips()
        TriggerClientEvent('blipCreator:syncBlips', -1, blips)
    end
end)

ESX.RegisterServerCallback('blipCreator:getBlips', function(_, cb)
    cb(blips)
end)

LoadBlips()
