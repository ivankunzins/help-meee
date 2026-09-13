-- SECRET VILLAGE FINAL TERRAIN CLEANUP v1
-- Authoritative last-pass cleanup. Removes visual road clutter and unnecessary world labels.
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local root=WS:FindFirstChild("SECRET_VILLAGE_WORLD") or WS
local folder=WS:FindFirstChild("SECRET_VILLAGE_FINAL_TERRAIN") or Instance.new("Folder",WS);folder.Name="SECRET_VILLAGE_FINAL_TERRAIN"
if folder:GetAttribute("Built") then return end
folder:SetAttribute("Built",true)

local function patch(n,s,cf,mat,col,trans)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=cf;p.Anchored=true;p.CanCollide=true;p.Material=mat;p.Color=col;p.Transparency=trans or 0;p.Parent=folder;return p
end

-- Roads are intentionally absent. Hide every known generated road/marking object.
local roadNames={MainRoad=true,CrossRoad=true,DirtVillageRoad=true,DirtVillageRoadCross=true,Road=true,RoadMark=true,CenterLine=true,Curbs=true}
for _,obj in ipairs(WS:GetDescendants()) do
 if obj:IsA("BasePart") and roadNames[obj.Name] then obj.Transparency=1;obj.CanCollide=false end
end

-- Broad meadow plates visually unify the village. They sit below props and buildings.
local meadows={
 {Vector3.new(0,-.16,0),Vector3.new(250,.28,250)},
 {Vector3.new(-80,-.13,70),Vector3.new(105,.24,80)},
 {Vector3.new(80,-.13,-65),Vector3.new(100,.24,90)},
}
for i,v in ipairs(meadows) do patch("Meadow_"..i,v[2],CFrame.new(v[1]),Enum.Material.Grass,Color3.fromRGB(91,125,66)) end

-- Irregular dirt footpaths only; no vehicle roads.
local paths={
 {Vector3.new(-35,.02,15),Vector3.new(8,.18,105),math.rad(-18)},
 {Vector3.new(30,.02,25),Vector3.new(8,.18,90),math.rad(22)},
 {Vector3.new(-10,.02,-35),Vector3.new(95,.18,7),math.rad(4)},
}
for i,v in ipairs(paths) do local p=patch("NaturalFootpath_"..i,v[2],CFrame.new(v[1])*CFrame.Angles(0,v[3],0),Enum.Material.Ground,Color3.fromRGB(126,104,72));p.CanCollide=true end

-- Small terrain mounds break the flat generated-plane feeling.
local rng=Random.new(9117)
for i=1,34 do
 local a=rng:NextNumber(0,math.pi*2);local r=rng:NextNumber(70,125);local s=rng:NextNumber(5,13)
 local p=patch("MeadowMound",Vector3.new(s,rng:NextNumber(.35,.8),s*.75),CFrame.new(math.cos(a)*r,.05,math.sin(a)*r),Enum.Material.Grass,Color3.fromRGB(84,116,62));p.Shape=Enum.PartType.Ball;p.CanCollide=true
end

-- Remove decorative floating labels from generated life/visual folders. Secret prompts remain untouched.
local function cleanGui(obj)
 for _,d in ipairs(obj:GetDescendants()) do
  if d:IsA("BillboardGui") then d:Destroy() end
 end
end
for _,name in ipairs({"SECRET_VILLAGE_LIFE","SECRET_VILLAGE_FOREST"}) do local f=WS:FindFirstChild(name);if f then cleanGui(f) end end

-- Keep the presentation grounded and natural.
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.Brightness=2.05
Lighting.ClockTime=14.7
Lighting.ExposureCompensation=.02
Lighting.EnvironmentDiffuseScale=.58
Lighting.EnvironmentSpecularScale=.7
local cc=Lighting:FindFirstChild("FinalTerrainColor") or Instance.new("ColorCorrectionEffect",Lighting);cc.Name="FinalTerrainColor";cc.Brightness=.01;cc.Contrast=.08;cc.Saturation=.05
