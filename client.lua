local ESX = exports['es_extended']:getSharedObject()
local isBusy = false

-- Blips separados
local function CreateBlips()
    -- Reparação
    for _, loc in ipairs(Config.Repair.Locations) do
        local blip = AddBlipForCoord(loc)
        SetBlipSprite(blip, Config.Repair.Blip.sprite)
        SetBlipColour(blip, Config.Repair.Blip.color)
        SetBlipScale(blip, Config.Repair.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Repair.Blip.label)
        EndTextCommandSetBlipName(blip)
    end
    -- Lavagem
    for _, loc in ipairs(Config.Wash.Locations) do
        local blip = AddBlipForCoord(loc)
        SetBlipSprite(blip, Config.Wash.Blip.sprite)
        SetBlipColour(blip, Config.Wash.Blip.color)
        SetBlipScale(blip, Config.Wash.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Wash.Blip.label)
        EndTextCommandSetBlipName(blip)
    end
end

-- Markers separados
local function DrawMarkers()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for _, loc in ipairs(Config.Repair.Locations) do
        if #(coords - loc) < 10.0 then
            DrawMarker(
                Config.Repair.Marker.type,
                loc.x, loc.y, loc.z - 0.96,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                Config.Repair.Marker.size.x, Config.Repair.Marker.size.y, Config.Repair.Marker.size.z,
                Config.Repair.Marker.color.r, Config.Repair.Marker.color.g, Config.Repair.Marker.color.b, Config.Repair.Marker.color.a,
                false, true, 2, false, nil, nil, false
            )
        end
    end
    for _, loc in ipairs(Config.Wash.Locations) do
        if #(coords - loc) < 10.0 then
            DrawMarker(
                Config.Wash.Marker.type,
                loc.x, loc.y, loc.z - 0.96,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                Config.Wash.Marker.size.x, Config.Wash.Marker.size.y, Config.Wash.Marker.size.z,
                Config.Wash.Marker.color.r, Config.Wash.Marker.color.g, Config.Wash.Marker.color.b, Config.Wash.Marker.color.a,
                false, true, 2, false, nil, nil, false
            )
        end
    end
end

local function IsNearZone(coords, zoneList)
    for _, loc in ipairs(zoneList) do
        if #(coords - loc) < 2.0 then return true end
    end
    return false
end

-- Funções de serviço independentes
local function RepairVehicle(vehicle)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleUndriveable(vehicle, false)
    ESX.ShowNotification(Config.Notifications.repair_success)
end

local function CleanVehicle(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    WashDecalsFromVehicle(vehicle, 1.0)
    ESX.ShowNotification(Config.Notifications.clean_success)
end

local function StartRepair()
    if isBusy then return end
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then ESX.ShowNotification(Config.Notifications.not_in_vehicle) return end
    isBusy = true
    local ok = lib.progressBar({
        duration = Config.Progress.repair.duration,
        label = Config.Progress.repair.label,
        useWhileDead = false,
        canCancel = true,
        disable = {move = true, car = true}
    })
    if ok then
        RepairVehicle(vehicle)
    else
        ESX.ShowNotification(Config.Notifications.cancelled)
    end
    isBusy = false
end

local function StartClean()
    if isBusy then return end
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then ESX.ShowNotification(Config.Notifications.not_in_vehicle) return end
    isBusy = true
    local ok = lib.progressBar({
        duration = Config.Progress.clean.duration,
        label = Config.Progress.clean.label,
        useWhileDead = false,
        canCancel = true,
        disable = {move = true, car = true}
    })
    if ok then
        CleanVehicle(vehicle)
    else
        ESX.ShowNotification(Config.Notifications.cancelled)
    end
    isBusy = false
end

-- Thread principal
Citizen.CreateThread(function()
    CreateBlips()
    while true do
        Citizen.Wait(5)
        DrawMarkers()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local nearRepair = IsNearZone(coords, Config.Repair.Locations)
        local nearWash = IsNearZone(coords, Config.Wash.Locations)
        if nearRepair and IsPedInAnyVehicle(ped, false) and not isBusy then
            lib.showTextUI('[E] Reparar Veículo', {position = 'right-center'})
            if IsControlJustReleased(0, Config.Keybinds.repair) then
                lib.hideTextUI()
                StartRepair()
            end
        elseif nearWash and IsPedInAnyVehicle(ped, false) and not isBusy then
            lib.showTextUI('[E] Lavar Veículo', {position = 'right-center'})
            if IsControlJustReleased(0, Config.Keybinds.clean) then
                lib.hideTextUI()
                StartClean()
            end
        else
            lib.hideTextUI()
        end
    end
end)
