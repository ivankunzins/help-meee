-- SECRET VILLAGE JOBS v5
-- Concrete job gameplay with shared configuration and server validation.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Config=require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("Config"))
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local BuyFisher=remotes:WaitForChild("BuyFisher")
local root=workspace:FindFirstChild("SECRET_JOBS") or Instance.new("Folder")
root.Name="SECRET_JOBS"
root.Parent=workspace

-- Prevent duplicate NPCs, fishing spots, leaves and prompt connections when
-- the script is accidentally initialized more than once in the same server.
if root:GetAttribute("JobsInitialized")==true then
 return
end
root:SetAttribute("JobsInitialized",true)

local actionCooldown={}

local function notify(p,message)
 if p and p.Parent then Notify:FireClient(p,message) end
end

local function loaded(p)
 return p:GetAttribute("CoreLoaded")==true
end

local function money(p)
 local ls=p:FindFirstChild("leaderstats")
 local m=ls and ls:FindFirstChild("Money")
 if m and m:IsA("IntValue") and m.Value>=0 then return m end
 return nil
end

local function allowedAction(p,key,delaySeconds)
 local now=os.clock()
 actionCooldown[p]=actionCooldown[p] or {}
 local last=actionCooldown[p][key] or 0
 if now-last<delaySeconds then return false end
 actionCooldown[p][key]=now
 return true
end

local function npc(name,pos,text,action)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=Vector3.new(5,7,5)
 p.Position=pos
 p.Anchored=true
 p.Material=Enum.Material.Wood
 p.Parent=root
 local g=Instance.new("BillboardGui")
 g.Size=UDim2.fromOffset(250,50)
 g.StudsOffset=Vector3.new(0,5,0)
 g.AlwaysOnTop=true
 g.Parent=p
 local l=Instance.new("TextLabel")
 l.Size=UDim2.fromScale(1,1)
 l.BackgroundTransparency=1
 l.Text=text
 l.TextScaled=true
 l.Font=Enum.Font.GothamBold
 l.Parent=g
 local q=Instance.new("ProximityPrompt")
 q.ActionText="Работать"
 q.ObjectText=name
 q.HoldDuration=.4
 q.MaxActivationDistance=12
 q.Parent=p
 q.Triggered:Connect(action)
end

npc("JanitorBoss",Vector3.new(-35,3.5,28),"🧹 ДВОРНИК — $100",function(p)
 if not loaded(p) then notify(p,"⏳ Профиль ещё загружается.");return end
 notify(p,"🧹 Нажми кнопку «Работа» слева, чтобы начать смену.")
end)

npc("FisherBoss",Vector3.new(65,3.5,25),"🎣 РЫБАК — $250",function(p)
 if not loaded(p) then notify(p,"⏳ Профиль ещё загружается.");return end
 notify(p,"🎣 Используй кнопку работы после покупки рыбака.")
 BuyFisher:FireClient(p)
end)

for i=1,16 do
 local x=-90+(i*11)%110
 local z=55+math.sin(i)*12
 local spot=Instance.new("Part")
 spot.Name="FishingSpot_"..i
 spot.Size=Vector3.new(3,.5,3)
 spot.Position=Vector3.new(x,.7,z)
 spot.Anchored=true
 spot.Material=Enum.Material.Neon
 spot.Transparency=.45
 spot.Parent=root
 local q=Instance.new("ProximityPrompt")
 q.ActionText="Ловить"
 q.ObjectText="🐟 Рыба"
 q.HoldDuration=1
 q.MaxActivationDistance=10
 q.Parent=spot
 q.Triggered:Connect(function(p)
  if not loaded(p) or p:GetAttribute("JobType")~="fisher" or p:GetAttribute("InJob")~=true then notify(p,"🎣 Сначала устройся рыбаком.");return end
  if not allowedAction(p,"fish",1) then return end
  if spot:GetAttribute("Cooldown") then notify(p,"⏳ Здесь пока не клюёт.");return end
  local m=money(p)
  if not m then return end
  spot:SetAttribute("Cooldown",true)
  m.Value+=Config.FishReward
  p:SetAttribute("TotalFish",math.max(0,p:GetAttribute("TotalFish")or 0)+1)
  notify(p,"🐟 +$"..Config.FishReward)
  task.delay(10,function()
   if spot.Parent then spot:SetAttribute("Cooldown",nil) end
  end)
 end)
end

for i=1,80 do
 local leaf=Instance.new("Part")
 leaf.Name="Leaf_"..i
 leaf.Size=Vector3.new(.8,.15,1.2)
 leaf.Position=Vector3.new(math.random(-105,105),.45,math.random(-105,105))
 leaf.Anchored=true
 leaf.Material=Enum.Material.Grass
 leaf.Parent=root
 local q=Instance.new("ProximityPrompt")
 q.ActionText="Убрать"
 q.ObjectText="🍂 Лист"
 q.HoldDuration=.15
 q.MaxActivationDistance=10
 q.Parent=leaf
 q.Triggered:Connect(function(p)
  if not loaded(p) or p:GetAttribute("JobType")~="janitor" or p:GetAttribute("InJob")~=true then notify(p,"🧹 Сначала начни смену дворника.");return end
  if not allowedAction(p,"leaf",.35) then return end
  if leaf:GetAttribute("Taken") then return end
  local m=money(p)
  if not m then return end
  leaf:SetAttribute("Taken",true)
  leaf.Transparency=1
  q.Enabled=false
  m.Value+=Config.LeafReward
  p:SetAttribute("TotalLeaves",math.max(0,p:GetAttribute("TotalLeaves")or 0)+1)
  notify(p,"🍂 +$"..Config.LeafReward)
  task.delay(20,function()
   if leaf.Parent then
    leaf:SetAttribute("Taken",nil)
    leaf.Transparency=0
    q.Enabled=true
   end
  end)
 end)
end

Players.PlayerRemoving:Connect(function(p)
 actionCooldown[p]=nil
end)
