-- SECRET VILLAGE BEAR VILLAGE GUARD v2
-- Bears may protect the forest, but they must never enter the village.
-- This controller replaces the older boundary controller and hard-resets
-- a bear to its home position if it crosses the village safety perimeter.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local world = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not world then
	warn("BEAR VILLAGE GUARD: authoritative world not found")
	return
end

local bearsFolder = world:WaitForChild("DANGEROUS_BEAR_ZONE", 30)
if not bearsFolder then
	warn("BEAR VILLAGE GUARD: bear folder not found")
	return
end

if world:FindFirstChild("BEAR_VILLAGE_GUARD_V2") then
	return
end

local marker = Instance.new("BoolValue")
marker.Name = "BEAR_VILLAGE_GUARD_V2"
marker.Value = true
marker.Parent = world

local VILLAGE_SAFE_RADIUS = 145
local FOREST_START_RADIUS = 155
local FOREST_END_RADIUS = 235
local CONTROL_INTERVAL = 0.12
local HOME_REACH_DISTANCE = 6

local homes = {}
local elapsed = 0

local function flatRadius(position)
	return Vector3.new(position.X, 0, position.Z).Magnitude
end

local function getRoot(model)
	return model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
end

local function getAliveRoot(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if humanoid and root and humanoid.Health > 0 then
		return root
	end
	return nil
end

local function findForestPlayer(bearRoot)
	local nearest = nil
	local nearestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local root = getAliveRoot(player)
		if root then
			local radius = flatRadius(root.Position)
			if radius >= FOREST_START_RADIUS and radius <= FOREST_END_RADIUS then
				local distance = (root.Position - bearRoot.Position).Magnitude
				if distance < nearestDistance then
					nearest = root
					nearestDistance = distance
				end
			end
		end
	end

	return nearest
end

local function getHome(bear, root)
	if not homes[bear] then
		homes[bear] = root.CFrame
	end
	return homes[bear]
end

local function returnHome(bear, root, humanoid, home)
	-- Always teleport back as soon as the bear enters the village safety zone.
	-- This prevents momentum and competing MoveTo calls from carrying it in.
	bear:PivotTo(home)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero

	if (root.Position - home.Position).Magnitude > HOME_REACH_DISTANCE then
		humanoid:MoveTo(home.Position)
	else
		humanoid:MoveTo(root.Position)
	end
end

local function controlBear(bear)
	if not bear:IsA("Model") then
		return
	end

	local humanoid = bear:FindFirstChildOfClass("Humanoid")
	local root = getRoot(bear)
	if not humanoid or not root or humanoid.Health <= 0 then
		return
	end

	local home = getHome(bear, root)
	local radius = flatRadius(root.Position)

	-- Absolute village exclusion: never allow a bear inside the village.
	if radius < VILLAGE_SAFE_RADIUS then
		returnHome(bear, root, humanoid, home)
		return
	end

	local intruder = findForestPlayer(root)
	if intruder then
		-- The target is guaranteed to be in the forest, never in the village.
		humanoid:MoveTo(intruder.Position)
	else
		returnHome(bear, root, humanoid, home)
	end
end

RunService.Heartbeat:Connect(function(deltaTime)
	elapsed += deltaTime
	if elapsed < CONTROL_INTERVAL then
		return
	end
	elapsed = 0

	for bear in pairs(homes) do
		if not bear.Parent then
			homes[bear] = nil
		end
	end

	for _, bear in ipairs(bearsFolder:GetChildren()) do
		controlBear(bear)
	end
end)

print("SECRET VILLAGE BEAR VILLAGE GUARD v2 READY: bears cannot enter the village")
