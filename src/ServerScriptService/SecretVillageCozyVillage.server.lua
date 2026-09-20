-- SECRET VILLAGE COZY VILLAGE v1
-- Decorative village layer: square, cottages, town hall, shop, jobs, quests, lamps, signs and dock.
-- Safe to run once. Does not replace gameplay systems or existing world geometry.

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local ROOT = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not ROOT then
	warn("[CozyVillage] SECRET_VILLAGE_FINAL_MASTER was not found")
	return
end

if ROOT:FindFirstChild("COZY_VILLAGE_ART_V1") then
	return
end

local ART = Instance.new("Folder")
ART.Name = "COZY_VILLAGE_ART_V1"
ART.Parent = ROOT

local COLORS = {
	Wood = Color3.fromRGB(105, 66, 43),
	WoodDark = Color3.fromRGB(65, 40, 29),
	WoodLight = Color3.fromRGB(166, 106, 65),
	Wall = Color3.fromRGB(224, 188, 133),
	WallLight = Color3.fromRGB(247, 218, 166),
	Roof = Color3.fromRGB(64, 68, 91),
	RoofWarm = Color3.fromRGB(105, 57, 48),
	Window = Color3.fromRGB(255, 220, 116),
	Stone = Color3.fromRGB(132, 126, 116),
	Path = Color3.fromRGB(157, 135, 111),
	Grass = Color3.fromRGB(93, 137, 70),
	Leaf = Color3.fromRGB(52, 105, 57),
	Water = Color3.fromRGB(65, 156, 190),
	Metal = Color3.fromRGB(70, 77, 79),
	Red = Color3.fromRGB(151, 61, 48),
}

local function part(parent, name, size, cf, material, color, canCollide)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Anchored = true
	p.Material = material or Enum.Material.Wood
	p.Color = color or COLORS.Wood
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.CanCollide = canCollide ~= false
	p.CastShadow = true
	p.Parent = parent
	return p
end

local function block(parent, name, size, position, material, color, canCollide)
	return part(parent, name, size, CFrame.new(position), material, color, canCollide)
end

local function cylinder(parent, name, radius, height, position, material, color)
	local p = part(parent, name, Vector3.new(height, radius * 2, radius * 2), CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90)), material, color)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function ball(parent, name, size, position, material, color)
	local p = block(parent, name, size, position, material, color, false)
	p.Shape = Enum.PartType.Ball
	p.CanCollide = false
	return p
end

local function model(name)
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = ART
	return m
end

local function roof(parent, center, width, depth, height, roofColor)
	local left = part(parent, "RoofLeft", Vector3.new(width / 2 + 1, 0.7, depth + 1), CFrame.new(center + Vector3.new(-width / 4, height, 0)) * CFrame.Angles(0, 0, math.rad(-27)), Enum.Material.Slate, roofColor)
	local right = part(parent, "RoofRight", Vector3.new(width / 2 + 1, 0.7, depth + 1), CFrame.new(center + Vector3.new(width / 4, height, 0)) * CFrame.Angles(0, 0, math.rad(27)), Enum.Material.Slate, roofColor)
	return left, right
end

local function window(parent, position, rotation)
	local frame = block(parent, "WindowFrame", Vector3.new(2.7, 2.8, 0.25), position, Enum.Material.Wood, COLORS.WoodDark, false)
	local glass = block(parent, "WarmWindow", Vector3.new(2.1, 2.2, 0.12), position + Vector3.new(0, 0, -0.16), Enum.Material.Neon, COLORS.Window, false)
	if rotation then
		frame.CFrame = frame.CFrame * rotation
		glass.CFrame = glass.CFrame * rotation
	end
	return glass
end

local function door(parent, position, rotation)
	local d = block(parent, "Door", Vector3.new(2.3, 3.8, 0.3), position, Enum.Material.Wood, COLORS.WoodDark)
	local knob = ball(parent, "DoorKnob", Vector3.new(0.18, 0.18, 0.18), position + Vector3.new(0.65, 0, -0.22), Enum.Material.Metal, Color3.fromRGB(226, 184, 76))
	if rotation then
		d.CFrame = d.CFrame * rotation
		knob.CFrame = knob.CFrame * rotation
	end
end

local function lamp(parent, position)
	local pole = cylinder(parent, "LampPole", 0.12, 4.4, position + Vector3.new(0, 2.2, 0), Enum.Material.Metal, COLORS.Metal)
	local cap = block(parent, "LampCap", Vector3.new(0.9, 0.25, 0.9), position + Vector3.new(0, 4.45, 0), Enum.Material.Wood, COLORS.WoodDark, false)
	local lightPart = ball(parent, "Lantern", Vector3.new(0.7, 0.7, 0.7), position + Vector3.new(0, 3.95, 0), Enum.Material.Neon, COLORS.Window)
	local light = Instance.new("PointLight")
	light.Name = "WarmLight"
	light.Color = Color3.fromRGB(255, 194, 112)
	light.Brightness = 1.5
	light.Range = 15
	light.Shadows = true
	light.Parent = lightPart
	return pole, cap, lightPart
end

local function sign(parent, text, position, size, rotation)
	local board = block(parent, "SignBoard", size, position, Enum.Material.Wood, COLORS.WoodDark)
	if rotation then
		board.CFrame = board.CFrame * rotation
	end
	local gui = Instance.new("SurfaceGui")
	gui.Name = "SignText"
	gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 35
	gui.Parent = board
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 224, 157)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextStrokeTransparency = 0.55
	label.Parent = gui
	return board
end

local function flowerBed(parent, center)
	block(parent, "FlowerBed", Vector3.new(5.5, 0.25, 2.5), center, Enum.Material.Grass, COLORS.Grass, false)
	for i = -2, 2 do
		local flower = ball(parent, "Flower", Vector3.new(0.45, 0.45, 0.45), center + Vector3.new(i * 1.05, 0.45, 0), Enum.Material.Neon, (i % 2 == 0) and Color3.fromRGB(230, 104, 137) or Color3.fromRGB(255, 211, 83))
		block(parent, "Stem", Vector3.new(0.08, 0.55, 0.08), center + Vector3.new(i * 1.05, 0.2, 0), Enum.Material.Grass, COLORS.Leaf, false)
	end
end

local function path(center, size)
	return block(ART, "CobblestonePath", size, center, Enum.Material.Cobblestone, COLORS.Path, true)
end

local function cottage(name, center, wallColor, roofColor, signText)
	local m = model(name)
	local w, d, h = 14, 12, 8
	block(m, "Foundation", Vector3.new(w + 1, 0.8, d + 1), center + Vector3.new(0, 0.4, 0), Enum.Material.Cobblestone, COLORS.Stone)
	block(m, "BackWall", Vector3.new(w, h, 0.5), center + Vector3.new(0, h / 2 + 0.8, d / 2), Enum.Material.WoodPlanks, wallColor)
	block(m, "FrontWall", Vector3.new(w, h, 0.5), center + Vector3.new(0, h / 2 + 0.8, -d / 2), Enum.Material.WoodPlanks, wallColor)
	block(m, "LeftWall", Vector3.new(0.5, h, d), center + Vector3.new(-w / 2, h / 2 + 0.8, 0), Enum.Material.WoodPlanks, wallColor)
	block(m, "RightWall", Vector3.new(0.5, h, d), center + Vector3.new(w / 2, h / 2 + 0.8, 0), Enum.Material.WoodPlanks, wallColor)
	roof(m, center, w + 2, d + 2, h + 3.3, roofColor)
	door(m, center + Vector3.new(0, 2.7, -d / 2 - 0.3))
	window(m, center + Vector3.new(-4, 4.4, -d / 2 - 0.3))
	window(m, center + Vector3.new(4, 4.4, -d / 2 - 0.3))
	window(m, center + Vector3.new(-w / 2 - 0.3, 4.4, 0), CFrame.Angles(0, math.rad(90), 0))
	if signText then
		sign(m, signText, center + Vector3.new(0, 7.1, -d / 2 - 0.5), Vector3.new(7, 1.25, 0.25))
	end
	return m
end

local function largeBuilding(name, center, labelText, roofColor)
	local m = model(name)
	local w, d, h = 24, 18, 11
	block(m, "Foundation", Vector3.new(w + 2, 1, d + 2), center + Vector3.new(0, 0.5, 0), Enum.Material.Cobblestone, COLORS.Stone)
	block(m, "BackWall", Vector3.new(w, h, 0.6), center + Vector3.new(0, h / 2 + 1, d / 2), Enum.Material.WoodPlanks, COLORS.Wall)
	block(m, "FrontWall", Vector3.new(w, h, 0.6), center + Vector3.new(0, h / 2 + 1, -d / 2), Enum.Material.WoodPlanks, COLORS.WallLight)
	block(m, "LeftWall", Vector3.new(0.6, h, d), center + Vector3.new(-w / 2, h / 2 + 1, 0), Enum.Material.WoodPlanks, COLORS.Wall)
	block(m, "RightWall", Vector3.new(0.6, h, d), center + Vector3.new(w / 2, h / 2 + 1, 0), Enum.Material.WoodPlanks, COLORS.Wall)
	roof(m, center, w + 2, d + 2, h + 4.2, roofColor)
	door(m, center + Vector3.new(0, 3.2, -d / 2 - 0.4))
	for x = -7, 7, 7 do
		window(m, center + Vector3.new(x, 5.4, -d / 2 - 0.4))
	end
	sign(m, labelText, center + Vector3.new(0, 8.3, -d / 2 - 0.65), Vector3.new(10, 1.5, 0.3))
	return m
end

-- Main village paths and square.
path(Vector3.new(0, 0.08, 0), Vector3.new(42, 0.22, 42))
path(Vector3.new(0, 0.1, 37), Vector3.new(12, 0.24, 70))
path(Vector3.new(-39, 0.1, 0), Vector3.new(70, 0.24, 10))
path(Vector3.new(39, 0.1, 0), Vector3.new(70, 0.24, 10))

-- Central fountain.
local fountain = model("VillageFountain")
cylinder(fountain, "Base", 7.5, 0.8, Vector3.new(0, 0.55, 0), Enum.Material.Cobblestone, COLORS.Stone)
cylinder(fountain, "Water", 6.3, 0.18, Vector3.new(0, 1.05, 0), Enum.Material.Glass, COLORS.Water)
cylinder(fountain, "Column", 1.1, 4.2, Vector3.new(0, 2.8, 0), Enum.Material.Cobblestone, COLORS.Stone)
ball(fountain, "FountainTop", Vector3.new(2.5, 1.1, 2.5), Vector3.new(0, 5.05, 0), Enum.Material.Cobblestone, COLORS.Stone)
for angle = 0, 270, 90 do
	local a = math.rad(angle)
	lamp(fountain, Vector3.new(math.cos(a) * 9, 0, math.sin(a) * 9))
end
sign(fountain, "SECRET VILLAGE", Vector3.new(0, 3.1, 7.8), Vector3.new(8, 1.35, 0.25))

-- Buildings around the square.
largeBuilding("TownHall", Vector3.new(0, 0, -42), "TOWN HALL", COLORS.Roof)
largeBuilding("Shop", Vector3.new(-42, 0, -22), "SHOP", COLORS.RoofWarm)
cottage("JobsHouse", Vector3.new(34, 0, -23), COLORS.WallLight, COLORS.Roof, "JOBS")
cottage("QuestHouse", Vector3.new(43, 0, 23), COLORS.Wall, COLORS.RoofWarm, "QUESTS")
cottage("FisherHouse", Vector3.new(-36, 0, 30), COLORS.WallLight, COLORS.Roof, "FISHING")
cottage("VillageHome01", Vector3.new(-62, 0, 20), COLORS.Wall, COLORS.RoofWarm, nil)
cottage("VillageHome02", Vector3.new(67, 0, -2), COLORS.WallLight, COLORS.Roof, nil)
cottage("VillageHome03", Vector3.new(-12, 0, 63), COLORS.Wall, COLORS.RoofWarm, nil)

-- Market stalls.
local market = model("MarketStalls")
for i = -1, 1 do
	local x = i * 9
	block(market, "StallTable", Vector3.new(7, 0.45, 3), Vector3.new(x, 2.1, 15), Enum.Material.Wood, COLORS.Wood)
	for side = -1, 1, 2 do
		block(market, "StallPost", Vector3.new(0.35, 5, 0.35), Vector3.new(x + side * 3, 4.5, 15), Enum.Material.Wood, COLORS.WoodDark)
	end
	block(market, "StallRoof", Vector3.new(8, 0.35, 4.2), Vector3.new(x, 7.1, 15), Enum.Material.Fabric, (i == 0) and COLORS.Red or COLORS.WallLight)
end

-- Flower beds and seating.
flowerBed(ART, Vector3.new(-12, 0.25, -7))
flowerBed(ART, Vector3.new(12, 0.25, -7))
flowerBed(ART, Vector3.new(-12, 0.25, 7))
flowerBed(ART, Vector3.new(12, 0.25, 7))
for _, p in ipairs({Vector3.new(-17, 0, 0), Vector3.new(17, 0, 0), Vector3.new(0, 0, -17), Vector3.new(0, 0, 17)}) do
	block(ART, "BenchSeat", Vector3.new(4, 0.35, 1), p + Vector3.new(0, 1.5, 0), Enum.Material.Wood, COLORS.Wood)
	block(ART, "BenchLeg", Vector3.new(0.35, 1.5, 0.35), p + Vector3.new(-1.4, 0.75, 0), Enum.Material.Wood, COLORS.WoodDark)
	block(ART, "BenchLeg", Vector3.new(0.35, 1.5, 0.35), p + Vector3.new(1.4, 0.75, 0), Enum.Material.Wood, COLORS.WoodDark)
end

-- Direction signs near the main path.
local directions = model("DirectionSigns")
sign(directions, "SHOP", Vector3.new(-15, 3.2, 26), Vector3.new(5, 1, 0.3))
sign(directions, "QUESTS", Vector3.new(15, 3.2, 26), Vector3.new(5, 1, 0.3))
sign(directions, "FOREST", Vector3.new(0, 3.2, 82), Vector3.new(6, 1, 0.3))
sign(directions, "FISHING", Vector3.new(-25, 3.2, 45), Vector3.new(6, 1, 0.3))
sign(directions, "EXPLORE • DISCOVER • FIND SECRETS", Vector3.new(0, 5.5, 96), Vector3.new(18, 2, 0.35))

-- Warm street lighting around the village.
for _, p in ipairs({
	Vector3.new(-24, 0, -28), Vector3.new(24, 0, -28), Vector3.new(-28, 0, 28), Vector3.new(28, 0, 28),
	Vector3.new(-52, 0, -7), Vector3.new(52, 0, -7), Vector3.new(-52, 0, 18), Vector3.new(52, 0, 18),
	Vector3.new(-7, 0, 47), Vector3.new(7, 0, 47),
} ) do
	lamp(ART, p)
end

-- Small dock and boats by the existing water side.
local dock = model("VillageDock")
for z = 48, 78, 5 do
	block(dock, "DockPlank", Vector3.new(12, 0.45, 4.2), Vector3.new(38, 1.15, z), Enum.Material.WoodPlanks, COLORS.Wood)
end
for x = 33, 43, 10 do
	for z = 48, 78, 15 do
		cylinder(dock, "DockPost", 0.22, 4, Vector3.new(x, -0.4, z), Enum.Material.Wood, COLORS.WoodDark)
	end
end
sign(dock, "FISHING • BOATS", Vector3.new(38, 4.2, 48), Vector3.new(9, 1.4, 0.3))

local boat = model("VillageRowboat")
block(boat, "Hull", Vector3.new(5, 1.2, 12), Vector3.new(49, 0.2, 65), Enum.Material.Wood, COLORS.WoodDark, false)
block(boat, "Seat", Vector3.new(4, 0.3, 1), Vector3.new(49, 1.0, 65), Enum.Material.Wood, COLORS.Wood, false)
block(boat, "Oar", Vector3.new(0.18, 0.18, 7), Vector3.new(45.8, 1.2, 65), Enum.Material.Wood, COLORS.WoodLight, false)
block(boat, "Oar", Vector3.new(0.18, 0.18, 7), Vector3.new(52.2, 1.2, 65), Enum.Material.Wood, COLORS.WoodLight, false)

-- Ambient lighting settings for the cozy look.
Lighting.ClockTime = 17.4
Lighting.Brightness = 2.2
Lighting.GlobalShadows = true
local atmosphere = Lighting:FindFirstChild("SecretVillage_CozyAtmosphere")
if not atmosphere then
	atmosphere = Instance.new("Atmosphere")
	atmosphere.Name = "SecretVillage_CozyAtmosphere"
	atmosphere.Parent = Lighting
end
atmosphere.Density = 0.28
atmosphere.Haze = 1.1
atmosphere.Glare = 0.08
atmosphere.Color = Color3.fromRGB(205, 218, 255)
atmosphere.Decay = Color3.fromRGB(255, 188, 145)

print("[CozyVillage] v1 created: square, buildings, signs, lamps, market, fountain and dock")