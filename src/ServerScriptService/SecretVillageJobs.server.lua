-- SECRET VILLAGE JOBS v3
-- Concrete job gameplay. Core owns job state and unlock costs.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local BuyFisher=remotes:WaitForChild("BuyFisher")
local root=workspace:FindFirstChild("SECRET_JOBS") or Instance.new("Folder");root.Name="SECRET_JOBS";root.Parent=workspace
local function money(p)local ls=p:FindFirstChild("leaderstats");return ls and ls:FindFirstChild("Money")end
local function npc(name,pos,text,action)
 local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(5,7,5);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Wood;p.Parent=root
 local g=Instance.new("BillboardGui");g.Size=UDim2.fromOffset(250,50);g.StudsOffset=Vector3.new(0,5,0);g.AlwaysOnTop=true;g.Parent=p
 local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=g
 local q=Instance.new("ProximityPrompt");q.ActionText="Работать";q.ObjectText=name;q.HoldDuration=.4;q.Parent=p;q.Triggered:Connect(action)
end
npc("JanitorBoss",Vector3.new(-35,3.5,28),"🧹 ДВОРНИК — $100",function(p)Notify:FireClient(p,"🧹 Нажми кнопку «Работа» слева, чтобы начать смену.")end)
npc("FisherBoss",Vector3.new(65,3.5,25),"🎣 РЫБАК — $250",function(p)Notify:FireClient(p,"🎣 Используй кнопку работы после покупки рыбака.");BuyFisher:FireClient(p)end)
for i=1,16 do
 local x=-90+(i*11)%110;local z=55+math.sin(i)*12
 local spot=Instance.new("Part");spot.Name="FishingSpot_"..i;spot.Size=Vector3.new(3,.5,3);spot.Position=Vector3.new(x,.7,z);spot.Anchored=true;spot.Material=Enum.Material.Neon;spot.Transparency=.45;spot.Parent=root
 local q=Instance.new("ProximityPrompt");q.ActionText="Ловить";q.ObjectText="🐟 Рыба";q.HoldDuration=1;q.Parent=spot
 q.Triggered:Connect(function(p)
  if p:GetAttribute("JobType")~="fisher" or not p:GetAttribute("InJob") then Notify:FireClient(p,"🎣 Сначала устройся рыбаком.");return end
  if spot:GetAttribute("Cooldown") then Notify:FireClient(p,"⏳ Здесь пока не клюёт.");return end
  spot:SetAttribute("Cooldown",true);local m=money(p);if m then m.Value+=8 end;p:SetAttribute("TotalFish",(p:GetAttribute("TotalFish")or 0)+1);Notify:FireClient(p,"🐟 +$8");task.delay(10,function()spot:SetAttribute("Cooldown",nil)end)
 end)
end
for i=1,80 do
 local leaf=Instance.new("Part");leaf.Name="Leaf_"..i;leaf.Size=Vector3.new(.8,.15,1.2);leaf.Position=Vector3.new(math.random(-105,105),.45,math.random(-105,105));leaf.Anchored=true;leaf.Material=Enum.Material.Grass;leaf.Parent=root
 local q=Instance.new("ProximityPrompt");q.ActionText="Убрать";q.ObjectText="🍂 Лист";q.HoldDuration=.15;q.Parent=leaf
 q.Triggered:Connect(function(p)
  if p:GetAttribute("JobType")~="janitor" or not p:GetAttribute("InJob") then Notify:FireClient(p,"🧹 Сначала начни смену дворника.");return end
  if leaf:GetAttribute("Taken") then return end
  leaf:SetAttribute("Taken",true);leaf.Transparency=1;q.Enabled=false
  local m=money(p);if m then m.Value+=1 end;p:SetAttribute("TotalLeaves",(p:GetAttribute("TotalLeaves")or 0)+1);Notify:FireClient(p,"🍂 +$1")
  task.delay(20,function()if leaf.Parent then leaf:SetAttribute("Taken",nil);leaf.Transparency=0;q.Enabled=true end end)
 end)
end
