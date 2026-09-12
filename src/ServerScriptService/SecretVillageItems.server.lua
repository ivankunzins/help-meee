-- SECRET VILLAGE ITEMS / exploration tools
-- Creates collectible gear in the secret room and simple usable tools.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")

local root = Workspace:FindFirstChild("SECRET_VILLAGE_ITEMS") or Instance.new("Folder")
root.Name = "SECRET_VILLAGE_ITEMS"
root.Parent = Workspace

local function notify(p,t) Notify:FireClient(p,t) end

local function giveTool(player, name, color, action)
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack or backpack:FindFirstChild(name) then return end
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,1,3)
    handle.Color = color
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    tool.Activated:Connect(function()
        if action then action(player) end
    end)
    tool.Parent = backpack
end

local function rewardPad(name, pos, item, color, text)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = Vector3.new(5,.5,5)
    p.Position = pos
    p.Anchored = true
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Parent = root
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Получить"
    prompt.ObjectText = text
    prompt.HoldDuration = .5
    prompt.Parent = p
    prompt.Triggered:Connect(function(player)
        giveTool(player,item,color,function(plr)
            notify(plr,"✨ Использован предмет: "..item)
        end)
        notify(player,"🎁 Получен предмет: "..item)
    end)
end

-- Hidden reward room. The pads exist at a safe offset and can be moved into the final room later.
rewardPad("MagicCarpet", Vector3.new(-30,-6,75), "🛩️ MAGIC CARPET", Color3.fromRGB(180,80,255), "Magic Carpet")
rewardPad("EnergySword", Vector3.new(-40,-6,75), "⚔️ ENERGY SWORD", Color3.fromRGB(80,220,255), "Energy Sword")
rewardPad("RocketBlaster", Vector3.new(-50,-6,75), "🚀 ROCKET BLASTER", Color3.fromRGB(255,90,70), "Rocket Blaster")
rewardPad("BoomCannon", Vector3.new(-60,-6,75), "💥 BOOM CANNON", Color3.fromRGB(255,180,50), "Boom Cannon")

-- Basic vehicle seats: safe, simple prototype transport.
local vehicles = Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES") or Instance.new("Folder")
vehicles.Name = "SECRET_VILLAGE_VEHICLES"
vehicles.Parent = Workspace

local function makeVehicle(name, pos, color, speed)
    local model = Instance.new("Model")
    model.Name = name
    model.Parent = vehicles
    local body = Instance.new("Part")
    body.Size = Vector3.new(7,2,11)
    body.Position = pos
    body.Anchored = false
    body.Color = color
    body.Material = Enum.Material.SmoothPlastic
    body.Parent = model
    model.PrimaryPart = body
    local seat = Instance.new("VehicleSeat")
    seat.Name = "DriverSeat"
    seat.Size = Vector3.new(2,1,2)
    seat.Position = pos + Vector3.new(0,1.5,0)
    seat.MaxSpeed = speed
    seat.Torque = 8000
    seat.TurnSpeed = 2
    seat.Parent = model
    for _,x in ipairs({-3,3}) do
        for _,z in ipairs({-4,4}) do
            local w=Instance.new("Part")
            w.Size=Vector3.new(1.5,1.5,1.5)
            w.Shape=Enum.PartType.Cylinder
            w.Orientation=Vector3.new(0,0,90)
            w.Position=pos+Vector3.new(x,-1,z)
            w.Color=Color3.fromRGB(25,25,25)
            w.CanCollide=false
            w.Parent=model
            local weld=Instance.new("WeldConstraint")
            weld.Part0=body
            weld.Part1=w
            weld.Parent=w
        end
    end
end

makeVehicle("VillageCar",Vector3.new(20,3,12),Color3.fromRGB(70,130,220),55)
makeVehicle("Taxi",Vector3.new(32,3,12),Color3.fromRGB(245,205,55),50)
makeVehicle("DeliveryVan",Vector3.new(44,3,12),Color3.fromRGB(235,235,235),45)
