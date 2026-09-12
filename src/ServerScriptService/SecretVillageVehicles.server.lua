-- SECRET VILLAGE VEHICLES v2
-- Functional server-controlled arcade vehicles. One active vehicle per player.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local spawnRemote=remotes:FindFirstChild("SpawnVehicle") or Instance.new("RemoteEvent");spawnRemote.Name="SpawnVehicle";spawnRemote.Parent=remotes
local root=Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES") or Instance.new("Folder");root.Name="SECRET_VILLAGE_VEHICLES";root.Parent=Workspace
local active={}
local allowed={VillageCar={cost=0,speed=62,color=Color3.fromRGB(80,170,255),name="🚗 Машина"},Taxi={cost=500,speed=70,color=Color3.fromRGB(245,210,45),name="🚕 Такси"},DeliveryVan={cost=750,speed=54,color=Color3.fromRGB(235,235,235),name="📦 Фургон"}}
local function money(p)local l=p:FindFirstChild("leaderstats");return l and l:FindFirstChild("Money")end
local function spawn(p,kind)
 local spec=allowed[kind];if not spec then return end
 if kind~="VillageCar" and not p:GetAttribute("OwnVehicle_"..kind) then local m=money(p);if not m or m.Value<spec.cost then Notify:FireClient(p,"❌ Для этого транспорта нужно $"..spec.cost..".");return end;m.Value-=spec.cost;p:SetAttribute("OwnVehicle_"..kind,true)end
 if active[p]then active[p]:Destroy()end
 local char=p.Character;if not char then return end
 local cf=char:GetPivot();local base=cf.Position+cf.LookVector*14+Vector3.new(0,3,0)
 local model=Instance.new("Model");model.Name=kind.."_"..p.UserId;model.Parent=root
 local body=Instance.new("Part");body.Name="Body";body.Size=Vector3.new(8,2.2,12);body.CFrame=CFrame.new(base,base+cf.LookVector);body.Anchored=false;body.Material=Enum.Material.Metal;body.Color=spec.color;body.Parent=model;model.PrimaryPart=body
 local seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.CFrame=body.CFrame*CFrame.new(0,1.7,-1);seat.Anchored=false;seat.MaxSpeed=0;seat.Parent=model
 local sw=Instance.new("WeldConstraint");sw.Part0=body;sw.Part1=seat;sw.Parent=body
 for _,x in ipairs({-3,3})do for _,z in ipairs({-4,4})do local w=Instance.new("Part");w.Name="Wheel";w.Shape=Enum.PartType.Cylinder;w.Size=Vector3.new(1.5,2.4,2.4);w.CFrame=CFrame.new(base+Vector3.new(x,-1,z))*CFrame.Angles(0,0,math.rad(90));w.Anchored=false;w.Material=Enum.Material.Rubber;w.Parent=model;local ww=Instance.new("WeldConstraint");ww.Part0=body;ww.Part1=w;ww.Parent=w end end
 local tag=Instance.new("StringValue");tag.Name="VehicleType";tag.Value=kind;tag.Parent=model
 active[p]=model;Notify:FireClient(p,spec.name.." готово. Садись за руль!")
end
spawnRemote.OnServerEvent:Connect(function(p,kind)if type(kind)=="string"then spawn(p,kind)end end)
RunService.Heartbeat:Connect(function()
 for p,model in pairs(active)do
  if not p.Parent or not model.Parent then active[p]=nil;continue end
  local seat=model:FindFirstChild("DriverSeat");local body=model.PrimaryPart
  if seat and body and seat.Occupant then
   local driver=Players:GetPlayerFromCharacter(seat.Occupant.Parent)
   if driver==p then local spec=allowed[model.VehicleType.Value];local v=body.CFrame.LookVector*(seat.ThrottleFloat*spec.speed);body.AssemblyLinearVelocity=Vector3.new(v.X,body.AssemblyLinearVelocity.Y,v.Z);body.AssemblyAngularVelocity=Vector3.new(0,-seat.SteerFloat*1.8,0)end
  end
 end
end)
Players.PlayerRemoving:Connect(function(p)if active[p]then active[p]:Destroy()end;active[p]=nil end)
