-- SECRET VILLAGE ARCHITECTURE + VEHICLE VISUAL PASS v1
-- Visual-only layer. Does not replace gameplay scripts.
-- Builds a large amount of detail around the generated village and vehicle prototypes.

local Workspace = game:GetService("Workspace")

local ROOT_NAME = "GRAPHICS_ARCHITECTURE_V1"
if Workspace:FindFirstChild(ROOT_NAME) then return end

local ROOT = Instance.new("Folder")
ROOT.Name = ROOT_NAME
ROOT.Parent = Workspace

local function part(name, size, cf, material, parent, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Anchored = true
	p.CanCollide = true
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent or ROOT
	return p
end

local function cyl(name, radius, height, cf, material, parent)
	local p = part(name, Vector3.new(radius * 2, height, radius * 2), cf, material, parent)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function ball(name, size, cf, material, parent)
	local p = part(name, size, cf, material, parent)
	p.Shape = Enum.PartType.Ball
	return p
end

local function light(parent, color, brightness, range)
	local l = Instance.new("PointLight")
	l.Color = color
	l.Brightness = brightness
	l.Range = range
	l.Shadows = true
	l.Parent = parent
	return l
end

local function label(parent, text, offset, size)
	local gui = Instance.new("BillboardGui")
	gui.Name = "DetailLabel"
	gui.Size = UDim2.fromOffset(size or 150, 38)
	gui.StudsOffset = offset or Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 90
	gui.Parent = parent
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = UDim2.fromScale(1, 1)
	t.Text = text
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.fromRGB(245, 238, 215)
	t.TextStrokeTransparency = 0.55
	t.Parent = gui
	return gui
end

local function trimWindow(parent, x, y, z, w, h, frontZ)
	local frame = part("WindowFrame", Vector3.new(w + .45, h + .45, .22), CFrame.new(x, y, frontZ), Enum.Material.Wood, parent)
	part("Glass", Vector3.new(w, h, .08), CFrame.new(x, y, frontZ - .13), Enum.Material.Glass, parent, .12)
	part("MullionV", Vector3.new(.09, h, .14), CFrame.new(x, y, frontZ - .19), Enum.Material.Wood, parent)
	part("MullionH", Vector3.new(w, .09, .14), CFrame.new(x, y, frontZ - .19), Enum.Material.Wood, parent)
	part("Sill", Vector3.new(w + .7, .16, .34), CFrame.new(x, y - h / 2 - .15, frontZ - .04), Enum.Material.Wood, parent)
	return frame
end

local function planter(parent, x, y, z)
	part("Planter", Vector3.new(1.6, .65, .7), CFrame.new(x, y, z), Enum.Material.Concrete, parent)
	for i = 1, 5 do
		local dx = (i - 3) * .22
		ball("Flower", Vector3.new(.38, .38, .38), CFrame.new(x + dx, y + .45 + (i % 2) * .1, z), Enum.Material.Grass, parent)
	end
end

local function door(parent, x, y, z, width, height, color)
	part("DoorPanel", Vector3.new(width, height, .18), CFrame.new(x, y + height / 2, z), color, parent)
	part("DoorFrameL", Vector3.new(.18, height + .3, .28), CFrame.new(x - width / 2 - .12, y + height / 2, z), Enum.Material.Wood, parent)
	part("DoorFrameR", Vector3.new(.18, height + .3, .28), CFrame.new(x + width / 2 + .12, y + height / 2, z), Enum.Material.Wood, parent)
	part("DoorTop", Vector3.new(width + .45, .18, .28), CFrame.new(x, y + height + .15, z), Enum.Material.Wood, parent)
	cyl("Handle", .07, .14, CFrame.new(x + width * .28, y + height * .48, z - .14) * CFrame.Angles(0, math.rad(90), 0), Enum.Material.Metal, parent)
end

local function facade(name, pos, width, depth, wallMat, roofMat, signText)
	local f = Instance.new("Model")
	f.Name = name
	f.Parent = ROOT
	local x, y, z = pos.X, pos.Y, pos.Z
	part("Facade", Vector3.new(width, 7, .35), CFrame.new(x, y + 3.5, z), wallMat, f)
	part("Roof", Vector3.new(width + 1.2, .6, depth + 1), CFrame.new(x, y + 7.25, z), roofMat, f)
	part("RoofCap", Vector3.new(width * .72, .42, depth + 1.2), CFrame.new(x, y + 7.75, z), roofMat, f)
	part("Cornice", Vector3.new(width + .6, .28, .5), CFrame.new(x, y + 6.9, z - .2), Enum.Material.Wood, f)
	door(f, x, y, z - .28, 1.8, 3.5, Enum.Material.Wood)
	trimWindow(f, x - width * .27, y + 3.6, z, 2.4, 2.1, z - .24)
	trimWindow(f, x + width * .27, y + 3.6, z, 2.4, 2.1, z - .24)
	planter(f, x - width * .27, y + 1.05, z - .5)
	planter(f, x + width * .27, y + 1.05, z - .5)
	local sign = part("Sign", Vector3.new(math.min(width * .52, 7), 1.0, .22), CFrame.new(x, y + 5.85, z - .42), Enum.Material.Wood, f)
	label(sign, signText, Vector3.new(0, 0, -.25), 190)
	local lamp = part("FacadeLamp", Vector3.new(.28, .28, .18), CFrame.new(x + width * .38, y + 5.25, z - .55), Enum.Material.Neon, f)
	light(lamp, Color3.fromRGB(255, 205, 125), 1.5, 14)
	return f
end

-- Additional architectural shells. They sit in front of the generated buildings and make them read as authored locations.
facade("BakeryArchitecturalFacade", Vector3.new(55, -5, -1), 14, 9, Enum.Material.Brick, Enum.Material.Slate, "BAKERY")
facade("VillageShopArchitecturalFacade", Vector3.new(90, -5, 45), 15, 9, Enum.Material.Brick, Enum.Material.Slate, "VILLAGE SHOP")
facade("OldHouseArchitecturalFacade", Vector3.new(-70, -5, -30), 13, 9, Enum.Material.WoodPlanks, Enum.Material.Wood, "OLD HOUSE")
facade("GarageArchitecturalFacade", Vector3.new(25, -5, 95), 16, 10, Enum.Material.Concrete, Enum.Material.Metal, "GARAGE")
facade("ForestCabinArchitecturalFacade", Vector3.new(-95, -5, 5), 12, 9, Enum.Material.WoodPlanks, Enum.Material.Wood, "FOREST CABIN")

-- Village square seating and civic detail.
do
	local m = Instance.new("Model")
	m.Name = "VillageSquareCivicDetail"
	m.Parent = ROOT
	for i = 1, 4 do
		local a = math.rad(i * 90)
		local x, z = 25 + math.cos(a) * 10, -45 + math.sin(a) * 10
		part("BenchSeat", Vector3.new(3.4, .28, .7), CFrame.new(x, 1.15, z) * CFrame.Angles(0, -a, 0), Enum.Material.Wood, m)
		part("BenchBack", Vector3.new(3.4, 1.15, .18), CFrame.new(x, 1.65, z + math.sin(a) * .25) * CFrame.Angles(0, -a, 0), Enum.Material.Wood, m)
	end
	for i = 1, 8 do
		local a = math.rad(i * 45)
		ball("FlowerCluster", Vector3.new(.55, .45, .55), CFrame.new(25 + math.cos(a) * 13, .5, -45 + math.sin(a) * 13), Enum.Material.Grass, m)
	end
end

-- Roadside utility / navigation props.
do
	local m = Instance.new("Model")
	m.Name = "RoadsideNavigationDetail"
	m.Parent = ROOT
	local signs = {
		{Vector3.new(-5, 2.5, 18), "VILLAGE"},
		{Vector3.new(48, 2.5, 18), "SHOP"},
		{Vector3.new(78, 2.5, 78), "DOCK"},
		{Vector3.new(-78, 2.5, 52), "FOREST"},
	}
	for _, data in ipairs(signs) do
		local p = data[1]
		part("SignPost", Vector3.new(.18, 3.8, .18), CFrame.new(p.X, 1.9, p.Z), Enum.Material.Wood, m)
		local s = part("DirectionSign", Vector3.new(2.8, .65, .18), CFrame.new(p.X, p.Y, p.Z), Enum.Material.Wood, m)
		label(s, data[2], Vector3.new(0, 0, -.2), 120)
	end
end

-- Detailed delivery/taxi props near the jobs.
do
	local m = Instance.new("Model")
	m.Name = "JobHubVisuals"
	m.Parent = ROOT
	for _, p in ipairs({Vector3.new(-20, 0, 35), Vector3.new(80, 0, 25), Vector3.new(65, 0, 25)}) do
		part("Paver", Vector3.new(5, .16, 3), CFrame.new(p.X, .08, p.Z), Enum.Material.Cobblestone, m)
	end
	local board = part("JobsBoard", Vector3.new(5, 3.2, .3), CFrame.new(-20, 2.3, 34.5), Enum.Material.Wood, m)
	label(board, "VILLAGE JOBS", Vector3.new(0, 0, -.35), 180)
	for i = 1, 3 do
		local bulb = part("JobBulb", Vector3.new(.22, .22, .22), CFrame.new(-21 + i * .8, 1.35, 34.2), Enum.Material.Neon, m)
		light(bulb, Color3.fromRGB(255, 215, 130), .7, 7)
	end
end

-- Vehicle visual bodies: these are shells intended to visually upgrade the existing spawned vehicle models.
local function vehicleShell(name, basePos, bodySize, bodyMat, accentMat, signText)
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = ROOT
	local x, y, z = basePos.X, basePos.Y, basePos.Z
	part("Chassis", bodySize, CFrame.new(x, y, z), bodyMat, m)
	part("Cabin", Vector3.new(bodySize.X * .55, bodySize.Y * .72, bodySize.Z * .82), CFrame.new(x - bodySize.X * .08, y + bodySize.Y * .66, z), Enum.Material.Glass, m, .18)
	part("Hood", Vector3.new(bodySize.X * .42, bodySize.Y * .55, bodySize.Z * .9), CFrame.new(x + bodySize.X * .28, y + bodySize.Y * .25, z), bodyMat, m)
	part("FrontBumper", Vector3.new(.35, .45, bodySize.Z + .15), CFrame.new(x + bodySize.X / 2 + .18, y, z), Enum.Material.Metal, m)
	part("RearBumper", Vector3.new(.35, .45, bodySize.Z + .15), CFrame.new(x - bodySize.X / 2 - .18, y, z), Enum.Material.Metal, m)
	for _, dz in ipairs({-bodySize.Z * .55, bodySize.Z * .55}) do
		for _, dx in ipairs({-bodySize.X * .32, bodySize.X * .32}) do
			cyl("Wheel", .58, .34, CFrame.new(x + dx, y - .55, z + dz) * CFrame.Angles(0, 0, math.rad(90)), Enum.Material.Rubber, m)
			local hub = cyl("Hub", .22, .36, CFrame.new(x + dx, y - .55, z + dz) * CFrame.Angles(0, 0, math.rad(90)), Enum.Material.Metal, m)
			hub.CanCollide = false
		end
	end
	for _, dx in ipairs({-bodySize.X * .34, bodySize.X * .34}) do
		local lamp = part("Headlight", Vector3.new(.18, .32, .72), CFrame.new(x + bodySize.X / 2 + .22, y + .08, z + dx), Enum.Material.Neon, m)
		light(lamp, Color3.fromRGB(255, 244, 210), 1.3, 12)
	end
	local badge = part("VehicleBadge", Vector3.new(1.9, .55, .12), CFrame.new(x, y + .78, z - bodySize.Z / 2 - .08), accentMat, m)
	label(badge, signText, Vector3.new(0, 0, -.18), 115)
	return m
end

vehicleShell("ShowcaseVillageCar", Vector3.new(0, 1.6, 155), Vector3.new(6.8, 1.2, 3.5), Enum.Material.SmoothPlastic, Enum.Material.Metal, "VILLAGE")
vehicleShell("ShowcaseTaxi", Vector3.new(10, 1.6, 155), Vector3.new(7.1, 1.2, 3.5), Enum.Material.SmoothPlastic, Enum.Material.Metal, "TAXI")
vehicleShell("ShowcaseDeliveryVan", Vector3.new(21, 1.8, 155), Vector3.new(7.8, 1.8, 3.6), Enum.Material.Metal, Enum.Material.Wood, "DELIVERY")

-- Parking bays for the vehicle showcase.
do
	local m = Instance.new("Model")
	m.Name = "VehicleDisplayLot"
	m.Parent = ROOT
	part("Lot", Vector3.new(34, .18, 11), CFrame.new(10.5, .08, 155), Enum.Material.Asphalt, m)
	for i = 0, 2 do
		part("ParkingLine", Vector3.new(.12, .03, 8.5), CFrame.new(-4 + i * 11.5, .18, 155), Enum.Material.SmoothPlastic, m)
	end
	local sign = part("LotSign", Vector3.new(8, 1.1, .2), CFrame.new(10, 2.7, 149.3), Enum.Material.Wood, m)
	label(sign, "VILLAGE VEHICLES", Vector3.new(0, 0, -.3), 190)
end

-- Small premium-feeling environmental details.
do
	local m = Instance.new("Model")
	m.Name = "StreetMicroDetails"
	m.Parent = ROOT
	for i = 1, 24 do
		local x = math.random(-125, 125)
		local z = math.random(-115, 125)
		if math.abs(x) > 18 or math.abs(z) > 18 then
			part("Stone", Vector3.new(math.random(3, 8) / 10, math.random(2, 5) / 10, math.random(3, 8) / 10), CFrame.new(x, .25, z) * CFrame.Angles(math.random(), math.random(), math.random()), Enum.Material.Slate, m)
		end
	end
end

print("[SecretVillage] Architecture + vehicle visual pass loaded")
