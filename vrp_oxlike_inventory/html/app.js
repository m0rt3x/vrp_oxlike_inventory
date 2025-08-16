const app = document.getElementById('app');
const playerGrid = document.getElementById('playerGrid');
const weightSpan = document.getElementById('weight');
const amountInput = document.getElementById('amount');
const targetInput = document.getElementById('target');
const useBtn = document.getElementById('useBtn');
const dropBtn = document.getElementById('dropBtn');
const giveBtn = document.getElementById('giveBtn');
const closeBtn = document.getElementById('closeBtn');

const shop = document.getElementById('shop');
const shopTitle = document.getElementById('shopTitle');
const shopGrid = document.getElementById('shopGrid');
const closeShop = document.getElementById('closeShop');

let selected = null;
let inventory = { items:[], weight:0, max:0 };

function renderInventory() {
  playerGrid.innerHTML = '';
  inventory.items.forEach((it, idx) => {
    const el = document.createElement('div');
    el.className = 'slot' + (selected===idx ? ' active' : '');
    el.innerHTML = \`
      <div class="title">\${it.label || it.name}</div>
      <div class="meta"><span>x\${it.amount}</span><span>\${(it.weight||0).toFixed(1)}kg</span></div>
    \`;
    el.addEventListener('click', () => { selected = idx; renderInventory(); });
    playerGrid.appendChild(el);
  });
  weightSpan.textContent = \`\${(inventory.weight||0).toFixed(1)} / \${(inventory.max||0).toFixed(1)}\`;
}

function nui(event, data={}) {
  fetch(`https://${GetParentResourceName()}/${event}`, {
    method:'POST',
    headers: {'Content-Type':'application/json; charset=UTF-8'},
    body: JSON.stringify(data)
  }).then(r=>r.json()).then(res=>{
    if(event==='requestInventory'){
      // handled by cb in client
    }
  }).catch(()=>{});
}

// NUI interface from client
window.addEventListener('message', (e) => {
  const { action } = e.data || {};
  if(action === 'open'){
    app.classList.remove('hidden');
  }
  if(action === 'setInventory'){
    inventory = e.data.data;
    renderInventory();
  }
  if(action === 'openShop'){
    app.classList.remove('hidden');
    shop.classList.remove('hidden');
    shopTitle.textContent = e.data.shopName || 'Loja';
    shopGrid.innerHTML = '';
    (e.data.items || []).forEach(it => {
      const el = document.createElement('div');
      el.className = 'slot';
      el.innerHTML = \`
        <div class="title">\${it.label || it.name}</div>
        <div class="meta"><span>$\${it.price}</span><span>stock:\${it.amount??'-'}</span></div>
        <button style="margin-top:auto" class="buy">Comprar</button>
      \`;
      el.querySelector('.buy').addEventListener('click', ()=>{
        const qty = Math.max(1, parseInt(prompt('Quantidade:', '1'))||1);
        fetch(`https://${GetParentResourceName()}/buyItem`, {
          method:'POST',
          headers:{'Content-Type':'application/json; charset=UTF-8'},
          body: JSON.stringify({ shopId: e.data.shopId, item: it.name, qty, price: it.price })
        });
      });
      shopGrid.appendChild(el);
    });
  }
});

closeBtn.addEventListener('click', ()=>{
  app.classList.add('hidden');
  shop.classList.add('hidden');
  fetch(`https://${GetParentResourceName()}/close`, { method:'POST', body:'{}' });
});
closeShop.addEventListener('click', ()=>{
  shop.classList.add('hidden');
});

useBtn.addEventListener('click', ()=>{
  if(selected===null) return;
  const item = inventory.items[selected].name;
  fetch(`https://${GetParentResourceName()}/useItem`, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({item}) })
    .then(()=> setTimeout(()=> fetch(`https://${GetParentResourceName()}/requestInventory`, {method:'POST', body:'{}'}), 200));
});
dropBtn.addEventListener('click', ()=>{
  if(selected===null) return;
  const item = inventory.items[selected].name;
  const amount = Math.max(1, parseInt(amountInput.value||'1'));
  fetch(`https://${GetParentResourceName()}/dropItem`, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({item, amount}) })
    .then(()=> setTimeout(()=> fetch(`https://${GetParentResourceName()}/requestInventory`, {method:'POST', body:'{}'}), 200));
});
giveBtn.addEventListener('click', ()=>{
  if(selected===null) return;
  const item = inventory.items[selected].name;
  const amount = Math.max(1, parseInt(amountInput.value||'1'));
  const target = Math.max(1, parseInt(targetInput.value||'0'));
  fetch(`https://${GetParentResourceName()}/giveItem`, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({item, amount, target}) })
    .then(()=> setTimeout(()=> fetch(`https://${GetParentResourceName()}/requestInventory`, {method:'POST', body:'{}'}), 200));
});
