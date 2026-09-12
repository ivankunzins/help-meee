-- SECRET VILLAGE — persistent secret discovery.
-- Core owns the saved counter; this script only increments it.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_DISCOVERIES") or Instance.new("Folder")
root.Name="SECRET_DISCOVERIES";root.Parent=Workspace
local found={}
local function notify(p,t) Notify:FireClient(p,t) end
local function reward(p,amount)
 local ls=p:FindFirstChild("leaderstats");local m=ls and ls:FindFirstChild("Money");if m then m.Value+=amount end
end
local function secret(id,name,pos,requirement,rewardAmount)
 local p=Instance.new("Part");p.Name=string.format("SECRET_%03d",id);p.Size=Vector3.new(3,3,3);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Neon;p.Transparency=.35;p.Parent=root
 local pr=Instance.new("ProximityPrompt");pr.ActionText="Исследовать";pr.ObjectText=name;pr.HoldDuration=.7;pr.MaxActivationDistance=9;pr.Parent=p
 pr.Triggered:Connect(function(player)
  found[player]=found[player] or {}
  if found[player][id] then notify(player,"✅ Этот секрет уже найден.");return end
  if requirement and not requirement(player) then return end
  found[player][id]=true
  local n=(player:GetAttribute("SecretsFound") or 0)+1
  player:SetAttribute("SecretsFound",n);reward(player,rewardAmount)
  notify(player,string.format("🔐 SECRET #%03d найден: %s  +$%d",id,name,rewardAmount))
 end)
end
secret(1,"Подводная дверь",Vector3.new(-45,-2.5,65),nil,1000)
secret(2,"Ночной люк",Vector3.new(-90,1,40),function(p) if Workspace:GetAttribute("NightEvent") then return true end notify(p,"🌙 Этот люк открывается только ночью.");return false end,1500)
secret(3,"Колодец с эхом",Vector3.new(82,2,65),nil,750)
secret(4,"Дерево с меткой",Vector3.new(-105,3,-65),function(p) if (p:GetAttribute("SecretsFound") or 0)>=3 then return true end notify(p,"🌳 Сначала найди ещё 3 секрета.");return false end,1250)
secret(5,"Чердак старого дома",Vector3.new(-70,10,-30),function(p) if (p:GetAttribute("SecretsFound") or 0)>=4 then return true end notify(p,"🏚️ Сначала стань опытнее исследователем.");return false end,2000)
secret(6,"Красный телефон",Vector3.new(90,3,45),nil,500)
secret(7,"Спрятанный сундук",Vector3.new(110,1,80),function(p) if (p:GetAttribute("SecretsFound") or 0)>=5 then return true end notify(p,"🧰 Нужно найти минимум 5 секретов.");return false end,2500)
secret(8,"Фонарь в лесу",Vector3.new(-115,2,15),function(p) if Workspace:GetAttribute("NightEvent") then return true end notify(p,"🔦 Фонарь оживает только ночью.");return false end,1800)
secret(9,"Странная машина",Vector3.new(55,2,110),function(p) if (p:GetAttribute("SecretsFound") or 0)>=7 then return true end notify(p,"🚗 Машина ждёт, пока ты найдёшь ещё секреты.");return false end,3000)
secret(10,"Золотой знак",Vector3.new(0,2,115),function(p) if (p:GetAttribute("SecretsFound") or 0)>=9 then return true end notify(p,"🏆 Остался последний шаг: найди 9 секретов.");return false end,10000)
Players.PlayerRemoving:Connect(function(p) found[p]=nil end)
