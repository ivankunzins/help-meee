-- SECRET VILLAGE FOREST & BEARS FINAL v1
-- Final presentation pass: dense perimeter forest, natural undergrowth, non-primitive bear encounter.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local life=WS:FindFirstChild("SECRET_VILLAGE_FOREST") or Instance.new("Folder",WS);life.Name="SECRET_VILLAGE_FOREST"
if life:GetAttribute("Built") then return end
life:SetAttribute("Built",true)

local function part(n,s,cf,mat,col,parent,trans)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=cf;p.Anchored=true;p.CanCollide=true;p.Material=mat or Enum.Material.SmoothPlastic;if col then p.Color=col end;if trans then p.Transparency=trans end;p.Parent=parent or life;return p
end
local function tree(pos,scale)
 local m=Instance.new("Model");m.Name="ForestTree";m.Parent=life
 local trunk=part("Trunk",Vector3.new(2.1,10,2.1)*scale,CFrame.new(pos+Vector3.new(0,5*scale,0)),Enum.Material.Wood,Color3.fromRGB(74,58,43),m)
 trunk.CanCollide=true
 for _,o in ipairs({Vector3.new(0,11,0),Vector3.new(2.8,10,1),Vector3.new(-2.5,9,-1),Vector3.new(0,13,2),Vector3.new(-1,12,-2)}) do
  local c=part("Crown",Vector3.new(6.8,6.2,6.8)*scale,CFrame.new(pos+o*scale),Enum.Material.Grass,Color3.fromRGB(48,82,45),m,0)
  c.Shape=Enum.PartType.Ball;c.CanCollide=false
 end
 return m
end
local function bush(pos,s)
 local m=Instance.new("Model");m.Name="ForestBush";m.Parent=life
 for _,o in ipairs({Vector3.new(-1,0,0),Vector3.new(1,0,.5),Vector3.new(0,.5,1)}) do
  local c=part("LeafMass",Vector3.new(3.8,2.8,3.8)*s,CFrame.new(pos+o*s),Enum.Material.Grass,Color3.fromRGB(42,73,40),m);c.Shape=Enum.PartType.Ball;c.CanCollide=false
 end
end
local function createBear(pos,index)
 local m=Instance.new("Model");m.Name="ForestBear_"..index;m.Parent=life
 local root=part("Root",Vector3.new(2,2,2),CFrame.new(pos+Vector3.new(0,2.5,0)),Enum.Material.SmoothPlastic,nil,m,1);root.CanCollide=false
 local body=part("Body",Vector3.new(5.4,4.2,7),CFrame.new(pos+Vector3.new(0,3.1,0)),Enum.Material.SmoothPlastic,Color3.fromRGB(72,48,32),m);body.Shape=Enum.PartType.Ball;body.CanCollide=false
 local chest=part("Chest",Vector3.new(3.8,3.3,2.4),CFrame.new(pos+Vector3.new(0,3.4,-3.1)),Enum.Material.SmoothPlastic,Color3.fromRGB(102,70,48),m);chest.Shape=Enum.PartType.Ball;chest.CanCollide=false
 local head=part("Head",Vector3.new(3.6,3.3,3.6),CFrame.new(pos+Vector3.new(0,5.2,-3.1)),Enum.Material.SmoothPlastic,Color3.fromRGB(67,44,30),m);head.Shape=Enum.PartType.Ball;head.CanCollide=false
 for _,x in ipairs({-1.35,1.35}) do
  local ear=part("Ear",Vector3.new(1.25,1.25,1.25),CFrame.new(pos+Vector3.new(x,6.7,-3.1)),Enum.Material.SmoothPlastic,Color3.fromRGB(60,39,27),m);ear.Shape=Enum.PartType.Ball;ear.CanCollide=false
 end
 local muzzle=part("Muzzle",Vector3.new(2.1,1.5,1.7),CFrame.new(pos+Vector3.new(0,4.8,-4.7)),Enum.Material.SmoothPlastic,Color3.fromRGB(113,78,52),m);muzzle.Shape=Enum.PartType.Ball;muzzle.CanCollide=false
 for _,x in ipairs({-1,1}) do
  local eye=part("Eye",Vector3.new(.28,.28,.28),CFrame.new(pos+Vector3.new(x*.65,5.55,-4.72)),Enum.Material.Neon,Color3.fromRGB(255,190,70),m);eye.Shape=Enum.PartType.Ball;eye.CanCollide=false
  for _,z in ipairs({-2.1,2.1}) do local leg=part("Leg",Vector3.new(1.25,2.7,1.25),CFrame.new(pos+Vector3.new(x*1.65,1.55,z)),Enum.Material.SmoothPlastic,Color3.fromRGB(61,40,28),m);leg.Shape=Enum.PartType.Ball;leg.CanCollide=false end
 end
 m.PrimaryPart=root
 local hum=Instance.new("Humanoid");hum.MaxHealth=250;hum.Health=250;hum.WalkSpeed=0;hum.DisplayName="Лесной медведь";hum.Parent=m
 m:SetAttribute("AggroRange",34);m:SetAttribute("AttackRange",7);m:SetAttribute("Damage",22);m:SetAttribute("AttackCooldown",2.2);m:SetAttribute("HomeX",pos.X);m:SetAttribute("HomeZ",pos.Z)
 local prompt=Instance.new("ProximityPrompt",head);prompt.ActionText="Осмотреть";prompt.ObjectText="Дикий медведь";prompt.HoldDuration=.5;prompt.MaxActivationDistance=8
 return m
end

-- A wide irregular forest belt around the playable village, deliberately leaving the village center open.
local rng=Random.new(7319)
for i=1,150 do
 local a=rng:NextNumber(0,math.pi*2);local r=rng:NextNumber(125,178)
 local p=Vector3.new(math.cos(a)*r,0,math.sin(a)*r)
 tree(p,rng:NextNumber(.82,1.28))
end
for i=1,85 do
 local a=rng:NextNumber(0,math.pi*2);local r=rng:NextNumber(105,165)
 bush(Vector3.new(math.cos(a)*r,1,math.sin(a)*r),rng:NextNumber(.7,1.2))
end

-- Fallen logs / stones make the forest edge read as a real environment instead of a wall of trees.
for i=1,35 do
 local a=rng:NextNumber(0,math.pi*2);local r=rng:NextNumber(105,165);local p=Vector3.new(math.cos(a)*r,.45,math.sin(a)*r)
 if i%2==0 then part("FallenLog",Vector3.new(7,.8,.9),CFrame.new(p)*CFrame.Angles(0,rng:NextNumber(0,math.pi),rng:NextNumber(-.12,.12)),Enum.Material.Wood,Color3.fromRGB(79,58,42),life) else local s=rng:NextNumber(1,2.4);local rock=part("ForestRock",Vector3.new(s, s*.65,s*1.2),CFrame.new(p),Enum.Material.Slate,Color3.fromRGB(83,87,78),life);rock.Shape=Enum.PartType.Ball end
end

-- Bear patrols sit in the forest, not in the village.
local bears={createBear(Vector3.new(-138,0,105),1),createBear(Vector3.new(145,0,-112),2),createBear(Vector3.new(-150,0,-112),3)}
local lastAttack={}
local function nearestPlayer(m)
 local best,dist=nil,math.huge
 for _,p in ipairs(Players:GetPlayers()) do
  local c=p.Character;local hrp=c and c:FindFirstChild("HumanoidRootPart");local hum=c and c:FindFirstChildOfClass("Humanoid")
  if hrp and hum and hum.Health>0 then local d=(hrp.Position-m.PrimaryPart.Position).Magnitude;if d<dist then best,dist=p,d end end
 end
 return best,dist
end
RunService.Heartbeat:Connect(function(dt)
 for _,bear in ipairs(bears) do
  if bear.Parent and bear.PrimaryPart then
   local p,d=nearestPlayer(bear);local range=bear:GetAttribute("AggroRange") or 34
   if p and d<=range then
    local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    local hum=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
    if hrp and hum then
     local dir=hrp.Position-bear.PrimaryPart.Position;dir=Vector3.new(dir.X,0,dir.Z)
     if dir.Magnitude>1 then bear:PivotTo(CFrame.lookAt(bear.PrimaryPart.Position,bear.PrimaryPart.Position+dir.Unit)) end
     if d<=(bear:GetAttribute("AttackRange") or 7) then
      local now=os.clock();if now-(lastAttack[p] or 0)>=(bear:GetAttribute("AttackCooldown") or 2.2) then lastAttack[p]=now;hum:TakeDamage(bear:GetAttribute("Damage") or 22) end
     end
    end
   end
  end
 end
end)

local at=Lighting:FindFirstChild("ForestAtmosphere") or Instance.new("Atmosphere",Lighting);at.Name="ForestAtmosphere";at.Density=.31;at.Offset=.08;at.Haze=1.25;at.Glare=.06
local cc=Lighting:FindFirstChild("ForestColor") or Instance.new("ColorCorrectionEffect",Lighting);cc.Name="ForestColor";cc.Contrast=.1;cc.Saturation=.08;cc.Brightness=.01
