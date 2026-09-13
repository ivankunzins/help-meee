-- SECRET VILLAGE VISUAL PRESENTATION FINAL v1
-- Final composition pass: cohesive architecture, premium facades, believable interiors,
-- hero landscaping and restrained lighting. No gameplay logic is changed.
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
if WS:FindFirstChild("VISUAL_PRESENTATION_FINAL") then return end
local ROOT=Instance.new("Folder");ROOT.Name="VISUAL_PRESENTATION_FINAL";ROOT.Parent=WS

local function part(parent,name,size,cf,mat,color,collide)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.Material=mat or Enum.Material.SmoothPlastic;p.Color=color or Color3.fromRGB(130,130,130);p.CanCollide=collide~=false;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
local function wedge(parent,name,size,cf,mat,color)
 local p=part(parent,name,size,cf,mat,color);p.Shape=Enum.PartType.Wedge;return p
end
local function ball(parent,name,size,cf,mat,color)
 local p=part(parent,name,size,cf,mat,color,false);p.Shape=Enum.PartType.Ball;return p
end
local function cyl(parent,name,size,cf,mat,color)
 local p=part(parent,name,size,cf,mat,color);p.Shape=Enum.PartType.Cylinder;return p
end
local function folder(name)
 local f=Instance.new("Model");f.Name=name;f.Parent=ROOT;return f
end
local WOOD=Color3.fromRGB(83,57,40)
local DARK=Color3.fromRGB(55,52,47)
local CREAM=Color3.fromRGB(218,205,177)
local GLASS=Color3.fromRGB(145,190,194)
local GRASS=Color3.fromRGB(70,104,55)
local STONE=Color3.fromRGB(116,113,104)

-- Turn the existing village buildings into finished silhouettes without replacing gameplay models.
local function facade(buildingName,signText)
 local b=WS:FindFirstChild(buildingName);if not b or not b:IsA("Model") then return end
 local cf,size=b:GetBoundingBox();local x,z=cf.Position.X,cf.Position.Z;local front=z-size.Z/2-.12;local base=cf.Position.Y-size.Y/2
 local m=folder(buildingName.."_Presentation")
 -- plinth, porch and entrance composition
 part(m,"Plinth",Vector3.new(size.X+.8,.5,.7),CFrame.new(x,base+.25,front+.15),Enum.Material.Slate,STONE)
 part(m,"Porch",Vector3.new(math.min(7,size.X*.55),.25,2.2),CFrame.new(x,base+.5,front-1),Enum.Material.WoodPlanks,WOOD)
 for sx=-1,1 do part(m,"PorchPost",Vector3.new(.3,3.2,.3),CFrame.new(x+sx*math.min(2.8,size.X*.25),base+2,front-1.8),Enum.Material.Wood,WOOD) end
 part(m,"PorchBeam",Vector3.new(math.min(7,size.X*.7),.3,.3),CFrame.new(x,base+3.45,front-1.8),Enum.Material.Wood,WOOD)
 -- centered double-window arrangement
 for sx=-1,1 do
  local wx=x+sx*math.min(2.7,size.X*.27)
  part(m,"WindowFrame",Vector3.new(2.8,2.25,.22),CFrame.new(wx,base+3.5,front-.12),Enum.Material.Wood,WOOD,false)
  part(m,"WindowGlass",Vector3.new(2.35,1.78,.08),CFrame.new(wx,base+3.5,front-.25),Enum.Material.Glass,GLASS,false)
  part(m,"MullionV",Vector3.new(.09,1.8,.1),CFrame.new(wx,base+3.5,front-.31),Enum.Material.Wood,WOOD,false)
  part(m,"MullionH",Vector3.new(2.35,.09,.1),CFrame.new(wx,base+3.5,front-.31),Enum.Material.Wood,WOOD,false)
  for q=-1,1 do ball(m,"Flower",Vector3.new(.32,.32,.32),CFrame.new(wx+q*.55,base+2.45,front-.42),Enum.Material.Grass,GRASS) end
 end
 -- door with canopy
 part(m,"Door",Vector3.new(2.5,4,.2),CFrame.new(x,base+2.25,front-.22),Enum.Material.WoodPlanks,WOOD)
 part(m,"DoorGlass",Vector3.new(1.55,1.1,.07),CFrame.new(x,base+3.15,front-.35),Enum.Material.Glass,GLASS,false)
 part(m,"DoorAwning",Vector3.new(3.8,.25,1.4),CFrame.new(x,base+4.55,front-.65)*CFrame.Angles(math.rad(-8),0,0),Enum.Material.WoodPlanks,DARK)
 local s=part(m,"ShopSign",Vector3.new(math.min(8,size.X*.7),1.15,.18),CFrame.new(x,base+6.1,front-.28),Enum.Material.WoodPlanks,WOOD,false)
 local gui=Instance.new("SurfaceGui");gui.Face=Enum.NormalId.Front;gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;gui.PixelsPerStud=45;gui.Parent=s
 local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1;label.Text=signText;label.TextScaled=true;label.Font=Enum.Font.GothamBold;label.TextColor3=Color3.fromRGB(244,230,190);label.Parent=gui
 -- roof ridge and eaves
 local roofY=base+size.Y+.8
 part(m,"EaveFront",Vector3.new(size.X+1,.28,.45),CFrame.new(x,roofY,front+.15),Enum.Material.Wood,WOOD)
 part(m,"Ridge",Vector3.new(.45,.45,size.Z+1),CFrame.new(x,roofY+2.3,z),Enum.Material.Wood,WOOD)
 wedge(m,"RoofA",Vector3.new((size.X+1)/2,2.8,size.Z+1),CFrame.new(x-(size.X+1)/4,roofY+1.05,z)*CFrame.Angles(0,0,math.rad(180)),Enum.Material.Slate,DARK)
 wedge(m,"RoofB",Vector3.new((size.X+1)/2,2.8,size.Z+1),CFrame.new(x+(size.X+1)/4,roofY+1.05,z),Enum.Material.Slate,DARK)
 -- warm facade light
 local lamp=part(m,"FacadeLight",Vector3.new(.35,.35,.2),CFrame.new(x,base+5.15,front-.3),Enum.Material.Neon,Color3.fromRGB(255,202,125),false)
 local light=Instance.new("PointLight",lamp);light.Range=13;light.Brightness=.9
end
facade("VillageGeneralStore","GENERAL STORE")
facade("FarmShop","FARM & FEED")
facade("Bakery","BAKERY")
facade("Village Shop","VILLAGE SHOP")
facade("Old House","OLD HOUSE")
facade("Forest Cabin","FOREST CABIN")

-- Interiors: only visual dressing, kept slightly inside existing structures.
local function interior(buildingName,kind)
 local b=WS:FindFirstChild(buildingName);if not b or not b:IsA("Model") then return end
 local cf,size=b:GetBoundingBox();local x,z=cf.Position.X,cf.Position.Z;local y=cf.Position.Y-size.Y/2+1.1
 local m=folder(buildingName.."_InteriorPresentation")
 -- Back wall furniture / counter
 part(m,"Counter",Vector3.new(math.min(7,size.X*.65),1.1,.75),CFrame.new(x,y+1,z+size.Z*.2),Enum.Material.WoodPlanks,WOOD)
 for i=1,3 do part(m,"Shelf",Vector3.new(math.min(7,size.X*.7),.18,.65),CFrame.new(x,y+1.4+i*.7,z+size.Z*.38),Enum.Material.WoodPlanks,WOOD) end
 for i=1,5 do ball(m,"Prop",Vector3.new(.65,.65,.65),CFrame.new(x-2+i*.9,y+1.8,z+size.Z*.3),Enum.Material.SmoothPlastic,Color3.fromRGB(175,128,73)) end
 if kind=="bakery" then
  cyl(m,"Oven",Vector3.new(2.2,2.4,2.2),CFrame.new(x-2,y+1.2,z-size.Z*.18)*CFrame.Angles(0,math.rad(90),0),Enum.Material.Metal,Color3.fromRGB(65,65,61))
  for i=1,4 do ball(m,"Bread",Vector3.new(.8,.45,.55),CFrame.new(x+.5+i*.65,y+1.65,z+size.Z*.2),Enum.Material.SmoothPlastic,Color3.fromRGB(190,142,76)) end
 elseif kind=="house" then
  part(m,"Table",Vector3.new(3,.35,2),CFrame.new(x,y+.9,z),Enum.Material.WoodPlanks,WOOD)
  for sx=-1,1 do part(m,"Chair",Vector3.new(.8,1,.8),CFrame.new(x+sx*2,y+.5,z),Enum.Material.Wood,WOOD) end
 elseif kind=="farm" then
  for i=1,4 do part(m,"Crate",Vector3.new(1.6,1.6,1.6),CFrame.new(x-3+i*1.5,y+.8,z),Enum.Material.WoodPlanks,Color3.fromRGB(123,84,46)) end
 end
end
interior("Bakery","bakery")
interior("VillageGeneralStore","shop")
interior("FarmShop","farm")
interior("Old House","house")
interior("Forest Cabin","house")

-- Hero composition: a restrained foreground garden around the village center.
local garden=folder("HeroGarden")
for i=1,14 do
 local a=i*math.pi*2/14;local r=24
 local x=math.cos(a)*r;local z=-5+math.sin(a)*r
 cyl(garden,"Stone",Vector3.new(.5,1.1,.5),CFrame.new(x,.55,z),Enum.Material.Slate,STONE)
 ball(garden,"Shrub",Vector3.new(2.8,1.8,2.8),CFrame.new(x,.95,z),Enum.Material.Grass,GRASS)
end
-- benches orient toward the square
for _,x in ipairs({-13,13}) do
 local m=folder("Bench");part(m,"Seat",Vector3.new(5,.35,1),CFrame.new(x,.9,-5),Enum.Material.WoodPlanks,WOOD);part(m,"Back",Vector3.new(5,1.1,.3),CFrame.new(x,1.5,-5.35),Enum.Material.WoodPlanks,WOOD)
 for sx=-1,1 do part(m,"Leg",Vector3.new(.3,1,.8),CFrame.new(x+sx*1.8,.45,-5),Enum.Material.Metal,DARK) end
end

-- Final color balance: natural daytime, warm highlights, no heavy filters.
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.ClockTime=15.0
Lighting.Brightness=2.15
Lighting.ExposureCompensation=.03
Lighting.EnvironmentDiffuseScale=.6
Lighting.EnvironmentSpecularScale=.72
local cc=Lighting:FindFirstChild("PresentationColor") or Instance.new("ColorCorrectionEffect");cc.Name="PresentationColor";cc.Brightness=.008;cc.Contrast=.1;cc.Saturation=.055;cc.TintColor=Color3.fromRGB(255,249,238);cc.Parent=Lighting
local bloom=Lighting:FindFirstChild("PresentationBloom") or Instance.new("BloomEffect");bloom.Name="PresentationBloom";bloom.Intensity=.055;bloom.Size=18;bloom.Threshold=1.3;bloom.Parent=Lighting
print("SECRET VILLAGE VISUAL PRESENTATION FINAL: finished facades + interiors + hero garden + lighting READY")
