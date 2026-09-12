-- SECRET VILLAGE DAILY v2
-- Rotating daily tasks with persistent streak and rewards.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Daily_v2")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local function dayKey()return os.date("!%Y-%m-%d")end
local function load(p)
 local d={Day="",Done=0,Streak=0};local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(x)=="table"then for k in pairs(d)do if x[k]~=nil then d[k]=x[k]end end end
 if d.Day~=dayKey() then d.Day=dayKey();d.Done=0 end
 p:SetAttribute("DailyDone",d.Done);p:SetAttribute("DailyStreak",d.Streak);p:SetAttribute("DailyLoaded",true)
end
local function save(p)
 if not p:GetAttribute("DailyLoaded")then return end
 local d={Day=dayKey(),Done=p:GetAttribute("DailyDone")or 0,Streak=p:GetAttribute("DailyStreak")or 0}
 pcall(function()Store:SetAsync("u_"..p.UserId,d)end)
end
local function reward(p)
 local n=(p:GetAttribute("DailyDone")or 0)+1;p:SetAttribute("DailyDone",n)
 if n>=3 then
  local m=p:FindFirstChild("leaderstats")and p.leaderstats:FindFirstChild("Money");if m then m.Value+=500 end
  p:SetAttribute("DailyStreak",(p:GetAttribute("DailyStreak")or 0)+1)
  Notify:FireClient(p,"🎁 ДНЕВНАЯ ЦЕЛЬ: 3/3! +$500. Серия: "..(p:GetAttribute("DailyStreak")or 0))
 else Notify:FireClient(p,"📅 Дневное задание выполнено: "..n.."/3")end
end
local evt=ReplicatedStorage:FindFirstChild("SecretVillageDailyProgress")or Instance.new("BindableEvent");evt.Name="SecretVillageDailyProgress";evt.Parent=ReplicatedStorage
evt.Event:Connect(function(p)if p and p:IsA("Player")and (p:GetAttribute("DailyDone")or 0)<3 then reward(p)end end)
Players.PlayerAdded:Connect(function(p)task.spawn(function()load(p)end)end)
Players.PlayerRemoving:Connect(save)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do task.spawn(save,p)end end end)
game:BindToClose(function()for _,p in ipairs(Players:GetPlayers())do save(p)end end)
