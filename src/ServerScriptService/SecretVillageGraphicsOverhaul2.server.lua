-- SECRET VILLAGE GRAPHICS OVERHAUL v2
-- Second visual pass: micro-detail, believable village props, interiors, utility infrastructure,
-- richer nature, secret-room dressing and cinematic lighting. No gameplay APIs are changed.
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")
local art=world:FindFirstChild("GRAPHICS_OVERHAUL_V2") or Instance.new("Folder")
art.Name="GRAPHICS_OVERHAUL_V2";art.Parent=world
if art:GetAttribute("Built") then return end
art:SetAttribute("Built",true)

local function part(name,size,cf,mat,color,parent,collide)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.CanCollide=collide~=false;p.CanTouch=false;p.CanQuery=false
 p.Material=mat or Enum.Material.SmoothPlastic;if color then p.Color=color end;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent or art;return p
end
local function cyl(name,r,h,cf,mat,color,parent)
 local p=part(name,Vector3.new(r*2,h,r*2),cf,mat,color,parent);p.Shape=Enum.PartType.Cylinder;return p
end
local function ball(name,s,cf,mat,color,parent)
 local p=part(name,Vector3.new(s,s,s),cf,mat,color,parent,false);p.Shape=Enum.PartType.Ball;return p
end
local function light(parent,color,b,range)
 local l=Instance.new("PointLight");l.Color=color;l.Brightness=b;l.Range=range;l.Shadows=true;l.Parent=parent;return l
end
local function sign(p,txt,face)
 local g=Instance.new("SurfaceGui");g.Face=face or Enum.NormalId.Front;g.PixelsPerStud=55;g.Parent=p
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=txt;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.fromRGB(245,230,190);t.Parent=g
end
local wood=Color3.fromRGB(105,76,51);local dark=Color3.fromRGB(55,47,40);local metal=Color3.fromRGB(57,60,58)
local stone=Color3.fromRGB(116,114,105);local green=Color3.fromRGB(61,91,48);local green2=Color3.fromRGB(91,122,62)
local warm=Color3.fromRGB(255,198,126);local glass=Color3.fromRGB(82,145,166)

-- Landscaping: irregular clusters make the ground feel lived-in rather than procedural.
local nature=Instance.new("Folder");nature.Name="NatureDetail";nature.Parent=art
local function shrub(x,z,s)
 for i=1,5 do
  local a=i*1.7;ball("Bush",s*(.8+math.random()*.45),CFrame.new(x+math.cos(a)*s*.65,s*.45,z+math.sin(a)*s*.65),Enum.Material.Grass, i%2==0 and green2 or green,nature)
 end
end
local function grassPatch(x,z)
 for i=1,7 do
  local a=math.random()*math.pi*2;local r=math.random()*2.2;local h=math.random(1,2)*.7
  part("GrassBlade",Vector3.new(.08,h,.08),CFrame.new(x+math.cos(a)*r,h/2+.25,z+math.sin(a)*r)*CFrame.Angles(math.random()*.25,math.random()*6,math.random()*.25),Enum.Material.Grass,green2,nature,false)
 end
end
for i=1,85 do grassPatch(math.random(-135,135),math.random(-120,120)) end
for _,v in ipairs({{-100,-15,2.2},{-84,-22,1.7},{38,-58,2},{58,-36,1.8},{103,15,2},{-118,50,2.3},{72,64,1.8},{-40,-75,2}}) do shrub(v[1],v[2],v[3]) end
for i=1,45 do
 local x=math.random(-125,125);local z=math.random(-110,110)
 if math.abs(x)<10 or math.abs(z)<10 then continue end
 local s=math.random(1,3);ball("GroundStone",s,CFrame.new(x,s*.35,z)*CFrame.Angles(.2,math.random()*6,.15),Enum.Material.Slate,stone,nature)
end

-- Utility poles and overhead cables give the village a believable infrastructure silhouette.
local utility=Instance.new("Folder");utility.Name="UtilityInfrastructure";utility.Parent=art
local function cable(a,b)
 local mid=(a+b)/2;local len=(b-a).Magnitude
 local p=part("Cable",Vector3.new(.06,.06,len),CFrame.lookAt(mid,b),Enum.Material.SmoothPlastic,Color3.fromRGB(25,25,24),utility,false)
 return p
end
for _,x in ipairs({-100,-45,15,72}) do
 cyl("UtilityPole",.18,9,CFrame.new(x,4.5,-65),Enum.Material.Wood,wood,utility)
 for _,y in ipairs({7.2,8}) do part("CrossArm",Vector3.new(3.4,.14,.16),CFrame.new(x,y,-65),Enum.Material.Wood,dark,utility,false) end
 ball("Insulator",.28,CFrame.new(x-1.35,7.5,-65),Enum.Material.Glass,glass,utility)
 ball("Insulator",.28,CFrame.new(x+1.35,7.5,-65),Enum.Material.Glass,glass,utility)
end
for _,x in ipairs({-100,-45,15}) do cable(Vector3.new(x-60,8,-65),Vector3.new(x,8,-65)) end

-- Shop awnings, crates, barrels and delivery clutter.
local commerce=Instance.new("Folder");commerce.Name="VillageCommerceDetail";commerce.Parent=art
local function crate(x,y,z,rot)
 part("Crate",Vector3.new(1.8,1.2,1.8),CFrame.new(x,y,z)*CFrame.Angles(0,rot or 0,0),Enum.Material.Wood,wood,commerce)
 for _,d in ipairs({-0.65,0.65}) do part("CrateBand",Vector3.new(.12,1.25,1.9),CFrame.new(x+d,y,z)*CFrame.Angles(0,rot or 0,0),Enum.Material.Metal,dark,commerce,false) end
end
local function barrel(x,z)
 cyl("Barrel",.65,1.5,CFrame.new(x,.95,z),Enum.Material.Wood,wood,commerce)
 for y=0.45,1.45,.5 do cyl("BarrelBand",.69,.08,CFrame.new(x,y,z),Enum.Material.Metal,dark,commerce) end
end
for _,v in ipairs({{48,0},{62,-1},{82,55},{96,38},{61,92},{-61,-39}}) do crate(v[1],.65,v[2],math.random()*6) end
for _,v in ipairs({{51,1},{86,40},{64,94},{-61,-40}}) do barrel(v[1],v[2]) end
for _,v in ipairs({{55,-13},{90,35}}) do
 part("Awning",Vector3.new(10,.22,2.4),CFrame.new(v[1],7.2,v[2]),Enum.Material.Fabric,Color3.fromRGB(155,72,54),commerce)
 for sx=-1,1,2 do part("AwningSupport",Vector3.new(.12,2.1,.12),CFrame.new(v[1]+sx*4.4,6.1,v[2]+.8),Enum.Material.Metal,dark,commerce,false) end
end

-- Park details: planter, lamps, picnic table and flower clusters.
local park=Instance.new("Folder");park.Name="ParkDetail";park.Parent=art
for _,v in ipairs({{16,-50},{34,-50},{25,-37}}) do
 part("Planter",Vector3.new(2.8,.55,2.8),CFrame.new(v[1],.55,v[2]),Enum.Material.Slate,stone,park)
 for i=1,6 do ball("Plant",.35,CFrame.new(v[1]+math.cos(i)*.8,1.2,v[2]+math.sin(i)*.8),Enum.Material.Grass,green2,park) end
end
for _,v in ipairs({{6,-50},{44,-50}}) do
 part("PicnicTop",Vector3.new(5,.25,2),CFrame.new(v[1],1.6,v[2]),Enum.Material.Wood,wood,park)
 for sx=-1,1,2 do part("PicnicLeg",Vector3.new(.22,1.5,.22),CFrame.new(v[1]+sx*1.8,.8,v[2]),Enum.Material.Wood,dark,park) end
end

-- River: reeds, stepping stones, fishing crates and mooring posts.
local river=Instance.new("Folder");river.Name="RiverDetail";river.Parent=art
for i=1,38 do
 local x=-92+math.random(0,114);local z=(math.random()<.5 and 40.7 or 75.3)
 for j=1,3 do
  local h=math.random(2,4);local r=part("Reed",Vector3.new(.1,h,.1),CFrame.new(x+(j-2)*.25,h/2+.35,z+math.random(-1,1)),Enum.Material.Grass,green2,river,false)
  r.CFrame=r.CFrame*CFrame.Angles((math.random()-.5)*.35,math.random()*6,(math.random()-.5)*.35)
 end
end
for _,v in ipairs({{-55,40.2},{-32,40.2},{-8,40.2},{-70,75.8},{-22,75.8},{2,75.8}}) do
 ball("SteppingStone",1.25,CFrame.new(v[1],.48,v[2]),Enum.Material.Slate,stone,river)
end
for _,v in ipairs({{-95,.8,58},{-88,.8,58},{-82,.8,58}}) do
 cyl("MooringPost",.18,2,CFrame.new(v[1],v[2],v[3]),Enum.Material.Wood,dark,river)
end

-- Garage / gas station props: believable service area.
local garage=Instance.new("Folder");garage.Name="GarageDetail";garage.Parent=art
for _,x in ipairs({86,98}) do
 part("FuelPump",1 and Vector3.new(1.2,2.2,.7) or Vector3.new(1,1,1),CFrame.new(x,1.2,-45),Enum.Material.Metal,metal,garage)
 part("PumpDisplay",Vector3.new(.65,.55,.08),CFrame.new(x,1.75,-45.38),Enum.Material.Glass,glass,garage,false)
 part("PumpHose",Vector3.new(.06,1,.06),CFrame.new(x+.35,1.25,-45.1),Enum.Material.SmoothPlastic,dark,garage,false)
end
part("GasCanopy",Vector3.new(29,.5,19),CFrame.new(92,7,-45),Enum.Material.Metal,dark,garage)
for _,x in ipairs({79,105}) do part("CanopyColumn",Vector3.new(.45,7,.45),CFrame.new(x,3.5,-45),Enum.Material.Metal,metal,garage) end

-- Secret room: panels, warning stripes, cables, monitors and treasure display.
local secret=world:FindFirstChild("SecretRoom")
if secret then
 local s=Instance.new("Folder");s.Name="SecretRoomDetail";s.Parent=art
 for z=84,100,4 do part("WallPanel",Vector3.new(28,10,.12),CFrame.new(-45,-2,z),Enum.Material.Metal,Color3.fromRGB(70,76,74),s,false) end
 for x=-58,-32,4 do part("FloorPanel",Vector3.new(3,.08,20),CFrame.new(x,-7.45,94),Enum.Material.Metal,Color3.fromRGB(59,65,63),s,false) end
 for i=1,7 do part("Cable",Vector3.new(.08,.08,8),CFrame.new(-56+i*3,-3,103.2)*CFrame.Angles(math.rad(12),0,0),Enum.Material.SmoothPlastic,dark,s,false) end
 local monitor=part("ControlMonitor",Vector3.new(5,3,.25),CFrame.new(-45,-1.7,103.2),Enum.Material.Glass,Color3.fromRGB(36,74,78),s,false);light(monitor,Color3.fromRGB(75,190,205),.7,8)
 sign(monitor,"SECRET SYSTEM",Enum.NormalId.Front)
 local warning=part("WarningStripe",Vector3.new(8,.12,.5),CFrame.new(-45,-7.15,84),Enum.Material.Neon,Color3.fromRGB(218,170,54),s,false);sign(warning,"⚠  RESTRICTED",Enum.NormalId.Top)
 for _,x in ipairs({-57,-51,-39,-33}) do
  local l=part("CeilingLight",Vector3.new(1.2,.15,1.2),CFrame.new(x,-.8,92),Enum.Material.Neon,warm,s,false);light(l,warm,1.2,10)
 end
end

-- Night readability: warm windows and subtle moon-oriented lighting without overriding event logic.
local night=Lighting:FindFirstChild("VillageNight") or Instance.new("ColorCorrectionEffect")
night.Name="VillageNight";night.Brightness=0;night.Contrast=.08;night.Saturation=-.04;night.TintColor=Color3.fromRGB(210,220,235);night.Parent=Lighting

print("[SecretVillageGraphicsOverhaul2] High-detail environment pass initialized")
