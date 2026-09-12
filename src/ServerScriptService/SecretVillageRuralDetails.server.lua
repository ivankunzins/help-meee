-- SECRET VILLAGE RURAL DETAILS v1
-- Visual polish layered on top of the generated village.
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local root=WS:FindFirstChild("SECRET_VILLAGE_WORLD") or WS
local folder=WS:FindFirstChild("SECRET_VILLAGE_RURAL_DETAILS") or Instance.new("Folder",WS);folder.Name="SECRET_VILLAGE_RURAL_DETAILS"
if folder:GetAttribute("Built") then return end
folder:SetAttribute("Built",true)
local function P(n,s,c,m,par,t,col,can)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=c;p.Anchored=true;p.Material=m or Enum.Material.SmoothPlastic;p.Transparency=t or 0;p.CanCollide=can~=false;if col then p.Color=col end;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=par or folder;return p
end
local function cyl(n,s,c,m,par,col)
 local p=P(n,s,c,m,par);p.Shape=Enum.PartType.Cylinder;if col then p.Color=col end;return p
end
local function ball(n,s,c,m,par,col)
 local p=P(n,s,c,m,par);p.Shape=Enum.PartType.Ball;p.CanCollide=false;if col then p.Color=col end;return p
end
local function sign(pos,text)
 local p=P("WoodenSign",Vector3.new(7,2.2,.35),CFrame.new(pos),Enum.Material.Wood);local g=Instance.new("SurfaceGui",p);g.Face=Enum.NormalId.Front;local t=Instance.new("TextLabel",g);t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.fromRGB(250,238,210)
end
local function lamp(pos)
 local f=Instance.new("Model",folder);f.Name="VillageLamp";P("Pole",Vector3.new(.35,7,.35),CFrame.new(pos+Vector3.new(0,3.5,0)),Enum.Material.Metal,f);P("Arm",Vector3.new(2,.25,.25),CFrame.new(pos+Vector3.new(.8,6.7,0)),Enum.Material.Metal,f);local l=P("Lantern",Vector3.new(.7,.9,.7),CFrame.new(pos+Vector3.new(1.6,6.35,0)),Enum.Material.Glass,f,.05);local light=Instance.new("PointLight",l);light.Range=18;light.Brightness=1.6
end
local function fence(a,b)
 local d=b-a;local len=d.Magnitude;local mid=(a+b)/2;local f=Instance.new("Model",folder);f.Name="WoodFence";P("Rail",Vector3.new(len,.3,.3),CFrame.lookAt(mid,mid+d),Enum.Material.Wood,f);for i=0,math.floor(len/4)do local q=a+d.Unit*math.min(i*4,len);P("Post",Vector3.new(.35,2.2,.35),CFrame.new(q+Vector3.new(0,1.1,0)),Enum.Material.Wood,f)end
end
local function flower(pos)
 local f=Instance.new("Model",folder);f.Name="FlowerPatch";for i=1,7 do local p=pos+Vector3.new(math.random(-3,3),.25,math.random(-2,2));cyl("Stem",Vector3.new(.12,.7,.12),CFrame.new(p+Vector3.new(0,.35,0)),Enum.Material.Grass,f);ball("Flower",Vector3.new(.5,.5,.5),CFrame.new(p+Vector3.new(0,.75,0)),Enum.Material.Neon,f,Color3.fromHSV(math.random(),.55,1))end end
local function rock(pos,s)
 local p=P("RiverRock",Vector3.new(s,math.max(.5,s*.45),s*.75),CFrame.new(pos)*CFrame.Angles(0,math.random(),math.random()*.3),Enum.Material.Slate);p.Shape=Enum.PartType.Ball;p.CanCollide=true
end
local function bench(pos)
 local f=Instance.new("Model",folder);f.Name="VillageBench";P("Seat",Vector3.new(5,.35,1.3),CFrame.new(pos+Vector3.new(0,1.5,0)),Enum.Material.Wood,f);for _,x in ipairs({-1.8,1.8})do P("Leg",Vector3.new(.3,1.5,.3),CFrame.new(pos+Vector3.new(x,.75,0)),Enum.Material.Wood,f)end;P("Back",Vector3.new(5,1.4,.3),CFrame.new(pos+Vector3.new(0,2.25,.55)),Enum.Material.Wood,f)end
local function cart(pos)
 local f=Instance.new("Model",folder);f.Name="FarmCart";P("Bed",Vector3.new(5,1,3),CFrame.new(pos+Vector3.new(0,1.2,0)),Enum.Material.Wood,f);for _,x in ipairs({-2,2})do cyl("Wheel",Vector3.new(.35,2,2),CFrame.new(pos+Vector3.new(x,1,0))*CFrame.Angles(0,0,math.pi/2),Enum.Material.Wood,f)end;P("Handle",Vector3.new(3,.25,.25),CFrame.new(pos+Vector3.new(3.2,1.8,0)),Enum.Material.Wood,f)end
-- remove the old visual road surfaces; leave game roads entirely dirt.
for _,n in ipairs({"MainRoad","CrossRoad"})do local p=root:FindFirstChild(n);if p then p.Transparency=1;p.CanCollide=false end end
-- village landmarks and natural clutter
for _,p in ipairs({Vector3.new(-95,0,-50),Vector3.new(-55,0,-70),Vector3.new(10,0,-72),Vector3.new(65,0,-65),Vector3.new(100,0,-20),Vector3.new(95,0,60),Vector3.new(55,0,108),Vector3.new(-10,0,112),Vector3.new(-70,0,105),Vector3.new(-112,0,55),Vector3.new(-112,0,-5)})do flower(p)end
for _,p in ipairs({Vector3.new(-5,0,-15),Vector3.new(15,0,-15),Vector3.new(50,0,15),Vector3.new(55,0,50),Vector3.new(-20,0,15),Vector3.new(-65,0,20),Vector3.new(-85,0,50),Vector3.new(-20,0,-65)})do bench(p)end
for _,p in ipairs({Vector3.new(-90,0,42),Vector3.new(-75,0,42),Vector3.new(-55,0,42),Vector3.new(-35,0,42),Vector3.new(-15,0,42),Vector3.new(5,0,42),Vector3.new(25,0,42)})do rock(p,math.random(1,3))end
for _,p in ipairs({Vector3.new(-105,0,-25),Vector3.new(-105,0,5),Vector3.new(80,0,-80),Vector3.new(110,0,5),Vector3.new(110,0,90),Vector3.new(35,0,115),Vector3.new(-45,0,115),Vector3.new(-120,0,90)})do lamp(p)end
fence(Vector3.new(-100,0,88),Vector3.new(-45,0,88));fence(Vector3.new(-45,0,88),Vector3.new(-45,0,118));fence(Vector3.new(35,0,88),Vector3.new(85,0,88));fence(Vector3.new(85,0,88),Vector3.new(85,0,118));fence(Vector3.new(-105,0,-90),Vector3.new(-45,0,-90))
cart(Vector3.new(5,0,72));cart(Vector3.new(75,0,105));sign(Vector3.new(-10,4,-72),"ДЕРЕВЕНСКИЙ МАГАЗИН");sign(Vector3.new(105,4,25),"ФЕРМЕРСКАЯ ЛАВКА")
-- warm village ambience
local bloom=Lighting:FindFirstChild("VillageSoftBloom") or Instance.new("BloomEffect",Lighting);bloom.Name="VillageSoftBloom";bloom.Intensity=.12;bloom.Size=22;bloom.Threshold=1.05
local cc=Lighting:FindFirstChild("VillageWarmGrade") or Instance.new("ColorCorrectionEffect",Lighting);cc.Name="VillageWarmGrade";cc.Brightness=.01;cc.Contrast=.1;cc.Saturation=.08;cc.TintColor=Color3.fromRGB(255,248,235)
