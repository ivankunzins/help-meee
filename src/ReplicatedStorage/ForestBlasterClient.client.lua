-- SECRET VILLAGE FOREST BLASTER CLIENT v1
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local remote = ReplicatedStorage:WaitForChild("SecretVillageWeaponRemotes"):WaitForChild("ForestBlasterFire")
local tool = script.Parent
local busy = false

local function flash(position, direction)
	local beam = Instance.new("Part")
	beam.Name = "BlasterBeam"
	beam.Anchored = true
	beam.CanCollide = false
	beam.Material = Enum.Material.Neon
	beam.Color = Color3.fromRGB(70, 210, 255)
	beam.Size = Vector3.new(0.12, 0.12, 3)
	beam.CFrame = CFrame.lookAt(position + direction * 1.5, position + direction * 4.5)
	beam.Parent = workspace
	Debris:AddItem(beam, 0.08)
end

tool.Activated:Connect(function()
	if busy then
		return
	end
	busy = true

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if root and camera then
		local origin = camera.CFrame.Position
		local direction = camera.CFrame.LookVector.Unit
		remote:FireServer(origin, direction)
		flash(origin, direction)
	end

	task.wait(0.65)
	busy = false
end)
