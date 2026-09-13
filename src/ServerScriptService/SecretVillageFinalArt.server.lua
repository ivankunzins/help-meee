-- SECRET VILLAGE FINAL ART v2
-- Cohesive global art pass. Runs after the procedural village has been created.

local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")

task.wait(3)
local old=Workspace:FindFirstChild("FINAL_ART_PASS")
if old then old:Destroy() end
local ROOT=Instance.new("Folder")
ROOT.Name="FINAL_ART_PASS"
ROOT.Parent=Workspace

local function P(n,s,cf,m,c,par,shape)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=cf;p.Anchored=true;p.Material=m or Enum.Material.Wood;p.Color=c or Color3.fromRGB(110,90,65);p.Parent=par or ROOT
 if shape then p.Shape=shape end
 return p
end
local function ball(n,s,pos,m,c,par)
 local p=P(n,s,CFrame.new(pos),m,c,par,Enum.PartType.Ball);p.CanCollide=false;return p
end
local function cyl(n,r,h,pos,m,c,par)
 return P(n,Vector3.new(r*2,h,r*2),CFrame.new(pos),m,c,par,Enum.PartType.Cylinder)
end
local function lightAt(p,range,brightness,color)
 local l=Instance.new("PointLight");l.Range=range;l.Brightness=brightness;l.Color=color;l.Shadows=true;l.Parent=p;return l
end

-- --------------------------------------------------------------------------
-- 1. Ground: replace old asphalt/flat-road feeling with layered rural paths.
-- --------------------------------------------------------------------------
for _,o in ipairs(Workspace:GetDescendants()) do
 if o:IsA("BasePart") and (o.Name=="MainRoad" or o.Name=="CrossRoad") then
  o.Material=Enum.Material.Ground;o.Color=Color3.fromRGB(117,99,72);o.Transparency=0;o.CanCollide=true
 end
end
local ground=Instance.new("Folder");ground.Name="TerrainFinish";ground.Parent=ROOT
math.randomseed(140926)
for i=1,100 do
 local x=math.random(-145,145);local z=math.random(-125,135)
 local sx=math.random(5,12);local sz=math.random(4,9)
 local p=P("GrassPatch",Vector3.new(sx,.16,sz),CFrame.new(x,.22,z)*CFrame.Angles(0,math.random()*6.28,0),Enum.Material.Grass,Color3.fromRGB(math.random(70,92),math.random(94,120),math.random(52,75)),ground);p.CanCollide=false
end

-- Roadside ruts and stones make the dirt paths read as used paths.
local paths=Instance.new("Folder");paths.Name="RoadsideDetail";paths.Parent=ROOT
for _,z in ipairs({-85,-55,25,105}) do
 for side=-1,1,2 do
  for i=1,9 do
   local x=15+(i-5)*11
   ball("PathStone",Vector3.new(math.random(18,34)/10,math.random(8,16)/10,math.random(12,28)/10),Vector3.new(x,.38,z+side*(4+math.random(0,3))),Enum.Material.Slate,Color3.fromRGB(105,103,94),paths)
  end
 end
end

-- --------------------------------------------------------------------------
-- 2. Houses: apply one complete architectural language to every generated home.
-- --------------------------------------------------------------------------
local buildings=Instance.new("Folder");buildings.Name="ArchitectureFinish";buildings.Parent=ROOT
local function finishHouse(model,accent)
 if not model or not model:IsA("Model") then return end
 local cf,size=model:GetBoundingBox();local x,z=cf.Position.X,cf.Position.Z;local sx,sy,sz=size.X,size.Y,size.Z
 local f=Instance.new("Folder");f.Name="FacadeFinish";f.Parent=buildings
 P("Foundation",Vector3.new(sx+1,.45,sz+1),CFrame.new(x,cf.Position.Y-sy/2-.15,z),Enum.Material.Slate,Color3.fromRGB(69,69,65),f)
 P("Porch",Vector3.new(math.min(12,sx*.72),.3,2.6),CFrame.new(x,cf.Position.Y-sy/2+.12,z-sz/2-1.25),Enum.Material.WoodPlanks,Color3.fromRGB(117,84,54),f)
 for dx=-1.8,1.8,3.6 do
  P("Post",Vector3.new(.22,2.7,.22),CFrame.new(x+dx,cf.Position.Y-sy/2+1.35,z-sz/2-2),Enum.Material.Wood,Color3.fromRGB(83,61,44),f)
 end
 P("Door",Vector3.new(2.1,3.5,.18),CFrame.new(x,cf.Position.Y-sy/2+1.75,z-sz/2-.16),Enum.Material.Wood,accent,f)
 local knob=ball("Knob",Vector3.new(.16,.16,.16),Vector3.new(x+.68,cf.Position.Y-sy/2+1.8,z-sz/2-.28),Enum.Material.Metal,Color3.fromRGB(211,177,101),f);knob.CanCollide=false
 for _,dx in ipairs({-sx*.27,sx*.27}) do
  local w=P("Window",Vector3.new(2.5,1.65,.12),CFrame.new(x+dx,cf.Position.Y+.55,z-sz/2-.12),Enum.Material.Glass,Color3.fromRGB(148,190,198),f);w.CanCollide=false
  for _,off in ipairs({-.75,.75}) do P("Mullion",Vector3.new(.08,1.55,.14),CFrame.new(x+dx+off,cf.Position.Y+.55,z-sz/2-.2),Enum.Material.Wood,Color3.fromRGB(73,61,50),f) end
  P("Sill",Vector3.new(2.8,.15,.4),CFrame.new(x+dx,cf.Position.Y-.32,z-sz/2-.25),Enum.Material.Wood,Color3.fromRGB(91,66,45),f)
  for k=-1,1 do ball("Flower",Vector3.new(.25,.18,.25),Vector3.new(x+dx+k*.55,cf.Position.Y-.18,z-sz/2-.45),Enum.Material.Grass,Color3.fromRGB(67,105,54),f) end
 end
 -- roofline, gutter and chimney
 P("RoofRidge",Vector3.new(sx+1,.3,.38),CFrame.new(x,cf.Position.Y+sy/2+.2,z),Enum.Material.Wood,Color3.fromRGB(57,50,45),f)
 P("Gutter",Vector3.new(sx+1,.16,.16),CFrame.new(x,cf.Position.Y+sy/2-.15,z-sz/2-.2),Enum.Material.Metal,Color3.fromRGB(67,68,65),f)
 P("Downpipe",Vector3.new(.13,3.5,.13),CFrame.new(x+sx*.4,cf.Position.Y+sy/2-1.7,z-sz/2-.2),Enum.Material.Metal,Color3.fromRGB(67,68,65),f)
 P("Chimney",Vector3.new(1.5,3.3,1.5),CFrame.new(x+sx*.28,cf.Position.Y+sy/2+1.4,z+sz*.15),Enum.Material.Brick,Color3.fromRGB(116,75,58),f)
 local lamp=P("PorchLamp",Vector3.new(.3,.3,.3),CFrame.new(x+2.1,cf.Position.Y-sy/2+3.0,z-sz/2-.25),Enum.Material.Neon,Color3.fromRGB(255,208,137),f);lamp.CanCollide=false;lightAt(lamp,10,.55,Color3.fromRGB(255,208,150))
end

for _,o in ipairs(Workspace:GetDescendants()) do
 if o:IsA("Model") and o:IsDescendantOf(Workspace) then
  local n=o.Name
  if n=="Village House" or n=="VillageGeneralStore" or n=="FarmShop" or n=="Bakery" or n=="Village Shop" or n=="Old House" or n=="Garage" or n=="Forest Cabin" then
   finishHouse(o, n:find("Shop") and Color3.fromRGB(112,73,50) or Color3.fromRGB(126,86,61))
  end
 end
end

-- --------------------------------------------------------------------------
-- 3. Village square: a deliberate focal area, not an empty patch.
-- --------------------------------------------------------------------------
local square=Instance.new("Folder");square.Name="VillageSquareFinish";square.Parent=ROOT
local ring=cyl("StoneRing",10,.25,Vector3.new(25,.28,-45),Enum.Material.Slate,Color3.fromRGB(119,116,106),square);ring.CanCollide=false
for i=1,14 do
 local a=i*math.pi*2/14;local x=25+math.cos(a)*8.5;local z=-45+math.sin(a)*8.5
 ball("Shrub",Vector3.new(2.2,1.7,2.2),Vector3.new(x,1.05,z),Enum.Material.Grass,Color3.fromRGB(57,90,48),square)
end
for _,v in ipairs({Vector3.new(15,.4,-53),Vector3.new(35,.4,-53),Vector3.new(15,.4,-37),Vector3.new(35,.4,-37)}) do
 P("BenchSeat",Vector3.new(3,.25,.65),CFrame.new(v),Enum.Material.Wood,Color3.fromRGB(107,76,49),square)
 P("BenchBack",Vector3.new(3,1,.18),CFrame.new(v+Vector3.new(0,.65,.25)),Enum.Material.Wood,Color3.fromRGB(107,76,49),square)
end

-- --------------------------------------------------------------------------
-- 4. River: natural edge, reeds, driftwood and shallow shoreline stones.
-- --------------------------------------------------------------------------
local river=Instance.new("Folder");river.Name="RiverFinish";river.Parent=ROOT
for i=1,70 do
 local z=-8+i*3.5;local side=i%2==0 and -1 or 1;local x=side*(27+math.random(-7,7))
 local r=math.random(7,22)/10
 ball("ShoreRock",Vector3.new(r*1.7,r,r*.8),Vector3.new(x,1,z),Enum.Material.Slate,Color3.fromRGB(99,104,99),river)
 if i%2==0 then
  for j=1,4 do
   local reed=P("Reed",Vector3.new(.1,math.random(20,38)/10,.1),CFrame.new(x+math.random(-2,2),1,z+math.random(-2,2))*CFrame.Angles(math.rad(math.random(-10,10)),0,math.rad(math.random(-10,10))),Enum.Material.Grass,Color3.fromRGB(65,101,56),river);reed.CanCollide=false
  end
 end
end
for _,v in ipairs({{-38,1,32},{-33,1,40},{-30,1,47}}) do
 local log=cyl("Driftwood",.45,4,Vector3.new(v[1],v[2],v[3]),Enum.Material.Wood,Color3.fromRGB(91,65,44),river);log.CFrame=log.CFrame*CFrame.Angles(0,math.rad(35),math.rad(72))
end

-- --------------------------------------------------------------------------
-- 5. Farms: readable rows, fences, hay and working-yard composition.
-- --------------------------------------------------------------------------
local farm=Instance.new("Folder");farm.Name="FarmFinish";farm.Parent=ROOT
local function farmPlot(cx,cz,w,d)
 P("SoilPlot",Vector3.new(w,.15,d),CFrame.new(cx,.12,cz),Enum.Material.Ground,Color3.fromRGB(89,69,46),farm)
 for x=-w/2+2,w/2-2,3 do
  P("CropRow",Vector3.new(.35,.55,d-3),CFrame.new(cx+x,.48,cz),Enum.Material.Grass,Color3.fromRGB(57,99,50),farm)
 end
 for x=-w/2,w/2,4 do
  P("FencePost",Vector3.new(.18,1.25,.18),CFrame.new(cx+x,.7,cz-d/2),Enum.Material.Wood,Color3.fromRGB(101,73,47),farm)
  P("FencePost",Vector3.new(.18,1.25,.18),CFrame.new(cx+x,.7,cz+d/2),Enum.Material.Wood,Color3.fromRGB(101,73,47),farm)
 end
 P("Rail",Vector3.new(w, .16,.16),CFrame.new(cx,.85,cz-d/2),Enum.Material.Wood,Color3.fromRGB(101,73,47),farm)
 P("Rail",Vector3.new(w, .16,.16),CFrame.new(cx,.85,cz+d/2),Enum.Material.Wood,Color3.fromRGB(101,73,47),farm)
end
farmPlot(-100,-82,34,25);farmPlot(116,-55,28,22);farmPlot(-120,55,25,19)
for _,v in ipairs({{-90,-96},{-84,-96},{110,-68},{117,-68},{-114,67}}) do cyl("HayBale",1.15,1.8,Vector3.new(v[1],1,v[2]),Enum.Material.Fabric,Color3.fromRGB(181,151,77),farm) end

-- --------------------------------------------------------------------------
-- 6. NPCs: replace the primitive mannequins with real Roblox humanoid rigs.
-- --------------------------------------------------------------------------
local npcNames={"Marta","Anton","Nina","Oleg","Lena","Max","Vera","Roman"}
local roles={Marta="Farmer",Anton="Carpenter",Nina="Baker",Oleg="Fisherman",Lena="Gardener",Max="Courier",Vera="Shepherd",Roman="Mechanic"}
local npcFolder=Workspace:FindFirstChild("SECRET_VILLAGE_LIFE")
if npcFolder then
 for _,name in ipairs(npcNames) do
  local oldNpc=npcFolder:FindFirstChild(name)
  if oldNpc then
   local pos=oldNpc:GetPivot().Position
   oldNpc:Destroy()
   task.spawn(function()
    local ok,model=pcall(function()
     local desc=Instance.new("HumanoidDescription")
     return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
    end)
    if ok and model then
     model.Name=name;model.Parent=npcFolder
     model:PivotTo(CFrame.new(pos))
     local hum=model:FindFirstChildOfClass("Humanoid")
     if hum then hum.DisplayName=name;hum.WalkSpeed=6;hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.Viewer end
     local head=model:FindFirstChild("Head")
     if head then
      local gui=Instance.new("BillboardGui");gui.Name="RoleLabel";gui.Size=UDim2.fromOffset(160,34);gui.StudsOffset=Vector3.new(0,2.8,0);gui.AlwaysOnTop=true;gui.Parent=head
      local tx=Instance.new("TextLabel");tx.Size=UDim2.fromScale(1,1);tx.BackgroundTransparency=1;tx.Text=roles[name] or "Житель";tx.Font=Enum.Font.GothamBold;tx.TextScaled=true;tx.TextColor3=Color3.new(1,1,1);tx.TextStrokeTransparency=.35;tx.Parent=gui
     end
    end
   end)
  end
 end
end

-- --------------------------------------------------------------------------
-- 7. Animals: add recognizable silhouettes and facial detail to existing herds.
-- --------------------------------------------------------------------------
local function decorateAnimal(m,species)
 if not m:IsA("Model") then return end
 local body=m:FindFirstChild("Body");if not body then return end
 local f=Instance.new("Folder");f.Name="AnimalDetail";f.Parent=m
 local p=body.Position;local sx=body.Size.X
 if species=="Cow" then
  for _,side in ipairs({-1,1}) do
   ball("Eye",Vector3.new(.16,.16,.16),p+Vector3.new(sx*.48,body.Size.Y*.2,side*.7),Enum.Material.Neon,Color3.fromRGB(30,30,25),f)
  end
  for _,side in ipairs({-1,1}) do
   ball("Ear",Vector3.new(.55,.25,.5),p+Vector3.new(sx*.43,body.Size.Y*.65,side*1.15),Enum.Material.SmoothPlastic,Color3.fromRGB(65,55,50),f)
  end
  cyl("Tail",.1,1.6,p+Vector3.new(-sx*.55,.2,0),Enum.Material.Wood,Color3.fromRGB(70,52,42),f)
 elseif species=="Sheep" then
  for _,off in ipairs({Vector3.new(sx*.45,.7,.45),Vector3.new(sx*.45,.7,-.45)}) do ball("Eye",Vector3.new(.13,.13,.13),p+off,Enum.Material.Neon,Color3.fromRGB(25,25,25),f) end
  ball("WoolHead",Vector3.new(1.2,1.2,1.2),p+Vector3.new(sx*.48,.7,0),Enum.Material.Fabric,Color3.fromRGB(232,232,220),f)
 elseif species=="Chicken" then
  ball("Eye",Vector3.new(.12,.12,.12),p+Vector3.new(body.Size.X*.42,.35,.35),Enum.Material.Neon,Color3.fromRGB(20,20,20),f)
  ball("Comb",Vector3.new(.22,.38,.22),p+Vector3.new(body.Size.X*.42,.75,0),Enum.Material.SmoothPlastic,Color3.fromRGB(177,55,44),f)
 end
end
if npcFolder then
 for _,m in ipairs(npcFolder:GetChildren()) do if m:IsA("Model") and (m.Name=="Cow" or m.Name=="Sheep" or m.Name=="Chicken") then decorateAnimal(m,m.Name) end end
end

-- --------------------------------------------------------------------------
-- 8. Street furniture + warm practical lights.
-- --------------------------------------------------------------------------
local street=Instance.new("Folder");street.Name="StreetFinish";street.Parent=ROOT
for _,v in ipairs({{-18,-18},{18,-18},{-18,18},{18,18},{55,-30},{82,18},{-75,20},{-70,-40},{90,-75}}) do
 local x,z=v[1],v[2]
 cyl("LampPost",.13,5,Vector3.new(x,2.5,z),Enum.Material.Metal,Color3.fromRGB(43,45,42),street)
 P("LampArm",Vector3.new(1.5,.12,.12),CFrame.new(x+.65,5,z),Enum.Material.Metal,Color3.fromRGB(43,45,42),street)
 local lamp=P("Lamp",Vector3.new(.38,.38,.38),CFrame.new(x+1.25,4.8,z),Enum.Material.Neon,Color3.fromRGB(255,211,142),street);lamp.CanCollide=false;lightAt(lamp,18,1.15,Color3.fromRGB(255,211,155))
end

-- --------------------------------------------------------------------------
-- 9. Lighting: natural daytime base with strong night readability.
-- --------------------------------------------------------------------------
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.Brightness=2.1
Lighting.ClockTime=14.15
Lighting.ExposureCompensation=.03
Lighting.EnvironmentDiffuseScale=.5
Lighting.EnvironmentSpecularScale=.72
Lighting.ShadowSoftness=.28
local cc=Lighting:FindFirstChild("FinalNaturalColor") or Instance.new("ColorCorrectionEffect");cc.Name="FinalNaturalColor";cc.Brightness=.008;cc.Contrast=.055;cc.Saturation=.03;cc.TintColor=Color3.fromRGB(255,252,246);cc.Parent=Lighting
local bloom=Lighting:FindFirstChild("FinalSoftBloom") or Instance.new("BloomEffect");bloom.Name="FinalSoftBloom";bloom.Intensity=.045;bloom.Size=18;bloom.Threshold=1.3;bloom.Parent=Lighting

print("SECRET VILLAGE: FINAL ART v2 COMPLETE")
