-- SECRET VILLAGE VEHICLES v4
-- Server-authoritative arcade vehicles with validation and rate limiting.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")

local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local spawnRemote=remotes:FindFirstChild("SpawnVehicle") or Instance.new("RemoteEvent")
spawnRemote.Name="SpawnVehicle"
spawnRemote.Parent=remotes

local root=Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES") or Instance.new("Folder")
root.Name="SECRET_VILLAGE_VEHICLES"
root.Parent=Workspace

local active={}
local lastSpawn={}
local processing={}
local SPAWN_COOLDOWN=2

local allowed={
 VillageCar={cost=0,speed=62,color=Color3.fromRGB(80,170,255),name="🚗 Машина"},
 Taxi={cost=500,speed=70,color=Color3.fromRGB(245,210,45),name="🚕 Такси"},
 DeliveryVan={cost=750,speed=54,color=Color3.fromRGB(235,235,235),name="📦 Фургон"},
}

local function notify(p,message)
 if p and p.Parent then Notify:FireClient(p,message) end
end

local function money(p)
 local leaderstats=p:FindFirstChild("leaderstats")
 local value=leaderstats and leaderstats:FindFirstChild("Money")
 if value and value:IsA("IntValue") and value.Value>=0 then return value end
 return nil
end

local function coreLoaded(p)
 return p:GetAttribute("CoreLoaded")==true
end

local function canSpawn(p)
 local now=os.clock()
 if processing[p] then return false end
 if now-(lastSpawn[p] or 0)<SPAWN_COOLDOWN then return false end
 if not coreLoaded(p) then
  notify(p,"⏳ Профиль ещё загружается. Попробуй через несколько секунд.")
  return false
 end
 if not p.Character then return false end
 local humanoid=p.Character:FindFirstChildOfClass("Humanoid")
 local rootPart=p.Character:FindFirstChild("HumanoidRootPart")
 if not humanoid or humanoid.Health<=0 or not rootPart then return false end
 return true
end

local function destroyActive(p)
 local model=active[p]
 if model then
  active[p]=nil
  if model.Parent then model:Destroy() end
 end
end

local function spawn(p,kind)
 if type(kind)~="string" or #kind>32 then return end
 local spec=allowed[kind]
 if not spec or not canSpawn(p) then return end

 processing[p]=true
 lastSpawn[p]=os.clock()

 local m=money(p)
 local owns=p:GetAttribute("Own_"..kind)==true
 if kind~="VillageCar" and not owns then
  if not m or m.Value<spec.cost then
   notify(p,"❌ Для этого транспорта нужно $"..spec.cost..".")
   processing[p]=nil
   return
  end
 end

 local char=p.Character
 local rootPart=char and char:FindFirstChild("HumanoidRootPart")
 if not char or not rootPart then
  processing[p]=nil
  return
 end

 -- Remove the player's previous vehicle before creating a replacement.
 destroyActive(p)

 local cf=char:GetPivot()
 local base=cf.Position+cf.LookVector*14+Vector3.new(0,3,0)
 local model=Instance.new("Model")
 model.Name=kind.."_"..p.UserId
 model:SetAttribute("OwnerUserId",p.UserId)
 model:SetAttribute("VehicleType",kind)
 model.Parent=root

 local body=Instance.new("Part")
 body.Name="Body"
 body.Size=Vector3.new(8,2.2,12)
 body.CFrame=CFrame.new(base,base+cf.LookVector)
 body.Anchored=false
 body.CanCollide=true
 body.Material=Enum.Material.Metal
 body.Color=spec.color
 body.Parent=model
 model.PrimaryPart=body
 body:SetNetworkOwner(nil)

 local seat=Instance.new("VehicleSeat")
 seat.Name="DriverSeat"
 seat.Size=Vector3.new(3,1,3)
 seat.CFrame=body.CFrame*CFrame.new(0,1.7,-1)
 seat.Anchored=false
 seat.MaxSpeed=100
 seat.Parent=model
 seat:SetNetworkOwner(nil)

 local sw=Instance.new("WeldConstraint")
 sw.Part0=body
 sw.Part1=seat
 sw.Parent=body

 for _,x in ipairs({-3,3}) do
  for _,z in ipairs({-4,4}) do
   local wheel=Instance.new("Part")
   wheel.Name="Wheel"
   wheel.Shape=Enum.PartType.Cylinder
   wheel.Size=Vector3.new(1.5,2.4,2.4)
   wheel.CFrame=CFrame.new(base+Vector3.new(x,-1,z))*CFrame.Angles(0,0,math.rad(90))
   wheel.Anchored=false
   wheel.CanCollide=false
   wheel.Material=Enum.Material.Rubber
   wheel.Parent=model
   local weld=Instance.new("WeldConstraint")
   weld.Part0=body
   weld.Part1=wheel
   weld.Parent=wheel
  end
 end

 if kind~="VillageCar" and not owns then
  if not m or m.Value<spec.cost then
   model:Destroy()
   processing[p]=nil
   return
  end
  m.Value-=spec.cost
  p:SetAttribute("Own_"..kind,true)
 end

 active[p]=model
 processing[p]=nil
 notify(p,spec.name.." готово. Садись за руль!")
end

spawnRemote.OnServerEvent:Connect(function(p,kind)
 if typeof(p)~="Instance" or not p:IsA("Player") then return end
 spawn(p,kind)
end)

RunService.Heartbeat:Connect(function()
 for p,model in pairs(active) do
  if not p.Parent or not model.Parent then
   active[p]=nil
   continue
  end

  local seat=model:FindFirstChild("DriverSeat")
  local body=model.PrimaryPart
  local kind=model:GetAttribute("VehicleType")
  local ownerId=model:GetAttribute("OwnerUserId")
  local spec=allowed[kind]

  if not seat or not body or not spec or ownerId~=p.UserId then
   destroyActive(p)
   continue
  end

  if seat.Occupant then
   local character=seat.Occupant.Parent
   local driver=character and Players:GetPlayerFromCharacter(character)
   if driver==p then
    local velocity=body.CFrame.LookVector*(seat.ThrottleFloat*spec.speed)
    body.AssemblyLinearVelocity=Vector3.new(velocity.X,body.AssemblyLinearVelocity.Y,velocity.Z)
    body.AssemblyAngularVelocity=Vector3.new(0,-seat.SteerFloat*1.8,0)
   else
    body.AssemblyLinearVelocity=Vector3.new(0,body.AssemblyLinearVelocity.Y,0)
    body.AssemblyAngularVelocity=Vector3.zero
    seat:Sit(nil)
   end
  end
 end
end)

Players.PlayerRemoving:Connect(function(p)
 destroyActive(p)
 lastSpawn[p]=nil
 processing[p]=nil
end)
