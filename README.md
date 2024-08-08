# devyn_ui

![image](https://github.com/user-attachments/assets/91d41875-09a2-48bb-93dc-a09cb52b257e)


# Item List
```
exports.devyn_ui:createInfoItem(itemId, label, text)

exports.devyn_ui:updateInfoItem(itemId, label, text)

exports.devyn_ui:removeInfoItem(itemId)

```

# Timer

```
local timerId = exports.devyn_ui:startTimer({
    label = "Your Timer Label",
    duration = 5000, -- ms
    action = function()
        -- Code to run when timer is finished
    end,
    args = {
        foo = bar
    }
})

exports.devyn_ui:cancelTimer(timerId)

```

# Task
```
-- Display task UI.
exports.devyn_ui:showTask({
    title = "Your Title",
    description = "Your Task Description"
})

-- Hide the task UI.
exports.devyn_ui:hideTask()

```

# Progress Bar

Uses same object data as ox_lib progress bar.
https://overextended.dev/ox_lib/Modules/Interface/Client/progress
```
exports.devyn_ui:progressBar({
    duration = 5000,
    label = 'Progress Bar Label',
    useWhileDead = false,
    canCancel = true,
    disable = {
        car = true,
    },
    anim = {
        dict = 'mp_player_intdrink',
        clip = 'loop_bottle'
    },
    prop = {
        model = `prop_ld_flow_bottle`,
        pos = vec3(0.03, 0.03, 0.02),
        rot = vec3(0.0, 0.0, -1.5)
    },
})

```
 
