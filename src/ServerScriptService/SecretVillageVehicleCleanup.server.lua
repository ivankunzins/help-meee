-- SECRET VILLAGE VEHICLE CLEANUP v1
-- Removes stale vehicles owned by a player before the main vehicle spawner creates another one.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local spawnRemote = remotes:WaitForChild("SpawnVehicle")
local vehicles = Workspace:WaitForChild("SECRET_VILLAGE_VEHICLES")

local lastCleanup = {}

local function cleanup(player)
    if not player or not player.Parent then
        return
    end

    local now = os.clock()
    if now - (lastCleanup[player] or 0) < 1 then
        return
    end
    lastCleanup[player] = now

    for _, model in ipairs(vehicles:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("OwnerUserId") == player.UserId then
            model:Destroy()
        end
    end
end

spawnRemote.OnServerEvent:Connect(function(player)
    cleanup(player)
end)

Players.PlayerRemoving:Connect(function(player)
    lastCleanup[player] = nil
end)
