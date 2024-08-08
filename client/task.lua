
local function showTask(data)
    SendNUIMessage({
        action = 'task',
        title = data.title,
        description = data.description
    })
end
exports('showTask', showTask)

local function hideTask()
    SendNUIMessage({
        action = 'taskHide'
    })
end
exports('hideTask', hideTask)

RegisterNetEvent('ui:showTask', function(data)
    showTask(data)
end)

RegisterNetEvent('ui:hideTask', function()
    hideTask()
end)