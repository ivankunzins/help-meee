-- SECRET VILLAGE economy: food, shop, courier and daily challenge foundations.

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_ECONOMY") or Instance.new("Folder")
root.Name="SECRET_ECONOMY";root.Parent=Workspace

local function notify(p,t) Notify:FireClient(p,t) end
local function money(p)
 local ls=p:FindFirstChild("leaderstats");return ls and ls:FindFirstChild("Money")
end
local function npc(name,pos,text,action)
 local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(5,7,5);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Wood;p.Parent=root
 local g=Instance.new("BillboardGui");g.Size=UDim2.fromOffset(240,50);g.StudsOffset=Vector3.new(0,5,0);g.AlwaysOnTop=true;g.Parent=p
 local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=g
 local pr=Instance.new("ProximityPrompt");pr.ActionText="Взаимодействовать";pr.ObjectText=name;pr.Parent=p;pr.Triggered:Connect(action)
end

-- Food pickups spawn around the village and can be sold to the food seller.
local food=Instance.new("Folder");food.Name="FoodPickups";food.Parent=root
local types={{"Apple",15},{"Bread",25},{"Carrot",10},{"Fish",40},{"Mushroom",30}}
for i=1,30 do
 local item=types[math.random(1,#types)]
 local p=Instance.new("Part");p.Name=item[1];p.Size=Vector3.new(1.5,1.5,1.5);p.Position=Vector3.new(math.random(-105,105),1,math.random(-105,105));p.Anchored=true;p.Material=Enum.Material.SmoothPlastic;p.Parent=food
 local pr=Instance.new("ProximityPrompt");pr.ActionText="Подобрать";pr.ObjectText=item[1];pr.HoldDuration=.15;pr.Parent=p
 pr.Triggered:Connect(function(player)
  if p:GetAttribute("Taken") then return end
  p:SetAttribute("Taken",true);p.Transparency=1;pr.Enabled=false
  player:SetAttribute("FoodCount",(player:GetAttribute("FoodCount") or 0)+1)
  player:SetAttribute("FoodValue",(player:GetAttribute("FoodValue") or 0)+item[2])
  notify(player,"🍎 Найдено: "..item[1].." (ценность $"..item[2]..")")
 end)
end

npc("FoodSeller",Vector3.new(20,3.5,35),"🍎 FOOD SELLER",function(p)
 local count=p:GetAttribute("FoodCount") or 0;local value=p:GetAttribute("FoodValue") or 0
 if count<=0 then notify(p,"🍎 У тебя нет еды для продажи.");return end
 local m=money(p);if m then m.Value+=value end
 p:SetAttribute("FoodCount",0);p:SetAttribute("FoodValue",0)
 notify(p,string.format("💰 Еда продана: %d шт. +$%d",count,value))
end)

npc("CourierBoss",Vector3.new(-20,3.5,35),"📦 COURIER JOB",function(p)
 local m=money(p);if not m or m.Value<150 then notify(p,"📦 Чтобы начать работу курьера, нужно $150.");return end
 m.Value-=150
 p:SetAttribute("CourierActive",true)
 notify(p,"📦 Заказ получен! Добеги до синей точки доставки.")
end)

local delivery=Instance.new("Part");delivery.Name="DeliveryPoint";delivery.Size=Vector3.new(8,.5,8);delivery.Position=Vector3.new(100,.5,0);delivery.Anchored=true;delivery.Material=Enum.Material.Neon;delivery.Transparency=.3;delivery.Parent=root
local dp=Instance.new("ProximityPrompt");dp.ActionText="Доставить";dp.ObjectText="📦 Заказ";dp.Parent=delivery
dp.Triggered:Connect(function(p)
 if not p:GetAttribute("CourierActive") then notify(p,"📦 У тебя нет заказа.");return end
 p:SetAttribute("CourierActive",false);local m=money(p);if m then m.Value+=100 end;notify(p,"✅ Доставка выполнена! +$100")
end)

-- Daily challenge rotates once per server day.
local challenge=Instance.new("StringValue");challenge.Name="DailyChallenge";challenge.Value="Найди 3 секрета";challenge.Parent=Workspace
Players.PlayerAdded:Connect(function(p)
 p:SetAttribute("DailyProgress",0)
end)
