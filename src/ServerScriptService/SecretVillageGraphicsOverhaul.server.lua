-- SECRET VILLAGE GRAPHICS OVERHAUL v1
-- Full visual pass: architecture, roads, landscaping, props, lighting, river edges,
-- street furniture and small details. Gameplay scripts are left untouched.
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")

local art=world:FindFirstChild("GRAPHICS_OVERHAUL") or Instance.new("Folder")
art.Name="GRAPHICS_OVERHAUL";art.Parent=world
if art:GetAttribute("Built") then return end
art:SetAttribute("Built",true)

local function p(name,size,cf,mat,color,parent,collide)
 local x=Instance.new("Part")
 x.Name=name;x.Size=size;x.CFrame=cf;x.Anchored=true;x.CanCollide=collide~=false
 x.CanTouch=false;x.CanQuery=false;x.Material=mat or Enum.Material.SmoothPlastic
 if color then x.Color=color end
 x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth
 x.Parent=parent or art
 return x
end
local function cyl(name,radius,height,cf,mat,color,parent)
 local x=p(name,Vector3.new(radius*2,height,radius*2),cf,mat,color,parent)
 x.Shape=Enum.PartType.Cylinder
 return x
end
local function ball(name,size,cf,mat,color,parent)
 local x=p(name,Vector3.new(size,size,size),cf,mat,color,parent,false);x.Shape=Enum.PartType.Ball;return x
end
local function wedge(name,size,cf,mat,color,parent)
 local x=Instance.new("WedgePart");x.Name=name;x.Size=size;x.CFrame=cf;x.Anchored=true;x.CanCollide=true;x.CanTouch=false;x.CanQuery=false;x.Material=mat or Enum.Material.SmoothPlastic
 if color then x.Color=color end;x.Parent=parent or art;return x
end
local function light(parent,color,brightness,range)
 local l=Instance.new("PointLight");l.Color=color;l.Brightness=brightness;l.Range=range;l.Shadows=true;l.Parent=parent;return l
end
local function surfaceText(parent,text,face)
 local sg=Instance.new("SurfaceGui");sg.Face=face or Enum.NormalId.Front;sg.AlwaysOnTop=false;sg.Parent=parent
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.fromRGB(245,232,201);t.Parent=sg
end

local wood=Color3.fromRGB(105,76,51)
local woodDark=Color3.fromRGB(66,50,38)
local woodLight=Color3.fromRGB(143,103,67)
local plaster=Color3.fromRGB(206,196,177)
local stone=Color3.fromRGB(112,112,103)
local metal=Color3.fromRGB(54,57,55)
local glass=Color3.fromRGB(91,153,171)
local green=Color3.fromRGB(68,100,52)
local green2=Color3.fromRGB(92,126,65)
local flower=Color3.fromRGB(202,116,91)
local warm=Color3.fromRGB(255,201,132)

-- Ground layers: the village no longer reads as a collection of floating blocks.
p("GrassGround",Vector3.new(290,.35,260),CFrame.new(0,-.05,0),Enum.Material.Grass,Color3.fromRGB(78,105,61),art,false)
p("DirtShoulder",Vector3.new(232,.18,20),CFrame.new(0,.32,0),Enum.Material.Ground,Color3.fromRGB(103,84,61),art,false)
p("DirtShoulder",Vector3.new(20,.18,212),CFrame.new(0,.32,0),Enum.Material.Ground,Color3.fromRGB(103,84,61),art,false)

-- Road edge lines, broken center markings and curb stones.
for z=-103,103,8 do
 p("RoadCenterMark",Vector3.new(.28,.035,4.2),CFrame.new(0,.48,z),Enum.Material.Concrete,Color3.fromRGB(224,207,153),art,false)
end
for x=-112,112,8 do
 p("RoadCenterMark",Vector3.new(4.2,.035,.28),CFrame.new(x,.48,0),Enum.Material.Concrete,Color3.fromRGB(224,207,153),art,false)
end
for x=-112,112,5 do
 p("RoadCurb",Vector3.new(4.5,.28,.55),CFrame.new(x,.43,7.45),Enum.Material.Concrete,Color3.fromRGB(137,137,129),art,false)
 p("RoadCurb",Vector3.new(4.5,.28,.55),CFrame.new(x,.43,-7.45),Enum.Material.Concrete,Color3.fromRGB(137,137,129),art,false)
end
for z=-103,103,5 do
 p("RoadCurb",Vector3.new(.55,.28,4.5),CFrame.new(7.45,.43,z),Enum.Material.Concrete,Color3.fromRGB(137,137,129),art,false)
 p("RoadCurb",Vector3.new(.55,.28,4.5),CFrame.new(-7.45,.43,z),Enum.Material.Concrete,Color3.fromRGB(137,137,129),art,false)
end

-- Detailed windows: frame, sill, mullions, warm interior glow.
local function window(cx,cy,cz,w,h,rot,parent)
 local cf=CFrame.new(cx,cy,cz)*CFrame.Angles(0,rot or 0,0)
 p("WindowGlass",Vector3.new(w,h,.18),cf,Enum.Material.Glass,glass,parent,false)
 local fw=.22
 for sx=-1,1,2 do p("WindowFrame",Vector3.new(fw,h+.35,.28),cf*CFrame.new(sx*(w/2),0,-.08),Enum.Material.Wood,woodDark,parent,false) end
 for sy=-1,1,2 do p("WindowFrame",Vector3.new(w+.35,fw,.28),cf*CFrame.new(0,sy*(h/2),-.08),Enum.Material.Wood,woodDark,parent,false) end
 p("MullionV",Vector3.new(.16,h,.3),cf*CFrame.new(0,0,-.13),Enum.Material.Wood,woodDark,parent,false)
 p("MullionH",Vector3.new(w,.16,.3),cf*CFrame.new(0,0,-.13),Enum.Material.Wood,woodDark,parent,false)
 p("WindowSill",Vector3.new(w+.7,.22,.5),cf*CFrame.new(0,-h/2-.25,-.05),Enum.Material.Wood,woodLight,parent,false)
end

-- Architectural detailing for every generated house.
local houseInfo={
 {"Bakery",55,-5,1}, {"Village Shop",90,45,.9}, {"Old House",-70,-30,1.15},
 {"Garage",70,90,1.1}, {"Forest Cabin",-75,75,.85}
}
local function detailedHouse(info)
 local name,x,z,s=info
 local f=Instance.new("Folder");f.Name="Architecture_"..name;f.Parent=art
 local w=18*s;local d=16*s;local h=10*s
 -- stone foundation
 p("Foundation",Vector3.new(w+1,.7,d+1),CFrame.new(x,.55,z),Enum.Material.Slate,stone,f)
 -- horizontal wooden banding
 for yy in {2.1,5.1,8.1} do p("FacadeBeam",Vector3.new(w+.12,.22,d+.12),CFrame.new(x,yy*s,z),Enum.Material.Wood,woodDark,f,false) end
 -- front porch and steps
 p("Porch",Vector3.new(6*s,.35,2.8*s),CFrame.new(x,1.05,z-d/2-1.1*s),Enum.Material.Wood,woodLight,f)
 for i=1,3 do p("Step",Vector3.new(5*s,.28,.65*s),CFrame.new(x,.42+i*.2,z-d/2-.75*s+i*.3),Enum.Material.Slate,stone,f) end
 -- front door framing, door handle and small canopy
 p("DoorFrameL",Vector3.new(.3,7*s,.55),CFrame.new(x-2.15*s,3.8*s,z-d/2-.35),Enum.Material.Wood,woodDark,f)
 p("DoorFrameR",Vector3.new(.3,7*s,.55),CFrame.new(x+2.15*s,3.8*s,z-d/2-.35),Enum.Material.Wood,woodDark,f)
 local door=p("DetailedDoor",Vector3.new(3.7*s,6.7*s,.25),CFrame.new(x,3.65*s,z-d/2-.38),Enum.Material.Wood,woodLight,f)
 for yy=2.2,5.2,3 do p("DoorPanel",Vector3.new(2.7*s,1.8*s,.08),CFrame.new(x,yy*s,z-d/2-.53),Enum.Material.Wood,woodDark,f,false) end
 cyl("DoorHandle",.12,.25,CFrame.new(x+1.2*s,3.6*s,z-d/2-.65)*CFrame.Angles(0,math.rad(90),0),Enum.Material.Metal,Color3.fromRGB(208,173,91),f)
 p("PorchRoof",Vector3.new(7*s,.3,3.6*s),CFrame.new(x,7.8*s,z-d/2-1.2*s),Enum.Material.Slate,woodDark,f)
 -- windows on the front facade
 window(x-5*s,6*s,z-d/2-.32,4*s,3*s,0,f)
 window(x+5*s,6*s,z-d/2-.32,4*s,3*s,0,f)
 -- side windows rotated 90 degrees
 window(x-w/2-.18,6*s,z-2*s,3.5*s,2.8*s,math.rad(90),f)
 window(x+w/2+.18,6*s,z+2*s,3.5*s,2.8*s,math.rad(90),f)
 -- shutters
 for sx=-1,1,2 do
  p("Shutter",Vector3.new(.75*s,3*s,.16),CFrame.new(x+sx*6.8*s,6*s,z-d/2-.48),Enum.Material.Wood,wood,f,false)
 end
 -- roof eaves, ridge and chimney
 p("RoofEaveFront",Vector3.new(w+2*s,.45,1.1*s),CFrame.new(x,10.4*s,z-d/2-.5*s),Enum.Material.Slate,Color3.fromRGB(62,64,61),f)
 p("RoofEaveBack",Vector3.new(w+2*s,.45,1.1*s),CFrame.new(x,10.4*s,z+d/2+.5*s),Enum.Material.Slate,Color3.fromRGB(62,64,61),f)
 p("RoofRidge",Vector3.new(1*s,.55,d+2*s),CFrame.new(x,12*s,z),Enum.Material.Slate,Color3.fromRGB(49,51,49),f)
 local chimney=p("Chimney",Vector3.new(1.7*s,3.2*s,1.7*s),CFrame.new(x+4*s,12.6*s,z+2*s),Enum.Material.Brick,Color3.fromRGB(111,69,54),f)
 p("ChimneyCap",Vector3.new(2*s,.22,2*s),CFrame.new(chimney.Position+Vector3.new(0,1.7*s,0)),Enum.Material.Concrete,Color3.fromRGB(90,89,83),f)
 -- gutters and downspouts
 for sx=-1,1,2 do
  p("Gutter",Vector3.new(w+1*s,.18,.22),CFrame.new(x,10.65*s,z+sx*(d/2+.65*s)),Enum.Material.Metal,metal,f,false)
  p("Downspout",Vector3.new(.18,5*s,.18),CFrame.new(x+sx*(w/2+.5*s),3.2*s,z+sx*.0),Enum.Material.Metal,metal,f,false)
 end
 -- sign for key locations
 local signText=(name=="Bakery" and "BAKERY") or (name=="Village Shop" and "GENERAL STORE") or (name=="Old House" and "OLD HOUSE") or (name=="Garage" and "GARAGE") or "CABIN"
 local sign=p("ShopSign",Vector3.new(6*s,1.15*s,.18),CFrame.new(x,8.4*s,z-d/2-.7*s),Enum.Material.Wood,woodDark,f,false)
 surfaceText(sign,signText,Enum.NormalId.Front)
 if name=="Bakery" then light(sign,warm,1.1,10) end
end
for _,hinfo in ipairs(houseInfo) do detailedHouse(hinfo) end

-- Street lamps with believable arm, lantern and pool of light.
local function streetLamp(x,z)
 local f=Instance.new("Folder");f.Name="StreetLampDetailed";f.Parent=art
 cyl("Pole",.16,6,CFrame.new(x,3,z),Enum.Material.Metal,metal,f)
 cyl("Base",.42,.35,CFrame.new(x,.62,z),Enum.Material.Metal,metal,f)
 p("Arm",Vector3.new(2.1,.16,.16),CFrame.new(x+1.0,5.75,z),Enum.Material.Metal,metal,f,false)
 local lantern=p("Lantern",Vector3.new(.72,.72,.72),CFrame.new(x+1.95,5.48,z),Enum.Material.Glass,Color3.fromRGB(236,196,130),f,false)
 light(lantern,warm,1.25,17)
end
for _,v in ipairs({{14,-8},{14,70},{-14,-70},{-14,20},{48,10},{48,58},{-78,18},{-10,45},{25,-25}}) do streetLamp(v[1],v[2]) end

-- Benches, bins and bollards around the square/park.
local function bench(x,z,rot)
 local f=Instance.new("Folder");f.Name="Bench";f.Parent=art
 local cf=CFrame.new(x,.0,z)*CFrame.Angles(0,rot or 0,0)
 for _,yy in ipairs({1.05,1.7}) do p("BenchSlat",Vector3.new(5,.18,.38),cf*CFrame.new(0,yy,0),Enum.Material.Wood,woodLight,f) end
 p("BenchBack",Vector3.new(5,1.4,.18),cf*CFrame.new(0,2.15,.35),Enum.Material.Wood,woodLight,f)
 for sx=-1,1,2 do p("BenchLeg",Vector3.new(.28,1.0,.28),cf*CFrame.new(sx*1.8,.5,0),Enum.Material.Metal,metal,f) end
end
bench(14,-42,0);bench(36,-42,0);bench(25,-57,math.rad(90));bench(10,48,math.rad(90))
local function bin(x,z)
 local b=cyl("VillageBin",.48,1.1,CFrame.new(x,1.05,z),Enum.Material.Metal,metal,art);b.Shape=Enum.PartType.Cylinder
 p("BinLid",Vector3.new(1.05,.12,1.05),CFrame.new(x,1.62,z),Enum.Material.Metal,Color3.fromRGB(75,78,74),art,false)
end
bin(20,-39);bin(42,-39);bin(15,46);bin(-10,35)
for _,v in ipairs({{-10,-8},{10,-8},{-8,8},{8,8}}) do cyl("Bollard",.16,.9,CFrame.new(v[1],.65,v[2]),Enum.Material.Metal,metal,art) end

-- Fences with posts, caps and diagonal braces.
local function fenceLine(x,z,length,alongX)
 local f=Instance.new("Folder");f.Name="DetailedFence";f.Parent=art
 local step=5
 local n=math.floor(length/step)
 for i=0,n do
  local d=-length/2+i*step
  local px=x+(alongX and d or 0);local pz=z+(alongX and 0 or d)
  p("Post",Vector3.new(.42,2.5,.42),CFrame.new(px,1.45,pz),Enum.Material.Wood,wood,f)
  ball("PostCap",.5,CFrame.new(px,2.78,pz),Enum.Material.Wood,woodLight,f)
 end
 for y in {1.0,1.85} do
  local s=alongX and Vector3.new(length,.18,.18) or Vector3.new(.18,.18,length)
  p("Rail",s,CFrame.new(x,y,z),Enum.Material.Wood,woodLight,f,false)
 end
end
fenceLine(68,-18,42,true);fenceLine(-55,-18,36,true);fenceLine(55,76,36,true);fenceLine(-105,36,30,false)

-- Trees: layered canopies, branch forks, roots and a little undergrowth.
local function tree(x,z,scale)
 local f=Instance.new("Folder");f.Name="DetailedTree";f.Parent=art
 local s=scale or 1
 cyl("Trunk",.72*s,7*s,CFrame.new(x,3.6*s,z),Enum.Material.Wood,Color3.fromRGB(88,65,44),f)
 cyl("Branch",.25*s,3*s,CFrame.new(x+1*s,6*s,z)*CFrame.Angles(0,0,math.rad(-55)),Enum.Material.Wood,wood,f)
 cyl("Branch",.25*s,3*s,CFrame.new(x-1*s,6.2*s,z)*CFrame.Angles(0,0,math.rad(55)),Enum.Material.Wood,wood,f)
 for _,o in ipairs({Vector3.new(0,7.2,0),Vector3.new(-1.8,8,0),Vector3.new(1.8,7.9,.3),Vector3.new(0,8.8,-1),Vector3.new(0,8.4,1.4)}) do ball("LeafCanopy",4.5*s,CFrame.new(x+o.X*s,o.Y*s,z+o.Z*s),Enum.Material.Grass,green,f) end
 for _,sx in ipairs({-1,1}) do ball("Root",1.3*s,CFrame.new(x+sx*.9*s,.55,z),Enum.Material.Wood,wood,f) end
end
for _,v in ipairs({{-112,-75,1.1},{-95,-45,1},{-118,5,1.2},{-105,45,1},{-88,105,1.15},{-45,-105,1.2},{5,-105,1},{55,-105,1.1},{110,-80,1.2},{118,-20,1},{118,25,1.1},{110,70,1.2},{95,115,1},{20,115,1.15},{-20,100,1}}) do tree(v[1],v[2],v[3]) end

-- Bushes and grass tufts create a softer transition around roads.
for i=1,55 do
 local x=math.random(-125,125);local z=math.random(-110,120)
 if math.abs(x)<13 or math.abs(z)<13 then continue end
 local s=math.random(7,12)/10
 ball("Bush",2.5*s,CFrame.new(x,1.25*s,z),Enum.Material.Grass,green2,art)
 ball("BushSmall",1.8*s,CFrame.new(x+.9,1.45*s,z+.4),Enum.Material.Grass,green,art)
end
for i=1,90 do
 local x=math.random(-125,125);local z=math.random(-110,120)
 if math.abs(x)<10 or math.abs(z)<10 then continue end
 for j=1,3 do
  local h=math.random(5,10)/10
  p("GrassBlade",Vector3.new(.08,h,.08),CFrame.new(x+(j-2)*.18,h/2+.42,z+math.random(-3,3)/10)*CFrame.Angles(0,0,math.rad(math.random(-18,18))),Enum.Material.Grass,green2,art,false)
 end
end

-- Flower beds with irregular clusters.
local function flowerBed(x,z)
 local f=Instance.new("Folder");f.Name="DetailedFlowerBed";f.Parent=art
 p("Soil",Vector3.new(8,.18,3.5),CFrame.new(x,.52,z),Enum.Material.Ground,Color3.fromRGB(76,53,38),f,false)
 for i=1,10 do
  local xx=x+math.random(-32,32)/10;local zz=z+math.random(-12,12)/10
  cyl("Stem",.055,.7,CFrame.new(xx,.9,zz),Enum.Material.Grass,green,f)
  local b=ball("Bloom",.38,CFrame.new(xx,1.3,zz),Enum.Material.SmoothPlastic,flower,f)
  b.CanCollide=false
 end
end
flowerBed(20,18);flowerBed(48,30);flowerBed(30,-58);flowerBed(-60,-18);flowerBed(82,48)

-- River bank detailing: stepping stones, reeds, driftwood and a safer-looking shore.
for i=1,42 do
 local x=-100+math.random(0,130);local side=(math.random()<.5 and 42 or 74)
 local r=math.random(7,15)/10
 cyl("RiverStone",r,r*.65,CFrame.new(x,.62,side+math.random(-3,3)/10)*CFrame.Angles(math.rad(8),math.random(),math.rad(4)),Enum.Material.Slate,stone,art)
end
for i=1,35 do
 local x=-105+math.random(0,140);local z=(math.random()<.5 and 40+math.random(0,4) or 75-math.random(0,4))
 local h=math.random(18,35)/10
 for j=1,3 do p("Reed",.1 and Vector3.new(.1,h,.1) or Vector3.new(.1,h,.1),CFrame.new(x+j*.12,h/2+.45,z+j*.15),Enum.Material.Grass,green2,art,false) end
end
for i=1,7 do
 local x=-95+math.random(0,115);local z=(math.random()<.5 and 43 or 73)
 p("Driftwood",Vector3.new(math.random(3,6),.35,.5),CFrame.new(x,.65,z)*CFrame.Angles(0,math.random(),math.rad(math.random(-8,8))),Enum.Material.Wood,wood,f,false)
end

-- Bridge receives rails, supports and lanterns.
local bridge=world:FindFirstChild("Bridge")
if bridge then
 for sx=-1,1,2 do
  local z=58+sx*17
  p("BridgeRail",Vector3.new(1,.25,34),CFrame.new(-35,3,z),Enum.Material.Wood,woodLight,art)
  for x=-43,-27,4 do p("BridgePost",Vector3.new(.3,3,.3),CFrame.new(x,2.1,z),Enum.Material.Wood,wood,art) end
 end
 for x=-43,-27,8 do
  local lantern=p("BridgeLantern",Vector3.new(.45,.55,.45),CFrame.new(x,3.2,41.2),Enum.Material.Glass,Color3.fromRGB(239,190,118),art,false);light(lantern,warm,.75,9)
 end
end

-- Utility poles and overhead lines make the village silhouette feel inhabited.
local function utilityPole(x,z)
 local f=Instance.new("Folder");f.Name="UtilityPole";f.Parent=art
 cyl("Pole",.18,8,CFrame.new(x,4,z),Enum.Material.Wood,woodDark,f)
 p("CrossArm",Vector3.new(3.4,.18,.18),CFrame.new(x,7.1,z),Enum.Material.Wood,wood,f,false)
 for sx=-1,1,2 do cyl("Insulator",.12,.4,CFrame.new(x+sx*1.25,7.45,z),Enum.Material.Metal,Color3.fromRGB(219,217,201),f,false) end
end
for _,v in ipairs({{-25,-20},{25,55},{-55,105},{105,10}}) do utilityPole(v[1],v[2]) end
for _,v in ipairs({{-25,-20,25,55},{25,55,105,10}}) do
 local a=Vector3.new(v[1],7.4,v[2]);local b=Vector3.new(v[3],7.4,v[4]);local mid=(a+b)/2;local len=(b-a).Magnitude
 local wire=p("UtilityWire",Vector3.new(.06,.06,len),CFrame.lookAt(mid,b),Enum.Material.SmoothPlastic,Color3.fromRGB(25,25,24),art,false)
end

-- Park fountain upgrade: basin, rim, center column and illuminated water core.
local fountain=world:FindFirstChild("Fountain")
if fountain then
 local f=Instance.new("Folder");f.Name="FountainDetail";f.Parent=art
 cyl("Basin",5.2,.6,CFrame.new(25,.95,-45),Enum.Material.Marble,Color3.fromRGB(184,185,178),f)
 cyl("InnerWater",4.2,.12,CFrame.new(25,1.27,-45),Enum.Material.Water,Color3.fromRGB(54,135,169),f,false)
 cyl("Column",.8,3.2,CFrame.new(25,2.7,-45),Enum.Material.Marble,Color3.fromRGB(199,198,187),f)
 local glow=ball("WaterGlow",1.1,CFrame.new(25,4.25,-45),Enum.Material.Neon,Color3.fromRGB(128,210,235),f);light(glow,Color3.fromRGB(110,205,235),1.2,10)
end

-- Gas station visual polish.
local gas=world:FindFirstChild("GasStation")
if gas then
 local f=Instance.new("Folder");f.Name="GasStationDetail";f.Parent=art
 p("Canopy",Vector3.new(30,.6,19),CFrame.new(92,7,-45),Enum.Material.Metal,Color3.fromRGB(60,62,59),f)
 for sx=-1,1,2 do for sz=-1,1,2 do cyl("CanopyPost",.2,6,CFrame.new(92+sx*12,4.1,-45+sz*7),Enum.Material.Metal,metal,f) end end
 local sign=p("FuelSign",Vector3.new(5,5,.5),CFrame.new(92,9,-55),Enum.Material.Neon,Color3.fromRGB(222,64,48),f);surfaceText(sign,"FUEL",Enum.NormalId.Front);light(sign,warm,1.3,12)
 for x=84,100,8 do
  p("Pump",Vector3.new(2,2.5,1.3),CFrame.new(x,1.8,-45),Enum.Material.Metal,Color3.fromRGB(84,86,82),f)
  p("PumpTop",Vector3.new(1.3,.8,.8),CFrame.new(x,3.35,-45),Enum.Material.Glass,glass,f,false)
 end
end

-- Dock gets cleats, posts, rope and a small lantern.
local dock=world:FindFirstChild("Dock")
if dock then
 local f=Instance.new("Folder");f.Name="DockDetail";f.Parent=art
 for x=-96,-74,4 do
  cyl("DockPost",.22,2.4,CFrame.new(x,.0,58),Enum.Material.Wood,woodDark,f)
  p("DockCleat",Vector3.new(.7,.3,.7),CFrame.new(x,.0,54),Enum.Material.Metal,metal,f)
 end
 for x=-94,-76,6 do
  local lantern=p("DockLantern",Vector3.new(.4,.5,.4),CFrame.new(x,1.6,54),Enum.Material.Glass,Color3.fromRGB(242,193,123),f,false);light(lantern,warm,.8,9)
 end
end

-- Underwater secret entrance: make the discovery look intentional and cinematic.
local door=world:FindFirstChild("UnderwaterDoor")
if door then
 local f=Instance.new("Folder");f.Name="UnderwaterEntranceDetail";f.Parent=art
 p("FrameTop",Vector3.new(11,.6,.8),CFrame.new(-45,1.3,64.2),Enum.Material.Metal,Color3.fromRGB(57,64,66),f)
 for sx=-1,1,2 do p("FrameSide",Vector3.new(.6,9,.8),CFrame.new(-45+sx*5, -2.9,64.2),Enum.Material.Metal,Color3.fromRGB(57,64,66),f) end
 for i=1,5 do
  local glow=ball("UnderwaterGlow",.5,CFrame.new(-49+i*2,-3,63.8),Enum.Material.Neon,Color3.fromRGB(62,186,210),f);light(glow,Color3.fromRGB(40,170,205),.45,4)
 end
end

-- Secret room receives a complete industrial interior dressing.
local room=world:FindFirstChild("SecretRoom")
if room then
 local f=Instance.new("Folder");f.Name="SecretRoomDetail";f.Parent=art
 for x=-58,-32,4 do
  p("CeilingBeam",Vector3.new(.35,.5,22),CFrame.new(x,4,93),Enum.Material.Metal,metal,f)
 end
 for z=84,102,4 do p("WallRivetLine",Vector3.new(28,.12,.12),CFrame.new(-45,-1,z),Enum.Material.Metal,Color3.fromRGB(104,109,108),f,false) end
 local glow=ball("SecretAmbient",2,CFrame.new(-45,-1,92),Enum.Material.Neon,Color3.fromRGB(55,186,213),f);light(glow,Color3.fromRGB(45,170,210),1.8,18)
 for _,v in ipairs({{-56,-5,84},{-34,-5,84},{-56,-5,100},{-34,-5,100}}) do cyl("Support",.18,6,CFrame.new(v[1],-5,v[3]),Enum.Material.Metal,metal,f) end
end

-- Blackout keeps local lanterns alive while reducing the global exposure.
Workspace:GetAttributeChangedSignal("BlackoutEvent"):Connect(function()
 if Workspace:GetAttribute("BlackoutEvent") then
  TweenService:Create(Lighting,TweenInfo.new(1),{Brightness=.28,ExposureCompensation=-.8}):Play()
 else
  TweenService:Create(Lighting,TweenInfo.new(1.5),{Brightness=2.1,ExposureCompensation=.05}):Play()
 end
end)

print("[SecretVillageGraphicsOverhaul] GLOBAL HIGH-DETAIL VISUAL PASS INITIALIZED")
