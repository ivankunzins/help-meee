-- SECRET VILLAGE ARCHITECTURE FINAL v1
-- Distinctive, finished silhouettes for the main village buildings.
local WS=game:GetService("Workspace")
if WS:FindFirstChild("ARCHITECTURE_FINAL") then return end
local ROOT=Instance.new("Folder");ROOT.Name="ARCHITECTURE_FINAL";ROOT.Parent=WS
local function P(n,s,cf,m,c,par,coll)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=cf;p.Anchored=true;p.Material=m;p.Color=c;p.CanCollide=coll~=false;p.Parent=par or ROOT;return p
end
local function Wedge(n,s,cf,m,c,par)
 local p=P(n,s,cf,m,c,par);p.Shape=Enum.PartType.Wedge;return p
end
local function roof(model,c,r)
 local box,size=model:GetBoundingBox();local x,z=box.Position.X,box.Position.Z;local y=box.Position.Y+size.Y/2
 local f=Instance.new("Folder");f.Name="RoofAndTrim";f.Parent=ROOT
 local w=math.max(10,size.X+2);local d=math.max(9,size.Z+2)
 Wedge("RoofLeft",Vector3.new(w/2,2.8,d),CFrame.new(x-w/4,y+.9,z)*CFrame.Angles(0,0,math.rad(180)),Enum.Material.WoodPlanks,c,f)
 Wedge("RoofRight",Vector3.new(w/2,2.8,d),CFrame.new(x+w/4,y+.9,z),Enum.Material.WoodPlanks,c,f)
 P("Ridge",Vector3.new(.5, .45,d+.5),CFrame.new(x,y+2.15,z),Enum.Material.Wood,c:Lerp(Color3.new(0,0,0),.25),f)
end
local function window(x,y,z,rot)
 local f=Instance.new("Folder");f.Name="WindowDetail";f.Parent=ROOT
 P("Frame",Vector3.new(2.8,2.2,.22),CFrame.new(x,y,z)*CFrame.Angles(0,rot or 0,0),Enum.Material.Wood,Color3.fromRGB(84,61,45),f)
 P("Glass",Vector3.new(2.25,1.65,.08),CFrame.new(x,y,z-.13)*CFrame.Angles(0,rot or 0,0),Enum.Material.Glass,Color3.fromRGB(143,190,195),f)
 P("MullionV",Vector3.new(.09,1.7,.1),CFrame.new(x,y,z-.2)*CFrame.Angles(0,rot or 0,0),Enum.Material.Wood,Color3.fromRGB(84,61,45),f)
 P("MullionH",Vector3.new(2.25,.09,.1),CFrame.new(x,y,z-.2)*CFrame.Angles(0,rot or 0,0),Enum.Material.Wood,Color3.fromRGB(84,61,45),f)
end
local function door(x,y,z,c)
 local f=Instance.new("Folder");f.Name="DoorDetail";f.Parent=ROOT
 P("Door",Vector3.new(2.5,4,.22),CFrame.new(x,y,z),Enum.Material.Wood,c,f)
 for i=1,3 do P("Panel",Vector3.new(1.8,.7,.08),CFrame.new(x,y-1.1+i*.9,z-.15),Enum.Material.Wood,Color3.fromRGB(92,64,45),f) end
 local k=P("Handle",Vector3.new(.16,.16,.16),CFrame.new(x+.72,y,z-.3),Enum.Material.Metal,Color3.fromRGB(215,178,100),f);k.Shape=Enum.PartType.Ball;k.CanCollide=false
end
local function decorate(name,accent,roofColor)
 local m=WS:FindFirstChild(name);if not m or not m:IsA("Model") then return end
 local cf,size=m:GetBoundingBox();local x,z=cf.Position.X,cf.Position.Z;local base=cf.Position.Y-size.Y/2
 roof(m,roofColor,2)
 door(x,base+2,z-size.Z/2-.15,accent)
 window(x-size.X*.25,base+3.7,z-size.Z/2-.16,0);window(x+size.X*.25,base+3.7,z-size.Z/2-.16,0)
 -- steps
 P("Step",Vector3.new(4,.25,1.1),CFrame.new(x,base+.2,z-size.Z/2-.75),Enum.Material.Slate,Color3.fromRGB(91,88,80))
 -- flower boxes
 for sx=-1,1 do
  P("FlowerBox",Vector3.new(2.3,.3,.5),CFrame.new(x+sx*size.X*.25,base+2.55,z-size.Z/2-.32),Enum.Material.Wood,Color3.fromRGB(89,62,44))
  for j=1,3 do
   local f=P("Flower",Vector3.new(.3,.3,.3),CFrame.new(x+sx*size.X*.25+(j-2)*.55,base+2.82,z-size.Z/2-.4),Enum.Material.Grass,Color3.fromRGB(104,126,61));f.Shape=Enum.PartType.Ball;f.CanCollide=false
  end
 end
end
-- Main landmarks get intentionally different accents.
decorate("VillageGeneralStore",Color3.fromRGB(109,76,49),Color3.fromRGB(63,55,47))
decorate("FarmShop",Color3.fromRGB(95,68,43),Color3.fromRGB(71,58,43))
decorate("Bakery",Color3.fromRGB(153,105,67),Color3.fromRGB(75,54,45))
decorate("Village Shop",Color3.fromRGB(100,73,48),Color3.fromRGB(61,54,47))
decorate("Old House",Color3.fromRGB(119,82,54),Color3.fromRGB(67,57,48))
decorate("Forest Cabin",Color3.fromRGB(91,65,45),Color3.fromRGB(57,51,45))
-- Gas station gets a canopy silhouette.
local gas=WS:FindFirstChild("GasStation")
if gas and gas:IsA("Model") then
 local cf,size=gas:GetBoundingBox();local x,z=cf.Position.X,cf.Position.Z;local y=cf.Position.Y+size.Y/2+1.2
 local f=Instance.new("Folder");f.Name="CanopyFinal";f.Parent=ROOT
 P("Canopy",Vector3.new(25,.55,14),CFrame.new(x,y,z),Enum.Material.Metal,Color3.fromRGB(74,74,69),f)
 for dx=-10,10,20 do P("Column",Vector3.new(.45,5,.45),CFrame.new(x+dx,y-2.5,z),Enum.Material.Metal,Color3.fromRGB(62,62,58),f) end
end
print("SECRET VILLAGE: ARCHITECTURE FINAL COMPLETE")
