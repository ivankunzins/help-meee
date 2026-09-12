-- SECRET VILLAGE CINEMATIC GRAPHICS v1
-- Final visual polish: layered terrain, architecture accents, vegetation clusters,
-- signage, lighting, water-edge dressing and cinematic atmosphere.
-- Gameplay systems are untouched.
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")
local art=world:FindFirstChild("GRAPHICS_CINEMATIC") or Instance.new("Folder")
art.Name="GRAPHICS_CINEMATIC";art.Parent=world
if art:GetAttribute("Built") then return end
art:SetAttribute("Built",true)

local function p(name,size,cf,mat,color,parent,collide)
 local x=Instance.new("Part");x.Name=name;x.Size=size;x.CFrame=cf;x.Anchored=true;x.CanCollide=collide~=false;x.CanTouch=false;x.CanQuery=false;x.Material=mat or Enum.Material.SmoothPlastic
 if color then x.Color=color end;x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth;x.Parent=parent or art;return x
end
local function ball(name,s,cf,mat,color,parent)
 local x=p(name,Vector3.new(s,s,s),cf,mat,color,parent,false);x.Shape=Enum.PartType.Ball;return x
end
local function cyl(name,r,h,cf,mat,color,parent)
 local x=p(name,Vector3.new(r*2,h,r*2),cf,mat,color,parent);x.Shape=Enum.PartType.Cylinder;return x
end
local function light(parent,color,b,range)
 local l=Instance.new("PointLight");l.Color=color;l.Brightness=b;l.Range=range;l.Shadows=true;l.Parent=parent;return l
end
local dark=Color3.fromRGB(48,43,37);local wood=Color3.fromRGB(118,82,52);local stone=Color3.fromRGB(122,120,111)
local leaf=Color3.fromRGB(65,100,49);local leaf2=Color3.fromRGB(92,128,63);local warm=Color3.fromRGB(255,205,140)
local glass=Color3.fromRGB(92,157,177);local metal=Color3.fromRGB(59,62,60)

-- Layered terrain patches break the flat procedural-green appearance.
local terrain=Instance.new("Folder");terrain.Name="TerrainLayers";terrain.Parent=art
for i=1,32 do
 local x=math.random(-130,130);local z=math.random(-112,112)
 local sx=math.random(5,16);local sz=math.random(4,12)
 p("GroundPatch",Vector3.new(sx,.08,sz),CFrame.new(x,.17,z)*CFrame.Angles(0,math.random()*6.28,0),Enum.Material.Ground,Color3.fromRGB(91+math.random(0,12),76+math.random(0,10),56+math.random(0,8)),terrain,false)
end

-- Dense foliage clusters, intentionally irregular and low-poly friendly.
local foliage=Instance.new("Folder");foliage.Name="FoliageClusters";foliage.Parent=art
local function bush(x,z,s)
 for i=1,7 do
  local a=math.random()*6.28;local rr=math.random()*.8*s
  ball("BushLeaf",s*(.55+math.random()*.35),CFrame.new(x+math.cos(a)*rr,.55+s*.22+math.random()*.35,z+math.sin(a)*rr),Enum.Material.Grass,i%3==0 and leaf2 or leaf,foliage)
 end
end
for _,v in ipairs({{-120,-45,2.6},{-108,-55,2},{-92,-80,2.5},{-38,-78,2},{45,-72,2.4},{112,-72,2.3},{120,25,2.5},{-122,70,2.7},{-92,98,2.1},{42,105,2.4},{105,92,2.1}}) do bush(v[1],v[2],v[3]) end
for i=1,22 do
 local x=math.random(-130,130);local z=math.random(-115,115)
 cyl("GrassTuft",.07,math.random(2,4),CFrame.new(x,.9,z)*CFrame.Angles(.18,math.random()*6.28,.12),Enum.Material.Grass,leaf2,foliage)
end

-- Architectural trim: shutters, flower boxes and roof fascia on existing houses.
local arch=Instance.new("Folder");arch.Name="ArchitecturePolish";arch.Parent=art
local houses={{"Bakery",55,-5,1},{"VillageShop",90,45,.9},{"OldHouse",-70,-30,1.15},{"Garage",70,90,1.1},{"ForestCabin",-75,75,.85}}
for _,h in ipairs(houses) do
 local n,x,z,s=h;local w=18*s;local d=16*s
 for sx=-1,1,2 do
  p("RoofFascia",Vector3.new(w+.7*s,.35,.22),CFrame.new(x,10.7*s,z+sx*(d/2+.55*s)),Enum.Material.Wood,dark,arch,false)
 end
 for sx=-1,1,2 do
  local box=p("WindowBox",Vector3.new(3.6*s,.35,.75*s),CFrame.new(x+sx*5*s,4.25*s,z-d/2-.62),Enum.Material.Wood,wood,arch,false)
  for j=1,4 do ball("Flower",.22*s,CFrame.new(box.Position.X-1.2*s+j*.6*s,4.65*s,box.Position.Z-.05),Enum.Material.Grass,j%2==0 and leaf2 or leaf,arch) end
 end
end

-- Village square focal point: decorative planter ring and subtle path stones.
local square=Instance.new("Folder");square.Name="VillageSquarePolish";square.Parent=art
for i=1,12 do
 local a=i*math.pi/6;local x=25+math.cos(a)*13;local z=-48+math.sin(a)*13
 cyl("PathStone",.55,.18,CFrame.new(x,.48,z),Enum.Material.Slate,stone,square)
end
for i=1,10 do
 local a=i*math.pi/5;ball("SquareFlower",.3,CFrame.new(25+math.cos(a)*5,1.05,-48+math.sin(a)*5),Enum.Material.Grass,leaf2,square)
end

-- Utility details: mailboxes and refuse bins make residential areas feel occupied.
local street=Instance.new("Folder");street.Name="StreetLife";street.Parent=art
local function mailbox(x,z)
 cyl("MailboxPost",.08,1.1,CFrame.new(x,.8,z),Enum.Material.Metal,metal,street)
 p("Mailbox",Vector3.new(1.1,.65,.5),CFrame.new(x,1.35,z),Enum.Material.Metal,Color3.fromRGB(83,91,91),street)
end
for _,v in ipairs({{-58,-44},{-82,-20},{-62,18},{104,20},{112,62},{-100,82}}) do mailbox(v[1],v[2]) end
for _,v in ipairs({{-50,-50},{-82,-10},{108,12},{116,55}}) do
 cyl("TrashBin",.42,1.1,CFrame.new(v[1],.95,v[2]),Enum.Material.Metal,metal,street)
 p("TrashLid",Vector3.new(.9,.1,.9),CFrame.new(v[1],1.53,v[2]),Enum.Material.Metal,dark,street,false)
end

-- River banks: layered rocks and small driftwood pieces.
local river=Instance.new("Folder");river.Name="RiverBankPolish";river.Parent=art
for i=1,38 do
 local x=math.random(-100,100);local z=(math.random()<.5 and 39.7 or 76.2)
 local s=math.random(5,14)/10
 ball("BankRock",s,CFrame.new(x,.48,z),Enum.Material.Slate,Color3.fromRGB(105+math.random(0,18),105+math.random(0,15),98+math.random(0,12)),river)
end
for _,v in ipairs({{-86,39.5},{-55,76.4},{-12,39.5},{35,76.4},{76,39.5}}) do
 p("Driftwood",Vector3.new(3,.18,.28),CFrame.new(v[1],.65,v[2])*CFrame.Angles(0,math.random()*6.28,.08),Enum.Material.Wood,wood,river,false)
end

-- Warm facade lights create depth at dusk/night without changing event scripts.
for _,v in ipairs({{55,-14},{90,34},{-70,-39},{70,81},{-75,67},{25,-48}}) do
 local fixture=p("WallLight",Vector3.new(.35,.55,.18),CFrame.new(v[1],4.6,v[2]),Enum.Material.Glass,warm,art,false)
 light(fixture,warm,.75,10)
end

-- Cinematic lighting layer: restrained contrast, bloom and atmosphere.
local cc=Lighting:FindFirstChild("VillageCinematic") or Instance.new("ColorCorrectionEffect")
cc.Name="VillageCinematic";cc.Brightness=.01;cc.Contrast=.06;cc.Saturation=.04;cc.TintColor=Color3.fromRGB(255,251,244);cc.Parent=Lighting
local bloom=Lighting:FindFirstChild("VillageCinematicBloom") or Instance.new("BloomEffect")
bloom.Name="VillageCinematicBloom";bloom.Intensity=.08;bloom.Size=16;bloom.Threshold=1.2;bloom.Parent=Lighting
local rays=Lighting:FindFirstChild("VillageCinematicRays") or Instance.new("SunRaysEffect")
rays.Name="VillageCinematicRays";rays.Intensity=.025;rays.Spread=.7;rays.Parent=Lighting
print("[SecretVillageGraphicsCinematic] Cinematic visual polish initialized")
