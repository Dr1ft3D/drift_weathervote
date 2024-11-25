fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Drift3D'
description 'Weather Voting Script'
version '1.0.0'
client_scripts {
    'client/cl_*.lua'
}
server_scripts {
    'server/sv_*.lua'
}
shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

dependency 'ox_lib' 