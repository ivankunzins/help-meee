-- SECRET VILLAGE ART FINAL v1
-- Cohesive visual pass: terrain layering, architecture trim, village props, farms, fences, foliage and lighting.
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local world=WS:FindFirstChild("SECRET_VILLAGE_WORLD") or WS
local art=WS:FindFirstChild("SECRET_VILLAGE_ART_FINAL") or Instance.new("Folder",WS);art.Name="SECRET_VILLAGE_ART_FINAL"
if art:GetAttribute("Built") then return end
art:SetAttribute("Built",true)
local function p(n,s,cf,m,c,parent,t,coll)
 local x=Instance.new("Part");x.Name=n;x.Size=s;x.CFrame=cf;x.Anchored=true;x.Material=m or Enum.Material.SmoothPlastic;x.Color=c or Color3.fromRGB(120,120,120);x.Transparency=t or 0;x.CanCollide=coll~=false;x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth;x.Parent=parent or art;return x
end
local function ball(n,pos,size,mat,col,par)local x=p(n,size,CFrame.new(pos),mat,col,par);x.Shape=Enum.PartType.Ball;return x end
local function wedge(n,s,cf,mat,col,par)local x=p(n,s,cf,mat,col,par);x.Shape=Enum.PartType.Wedge;return x end
local function sign(pos,text,w,h)
 local x=p("Sign",Vector3.new(w or 5,h or 1.6,.25),CFrame.new(pos),Enum.Material.Wood,Color3.fromRGB(95,62,35));local g=Instance.new("SurfaceGui",x);g.Face=Enum.NormalId.Front;local l=Instance.new("TextLabel",g);l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.TextColor3=Color3.new(1,1,1);return x
end
-- soften/replace the visual language of the old road slabs
for _,n in ipairs({"MainRoad","CrossRoad"}) do local x=world:FindFirstChild(n);if x and x:IsA("BasePart") then x.Transparency=1;x.CanCollide=false end end
-- broad grass and dirt layers
p("VillageGrass",Vector3.new(320,.7,300),CFrame.new(0,-.35,10),Enum.Material.Grass,Color3.fromRGB(92,125,68),art)
for _,z in ipairs({-105,-70,-30,25,70,112}) do p("DirtPath",Vector3.new(210,.16,10),CFrame.new(0,.06,z),Enum.Material.Ground,Color3.fromRGB(124,102,72),art) end
for _,x in ipairs({-105,-65,-25,20,65,108}) do p("DirtPath",Vector3.new(8,.17,210),CFrame.new(x,.065,10),Enum.Material.Ground,Color3.fromRGB(124,102,72),art) end
-- village square: stone ring + central well
local sq=Instance.new("Model",art);sq.Name="VillageSquareArt"
for i=1,18 do local a=i*math.pi*2/18;local r=17;local s=Vector3.new(5,.45,2.5);local x=p("SquareStone",s,CFrame.new(math.cos(a)*r,.25,-5+math.sin(a)*r)*CFrame.Angles(0,-a,0),Enum.Material.Slate,Color3.fromRGB(135,135,125),sq)end
local well=Instance.new("Model",sq);well.Name="VillageWell";p("Base",Vector3.new(7,2,7),CFrame.new(0,1,-5),Enum.Material.Slate,Color3.fromRGB(110,108,98),well)
local water=p("Water",Vector3.new(5,.2,5),CFrame.new(0,2.05,-5),Enum.Material.Glass,Color3.fromRGB(45,120,155),well,.2,false)
for _,x in ipairs({-3,3})do p("Post",Vector3.new(.55,7,.55),CFrame.new(x,5,-5),Enum.Material.Wood,Color3.fromRGB(90,55,32),well)end
p("Beam",Vector3.new(7.2,.6,.6),CFrame.new(0,8,-5),Enum.Material.Wood,Color3.fromRGB(80,50,30),well);sign(Vector3.new(0,9,-5),"VILLAGE",5,1.2)
-- detailed fences around perimeter/farms
local function fence(a,b)
 local d=b-a;local len=d.Magnitude;local n=math.max(2,math.floor(len/7));for i=0,n do local q=a+d*(i/n);p("FencePost",Vector3.new(.45,2.6,.45),CFrame.new(q+Vector3.new(0,1.3,0)),Enum.Material.Wood,Color3.fromRGB(105,70,40),art)end
 for _,y in ipairs({.9,2}) do p("FenceRail",Vector3.new(len,.35,.35),CFrame.lookAt((a+b)/2+Vector3.new(0,y,0),b),Enum.Material.Wood,Color3.fromRGB(112,74,42),art)end
end
fence(Vector3.new(-115,0,-115),Vector3.new(-20,0,-115));fence(Vector3.new(65,0,108),Vector3.new(120,0,108));fence(Vector3.new(65,0,108),Vector3.new(65,0,145));fence(Vector3.new(-112,0,88),Vector3.new(-112,0,145))
-- farm plots, hay bales, crates and barrels
for _,base in ipairs({Vector3.new(-70,.1,125),Vector3.new(75,.1,125),Vector3.new(-115,.1,-75)}) do
 for r=0,3 do p("FieldRow",Vector3.new(38,.12,2),CFrame.new(base+Vector3.new(0,0,r*4)),Enum.Material.Ground,Color3.fromRGB(92,70,40),art) end
 for i=1,10 do ball("Crop",base+Vector3.new(math.random(-17,17),1+math.random()/3,math.random(0,12)),Vector3.new(1.1,1.5,1.1),Enum.Material.Grass,Color3.fromRGB(55,115,45),art) end
end
for _,q in ipairs({Vector3.new(-83,1,118),Vector3.new(83,1,118),Vector3.new(-105,1,-65),Vector3.new(94,1,46)}) do p("HayBale",Vector3.new(4,2.5,2.5),CFrame.new(q),Enum.Material.Hay,Color3.fromRGB(194,160,75),art)end
for _,q in ipairs({Vector3.new(-7,1,-88),Vector3.new(8,1,-88),Vector3.new(95,1,28),Vector3.new(95,1,43)}) do p("Crate",Vector3.new(2.5,2.5,2.5),CFrame.new(q),Enum.Material.Wood,Color3.fromRGB(120,80,42),art)end
-- lamps with warm lights
for _,q in ipairs({Vector3.new(-18,0,-22),Vector3.new(22,0,-22),Vector3.new(-18,0,18),Vector3.new(22,0,18),Vector3.new(-80,0,-35),Vector3.new(80,0,70),Vector3.new(55,0,-70),Vector3.new(-55,0,75)}) do local m=Instance.new("Model",art);m.Name="VillageLamp";p("Pole",Vector3.new(.35,7,.35),CFrame.new(q+Vector3.new(0,3.5,0)),Enum.Material.Metal,Color3.fromRGB(55,55,52),m);local lamp=p("Lamp",Vector3.new(1.1,1.1,1.1),CFrame.new(q+Vector3.new(0,7,0)),Enum.Material.Glass,Color3.fromRGB(255,214,140),m,.15,false);local li=Instance.new("PointLight",lamp);li.Range=18;li.Brightness=1.4 end
-- bushes and natural foliage clusters
for i=1,90 do local x=math.random(-145,145);local z=math.random(-125,155);if math.abs(x)<25 and math.abs(z)<25 then z+=45 end;local m=Instance.new("Model",art);m.Name="BushCluster";for j=1,3 do ball("Bush",Vector3.new(x+math.random(-3,3),1+math.random(0,2),z+math.random(-3,3)),Vector3.new(4,3.2,4),Enum.Material.Grass,Color3.fromRGB(62,105,52),m)end end
-- fallen logs / woodland detail
for _,q in ipairs({Vector3.new(-125,1,-95),Vector3.new(130,1,-60),Vector3.new(125,1,120),Vector3.new(-135,1,130),Vector3.new(-95,1,145)}) do p("FallenLog",Vector3.new(8,1.2,1.2),CFrame.new(q)*CFrame.Angles(0,math.random(),0),Enum.Material.Wood,Color3.fromRGB(78,52,34),art)end
-- simple storefront frames and awnings on the two added shops
for _,name in ipairs({"VillageGeneralStore","FarmShop"}) do local m=life and WS:FindFirstChild(name) or nil end
-- atmospheric tuning
Lighting.Technology=Enum.Technology.Future;Lighting.GlobalShadows=true;Lighting.Brightness=2.2;Lighting.ExposureCompensation=.05;Lighting.EnvironmentDiffuseScale=.55;Lighting.EnvironmentSpecularScale=.7;Lighting.ClockTime=14.4
local at=Lighting:FindFirstChild("VillageArtAtmosphere") or Instance.new("Atmosphere",Lighting);at.Name="VillageArtAtmosphere";at.Density=.22;at.Offset=.1;at.Glare=.06;at.Haze=.7
local cc=Lighting:FindFirstChild("VillageArtColor") or Instance.new("ColorCorrectionEffect",Lighting);cc.Name="VillageArtColor";cc.Brightness=.01;cc.Contrast=.08;cc.Saturation=.08;cc.TintColor=Color3.fromRGB(255,250,242)
