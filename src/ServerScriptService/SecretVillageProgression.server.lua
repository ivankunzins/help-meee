-- SECRET VILLAGE PROGRESSION v5
-- Persistent XP, levels, quest count and lifetime distance with migration and safe saving.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")

local Store=DataStoreService:GetDataStore("SecretVillage_Progression_v3")
local Legacy=DataStoreService:GetDataStore("SecretVillage_Progression_v1")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local event=ReplicatedStorage:FindFirstChild("SecretVillageQuestCompleted") or Instance.new("BindableEvent")
event.Name="SecretVillageQuestCompleted"
event.Parent=ReplicatedStorage

local loaded={}
local saving={}
local pendingCompletions={}
local connections={}

local function safeNumber(value,minimum)
 if type(value)~="number" or value~=value or value==math.huge or value==-math.huge then return minimum end
 return math.max(minimum,math.floor(value))
end

local function level(x)
 return math.floor(safeNumber(x,0)/100)+1
end

local function readData(store,key)
 local ok,data=pcall(function() return store:GetAsync(key) end)
 return ok,data
end

local function bindLevelUpdates(player)
 if connections[player] then connections[player]:Disconnect() end
 connections[player]=player:GetAttributeChangedSignal("QuestXP"):Connect(function()
  if not player.Parent then return end
  local newLevel=level(player:GetAttribute("QuestXP"))
  local oldLevel=safeNumber(player:GetAttribute("Level"),1)
  player:SetAttribute("Level",newLevel)
  if newLevel>oldLevel then Notify:FireClient(player,"⭐ НОВЫЙ УРОВЕНЬ! Уровень "..newLevel..".") end
 end)
end

local function load(player)
 if not player or not player.Parent then return end
 local key="u_"..player.UserId
 local ok,data=readData(Store,key)
 if not ok then
  warn("[SecretVillageProgression] Load failed for "..player.Name)
  player:SetAttribute("ProgressionLoaded",false)
  return
 end
 if type(data)~="table" then
  local oldOk,oldData=readData(Legacy,key)
  data=(oldOk and type(oldData)=="table") and oldData or {}
 end

 local xp=safeNumber(data.XP,0)
 local quests=safeNumber(data.Quests,0)
 local distance=safeNumber(data.Distance,0)
 local queued=safeNumber(pendingCompletions[player],0)
 pendingCompletions[player]=nil
 quests+=queued

 player:SetAttribute("QuestXP",xp)
 player:SetAttribute("QuestsCompleted",quests)
 player:SetAttribute("LifetimeDistance",distance)
 player:SetAttribute("Level",level(xp))
 player:SetAttribute("ProgressionLoaded",true)
 loaded[player]=true
 bindLevelUpdates(player)
end

local function save(player)
 if not player or not player.Parent or not loaded[player] or saving[player] then return false end
 saving[player]=true
 local data={
  XP=safeNumber(player:GetAttribute("QuestXP"),0),
  Quests=safeNumber(player:GetAttribute("QuestsCompleted"),0),
  Distance=safeNumber(player:GetAttribute("LifetimeDistance"),0),
 }
 local success=false
 for attempt=1,3 do
  local ok=pcall(function()
   Store:UpdateAsync("u_"..player.UserId,function(old)
    old=type(old)=="table" and old or {}
    old.XP=data.XP
    old.Quests=data.Quests
    old.Distance=data.Distance
    return old
   end)
  end)
  if ok then success=true;break end
  task.wait(attempt)
 end
 if not success then warn("[SecretVillageProgression] Save failed for "..player.Name) end
 saving[player]=nil
 return success
end

event.Event:Connect(function(player)
 if not player or not player:IsA("Player") then return end
 if loaded[player] and player.Parent then
  player:SetAttribute("QuestsCompleted",safeNumber(player:GetAttribute("QuestsCompleted"),0)+1)
 else
  pendingCompletions[player]=safeNumber(pendingCompletions[player],0)+1
 end
end)

local function onPlayerAdded(player)
 if not player or not player.Parent then return end
 task.spawn(load,player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _,player in ipairs(Players:GetPlayers()) do
 task.spawn(onPlayerAdded,player)
end

Players.PlayerRemoving:Connect(function(player)
 save(player)
 if connections[player] then connections[player]:Disconnect() end
 connections[player]=nil
 loaded[player]=nil
 saving[player]=nil
 pendingCompletions[player]=nil
end)

task.spawn(function()
 while true do
  task.wait(120)
  for _,player in ipairs(Players:GetPlayers()) do task.spawn(save,player) end
 end
end)

game:BindToClose(function()
 for _,player in ipairs(Players:GetPlayers()) do save(player) end
end)
