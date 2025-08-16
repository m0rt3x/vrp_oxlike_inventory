Config = {}

-- Peso máximo padrão do inventário do jogador (vRP já tem peso interno; aqui você pode ajustar multiplicadores/limites de UI)
Config.MaxWeight = 30.0

-- Permite arrastar/soltar no chão
Config.AllowDropOnGround = true

-- Distância para abrir lojas/cofres
Config.InteractDistance = 1.5

-- Tecla para abrir inventário (cliente) - você pode integrar com sua keymap atual
-- A UI também pode ser aberta via evento: TriggerEvent('vrp_oxlike_inventory:open')
Config.OpenKey = 289 -- F2

-- Shops cadastradas (ver server/shops.lua para lógica)
Config.Shops = {
    {
        id = "mercado_central",
        name = "24/7 Supermarket",
        coords = vec3(25.7, -1347.3, 29.5),
        items = {
            {name="water", label="Água", price=20, amount=100},
            {name="bread", label="Pão", price=25, amount=100},
            {name="WEAPON_KNIFE", label="Faca", price=2500, amount=5, weapon=true}
        }
    }
}

-- Stashes/Cofres avançados
-- Você pode vincular um cofre a um job, gang, casa, etc.
Config.Stashes = {
    { id="police_armory", label="Arsenal Policial", capacity=200.0, shared=true, access=function(user_id, source) 
        local vRP = Proxy.getInterface("vRP")
        local roles = vRP.getUserGroups({user_id}) or {}
        return roles["police"] ~= nil
    end },
    { id="bennys_storage", label="Depósito Benny's", capacity=150.0, shared=true, access=function(user_id, source)
        local vRP = Proxy.getInterface("vRP")
        local roles = vRP.getUserGroups({user_id}) or {}
        return roles["mechanic"] ~= nil
    end }
}

-- Traduções básicas (você pode mudar via locales/*.json)
Config.Locale = 'pt'
