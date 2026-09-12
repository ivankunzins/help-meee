-- SECRET VILLAGE PROGRESSION v1
-- Persistent XP, level and lifetime mission statistics.
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local Store=DataStoreService:GetDataStore("SecretVillage_Progression_v1")
local function load(p)
 local d={XP=0,Quests=0,Distance=0};local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(x)=="table"then for k,v in pairs(d)do if type(x[k])=="number"then d[k]=x[k]end end end
 p:SetAttribute("QuestXP",d.XP);p:SetAttribute("QuestsCompleted",d.Quests);p:SetAttribute("LifetimeDistance",d.Distance)
 p:GetAttributeChangedSignal("QuestXP"):Connect(function()p:SetAttribute("Level",math.floor((p:GetAttribute("QuestXP")or 0)/100)+1)end)
 p:SetAttribute("Level",math.floor(d.XP/100)+1)
end
local function save(p)
 local d={XP=p:GetAttribute("QuestXP")or 0,Quests=p:GetAttribute("QuestsCompleted")or 0,Distance=p:GetAttribute("LifetimeDistance")or 0}
 pcall(function()Store:UpdateAsync("u_"..p.UserId,function()return d end)end)
end
Players.PlayerAdded:Connect(function(p)task.defer(load,p);p:GetAttributeChangedSignal("QuestXP"):Connect(function()local xp=p:GetAttribute("QuestXP")or 0;p:SetAttribute("Level",math.floor(xp/100)+1)end)end)
Players.PlayerRemoving:Connect(save)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do save(p)end end end)
game:BindToClose(function()for _,p in ipairs(Players:GetPlayers())do save(p)end end)
-- Mission completion is announced by QuestXP changes; count each positive reward.
local last={}
Players.PlayerAdded:Connect(function(p)last[p]=0;p:GetAttributeChangedSignal("QuestXP"):Connect(function()local x=p:GetAttribute("QuestXP")or 0;if x>last[p]then p:SetAttribute("QuestsCompleted",(p:GetAttribute("QuestsCompleted")or 0)+1)end;last[p]=x end)end)
Players.PlayerRemoving:Connect(function(p)last[p]=nil end)
