-- SECRET VILLAGE CO-OP SECRET SYSTEM
-- Two-player pressure plate puzzle. Rewards both players once per server session.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_COOP") or Instance.new("Folder")
root.Name="SECRET_COOP";root.Parent=Workspace
local solved={}
local function part(name,pos)
 local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(8,.6,8);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Metal;p.Parent=root;return p
end
local plateA=part("PlateA",Vector3.new(35,.7,-85));local plateB=part("PlateB",Vector3.new(55,.7,-85))
local function prompt(p,text) local pr=Instance.new("ProximityPrompt");pr.ActionText=text;pr.ObjectText="Каменная плита";pr.HoldDuration=.3;pr.Parent=p;return pr end
local a=prompt(plateA,"Встать на плиту");local b=prompt(plateB,"Встать на плиту")
local occupied={}
local function reward(player)
 local ls=player:FindFirstChild("leaderstats");local m=ls and ls:FindFirstChild("Money");if m then m.Value+=3500 end
 player:SetAttribute("SecretsFound",(player:GetAttribute("SecretsFound") or 0)+1)
 Notify:FireClient(player,"🤝 SECRET #011 найден! Командная тайна. +$3500")
end
local function check()
 local pa,pb=occupied.A,occupied.B
 if not pa or not pb or pa==pb or not pa.Parent or not pb.Parent then return end
 if solved[pa.UserId] or solved[pb.UserId] then return end
 solved[pa.UserId]=true;solved[pb.UserId]=true
 Notify:FireClient(pa,"🤝 Вы открыли командную тайну вместе!");Notify:FireClient(pb,"🤝 Вы открыли командную тайну вместе!")
 reward(pa);reward(pb)
end
local function enter(player,slot)
 occupied[slot]=player
 Notify:FireClient(player,"🪨 Плита нажата. Нужен второй игрок на соседней плите!")
 check()
 task.delay(2,function() if occupied[slot]==player then occupied[slot]=nil end end)
end
a.Triggered:Connect(function(p) enter(p,"A") end)
b.Triggered:Connect(function(p) enter(p,"B") end)
Players.PlayerRemoving:Connect(function(p) if occupied.A==p then occupied.A=nil end;if occupied.B==p then occupied.B=nil end end)
