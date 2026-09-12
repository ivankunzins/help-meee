-- SECRET VILLAGE PROGRESSION v3
-- Persistent XP, levels, quest count and lifetime distance with legacy migration.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Progression_v3")
local Legacy=DataStoreService:GetDataStore("SecretVillage_Progression_v1")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes");local Notify=remotes:WaitForChild("Notify")
local event=ReplicatedStorage:FindFirstChild("SecretVillageQuestCompleted")or Instance.new("BindableEvent");event.Name="SecretVillageQuestCompleted";event.Parent=ReplicatedStorage
local function level(x)return math.floor((x or 0)/100)+1 end
local function load(p)
 local d={XP=0,Quests=0,Distance=0};local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(x)=="table"then for k in pairs(d)do if type(x[k])=="number"then d[k]=x[k]end end
 else
  local okOld,old=pcall(function()return Legacy:GetAsync("u_"..p.UserId)end)
  if okOld and type(old)=="table"then for k in pairs(d)do if type(old[k])=="number"then d[k]=old[k]end end end
 end
 p:SetAttribute("QuestXP",d.XP);p:SetAttribute("QuestsCompleted",d.Quests);p:SetAttribute("LifetimeDistance",d.Distance);p:SetAttribute("Level",level(d.XP));p:SetAttribute("ProgressionLoaded",true)
 p:GetAttributeChangedSignal("QuestXP"):Connect(function()local n=level(p:GetAttribute("QuestXP")or 0);local oldLevel=p:GetAttribute("Level")or 1;p:SetAttribute("Level",n);if n>oldLevel then Notify:FireClient(p,"⭐ НОВЫЙ УРОВЕНЬ! Уровень "..n..".")end end)
end
local function save(p)
 if not p:GetAttribute("ProgressionLoaded")then return end
 local d={XP=p:GetAttribute("QuestXP")or 0,Quests=p:GetAttribute("QuestsCompleted")or 0,Distance=p:GetAttribute("LifetimeDistance")or 0}
 for attempt=1,3 do local ok=pcall(function()Store:UpdateAsync("u_"..p.UserId,function(old)old=type(old)=="table"and old or{};old.XP=d.XP;old.Quests=d.Quests;old.Distance=d.Distance;return old end)end);if ok then return end;task.wait(attempt)end
end
event.Event:Connect(function(p)if p and p:IsA("Player")then p:SetAttribute("QuestsCompleted",(p:GetAttribute("QuestsCompleted")or 0)+1)end end)
Players.PlayerAdded:Connect(function(p)task.spawn(load,p)end)
Players.PlayerRemoving:Connect(save)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do task.spawn(save,p)end end end)
game:BindToClose(function()for _,p in ipairs(Players:GetPlayers())do save(p)end end)
