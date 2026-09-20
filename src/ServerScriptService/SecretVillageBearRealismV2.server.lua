-- SECRET VILLAGE BEAR REALISM v2
-- Full visual pass for every bear model. Keeps existing AI, combat and movement.

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local world = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not world then return end
local bears = world:WaitForChild("DANGEROUS_BEAR_ZONE", 30)
if not bears then return end

local function createPart(parent, name, size, cf, color, material, shape, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.Transparency = transparency or 0
	p.Anchored = false
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.Massless = true
	p.CastShadow = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent
	return p
end

local function weld(root, item)
	local joint = Instance.new("WeldConstraint")
	joint.Part0 = root
	joint.Part1 = item
	joint.Parent = root
end

local function decorateBear(bear)
	if not bear:IsA("Model") or bear:FindFirstChild("BEAR_REALISM_V2") then return end
	local root = bear.PrimaryPart or bear:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local index = bear:GetAttribute("BearIndex") or 1
	local fur, furLight, belly, paw
	if index % 3 == 2 then
		fur = Color3.fromRGB(34, 28, 24)
		furLight = Color3.fromRGB(70, 57, 48)
		belly = Color3.fromRGB(92, 73, 58)
		paw = Color3.fromRGB(19, 15, 13)
	elseif index % 3 == 0 then
		fur = Color3.fromRGB(105, 78, 48)
		furLight = Color3.fromRGB(151, 113, 70)
		belly = Color3.fromRGB(177, 137, 88)
		paw = Color3.fromRGB(54, 36, 25)
	else
		fur = Color3.fromRGB(73, 49, 32)
		furLight = Color3.fromRGB(119, 82, 49)
		belly = Color3.fromRGB(148, 104, 65)
		paw = Color3.fromRGB(42, 28, 21)
	end
	local dark = Color3.fromRGB(15, 11, 9)
	local eye = Color3.fromRGB(7, 5, 4)
	local claw = Color3.fromRGB(205, 181, 139)

	local marker = Instance.new("BoolValue")
	marker.Name = "BEAR_REALISM_V2"
	marker.Parent = bear

	for _, item in ipairs(bear:GetChildren()) do
		if item:IsA("BasePart") and item ~= root then
			item.Color = fur
			item.Material = Enum.Material.SmoothPlastic
			item.CastShadow = true
		end
	end

	local function add(name, size, offset, color, shape, transparency)
		local item = createPart(bear, name, size, root.CFrame * CFrame.new(offset), color, Enum.Material.SmoothPlastic, shape, transparency)
		weld(root, item)
		return item
	end

	-- Natural layered body silhouette: shoulders, belly, rump and neck.
	add("RealismShoulders", Vector3.new(4.9, 3.8, 3.9), Vector3.new(0, 0.7, -0.85), furLight, Enum.PartType.Ball)
	add("RealismBelly", Vector3.new(4.5, 3.3, 3.7), Vector3.new(0, 0.15, 0.15), belly, Enum.PartType.Ball)
	add("RealismRump", Vector3.new(4.8, 3.9, 4.0), Vector3.new(0, 0.5, 1.15), fur, Enum.PartType.Ball)
	add("RealismNeckMane", Vector3.new(3.7, 3.9, 3.5), Vector3.new(0, 1.15, -1.45), furLight, Enum.PartType.Ball)
	add("RealismChest", Vector3.new(2.35, 2.7, 0.65), Vector3.new(0, 0.45, -2.1), belly, Enum.PartType.Ball)

	-- Rounded ears with darker inner surfaces.
	for _, side in ipairs({-1, 1}) do
		add("RealismEarOuter", Vector3.new(1.05, 1.05, 0.75), Vector3.new(side * 1.12, 2.9, -3.0), furLight, Enum.PartType.Ball)
		add("RealismEarInner", Vector3.new(0.52, 0.55, 0.2), Vector3.new(side * 1.12, 2.9, -3.37), Color3.fromRGB(58, 31, 25), Enum.PartType.Ball)
	end

	-- Face structure, eyes, eyelids, muzzle and wet nose.
	add("RealismFace", Vector3.new(2.55, 2.35, 2.15), Vector3.new(0, 1.7, -3.05), furLight, Enum.PartType.Ball)
	add("RealismMuzzle", Vector3.new(1.9, 1.35, 1.45), Vector3.new(0, 1.0, -4.15), Color3.fromRGB(92, 67, 48), Enum.PartType.Ball)
	add("RealismNose", Vector3.new(0.7, 0.5, 0.42), Vector3.new(0, 1.08, -4.82), dark, Enum.PartType.Ball)
	add("RealismNoseShine", Vector3.new(0.16, 0.1, 0.08), Vector3.new(-0.13, 1.22, -5.02), Color3.fromRGB(166, 143, 117), Enum.PartType.Ball)
	for _, side in ipairs({-1, 1}) do
		add("RealismEyeSocket", Vector3.new(0.5, 0.4, 0.2), Vector3.new(side * 0.58, 1.95, -4.0), dark, Enum.PartType.Ball)
		add("RealismEye", Vector3.new(0.22, 0.22, 0.14), Vector3.new(side * 0.58, 1.97, -4.16), eye, Enum.PartType.Ball)
		add("RealismEyeGlint", Vector3.new(0.065, 0.065, 0.035), Vector3.new(side * 0.51, 2.04, -4.24), Color3.fromRGB(255, 240, 210), Enum.PartType.Ball)
	end

	-- Slightly open mouth: dark oral cavity and two subtle teeth.
	add("RealismMouth", Vector3.new(1.05, 0.32, 0.28), Vector3.new(0, 0.65, -4.78), dark, Enum.PartType.Ball)
	add("RealismToothLeft", Vector3.new(0.13, 0.23, 0.1), Vector3.new(-0.28, 0.72, -4.9), claw, Enum.PartType.Ball)
	add("RealismToothRight", Vector3.new(0.13, 0.23, 0.1), Vector3.new(0.28, 0.72, -4.9), claw, Enum.PartType.Ball)

	-- Four paws, darker pads and visible claws.
	for _, side in ipairs({-1, 1}) do
		for _, z in ipairs({-1.1, 1.0}) do
			add("RealismPaw", Vector3.new(1.55, 0.58, 1.65), Vector3.new(side * 1.68, -1.25, z), paw, Enum.PartType.Ball)
			add("RealismPad", Vector3.new(0.8, 0.18, 0.65), Vector3.new(side * 1.68, -1.52, z - 0.12), dark, Enum.PartType.Ball)
			for c = 1, 3 do
				add("RealismClaw", Vector3.new(0.13, 0.13, 0.38), Vector3.new(side * (1.43 + c * 0.22), -1.54, z - 0.63), claw, Enum.PartType.Ball)
			end
		end
	end

	-- Individual fur tufts break the smooth primitive look.
	for i = 1, 7 do
		local z = -1.7 + i * 0.58
		local side = (i % 2 == 0) and 1 or -1
		add("RealismFurTuft", Vector3.new(0.85, 1.45, 0.8), Vector3.new(side * 1.65, 1.25, z), furLight, Enum.PartType.Ball)
	end
	for i = 1, 5 do
		local z = -0.9 + i * 0.55
		add("RealismBackTuft", Vector3.new(1.1, 1.2, 0.75), Vector3.new(0, 1.95, z), furLight, Enum.PartType.Ball)
	end
end

for _, bear in ipairs(bears:GetChildren()) do
	decorateBear(bear)
end

bears.ChildAdded:Connect(function(bear)
	task.wait(0.2)
	decorateBear(bear)
end)

-- Small idle breathing and head movement, independent from AI movement.
local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
	elapsed += dt
	for _, bear in ipairs(bears:GetChildren()) do
		local root = bear.PrimaryPart
		if root and bear:FindFirstChild("BEAR_REALISM_V2") then
			local phase = (bear:GetAttribute("BearIndex") or 1) * 0.75
			local breathing = math.sin(elapsed * 1.8 + phase) * 0.035
			local shoulders = bear:FindFirstChild("RealismShoulders")
			if shoulders then
				shoulders.Size = Vector3.new(4.9 + breathing, 3.8 + breathing, 3.9 + breathing)
			end
		end
	end
end)

print("SECRET VILLAGE BEAR REALISM v2 READY: all bears decorated")
