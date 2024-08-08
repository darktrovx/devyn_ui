local timers = {}

local function createTimer(data)
    local timerId = #timers + 1
    timers[timerId] = {
        started = false,
        label = data.label or 'Time remaining',
        duration = data.duration or 1000,
        action = data.action or nil,
        args = data.args or nil
    }
    return timerId
end

function startTimer(data)
    local timerId = createTimer(data)
    SendNUIMessage({
        action = 'timer',
        data = {
            timerId = timerId,
            label = data.label or 'Time remaining',
            duration = data.duration
        }
    })
    
    timers[timerId].started = true
    return timerId
end
exports('startTimer', startTimer)

local function cancelTimer(timerId)
    local timer = timers[timerId]
    if timer then
        SendNUIMessage({ action = 'timerCancel', data = { timerId = timerId } })
        if timer.cancelAction then
            timer.cancelAction(timer?.args)
        end
        timers[timerId] = {}
    end
end
exports('cancelTimer', cancelTimer)

local function completeTimer(timerId)
    local timer = timers[timerId]
    if timer then
        if timer.action then
            timer.action(timer?.args)
        end
        timers[timerId] = {}
    end
end

RegisterNUICallback('timerComplete', function(data, cb)
    completeTimer(data.timerId)
    cb('ok')
end)