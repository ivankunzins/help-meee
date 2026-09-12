-- SECRET VILLAGE CORE v3
-- Single authoritative controller for money, personal timer, jobs and core persistence.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Config=require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("Config"))
local Store=DataStoreService:GetDataStore("SecretVillage_PlayerData_v3")
local remotes=ReplicatedStorage:FindFirstChild("SecretVillageRemotes")or Instance.new("Folder");remotes.Name="SecretVillageRemotes";remotes.Parent=ReplicatedStorage
local function remote(name)local r=remotes:FindFirstChild(name)or Instance.new("RemoteEvent");r.Name=name;r.Parent=remotes;return r end
local Notify=remote("Notify");local Hint=remote("BuyHint");local StartJob=remote("StartJob");local EndJob=remote("EndJob");local BuyFisher=remote("BuyFisher")
local daily=ReplicatedStorage:FindFirstChild("SecretVillageDailyProgress")
local profiles={}
local function notify(p,t)if p and p.Parent then Notify:FireClient(p,t)end end
local function stats(p)local ls=p:FindFirstChild("leaderstats")or Instance.new("Folder");ls.Name="leaderstats";ls.Parent=p;local m=ls:FindFirstChild("Money")or Instance.new("IntValue");m.Name="Money";m.Parent=ls;return m end
local function default()return{Money=Config.StartingMoney,SecretsFound=0,JanitorUnlocked=false,FisherUnlocked=false,TotalLeaves=0,TotalFish=0,Rounds=0}end
local function load(p)
 local d=default();local ok,data=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(data)=="table"then for k in pairs(d)do if data[k]~=nil then d[k]=data[k]end end end
 profiles[p]=d;stats(p).Value=math.max(0,tonumber(d.Money)or Config.StartingMoney)
 p:SetAttribute("SecretsFound",tonumber(d.SecretsFound)or 0);p:SetAttribute("TotalLeaves",tonumber(d.TotalLeaves)or 0);p:SetAttribute("TotalFish",tonumber(d.TotalFish)or 0);p:SetAttribute("Rounds",tonumber(d.Rounds)or 0);p:SetAttribute("JanitorUnlocked",d.JanitorUnlocked==true);p:SetAttribute("FisherUnlocked",d.FisherUnlocked==true);p:SetAttribute("InJob",false);p:SetAttribute("JobType","");p:SetAttribute("RoundSeconds",Config.RoundSeconds);p:SetAttribute("CoreLoaded",true)
end
local function save(p)
 local d=profiles[p];if not d or not p:GetAttribute("CoreLoaded")then return end
 d.Money=stats(p).Value;d.SecretsFound=p:GetAttribute("SecretsFound")or d.SecretsFound;d.TotalLeaves=p:GetAttribute("TotalLeaves")or d.TotalLeaves;d.TotalFish=p:GetAttribute("TotalFish")or d.TotalFish;d.Rounds=p:GetAttribute("Rounds")or d.Rounds;d.JanitorUnlocked=p:GetAttribute("JanitorUnlocked")==true;d.FisherUnlocked=p:GetAttribute("FisherUnlocked")==true
 for attempt=1,3 do local ok=pcall(function()Store:UpdateAsync("u_"..p.UserId,function()return d end)end);if ok then return end;task.wait(attempt)end
end
local function beginJob(p,kind)
 local d=profiles[p];local m=stats(p);if not d then return end
 if p:GetAttribute("InJob")then notify(p,"🛑 Сначала закончи текущую смену.");return end
 local cost,attr,title=kind=="fisher"and Config.FisherCost or Config.JanitorCost,kind=="fisher"and"FisherUnlocked"or"JanitorUnlocked",kind=="fisher"and"🎣 Рыбак"or"🧹 Дворник"
 if not p:GetAttribute(attr)then if m.Value<cost then notify(p,"❌ Нужно $"..cost..".");return end;m.Value-=cost;p:SetAttribute(attr,true);save(p)end
 p:SetAttribute("InJob",true);p:SetAttribute("JobType",kind);p:SetAttribute("JobStarted",os.time());notify(p,title.." — смена началась. ⏸️ Твой таймер остановлен.")
end
StartJob.OnServerEvent:Connect(function(p)beginJob(p,"janitor")end)
BuyFisher.OnServerEvent:Connect(function(p)beginJob(p,"fisher")end)
EndJob.OnServerEvent:Connect(function(p)
 if not p:GetAttribute("InJob")then return end
 p:SetAttribute("InJob",false);p:SetAttribute("JobType","");p:SetAttribute("JobsCompleted",(p:GetAttribute("JobsCompleted")or 0)+1);notify(p,"✅ Смена закончена. Таймер снова идёт.");if daily then daily:Fire(p)end;save(p)
end)
Hint.OnServerEvent:Connect(function(p)
 local m=stats(p);if m.Value<Config.HintCost then notify(p,"❌ Нужно $"..Config.HintCost..".");return end
 m.Value-=Config.HintCost;notify(p,"🔎 Подсказка: "..Config.FoodSellerHint);save(p)
end)
Players.PlayerAdded:Connect(function(p)load(p);task.defer(function()notify(p,"🏘️ Добро пожаловать! У тебя 30 минут. Найди первый секрет.")end)end)
Players.PlayerRemoving:Connect(function(p)save(p);profiles[p]=nil end)
task.spawn(function()while true do task.wait(1);for p in pairs(profiles)do if p.Parent and not p:GetAttribute("InJob")then local n=math.max(0,(p:GetAttribute("RoundSeconds")or Config.RoundSeconds)-1);p:SetAttribute("RoundSeconds",n);if n<=0 then local r=(p:GetAttribute("Rounds")or 0)+1;p:SetAttribute("Rounds",r);p:SetAttribute("RoundSeconds",Config.RoundSeconds);p:SetAttribute("InJob",false);p:SetAttribute("JobType","");if p.Character then p.Character:PivotTo(CFrame.new(0,5,0))end;notify(p,"⏰ 30 минут закончились. Раунд №"..r.." завершён, прогресс сохранён.");if daily then daily:Fire(p)end;save(p)end end end end end)
task.spawn(function()while true do task.wait(120);for p in pairs(profiles)do if p.Parent then task.spawn(save,p)end end end end)
game:BindToClose(function()for p in pairs(profiles)do save(p)end end)
