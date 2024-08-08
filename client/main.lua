

RegisterCommand('test1', function()
    exports.devyn_ui:createInfoItem('test1', 'Test 1', 'This is a test')
    exports.devyn_ui:createInfoItem('test2', 'Test 2', 'This is a test')
    exports.devyn_ui:createInfoItem('test3', 'Test 3', 'This is a test')
    exports.devyn_ui:createInfoItem('test4', 'Test 4', 'This is a test')
end)

RegisterCommand('test2', function()
    exports.devyn_ui:removeInfoItem('test1')
end)

RegisterCommand('test3', function()
    exports.devyn_ui:createInfoItem('test3', 'Test 3', 'This is a test 3')
end)