fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Serviço gratuito de reparação e lavagem de veículos, com zonas e blips separados'
author 'Paulo Martins'
version '0.0.1'

shared_script '@es_extended/imports.lua'

client_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'client.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}
