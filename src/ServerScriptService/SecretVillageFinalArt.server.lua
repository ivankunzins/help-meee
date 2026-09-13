-- SECRET VILLAGE FINAL ART v1
-- Global visual cleanup: cohesive rural village, natural materials, terrain dressing,
-- architectural finishing, farms, river edges, props, and lighting.
-- Intentionally avoids the previous "random Parts everywhere" look.

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

if Workspace:FindFirstChild("FINAL_ART_PASS") then return end
local ROOT = Instance.new("Folder")
ROOT.Name = "FINAL_ART_PASS"
ROOT.Parent = Workspace

local function part(name, size, cf, material, color, parent, shape)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Anchored = true
	p.CanCollide = true
	p.Material = material or Enum.Material.Wood
	p.Color = color or Color3.fromRGB(110,90,65)
	if shape then p.Shape = shape end
	p.Parent = parent or ROOT
	return p
end

local function ball(name, size, pos, material, color, parent)
	return part(name,size,CFrame.new(pos),material,color,parent,Enum.PartType.Ball)
end

local function cyl(name, radius, height, pos, material, color, parent)
	return part(name,Vector3.new(radius*2,height,radius*2),CFrame.new(pos),material,color,parent,Enum.PartType.Cylinder)
end

local function trimHouse(model, accent)
	if not model or not model:IsA("Model") then return end
	local cf,size = model:GetBoundingBox()
	local x,z = cf.Position.X,cf.Position.Z
	local sx,sy,sz = size.X,size.Y,size.Z
	local folder = Instance.new("Folder")
	folder.Name = "FinalFacade"
	folder.Parent = ROOT

	-- foundation
	part("Foundation",Vector3.new(sx+1.4,.45,sz+1.4),CFrame.new(x,cf.Position.Y-sy/2-.1,z),Enum.Material.Slate,Color3.fromRGB(72,73,68),folder)
	-- porch
	part("Porch",Vector3.new(math.min(sx*.72,12),.35,2.8),CFrame.new(x,cf.Position.Y-sy/2+.25,z-sz/2-1.2),Enum.Material.WoodPlanks,Color3.fromRGB(112,82,55),folder)
	for dx=-1.8,1.8,3.6 do
		part("PorchPost",Vector3.new(.25,2.5,.25),CFrame.new(x+dx,cf.Position.Y-sy/2+1.45,z-sz/2-2),Enum.Material.Wood,Color3.fromRGB(92,67,47),folder)
	end
	-- roof ridge + fascia
	part("RoofRidge",Vector3.new(sx+1,.3,.45),CFrame.new(x,cf.Position.Y+sy/2+.15,z),Enum.Material.Wood,Color3.fromRGB(64,55,48),folder)
	-- door
	part("Door",Vector3.new(2.1,3.2,.18),CFrame.new(x,cf.Position.Y-sy/2+1.65,z-sz/2-.12),Enum.Material.Wood,accent,folder)
	-- door knob
	ball("Knob",Vector3.new(.12,.12,.12),Vector3.new(x+.68,cf.Position.Y-sy/2+1.65,z-sz/2-.25),Enum.Material.Metal,Color3.fromRGB(210,178,105),folder)
	-- flower boxes / windows
	for dx=-math.min(sx*.3,4),math.min(sx*.3,4),math.max(3.2,sx*.45) do
		part("Window",Vector3.new(2.2,1.55,.12),CFrame.new(x+dx,cf.Position.Y+.45,z-sz/2-.08),Enum.Material.Glass,Color3.fromRGB(154,190,194),folder)
		part("WindowSill",Vector3.new(2.55,.16,.4),CFrame.new(x+dx,cf.Position.Y-.38,z-sz/2-.25),Enum.Material.Wood,Color3.fromRGB(90,65,47),folder)
		for fx=-.7,.7,1.4 do
			ball("Flower",Vector3.new(.25,.18,.25),Vector3.new(x+dx+fx,cf.Position.Y-.23,z-sz/2-.48),Enum.Material.Grass,Color3.fromRGB(88,118,62),folder)
		end
	end
end

-- Convert the old broad roads into believable rural paths rather than asphalt strips.
for _,obj in ipairs(Workspace:GetDescendants()) do
	if obj:IsA("BasePart") and (obj.Name=="MainRoad" or obj.Name=="CrossRoad") then
		obj.Material = Enum.Material.Ground
		obj.Color = Color3.fromRGB(117,101,75)
		obj.Transparency = 0
		obj.CastShadow = true
	end
end

-- Layered dirt shoulders and irregular grass islands.
local ground = Instance.new("Folder")
ground.Name = "NaturalGround"
ground.Parent = ROOT
math.randomseed(90417)
for i=1,85 do
	local x = math.random(-145,145)
	local z = math.random(-125,135)
	local s = math.random(5,13)
	local p = part("GrassIsland",Vector3.new(s,.18,math.random(4,10)),CFrame.new(x,.18,z)*CFrame.Angles(0,math.random()*math.pi,0),Enum.Material.Grass,Color3.fromRGB(79+math.random(0,18),105+math.random(0,18),61+math.random(0,12)),ground)
	p.CanCollide=false
end

-- Farm plots: coherent rectangles with rows, rather than isolated props.
local farms = Instance.new("Folder")
farms.Name = "FarmLandscapes"
farms.Parent = ROOT
local function farm(cx,cz,w,d)
	part("Soil",Vector3.new(w,.16,d),CFrame.new(cx,.12,cz),Enum.Material.Ground,Color3.fromRGB(91,70,47),farms)
	for x=-w/2+2, w/2-2, 3 do
		for z=-d/2+2,d/2-2,3 do
			local h=math.random(1,2)/2
			ball("Crop",Vector3.new(.35,.7+h,.35),Vector3.new(cx+x,.55+h/2,cz+z),Enum.Material.Grass,Color3.fromRGB(61,105,52),farms)
		end
	end
	for x=-w/2,w/2,4 do
		part("Fence",Vector3.new(.18,1.2,.18),CFrame.new(cx+x,.7,cz-d/2),Enum.Material.Wood,Color3.fromRGB(104,76,49),farms)
		part("Fence",Vector3.new(.18,1.2,.18),CFrame.new(cx+x,.7,cz+d/2),Enum.Material.Wood,Color3.fromRGB(104,76,49),farms)
	end
end
farm(-100,-82,34,25)
farm(116,-55,28,22)
farm(-120,55,25,19)

-- Rustic hay stacks.
local hay = Instance.new("Folder")
hay.Name="HayAndStorage"
hay.Parent=ROOT
for _,v in ipairs({{-88,-91},{-81,-91},{112,-65},{119,-65},{-113,66}}) do
	cyl("HayBale",1.15,1.8,Vector3.new(v[1],1,v[2]),Enum.Material.Fabric,Color3.fromRGB(181,151,77),hay)
end

-- River edge treatment.
local river = Instance.new("Folder")
river.Name="RiverBanksFinal"
river.Parent=ROOT
for i=1,55 do
	local z=-5+i*4.1
	local side=(i%2==0) and -1 or 1
	local x=side*(28+math.random(-7,7))
	local r=math.random(1,3)
	ball("BankRock",Vector3.new(r*1.5,r,r),Vector3.new(x,1,z+math.random(-2,2)),Enum.Material.Slate,Color3.fromRGB(101,105,99),river)
	if i%3==0 then
		for j=1,3 do
			part("Reed",Vector3.new(.12,math.random(2,4),.12),CFrame.new(x+math.random(-2,2),1,z+math.random(-2,2))*CFrame.Angles(math.rad(math.random(-12,12)),0,math.rad(math.random(-8,8))),Enum.Material.Grass,Color3.fromRGB(71,103,58),river)
		end
	end
end

-- Village square focal point: circular planting ring and seating.
local square=Instance.new("Folder")
square.Name="VillageSquareFinal"
square.Parent=ROOT
cyl("PlantingRing",10,.3,Vector3.new(25,.25,-45),Enum.Material.Slate,Color3.fromRGB(118,112,100),square)
for i=1,12 do
	local a=i/12*math.pi*2
	local x=25+math.cos(a)*8.5
	local z=-45+math.sin(a)*8.5
	ball("Shrub",Vector3.new(2,1.6,2),Vector3.new(x,1.1,z),Enum.Material.Grass,Color3.fromRGB(58,91,50),square)
end

-- Better street lamps: warm practical lights, not floating blocks.
local lamps=Instance.new("Folder")
lamps.Name="FinalStreetFurniture"
lamps.Parent=ROOT
for _,v in ipairs({{-18, -18},{18,-18},{-18,18},{18,18},{55,-30},{82,18},{-75,20},{-70,-40},{90,-75}}) do
	local x,z=v[1],v[2]
	cyl("LampPost",.13,5,Vector3.new(x,2.5,z),Enum.Material.Metal,Color3.fromRGB(45,47,43),lamps)
	part("LampArm",Vector3.new(1.5,.12,.12),CFrame.new(x+.65,5,z),Enum.Material.Metal,Color3.fromRGB(45,47,43),lamps)
	local light=part("Lamp",Vector3.new(.35,.35,.35),CFrame.new(x+1.25,4.8,z),Enum.Material.Neon,Color3.fromRGB(255,214,142),lamps)
	light.CanCollide=false
	local pl=Instance.new("PointLight")
	pl.Range=18
	pl.Brightness=1.3
	pl.Color=Color3.fromRGB(255,214,160)
	pl.Parent=light
end

-- Finish existing major buildings with a consistent facade language.
for _,name in ipairs({"Bakery","Village Shop","Old House","Garage","Forest Cabin","VillageGeneralStore","FarmShop"}) do
	local m=Workspace:FindFirstChild(name)
	if m then trimHouse(m,Color3.fromRGB(121,82,58)) end
end

-- Final lighting pass.
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.Brightness=2.15
Lighting.ClockTime=14.1
Lighting.ExposureCompensation=.05
Lighting.EnvironmentDiffuseScale=.5
Lighting.EnvironmentSpecularScale=.7
Lighting.ShadowSoftness=.3

local cc=Lighting:FindFirstChild("FinalNaturalColor") or Instance.new("ColorCorrectionEffect")
cc.Name="FinalNaturalColor"
cc.Brightness=.01
cc.Contrast=.055
cc.Saturation=.035
cc.TintColor=Color3.fromRGB(255,252,246)
cc.Parent=Lighting

local bloom=Lighting:FindFirstChild("FinalSoftBloom") or Instance.new("BloomEffect")
bloom.Name="FinalSoftBloom"
bloom.Intensity=.055
bloom.Size=20
bloom.Threshold=1.25
bloom.Parent=Lighting

print("SECRET VILLAGE: FINAL ART PASS COMPLETE")
