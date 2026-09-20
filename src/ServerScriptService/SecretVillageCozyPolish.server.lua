-- SECRET VILLAGE COZY POLISH v1
-- Decorative polish: fences, trees, flower baskets, benches, banners and ambient fireflies.
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local root=Workspace:WaitForChild("SECRET_VILLAGE_FINAL_MASTER",30)
if not root then warn("[CozyPolish] world not found");return end
local art=root:FindFirstChild("COZY_VILLAGE_ART_V1")
if not art or art:FindFirstChild("COZY_POLISH_V1") then return end
local folder=Instance.new("Folder");folder.Name="COZY_POLISH_V1";folder.Parent=art
local wood=Color3.fromRGB(105,66,43)
local dark=Color3.fromRGB(65,40,29)
local green=Color3.fromRGB(55,111,62)
local green2=Color3.fromRGB(88,145,70)
local cream=Color3.fromRGB(244,213,163)
local gold=Color3.fromRGB(255,203,105)
local function part(name,size,pos,material,color,collide)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Position=pos;p.Anchored=true;p.Material=material or Enum.Material.Wood;p.Color=color or wood;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.CanCollide=collide~=false;p.Parent=folder;return p
end
local function ball(name,size,pos,material,color)
 local p=part(name,size,pos,material,color,false);p.Shape=Enum.PartType.Ball;return p
end
local function cyl(name,radius,height,pos,material,color)
 local p=part(name,Vector3.new(height,radius*2,radius*2),pos,material,color,false);p.Shape=Enum.PartType.Cylinder;p.CFrame=p.CFrame*CFrame.Angles(0,0,math.rad(90));return p
end
local function tree(pos,scale)
 scale=scale or 1
 cyl("TreeTrunk",0.55*scale,4.5*scale,pos+Vector3.new(0,2.25*scale,0),Enum.Material.Wood,wood)
 ball("TreeCrown",Vector3.new(4.8,4.4,4.8)*scale,pos+Vector3.new(0,5.1*scale,0),Enum.Material.Grass,green)
 ball("TreeCrownSmall",Vector3.new(3.5,3.2,3.5)*scale,pos+Vector3.new(1.5*scale,5.4*scale,0.4*scale),Enum.Material.Grass,green2)
end
local function fence(startPos,count,step,axis)
 for i=0,count-1 do
  local pos=startPos+axis*step*i
  part("FencePost",Vector3.new(0.35,2.2,0.35),pos+Vector3.new(0,1.1,0),Enum.Material.Wood,dark)
  if i<count-1 then part("FenceRail",Vector3.new(axis.X==0 and 0.22 or step,0.25,axis.Z==0 and 0.22 or step),pos+axis*(step/2)+Vector3.new(0,1.5,0),Enum.Material.Wood,wood) end
 end
end
-- Decorative tree clusters around the village perimeter.
for _,pos in ipairs({Vector3.new(-78,0,-35),Vector3.new(-70,0,-48),Vector3.new(70,0,-38),Vector3.new(79,0,-25),Vector3.new(-78,0,42),Vector3.new(76,0,40),Vector3.new(-38,0,78),Vector3.new(32,0,83),Vector3.new(58,0,66),Vector3.new(-61,0,65)}) do tree(pos,1.15) end
for _,pos in ipairs({Vector3.new(-19,0,-29),Vector3.new(19,0,-29),Vector3.new(-28,0,18),Vector3.new(28,0,18)}) do tree(pos,0.7) end
-- Low fences framing homes and the market.
fence(Vector3.new(-66,0,12),5,3,Vector3.new(1,0,0))
fence(Vector3.new(53,0,10),5,3,Vector3.new(1,0,0))
fence(Vector3.new(-20,0,70),6,3,Vector3.new(1,0,0))
-- Hanging flower baskets and colorful banners.
for _,pos in ipairs({Vector3.new(-10,4,14),Vector3.new(10,4,14),Vector3.new(-42,5,-32),Vector3.new(34,5,-31)}) do
 cyl("BasketRope",0.06,2.2,pos+Vector3.new(0,1.1,0),Enum.Material.Metal,dark)
 ball("FlowerBasket",Vector3.new(1.2,0.7,1.2),pos,Enum.Material.Wood,wood)
 for i=0,2 do ball("BasketFlower",Vector3.new(0.35,0.35,0.35),pos+Vector3.new((i-1)*0.35,0.45,0),Enum.Material.Neon,(i==1) and gold or Color3.fromRGB(227,104,145)) end
end
for _,data in ipairs({{Vector3.new(-5,6,-10),Color3.fromRGB(151,61,48)},{Vector3.new(5,6,-10),Color3.fromRGB(62,107,159)},{Vector3.new(0,6,-10),Color3.fromRGB(224,174,73)}}) do
 part("Banner",Vector3.new(1.5,3,0.15),data[1],Enum.Material.Fabric,data[2],false)
end
-- Small picnic tables near the square.
for _,pos in ipairs({Vector3.new(-22,0,11),Vector3.new(22,0,11)}) do
 part("PicnicTable",Vector3.new(5,0.35,1.6),pos+Vector3.new(0,2,0),Enum.Material.Wood,wood)
 for _,dx in ipairs({-1.8,1.8}) do part("TableLeg",Vector3.new(0.3,2,0.3),pos+Vector3.new(dx,1,0),Enum.Material.Wood,dark) end
 part("Bench",Vector3.new(5,0.35,0.8),pos+Vector3.new(0,1.2,2),Enum.Material.Wood,wood)
 part("Bench",Vector3.new(5,0.35,0.8),pos+Vector3.new(0,1.2,-2),Enum.Material.Wood,wood)
end
-- Tiny firefly lights, kept sparse for performance.
for i=1,14 do
 local angle=i*math.pi*2/14
 local pos=Vector3.new(math.cos(angle)*31,3.5+((i%3)*0.6),math.sin(angle)*31)
 local glow=ball("Firefly",Vector3.new(0.18,0.18,0.18),pos,Enum.Material.Neon,Color3.fromRGB(255,236,135))
 local light=Instance.new("PointLight");light.Brightness=0.25;light.Range=4;light.Color=gold;light.Parent=glow
end
local color=Lighting:FindFirstChild("SecretVillage_CozyColor")
if not color then color=Instance.new("ColorCorrectionEffect");color.Name="SecretVillage_CozyColor";color.Saturation=0.08;color.Contrast=0.05;color.Brightness=0.03;color.TintColor=Color3.fromRGB(255,244,225);color.Parent=Lighting end
print("[CozyPolish] v1 created: trees, fences, baskets, banners, picnic tables and fireflies")