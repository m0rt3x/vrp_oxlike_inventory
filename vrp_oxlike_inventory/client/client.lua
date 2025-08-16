local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

INV = {}
Tunnel.bindInterface("vrp_oxlike_inventory", INV)
SRV = Tunnel.getInterface("vrp_oxlike_inventory")

local uiOpen = false

RegisterNetEvent("vrp_oxlike_inventory:open")
AddEventHandler("vrp_oxlike_inventory:open", function()
  if uiOpen then return end
  SetNuiFocus(true, true)
  uiOpen = true
  SendNUIMessage({ action="open" })
  local data = SRV.getPlayerInventory()
  SendNUIMessage({ action="setInventory", data=data })
end)

RegisterNUICallback("requestInventory", function(_, cb)
  local data = SRV.getPlayerInventory()
  SendNUIMessage({ action="setInventory", data=data })
  cb(true)
end)

RegisterNUICallback("useItem", function(data, cb)
  local ok, err = SRV.useItem(data.item)
  cb({ok=ok, err=err})
end)

RegisterNUICallback("dropItem", function(data, cb)
  local ok, err = SRV.dropItem(data.item, data.amount)
  cb({ok=ok, err=err})
end)

RegisterNUICallback("giveItem", function(data, cb)
  local ok, err = SRV.giveItem(data.target, data.item, data.amount)
  cb({ok=ok, err=err})
end)

RegisterNUICallback("close", function(_, cb)
  SetNuiFocus(false, false)
  uiOpen = false
  cb(true)
end)

-- Tecla para abrir (F2 por padrão)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(0, 289) then
      TriggerEvent("vrp_oxlike_inventory:open")
    end
  end
end)

-- Consumo de comida/bebida
RegisterNetEvent("vrp_oxlike_inventory:consumed")
AddEventHandler("vrp_oxlike_inventory:consumed", function(item)
  -- Aplique efeitos aqui (setar sede/fome do seu HUD)
  -- Exemplo: TriggerEvent('status:add','thirst', 200000)
end)

-- Dropar no chão (placeholder)
RegisterNetEvent("vrp_oxlike_inventory:dropOnGround")
AddEventHandler("vrp_oxlike_inventory:dropOnGround", function(item, amount)
  -- Você pode criar um objeto/prop no mundo e permitir pegar
  TriggerEvent("chat:addMessage", {args={"Inventário","Você dropou "..amount.."x "..item.." no chão."}})
end)

-- Equipar arma
RegisterNetEvent("vrp_oxlike_inventory:equipWeapon")
AddEventHandler("vrp_oxlike_inventory:equipWeapon", function(weapon, ammoType)
  local ped = PlayerPedId()
  GiveWeaponToPed(ped, GetHashKey(weapon), 0, false, true)
  -- Você pode integrar munições/munição itemizada aqui
end)

-- Shops helpers (markers simples)
Citizen.CreateThread(function()
  while true do
    local sleep = 1000
    local ped = PlayerPedId()
    local px,py,pz = table.unpack(GetEntityCoords(ped))
    for _,s in pairs(Config.Shops or {}) do
      local dist = #(vector3(px,py,pz) - s.coords)
      if dist < 10.0 then
        sleep = 0
        DrawMarker(1, s.coords.x, s.coords.y, s.coords.z-1.0, 0,0,0, 0,0,0, 1.0,1.0,0.4, 255,255,255,120, false,true,2,false,nil,nil,false)
        if dist < (Config.InteractDistance or 1.5) then
          BeginTextCommandDisplayHelp("STRING")
          AddTextComponentSubstringPlayerName("Pressione ~INPUT_CONTEXT~ para abrir a loja")
          EndTextCommandDisplayHelp(0, false, false, -1)
          if IsControlJustPressed(0, 38) then -- E
            TriggerServerEvent("vrp_oxlike_inventory:server:getShopItems", s.id)
          end
        end
      end
    end
    Citizen.Wait(sleep)
  end
end)

RegisterNetEvent("vrp_oxlike_inventory:client:openShop")
AddEventHandler("vrp_oxlike_inventory:client:openShop", function(shopId, shopName, items)
  SetNuiFocus(true, true)
  uiOpen = true
  SendNUIMessage({ action="openShop", shopId=shopId, shopName=shopName, items=items })
end)
