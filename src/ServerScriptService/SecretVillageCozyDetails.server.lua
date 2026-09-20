-- SECRET VILLAGE COZY DETAILS v1
-- Additional decorative pass for the cozy village.

local Workspace = game:GetService("Workspace")
local root = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not root then return end
local art = root:FindFirstChild("COZY_VILLAGE_ART_V1")
if not art or art:FindFirstChild("COZY_DETAILS_V1") then return end

local details = Instance.new("Folder")
details.Name = "COZY_DETAILS_V1"
details.Parent = art

local function p(parent, name, size, pos, material, color, collide)
	local x = Instance.new("Part")
	x.Name = name
	x.Size = size
	x.Position = pos
	x.Anchored = true
	x.Material = material or Enum.Material.Wood
	x.Color = color or Color3.fromRGB(105,66,43)
	x.TopSurface = Enum.SurfaceType.Smooth
	x.BottomSurface = Enum.SurfaceType.Smooth
	x.CanCollide = collide ~= false
	x.Parent = parent
	return x
end

local function ball(parent, name, size, pos, material, color)
	local x = p(parent,name,size,pos,material,color,false)
	x.Shape = Enum.PartType.Ball
	return x
end

local function cylinder(parent, name, radius, height, pos, material, color)
	local x = p(parent,name,Vector3.new(height,radius*2,radius*2),pos,material,color,false)
	x.Shape = Enum.PartType.Cylinder
	x.CFrame = x.CFrame * CFrame.Angles(0,0,math.rad(90))
	return x
end

local wood = Color3.fromRGB(105,66,43)
local dark = Color3.fromRGB(55,38,30)
local green = Color3.fromRGB(54,110,61)
local green2 = Color3.fromRGB(84,143,70)
local warm = Color3.fromRGB(255,195,100)
local stone = Color3.fromRGB(132,126,116)

-- Chimneys and smoke-like decorative caps on the larger buildings.
for _,data in ipairs({
	{Vector3.new(0,0,-42),Vector3.new(8,0,5)},
	{Vector3.new(-42,0,-22),Vector3.new(-7,0,4)},
}) do
	local c = data[1] + data[2]
	p(details,"Chimney",Vector3.new(1.8,4,1.8),c+Vector3.new(0,13,0),Enum.Material.Brick,Color3.fromRGB(125,76,62))
	p(details,"ChimneyCap",Vector3.new(2.3,0.3,2.3),c+Vector3.new(0,15,0),Enum.Material.Brick,dark,false)
	for i=1,3 do
		ball(details,"Smoke",Vector3.new(0.6+i*0.25,0.6+i*0.25,0.6+i*0.25),c+Vector3.new((i-2)*0.35,15+i*0.8,0),Enum.Material.SmoothPlastic,Color3.fromRGB(190,190,185))
	end
end

-- Bush clusters around the homes and paths.
local bushes = {
	Vector3.new(-24,1, -18),Vector3.new(-27,1,-13),Vector3.new(25,1,-17),Vector3.new(29,1,-12),
	Vector3.new(-57,1,10),Vector3.new(-52,1,13),Vector3.new(59,1,8),Vector3.new(62,1,12),
	Vector3.new(-20,1,57),Vector3.new(-15,1,59),Vector3.new(28,1,18),Vector3.new(31,1,20),
}
for i,pos in ipairs(bushes) do
	ball(details,"Bush",Vector3.new(3.4,2.4,3.4),pos,Enum.Material.Grass,(i%2==0) and green or green2)
	ball(details,"BushSmall",Vector3.new(2.1,1.7,2.1),pos+Vector3.new(1.1,0.1,0.35),Enum.Material.Grass,green)
end

-- Decorative wooden barrels, crates and flower pots near the market and shop.
for i=0,3 do
	local x = -49 + i*3
	cylinder(details,"Barrel",0.75,1.6,Vector3.new(x,1.25,-13),Enum.Material.Wood,wood)
	p(details,"BarrelBand",Vector3.new(1.7,0.12,1.7),Vector3.new(x,1.05,-13),Enum.Material.Metal,dark,false)
	p(details,"Crate",Vector3.new(1.6,1.6,1.6),Vector3.new(-48+i*2,0.8,-10),Enum.Material.WoodPlanks,Color3.fromRGB(151,99,58))
end

-- A cozy campfire area outside the square.
local fire = Instance.new("Model")
fire.Name = "VillageCampfire"
fire.Parent = details
for angle=0,300,60 do
	local a=math.rad(angle)
	local log=cylinder(fire,"Firewood",0.22,3,Vector3.new(math.cos(a)*1.1,0.7,math.sin(a)*1.1),Enum.Material.Wood,wood)
	log.CFrame = log.CFrame * CFrame.Angles(0,math.rad(angle),math.rad(90))
end
for angle=0,270,90 do
	local a=math.rad(angle)
	ball(fire,"Stone",Vector3.new(1.2,0.8,1.2),Vector3.new(0.2+math.cos(a)*2,0.4,42+math.sin(a)*2),Enum.Material.Slate,stone)
end
local flame=ball(fire,"Flame",Vector3.new(1.8,2.8,1.8),Vector3.new(0.2,2,42),Enum.Material.Neon,Color3.fromRGB(255,126,45))
local fireLight=Instance.new("PointLight")
fireLight.Color=Color3.fromRGB(255,145,70)
fireLight.Brightness=2.5
fireLight.Range=18
fireLight.Parent=flame

-- Small stepping stones beside the main paths.
for i=-4,4 do
	p(details,"SteppingStone",Vector3.new(2.4,0.22,1.4),Vector3.new(i*3,0.2,24+math.sin(i)*1.5),Enum.Material.Slate,stone,false)
end

-- Add a soft sun glow to the existing lighting without replacing other systems.
local lighting = game:GetService("Lighting")
local bloom = lighting:FindFirstChild("SecretVillage_CozyBloom")
if not bloom then
	bloom=Instance.new("BloomEffect")
	bloom.Name="SecretVillage_CozyBloom"
	bloom.Intensity=0.18
	bloom.Size=24
	bloom.Threshold=1.1
	bloom.Parent=lighting
end

print("[CozyDetails] v1 created: chimneys, bushes, barrels, campfire, stones and bloom")