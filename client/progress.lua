-- Code from : https://github.com/overextended/ox_lib

local progress
local DisableControlAction = DisableControlAction
local DisablePlayerFiring = DisablePlayerFiring
local playerState = LocalPlayer.state

---Yields the current thread until a non-nil value is returned by the function.
---@generic T
---@param cb fun(): T?
---@param errMessage string?
---@param timeout? number | false Error out after `~x` ms. Defaults to 1000, unless set to `false`.
---@return T
---@async
function waitFor(cb, errMessage, timeout)
    local value = cb()

    if value ~= nil then return value end

    if timeout or timeout == nil then
        if type(timeout) ~= 'number' then timeout = 1000 end
    end

    local start = timeout and GetGameTimer()

    while value == nil do
        Wait(0)

        local elapsed = timeout and GetGameTimer() - start

        if elapsed and elapsed > timeout then
            return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', elapsed), 2)
        end

        value = cb()
    end

    return value
end

---@async
---@generic T : string | number
---@param request function
---@param hasLoaded function
---@param assetType string
---@param asset T
---@param timeout? number
---@param ... any
---Used internally.
function streamingRequest(request, hasLoaded, assetType, asset, timeout, ...)
    if hasLoaded(asset) then return asset end

    request(asset, ...)

    return waitFor(function()
        if hasLoaded(asset) then return asset end
    end, ("failed to load %s '%s' - this is likely caused by unreleased assets"):format(assetType, asset), timeout or 10000)
end

---Load a model. When called from a thread, it will yield until it has loaded.
---@param model number | string
---@param timeout number? Approximate milliseconds to wait for the model to load. Default is 10000.
---@return number model
local function requestModel(model, timeout)
    if type(model) ~= 'number' then model = joaat(model) end
    if HasModelLoaded(model) then return model end

    if not IsModelValid(model) and not IsModelInCdimage(model) then
        error(("attempted to load invalid model '%s'"):format(model))
    end

    return streamingRequest(RequestModel, HasModelLoaded, 'model', model, timeout)
end

---Load an animation dictionary. When called from a thread, it will yield until it has loaded.
---@param animDict string
---@param timeout number? Approximate milliseconds to wait for the dictionary to load. Default is 10000.
---@return string animDict
function requestAnimDict(animDict, timeout)
    if HasAnimDictLoaded(animDict) then return animDict end

    if type(animDict) ~= 'string' then
        error(("expected animDict to have type 'string' (received %s)"):format(type(animDict)))
    end

    if not DoesAnimDictExist(animDict) then
        error(("attempted to load invalid animDict '%s'"):format(animDict))
    end

    return streamingRequest(RequestAnimDict, HasAnimDictLoaded, 'animDict', animDict, timeout)
end

---@class ProgressPropProps
---@field model string
---@field bone? number
---@field pos vector3
---@field rot vector3

---@class ProgressProps
---@field label? string
---@field duration number
---@field position? 'middle' | 'bottom'
---@field useWhileDead? boolean
---@field allowRagdoll? boolean
---@field allowCuffed? boolean
---@field allowFalling? boolean
---@field canCancel? boolean
---@field anim? { dict?: string, clip: string, flag?: number, blendIn?: number, blendOut?: number, duration?: number, playbackRate?: number, lockX?: boolean, lockY?: boolean, lockZ?: boolean, scenario?: string, playEnter?: boolean }
---@field prop? ProgressPropProps | ProgressPropProps[]
---@field disable? { move?: boolean, sprint?: boolean, car?: boolean, combat?: boolean, mouse?: boolean }

local function createProp(prop)
    requestModel(prop.model)
    local coords = GetEntityCoords(cache.ped)
    local object = CreateObject(prop.model, coords.x, coords.y, coords.z, true, true, true)

    AttachEntityToEntity(object, cache.ped, GetPedBoneIndex(cache.ped, prop.bone or 60309), prop.pos.x, prop.pos.y, prop.pos.z, prop.rot.x, prop.rot.y, prop.rot.z, true, true, false, true, 0, true)
    SetModelAsNoLongerNeeded(prop.model)

    return object
end

local function interruptProgress(data)
    if not data.useWhileDead and IsEntityDead(cache.ped) then return true end
    if not data.allowRagdoll and IsPedRagdoll(cache.ped) then return true end
    if not data.allowCuffed and IsPedCuffed(cache.ped) then return true end
    if not data.allowFalling and IsPedFalling(cache.ped) then return true end
end

local controls = {
    INPUT_LOOK_LR = 1,
    INPUT_LOOK_UD = 2,
    INPUT_SPRINT = 21,
    INPUT_AIM = 25,
    INPUT_MOVE_LR = 30,
    INPUT_MOVE_UD = 31,
    INPUT_DUCK = 36,
    INPUT_VEH_MOVE_LEFT_ONLY = 63,
    INPUT_VEH_MOVE_RIGHT_ONLY = 648,
    INPUT_VEH_ACCELERATE = 71,
    INPUT_VEH_BRAKE = 72,
    INPUT_VEH_EXIT = 75,
    INPUT_VEH_MOUSE_CONTROL_OVERRIDE = 106,
}

local function startProgress(data)
    playerState.invBusy = true
    progress = data
    local anim = data.anim

    if anim then
        if anim.dict then
            requestAnimDict(anim.dict)

            TaskPlayAnim(cache.ped, anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1, anim.flag or 49, anim.playbackRate or 0, anim.lockX, anim.lockY, anim.lockZ)
            RemoveAnimDict(anim.dict)
        elseif anim.scenario then
            TaskStartScenarioInPlace(cache.ped, anim.scenario, 0, anim.playEnter ~= nil and anim.playEnter or true)
        end
    end

    if data.prop then
        if data.prop.model then
            data.prop1 = createProp(data.prop)
        else
            for i = 1, #data.prop do
                local prop = data.prop[i]

                if prop then
                    data['prop'..i] = createProp(prop)
                end
            end
        end
    end

    local disable = data.disable

    while progress do
        if disable then
            if disable.mouse then
                DisableControlAction(0, controls.INPUT_LOOK_LR, true)
                DisableControlAction(0, controls.INPUT_LOOK_UD, true)
                DisableControlAction(0, controls.INPUT_VEH_MOUSE_CONTROL_OVERRIDE, true)
            end

            if disable.move then
                DisableControlAction(0, controls.INPUT_SPRINT, true)
                DisableControlAction(0, controls.INPUT_MOVE_LR, true)
                DisableControlAction(0, controls.INPUT_MOVE_UD, true)
                DisableControlAction(0, controls.INPUT_DUCK, true)
            end

            if disable.sprint and not disable.move then
                DisableControlAction(0, controls.INPUT_SPRINT, true)
            end

            if disable.car then
                DisableControlAction(0, controls.INPUT_VEH_MOVE_LEFT_ONLY, true)
                DisableControlAction(0, controls.INPUT_VEH_MOVE_RIGHT_ONLY, true)
                DisableControlAction(0, controls.INPUT_VEH_ACCELERATE, true)
                DisableControlAction(0, controls.INPUT_VEH_BRAKE, true)
                DisableControlAction(0, controls.INPUT_VEH_EXIT, true)
            end

            if disable.combat then
                DisableControlAction(0, controls.INPUT_AIM, true)
                DisablePlayerFiring(cache.playerId, true)
            end
        end

        if interruptProgress(progress) then
            progress = false
        end

        Wait(0)
    end

    if data.prop then
        local n = #data.prop
        for i = 1, n > 0 and n or 1 do
            local prop = data['prop'..i]

            if prop then
                DeleteEntity(prop)
            end
        end
    end

    if anim then
        if anim.dict then
            StopAnimTask(cache.ped, anim.dict, anim.clip, 1.0)
            Wait(0) -- This is needed here otherwise the StopAnimTask is cancelled
        else
            ClearPedTasks(cache.ped)
        end
    end

    playerState.invBusy = false

    if progress == false then
        SendNUIMessage({ action = 'progressCancel' })
        return false
    end

    return true
end

---@param data ProgressProps
---@return boolean?
function progressBar(data)
    while progress ~= nil do Wait(0) end

    if not interruptProgress(data) then
        SendNUIMessage({
            action = 'progress',
            data = {
                label = data.label,
                duration = data.duration
            }
        })

        return startProgress(data)
    end
end
exports('progressBar', progressBar)

function cancelProgress()
    if not progress then
        error('No progress bar is active')
    end

    progress = false
end
exports('cancelProgress', cancelProgress)

---@return boolean
function progressActive()
    return progress and true
end
exports('progressActive', progressActive)

RegisterNUICallback('progressComplete', function(data, cb)
    cb(1)
    progress = nil
end)

RegisterCommand('cancelprogress', function()
    if progress?.canCancel then progress = false end
end)

RegisterKeyMapping('cancelprogress', 'Cancel current progress bar', 'keyboard', 'x')
