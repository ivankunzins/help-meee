-- SECRET VILLAGE BEAR BOUNDARY v1
-- Bears protect the forest perimeter. They chase an intruder only until
-- the player leaves the forest zone, then return to their spawn position.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local world = Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER", 30)
if not world then
	warn("BEAR BOUNDARY: authoritative world not found")
	return
end

local bearsFolder = world:WaitForChild("DANGEROUS_BEAR_ZONE", 30)
if not bearsFolder then
	warn("BEAR BOUNDARY: bear folder not found")
	return
end

if world:FindFirstChild("BEAR_BOUNDARY_CONTROLLER_V1") then
	return
end

local marker = Instance.new("BoolValue")
marker.Name = "BEAR_BOUNDARY_CONTROLLER_V1"
marker.Value = true
marker.Parent = world

local FOREST_INNER_RADIUS = 150
local FOREST_OUTER_RADIUS = 235
local RETURN_RADIUS = 142
local CONTROL_INTERVAL = 0.08
local HOME_REACH_DISTANCE = 7

local homes = {}
local elapsed = 0

local function getCenterPosition()
	return Vector3.new(0, 0, 0)
end

local function getFlatRadius(position)
	local center = getCenterPosition()
	return (Vector3.new(position.X, 0, position.Z) - center).Magnitude
end

local function getPlayerRoot(player)
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if humanoid and root and humanoid.Health > 0 then
		return root
	end
	return nil
end

local function nearestForestIntruder(bearRoot)
	local nearestRoot = nil
	local nearestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local root = getPlayerRoot(player)
		if root then
			local radius = getFlatRadius(root.Position)
			if radius >= FOREST_INNER_RADIUS and radius <= FOREST_OUTER_RADIUS then
				local distance = (root.Position - bearRoot.Position).Magnitude
				if distance < nearestDistance then
					nearestDistance = distance
					nearestRoot = root
				end
			end
		end
	end

	return nearestRoot
end

local function setupHome(bear)
	if homes[bear] then
		return homes[bear]
	end

	local root = bear.PrimaryPart or bear:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end

	homes[bear] = root.Position
	return homes[bear]
end

local function controlBear(bear)
	if not bear:IsA("Model") then
		return
	end

	local humanoid = bear:FindFirstChildOfClass("Humanoid")
	local root = bear.PrimaryPart or bear:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root or humanoid.Health <= 0 then
		return
	end

	local home = setupHome(bear)
	if not home then
		return
	end

	local intruder = nearestForestIntruder(root)
	if intruder then
		-- Pursue only while the player is inside the forest perimeter.
		humanoid:MoveTo(intruder.Position)
	else
		-- No intruder in the forest: stop pursuing and return to spawn.
		local distanceHome = (root.Position - home).Magnitude
		if distanceHome > HOME_REACH_DISTANCE then
			humanoid:MoveTo(home)
		else
			humanoid:MoveTo(root.Position)
		end
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

print("SECRET VILLAGE BEAR BOUNDARY v1 READY: chase stops outside forest and bears return home")
