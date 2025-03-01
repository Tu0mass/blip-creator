local blips = {}
local serverBlips = {}
local CurrentLocale = {}

-- Tarkista, että Config on ladattu
if not Config then
    print("^1[ERROR]^7 Config.lua ei ole ladattu! Tarkista fxmanifest.lua ja varmista, että config.lua on client_scripts-listassa!")
    return
end

-- Lataa kielitiedosto configista
function LoadLocale(locale)
    local file = LoadResourceFile(GetCurrentResourceName(), "locales/" .. locale .. ".lua")
    if file then
        local chunk, err = load(file)
        if chunk then
            CurrentLocale = chunk().Locales[locale] or {}
        else
            print("^1[ERROR]^7 Locale file error: " .. err)
        end
    else
        print("^1[ERROR]^7 Locale file not found: locales/" .. locale .. ".lua")
    end
end

function _U(str)
    return CurrentLocale[str] or str
end

LoadLocale(Config.Locale)

RegisterNetEvent('blipCreator:syncBlips', function(data)
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    blips = {}

    serverBlips = data

    for index, v in pairs(data) do
        local newBlip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(newBlip, v.sprite)
        SetBlipColour(newBlip, v.color)
        SetBlipScale(newBlip, v.scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(newBlip)
        blips[index] = newBlip
    end
end)

local icons = {
    { label = _U("house"), value = 40 },
    { label = _U("store"), value = 52 },
    { label = _U("police"), value = 60 },
    { label = _U("hospital"), value = 61 },
    { label = _U("gas_station"), value = 361 },
    { label = _U("bank"), value = 108 },
    { label = _U("shooting_range"), value = 110 },
    { label = _U("casino"), value = 679 },
    { label = _U("bar"), value = 93 },
    { label = _U("gym"), value = 311 },
    { label = _U("mechanic"), value = 402 },
    { label = _U("mc_club"), value = 226 },
    { label = _U("ferry"), value = 356 },
    { label = _U("airport"), value = 90 },
    { label = _U("helipad"), value = 64 },
    { label = _U("restaurant"), value = 267 },
    { label = _U("prison"), value = 285 },
    { label = _U("oil_field"), value = 436 },
    { label = _U("gold_mine"), value = 467 }
}

local colors = {
    { label = _U("red"), value = 1 },
    { label = _U("blue"), value = 3 },
    { label = _U("green"), value = 2 },
    { label = _U("yellow"), value = 5 },
    { label = _U("white"), value = 4 }
}

local function OpenBlipMenu()
    if not Config.MenuEnabled then
        lib.notify({ title = _U("blip_creator"), description = _U("menu_disabled"), type = "error" })
        return
    end

    lib.registerContext({
        id = 'blip_menu',
        title = _U("jimmy Blips"),
        description = _U("manage_blips"),
        options = {
            {
                title = _U("create_blip"),
                description = _U("create_blip_desc"),
                onSelect = function()
                    local input = lib.inputDialog(_U('create_blip'), {
                        { type = "input", label = _U('blip_name'), required = true },
                        { type = "select", label = _U('icon'), options = icons, required = true },
                        { type = "select", label = _U('color'), options = colors, required = true },
                        { type = "slider", label = _U('size'), min = 0.5, max = 4.0, default = 1.0 }
                    })

                    if not input then return end

                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped)

                    TriggerServerEvent('blipCreator:addBlip', {
                        label = input[1],
                        sprite = tonumber(input[2]),
                        color = tonumber(input[3]),
                        scale = tonumber(input[4]),
                        coords = { x = coords.x, y = coords.y, z = coords.z }
                    })

                    lib.notify({ title = _U("blip_added"), description = input[1] .. " " .. _U("blip_added"), type = "success" })
                end
            },
            {
                title = _U("remove_blip"),
                description = _U("remove_blip_desc"),
                onSelect = function()
                    OpenDeleteBlipMenu()
                end
            }
        }
    })
    lib.showContext('blip_menu')
end

RegisterCommand("blipmenu", function()
    OpenBlipMenu()
end, false)
