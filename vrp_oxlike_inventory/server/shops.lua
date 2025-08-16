local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("vrp_oxlike_inventory:server:getShopItems")
AddEventHandler("vrp_oxlike_inventory:server:getShopItems", function(shopId)
  local src = source
  local shop = nil
  for _,s in pairs(Config.Shops or {}) do
    if s.id == shopId then shop = s break end
  end
  if shop then
    TriggerClientEvent("vrp_oxlike_inventory:client:openShop", src, shopId, shop.name, shop.items)
  else
    TriggerClientEvent("Notify", src, "negado", "Loja não encontrada.")
  end
end)
