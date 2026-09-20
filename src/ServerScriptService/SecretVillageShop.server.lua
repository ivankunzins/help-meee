-- SECRET VILLAGE SHOP v2
-- Server-authoritative purchases. The client only supplies an item ID.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ShopConfig=require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("ShopConfig"))
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local Buy=remotes:FindFirstChild("BuyShopItem") or Instance.new("RemoteEvent")
Buy.Name="BuyShopItem";Buy.Parent=remotes
local byId={}
for _,item in ipairs(ShopConfig) do
 if type(item)=="table" and type(item.Id)=="string" and type(item.Price)=="number" and item.Price>=0 then byId[item.Id]=item end
end
local processing={}
local function notify(p,text)if p and p.Parent then Notify:FireClient(p,text)end end
local function moneyValue(p)
 local ls=p:FindFirstChild("leaderstats")
 return ls and ls:FindFirstChild("Money")
end
local function give(p,id)
 if id=="MysteryBox" then
  local m=moneyValue(p)
  if not m then return false end
  local prize=math.random(250,2500)
  m.Value+=prize
  notify(p,"🎁 Mystery Box: ты получил $"..prize)
  return true
 end
 if p:GetAttribute("Own_"..id) then return false end
 p:SetAttribute("Own_"..id,true)
 local giver=_G.SecretVillageGiveItem
 if giver then giver(p,id) end
 notify(p,"🛍️ Куплено: "..tostring(byId[id].Name))
 return true
end
Buy.OnServerEvent:Connect(function(p,id)
 if processing[p] or type(id)~="string" or #id>64 then return end
 if not p:GetAttribute("CoreLoaded") then return end
 local item=byId[id];local m=moneyValue(p)
 if not item or not m or m.Value<0 then return end
 if id~="MysteryBox" and p:GetAttribute("Own_"..id) then notify(p,"✅ Этот предмет уже у тебя.");return end
 if m.Value<item.Price then notify(p,"❌ Не хватает $"..(item.Price-m.Value)..".");return end
 processing[p]=true
 local purchased=false
 if id=="MysteryBox" then
  m.Value-=item.Price
  purchased=give(p,id)
 else
  m.Value-=item.Price
  purchased=give(p,id)
 end
 if not purchased then m.Value+=item.Price end
 processing[p]=nil
end)
Players.PlayerRemoving:Connect(function(p)processing[p]=nil end)
