-- SECRET VILLAGE VISUAL MASTER v1
-- Unified atmosphere pass: grass-only village, forest perimeter, dangerous bears,
-- water buoyancy/safe floor, reduced world labels, and warm rural presentation.

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local Terrain=Workspace.Terrain

if Workspace:FindFirstChild("SECRET_VILLAGE_VISUAL_MASTER") then return end
local ROOT=Instance.new("Folder");ROOT.Name="SECRET_VILLAGE_VISUAL_MASTER";ROOT.Parent=Workspace

local function mkPart(parent,name,size,pos,material,transparency,canCollide)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.Position=pos;p.Material=material or Enum.Material.Wood
 p.Anchored=true;p.CanCollide=canCollide~=false;p.CanTouch=true;p.CanQuery=true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 if transparency then p.Transparency=transparency end;p.Parent=parent;return p
end
local function sphere(parent,name,size,pos,material)
 local p=mkPart(parent,name,size,pos,material);p.Shape=Enum.PartType.Ball;return p
end
local function cyl(parent,name,size,pos,material)
 local p=mkPart(parent,name,size,pos,material);p.Shape=Enum.PartType.Cylinder;return p
end

-- 1) Replace the visual idea of streets with one continuous meadow.
local ground=Terrain:FindFirstChild("SecretVillageMasterGround")
if not ground then
 Terrain:FillBlock(CFrame.new(0,-1,0),Vector3.new(460,8,420),Enum.Material.Grass)
end
local function flattenRoad(name)
 local r=Workspace:FindFirstChild(name)
 if r and r:IsA("BasePart") then
  r.Transparency=1;r.CanCollide=false;r.CanTouch=false
  r.Material=Enum.Material.Grass
 end
end
flattenRoad("MainRoad");flattenRoad("CrossRoad")
task.spawn(function()
 while ROOT.Parent do
  flattenRoad("MainRoad");flattenRoad("CrossRoad");task.wait(3)
 end
end)

-- 2) Dense forest wall around the playable village.
local forest=Instance.new("Folder");forest.Name="FOREST_PERIMETER";forest.Parent=ROOT
local function tree(x,z,s)
 local m=Instance.new("Model");m.Name="Pine";m.Parent=forest
 local h=20*s
 cyl(m,"Trunk",Vector3.new(2.2*s,h,2.2*s),Vector3.new(x,h/2-1,z),Enum.Material.Wood)
 for i=1,4 do
  local y=5*s+i*3.5*s
  sphere(m,"Branch"..i,Vector3.new((10-i)*s,(6-i*.5)*s,(10-i)*s),Vector3.new(x,y,z),Enum.Material.Grass)
 end
end
local seed=1
local function rand(a,b)
 seed=(seed*1103515245+12345)%2147483648
 return a+(seed%10000)/10000*(b-a)
end
-- Four sides, with irregular spacing so the edge reads as real forest rather than a wall.
for i=1,85 do
 local side=i%4;local x,z
 if side==0 then x=rand(-225,225);z=rand(-205,-165)
 elseif side==1 then x=rand(-225,225);z=rand(165,205)
 elseif side==2 then x=rand(-225,-185);z=rand(-165,165)
 else x=rand(185,225);z=rand(-165,165) end
 tree(x,z,rand(.75,1.35))
end
for i=1,35 do
 local x=rand(-165,165);local z=rand(-145,145)
 tree(x,z,rand(.45,.8))
end

-- 3) Forest undergrowth: grass, ferns, stones, fallen logs.
local under=Instance.new("Folder");under.Name="FOREST_UNDERGROWTH";under.Parent=ROOT
for i=1,130 do
 local x=rand(-220,220);local z=rand(-195,195)
 if math.abs(x)<150 and math.abs(z)<125 then continue end
 sphere(under,"Bush",Vector3.new(rand(2,5),rand(1.2,3),rand(2,5)),Vector3.new(x,rand(.6,1.4),z),Enum.Material.Grass)
end
for i=1,28 do
 local x=rand(-210,210);local z=rand(-190,190)
 cyl(under,"FallenLog",Vector3.new(1.1,rand(4,8),1.1),Vector3.new(x,.7,z),Enum.Material.Wood)
end

-- 4) Dangerous bears at the forest edge.
local bears=Instance.new("Folder");bears.Name="DANGEROUS_BEARS";bears.Parent=ROOT
local function bear(x,z,index)
 local m=Instance.new("Model");m.Name="ForestBear_"..index;m.Parent=bears
 local body=sphere(m,"Body",Vector3.new(6,4.5,4),Vector3.new(x,3,z),Enum.Material.SmoothPlastic)
 body.Color=Color3.fromRGB(72,48,34)
 local head=sphere(m,"Head",Vector3.new(3.2,3.2,3.2),Vector3.new(x,5.1,z-2.2),Enum.Material.SmoothPlastic);head.Color=body.Color
 for _,dx in ipairs({-1.15,1.15}) do
  local e=sphere(m,"Ear",Vector3.new(.9,.9,.9),Vector3.new(x+dx,6.4,z-2.2),Enum.Material.SmoothPlastic);e.Color=body.Color
 end
 local muzzle=sphere(m,"Muzzle",Vector3.new(1.6,1.2,1.1),Vector3.new(x,4.8,z-3.55),Enum.Material.SmoothPlastic);muzzle.Color=Color3.fromRGB(45,31,24)
 for _,dx in ipairs({-1,1}) do
  local eye=sphere(m,"Eye",Vector3.new(.28,.28,.18),Vector3.new(x+dx*.65,5.35,z-3.55),Enum.Material.Neon);eye.Color=Color3.fromRGB(255,190,80)
 end
 for _,dx in ipairs({-1.6,1.6}) do
  for _,dz in ipairs({-1.2,1.1}) do
   local leg=cyl(m,"Leg",Vector3.new(1.25,3,1.25),Vector3.new(x+dx,1.5,z+dz),Enum.Material.SmoothPlastic);leg.Color=body.Color
  end
 end
 local hum=Instance.new("Humanoid");hum.MaxHealth=220;hum.Health=220;hum.WalkSpeed=12;hum.Parent=m
 m.PrimaryPart=body
 m:SetAttribute("Aggressive",true)
 m:SetAttribute("Damage",35)
 local cooldown={}
 body.Touched:Connect(function(hit)
  local ch=hit and hit:FindFirstAncestorOfClass("Model");local pl=ch and Players:GetPlayerFromCharacter(ch)
  if pl and ch:FindFirstChildOfClass("Humanoid") and not cooldown[pl] then
   cooldown[pl]=true
   local ph=ch:FindFirstChildOfClass("Humanoid");ph:TakeDamage(35)
   task.delay(1.4,function()cooldown[pl]=nil end)
  end
 end)
 task.spawn(function()
  local home=Vector3.new(x,3,z)
  while m.Parent and hum.Health>0 do
   local target=nil;local dist=70
   for _,pl in ipairs(Players:GetPlayers()) do
    local c=pl.Character;local r=c and c:FindFirstChild("HumanoidRootPart")
    if r then local d=(r.Position-body.Position).Magnitude;if d<dist then dist=d;target=r end end
   end
   if target then hum:MoveTo(target.Position) else hum:MoveTo(home+Vector3.new(rand(-20,20),0,rand(-20,20))) end
   task.wait(.8)
  end
 end)
end
for i=1,7 do
 local a=(i/7)*math.pi*2
 bear(math.cos(a)*rand(155,195),math.sin(a)*rand(135,175),i)
end

-- 5) Water fix: identify the village river and provide buoyancy + a real underwater floor.
local water=Workspace:FindFirstChild("River")
local WATER_Y=.15
local WATER_MIN_X,WATER_MAX_X=-115,25
local WATER_MIN_Z,WATER_MAX_Z=40,78
local floor=mkPart(ROOT,"UnderwaterSafetyFloor",Vector3.new(145,1,48),Vector3.new(-45,-6.5,59),Enum.Material.Slate,1,true)
-- A non-colliding water volume marks the swimming area without blocking diving.
local volume=mkPart(ROOT,"WaterVolume",Vector3.new(140,7,42),Vector3.new(-45,-3.3,59),Enum.Material.Water,1,false)
if water and water:IsA("BasePart") then water.CanCollide=false;water.CanTouch=true end
local function inWater(pos)
 return pos.X>=WATER_MIN_X and pos.X<=WATER_MAX_X and pos.Z>=WATER_MIN_Z and pos.Z<=WATER_MAX_Z and pos.Y<1 and pos.Y>-8
end
RunService.Heartbeat:Connect(function()
 for _,pl in ipairs(Players:GetPlayers()) do
  local c=pl.Character;local r=c and c:FindFirstChild("HumanoidRootPart");local h=c and c:FindFirstChildOfClass("Humanoid")
  if r and h and inWater(r.Position) then
   local diving=pl:GetAttribute("Own_Diving") or pl:GetAttribute("Own_Diving")==true
   if not diving and r.Position.Y<-.8 then
    r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,math.max(r.AssemblyLinearVelocity.Y,7),r.AssemblyLinearVelocity.Z)
   end
   h:ChangeState(Enum.HumanoidStateType.Swimming)
  end
 end
end)

-- 6) Remove decorative world labels, signs and duplicate floating text. Gameplay prompts stay.
local function cleanLabels(root)
 for _,d in ipairs(root:GetDescendants()) do
  if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
   local n=string.lower(d.Name)
   if n:find("sign") or n:find("label") or n:find("title") or n:find("name") then d:Destroy() end
  end
 end
end
cleanLabels(Workspace)
task.spawn(function()
 while ROOT.Parent do task.wait(5);cleanLabels(Workspace) end
end)

-- 7) Remove obsolete start/play UI without touching the main HUD.
local function cleanStartUI()
 for _,pl in ipairs(Players:GetPlayers()) do
  local pg=pl:FindFirstChildOfClass("PlayerGui")
  if pg then
   for _,g in ipairs(pg:GetChildren()) do
    local n=string.lower(g.Name)
    if n:find("start") or n:find("splash") or n:find("welcome") then g:Destroy() end
   end
   for _,d in ipairs(pg:GetDescendants()) do
    if d:IsA("TextButton") then
     local t=string.lower(d.Text or "")
     if t=="start" or t=="play" or t=="начать" or t=="играть" or t:find("начать игру") then d:Destroy() end
    end
   end
  end
 end
end
Players.PlayerAdded:Connect(function(pl)pl.CharacterAdded:Connect(function()task.wait(1);cleanStartUI()end);task.wait(1);cleanStartUI()end)
for _,pl in ipairs(Players:GetPlayers()) do task.spawn(function()cleanStartUI()end) end

-- 8) One atmospheric lighting layer.
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.Brightness=2.05
Lighting.ClockTime=15.7
Lighting.ExposureCompensation=.02
Lighting.EnvironmentDiffuseScale=.55
Lighting.EnvironmentSpecularScale=.7
local cc=Lighting:FindFirstChild("VillageMasterGrade") or Instance.new("ColorCorrectionEffect");cc.Name="VillageMasterGrade";cc.Brightness=.015;cc.Contrast=.14;cc.Saturation=.09;cc.TintColor=Color3.fromRGB(255,247,232);cc.Parent=Lighting
local atm=Lighting:FindFirstChild("VillageMasterAtmosphere") or Instance.new("Atmosphere");atm.Name="VillageMasterAtmosphere";atm.Density=.3;atm.Offset=.1;atm.Haze=1.05;atm.Glare=.08;atm.Color=Color3.fromRGB(205,220,224);atm.Decay=Color3.fromRGB(105,122,136);atm.Parent=Lighting
local bloom=Lighting:FindFirstChild("VillageMasterBloom") or Instance.new("BloomEffect");bloom.Name="VillageMasterBloom";bloom.Intensity=.1;bloom.Size=22;bloom.Threshold=1.1;bloom.Parent=Lighting

print("SECRET VILLAGE VISUAL MASTER: grass + forest + bears + water safety + clean world labels + atmosphere READY")