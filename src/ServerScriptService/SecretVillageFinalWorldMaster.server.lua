-- SECRET VILLAGE FINAL WORLD MASTER v1
-- Unified corrective pass. Run after the existing world builders.
-- Removes roads/start-style clutter, establishes meadow + forest perimeter, adds dangerous bears,
-- and fixes the water fall-through by providing a reliable swimming surface controller.

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")

if Workspace:FindFirstChild("SECRET_VILLAGE_FINAL_MASTER") then return end
local ROOT=Instance.new("Folder");ROOT.Name="SECRET_VILLAGE_FINAL_MASTER";ROOT.Parent=Workspace

local function mkPart(parent,name,size,pos,material,transparency,canCollide)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Position=pos;p.Anchored=true;p.Material=material or Enum.Material.Grass;p.Transparency=transparency or 0;p.CanCollide=canCollide~=false;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
local function sphere(parent,name,size,pos,material)
 local p=mkPart(parent,name,size,pos,material);p.Shape=Enum.PartType.Ball;return p
end
local function cyl(parent,name,size,pos,material)
 local p=mkPart(parent,name,size,pos,material);p.Shape=Enum.PartType.Cylinder;return p
end

-- 1. Turn the settlement into a continuous meadow. Roads are deliberately removed.
local function isRoadName(n)
 n=n:lower()
 return n:find("road",1,true) or n:find("street",1,true) or n:find("asphalt",1,true) or n:find("crossroad",1,true)
end
for _,d in ipairs(Workspace:GetDescendants()) do
 if d:IsA("BasePart") then
  if isRoadName(d.Name) or d.Material==Enum.Material.Asphalt then
   d.Transparency=1;d.CanCollide=false
  elseif d.Size.X>55 and d.Size.Z>55 and d.Position.Y<1 and d.Name~="River" and not d:IsDescendantOf(ROOT) then
   d.Material=Enum.Material.Grass
  end
 end
end

-- Soft meadow under the village, intentionally broad so no artificial road grid is visible.
mkPart(ROOT,"Meadow",Vector3.new(430,1,430),Vector3.new(0,-.65,0),Enum.Material.Grass,0,false)

-- 2. Dense forest ring around the playable village. Keep the center open.
local forest=Instance.new("Folder");forest.Name="FOREST_PERIMETER";forest.Parent=ROOT
local rng=Random.new(72419)
local function makeTree(x,z,s)
 local m=Instance.new("Model");m.Name="Pine";m.Parent=forest
 local trunk=cyl(m,"Trunk",Vector3.new(1.7*s,9*s,1.7*s),Vector3.new(x,4.5*s,z),Enum.Material.Wood)
 trunk.CFrame=trunk.CFrame*CFrame.Angles(0,0,math.rad(90))
 for i=1,4 do
  local y=(3.8+i*2.2)*s
  local r=(6.4-i*.9)*s
  local c=sphere(m,"Foliage",Vector3.new(r*2,3.8*s,r*2),Vector3.new(x,y,z),Enum.Material.Grass)
  c.CanCollide=false
 end
 return m
end
for i=1,150 do
 local a=rng:NextNumber(0,math.pi*2)
 local r=rng:NextNumber(190,225)
 local x=math.cos(a)*r
 local z=math.sin(a)*r
 makeTree(x,z,rng:NextNumber(.8,1.45))
end
-- second inner irregular forest band for a genuinely enclosed village feeling
for i=1,55 do
 local a=rng:NextNumber(0,math.pi*2)
 local r=rng:NextNumber(165,188)
 makeTree(math.cos(a)*r,math.sin(a)*r,rng:NextNumber(.65,1.15))
end

-- 3. Forest floor details, but no signs or floating labels.
local ground=Instance.new("Folder");ground.Name="FOREST_FLOOR";ground.Parent=ROOT
for i=1,90 do
 local a=rng:NextNumber(0,math.pi*2);local r=rng:NextNumber(160,220)
 local x=math.cos(a)*r;local z=math.sin(a)*r
 local s=rng:NextNumber(.6,2.2)
 sphere(ground,"Moss",Vector3.new(2.5*s,.7,2.5*s),Vector3.new(x,.35,z),Enum.Material.Grass).CanCollide=false
end

-- 4. Bears: dangerous wildlife at the edge of the forest.
local bears=Instance.new("Folder");bears.Name="DANGEROUS_BEAR_ZONE";bears.Parent=ROOT
local function makeBear(i,x,z)
 local m=Instance.new("Model");m.Name="Bear_"..i;m.Parent=bears;m:SetAttribute("Dangerous",true)
 local root=mkPart(m,"HumanoidRootPart",Vector3.new(2.2,2.5,2.2),Vector3.new(x,3,z),Enum.Material.SmoothPlastic,1,false)
 m.PrimaryPart=root
 local hum=Instance.new("Humanoid");hum.Name="Humanoid";hum.MaxHealth=180;hum.Health=180;hum.WalkSpeed=11;hum.DisplayName="";hum.Parent=m
 local body=sphere(m,"Body",Vector3.new(6,4.8,4.2),Vector3.new(x,3.5,z),Enum.Material.SmoothPlastic);body.CanCollide=false
 local neck=sphere(m,"Neck",Vector3.new(3.2,3.2,3),Vector3.new(x,4.4,z-1.6),Enum.Material.SmoothPlastic);neck.CanCollide=false
 local head=sphere(m,"Head",Vector3.new(3.1,3,3.1),Vector3.new(x,5.2,z-3),Enum.Material.SmoothPlastic);head.CanCollide=false
 for _,sx in ipairs({-1,1}) do
  local ear=sphere(m,"Ear",Vector3.new(.9,.9,.7),Vector3.new(x+sx*1.15,6.45,z-3.1),Enum.Material.SmoothPlastic);ear.CanCollide=false
  local leg=sphere(m,"Leg",Vector3.new(1.45,2.7,1.45),Vector3.new(x+sx*1.7,1.65,z-.65),Enum.Material.SmoothPlastic);leg.CanCollide=false
  local rear=sphere(m,"RearLeg",Vector3.new(1.55,2.6,1.55),Vector3.new(x+sx*1.65,1.6,z+1.05),Enum.Material.SmoothPlastic);rear.CanCollide=false
 end
 local muzzle=sphere(m,"Muzzle",Vector3.new(1.65,1.2,1.25),Vector3.new(x,4.8,z-4.25),Enum.Material.SmoothPlastic);muzzle.CanCollide=false
 local nose=sphere(m,"Nose",Vector3.new(.55,.45,.35),Vector3.new(x,4.8,z-4.95),Enum.Material.SmoothPlastic);nose.CanCollide=false
 local tail=sphere(m,"Tail",Vector3.new(1.2,1.2,1.2),Vector3.new(x,4,z+2.3),Enum.Material.SmoothPlastic);tail.CanCollide=false
 hum.Died:Connect(function()task.delay(25,function()if m.Parent then m:Destroy()end end)end)
 return m
end
local bearPositions={{-175,-175},{175,-145},{-195,80},{190,105},{-120,190},{105,190}}
for i,p in ipairs(bearPositions) do makeBear(i,p[1],p[2]) end

-- Bear AI: stalk the nearest player who enters the forest edge; attack at close range.
task.spawn(function()
 while ROOT.Parent do
  for _,bear in ipairs(bears:GetChildren()) do
   local hum=bear:FindFirstChildOfClass("Humanoid");local root=bear.PrimaryPart
   if hum and root and hum.Health>0 then
    local best,bestDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
     local ch=plr.Character;local pr=ch and ch:FindFirstChild("HumanoidRootPart");local ph=ch and ch:FindFirstChildOfClass("Humanoid")
     if pr and ph and ph.Health>0 then
      local d=(pr.Position-root.Position).Magnitude
      if d<bestDist and d<58 then best,bestDist=plr,d end
     end
    end
    if best then
     local ch=best.Character;local pr=ch and ch:FindFirstChild("HumanoidRootPart");local ph=ch and ch:FindFirstChildOfClass("Humanoid")
     if pr and ph then
      hum:MoveTo(pr.Position)
      if bestDist<6.5 then ph:TakeDamage(28) end
     end
    end
   end
  end
  task.wait(.35)
 end
end)

-- 5. Water fix. Existing world uses a river around the village. Keep the player floating reliably.
-- Normal players are buoyant at the surface. Owners of the Diving tool can descend normally.
local function inWater(pos)
 -- broad bounds matching the generated river/dive zone; avoid affecting the whole map.
 return pos.X>-120 and pos.X<125 and pos.Z>38 and pos.Z<80 and pos.Y<4 and pos.Y>-18
end
RunService.Heartbeat:Connect(function()
 for _,plr in ipairs(Players:GetPlayers()) do
  local ch=plr.Character;local root=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
  if root and hum and hum.Health>0 and inWater(root.Position) then
   local diving=ch:FindFirstChild("Diving") or (plr:FindFirstChildOfClass("Backpack") and plr.Backpack:FindFirstChild("Diving"))
   if not diving and root.Position.Y<.35 then
    local p=root.Position
    root.CFrame=CFrame.new(p.X,.75,p.Z,root.CFrame.XVector.X,root.CFrame.XVector.Y,root.CFrame.XVector.Z,root.CFrame.YVector.X,root.CFrame.YVector.Y,root.CFrame.YVector.Z,root.CFrame.ZVector.X,root.CFrame.ZVector.Y,root.CFrame.ZVector.Z)
    root.AssemblyLinearVelocity=Vector3.new(root.AssemblyLinearVelocity.X,math.max(0,root.AssemblyLinearVelocity.Y),root.AssemblyLinearVelocity.Z)
   end
  end
 end
end)

-- 6. Remove unnecessary world labels/sign clutter. Keep gameplay-critical secret/quest prompts intact.
for _,d in ipairs(Workspace:GetDescendants()) do
 if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
  local n=d.Name:lower()
  local p=d.Parent
  local keep=n:find("secret",1,true) or n:find("quest",1,true)
  if not keep and p and p.Name~="DiveSign" then d:Destroy() end
 end
end

-- 7. Remove accidental decorative text objects named START/PLAY from existing GUIs.
local function cleanGui(container)
 for _,d in ipairs(container:GetDescendants()) do
  if d:IsA("TextButton") or d:IsA("TextLabel") then
   local s=(d.Text or ""):lower()
   local n=d.Name:lower()
   if s:find("start",1,true) or s:find("начать",1,true) or n:find("start",1,true) or n:find("play",1,true) then
    d:Destroy()
   end
  end
 end
end
cleanGui(game:GetService("StarterGui"))

-- 8. Calm village lighting; retain existing event system but make the baseline warmer.
Lighting.ClockTime=15.2
Lighting.Brightness=2.05
Lighting.GlobalShadows=true
local at=Lighting:FindFirstChild("SecretVillage_FinalAtmosphere")
if at then at.Density=.27;at.Haze=.9;at.Glare=.07 end

print("SECRET VILLAGE MASTER: grass meadow + no roads + forest ring + dangerous bears + water protection + label cleanup READY")