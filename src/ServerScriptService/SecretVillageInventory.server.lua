-- SECRET VILLAGE INVENTORY v4
-- Server-created tools with safe ownership restoration after profile loading.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local folder=ReplicatedStorage:FindFirstChild("SecretVillageTools") or Instance.new("Folder")
folder.Name="SecretVillageTools"
folder.Parent=ReplicatedStorage

local definitions={
 Flashlight={display="🔦 Фонарик",color=Color3.fromRGB(255,245,180)},
 Detector={display="📡 Детектор секретов",color=Color3.fromRGB(80,220,255)},
 Diving={display="🤿 Дайвинг-комплект",color=Color3.fromRGB(60,170,255)},
 MagicCarpet={display="🪄 Магический ковёр",color=Color3.fromRGB(180,80,255)}
}
local cooldowns={}
local restoring={}

local function ready(p,key,delay)
 local now=os.clock()
 cooldowns[p]=cooldowns[p] or {}
 if now-(cooldowns[p][key] or 0)<delay then return false end
 cooldowns[p][key]=now
 return true
end

local function toolFor(name)
 local d=definitions[name]
 if not d then return nil end
 local t=Instance.new("Tool")
 t.Name=d.display
 t.RequiresHandle=true
 t.CanBeDropped=false
 local h=Instance.new("Part")
 h.Name="Handle"
 h.Size=Vector3.new(1.4,.35,1.4)
 h.Color=d.color
 h.Material=Enum.Material.Neon
 h.Parent=t

 if name=="Flashlight" then
  local light=Instance.new("SpotLight")
  light.Brightness=3
  light.Range=28
  light.Angle=65
  light.Enabled=false
  light.Parent=h
  t.Activated:Connect(function()
   local p=Players:GetPlayerFromCharacter(t.Parent)
   if not p or not p:GetAttribute("Own_Flashlight") or not ready(p,"flashlight",.25) then return end
   light.Enabled=not light.Enabled
   Notify:FireClient(p,light.Enabled and "🔦 Фонарик включён" or "🔦 Фонарик выключен")
  end)
 elseif name=="Detector" then
  t.Activated:Connect(function()
   local p=Players:GetPlayerFromCharacter(t.Parent)
   if not p or not p:GetAttribute("Own_Detector") or not ready(p,"detector",1) then return end
   local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   local secrets=workspace:FindFirstChild("SECRET_DISCOVERIES")
   if not hrp or not secrets then return end
   local best,dist=nil,math.huge
   for _,x in ipairs(secrets:GetChildren()) do
    if x:IsA("BasePart") and not x:GetAttribute("Found") then
     local dd=(hrp.Position-x.Position).Magnitude
     if dd<dist then best,dist=x,dd end
    end
   end
   Notify:FireClient(p,best and ("📡 Ближайший секрет: ~"..math.floor(dist).." studs") or "📡 Сигналов нет")
  end)
 elseif name=="Diving" then
  t.Activated:Connect(function()
   local p=Players:GetPlayerFromCharacter(t.Parent)
   if not p or not p:GetAttribute("Own_Diving") or not ready(p,"diving",.5) then return end
   p:SetAttribute("Diving",not p:GetAttribute("Diving"))
   Notify:FireClient(p,p:GetAttribute("Diving") and "🤿 Дайвинг активирован" or "🤿 Дайвинг отключён")
  end)
 elseif name=="MagicCarpet" then
  t.Activated:Connect(function()
   local p=Players:GetPlayerFromCharacter(t.Parent)
   if not p or not p:GetAttribute("Own_MagicCarpet") or not ready(p,"carpet",2) then return end
   local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   if hrp then
    hrp.AssemblyLinearVelocity=hrp.CFrame.LookVector*85+Vector3.new(0,35,0)
    Notify:FireClient(p,"🪄 Ковёр понёс тебя вперёд!")
   end
  end)
 end
 return t
end

local function give(p,name)
 if not p or not p.Parent or type(name)~="string" or not definitions[name] then return false end
 local backpack=p:FindFirstChildOfClass("Backpack")
 if not backpack then return false end
 local display=definitions[name].display
 if backpack:FindFirstChild(display) or (p.Character and p.Character:FindFirstChild(display)) then return false end
 local t=toolFor(name)
 if not t then return false end
 t.Parent=backpack
 if t.Parent~=backpack then t:Destroy();return false end
 Notify:FireClient(p,"🎁 Получен предмет: "..display)
 return true
end

_G.SecretVillageGiveItem=give

local function restoreOwnedTools(p)
 if not p or not p.Parent or restoring[p] then return end
 restoring[p]=true
 local deadline=os.clock()+15
 while p.Parent and p:GetAttribute("OwnershipLoaded")~=true and os.clock()<deadline do
  task.wait(.25)
 end
 if p.Parent and p:GetAttribute("OwnershipLoaded")==true then
  for name in pairs(definitions) do
   if p:GetAttribute("Own_"..name)==true then
    local backpack=p:FindFirstChildOfClass("Backpack") or p:WaitForChild("Backpack",5)
    if backpack then
     local display=definitions[name].display
     if not backpack:FindFirstChild(display) and not (p.Character and p.Character:FindFirstChild(display)) then
      give(p,name)
     end
    end
   end
  end
 end
 restoring[p]=nil
end

local function onPlayerAdded(p)
 p.CharacterAdded:Connect(function()
  task.defer(function() restoreOwnedTools(p) end)
 end)
 task.spawn(restoreOwnedTools,p)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _,p in ipairs(Players:GetPlayers()) do task.spawn(onPlayerAdded,p) end
Players.PlayerRemoving:Connect(function(p)
 cooldowns[p]=nil
 restoring[p]=nil
end)
