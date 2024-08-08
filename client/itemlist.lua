
local ListItems = {}

local function updateInfoItem(itemId, label, text)
    if ListItems[itemId] then
        ListItems[itemId].label = label
        ListItems[itemId].text = text
    else
        ListItems[itemId] = {
            label = label,
            text = text
        }
    end

    SendNUIMessage({
        action = 'updateInfoItem',
        itemId = itemId,
        label = label,
        text = text
    })
end
exports('updateInfoItem', updateInfoItem)

local function createInfoItem(itemId, label, text)
    if ListItems[itemId] then
        updateInfoItem(itemId, label, text)
        return
    end

    ListItems[itemId] = {
        label = label,
        text = text
    }

    SendNUIMessage({
        action = 'createInfoItem',
        itemId = itemId,
        label = label,
        text = text
    })

end
exports('createInfoItem', createInfoItem)

local function removeInfoItem(itemId)
    if ListItems[itemId] then
        ListItems[itemId] = nil
    end

    SendNUIMessage({
        action = 'removeInfoItem',
        itemId = itemId
    })
end
exports('removeInfoItem', removeInfoItem)
