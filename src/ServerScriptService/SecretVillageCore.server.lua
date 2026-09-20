-- SECRET VILLAGE CORE v5
-- Server-authoritative core: safe loading, serialized saves, validation and rate limits.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Config=require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("Config"))
local Store=DataStoreService:GetDataStore("SecretVillage_PlayerData_v4")
local remotes=ReplicatedStorage:FindFirstChild("SecretVillageRemotes") or Instance.new("Folder")
remotes.Name="SecretVillageRemotes";remotes.Parent=ReplicatedStorage
local function remote(name)
 local r=remotes:FindFirstChild(name) or Instance.new("RemoteEvent")
 r.Name=name;r.Parent=remotes;return r
end
local Notify=remote("Notify");local Hint=remote("BuyHint");local StartJob=remote("StartJob");local EndJob=remote("EndJob");local BuyFisher=remote("BuyFisher")
local daily=ReplicatedStorage:FindFirstChild("SecretVillageDailyProgress")
local profiles={};local saving={};local calls={}
local MIN_JOB_SECONDS=5
local JOB_NPC_POSITIONS={janitor=Vector3.new(-35,3.5,28),fisher=Vector3.new(65,3.5,25)}
local JOB_NPC_DISTANCE=20
local function notify(p,t)if p and p.Parent then Notify:FireClient(p,t)end end
local function allowedCall(p,key,delay)
 local now=os.clock();calls[p]=calls[p] or {};local last=calls[p][key] or 0
 if now-last<delay then return false end
 calls[p][key]=now;return true
end
local function stats(p)
 local ls=p:FindFirstChild("leaderstats") or Instance.new("Folder");ls.Name="leaderstats";ls.Parent=p
 local m=ls:FindFirstChild("Money") or Instance.new("IntValue");m.Name="Money";m.Parent=ls
 return m
end
local function default()
 return {Money=Config.StartingMoney,SecretsFound=0,JanitorUnlocked=false,FisherUnlocked=false,TotalLeaves=0,TotalFish=0,Rounds=0,JobsCompleted=0}
end
local function number(v,floor)
 local n=tonumber(v);if not n or n~=n or n==math.huge or n==-math.huge then return floor end
 return math.max(0,math.floor(n))
end
local function load(p)
 local key="u_"..p.UserId;local ok,data=pcall(function()return Store:GetAsync(key)end)
 if not ok then
  warn("[SecretVillage] Data load failed for "..p.UserId..": "..tostring(data))
  p:SetAttribute("CoreLoaded",false);notify(p,"⚠️ Не удалось загрузить прогресс. Перезаходи позже.");return false
 end
 local d=default()
 if type(data)=="table" then
  d.Money=number(data.Money,d.Money);d.SecretsFound=number(data.SecretsFound,0);d.TotalLeaves=number(data.TotalLeaves,0);d.TotalFish=number(data.TotalFish,0);d.Rounds=number(data.Rounds,0);d.JobsCompleted=number(data.JobsCompleted,0)
  d.JanitorUnlocked=data.JanitorUnlocked==true;d.FisherUnlocked=data.FisherUnlocked==true
 end
 profiles[p]=d;stats(p).Value=d.Money
 p:SetAttribute("SecretsFound",d.SecretsFound);p:SetAttribute("TotalLeaves",d.TotalLeaves);p:SetAttribute("TotalFish",d.TotalFish);p:SetAttribute("Rounds",d.Rounds);p:SetAttribute("JobsCompleted",d.JobsCompleted)
 p:SetAttribute("JanitorUnlocked",d.JanitorUnlocked);p:SetAttribute("FisherUnlocked",d.FisherUnlocked);p:SetAttribute("InJob",false);p:SetAttribute("JobType","");p:SetAttribute("RoundSeconds",Config.RoundSeconds);p:SetAttribute("CoreLoaded",true)
 return true
end
local function save(p)
 local d=profiles[p];if not d or not p:GetAttribute("CoreLoaded") or saving[p] then return false end
 saving[p]=true
 d.Money=number(stats(p).Value,Config.StartingMoney);d.SecretsFound=number(p:GetAttribute("SecretsFound"),d.SecretsFound);d.TotalLeaves=number(p:GetAttribute("TotalLeaves"),d.TotalLeaves);d.TotalFish=number(p:GetAttribute("TotalFish"),d.TotalFish);d.Rounds=number(p:GetAttribute("Rounds"),d.Rounds);d.JobsCompleted=number(p:GetAttribute("JobsCompleted"),d.JobsCompleted);d.JanitorUnlocked=p:GetAttribute("JanitorUnlocked")==true;d.FisherUnlocked=p:GetAttribute("FisherUnlocked")==true
 local payload={Money=d.Money,SecretsFound=d.SecretsFound,TotalLeaves=d.TotalLeaves,TotalFish=d.TotalFish,Rounds=d.Rounds,JobsCompleted=d.JobsCompleted,JanitorUnlocked=d.JanitorUnlocked,FisherUnlocked=d.FisherUnlocked,SchemaVersion=4}
 local success=false
 for attempt=1,3 do
  local ok,err=pcall(function()Store:UpdateAsync("u_"..p.UserId,function(old)
   old=type(old)=="table" and old or {};for k,v in pairs(payload)do old[k]=v end;return old
  end)end)
  if ok then success=true;break end
  warn("[SecretVillage] Save attempt "..attempt.." failed for "..p.UserId..": "..tostring(err));task.wait(attempt)
 end
 saving[p]=nil;return success
end
local function nearJobNpc(p,kind)
 local position=JOB_NPC_POSITIONS[kind]
 local character=p.Character
 local rootPart=character and character:FindFirstChild("HumanoidRootPart")
 if not position or not rootPart then return false end
 return (rootPart.Position-position).Magnitude<=JOB_NPC_DISTANCE
end
local function beginJob(p,kind)
 if not profiles[p] or not p:GetAttribute("CoreLoaded") or not allowedCall(p,"beginJob",1) then return end
 if not nearJobNpc(p,kind) then notify(p,"📍 Подойди к NPC, чтобы начать работу.");return end
 local m=stats(p);if p:GetAttribute("InJob")then notify(p,"🛑 Сначала закончи текущую смену.");return end
 if kind~="fisher" and kind~="janitor" then return end
 local cost=kind=="fisher" and Config.FisherCost or Config.JanitorCost
 local attr=kind=="fisher" and "FisherUnlocked" or "JanitorUnlocked"
 local title=kind=="fisher" and "🎣 Рыбак" or "🧹 Дворник"
 if not p:GetAttribute(attr) then
  if m.Value<cost then notify(p,"❌ Нужно $"..cost..".");return end
  m.Value-=cost;p:SetAttribute(attr,true)
 end
 p:SetAttribute("InJob",true);p:SetAttribute("JobType",kind);p:SetAttribute("JobStarted",os.time());notify(p,title.." — смена началась. ⏸️ Твой таймер остановлен.");save(p)
end
StartJob.OnServerEvent:Connect(function(p)beginJob(p,"janitor")end)
BuyFisher.OnServerEvent:Connect(function(p)beginJob(p,"fisher")end)
EndJob.OnServerEvent:Connect(function(p)
 if not profiles[p] or not p:GetAttribute("CoreLoaded") then return end
 if not allowedCall(p,"endJob",1) or not p:GetAttribute("InJob") then return end
 local started=tonumber(p:GetAttribute("JobStarted")) or 0
 if os.time()-started<MIN_JOB_SECONDS then notify(p,"⏳ Смена должна длиться минимум "..MIN_JOB_SECONDS.." секунд.");return end
 p:SetAttribute("InJob",false);p:SetAttribute("JobType","");p:SetAttribute("JobsCompleted",(p:GetAttribute("JobsCompleted")or 0)+1);notify(p,"✅ Смена закончена. Таймер снова идёт.");if daily then daily:Fire(p)end;save(p)
end)
Hint.OnServerEvent:Connect(function(p)
 if not allowedCall(p,"hint",2) or not profiles[p] or not p:GetAttribute("CoreLoaded") then return end
 local m=stats(p);if m.Value<Config.HintCost then notify(p,"❌ Нужно $"..Config.HintCost..".");return end
 m.Value-=Config.HintCost;notify(p,"🔎 Подсказка: "..Config.FoodSellerHint);save(p)
end)
Players.PlayerAdded:Connect(function(p)
 if load(p) then task.defer(function()notify(p,"🏘️ Добро пожаловать! У тебя 30 минут. Найди первый секрет.")end)end
end)
Players.PlayerRemoving:Connect(function(p)save(p);profiles[p]=nil;calls[p]=nil;saving[p]=nil end)
task.spawn(function()
 while true do task.wait(1)
  for p in pairs(profiles)do
   if p.Parent and p:GetAttribute("CoreLoaded") and not p:GetAttribute("InJob") then
    local n=math.max(0,(p:GetAttribute("RoundSeconds")or Config.RoundSeconds)-1);p:SetAttribute("RoundSeconds",n)
    if n<=0 then
     local r=(p:GetAttribute("Rounds")or 0)+1;p:SetAttribute("Rounds",r);p:SetAttribute("RoundSeconds",Config.RoundSeconds);p:SetAttribute("InJob",false);p:SetAttribute("JobType","")
     if p.Character then p.Character:PivotTo(CFrame.new(0,5,0))end
     notify(p,"⏰ 30 минут закончились. Раунд №"..r.." завершён, прогресс сохранён.");if daily then daily:Fire(p)end;save(p)
    end
   end
  end
 end
end)
task.spawn(function()while true do task.wait(120);for p in pairs(profiles)do if p.Parent then task.spawn(save,p)end end end end)
game:BindToClose(function()for p in pairs(profiles)do save(p)end end)