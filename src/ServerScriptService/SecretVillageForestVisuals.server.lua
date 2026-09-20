-- SECRET VILLAGE FOREST VISUALS v1
-- Adds layered, varied trees and forest-floor decoration without replacing gameplay.

local Workspace = game:GetService("Workspace")
local world = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not world then return end
if world:FindFirstChild("FOREST_VISUALS_V1") then return end

local folder = Instance.new("Folder")
folder.Name = "FOREST_VISUALS_V1"
folder.Parent = world

local function part(name, size, color, material, cf, parent, shape)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = material
	p.CFrame = cf
	p.Anchored = true
	p.CanCollide = false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent
	return p
end

local function tree(pos, scale, variant)
	local model = Instance.new("Model")
	model.Name = "ForestTree"
	model.Parent = folder
	local trunkColor = variant == 2 and Color3.fromRGB(83, 54, 34) or Color3.fromRGB(105, 69, 42)
	local leafColor = variant == 3 and Color3.fromRGB(43, 112, 57) or Color3.fromRGB(35, 94, 48)
	local trunk = part("Trunk", Vector3.new(1.7*scale, 7*scale, 1.7*scale), trunkColor, Enum.Material.Wood, CFrame.new(pos + Vector3.new(0,3.5*scale,0)), model, Enum.PartType.Cylinder)
	trunk.CFrame *= CFrame.Angles(0, 0, math.rad(90))
	for i = 1, 4 do
		local y = (5.2 + i*1.35)*scale
		local spread = (4.8 - i*0.45)*scale
		part("Canopy", Vector3.new(spread, spread, spread), leafColor, Enum.Material.Grass, CFrame.new(pos + Vector3.new((i%2-0.5)*1.2*scale,y,((i+1)%2-0.5)*1.1*scale)), model, Enum.PartType.Ball)
	end
	part("Shadow", Vector3.new(5.5*scale,0.08,5.5*scale), Color3.fromRGB(25,55,30), Enum.Material.Grass, CFrame.new(pos + Vector3.new(0,0.05,0)), model, Enum.PartType.Cylinder)
end

local function bush(pos, scale)
	for i = 1, 3 do
		part("Bush", Vector3.new(2.4*scale,2.1*scale,2.4*scale), Color3.fromRGB(48,120,60), Enum.Material.Grass, CFrame.new(pos + Vector3.new((i-2)*1.1*scale,1*scale,((i%2)-0.5)*0.8*scale)), folder, Enum.PartType.Ball)
	end
end

local rng = Random.new(734)
for i = 1, 58 do
	local angle = rng:NextNumber(0, math.pi*2)
	local radius = rng:NextNumber(165, 238)
	local x, z = math.cos(angle)*radius, math.sin(angle)*radius
	tree(Vector3.new(x,0,z), rng:NextNumber(0.85,1.35), rng:NextInteger(1,3))
	if i % 2 == 0 then bush(Vector3.new(x+rng:NextNumber(-5,5),0,z+rng:NextNumber(-5,5)), rng:NextNumber(0.7,1.2)) end
end

for i = 1, 26 do
	local x = rng:NextNumber(-130,130)
	local z = rng:NextNumber(-130,130)
	if math.abs(x) > 45 or math.abs(z) > 45 then bush(Vector3.new(x,0,z), rng:NextNumber(0.55,0.9)) end
end

local atmosphere = game:GetService("Lighting"):FindFirstChild("SecretVillageForestAtmosphere")
if not atmosphere then
	atmosphere = Instance.new("Atmosphere")
	atmosphere.Name = "SecretVillageForestAtmosphere"
	atmosphere.Density = 0.28
	atmosphere.Offset = 0.15
	atmosphere.Color = Color3.fromRGB(178,205,180)
	atmosphere.Decay = Color3.fromRGB(78,105,82)
	atmosphere.Glare = 0.08
	atmosphere.Haze = 1.4
	atmosphere.Parent = game:GetService("Lighting")
end

print("SECRET VILLAGE FOREST VISUALS v1 READY")