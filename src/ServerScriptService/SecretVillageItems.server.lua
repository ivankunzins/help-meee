-- SECRET VILLAGE ITEMS / exploration tools
-- Creates prototype vehicles. Official purchasable tools are managed by SecretVillageInventory.

local Workspace = game:GetService("Workspace")

-- Vehicles are kept here as simple prototype transport.
local vehicles = Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES") or Instance.new("Folder")
vehicles.Name = "SECRET_VILLAGE_VEHICLES"
vehicles.Parent = Workspace

local function makeVehicle(name, pos, color, speed)
    if vehicles:FindFirstChild(name) then return end

    local model = Instance.new("Model")
    model.Name = name
    model.Parent = vehicles

    local body = Instance.new("Part")
    body.Name = "Body"
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
            local wheel = Instance.new("Part")
            wheel.Name = "Wheel"
            wheel.Size = Vector3.new(1.5,1.5,1.5)
            wheel.Shape = Enum.PartType.Cylinder
            wheel.Orientation = Vector3.new(0,0,90)
            wheel.Position = pos + Vector3.new(x,-1,z)
            wheel.Color = Color3.fromRGB(25,25,25)
            wheel.CanCollide = false
            wheel.Parent = model

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = body
            weld.Part1 = wheel
            weld.Parent = wheel
        end
    end
end

makeVehicle("VillageCar",Vector3.new(20,3,12),Color3.fromRGB(70,130,220),55)
makeVehicle("Taxi",Vector3.new(32,3,12),Color3.fromRGB(245,205,55),50)
makeVehicle("DeliveryVan",Vector3.new(44,3,12),Color3.fromRGB(235,235,235),45)
