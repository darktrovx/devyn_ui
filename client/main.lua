

RegisterCommand('test1', function()
    exports.ui:createInfoItem('test1', 'Test 1', 'This is a test')
end)

RegisterCommand('test2', function()
    exports.ui:removeInfoItem('test1')
end)

RegisterCommand('test3', function()
    exports.ui:createInfoItem('test3', 'Test 3', 'This is a test 3')
end)