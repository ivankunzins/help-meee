-- SECRET VILLAGE BEAR REALISM v1
-- Visual layer for existing bears. Does not replace AI or movement.

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local world = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not world then return end
local bears = world:WaitForChild("DANGEROUS_BEAR_ZONE", 30)
if not bears then return end

local function part(parent, name, size, cf, color, material, shape)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Anchored = false
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent
	return p
end

local function weld(root, p)
	local w = Instance.new("WeldConstraint")
	w.Part0 = root
	w.Part1 = p
	w.Parent = root
end

local function decorateBear(bear)
	if not bear:IsA("Model") or bear:FindFirstChild("BEAR_REALISM_V1") then return end
	local root = bear.PrimaryPart or bear:FindFirstChild("HumanoidRootPart")
	local head = bear:FindFirstChild("Head")
	local muzzle = bear:FindFirstChild("Muzzle")
	if not root or not head or not muzzle then return end

	local marker = Instance.new("BoolValue")
	marker.Name = "BEAR_REALISM_V1"
	marker.Parent = bear

	local fur = Color3.fromRGB(72, 49, 32)
	local furLight = Color3.fromRGB(112, 78, 49)
	local dark = Color3.fromRGB(24, 17, 13)
	local paw = Color3.fromRGB(43, 28, 21)

	for _, d in ipairs(bear:GetChildren()) do
		if d:IsA("BasePart") and d ~= root then
			d.Color = fur
			d.Material = Enum.Material.SmoothPlastic
		end
	end

	local function add(name, size, offset, color, shape)
		local p = part(bear, name, size, root.CFrame * CFrame.new(offset), color, Enum.Material.SmoothPlastic, shape)
		weld(root, p)
		return p
	end

	-- Layered shoulder and belly volumes create a fuller, less toy-like silhouette.
	add("FurShoulder", Vector3.new(4.7, 3.6, 3.7), Vector3.new(0, 0.65, -0.9), furLight, Enum.PartType.Ball)
	add("FurRump", Vector3.new(4.6, 3.7, 3.8), Vector3.new(0, 0.45, 1.0), fur, Enum.PartType.Ball)
	add("ChestPatch", Vector3.new(2.25, 2.5, 0.55), Vector3.new(0, 0.45, -2.05), Color3.fromRGB(133, 96, 62), Enum.PartType.Ball)

	-- Small ears with inner ear shading.
	for _, side in ipairs({-1, 1}) do
		add("EarInner", Vector3.new(0.42, 0.48, 0.18), Vector3.new(side * 1.15, 2.95, -3.12), Color3.fromRGB(54, 30, 25), Enum.PartType.Ball)
		add("ClawPaw", Vector3.new(1.35, 0.5, 1.5), Vector3.new(side * 1.7, -1.35, -1.15), paw, Enum.PartType.Ball)
		add("ClawPawRear", Vector3.new(1.45, 0.5, 1.55), Vector3.new(side * 1.65, -1.4, 1.0), paw, Enum.PartType.Ball)
		for claw = 1, 3 do
			add("Claw", Vector3.new(0.12, 0.12, 0.32), Vector3.new(side * (1.42 + claw * 0.22), -1.48, -1.78), Color3.fromRGB(210, 191, 157), Enum.PartType.Ball)
		end
	end

	-- Expressive eyes and a wet-looking nose.
	for _, side in ipairs({-1, 1}) do
		add("Eye", Vector3.new(0.23, 0.23, 0.16), Vector3.new(side * 0.56, 1.95, -4.23), Color3.fromRGB(8, 6, 4), Enum.PartType.Ball)
		add("EyeHighlight", Vector3.new(0.06, 0.06, 0.04), Vector3.new(side * 0.51, 2.02, -4.31), Color3.fromRGB(245, 235, 205), Enum.PartType.Ball)
	end
	add("NoseHighlight", Vector3.new(0.12, 0.1, 0.08), Vector3.new(0, 1.0, -5.08), Color3.fromRGB(120, 96, 76), Enum.PartType.Ball)

	-- Fur tufts along the neck and back, using small overlapping volumes.
	for i = 1, 5 do
		local z = -1.45 + i * 0.7
		add("FurTuft", Vector3.new(1.1, 1.4, 0.9), Vector3.new(0, 1.65, z), furLight, Enum.PartType.Ball)
	end
end

for _, bear in ipairs(bears:GetChildren()) do decorateBear(bear) end
bears.ChildAdded:Connect(function(bear)
	task.wait(0.15)
	decorateBear(bear)
end)

-- Gentle breathing motion makes bears feel alive without affecting physics.
local t = 0
RunService.Heartbeat:Connect(function(dt)
	t += dt
	for _, bear in ipairs(bears:GetChildren()) do
		local root = bear.PrimaryPart
		if root and bear:FindFirstChild("BEAR_REALISM_V1") then
			local phase = (bear:GetAttribute("BearIndex") or 1) * 0.8
			local pulse = math.sin(t * 2.1 + phase) * 0.025
			local body = bear:FindFirstChild("Body")
			if body then body.Size = Vector3.new(6 + pulse, 4.8 + pulse, 4.2 + pulse) end
		end
	end
end)

print("SECRET VILLAGE BEAR REALISM v1 READY")
