-- SECRET VILLAGE inventory + utility items.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local folder=ReplicatedStorage:FindFirstChild("SecretVillageTools") or Instance.new("Folder")
folder.Name="SecretVillageTools";folder.Parent=ReplicatedStorage

local definitions={
 Flashlight={display="🔦 Фонарик",color=Color3.fromRGB(255,245,180)},
 Detector={display="📡 Детектор секретов",color=Color3.fromRGB(80,220,255)},
 Diving={display="🤿 Дайвинг-комплект",color=Color3.fromRGB(60,170,255)},
 MagicCarpet={display="🪄 Магический ковёр",color=Color3.fromRGB(180,80,255)},
}

local function toolFor(name)
 local d=definitions[name]; if not d then return end
 local t=Instance.new("Tool");t.Name=d.display;t.RequiresHandle=true;t.CanBeDropped=false
 local h=Instance.new("Part");h.Name="Handle";h.Size=Vector3.new(1.4,.35,1.4);h.Color=d.color;h.Material=Enum.Material.Neon;h.Parent=t
 if name=="Flashlight" then
  local light=Instance.new("SpotLight");light.Brightness=3;light.Range=28;light.Angle=65;light.Enabled=false;light.Parent=h
  t.Activated:Connect(function()light.Enabled=not light.Enabled;Notify:FireClient(Players:GetPlayerFromCharacter(t.Parent),light.Enabled and "🔦 Фонарик включён" or "🔦 Фонарик выключен")end)
 elseif name=="Detector" then
  t.Activated:Connect(function()
   local p=Players:GetPlayerFromCharacter(t.Parent);if not p then return end
   local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart");local secrets=workspace:FindFirstChild("SECRET_DISCOVERIES")
   if not root or not secrets then return end
   local best,dist=nil,math.huge
   for _,x in ipairs(secrets:GetChildren()) do if x:IsA("BasePart") then local dd=(root.Position-x.Position).Magnitude;if dd<dist then best,dist=x,dd end end end
   Notify:FireClient(p,best and ("📡 Ближайший секрет: ~"..math.floor(dist).." studs") or "📡 Сигналов нет")
  end)
 elseif name=="Diving" then
  t.Activated:Connect(function()local p=Players:GetPlayerFromCharacter(t.Parent);if p then p:SetAttribute("Diving",not p:GetAttribute("Diving"));Notify:FireClient(p,p:GetAttribute("Diving") and "🤿 Дайвинг активирован" or "🤿 Дайвинг отключён")end end)
 elseif name=="MagicCarpet" then
  t.Activated:Connect(function()
   local p=Players:GetPlayerFromCharacter(t.Parent);local c=p and p.Character;local hrp=c and c:FindFirstChild("HumanoidRootPart");if not hrp then return end
   hrp.AssemblyLinearVelocity=hrp.CFrame.LookVector*85+Vector3.new(0,35,0)
   Notify:FireClient(p,"🪄 Ковёр понёс тебя вперёд!")
  end)
 end
 return t
end

local function give(p,name)
 local backpack=p:FindFirstChildOfClass("Backpack");if not backpack then return end
 if backpack:FindFirstChild(definitions[name].display) or (p.Character and p.Character:FindFirstChild(definitions[name].display)) then return end
 local t=toolFor(name);if t then t.Parent=backpack;Notify:FireClient(p,"🎁 Получен предмет: "..definitions[name].display)end
end

Players.PlayerAdded:Connect(function(p)
 task.delay(3,function()
  if p.Parent then give(p,"Flashlight") end
 end)
end)

-- Server-only helper for future secret rewards.
_G.SecretVillageGiveItem=give
