-- SECRET VILLAGE ACHIEVEMENTS v1
-- Persistent achievement badges and milestone rewards.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Achievements_v1")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local list={
 {id="first_secret",name="Первый след",desc="Найди первый секрет",need=1,reward=100},
 {id="five_secrets",name="Следопыт",desc="Найди 5 секретов",need=5,reward=300},
 {id="ten_secrets",name="Мастер деревни",desc="Найди 10 секретов",need=10,reward=750},
 {id="three_jobs",name="Работяга",desc="Выполни 3 работы",need=3,reward=400},
 {id="distance",name="Путешественник",desc="Пройди 5000 studs",need=5000,reward=500},
 {id="level10",name="Ветеран",desc="Достигни 10 уровня",need=10,reward=1000},
}
local loaded={}
local function load(p)
 local d={};local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(x)=="table" then d=x end
 loaded[p]=d
end
local function save(p)
 local d=loaded[p];if not d then return end
 pcall(function()Store:SetAsync("u_"..p.UserId,d)end)
end
local function grant(p,a)
 if loaded[p][a.id] then return end
 loaded[p][a.id]=true
 local m=p:FindFirstChild("leaderstats")and p.leaderstats:FindFirstChild("Money");if m then m.Value+=a.reward end
 Notify:FireClient(p,"🏆 ДОСТИЖЕНИЕ: "..a.name.."  +$"..a.reward)
end
local function check(p)
 if not loaded[p] then return end
 local secrets=p:GetAttribute("SecretsFound")or 0
 local jobs=p:GetAttribute("JobsCompleted")or 0
 local dist=p:GetAttribute("LifetimeDistance")or 0
 local level=p:GetAttribute("Level")or 1
 local values={first_secret=secrets,five_secrets=secrets,ten_secrets=secrets,three_jobs=jobs,distance=dist,level10=level}
 for _,a in ipairs(list)do if (values[a.id]or 0)>=a.need then grant(p,a)end end
end
Players.PlayerAdded:Connect(function(p)
 task.spawn(function()load(p);task.wait(2);check(p)
  for _,n in ipairs({"SecretsFound","JobsCompleted","LifetimeDistance","Level"})do p:GetAttributeChangedSignal(n):Connect(function()check(p)end)end
 end)
end)
Players.PlayerRemoving:Connect(function(p)save(p);loaded[p]=nil end)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do task.spawn(save,p)end end end)
game:BindToClose(function()for _,p in ipairs(Players:GetPlayers())do save(p)end end)
