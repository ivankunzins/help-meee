-- SECRET VILLAGE PROGRESSION v2
-- Persistent XP, level and lifetime mission statistics.
-- Quest completion is counted through an explicit server-side event, never by guessing from XP changes.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Progression_v2")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local questCompleted=ReplicatedStorage:FindFirstChild("SecretVillageQuestCompleted") or Instance.new("BindableEvent")
questCompleted.Name="SecretVillageQuestCompleted";questCompleted.Parent=ReplicatedStorage
local function levelFor(xp)return math.floor((xp or 0)/100)+1 end
local function load(p)
 local d={XP=0,Quests=0,Distance=0}
 local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(x)=="table" then for k,v in pairs(d)do if type(x[k])=="number" then d[k]=x[k] end end end
 p:SetAttribute("QuestXP",d.XP);p:SetAttribute("QuestsCompleted",d.Quests);p:SetAttribute("LifetimeDistance",d.Distance);p:SetAttribute("Level",levelFor(d.XP));p:SetAttribute("ProgressionLoaded",true)
 p:GetAttributeChangedSignal("QuestXP"):Connect(function()
  local xp=p:GetAttribute("QuestXP")or 0;local old=p:GetAttribute("Level")or 1;local new=levelFor(xp);p:SetAttribute("Level",new)
  if new>old then Notify:FireClient(p,"⭐ НОВЫЙ УРОВЕНЬ! Уровень "..new..".") end
 end)
end
local function save(p)
 if not p:GetAttribute("ProgressionLoaded") then return end
 local d={XP=p:GetAttribute("QuestXP")or 0,Quests=p:GetAttribute("QuestsCompleted")or 0,Distance=p:GetAttribute("LifetimeDistance")or 0}
 for attempt=1,3 do
  local ok=pcall(function()Store:UpdateAsync("u_"..p.UserId,function(old)
   old=type(old)=="table" and old or {};old.XP=d.XP;old.Quests=d.Quests;old.Distance=d.Distance;return old
  end)end)
  if ok then return end
  task.wait(attempt)
 end
end
questCompleted.Event:Connect(function(p)
 if not p or not p:IsA("Player") then return end
 p:SetAttribute("QuestsCompleted",(p:GetAttribute("QuestsCompleted")or 0)+1)
end)
Players.PlayerAdded:Connect(function(p)task.spawn(load,p)end)
Players.PlayerRemoving:Connect(save)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do task.spawn(save,p)end end end)
game:BindToClose(function()for _,p in ipairs(Players:GetPlayers())do save(p)end end)
