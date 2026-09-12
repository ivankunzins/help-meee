-- SECRET VILLAGE GRAPHICS v1
-- Natural lighting, atmosphere, materials, foliage and environmental polish.
local Lighting=game:GetService("Lighting")
local Workspace=game:GetService("Workspace")
local Terrain=Workspace.Terrain
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.Brightness=2.1
Lighting.ClockTime=14.2
Lighting.GeographicLatitude=52
Lighting.ExposureCompensation=0.05
Lighting.EnvironmentDiffuseScale=0.45
Lighting.EnvironmentSpecularScale=0.65
Lighting.ShadowSoftness=0.28
Lighting.FogStart=180
Lighting.FogEnd=900
Lighting.Ambient=Color3.fromRGB(72,78,82)
Lighting.OutdoorAmbient=Color3.fromRGB(128,137,142)
local function ensure(className,name,parent)
 local x=parent:FindFirstChild(name)
 if x and x.ClassName==className then return x end
 if x then x:Destroy() end
 x=Instance.new(className);x.Name=name;x.Parent=parent;return x
end
local atmosphere=ensure("Atmosphere","NaturalAtmosphere",Lighting)
atmosphere.Density=0.28
atmosphere.Offset=0.12
atmosphere.Color=Color3.fromRGB(202,218,224)
atmosphere.Decay=Color3.fromRGB(116,133,146)
atmosphere.Glare=0.08
atmosphere.Haze=1.15
local cc=ensure("ColorCorrectionEffect","NaturalColor",Lighting)
cc.Brightness=0.015
cc.Contrast=0.08
cc.Saturation=0.06
cc.TintColor=Color3.fromRGB(255,251,244)
local bloom=ensure("BloomEffect","SoftSunBloom",Lighting)
bloom.Intensity=0.08
bloom.Size=18
bloom.Threshold=1.15
local sun=ensure("SunRaysEffect","SunRays",Lighting)
sun.Intensity=0.045
sun.Spread=0.72
local dof=ensure("DepthOfFieldEffect","SubtleDepth",Lighting)
dof.Enabled=false
local clouds=ensure("Clouds","VillageClouds",Terrain)
clouds.Cover=0.34
clouds.Density=0.22
clouds.Color=Color3.fromRGB(238,241,240)
Terrain.WaterColor=Color3.fromRGB(42,125,164)
Terrain.WaterTransparency=0.18
Terrain.WaterReflectance=0.28
Terrain.WaterWaveSize=0.12
Terrain.WaterWaveSpeed=7
local world=Workspace:FindFirstChild("SECRET_VILLAGE_WORLD")
if world then
 for _,obj in ipairs(world:GetDescendants()) do
  if obj:IsA("BasePart") then
   if obj.Name=="MainRoad" or obj.Name=="CrossRoad" then obj.Material=Enum.Material.Asphalt
   elseif obj.Name=="VillageSquare" then obj.Material=Enum.Material.Cobblestone
   elseif obj.Name=="RiverBank" then obj.Material=Enum.Material.Sand
   elseif obj.Name=="Bridge" or obj.Name=="Dock" then obj.Material=Enum.Material.WoodPlanks
   elseif obj.Name=="Roof" then obj.Material=Enum.Material.Slate
   elseif obj.Name=="House" then obj.Material=Enum.Material.Brick
   elseif obj.Name=="Window" then obj.Material=Enum.Material.Glass;obj.Reflectance=0.18
   elseif obj.Name=="RoomLight" then obj.Material=Enum.Material.Neon;obj.Transparency=0.08 end
  end
 end
end
local function addLight(partName,color,brightness,range)
 if not world then return end
 local p=world:FindFirstChild(partName,true)
 if not p or not p:IsA("BasePart") then return end
 local light=p:FindFirstChild("VillageLight") or Instance.new("PointLight")
 light.Name="VillageLight";light.Color=color;light.Brightness=brightness;light.Range=range;light.Shadows=true;light.Parent=p
end
addLight("Fountain",Color3.fromRGB(190,225,255),1.2,18)
addLight("GasSign",Color3.fromRGB(255,196,112),1.8,24)
addLight("RoomLight",Color3.fromRGB(90,190,255),2.8,28)
if world then
 for _,tree in ipairs(world:GetChildren()) do
  if tree.Name=="Tree" then
   local trunk=tree:FindFirstChild("Trunk");local crown=tree:FindFirstChild("Crown")
   if trunk and crown and not tree:FindFirstChild("Canopy2") then
    trunk.Material=Enum.Material.Wood;trunk.Color=Color3.fromRGB(92,67,46)
    crown.Material=Enum.Material.Grass;crown.Color=Color3.fromRGB(67,112,55);crown.Size=Vector3.new(8,7,8)
    local c2=crown:Clone();c2.Name="Canopy2";c2.Size=Vector3.new(6.5,6,6.5);c2.CFrame=crown.CFrame*CFrame.new(2,2,-1);c2.Parent=tree
    local c3=crown:Clone();c3.Name="Canopy3";c3.Size=Vector3.new(5.5,5,5.5);c3.CFrame=crown.CFrame*CFrame.new(-2,2,1);c3.Parent=tree
   end
  end
 end
end
print("[SecretVillageGraphics] Natural graphics initialized")
