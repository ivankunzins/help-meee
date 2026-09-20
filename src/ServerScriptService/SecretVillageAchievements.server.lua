-- SECRET VILLAGE ACHIEVEMENTS v2
-- Persistent achievement rewards with safe loading, retries and save locking.
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
local saving={}
local checking={}

local function safeNumber(value,minimum)
 if type(value)~="number" or value~=value or value==math.huge or value==-math.huge then return minimum end
 return math.max(minimum,math.floor(value))
end

local function read(p)
 local ok,data=pcall(function() return Store:GetAsync("u_"..p.UserId) end)
 if not ok then return false,nil end
 return true,type(data)=="table" and data or {}
end

local function load(p)
 if not p or not p.Parent then return end
 local ok,data=read(p)
 if not ok then
  p:SetAttribute("AchievementsLoaded",false)
  warn("[SecretVillageAchievements] Load failed for "..p.Name)
  return
 end
 loaded[p]=data
 p:SetAttribute("AchievementsLoaded",true)
end

local function save(p)
 if not p or not loaded[p] or saving[p] then return false end
 saving[p]=true
 local data=loaded[p]
 local success=false
 for attempt=1,3 do
  local ok=pcall(function()
   Store:UpdateAsync("u_"..p.UserId,function(old)
    old=type(old)=="table" and old or {}
    for key,value in pairs(data) do
     if type(key)=="string" and value==true then old[key]=true end
    end
    return old
   end)
  end)
  if ok then success=true break end
  task.wait(attempt)
 end
 if not success then warn("[SecretVillageAchievements] Save failed for "..p.Name) end
 saving[p]=nil
 return success
end

local function grant(p,a)
 local data=loaded[p]
 if not data or data[a.id] then return end
 data[a.id]=true
 local m=p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Money")
 if m then m.Value+=a.reward end
 if p.Parent then Notify:FireClient(p,"🏆 ДОСТИЖЕНИЕ: "..a.name.."  +$"..a.reward) end
end

local function check(p)
 if not p or not p.Parent or not loaded[p] or checking[p] then return end
 checking[p]=true
 local secrets=safeNumber(p:GetAttribute("SecretsFound"),0)
 local jobs=safeNumber(p:GetAttribute("JobsCompleted"),0)
 local distance=safeNumber(p:GetAttribute("LifetimeDistance"),0)
 local level=safeNumber(p:GetAttribute("Level"),1)
 local values={first_secret=secrets,five_secrets=secrets,ten_secrets=secrets,three_jobs=jobs,distance=distance,level10=level}
 for _,a in ipairs(list) do
  if (values[a.id] or 0)>=a.need then grant(p,a) end
 end
 checking[p]=nil
end

local function onPlayerAdded(p)
 task.spawn(function()
  load(p)
  if not loaded[p] then return end
  task.wait(2)
  check(p)
  for _,attribute in ipairs({"SecretsFound","JobsCompleted","LifetimeDistance","Level"}) do
   p:GetAttributeChangedSignal(attribute):Connect(function() check(p) end)
  end
 end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _,p in ipairs(Players:GetPlayers()) do task.spawn(onPlayerAdded,p) end

Players.PlayerRemoving:Connect(function(p)
 save(p)
 loaded[p]=nil
 saving[p]=nil
 checking[p]=nil
end)

task.spawn(function()
 while true do
  task.wait(120)
  for _,p in ipairs(Players:GetPlayers()) do task.spawn(save,p) end
 end
end)

game:BindToClose(function()
 for _,p in ipairs(Players:GetPlayers()) do save(p) end
end)
