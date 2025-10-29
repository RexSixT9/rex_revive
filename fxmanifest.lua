fx_version 'cerulean'
game 'gta5'

author 'RICK-OP (QBOX Conversion by Rex & ChatGPT)'
description 'Simple Qbox-compatible Revive Script using ox_lib'
version 'v3.0'

lua54 'yes'

dependencies {
    'ox_lib',
    'qbx_core'
}

shared_script '@ox_lib/init.lua'

client_script 'client.lua'
server_script 'server.lua'
