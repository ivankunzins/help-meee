-- SECRET VILLAGE MEADOWS & GRASS v1
-- Adds grass coverage, meadow patches and forest-edge clearings.
-- Decorative layer only: does not replace gameplay systems.

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local world = Workspace:FindFirstChild("SECRET_VILLAGE_FINAL_MASTER")
if not world then
	warn("MEADOWS: SECRET_VILLAGE_FINAL_MASTER not found")
	return
end

if Workspace:FindFirstChild("SECRET_VILLAGE_MEADOWS_V1") then
	return
end

local meadowRoot = Instance.new("Folder")
meadowRoot.Name = "SECRET_VILLAGE_MEADOWS_V1"
meadowRoot.Parent = Workspace

local rng = Random.new(24091990)
local grassColors = {
	Color3.fromRGB(61, 105, 42),
	Color3.fromRGB(76, 124, 49),
	Color3.fromRGB(91, 139, 57),
	Color3.fromRGB(47, 91, 38),
}
local flowerColors = {
	Color3.fromRGB(244, 221, 150),
	Color3.fromRGB(226, 157, 183),
	Color3.fromRGB(170, 188, 238),
	Color3.fromRGB(245, 245, 220),
}

local function makePart(parent, name, size, cf, color, material, shape)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cf
	part.Color = color
	part.Material = material or Enum.Material.Grass
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	if shape then part.Shape = shape end
	part.Parent = parent
	return part
end

local function meadowPatch(x, z, radiusX, radiusZ, rotation)
	local patch = Instance.new("Model")
	patch.Name = "MeadowPatch"
	patch.Parent = meadowRoot

	local base = makePart(
		patch,
		"SoftGrassGround",
		Vector3.new(radiusX * 2, 0.12, radiusZ * 2),
		CFrame.new(x, 0.08, z) * CFrame.Angles(0, rotation, 0),
		Color3.fromRGB(67, 116, 45),
		Enum.Material.Grass,
		Enum.PartType.Cylinder
	)
	base.Transparency = 0.18

	local blades = math.floor((radiusX + radiusZ) * 1.35)
	for i = 1, blades do
		local angle = rng:NextNumber(0, math.pi * 2)
		local distance = math.sqrt(rng:NextNumber())
		local px = x + math.cos(angle) * radiusX * distance
		local pz = z + math.sin(angle) * radiusZ * distance
		local height = rng:NextNumber(0.35, 0.9)
		local width = rng:NextNumber(0.07, 0.16)
		local lean = rng:NextNumber(-0.22, 0.22)
		local grass = makePart(
			patch,
			"GrassBlade",
			Vector3.new(width, height, width),
			CFrame.new(px, 0.18 + height / 2, pz) * CFrame.Angles(lean, rng:NextNumber(0, math.pi), lean),
			grassColors[rng:NextInteger(1, #grassColors)],
			Enum.Material.Grass,
			nil
		)
		grass.CastShadow = false
	end

	local flowers = math.floor((radiusX + radiusZ) / 4)
	for i = 1, flowers do
		local angle = rng:NextNumber(0, math.pi * 2)
		local distance = math.sqrt(rng:NextNumber())
		local px = x + math.cos(angle) * radiusX * distance
		local pz = z + math.sin(angle) * radiusZ * distance
		local stem = makePart(patch, "FlowerStem", Vector3.new(0.035, 0.35, 0.035), CFrame.new(px, 0.35, pz), Color3.fromRGB(47, 94, 37), Enum.Material.Grass)
		stem.CastShadow = false
		makePart(patch, "WildFlower", Vector3.new(0.16, 0.16, 0.16), CFrame.new(px, 0.57, pz), flowerColors[rng:NextInteger(1, #flowerColors)], Enum.Material.Neon, Enum.PartType.Ball)
	end
end

-- Broad clearings between the village and the forest ring.
local patches = {
	{0, 116, 24, 16, 0.2},
	{-42, 112, 25, 17, -0.5},
	{45, 115, 24, 16, 0.7},
	{-78, 92, 22, 15, 0.1},
	{77, 95, 24, 17, -0.3},
	{-112, 55, 20, 14, 0.8},
	{112, 55, 21, 15, -0.6},
	{-121, 8, 20, 15, 0.2},
	{122, 10, 22, 15, -0.2},
	{-112, -48, 23, 15, -0.4},
	{111, -49, 22, 16, 0.5},
	{-76, -91, 26, 16, -0.8},
	{77, -90, 24, 17, 0.6},
	{-35, -112, 25, 16, 0.1},
	{38, -113, 25, 16, -0.3},
	{0, -127, 28, 15, 0.4},
}

for _, data in ipairs(patches) do
	meadowPatch(table.unpack(data))
end

-- Small scattered grass clusters make the transition to the forest less artificial.
for i = 1, 85 do
	local angle = rng:NextNumber(0, math.pi * 2)
	local radius = rng:NextNumber(92, 158)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	local cluster = Instance.new("Model")
	cluster.Name = "GrassCluster"
	cluster.Parent = meadowRoot
	local count = rng:NextInteger(3, 6)
	for j = 1, count do
		local offsetX = rng:NextNumber(-1.6, 1.6)
		local offsetZ = rng:NextNumber(-1.6, 1.6)
		local height = rng:NextNumber(0.45, 1.15)
		makePart(
			cluster,
			"TallGrass",
			Vector3.new(rng:NextNumber(0.08, 0.16), height, rng:NextNumber(0.08, 0.16)),
			CFrame.new(x + offsetX, 0.2 + height / 2, z + offsetZ) * CFrame.Angles(rng:NextNumber(-0.2, 0.2), rng:NextNumber(0, math.pi), rng:NextNumber(-0.2, 0.2)),
			grassColors[rng:NextInteger(1, #grassColors)],
			Enum.Material.Grass
		)
	end
end

-- A subtle green tint helps the clearings blend with the forest.
local colorCorrection = Lighting:FindFirstChild("SecretVillageMeadowColor")
if not colorCorrection then
	colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.Name = "SecretVillageMeadowColor"
	colorCorrection.TintColor = Color3.fromRGB(231, 242, 216)
	colorCorrection.Saturation = 0.08
	colorCorrection.Contrast = 0.04
	colorCorrection.Parent = Lighting
end

print("SECRET VILLAGE MEADOWS & GRASS v1 READY")