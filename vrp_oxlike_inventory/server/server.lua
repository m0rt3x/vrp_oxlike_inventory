local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_oxlike_inventory")

local INV = {}
Tunnel.bindInterface("vrp_oxlike_inventory", INV)

-- Callbacks/exports para UI
function INV.getPlayerInventory()
  local source = source
  local user_id = vRP.getUserId({source})
  if not user_id then return {items={}, weight=0, max=0} end
  local inv = vRP.getInventory({user_id})
  local weight = vRP.getInventoryWeight({user_id})
  local max = vRP.getInventoryMaxWeight({user_id})
  local items = {}
  for k,v in pairs(inv) do
    table.insert(items, {name=k, amount=v.amount or v, label=k, weight=vRP.getItemWeight({k}) or 0})
  end
  return {items=items, weight=weight, max=max}
end

function INV.useItem(itemName)
  local source = source
  local user_id = vRP.getUserId({source})
  if not user_id then return false, "no_user" end
  return vRP.useInventoryItem({user_id, itemName})
end

function INV.dropItem(itemName, amount)
  local source = source
  local user_id = vRP.getUserId({source})
  if not user_id then return false, "no_user" end
  amount = tonumber(amount) or 1
  if vRP.tryGetInventoryItem({user_id, itemName, amount, true}) then
    TriggerClientEvent("vrp_oxlike_inventory:dropOnGround", source, itemName, amount)
    return true
  end
  return false, "not_enough"
end

function INV.giveItem(targetSource, itemName, amount)
  local source = source
  local user_id = vRP.getUserId({source})
  local target_id = vRP.getUserId({targetSource})
  if not user_id or not target_id then return false, "invalid" end
  amount = tonumber(amount) or 1
  if vRP.tryGetInventoryItem({user_id, itemName, amount, true}) then
    vRP.giveInventoryItem({target_id, itemName, amount, true})
    return true
  end
  return false, "not_enough"
end

RegisterNetEvent("vrp_oxlike_inventory:server:buyItem")
AddEventHandler("vrp_oxlike_inventory:server:buyItem", function(shopId, item, qty, price)
  local source = source
  local user_id = vRP.getUserId({source})
  qty = tonumber(qty) or 1
  price = tonumber(price) or 0
  if user_id and qty > 0 and price >= 0 then
    if vRP.tryPayment({user_id, price * qty}) then
      vRP.giveInventoryItem({user_id, item, qty, true})
      TriggerClientEvent("Notify", source, "sucesso", "Comprou "..qty.."x "..item..".")
    else
      TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.")
    end
  end
end)

-- Stashes / Cofres
local STASHES = {}
-- Simple in-memory storage (recommend replacing with DB persistence for production)
-- STASHES[id] = { items = { [name] = qty }, weight = 0 }

local function getStash(id)
  STASHES[id] = STASHES[id] or {items={}, weight=0.0, max=200.0}
  return STASHES[id]
end

function INV.openStash(stashId)
  local source = source
  local user_id = vRP.getUserId({source})
  if not user_id then return {items={}, weight=0, max=0} end
  local stash = getStash(stashId)
  return stash
end

function INV.depositToStash(stashId, itemName, qty)
  local source = source
  local user_id = vRP.getUserId({source})
  qty = tonumber(qty) or 1
  if not user_id or qty <= 0 then return false end
  if vRP.tryGetInventoryItem({user_id, itemName, qty, true}) then
    local stash = getStash(stashId)
    stash.items[itemName] = (stash.items[itemName] or 0) + qty
    return true
  end
  return false
end

function INV.withdrawFromStash(stashId, itemName, qty)
  local source = source
  local user_id = vRP.getUserId({source})
  qty = tonumber(qty) or 1
  if not user_id or qty <= 0 then return false end
  local stash = getStash(stashId)
  local have = stash.items[itemName] or 0
  if have >= qty then
    stash.items[itemName] = have - qty
    vRP.giveInventoryItem({user_id, itemName, qty, true})
    return true
  end
  return false
end

-- Export para abrir a UI via outros recursos
RegisterCommand("inventario", function(source)
  TriggerClientEvent("vrp_oxlike_inventory:open", source)
end)

RegisterServerEvent("vrp_oxlike_inventory:server:log")
AddEventHandler("vrp_oxlike_inventory:server:log", function(data)
  -- Substitua por sua solução de log (webhook, db, etc.)
  print("[vrp_oxlike_inventory LOG]", json.encode(data))
end)
