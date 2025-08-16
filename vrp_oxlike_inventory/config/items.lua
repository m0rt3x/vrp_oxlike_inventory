-- Registro de itens no vRP 1
-- Certifique-se de que este arquivo seja carregado após utils.lua do vRP.

local lang = {}

-- Helper para itens simples com uso opcional
local function defSimpleItem(name, label, weight, on_use)
  vRP.defInventoryItem({name, label, label.."\nPeso: "..tostring(weight), weight, on_use, nil})
end

-- Itens comuns
defSimpleItem("water","Água",0.3,function(user_id,player)
  vRPclient.notify(player, {"~b~Você bebeu água."})
  TriggerClientEvent("vrp_oxlike_inventory:consumed", player, "water")
  return true
end)

defSimpleItem("bread","Pão",0.3,function(user_id,player)
  vRPclient.notify(player, {"~g~Você comeu pão."})
  TriggerClientEvent("vrp_oxlike_inventory:consumed", player, "bread")
  return true
end)

-- Armas: no vRP 1, armas são tratadas como itens com uso para equipar
-- O nome do item deve ser igual ao hash/identificador GTA (ex: WEAPON_KNIFE, WEAPON_PISTOL)
local function defWeaponItem(weapon, label, weight, ammoType)
  vRP.defInventoryItem({weapon, label, "Arma: "..label, weight, function(user_id, player)
    -- Equipa arma no cliente e remove item (ou não, se quiser arma persistente)
    TriggerClientEvent("vrp_oxlike_inventory:equipWeapon", player, weapon, ammoType or "AMMO_PISTOL")
    return true
  end, nil})
end

defWeaponItem("WEAPON_KNIFE", "Faca", 1.0)
defWeaponItem("WEAPON_PISTOL", "Pistola", 2.0, "AMMO_PISTOL")
