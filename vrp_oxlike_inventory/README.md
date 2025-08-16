# vrp_oxlike_inventory (vRP 1)

Inventário para vRP 1 com UI parecida com ox_inventory: itens, armas, lojas e cofres (stashes).

## Instalação
1. Copie a pasta `vrp_oxlike_inventory` para `resources/`.
2. No seu `server.cfg`, adicione:
   ```
   ensure vrp
   ensure vrp_oxlike_inventory
   ```
3. Garanta que as libs do vRP estão acessíveis via `@vrp/lib/...` (Proxy.lua, Tunnel.lua, utils.lua).

## Uso
- Abra o inventário com **F2** ou `/inventario`.
- Lojas: definidas em `config/config.lua` (markers simples no mundo).
- Cofres: interface via funções do server (UI não tem painel separado, mas você pode abrir via chamadas a `INV.openStash` + construir UI se quiser).

## Itens e Armas
- Registros em `config/items.lua` usando `vRP.defInventoryItem`.
- Armas são itens (ex.: `WEAPON_PISTOL`). Ao usar, equipa no jogador.

## Exports/Events
- `TriggerEvent('vrp_oxlike_inventory:open')` para abrir a UI do jogador.
- Server NUI:
  - `vrp_oxlike_inventory:server:buyItem (shopId, item, qty, price)`
- Tunnel/Interface (server):
  - `getPlayerInventory()` → { items[], weight, max }
  - `useItem(item)`
  - `dropItem(item, amount)`
  - `giveItem(targetSource, item, amount)`
  - `openStash(stashId)`
  - `depositToStash(stashId, item, qty)`
  - `withdrawFromStash(stashId, item, qty)`

## Observações
- Cofres estão **em memória** por padrão. Para produção, substitua por persistência em DB.
- Se você já tinha itens no ox_inventory, mapeie os nomes para `vRP.defInventoryItem`.
- Esta UI é simples e leve, sem dependências externas.

## Personalização
- Altere cores/estilo em `html/styles.css`.
- Adicione itens e munições em `config/items.lua`.
- Adapte efeitos de fome/sede em `client/client.lua` evento `vrp_oxlike_inventory:consumed`.
