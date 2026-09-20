-- SECRET VILLAGE DAILY v3
-- Rotating daily tasks with persistent streak, safe loading and reliable saving.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Daily_v2")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local function dayKey()return os.date("!%Y-%m-%d")end
local function load(p)
 if not p or not p.Parent then return false end
 local d={Day="",Done=0,Streak=0}
 local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if not ok then
  p:SetAttribute("DailyLoaded",false)
  warn("[SecretVillageDaily] Load failed for "..p.Name)
  return false
 end
 if type(x)=="table"then
  if type(x.Day)=="string"then d.Day=x.Day end
  if type(x.Done)=="number"then d.Done=math.clamp(math.floor(x.Done),0,3)end
  if type(x.Streak)=="number"then d.Streak=math.max(0,math.floor(x.Streak))end
 end
 if d.Day~=dayKey() then d.Day=dayKey();d.Done=0 end
 p:SetAttribute("DailyDone",d.Done)
 p:SetAttribute("DailyStreak",d.Streak)
 p:SetAttribute("DailyLoaded",true)
 return true
end
local function save(p)
 if not p or not p.Parent or not p:GetAttribute("DailyLoaded")then return false end
 local d={Day=dayKey(),Done=math.clamp(math.floor(tonumber(p:GetAttribute("DailyDone"))or 0),0,3),Streak=math.max(0,math.floor(tonumber(p:GetAttribute("DailyStreak"))or 0))}
 for attempt=1,3 do
  local ok=pcall(function()
   Store:UpdateAsync("u_"..p.UserId,function(old)
    old=type(old)=="table" and old or {}
    old.Day=d.Day;old.Done=d.Done;old.Streak=d.Streak
    return old
   end)
  end)
  if ok then return true end
  task.wait(attempt)
 end
 warn("[SecretVillageDaily] Save failed for "..p.Name)
 return false
end
local function reward(p)
 if not p or not p.Parent or not p:GetAttribute("DailyLoaded") then return end
 local current=math.clamp(math.floor(tonumber(p:GetAttribute("DailyDone"))or 0),0,3)
 if current>=3 then return end
 local n=current+1
 p:SetAttribute("DailyDone",n)
 if n>=3 then
  local m=p:FindFirstChild("leaderstats")and p.leaderstats:FindFirstChild("Money")
  if m then m.Value+=500 end
  p:SetAttribute("DailyStreak",math.max(0,math.floor(tonumber(p:GetAttribute("DailyStreak"))or 0))+1)
  Notify:FireClient(p,"🎁 ДНЕВНАЯ ЦЕЛЬ: 3/3! +$500. Серия: "..(p:GetAttribute("DailyStreak")or 0))
 else
  Notify:FireClient(p,"📅 Дневное задание выполнено: "..n.."/3")
 end
end
local evt=ReplicatedStorage:FindFirstChild("SecretVillageDailyProgress")or Instance.new("BindableEvent")
evt.Name="SecretVillageDailyProgress";evt.Parent=ReplicatedStorage
evt.Event:Connect(function(p)
 if p and p:IsA("Player") then reward(p) end
end)
Players.PlayerAdded:Connect(function(p)task.spawn(load,p)end)
for _,p in ipairs(Players:GetPlayers())do task.spawn(load,p)end
Players.PlayerRemoving:Connect(save)
task.spawn(function()
 while true do
  task.wait(120)
  for _,p in ipairs(Players:GetPlayers())do task.spawn(save,p)end
 end
end)
game:BindToClose(function()
 for _,p in ipairs(Players:GetPlayers())do save(p)end
end)
