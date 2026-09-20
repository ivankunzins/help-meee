-- SECRET VILLAGE FINAL WORLD MASTER v3
-- World generation plus rebuilt, movable, server-controlled bears.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

if Workspace:FindFirstChild("SECRET_VILLAGE_FINAL_MASTER") then
	return
end

local ROOT = Instance.new("Folder")
ROOT.Name = "SECRET_VILLAGE_FINAL_MASTER"
ROOT.Parent = Workspace

local function mkPart(parent, name, size, pos, material, transparency, canCollide)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.Anchored = true
	p.Material = material or Enum.Material.Grass
	p.Transparency = transparency or 0
	p.CanCollide = canCollide ~= false
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function sphere(parent, name, size, pos, material)
	local p = mkPart(parent, name, size, pos, material)
	p.Shape = Enum.PartType.Ball
	return p
end

local function cyl(parent, name, size, pos, material)
	local p = mkPart(parent, name, size, pos, material)
	p.Shape = Enum.PartType.Cylinder
	return p
end

local function isRoadName(name)
	local n = name:lower()
	return n:find("road", 1, true)
		or n:find("street", 1, true)
		or n:find("asphalt", 1, true)
		or n:find("crossroad", 1, true)
end

for _, d in ipairs(Workspace:GetDescendants()) do
	if d:IsA("BasePart") then
		if isRoadName(d.Name) or d.Material == Enum.Material.Asphalt then
			d.Transparency = 1
			d.CanCollide = false
		elseif d.Size.X > 55 and d.Size.Z > 55 and d.Position.Y < 1
			and d.Name ~= "River" and not d:IsDescendantOf(ROOT) then
			d.Material = Enum.Material.Grass
		end
	end
end

mkPart(
	ROOT,
	"Meadow",
	Vector3.new(430, 1, 430),
	Vector3.new(0, -0.65, 0),
	Enum.Material.Grass,
	0,
	false
)

local forest = Instance.new("Folder")
forest.Name = "FOREST_PERIMETER"
forest.Parent = ROOT

local rng = Random.new(72419)

local function makeTree(x, z, scale)
	local model = Instance.new("Model")
	model.Name = "Pine"
	model.Parent = forest

	local trunk = cyl(
		model,
		"Trunk",
		Vector3.new(1.7 * scale, 9 * scale, 1.7 * scale),
		Vector3.new(x, 4.5 * scale, z),
		Enum.Material.Wood
	)
	trunk.CFrame = trunk.CFrame * CFrame.Angles(0, 0, math.rad(90))

	for i = 1, 4 do
		local y = (3.8 + i * 2.2) * scale
		local radius = (6.4 - i * 0.9) * scale
		local foliage = sphere(
			model,
			"Foliage",
			Vector3.new(radius * 2, 3.8 * scale, radius * 2),
			Vector3.new(x, y, z),
			Enum.Material.Grass
		)
		foliage.CanCollide = false
	end

	return model
end

for _ = 1, 150 do
	local angle = rng:NextNumber(0, math.pi * 2)
	local radius = rng:NextNumber(190, 225)
	makeTree(math.cos(angle) * radius, math.sin(angle) * radius, rng:NextNumber(0.8, 1.45))
end

for _ = 1, 55 do
	local angle = rng:NextNumber(0, math.pi * 2)
	local radius = rng:NextNumber(165, 188)
	makeTree(math.cos(angle) * radius, math.sin(angle) * radius, rng:NextNumber(0.65, 1.15))
end

local ground = Instance.new("Folder")
ground.Name = "FOREST_FLOOR"
ground.Parent = ROOT

for _ = 1, 90 do
	local angle = rng:NextNumber(0, math.pi * 2)
	local radius = rng:NextNumber(160, 220)
	local scale = rng:NextNumber(0.6, 2.2)
	local moss = sphere(
		ground,
		"Moss",
		Vector3.new(2.5 * scale, 0.7, 2.5 * scale),
		Vector3.new(math.cos(angle) * radius, 0.35, math.sin(angle) * radius),
		Enum.Material.Grass
	)
	moss.CanCollide = false
end

local bears = Instance.new("Folder")
bears.Name = "DANGEROUS_BEAR_ZONE"
bears.Parent = ROOT

local BEAR_MAX_HEALTH = 180
local BEAR_WALK_SPEED = 11
local BEAR_DETECTION_DISTANCE = 58
local BEAR_ATTACK_DISTANCE = 6.5
local BEAR_ATTACK_DAMAGE = 28
local BEAR_ATTACK_COOLDOWN = 1.25
local BEAR_RESPAWN_SECONDS = 25

local function weldToRoot(root, part)
	part.Anchored = false
	part.CanCollide = false
	part.Massless = true

	local weld = Instance.new("WeldConstraint")
	weld.Name = "BearWeld"
	weld.Part0 = root
	weld.Part1 = part
	weld.Parent = root
end

local function makeBear(index, x, z)
	local model = Instance.new("Model")
	model.Name = "Bear_" .. index
	model:SetAttribute("Dangerous", true)
	model:SetAttribute("BearIndex", index)
	model.Parent = bears

	local root = mkPart(
		model,
		"HumanoidRootPart",
		Vector3.new(2.2, 2.5, 2.2),
		Vector3.new(x, 3, z),
		Enum.Material.SmoothPlastic,
		1,
		false
	)
	root.Anchored = false
	root.CanCollide = false
	root.Massless = false
	root.Transparency = 1
	model.PrimaryPart = root

	local humanoid = Instance.new("Humanoid")
	humanoid.Name = "Humanoid"
	humanoid.MaxHealth = BEAR_MAX_HEALTH
	humanoid.Health = BEAR_MAX_HEALTH
	humanoid.WalkSpeed = BEAR_WALK_SPEED
	humanoid.DisplayName = ""
	humanoid.AutoRotate = true
	humanoid.BreakJointsOnDeath = false
	humanoid.Parent = model

	local body = sphere(model, "Body", Vector3.new(6, 4.8, 4.2), Vector3.new(x, 3.5, z), Enum.Material.SmoothPlastic)
	local neck = sphere(model, "Neck", Vector3.new(3.2, 3.2, 3), Vector3.new(x, 4.4, z - 1.6), Enum.Material.SmoothPlastic)
	local head = sphere(model, "Head", Vector3.new(3.1, 3, 3.1), Vector3.new(x, 5.2, z - 3), Enum.Material.SmoothPlastic)

	for _, side in ipairs({ -1, 1 }) do
		sphere(model, "Ear", Vector3.new(0.9, 0.9, 0.7), Vector3.new(x + side * 1.15, 6.45, z - 3.1), Enum.Material.SmoothPlastic)
		sphere(model, "Leg", Vector3.new(1.45, 2.7, 1.45), Vector3.new(x + side * 1.7, 1.65, z - 0.65), Enum.Material.SmoothPlastic)
		sphere(model, "RearLeg", Vector3.new(1.55, 2.6, 1.55), Vector3.new(x + side * 1.65, 1.6, z + 1.05), Enum.Material.SmoothPlastic)
	end

	sphere(model, "Muzzle", Vector3.new(1.65, 1.2, 1.25), Vector3.new(x, 4.8, z - 4.25), Enum.Material.SmoothPlastic)
	sphere(model, "Nose", Vector3.new(0.55, 0.45, 0.35), Vector3.new(x, 4.8, z - 4.95), Enum.Material.SmoothPlastic)
	sphere(model, "Tail", Vector3.new(1.2, 1.2, 1.2), Vector3.new(x, 4, z + 2.3), Enum.Material.SmoothPlastic)

	for _, part in ipairs(model:GetChildren()) do
		if part:IsA("BasePart") and part ~= root then
			weldToRoot(root, part)
		end
	end

	pcall(function()
		root:SetNetworkOwner(nil)
	end)

	local diedConnection
	diedConnection = humanoid.Died:Connect(function()
		if diedConnection then
			diedConnection:Disconnect()
			diedConnection = nil
		end

		task.delay(BEAR_RESPAWN_SECONDS, function()
			if model.Parent then
				model:Destroy()
			end
			if ROOT.Parent then
				makeBear(index, x, z)
			end
		end)
	end)

	return model
end

local bearPositions = {
	{ -175, -175 },
	{ 175, -145 },
	{ -195, 80 },
	{ 190, 105 },
	{ -120, 190 },
	{ 105, 190 },
}

for index, position in ipairs(bearPositions) do
	makeBear(index, position[1], position[2])
end

local lastAttack = {}

local function getNearestTarget(root)
	local nearestPlayer = nil
	local nearestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
		local playerHumanoid = character and character:FindFirstChildOfClass("Humanoid")

		if playerRoot and playerHumanoid and playerHumanoid.Health > 0 then
			local distance = (playerRoot.Position - root.Position).Magnitude
			if distance < nearestDistance and distance <= BEAR_DETECTION_DISTANCE then
				nearestPlayer = player
				nearestDistance = distance
			end
		end
	end

	return nearestPlayer, nearestDistance
end

task.spawn(function()
	while ROOT.Parent do
		for _, bear in ipairs(bears:GetChildren()) do
			if bear:IsA("Model") then
				local humanoid = bear:FindFirstChildOfClass("Humanoid")
				local root = bear.PrimaryPart or bear:FindFirstChild("HumanoidRootPart")

				if humanoid and root and root:IsA("BasePart") and humanoid.Health > 0 then
					local target, distance = getNearestTarget(root)

					if target then
						local character = target.Character
						local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
						local playerHumanoid = character and character:FindFirstChildOfClass("Humanoid")

						if playerRoot and playerHumanoid and playerHumanoid.Health > 0 then
							humanoid:MoveTo(playerRoot.Position)

							if distance <= BEAR_ATTACK_DISTANCE then
								local now = os.clock()
								local previousAttack = lastAttack[bear] or 0

								if now - previousAttack >= BEAR_ATTACK_COOLDOWN then
									lastAttack[bear] = now
									playerHumanoid:TakeDamage(BEAR_ATTACK_DAMAGE)
								end
							end
						end
					end
				end
			end
		end

		task.wait(0.35)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	for bear, _ in pairs(lastAttack) do
		if not bear.Parent then
			lastAttack[bear] = nil
		end
	end
end)

local function inWater(position)
	return position.X > -120
		and position.X < 125
		and position.Z > 38
		and position.Z < 80
		and position.Y < 4
		and position.Y > -18
end

RunService.Heartbeat:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if root and humanoid and humanoid.Health > 0 and inWater(root.Position) then
			local backpack = player:FindFirstChildOfClass("Backpack")
			local diving = character:FindFirstChild("Diving") or (backpack and backpack:FindFirstChild("Diving"))

			if not diving and root.Position.Y < 0.35 then
				local position = root.Position
				local rotation = root.CFrame - root.CFrame.Position
				root.CFrame = CFrame.new(position.X, 0.75, position.Z) * rotation

				local velocity = root.AssemblyLinearVelocity
				root.AssemblyLinearVelocity = Vector3.new(velocity.X, math.max(0, velocity.Y), velocity.Z)
			end
		end
	end
end)

for _, d in ipairs(Workspace:GetDescendants()) do
	if d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
		local name = d.Name:lower()
		local parent = d.Parent
		local keep = name:find("secret", 1, true) or name:find("quest", 1, true)

		if not keep and parent and parent.Name ~= "DiveSign" then
			d:Destroy()
		end
	end
end

local function cleanGui(container)
	for _, d in ipairs(container:GetDescendants()) do
		if d:IsA("TextButton") or d:IsA("TextLabel") then
			local text = (d.Text or ""):lower()
			local name = d.Name:lower()

			if text:find("start", 1, true)
				or text:find("начать", 1, true)
				or name:find("start", 1, true)
				or name:find("play", 1, true) then
				d:Destroy()
			end
		end
	end
end

cleanGui(game:GetService("StarterGui"))

Lighting.ClockTime = 15.2
Lighting.Brightness = 2.05
Lighting.GlobalShadows = true

local atmosphere = Lighting:FindFirstChild("SecretVillage_FinalAtmosphere")
if atmosphere then
	atmosphere.Density = 0.27
	atmosphere.Haze = 0.9
	atmosphere.Glare = 0.07
end

print("SECRET VILLAGE MASTER v3 READY: movable welded bears + AI + respawn + water protection")