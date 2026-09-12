-- SECRET VILLAGE ENVIRONMENT ART v1
-- Detailed environmental dressing: fences, lamps, flower beds, stones, grass clumps,
-- house trim, road markings and water-side decoration.
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")

local function part(name,size,cf,mat,color,parent)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.CanCollide=true
 p.Material=mat or Enum.Material.SmoothPlastic
 if color then p.Color=color end
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent or world
 return p
end

local function light(parent,color,brightness,range)
 local l=Instance.new("PointLight");l.Color=color;l.Brightness=brightness;l.Range=range;l.Shadows=true;l.Parent=parent
end

local function fence(x,z,length,alongX)
 local f=Instance.new("Folder");f.Name="VillageFence";f.Parent=world
 local step=6
 local count=math.max(1,math.floor(length/step))
 for i=0,count do
  local d=-length/2+i*step
  local px=x+(alongX and d or 0);local pz=z+(alongX and 0 or d)
  part("Post",Vector3.new(.45,2.4,.45),CFrame.new(px,1.35,pz),Enum.Material.Wood,Color3.fromRGB(101,76,51),f)
 end
 for y in {0.8,1.65} do
  local s=alongX and Vector3.new(length,0.18,.18) or Vector3.new(.18,.18,length)
  part("Rail",s,CFrame.new(x,y,z),Enum.Material.Wood,Color3.fromRGB(121,91,61),f)
 end
end

local function flowerBed(x,z)
 local f=Instance.new("Folder");f.Name="FlowerBed";f.Parent=world
 part("Soil",Vector3.new(7,.18,3),CFrame.new(x,.48,z),Enum.Material.Ground,Color3.fromRGB(76,54,38),f)
 for i=-2,2 do
  local stem=part("Stem",Vector3.new(.12,.65,.12),CFrame.new(x+i*1.35,.85,z+(i%2)*.35),Enum.Material.Grass,Color3.fromRGB(63,105,48),f)
  local bloom=part("Flower",Vector3.new(.42,.42,.42),CFrame.new(stem.Position+Vector3.new(0,.42,0)),Enum.Material.SmoothPlastic,Color3.fromRGB(190+(i%2)*25,150,95),f)
  bloom.Shape=Enum.PartType.Ball;bloom.CanCollide=false
 end
end

local function rock(x,y,z,s)
 local p=part("NaturalRock",Vector3.new(s,s*.55,s*.8),CFrame.new(x,y,z)*CFrame.Angles(.1,.35,.18),Enum.Material.Slate,Color3.fromRGB(92,94,86),world)
 p.CanCollide=true
end

local function lamp(x,z)
 local pole=part("StreetLamp",Vector3.new(.35,6,.35),CFrame.new(x,3,z),Enum.Material.Metal,Color3.fromRGB(48,51,48),world)
 local cap=part("LampHead",Vector3.new(1.2,.35,1.2),CFrame.new(x,6.05,z),Enum.Material.Metal,Color3.fromRGB(42,43,40),world)
 local bulb=part("LampGlow",Vector3.new(.6,.35,.6),CFrame.new(x,5.82,z),Enum.Material.Neon,Color3.fromRGB(255,214,145),world)
 bulb.CanCollide=false;light(bulb,Color3.fromRGB(255,196,120),1.15,15)
end

-- Roadside details and pedestrian-scale lighting.
lamp(14,-8);lamp(14,70);lamp(-14,-70);lamp(-14,20);lamp(48,10);lamp(48,58);lamp(-78,18)
fence(68,-18,42,true);fence(-55,-18,36,true);fence(55,76,36,true);fence(-105,36,30,false)
flowerBed(20,18);flowerBed(48,30);flowerBed(30,-58);flowerBed(-60,-18);flowerBed(82,48)

-- River banks get irregular stones so the water edge is not a perfect rectangle.
for i=1,28 do
 local x=-95+(i-1)*7
 local z=(i%2==0) and 40.5 or 75.5
 rock(x,.65,z,math.random(1,3))
end
for i=1,22 do
 local x=-110+math.random(0,140)
 local z=math.random(42,75)
 if math.abs(x+45)>8 then rock(x,.55,z,math.random(1,2)) end
end

-- Add simple architectural trim to generated houses.
for _,house in ipairs(world:GetChildren()) do
 if house:IsA("Folder") and house:FindFirstChild("House") and house:FindFirstChild("Roof") then
  local body=house:FindFirstChild("House")
  if not house:FindFirstChild("Trim") then
   local trim=Instance.new("Folder");trim.Name="Trim";trim.Parent=house
   local pos=body.Position;local sx=body.Size.X;local sz=body.Size.Z
   part("FrontTrim",Vector3.new(sx*.88,.28,.25),CFrame.new(pos.X,pos.Y+3.2,pos.Z-sz/2-.14),Enum.Material.Wood,Color3.fromRGB(74,54,40),trim)
   part("SideTrim",Vector3.new(.25,.28,sz*.88),CFrame.new(pos.X-sx/2-.14,pos.Y+3.2,pos.Z),Enum.Material.Wood,Color3.fromRGB(74,54,40),trim)
  end
 end
end

-- Gentle water-side vegetation.
for i=1,24 do
 local x=-100+math.random(0,110)
 local z=(math.random()<.5) and math.random(42,48) or math.random(68,74)
 local h=math.random(2,4)
 local g=part("Reed",Vector3.new(.12,h,.12),CFrame.new(x,h/2+.45,z),Enum.Material.Grass,Color3.fromRGB(70,106,51),world)
 g.CanCollide=false
end

-- Subtle environment audio placeholders; actual SoundIds can be assigned later.
local ambience=world:FindFirstChild("EnvironmentAmbience") or Instance.new("Folder")
ambience.Name="EnvironmentAmbience";ambience.Parent=world

-- Ensure event transitions don't permanently leave extreme visual settings.
Workspace:GetAttributeChangedSignal("BlackoutEvent"):Connect(function()
 if Workspace:GetAttribute("BlackoutEvent") then
  local tw=TweenService:Create(Lighting,TweenInfo.new(1),{Brightness=.35,ExposureCompensation=-.65})
  tw:Play()
 else
  local tw=TweenService:Create(Lighting,TweenInfo.new(1.5),{Brightness=2.1,ExposureCompensation=.05})
  tw:Play()
 end
end)

print("[SecretVillageEnvironmentArt] Environment dressing initialized")
