-- SECRET VILLAGE INTERIORS + NIGHT v1
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")
local root=world:FindFirstChild("INTERIORS_NIGHT") or Instance.new("Folder")
root.Name="INTERIORS_NIGHT";root.Parent=world
if root:GetAttribute("Built") then return end
root:SetAttribute("Built",true)
local function p(n,s,cf,m,c,parent,collide)
 local x=Instance.new("Part");x.Name=n;x.Size=s;x.CFrame=cf;x.Anchored=true;x.CanCollide=collide~=false;x.CanTouch=false;x.CanQuery=false;x.Material=m or Enum.Material.SmoothPlastic;if c then x.Color=c end;x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth;x.Parent=parent or root;return x
end
local function light(n,pos,color,range,brightness,parent)
 local x=p(n,Vector3.new(.25,.25,.25),CFrame.new(pos),Enum.Material.Neon,color,parent,false)
 local l=Instance.new("PointLight");l.Color=color;l.Range=range;l.Brightness=brightness;l.Shadows=true;l.Parent=x;return x
end
local function room(name,pos,size)
 local f=Instance.new("Folder");f.Name=name;f.Parent=root
 local x,y,z=size.X,size.Y,size.Z
 p("Floor",Vector3.new(x,.25,z),CFrame.new(pos.X,pos.Y,pos.Z),Enum.Material.Wood,Color3.fromRGB(103,78,57),f)
 p("Rug",Vector3.new(x*.48,.04,z*.5),CFrame.new(pos.X,pos.Y+.16,pos.Z),Enum.Material.Fabric,Color3.fromRGB(112,94,72),f,false)
 return f
end

-- Bakery interior: counter, display shelves, oven and warm lamps.
do
 local f=room("BakeryInterior",Vector3.new(-15,2, -29),Vector3.new(20,1,16))
 p("Counter",Vector3.new(7,2.2,2),CFrame.new(-15,3,-34),Enum.Material.Wood,Color3.fromRGB(116,76,45),f)
 for i=1,3 do p("Shelf",Vector3.new(5.5,.18,.7),CFrame.new(-19+i*2,4.2,-37),Enum.Material.Wood,Color3.fromRGB(92,61,39),f) end
 for i=1,5 do local a=p("Bread",Vector3.new(.7,.35,.7),CFrame.new(-22+i*1.5,4.48,-37),Enum.Material.SmoothPlastic,Color3.fromRGB(196,143,72),f,false);a.Shape=Enum.PartType.Ball end
 p("Oven",Vector3.new(3,2.3,2),CFrame.new(-7,3,-32),Enum.Material.Metal,Color3.fromRGB(66,65,61),f)
 p("OvenDoor",Vector3.new(2.2,1.3,.08),CFrame.new(-7,3,-33.05),Enum.Material.Glass,Color3.fromRGB(40,52,55),f,false)
 light("BakeryLamp",Vector3.new(-15,6,-31),Color3.fromRGB(255,204,137),12,1.5,f)
end

-- Village shop interior: shelving, register and product crates.
do
 local f=room("ShopInterior",Vector3.new(20,2,-29),Vector3.new(20,1,16))
 p("Register",Vector3.new(2,1.3,1.5),CFrame.new(14,3,-34),Enum.Material.Wood,Color3.fromRGB(88,69,49),f)
 p("Screen",Vector3.new(.8,.65,.08),CFrame.new(14,3.65,-34.8),Enum.Material.Neon,Color3.fromRGB(89,145,111),f,false)
 for _,x in ipairs({17,20,23,26}) do
  p("Shelf",Vector3.new(2.3,.2,5),CFrame.new(x,3.6,-29),Enum.Material.Wood,Color3.fromRGB(94,67,43),f)
  for i=1,3 do p("Product",Vector3.new(.55,.7,.55),CFrame.new(x-0.6+i*.55,4.05,-29),Enum.Material.SmoothPlastic,Color3.fromRGB(173,142,94),f,false) end
 end
 light("ShopLamp",Vector3.new(20,6,-29),Color3.fromRGB(255,222,171),12,1.25,f)
end

-- Old house attic: dusty crates and a small secret-looking ceiling lamp.
do
 local f=room("OldHouseAttic",Vector3.new(-70,10,-30),Vector3.new(16,1,12))
 for i=1,5 do p("Crate",Vector3.new(2,1.7,2),CFrame.new(-75+i*2.2,11,-33+(i%2)*2),Enum.Material.Wood,Color3.fromRGB(102,72,47),f) end
 p("Table",Vector3.new(5,.35,2.4),CFrame.new(-70,12,-27),Enum.Material.Wood,Color3.fromRGB(91,62,42),f)
 light("AtticLamp",Vector3.new(-70,14,-30),Color3.fromRGB(255,188,105),9,.8,f)
end

-- Secret room: control console, pipes, archive shelves and warning lighting.
do
 local f=Instance.new("Folder");f.Name="SecretRoomInterior";f.Parent=root
 for i=1,5 do p("ArchiveShelf",Vector3.new(.35,5,4),CFrame.new(-4+i*1.5,3,100),Enum.Material.Metal,Color3.fromRGB(59,63,61),f) end
 for i=1,8 do p("ArchiveBox",Vector3.new(1,.45,1.2),CFrame.new(-3.2+i*.75,3.1,99.6),Enum.Material.Wood,Color3.fromRGB(108,76,48),f,false) end
 p("ControlDesk",Vector3.new(5,1.2,2),CFrame.new(0,2,106),Enum.Material.Metal,Color3.fromRGB(55,59,58),f)
 p("Monitor",Vector3.new(2.8,1.8,.16),CFrame.new(0,3.45,105),Enum.Material.Metal,Color3.fromRGB(38,42,41),f)
 p("MonitorScreen",Vector3.new(2.35,1.3,.04),CFrame.new(0,3.45,104.9),Enum.Material.Neon,Color3.fromRGB(40,132,112),f,false)
 for _,x in ipairs({-1.4,-.7,0,.7,1.4}) do light("ConsoleLED",Vector3.new(x,2.7,104.9),Color3.fromRGB(54,198,165),5,.25,f) end
 p("PipeA",Vector3.new(.35,7,.35),CFrame.new(5,4,101),Enum.Material.Metal,Color3.fromRGB(76,78,74),f)
 p("PipeB",Vector3.new(5,.35,.35),CFrame.new(2.5,7.3,101),Enum.Material.Metal,Color3.fromRGB(76,78,74),f)
 light("SecretRoomLamp",Vector3.new(0,7,101),Color3.fromRGB(76,185,162),14,1.1,f)
end

-- Make the night event feel intentional: warm local lights remain readable against a darker sky.
local cc=Lighting:FindFirstChild("VillageNightCinema") or Instance.new("ColorCorrectionEffect")
cc.Name="VillageNightCinema";cc.Brightness=-.04;cc.Contrast=.18;cc.Saturation=-.08;cc.TintColor=Color3.fromRGB(202,216,235);cc.Enabled=false;cc.Parent=Lighting
local bloom=Lighting:FindFirstChild("VillageNightBloom") or Instance.new("BloomEffect")
bloom.Name="VillageNightBloom";bloom.Intensity=.14;bloom.Size=20;bloom.Threshold=.8;bloom.Enabled=false;bloom.Parent=Lighting
local function setNight(on)
 cc.Enabled=on;bloom.Enabled=on
 if on then
  Lighting.Brightness=.8
  Lighting.ExposureCompensation=-.35
 else
  Lighting.Brightness=2.1
  Lighting.ExposureCompensation=.05
 end
end
local night=Workspace:FindFirstChild("NightEvent")
if night and night:IsA("BoolValue") then night.Changed:Connect(function(v)setNight(v)end);setNight(night.Value) end
print("[SecretVillageInteriorsNight] Detailed interiors and night presentation initialized")
