-- SECRET VILLAGE — secret discovery v4
-- Creates exactly 100 discoverable secrets and avoids duplicate generation.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_DISCOVERIES") or Instance.new("Folder")
root.Name="SECRET_DISCOVERIES"
root.Parent=Workspace

if root:FindFirstChild("SECRET_001") then
 return
end

local award=ReplicatedStorage:FindFirstChild("SecretAward") or Instance.new("BindableEvent")
award.Name="SecretAward"
award.Parent=ReplicatedStorage

local function notify(p,t)
 Notify:FireClient(p,t)
end

local function secret(id,name,pos,requirement,reward)
 local p=Instance.new("Part")
 p.Name=string.format("SECRET_%03d",id)
 p.Size=Vector3.new(3,3,3)
 p.Position=pos
 p.Anchored=true
 p.Material=Enum.Material.Neon
 p.Transparency=.35
 p:SetAttribute("SecretId",id)
 p:SetAttribute("SecretName",name)
 p.Parent=root

 local q=Instance.new("ProximityPrompt")
 q.ActionText="Исследовать"
 q.ObjectText=name
 q.HoldDuration=.7
 q.MaxActivationDistance=9
 q.RequiresLineOfSight=false
 q.Parent=p

 q.Triggered:Connect(function(player)
  if player:GetAttribute("Secret_"..id) then
   notify(player,"✅ Этот секрет уже есть в коллекции.")
   return
  end
  if requirement and not requirement(player) then
   return
  end
  award:Fire(player,id,reward,name)
 end)
end

secret(1,"Подводная дверь",Vector3.new(-45,-3,65),nil,1000)
secret(2,"Ночной люк",Vector3.new(-90,1,40),function(p)
 if Workspace:GetAttribute("NightEvent") then return true end
 notify(p,"🌙 Этот люк открывается только ночью.")
 return false
end,1500)
secret(3,"Колодец с эхом",Vector3.new(82,2,65),nil,750)
secret(4,"Дерево с меткой",Vector3.new(-105,3,-65),function(p)
 if (p:GetAttribute("SecretsFound") or 0)>=3 then return true end
 notify(p,"🌳 Сначала найди 3 секрета.")
 return false
end,1250)
secret(5,"Чердак старого дома",Vector3.new(-70,10,-30),function(p)
 if (p:GetAttribute("SecretsFound") or 0)>=4 then return true end
 notify(p,"🏚️ Сначала найди 4 секрета.")
 return false
end,2000)
secret(6,"Красный телефон",Vector3.new(90,3,45),nil,500)
secret(7,"Спрятанный сундук",Vector3.new(110,1,80),function(p)
 if (p:GetAttribute("SecretsFound") or 0)>=5 then return true end
 notify(p,"🧰 Нужно минимум 5 секретов.")
 return false
end,2500)
secret(8,"Фонарь в лесу",Vector3.new(-115,2,15),function(p)
 if Workspace:GetAttribute("NightEvent") then return true end
 notify(p,"🔦 Фонарь оживает только ночью.")
 return false
end,1800)
secret(9,"Странная машина",Vector3.new(55,2,110),function(p)
 if (p:GetAttribute("SecretsFound") or 0)>=7 then return true end
 notify(p,"🚗 Найди ещё секреты, чтобы понять машину.")
 return false
end,3000)
secret(10,"Золотой знак",Vector3.new(0,2,115),function(p)
 if (p:GetAttribute("SecretsFound") or 0)>=9 then return true end
 notify(p,"🏆 Найди 9 секретов.")
 return false
end,10000)
secret(11,"Скрытая печать",Vector3.new(-25,2,100),function(p)
 if (p:GetAttribute("SecretsFound") or 0)>=10 then return true end
 notify(p,"🔒 Найди 10 секретов.")
 return false
end,12000)

local names={"Сломанный указатель","Пустая клетка","Старый колокольчик","Монета у дороги","Следы на песке","Запертый ящик","Потайной рычаг","Синий камень","Письмо в стене","Крыша без черепицы","Тень у дерева","Забытый велосипед","Лампа под мостом","Карта деревни","Часы без стрелок","Красный кирпич","Трещина в заборе","Ключ в траве","Странный рисунок","Тайная кнопка"}
for id=12,100 do
 local ring=id%20
 local row=math.floor(id/20)
 local x=-115+(ring*12)%230
 local z=-105+row*42+math.floor(ring/10)*8
 local n=names[((id-12)%#names)+1]
 secret(id,n,Vector3.new(x,1.5,z),function(p)
  local need=math.min(10,math.floor((id-1)/10))
  if (p:GetAttribute("SecretsFound") or 0)>=need then return true end
  notify(p,"🔒 Нужно найти минимум "..need.." секретов.")
  return false
 end,250+id*25)
end

print("SECRET VILLAGE: 100 SECRET DISCOVERIES READY")
