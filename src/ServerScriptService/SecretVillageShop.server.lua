-- SECRET VILLAGE SHOP v4
-- Server-authoritative purchases with validation, throttling and rollback protection.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ShopConfig=require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("ShopConfig"))
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local Buy=remotes:FindFirstChild("BuyShopItem") or Instance.new("RemoteEvent")
Buy.Name="BuyShopItem"
Buy.Parent=remotes

local byId={}
for _,item in ipairs(ShopConfig) do
 if type(item)=="table" and type(item.Id)=="string" and #item.Id>0 and #item.Id<=64 and type(item.Price)=="number" and item.Price>=0 and item.Price%1==0 and item.Price<1000000000 then
  byId[item.Id]=item
 end
end

local processing={}
local lastRequest={}

local function notify(p,message)
 if p and p.Parent then Notify:FireClient(p,message) end
end

local function moneyValue(p)
 local ls=p:FindFirstChild("leaderstats")
 local value=ls and ls:FindFirstChild("Money")
 if value and value:IsA("IntValue") and value.Value>=0 then return value end
 return nil
end

local function allowedRequest(p)
 local now=os.clock()
 if now-(lastRequest[p]or 0)<.5 then return false end
 lastRequest[p]=now
 return true
end

local function give(p,id)
 local item=byId[id]
 if not item then return false end
 if id=="MysteryBox" then
  local m=moneyValue(p)
  if not m then return false end
  local prize=math.random(250,2500)
  m.Value+=prize
  notify(p,"🎁 Mystery Box: ты получил $"..prize)
  return true
 end
 if p:GetAttribute("Own_"..id)==true then return false end
 local giver=_G.SecretVillageGiveItem
 if type(giver)~="function" then return false end
 local ok,result=pcall(giver,p,id)
 if not ok or result~=true then return false end
 p:SetAttribute("Own_"..id,true)
 notify(p,"🛍️ Куплено: "..tostring(item.Name or id))
 return true
end

Buy.OnServerEvent:Connect(function(p,id)
 if not p or not p.Parent or processing[p] or not allowedRequest(p) then return end
 if type(id)~="string" or #id==0 or #id>64 then return end
 if p:GetAttribute("CoreLoaded")~=true then notify(p,"⏳ Профиль ещё загружается.");return end
 local item=byId[id]
 local m=moneyValue(p)
 if not item or not m then return end
 if id~="MysteryBox" and p:GetAttribute("Own_"..id)==true then notify(p,"✅ Этот предмет уже у тебя.");return end
 if m.Value<item.Price then notify(p,"❌ Не хватает $"..(item.Price-m.Value)..".");return end

 processing[p]=true
 local before=m.Value
 m.Value=before-item.Price
 local purchased=false
 local ok=pcall(function() purchased=give(p,id) end)
 if not ok or not purchased then
  m.Value=before
  notify(p,"⚠️ Покупка не выполнена. Деньги возвращены.")
 end
 processing[p]=nil
end)

Players.PlayerRemoving:Connect(function(p)
 processing[p]=nil
 lastRequest[p]=nil
end)
