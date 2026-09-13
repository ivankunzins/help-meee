-- SECRET VILLAGE UNIFIED WORLD v1
-- One authoritative environment. No stacked visual passes, no roads, no exposed secret labels.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local Terrain=Workspace.Terrain

if Workspace:FindFirstChild("SECRET_VILLAGE_UNIFIED_WORLD") then return end
local ROOT=Instance.new("Folder");ROOT.Name="SECRET_VILLAGE_UNIFIED_WORLD";ROOT.Parent=Workspace

-- Remove old generated visual layers. Gameplay systems and SECRET_DISCOVERIES remain.
local remove={
 "SECRET_VILLAGE_LIFE","FINAL_ART_PASS","SECRET_VILLAGE_WORLD_FINAL","SECRET_VILLAGE_FINAL_MASTER",
 "GRAPHICS_OVERHAUL","GRAPHICS_OVERHAUL_V2","GRAPHICS_CINEMATIC","GRAPHICS_HERO_PROPS","GRAPHICS_HERO_ASSETS",
 "ARCHITECTURE_FINAL","VISUAL_WORLD_V2","WORLD_FINAL","VISUAL_MASTER","VISUAL_PRESENTATION_FINAL",
 "SECRET_VILLAGE_RURAL_DETAIL","SECRET_VILLAGE_PRESENTATION_RECOVERY","TerrainFinish","ArchitectureFinish",
 "VillageSquareFinish","RiverFinish","FarmFinish","FOREST_PERIMETER","FOREST_FLOOR","DANGEROUS_BEAR_ZONE"
}
for _,n in ipairs(remove) do local x=Workspace:FindFirstChild(n);if x then x:Destroy()end end
for _,n in ipairs({"MainRoad","CrossRoad","Road","Roads"}) do local x=Workspace:FindFirstChild(n);if x then x:Destroy()end end

local function part(parent,name,size,pos,mat,trans,collide)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Position=pos;p.Anchored=true;p.Material=mat or Enum.Material.Wood;p.Transparency=trans or 0;p.CanCollide=collide~=false;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
local function ball(parent,name,size,pos,mat)
 local p=part(parent,name,size,pos,mat,false,false);p.Shape=Enum.PartType.Ball;return p
end
local function cyl(parent,name,size,pos,mat)
 local p=part(parent,name,size,pos,mat);p.Shape=Enum.PartType.Cylinder;return p
end
local function wedge(parent,name,size,pos,rot,mat)
 local p=part(parent,name,size,pos,mat);p.Shape=Enum.PartType.Wedge;p.CFrame=CFrame.new(pos)*CFrame.Angles(0,math.rad(rot or 0),0);return p
end

-- Continuous meadow: the village sits in grass, with only narrow organic footpaths.
part(ROOT,"Meadow",Vector3.new(440,2,440),Vector3.new(0,-1.2,0),Enum.Material.Grass,0,false)
Terrain.GrassLength=.08

-- River corridor. Terrain water + hidden solid bed prevents falling through the world.
local river=Instance.new("Folder");river.Name="RIVER";river.Parent=ROOT
Terrain:FillBlock(CFrame.new(-45,-.7,0),Vector3.new(30,3,330),Enum.Material.Water)
Terrain:FillBlock(CFrame.new(-45,-.7,65),Vector3.new(42,3,90),Enum.Material.Water)
part(river,"RiverBed",Vector3.new(42,.8,330),Vector3.new(-45,-3.1,0),Enum.Material.Ground,0,true)
part(river,"RiverBankWest",Vector3.new(5,1,330),Vector3.new(-66,.1,0),Enum.Material.Ground,0,false)
part(river,"RiverBankEast",Vector3.new(5,1,330),Vector3.new(-24,.1,0),Enum.Material.Ground,0,false)
for z=-150,150,12 do
 local side=(z/12)%2==0 and -1 or 1
 ball(river,"ShoreRock",Vector3.new(2.8,1.1,2.1),Vector3.new(-45+side*16,.55,z+math.random(-3,3)),Enum.Material.Slate)
end

-- Bridge connecting both sides of the village.
local bridge=Instance.new("Model");bridge.Name="VillageBridge";bridge.Parent=ROOT
part(bridge,"Deck",Vector3.new(50,.8,10),Vector3.new(-45,.9,18),Enum.Material.WoodPlanks)
for x=-68,-22,7 do
 part(bridge,"RailPost",Vector3.new(.45,4,.45),Vector3.new(x,2.7,13.8),Enum.Material.Wood)
 part(bridge,"RailPost",Vector3.new(.45,4,.45),Vector3.new(x,2.7,22.2),Enum.Material.Wood)
end
part(bridge,"RailA",Vector3.new(48,.4,.4),Vector3.new(-45,4.2,13.8),Enum.Material.Wood)
part(bridge,"RailB",Vector3.new(48,.4,.4),Vector3.new(-45,4.2,22.2),Enum.Material.Wood)

-- Finished village houses with distinct silhouettes.
local function house(name,x,z,w,d,wall)
 local m=Instance.new("Model");m.Name=name;m.Parent=ROOT
 part(m,"Body",Vector3.new(w,7,d),Vector3.new(x,3.5,z),Enum.Material.WoodPlanks,0,true)
 part(m,"Foundation",Vector3.new(w+1,.5,d+1),Vector3.new(x,.25,z),Enum.Material.Slate)
 part(m,"Door",Vector3.new(2.4,3.8,.25),Vector3.new(x,2.3,z-d/2-.14),Enum.Material.Wood)
 for _,dx in ipairs({-w*.27,w*.27}) do
  part(m,"Window",Vector3.new(3,2.3,.18),Vector3.new(x+dx,4.2,z-d/2-.15),Enum.Material.Glass,.18,false)
  part(m,"WindowFrame",Vector3.new(3.4,.25,.35),Vector3.new(x+dx,4.2,z-d/2-.3),Enum.Material.Wood,false,false)
 end
 part(m,"Porch",Vector3.new(math.min(11,w*.65),.35,2.7),Vector3.new(x,.55,z-d/2-1.3),Enum.Material.WoodPlanks)
 for _,dx in ipairs({-3,3}) do part(m,"Post",Vector3.new(.25,3,.25),Vector3.new(x+dx,2,z-d/2-2.3),Enum.Material.Wood) end
 wedge(m,"RoofL",Vector3.new(w/2+1,d+1,4.2),Vector3.new(x-w/4,8.8,z),0,Enum.Material.Slate)
 wedge(m,"RoofR",Vector3.new(w/2+1,d+1,4.2),Vector3.new(x+w/4,8.8,z),180,Enum.Material.Slate)
 part(m,"Chimney",Vector3.new(1.5,2.8,1.5),Vector3.new(x+w*.25,10,z+.8),Enum.Material.Brick)
end
house("VillageHouse_A",-105,-45,20,16,Color3.fromRGB(166,124,87))
house("VillageHouse_B",-10,-65,22,17,Color3.fromRGB(177,133,91))
house("VillageHouse_C",35,-30,20,15,Color3.fromRGB(151,113,82))
house("VillageHouse_D",70,5,23,17,Color3.fromRGB(183,139,98))
house("VillageHouse_E",-100,65,21,16,Color3.fromRGB(159,119,84))
house("VillageHouse_F",15,80,20,15,Color3.fromRGB(176,130,88))
house("Bakery",58,-5,23,17,Color3.fromRGB(188,146,103))
house("Village Shop",88,42,23,17,Color3.fromRGB(156,119,88))
house("Old House",-75,-5,19,15,Color3.fromRGB(135,101,76))
house("Forest Cabin",95,-70,19,15,Color3.fromRGB(132,99,72))
house("Garage",42,78,22,16,Color3.fromRGB(119,112,98))

-- Square with fountain, seating and mature trees; no text/sign clutter.
local square=Instance.new("Model");square.Name="VillageSquare";square.Parent=ROOT
for i=1,16 do local a=i*math.pi*2/16;ball(square,"Stone",Vector3.new(2.2,.5,1.5),Vector3.new(25+math.cos(a)*12,.25,-45+math.sin(a)*12),Enum.Material.Slate)end
cyl(square,"FountainBase",Vector3.new(12,.8,12),Vector3.new(25,.7,-45),Enum.Material.Marble)
cyl(square,"FountainBasin",Vector3.new(8,.6,8),Vector3.new(25,1.3,-45),Enum.Material.Marble)
cyl(square,"FountainPillar",Vector3.new(2,4,2),Vector3.new(25,3.4,-45),Enum.Material.Marble)
part(square,"FountainWater",Vector3.new(7,.15,7),Vector3.new(25,1.62,-45),Enum.Material.Water,0,false)
for _,v in ipairs({Vector3.new(10,.5,-55),Vector3.new(40,.5,-55),Vector3.new(10,.5,-35),Vector3.new(40,.5,-35)}) do
 part(square,"Bench",Vector3.new(4,.3,1),v,Enum.Material.WoodPlanks)
end

-- Trees are placed as silhouettes around homes and thickly around the perimeter.
local forest=Instance.new("Folder");forest.Name="FOREST";forest.Parent=ROOT
local rng=Random.new(91273)
local function tree(x,z,s)
 local m=Instance.new("Model");m.Name="Tree";m.Parent=forest
 cyl(m,"Trunk",Vector3.new(1.5*s,8*s,1.5*s),Vector3.new(x,4*s,z),Enum.Material.Wood)
 for i=1,4 do
  local y=(3+i*1.8)*s;local r=(6.5-i*.9)*s
  local c=ball(m,"Crown",Vector3.new(r*2,3.5*s,r*2),Vector3.new(x,y,z),Enum.Material.Grass);c.CanCollide=false
 end
end
for _,v in ipairs({{-125,-25,1.3},{-118,0,1.1},{-120,35,1.4},{-105,95,1.25},{-45,105,1.35},{20,110,1.2},{80,105,1.35},{125,75,1.25},{125,25,1.4},{120,-30,1.2},{115,-85,1.35},{50,-110,1.4},{0,-120,1.2},{-70,-115,1.35},{-125,-95,1.2}}) do tree(v[1],v[2],v[3]) end
for i=1,115 do
 local a=rng:NextNumber(0,math.pi*2);local r=rng:NextNumber(150,215)
 tree(math.cos(a)*r,math.sin(a)*r,rng:NextNumber(.75,1.45))
end

-- Organic footpaths, not roads.
local paths=Instance.new("Folder");paths.Name="FOOTPATHS";paths.Parent=ROOT
for _,route in ipairs({{-105,-45,25,0},{25,-45,65,0},{-75,-5,-25,1}}) do
 local x0,z0,len,vertical=route
 for i=0,math.floor(len/5) do
  local t=i*5;local x=vertical==1 and x0 or x0+t;local z=vertical==1 and z0+t or z0
  ball(paths,"PathStone",Vector3.new(3,.35,2.2),Vector3.new(x,.2,z),Enum.Material.Slate)
 end
end

-- Farm atmosphere.
local farm=Instance.new("Model");farm.Name="Farmstead";farm.Parent=ROOT
part(farm,"Barn",Vector3.new(30,10,22),Vector3.new(-105,5,-100),Enum.Material.WoodPlanks)
wedge(farm,"BarnRoofL",Vector3.new(16,24,4),Vector3.new(-113,11,-100),0,Enum.Material.Slate)
wedge(farm,"BarnRoofR",Vector3.new(16,24,4),Vector3.new(-97,11,-100),180,Enum.Material.Slate)
for x=-120,-90,6 do part(farm,"FencePost",Vector3.new(.25,3,.25),Vector3.new(x,1.5,-82),Enum.Material.Wood)end
part(farm,"FenceRail",Vector3.new(30,.25,.25),Vector3.new(-105,2,-82),Enum.Material.Wood)

-- Quest/job locations get visual focus without giant floating labels.
local function marker(pos,material)
 local m=Instance.new("Model");m.Name="ActivitySpot";m.Parent=ROOT
 part(m,"Pad",Vector3.new(4,.25,4),pos,material or Enum.Material.WoodPlanks,false,false)
 ball(m,"Lantern",Vector3.new(.8,1.2,.8),pos+Vector3.new(0,1.3,0),Enum.Material.Neon)
end
marker(Vector3.new(-20,.15,35),Enum.Material.WoodPlanks) -- courier
marker(Vector3.new(80,.15,25),Enum.Material.Metal) -- taxi
marker(Vector3.new(65,.15,25),Enum.Material.WoodPlanks) -- fishing quest
marker(Vector3.new(35,.15,55),Enum.Material.Marble) -- explorer

-- Bears: fewer, larger and hidden in the forest edge. They chase and damage players.
local bears=Instance.new("Folder");bears.Name="BEARS";bears.Parent=ROOT
local function bear(i,x,z)
 local m=Instance.new("Model");m.Name="Bear_"..i;m.Parent=bears;m:SetAttribute("Dangerous",true)
 local root=part(m,"HumanoidRootPart",Vector3.new(2,2,2),Vector3.new(x,2.5,z),Enum.Material.SmoothPlastic,1,false);m.PrimaryPart=root
 local h=Instance.new("Humanoid");h.MaxHealth=200;h.Health=200;h.WalkSpeed=10;h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None;h.Parent=m
 local body=ball(m,"Body",Vector3.new(6,4.5,4.2),Vector3.new(x,3.2,z),Enum.Material.SmoothPlastic)
 ball(m,"Head",Vector3.new(3.2,3,3.1),Vector3.new(x,5,z-2.8),Enum.Material.SmoothPlastic)
 ball(m,"Muzzle",Vector3.new(1.7,1.2,1.3),Vector3.new(x,4.7,z-4.1),Enum.Material.SmoothPlastic)
 for _,sx in ipairs({-1,1}) do ball(m,"Ear",Vector3.new(.9,.9,.7),Vector3.new(x+sx*1.1,6.2,z-2.9),Enum.Material.SmoothPlastic)end
 for _,sx in ipairs({-1,1}) do ball(m,"Leg",Vector3.new(1.5,2.5,1.5),Vector3.new(x+sx*1.7,1.5,z-.7),Enum.Material.SmoothPlastic);ball(m,"RearLeg",Vector3.new(1.6,2.5,1.6),Vector3.new(x+sx*1.6,1.5,z+1),Enum.Material.SmoothPlastic)end
 ball(m,"Tail",Vector3.new(1.2,1.2,1.2),Vector3.new(x,3.8,z+2.3),Enum.Material.SmoothPlastic)
end
for i,v in ipairs({{-155,-145},{155,-120},{-175,80},{170,95},{-105,170},{100,175}}) do bear(i,v[1],v[2])end
task.spawn(function()
 while ROOT.Parent do
  for _,b in ipairs(bears:GetChildren()) do
   local h=b:FindFirstChildOfClass("Humanoid");local r=b.PrimaryPart
   if h and r and h.Health>0 then
    local target,dist=nil,math.huge
    for _,p in ipairs(Players:GetPlayers()) do
     local ch=p.Character;local pr=ch and ch:FindFirstChild("HumanoidRootPart");local ph=ch and ch:FindFirstChildOfClass("Humanoid")
     if pr and ph and ph.Health>0 then local d=(pr.Position-r.Position).Magnitude;if d<dist and d<55 then target,dist=p,d end end
    end
    if target then
     local ch=target.Character;local pr=ch and ch:FindFirstChild("HumanoidRootPart");local ph=ch and ch:FindFirstChildOfClass("Humanoid")
     if pr and ph then h:MoveTo(pr.Position);if dist<6 then ph:TakeDamage(24)end end
    end
   end
  end
  task.wait(.4)
 end
end)

-- Remove all world text created by old art passes. Secret/quest prompts are ProximityPrompts and remain.
for _,d in ipairs(Workspace:GetDescendants()) do
 if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then d:Destroy() end
end

Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.Brightness=2.1
Lighting.ClockTime=14.5
Lighting.ExposureCompensation=.02
Lighting.EnvironmentDiffuseScale=.55
Lighting.EnvironmentSpecularScale=.7
local at=Lighting:FindFirstChild("SecretVillageUnifiedAtmosphere") or Instance.new("Atmosphere",Lighting);at.Name="SecretVillageUnifiedAtmosphere";at.Density=.27;at.Haze=.85;at.Glare=.07;at.Color=Color3.fromRGB(205,220,225);at.Decay=Color3.fromRGB(120,136,148)
local cc=Lighting:FindFirstChild("SecretVillageUnifiedGrade") or Instance.new("ColorCorrectionEffect",Lighting);cc.Name="SecretVillageUnifiedGrade";cc.Brightness=.015;cc.Contrast=.1;cc.Saturation=.06;cc.TintColor=Color3.fromRGB(255,249,239)
print("SECRET VILLAGE UNIFIED WORLD: ONE WORLD LAYER | grass + houses + river + forest + quests + bears | no roads | no world labels")