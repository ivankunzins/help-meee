-- SECRET VILLAGE CO-OP SECRET #011
-- Two distinct players must activate both plates at the same time.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local root=workspace:FindFirstChild("SECRET_COOP") or Instance.new("Folder")
root.Name="SECRET_COOP";root.Parent=workspace
local found=ReplicatedStorage:FindFirstChild("SecretAward") or Instance.new("BindableEvent")
found.Name="SecretAward";found.Parent=ReplicatedStorage
local occupied={A=nil,B=nil};local solved={}
local function part(name,pos)
 local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(8,.7,8);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Metal;p.Parent=root
 local light=Instance.new("PointLight");light.Range=12;light.Brightness=1;light.Parent=p
 return p
end
local function prompt(p)
 local q=Instance.new("ProximityPrompt");q.ActionText="Встать на плиту";q.ObjectText="Командная плита";q.HoldDuration=.25;q.MaxActivationDistance=10;q.Parent=p;return q
end
local a=prompt(part("PlateA",Vector3.new(35,.7,-85)));local b=prompt(part("PlateB",Vector3.new(55,.7,-85)))
local function clear(slot,p)
 task.delay(4,function()if occupied[slot]==p then occupied[slot]=nil end end)
end
local function check()
 local pa,pb=occupied.A,occupied.B
 if not pa or not pb or pa==pb or not pa.Parent or not pb.Parent then return end
 if solved[pa.UserId] or solved[pb.UserId] then return end
 solved[pa.UserId]=true;solved[pb.UserId]=true
 found:Fire(pa,11,3500,"Командная тайна")
 found:Fire(pb,11,3500,"Командная тайна")
 Notify:FireClient(pa,"🤝 SECRET #011 найден! Ты прошёл его вместе с другим игроком.")
 Notify:FireClient(pb,"🤝 SECRET #011 найден! Ты прошёл его вместе с другим игроком.")
end
local function enter(p,slot)
 if occupied[slot] and occupied[slot]~=p then Notify:FireClient(p,"⛔ Плита уже занята.");return end
 occupied[slot]=p;Notify:FireClient(p,"🪨 Плита активна. Нужен второй игрок!");check();clear(slot,p)
end
a.Triggered:Connect(function(p)enter(p,"A")end);b.Triggered:Connect(function(p)enter(p,"B")end)
Players.PlayerRemoving:Connect(function(p)if occupied.A==p then occupied.A=nil end;if occupied.B==p then occupied.B=nil end end)
