-- SECRET VILLAGE VEHICLES v1
-- Server-authoritative simple vehicles. One active vehicle per player.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local spawnRemote=remotes:FindFirstChild("SpawnVehicle") or Instance.new("RemoteEvent")
spawnRemote.Name="SpawnVehicle";spawnRemote.Parent=remotes
local root=Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES") or Instance.new("Folder")
root.Name="SECRET_VILLAGE_VEHICLES";root.Parent=Workspace
local active={}
local allowed={VillageCar={cost=0,color=Color3.fromRGB(80,170,255)},Taxi={cost=500,color=Color3.fromRGB(245,210,45)},DeliveryVan={cost=750,color=Color3.fromRGB(235,235,235)}}
local function money(p) local ls=p:FindFirstChild("leaderstats");return ls and ls:FindFirstChild("Money") end
local function spawn(p,kind)
 local spec=allowed[kind];if not spec then return end
 if kind~="VillageCar" and not p:GetAttribute("OwnVehicle_"..kind) then
  local m=money(p);if not m or m.Value<spec.cost then Notify:FireClient(p,"❌ Для этого транспорта нужно $"..spec.cost..".");return end
  m.Value-=spec.cost;p:SetAttribute("OwnVehicle_"..kind,true)
 end
 if active[p] then active[p]:Destroy() end
 local char=p.Character;if not char then return end
 local base=char:GetPivot().Position+char:GetPivot().LookVector*14+Vector3.new(0,2,0)
 local model=Instance.new("Model");model.Name=kind.."_"..p.UserId;model.Parent=root
 local body=Instance.new("Part");body.Name="Body";body.Size=Vector3.new(8,2,12);body.Position=base;body.Anchored=false;body.Material=Enum.Material.Metal;body.Color=spec.color;body.Parent=model
 local seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(3,1,3);seat.Position=base+Vector3.new(0,1.6,0);seat.Anchored=false;seat.Parent=model
 local weld=Instance.new("WeldConstraint");weld.Part0=body;weld.Part1=seat;weld.Parent=body
 model.PrimaryPart=body
 active[p]=model
 Notify:FireClient(p,"🚗 "..kind.." готов. Садись за руль!")
end
spawnRemote.OnServerEvent:Connect(function(p,kind) spawn(p,kind) end)
Players.PlayerRemoving:Connect(function(p) if active[p] then active[p]:Destroy() end;active[p]=nil end)
