fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'M0rt3x'
description 'vRP1-compatible inventory with ox-like UI (items, weapons, shops, stashes).'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@vrp/lib/utils.lua',
    'config/config.lua',
    'config/items.lua'
}

server_scripts {
    '@vrp/lib/utils.lua',
    '@vrp/lib/Proxy.lua',
    '@vrp/lib/Tunnel.lua',
    'server/server.lua',
    'server/shops.lua',
    'server/stashes.lua'
}

client_scripts {
    '@vrp/lib/Proxy.lua',
    '@vrp/lib/Tunnel.lua',
    'client/client.lua'
}

files {
    'html/index.html',
    'html/app.js',
    'html/styles.css'
}
