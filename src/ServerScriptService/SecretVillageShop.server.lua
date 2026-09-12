-- Server-authoritative shop. Purchases are validated here; clients never set money.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ShopConfig=require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("ShopConfig"))
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local Buy=remotes:FindFirstChild("BuyShopItem") or Instance.new("RemoteEvent");Buy.Name="BuyShopItem";Buy.Parent=remotes
local byId={};for _,x in ipairs(ShopConfig) do byId[x.Id]=x end
local function notify(p,t)Notify:FireClient(p,t)end
local function give(p,id)
 if id=="MysteryBox" then
  local m=p.leaderstats and p.leaderstats:FindFirstChild("Money");if m then local prize=math.random(250,2500);m.Value+=prize;notify(p,"🎁 Mystery Box: ты получил $"..prize)end;return
 end
 p:SetAttribute("Own_"..id,true)
 local giver=_G.SecretVillageGiveItem
 if giver then giver(p,id) end
 notify(p,"🛍️ Куплено: "..byId[id].Name)
end
Buy.OnServerEvent:Connect(function(p,id)
 if type(id)~="string" then return end
 local item=byId[id];local m=p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Money")
 if not item or not m then return end
 if p:GetAttribute("Own_"..id) then notify(p,"✅ Этот предмет уже у тебя.");return end
 if m.Value<item.Price then notify(p,"❌ Не хватает $"..(item.Price-m.Value)..".");return end
 m.Value-=item.Price;give(p,id)
end)
