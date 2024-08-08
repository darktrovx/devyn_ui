

RegisterCommand('testui', function()
    exports.devyn_ui:createInfoItem('test1', 'Test 1', 'This is a test')
    exports.devyn_ui:createInfoItem('test2', 'Test 2', 'This is a test')
    exports.devyn_ui:createInfoItem('test3', 'Test 3', 'This is a test')
    exports.devyn_ui:createInfoItem('test4', 'Test 4', 'This is a test')

    local timer_one = exports.devyn_ui:startTimer({
        label = "My New Timer",
        duration = 90000, -- ms
    })

    local timer_two = exports.devyn_ui:startTimer({
        label = "My Second Timer",
        duration = 70000, -- ms
    })

    exports.devyn_ui:showTask({
        title = "Your Title",
        description = "Your Task Description"
    })

    exports.devyn_ui:progressBar({
        duration = 10000,
        label = 'Progress Bar Label',
        useWhileDead = false,
        canCancel = true,
    })

end)