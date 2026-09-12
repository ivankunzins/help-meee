-- SECRET VILLAGE HERO ASSETS v1
-- Hero-object polish for vehicles, fountain, bridge, NPC stands and secret entrance.
local Workspace=game:GetService("Workspace")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")
local root=world:FindFirstChild("HERO_ASSETS") or Instance.new("Folder")
root.Name="HERO_ASSETS";root.Parent=world
if root:GetAttribute("Built") then return end
root:SetAttribute("Built",true)
local function p(n,s,cf,m,c,parent,collide)
 local x=Instance.new("Part");x.Name=n;x.Size=s;x.CFrame=cf;x.Anchored=true;x.CanCollide=collide~=false;x.CanTouch=false;x.CanQuery=false;x.Material=m or Enum.Material.SmoothPlastic;if c then x.Color=c end;x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth;x.Parent=parent or root;return x
end
local function cyl(n,r,h,cf,m,c,parent)
 local x=p(n,Vector3.new(r*2,h,r*2),cf,m,c,parent);x.Shape=Enum.PartType.Cylinder;return x
end
local function ball(n,s,cf,m,c,parent)
 local x=p(n,Vector3.new(s,s,s),cf,m,c,parent,false);x.Shape=Enum.PartType.Ball;return x
end
local dark=Color3.fromRGB(42,45,43);local metal=Color3.fromRGB(72,76,73);local rubber=Color3.fromRGB(28,29,28);local chrome=Color3.fromRGB(175,178,171);local glass=Color3.fromRGB(70,130,150);local wood=Color3.fromRGB(111,77,49);local stone=Color3.fromRGB(122,120,111);local water=Color3.fromRGB(65,143,174);local red=Color3.fromRGB(155,57,46)

-- Fountain hero dressing: concentric stone base, basin rim and central feature.
do
 local f=Instance.new("Folder");f.Name="FountainHero";f.Parent=root
 cyl("LowerBasin",8,.55,CFrame.new(25,.55,-48),Enum.Material.Slate,stone,f)
 cyl("WaterBasin",6.8,.18,CFrame.new(25,.9,-48),Enum.Material.Glass,water,f)
 cyl("UpperBasin",3.2,.45,CFrame.new(25,2.1,-48),Enum.Material.Slate,stone,f)
 cyl("Column",.55,2.3,CFrame.new(25,2.9,-48),Enum.Material.Slate,stone,f)
 ball("FountainFinial",1.1,CFrame.new(25,4.25,-48),Enum.Material.Slate,stone,f)
 for i=1,12 do local a=i*math.pi/6;ball("RimStone",.55,CFrame.new(25+math.cos(a)*7.3,.95,-48+math.sin(a)*7.3),Enum.Material.Slate,stone,f) end
end

-- Bridge: layered decking, beams and railings.
do
 local f=Instance.new("Folder");f.Name="BridgeHero";f.Parent=root
 for x=-11,11,2 do p("DeckPlank",Vector3.new(1.7,.22,9),CFrame.new(x,.75,58),Enum.Material.Wood,wood,f) end
 for _,x in ipairs({-10,10}) do
  for _,z in ipairs({54,62}) do
   p("BridgePost",Vector3.new(.32,3,.32),CFrame.new(x,2.05,z),Enum.Material.Wood,dark,f)
  end
 end
 for _,z in ipairs({54,62}) do p("BridgeRail",Vector3.new(20,.25,.25),CFrame.new(0,3.25,z),Enum.Material.Wood,dark,f,false) end
 for _,x in ipairs({-10,10}) do p("BridgeBeam",Vector3.new(.45,.45,9.5),CFrame.new(x,.25,58),Enum.Material.Wood,dark,f) end
end

-- Detailed parked vehicles used as scenery; no seats or gameplay events are attached.
local cars=Instance.new("Folder");cars.Name="ParkedVehicleScenery";cars.Parent=root
local function car(x,z,bodyColor,rot)
 local f=Instance.new("Folder");f.Name="ParkedCar";f.Parent=cars
 local cf=CFrame.new(x,.85,z)*CFrame.Angles(0,rot or 0,0)
 p("Body",Vector3.new(7,1.25,3.2),cf,Enum.Material.Metal,bodyColor,f)
 p("Cabin",Vector3.new(3.7,1.35,2.7),cf*CFrame.new(-.2,1.15,0),Enum.Material.Metal,bodyColor,f)
 p("Windshield",Vector3.new(.12,1,2.25),cf*CFrame.new(1.7,1.2,0)*CFrame.Angles(0,math.rad(0),0),Enum.Material.Glass,glass,f,false)
 for _,yy in ipairs({-.95,.95}) do p("WindowSide",Vector3.new(1.9,.72,.08),cf*CFrame.new(-.2,1.35,yy),Enum.Material.Glass,glass,f,false) end
 for _,xx in ipairs({-2.4,2.4}) do
  for _,zz in ipairs({-1.7,1.7}) do cyl("Wheel",.58,.35,cf*CFrame.new(xx,-.55,zz)*CFrame.Angles(math.rad(90),0,0),Enum.Material.Rubber,rubber,f) end
 end
 for _,xx in ipairs({-3.55,3.55}) do
  local lamp=p("Lamp",Vector3.new(.45,.35,.12),cf*CFrame.new(xx,.95,-1.62),Enum.Material.Glass,Color3.fromRGB(235,218,160),f,false)
 end
end
car(38,-14,Color3.fromRGB(80,92,88),math.rad(90));car(-37,-10,Color3.fromRGB(125,91,60),math.rad(-90));car(75,18,Color3.fromRGB(92,101,112),0)

-- Job hubs receive recognizable visual silhouettes.
local hubs=Instance.new("Folder");hubs.Name="JobHubHeroes";hubs.Parent=root
local function kiosk(name,x,z,title,accent)
 local f=Instance.new("Folder");f.Name=name;f.Parent=hubs
 p("Kiosk",Vector3.new(4,3.4,2),CFrame.new(x,2,z),Enum.Material.Wood,wood,f)
 p("Counter",Vector3.new(4.4,.25,2.2),CFrame.new(x,3.55,z),Enum.Material.Wood,dark,f)
 p("Sign",Vector3.new(3.2,1,.15),CFrame.new(x,4.45,z-1.05),Enum.Material.Wood,accent,f,false)
 local sg=Instance.new("SurfaceGui");sg.Face=Enum.NormalId.Front;sg.Parent=f.Sign
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=title;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.new(1,1,1);t.Parent=sg
end
kiosk("JanitorHub",-22,30,"CLEAN TEAM",Color3.fromRGB(61,113,89));kiosk("FisherHub",62,25,"FISHING",Color3.fromRGB(53,100,137))

-- Underwater entrance gets a clear but mysterious hero silhouette.
do
 local f=Instance.new("Folder");f.Name="UnderwaterEntranceHero";f.Parent=root
 p("FrameTop",Vector3.new(9,.55,.55),CFrame.new(-45,-2.5,65),Enum.Material.Metal,dark,f)
 for _,x in ipairs({-49,-41}) do p("FrameSide",Vector3.new(.55,5,.55),CFrame.new(x,-5,65),Enum.Material.Metal,dark,f) end
 p("DoorGlow",Vector3.new(7,4,.12),CFrame.new(-45,-5,64.65),Enum.Material.Neon,Color3.fromRGB(48,154,170),f,false)
 for i=1,7 do p("WarningStrip",Vector3.new(.55,.15,.18),CFrame.new(-48+i*1.0,-3,64.5),Enum.Material.Neon,Color3.fromRGB(210,167,57),f,false) end
end

print("[SecretVillageHeroAssets] Hero object visual pass initialized")
