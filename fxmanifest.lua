fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'jimmy'
description 'Blip Creator'
version '1.0.0'

shared_script '@ox_lib/init.lua'

server_script 'server.lua'

client_scripts {
    'config.lua',
    'locales/fi.lua',
    'locales/en.lua',
    'client.lua'
}

files {
    'data/blips.json'
}

dependencies {
    'es_extended',
    'ox_lib'
}
