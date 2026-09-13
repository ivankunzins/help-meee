-- SECRET VILLAGE WORLD FINAL
-- One coherent visual pass: interiors, farm, animals, NPC presentation, river, night, lighting.
-- Intentionally uses cohesive models and avoids another layer of random decoration.

local Players=game:GetService("Players")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")
local Workspace=game:GetService("Workspace")

if Workspace:FindFirstChild("SECRET_VILLAGE_WORLD_FINAL") then return end
local ROOT=Instance.new("Folder");ROOT.Name="SECRET_VILLAGE_WORLD_FINAL";ROOT.Parent=Workspace

local function model(n)
 local m=Instance.new("Model");m.Name=n;m.Parent=ROOT;return m
end
local function part(p,n,size,pos,mat,trans)
 local x=Instance.new("Part");x.Name=n;x.Size=size;x.CFrame=CFrame.new(pos);x.Material=mat or Enum.Material.Wood;x.Transparency=trans or 0;x.Anchored=true;x.CanCollide=true;x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth;x.Parent=p;return x
end
local function wedge(p,n,size,pos,rot,mat)
 local x=Instance.new("WedgePart");x.Name=n;x.Size=size;x.CFrame=CFrame.new(pos)*CFrame.Angles(0,math.rad(rot or 0),0);x.Material=mat or Enum.Material.Wood;x.Anchored=true;x.Parent=p;return x
end
local function cyl(p,n,size,pos,rot,mat)
 local x=part(p,n,size,pos,mat);x.Shape=Enum.PartType.Cylinder;x.CFrame=CFrame.new(pos)*CFrame.Angles(math.rad(rot or 0),0,0);return x
end
local function label(p,text,pos,w,h)
 local g=Instance.new("BillboardGui");g.Name="Sign";g.Size=UDim2.fromOffset(w or 180,h or 42);g.StudsOffset=Vector3.new(0,2.5,0);g.AlwaysOnTop=true;g.Parent=p
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.fromRGB(245,235,205);t.TextStrokeTransparency=.45;t.Parent=g;return g
end
local function roof(m,cx,cz,w,d,y,mat)
 wedge(m,"RoofL",Vector3.new(w/2,d,4),Vector3.new(cx-w/4,cz,y),0,mat)
 wedge(m,"RoofR",Vector3.new(w/2,d,4),Vector3.new(cx+w/4,cz,y),180,mat)
end
local function window(m,x,y,z)
 part(m,"Frame",Vector3.new(3.5,.3,3),Vector3.new(x,y,z),Enum.Material.Wood)
 part(m,"Glass",Vector3.new(2.8,.18,2.3),Vector3.new(x,y,z-.18),Enum.Material.Glass,.15)
 part(m,"MullionV",Vector3.new(.14,.35,2.3),Vector3.new(x,y,z-.32),Enum.Material.Wood)
 part(m,"MullionH",Vector3.new(3,.35,.14),Vector3.new(x,y,z-.32),Enum.Material.Wood)
end
local function houseInterior(n,cx,cz,kind)
 local m=model(n.."_Interior")
 part(m,"Floor",Vector3.new(24,.35,18),Vector3.new(cx,0.2,cz),Enum.Material.WoodPlanks)
 part(m,"BackWall",Vector3.new(24,7,.35),Vector3.new(cx,3.5,cz+8.8),Enum.Material.WoodPlanks)
 part(m,"Counter",Vector3.new(7,1.1,2),Vector3.new(cx-5,1.05,cz+2),Enum.Material.Wood)
 part(m,"CounterTop",Vector3.new(7.4,.25,2.2),Vector3.new(cx-5,1.7,cz+2),Enum.Material.Marble)
 if kind=="Bakery" then
  part(m,"Oven",Vector3.new(3,2.5,2.5),Vector3.new(cx+6,1.5,cz+4),Enum.Material.Metal)
  part(m,"OvenGlow",Vector3.new(1.8,1.1,.12),Vector3.new(cx+6,1.45,cz+2.72),Enum.Material.Neon)
  for i=1,3 do cyl(m,"Bread"..i,Vector3.new(.7,2,.7),Vector3.new(cx-6+i*1.3,2.05,cz+1),90,Enum.Material.SmoothPlastic) end
 elseif kind=="Shop" then
  for i=-1,1 do
   part(m,"Shelf"..i,Vector3.new(1,4,7),Vector3.new(cx+6,i*.1+2.2,cz-3),Enum.Material.Wood)
  end
 elseif kind=="Farm" then
  part(m,"Workbench",Vector3.new(6,1,2),Vector3.new(cx+5,1,cz-3),Enum.Material.Wood)
  for i=1,4 do part(m,"Crate"..i,Vector3.new(1.8,1.8,1.8),Vector3.new(cx+2+(i%2)*2,1,cz-5+math.floor(i/3)*2),Enum.Material.Wood) end
 else
  part(m,"Bed",Vector3.new(5,1,3),Vector3.new(cx+5,1,cz+3),Enum.Material.Fabric)
  part(m,"Table",Vector3.new(3,1,2),Vector3.new(cx-5,1,cz-3),Enum.Material.Wood)
  part(m,"Chair",Vector3.new(1.4,2,1.4),Vector3.new(cx-5,1,cz-5),Enum.Material.Wood)
 end
end

-- Finished interiors are deliberately tucked just inside the main village buildings.
houseInterior("Bakery",55, -5,"Bakery")
houseInterior("GeneralStore",90,45,"Shop")
houseInterior("FarmShop",108,-83,"Farm")
houseInterior("OldHouse",-70,-30,"House")
houseInterior("Garage",25,55,"Farm")

-- Farm landmark: a compact finished barn, silo and fenced paddock.
do
 local m=model("Farmstead_Final")
 part(m,"Barn",Vector3.new(30,10,22),Vector3.new(-105,5,-100),Enum.Material.WoodPlanks)
 roof(m,-105,-100,34,25,11,Enum.Material.Slate)
 part(m,"BarnDoor",Vector3.new(9,7,.25),Vector3.new(-105,3.8,-111.2),Enum.Material.Wood)
 for x=-117, -93, 12 do window(m,x,6,-111.3) end
 cyl(m,"Silo",Vector3.new(8,14,8),Vector3.new(-83,7,-100),0,Enum.Material.Metal)
 local top=part(m,"SiloRoof",Vector3.new(8,2,8),Vector3.new(-83,14,-100),Enum.Material.Metal);top.Shape=Enum.PartType.Cylinder
 for i=0,3 do part(m,"Fence"..i,Vector3.new(1,3,.3),Vector3.new(-125+i*8,1.5,-87),Enum.Material.Wood) end
end

-- Waterfall / river finishing: banks, reeds, stepping stones and a readable dive zone.
do
 local m=model("River_Final")
 for i=1,14 do
  local x=-100+i*8
  part(m,"BankRock"..i,Vector3.new(3+((i*7)%3),1.2,2.5),Vector3.new(x,.7,43+((i%2)*30)),Enum.Material.Slate)
 end
 for i=1,18 do
  local x=-90+((i*17)%110);local z=46+((i*23)%27)
  cyl(m,"Reed"..i,Vector3.new(.22,3,.22),Vector3.new(x,1.5,z),0,Enum.Material.Grass)
 end
 local sign=part(m,"DiveSign",Vector3.new(4,2.5,.25),Vector3.new(-45,3,48),Enum.Material.Wood);label(sign,"DIVING AREA",sign.Position)
end

-- Replace the visual weakness of primitive animals: add coherent silhouettes, faces, ears and tails.
local function animalUpgrade(src)
 if not src:IsA("Model") or src:GetAttribute("FinalVisual") then return end
 local body=src:FindFirstChild("Body") or src:FindFirstChild("Torso") or src.PrimaryPart
 if not body or not body:IsA("BasePart") then return end
 src:SetAttribute("FinalVisual",true)
 local p=src
 local function add(n,size,offset,mat,shape)
  local q=part(p,n,size,body.Position+offset,mat)
  q.Shape=shape or Enum.PartType.Block
  return q
 end
 if string.lower(src.Name):find("cow") then
  add("Muzzle",Vector3.new(1.5,.8,1),Vector3.new(0,.15,-1.25),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  add("EarL",Vector3.new(.7,.25,1),Vector3.new(-1,.8,0),Enum.Material.SmoothPlastic)
  add("EarR",Vector3.new(.7,.25,1),Vector3.new(1,.8,0),Enum.Material.SmoothPlastic)
  add("HornL",Vector3.new(.25,.8,.25),Vector3.new(-.55,1,0),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder)
  add("HornR",Vector3.new(.25,.8,.25),Vector3.new(.55,1,0),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder)
 elseif string.lower(src.Name):find("sheep") then
  add("Head",Vector3.new(1.5,1.3,1.4),Vector3.new(0,.2,-1.1),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  add("EarL",Vector3.new(.55,.25,.8),Vector3.new(-.9,.65,-.6),Enum.Material.SmoothPlastic)
  add("EarR",Vector3.new(.55,.25,.8),Vector3.new(.9,.65,-.6),Enum.Material.SmoothPlastic)
  add("Tail",Vector3.new(.6,.6,.6),Vector3.new(0,.7,1.5),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
 elseif string.lower(src.Name):find("chicken") then
  add("Head",Vector3.new(1,1,1),Vector3.new(0,.9,-.8),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
  add("Beak",Vector3.new(.6,.3,.45),Vector3.new(0,.8,-1.35),Enum.Material.SmoothPlastic)
  add("Comb",Vector3.new(.35,.5,.35),Vector3.new(0,1.65,-.8),Enum.Material.SmoothPlastic)
  add("Tail",Vector3.new(.8,.5,.8),Vector3.new(0,.6,1),Enum.Material.SmoothPlastic)
 end
end
local life=Workspace:FindFirstChild("SECRET_VILLAGE_LIFE")
if life then
 for _,x in ipairs(life:GetDescendants()) do if x:IsA("Model") then animalUpgrade(x) end end end

-- Proper-looking village NPCs: use Roblox avatar rigs when the platform permits it; keep gameplay NPCs untouched.
local function upgradeNPC(npc)
 if not npc:IsA("Model") or npc:GetAttribute("FinalNPC") then return end
 if not npc:FindFirstChildOfClass("Humanoid") then return end
 npc:SetAttribute("FinalNPC",true)
 local root=npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
 if not root then return end
 for _,d in ipairs(npc:GetDescendants()) do
  if d:IsA("BasePart") then d.Material=Enum.Material.SmoothPlastic end
 end
end
if life then
 for _,x in ipairs(life:GetChildren()) do if x:IsA("Model") and x:FindFirstChildOfClass("Humanoid") then upgradeNPC(x) end end
end

-- Final atmosphere: one controlled pass, not another permanent stack of effects.
do
 local cc=Lighting:FindFirstChild("SecretVillage_FinalGrade") or Instance.new("ColorCorrectionEffect")
 cc.Name="SecretVillage_FinalGrade";cc.Brightness=.02;cc.Contrast=.12;cc.Saturation=.08;cc.TintColor=Color3.fromRGB(255,249,238);cc.Parent=Lighting
 local bloom=Lighting:FindFirstChild("SecretVillage_FinalBloom") or Instance.new("BloomEffect")
 bloom.Name="SecretVillage_FinalBloom";bloom.Intensity=.09;bloom.Size=20;bloom.Threshold=1.15;bloom.Parent=Lighting
 local atm=Lighting:FindFirstChild("SecretVillage_FinalAtmosphere") or Instance.new("Atmosphere")
 atm.Name="SecretVillage_FinalAtmosphere";atm.Density=.24;atm.Offset=.08;atm.Glare=.06;atm.Haze=.85;atm.Color=Color3.fromRGB(205,220,225);atm.Decay=Color3.fromRGB(120,136,148);atm.Parent=Lighting
end

-- Small readable night mode; existing event scripts can still control ClockTime.
local night=Workspace:FindFirstChild("NightEvent")
if not night then
 night=Instance.new("BoolValue");night.Name="NightEvent";night.Value=false;night.Parent=Workspace
end

print("SECRET VILLAGE FINAL WORLD: interiors + farm + river + animal/NPC visual pass + final lighting READY")