-- SECRET VILLAGE FOREST BLASTER v3
-- A fictional in-game blaster pickup near the forest edge.
-- Server validates shots and damages only dangerous bears.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local TOOL_NAME = "Forest Blaster"
local PICKUP_POSITION = Vector3.new(0, 2.2, 146)
local RANGE = 180
local DAMAGE = 60
local COOLDOWN = 0.65

local remotes = ReplicatedStorage:FindFirstChild("SecretVillageWeaponRemotes")
if not remotes then
	remotes = Instance.new("Folder")
	remotes.Name = "SecretVillageWeaponRemotes"
	remotes.Parent = ReplicatedStorage
end

local fireRemote = remotes:FindFirstChild("ForestBlasterFire")
if not fireRemote then
	fireRemote = Instance.new("RemoteEvent")
	fireRemote.Name = "ForestBlasterFire"
	fireRemote.Parent = remotes
end

local function createPart(parent, name, size, color, material, cf)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Color = color
	p.Material = material
	p.CFrame = cf
	p.Anchored = false
	p.CanCollide = false
	p.Massless = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function createBlaster()
	local tool = Instance.new("Tool")
	tool.Name = TOOL_NAME
	tool.ToolTip = "Защита от медведей · ЛКМ / тап"
	tool.RequiresHandle = true
	tool.CanBeDropped = true
	tool.Grip = CFrame.new(0, -0.15, -0.7) * CFrame.Angles(0, math.rad(180), 0)

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.45, 0.45, 1.5)
	handle.Color = Color3.fromRGB(35, 42, 55)
	handle.Material = Enum.Material.Metal
	handle.CFrame = CFrame.new(PICKUP_POSITION)
	handle.CanCollide = true
	handle.Anchored = true
	handle.Parent = tool

	local barrel = createPart(tool, "Barrel", Vector3.new(0.22, 0.22, 1.25), Color3.fromRGB(95, 170, 255), Enum.Material.Neon, handle.CFrame * CFrame.new(0, 0, -1.25))
	local grip = createPart(tool, "Grip", Vector3.new(0.3, 0.65, 0.38), Color3.fromRGB(25, 28, 35), Enum.Material.Metal, handle.CFrame * CFrame.new(0, -0.42, 0.15))
	local core = createPart(tool, "EnergyCore", Vector3.new(0.5, 0.5, 0.5), Color3.fromRGB(80, 220, 255), Enum.Material.Neon, handle.CFrame * CFrame.new(0, 0, -0.25))

	for _, part in ipairs({barrel, grip, core}) do
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = handle
		weld.Part1 = part
		weld.Parent = handle
	end

	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(70, 190, 255)
	light.Brightness = 1.5
	light.Range = 8
	light.Parent = core

	local templateFolder = ReplicatedStorage:FindFirstChild("SecretVillageWeaponTemplates")
	local template = templateFolder and templateFolder:FindFirstChild("ForestBlasterClient")
	if template and template:IsA("LocalScript") then
		template:Clone().Parent = tool
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Взять"
	prompt.ObjectText = "Forest Blaster"
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 10
	prompt.Parent = handle
	prompt.Triggered:Connect(function(player)
		if tool.Parent == Workspace then
			local backpack = player:FindFirstChildOfClass("Backpack")
			if backpack then
				prompt.Enabled = false
				handle.Anchored = false
				tool.Parent = backpack
			end
		end
	end)

	return tool
end

local function ensurePickup()
	if Workspace:FindFirstChild(TOOL_NAME) then
		return
	end
	local tool = createBlaster()
	tool.Parent = Workspace
	local handle = tool:FindFirstChild("Handle")
	if handle then
		handle.CFrame = CFrame.new(PICKUP_POSITION)
	end
end

ensurePickup()

local lastShot = {}

fireRemote.OnServerEvent:Connect(function(player, origin, direction)
	if typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then
		return
	end
	if direction.Magnitude < 0.9 or direction.Magnitude > 1.1 then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local tool = character and character:FindFirstChild(TOOL_NAME)
	if not root or not humanoid or humanoid.Health <= 0 or not tool then
		return
	end
	if (origin - root.Position).Magnitude > 12 then
		return
	end

	local now = os.clock()
	if now - (lastShot[player] or 0) < COOLDOWN then
		return
	end
	lastShot[player] = now

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {character, tool}
	params.IgnoreWater = true

	local result = Workspace:Raycast(origin, direction * RANGE, params)
	if not result then
		return
	end

	local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
	local hitHumanoid = hitModel and hitModel:FindFirstChildOfClass("Humanoid")
	if hitModel and hitModel:GetAttribute("Dangerous") == true and hitHumanoid and hitHumanoid.Health > 0 then
		hitHumanoid:TakeDamage(DAMAGE)
		print(string.format("FOREST BLASTER: %s hit %s for %d damage", player.Name, hitModel.Name, DAMAGE))
	end
end)

Players.PlayerRemoving:Connect(function(player)
	lastShot[player] = nil
end)

print("SECRET VILLAGE FOREST BLASTER v3 READY: fixed pickup + client aiming + bear damage")
