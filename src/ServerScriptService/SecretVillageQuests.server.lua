-- SECRET VILLAGE QUESTS v3
-- Repeatable NPC missions with real per-quest progress baselines.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_QUESTS") or Instance.new("Folder");root.Name="SECRET_QUESTS";root.Parent=Workspace
local Complete=remotes:FindFirstChild("CompleteQuest") or Instance.new("RemoteEvent");Complete.Name="CompleteQuest";Complete.Parent=remotes
local questCompleted=ReplicatedStorage:FindFirstChild("SecretVillageQuestCompleted") or Instance.new("BindableEvent");questCompleted.Name="SecretVillageQuestCompleted";questCompleted.Parent=ReplicatedStorage
local quests={
 {id="delivery",name="📦 Срочная доставка",text="Отвези посылку к синему терминалу",reward=180,xp=40,target=Vector3.new(100,.5,0)},
 {id="taxi",name="🚕 Пассажир",text="Доставь пассажира к старому дому",reward=300,xp=60,target=Vector3.new(-70,1,-30)},
 {id="explore",name="🔎 Следопыт",text="Найди новый секрет после взятия задания",reward=250,xp=50,target=0},
 {id="fisher",name="🎣 Улов дня",text="Поймай 5 новых рыб",reward=220,xp=45,target=5},
}
local byId={};for _,q in ipairs(quests)do byId[q.id]=q end
local function money(p)local l=p:FindFirstChild("leaderstats");return l and l:FindFirstChild("Money")end
local function npc(name,pos,title,questId)
 local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(5,7,5);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Wood;p.Parent=root
 local g=Instance.new("BillboardGui");g.Size=UDim2.fromOffset(280,55);g.StudsOffset=Vector3.new(0,5,0);g.AlwaysOnTop=true;g.Parent=p
 local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=title;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=g
 local pr=Instance.new("ProximityPrompt");pr.ActionText="Задание";pr.ObjectText=name;pr.HoldDuration=.35;pr.Parent=p
 pr.Triggered:Connect(function(player)
  if player:GetAttribute("QuestActive") and player:GetAttribute("QuestActive")~="" then Notify:FireClient(player,"📋 Сначала закончи текущее задание.");return end
  local q=byId[questId];player:SetAttribute("QuestActive",questId);player:SetAttribute("QuestProgress",0);player:SetAttribute("QuestTarget",q.target)
  player:SetAttribute("QuestStartSecrets",player:GetAttribute("SecretsFound")or 0);player:SetAttribute("QuestStartFish",player:GetAttribute("TotalFish")or 0)
  Notify:FireClient(player,q.name.." — "..q.text..". Награда $"..q.reward.." +"..q.xp.." XP")
 end)
end
npc("CourierQuestNPC",Vector3.new(-20,3.5,35),"📦 КУРЬЕР","delivery")
npc("TaxiQuestNPC",Vector3.new(80,3.5,25),"🚕 ДИСПЕТЧЕР","taxi")
npc("ExplorerQuestNPC",Vector3.new(35,3.5,55),"🔎 ИССЛЕДОВАТЕЛЬ","explore")
npc("FishingQuestNPC",Vector3.new(65,3.5,25),"🎣 РЫБОЛОВ","fisher")
local target=Instance.new("Part");target.Name="DeliveryTarget";target.Size=Vector3.new(8,.5,8);target.Position=Vector3.new(100,.5,0);target.Anchored=true;target.Material=Enum.Material.Neon;target.Transparency=.35;target.Parent=root
local targetPrompt=Instance.new("ProximityPrompt");targetPrompt.ActionText="Сдать";targetPrompt.ObjectText="📦 Терминал доставки";targetPrompt.Parent=target
local function finish(p,q)
 if not p:GetAttribute("QuestActive") or p:GetAttribute("QuestActive")=="" then return end
 local m=money(p);if m then m.Value+=q.reward end
 p:SetAttribute("QuestActive","");p:SetAttribute("QuestProgress",0);p:SetAttribute("QuestTarget",0);p:SetAttribute("QuestStartSecrets",nil);p:SetAttribute("QuestStartFish",nil)
 p:SetAttribute("QuestXP",(p:GetAttribute("QuestXP")or 0)+q.xp);questCompleted:Fire(p)
 Notify:FireClient(p,"✅ Задание «"..q.name.."» выполнено! +$"..q.reward.." +"..q.xp.." XP")
end
local function tryComplete(p)
 local id=p:GetAttribute("QuestActive");local q=byId[id];if not q then return end
 if id=="delivery" then
  local c=p.Character;local r=c and c:FindFirstChild("HumanoidRootPart");if not r or (r.Position-target.Position).Magnitude>14 then Notify:FireClient(p,"📦 Подойди к терминалу доставки.");return end
 elseif id=="taxi" then
  local c=p.Character;local r=c and c:FindFirstChild("HumanoidRootPart");local hum=c and c:FindFirstChildOfClass("Humanoid");local seat=hum and hum.SeatPart
  if not r or not seat or not seat:IsDescendantOf(Workspace.SECRET_VILLAGE_VEHICLES) or (r.Position-q.target).Magnitude>16 then Notify:FireClient(p,"🚕 Сядь в такси и привези пассажира к старому дому.");return end
 elseif id=="explore" then
  local start=p:GetAttribute("QuestStartSecrets")or 0;if (p:GetAttribute("SecretsFound")or 0)<=start then Notify:FireClient(p,"🔎 Найди новый секрет после взятия задания.");return end;p:SetAttribute("QuestProgress",1)
 elseif id=="fisher" then
  local start=p:GetAttribute("QuestStartFish")or 0;local now=p:GetAttribute("TotalFish")or 0;if now-start<5 then Notify:FireClient(p,"🎣 Нужно поймать ещё "..math.max(0,5-(now-start)).." рыб.");return end;p:SetAttribute("QuestProgress",5)
 end
 finish(p,q)
end
Complete.OnServerEvent:Connect(tryComplete);targetPrompt.Triggered:Connect(tryComplete)
Players.PlayerAdded:Connect(function(p)
 if p:GetAttribute("QuestActive")==nil then p:SetAttribute("QuestActive","") end
 if p:GetAttribute("QuestProgress")==nil then p:SetAttribute("QuestProgress",0) end
 if p:GetAttribute("QuestTarget")==nil then p:SetAttribute("QuestTarget",0) end
 p:GetAttributeChangedSignal("TotalFish"):Connect(function()if p:GetAttribute("QuestActive")=="fisher" then local start=p:GetAttribute("QuestStartFish")or 0;local now=p:GetAttribute("TotalFish")or 0;p:SetAttribute("QuestProgress",math.min(5,math.max(0,now-start)))end end)
 p:GetAttributeChangedSignal("SecretsFound"):Connect(function()if p:GetAttribute("QuestActive")=="explore" then local start=p:GetAttribute("QuestStartSecrets")or 0;local now=p:GetAttribute("SecretsFound")or 0;p:SetAttribute("QuestProgress",now>start and 1 or 0)end end)
end)
