fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54        'yes'

name 'ui'
author 'devyn'
version '1.0.0'
repository 'https://github.com/darktrovx/devyn_ui'

ui_page 'html/index.html'

files {
	'html/**',
}

client_scripts {
    'client/main.lua',
    'client/progress.lua',
    'client/timer.lua',
    'client/task.lua',
    'client/itemlist.lua',
}
server_scripts {
    'server/main.lua',
}

