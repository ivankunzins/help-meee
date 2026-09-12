-- SECRET VILLAGE SECRET CHAIN v1
-- Turns early discoveries into a connected mystery progression.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local root=Workspace:FindFirstChild("SECRET_CHAIN")or Instance.new("Folder");root.Name="SECRET_CHAIN";root.Parent=Workspace
local function marker(name,pos,text,need,clue)
 local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(3,3,3);p.Position=pos;p.Anchored=true;p.Material=Enum.Material.Neon;p.Transparency=.18;p.Parent=root
 local b=Instance.new("BillboardGui");b.Size=UDim2.fromOffset(260,55);b.StudsOffset=Vector3.new(0,3,0);b.AlwaysOnTop=true;b.Parent=p
 local l=Instance.new("TextLabel");l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=b
 local pr=Instance.new("ProximityPrompt");pr.ActionText="Исследовать";pr.ObjectText=text;pr.HoldDuration=.5;pr.Parent=p
 pr.Triggered:Connect(function(player)
  if (player:GetAttribute("SecretsFound")or 0)<need then Notify:FireClient(player,"🔒 Нужно найти ещё секретов: "..need);return end
  Notify:FireClient(player,clue)
 end)
end
marker("ChainStone2",Vector3.new(-5,1,82),"🗿 ВТОРОЙ СЛЕД",1,"🌊 На камне: «Тот, кто вошёл под воду, должен искать там, где свет не должен быть».")
marker("ChainLantern",Vector3.new(-92,4,55),"🏮 СТРАННЫЙ ФОНАРЬ",2,"🏮 Фонарь мигает три раза. Похоже, это код для старого дома.")
marker("ChainAttic",Vector3.new(-70,12,-30),"🔑 ЧЕРДАЧНЫЙ СЛЕД",4,"🔑 На балке: «Красная трубка слышит всё». Ищи старый телефон.")
marker("ChainPhone",Vector3.new(5,2,-18),"☎️ КРАСНЫЙ ТЕЛЕФОН",5,"☎️ Телефон звонит сам. Последняя цифра: 7. Странная машина должна что-то знать.")
marker("ChainCar",Vector3.new(82,2,-8),"🚗 СТРАННАЯ МАШИНА",7,"🚗 В бардачке записка: «Золото не всегда видно днём». Следующий след появится ночью.")
marker("ChainGold",Vector3.new(25,2,5),"✨ ЗОЛОТОЙ СЛЕД",9,"✨ Ты собрал первый фрагмент истории. Десятый секрет ждёт там, где деревня смотрит на воду.")
Players.PlayerAdded:Connect(function(p)
 p:GetAttributeChangedSignal("SecretsFound"):Connect(function()
  local n=p:GetAttribute("SecretsFound")or 0
  if n==1 or n==2 or n==4 or n==5 or n==7 or n==9 then Notify:FireClient(p,"📖 Книга секретов обновилась. Проверь новые подсказки!")end
 end)
end)
