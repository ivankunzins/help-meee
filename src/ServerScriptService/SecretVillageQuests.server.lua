-- SECRET VILLAGE QUESTS v4
-- Repeatable NPC missions with server validation and completion locking.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")

local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_QUESTS") or Instance.new("Folder")
root.Name="SECRET_QUESTS"
root.Parent=Workspace
local Complete=remotes:FindFirstChild("CompleteQuest") or Instance.new("RemoteEvent")
Complete.Name="CompleteQuest"
Complete.Parent=remotes
local questCompleted=ReplicatedStorage:FindFirstChild("SecretVillageQuestCompleted") or Instance.new("BindableEvent")
questCompleted.Name="SecretVillageQuestCompleted"
questCompleted.Parent=ReplicatedStorage

local quests={
 {id="delivery",name="📦 Срочная доставка",text="Отвези посылку к синему терминалу",reward=180,xp=40,target=Vector3.new(100,.5,0)},
 {id="taxi",name="🚕 Пассажир",text="Доставь пассажира к старому дому",reward=300,xp=60,target=Vector3.new(-70,1,-30)},
 {id="explore",name="🔎 Следопыт",text="Найди новый секрет после взятия задания",reward=250,xp=50,target=0},
 {id="fisher",name="🎣 Улов дня",text="Поймай 5 новых рыб",reward=220,xp=45,target=5},
}
local byId={}
for _,q in ipairs(quests) do byId[q.id]=q end
local finishing={}
local promptCooldown={}

local function money(p)
 local l=p:FindFirstChild("leaderstats")
 local m=l and l:FindFirstChild("Money")
 if m and m:IsA("IntValue") and m.Value>=0 then return m end
 return nil
end

local function loaded(p)
 return p:GetAttribute("CoreLoaded")==true
end

local function notify(p,message)
 if p and p.Parent then Notify:FireClient(p,message) end
end

local function npc(name,pos,title,questId)
 local part=Instance.new("Part")
 part.Name=name
 part.Size=Vector3.new(5,7,5)
 part.Position=pos
 part.Anchored=true
 part.Material=Enum.Material.Wood
 part.Parent=root

 local gui=Instance.new("BillboardGui")
 gui.Size=UDim2.fromOffset(280,55)
 gui.StudsOffset=Vector3.new(0,5,0)
 gui.AlwaysOnTop=true
 gui.Parent=part
 local label=Instance.new("TextLabel")
 label.Size=UDim2.fromScale(1,1)
 label.BackgroundTransparency=1
 label.Text=title
 label.TextScaled=true
 label.Font=Enum.Font.GothamBold
 label.Parent=gui

 local prompt=Instance.new("ProximityPrompt")
 prompt.ActionText="Задание"
 prompt.ObjectText=name
 prompt.HoldDuration=.35
 prompt.MaxActivationDistance=12
 prompt.Parent=part
 prompt.Triggered:Connect(function(player)
  if not loaded(player) then notify(player,"⏳ Профиль ещё загружается.");return end
  if finishing[player] then return end
  local active=player:GetAttribute("QuestActive")
  if active and active~="" then notify(player,"📋 Сначала закончи текущее задание.");return end
  local q=byId[questId]
  if not q then return end
  player:SetAttribute("QuestActive",questId)
  player:SetAttribute("QuestProgress",0)
  player:SetAttribute("QuestTarget",q.target)
  player:SetAttribute("QuestStartSecrets",math.max(0,player:GetAttribute("SecretsFound")or 0))
  player:SetAttribute("QuestStartFish",math.max(0,player:GetAttribute("TotalFish")or 0))
  notify(player,q.name.." — "..q.text..". Награда $"..q.reward.." +"..q.xp.." XP")
 end)
end

npc("CourierQuestNPC",Vector3.new(-20,3.5,35),"📦 КУРЬЕР","delivery")
npc("TaxiQuestNPC",Vector3.new(80,3.5,25),"🚕 ДИСПЕТЧЕР","taxi")
npc("ExplorerQuestNPC",Vector3.new(35,3.5,55),"🔎 ИССЛЕДОВАТЕЛЬ","explore")
npc("FishingQuestNPC",Vector3.new(65,3.5,25),"🎣 РЫБОЛОВ","fisher")

local target=Instance.new("Part")
target.Name="DeliveryTarget"
target.Size=Vector3.new(8,.5,8)
target.Position=Vector3.new(100,.5,0)
target.Anchored=true
target.Material=Enum.Material.Neon
target.Transparency=.35
target.Parent=root
local targetPrompt=Instance.new("ProximityPrompt")
targetPrompt.ActionText="Сдать"
targetPrompt.ObjectText="📦 Терминал доставки"
targetPrompt.MaxActivationDistance=12
targetPrompt.Parent=target

local function finish(p,q)
 if finishing[p] then return end
 finishing[p]=true
 local m=money(p)
 if not m then finishing[p]=nil;return end

 -- Clear the quest before granting rewards to prevent concurrent duplicate completion.
 p:SetAttribute("QuestActive","")
 p:SetAttribute("QuestProgress",0)
 p:SetAttribute("QuestTarget",0)
 p:SetAttribute("QuestStartSecrets",nil)
 p:SetAttribute("QuestStartFish",nil)
 p:SetAttribute("QuestXP",math.max(0,p:GetAttribute("QuestXP")or 0)+q.xp)
 m.Value+=q.reward
 questCompleted:Fire(p)
 notify(p,"✅ Задание «"..q.name.."» выполнено! +$"..q.reward.." +"..q.xp.." XP")
 finishing[p]=nil
end

local function tryComplete(p)
 if not p or not p:IsA("Player") or not p.Parent or not loaded(p) then return end
 if finishing[p] then return end
 local id=p:GetAttribute("QuestActive")
 local q=byId[id]
 if not q then return end

 local character=p.Character
 local rootPart=character and character:FindFirstChild("HumanoidRootPart")
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 if not rootPart or not humanoid or humanoid.Health<=0 then return end

 if id=="delivery" then
  if (rootPart.Position-target.Position).Magnitude>14 then notify(p,"📦 Подойди к терминалу доставки.");return end
 elseif id=="taxi" then
  local seat=humanoid.SeatPart
  if not seat or not seat:IsDescendantOf(Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES")) or (rootPart.Position-q.target).Magnitude>16 then
   notify(p,"🚕 Сядь в такси и привези пассажира к старому дому.")
   return
  end
  local model=seat:FindFirstAncestorOfClass("Model")
  if not model or model:GetAttribute("OwnerUserId")~=p.UserId or model:GetAttribute("VehicleType")~="Taxi" then
   notify(p,"🚕 Для задания нужно использовать своё такси.")
   return
  end
 elseif id=="explore" then
  local start=math.max(0,p:GetAttribute("QuestStartSecrets")or 0)
  if (p:GetAttribute("SecretsFound")or 0)<=start then notify(p,"🔎 Найди новый секрет после взятия задания.");return end
  p:SetAttribute("QuestProgress",1)
 elseif id=="fisher" then
  local start=math.max(0,p:GetAttribute("QuestStartFish")or 0)
  local now=math.max(0,p:GetAttribute("TotalFish")or 0)
  if now-start<5 then notify(p,"🎣 Нужно поймать ещё "..math.max(0,5-(now-start)).." рыб.");return end
  p:SetAttribute("QuestProgress",5)
 end
 finish(p,q)
end

Complete.OnServerEvent:Connect(tryComplete)
targetPrompt.Triggered:Connect(function(p)
 local now=os.clock()
 if now-(promptCooldown[p]or 0)<1 then return end
 promptCooldown[p]=now
 tryComplete(p)
end)

Players.PlayerAdded:Connect(function(p)
 if p:GetAttribute("QuestActive")==nil then p:SetAttribute("QuestActive","") end
 if p:GetAttribute("QuestProgress")==nil then p:SetAttribute("QuestProgress",0) end
 if p:GetAttribute("QuestTarget")==nil then p:SetAttribute("QuestTarget",0) end
 p:GetAttributeChangedSignal("TotalFish"):Connect(function()
  if p:GetAttribute("QuestActive")=="fisher" then
   local start=p:GetAttribute("QuestStartFish")or 0
   local now=p:GetAttribute("TotalFish")or 0
   p:SetAttribute("QuestProgress",math.min(5,math.max(0,now-start)))
  end
 end)
 p:GetAttributeChangedSignal("SecretsFound"):Connect(function()
  if p:GetAttribute("QuestActive")=="explore" then
   local start=p:GetAttribute("QuestStartSecrets")or 0
   local now=p:GetAttribute("SecretsFound")or 0
   p:SetAttribute("QuestProgress",now>start and 1 or 0)
  end
 end)
end)

Players.PlayerRemoving:Connect(function(p)
 finishing[p]=nil
 promptCooldown[p]=nil
end)
