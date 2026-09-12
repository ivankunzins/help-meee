-- SECRET VILLAGE RURAL DETAIL v1
-- Deep environmental pass: farms, yards, barns, windmill, ponds, fences, props and village clutter.
local WS=game:GetService("Workspace")
local life=WS:FindFirstChild("SECRET_VILLAGE_LIFE") or Instance.new("Folder",WS);life.Name="SECRET_VILLAGE_LIFE"
local detail=WS:FindFirstChild("SECRET_VILLAGE_RURAL_DETAIL") or Instance.new("Folder",WS);detail.Name="SECRET_VILLAGE_RURAL_DETAIL"
local function P(n,s,c,m,par,t,col)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=c;p.Anchored=true;p.CanCollide=true;p.Material=m or Enum.Material.SmoothPlastic;p.Transparency=t or 0;if col then p.Color=col end;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=par or detail;return p
end
local function ball(n,pos,size,mat,col,par)
 local p=P(n,size,CFrame.new(pos),mat,par,nil,col);p.Shape=Enum.PartType.Ball;p.CanCollide=false;return p
end
local function sign(pos,text,size)
 local p=P("VillageSign",Vector3.new(size or 7,2,.35),CFrame.new(pos),Enum.Material.Wood,detail,nil,Color3.fromRGB(91,64,39));local g=Instance.new("SurfaceGui",p);g.Face=Enum.NormalId.Front;local l=Instance.new("TextLabel",g);l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=text;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.TextColor3=Color3.new(1,1,1);return p
end
local function fence(a,b,step)
 step=step or 5;local d=b-a;local len=d.Magnitude;local dir=d.Unit
 for x=0,len,step do local q=a+dir*x;P("FencePost",Vector3.new(.45,2.2,.45),CFrame.new(q+Vector3.new(0,1.1,0)),Enum.Material.Wood,detail);if x<len then P("FenceRail",Vector3.new(step,.28,.28),CFrame.lookAt(q+Vector3.new(0,1.4,0),q+dir*step),Enum.Material.Wood,detail)end end
end
local function barn(pos,name)
 local m=Instance.new("Model",detail);m.Name=name
 P("BarnBody",Vector3.new(20,9,16),CFrame.new(pos+Vector3.new(0,4.5,0)),Enum.Material.WoodPlanks,m,nil,Color3.fromRGB(125,76,49))
 P("BarnRoof",Vector3.new(23,2.4,18),CFrame.new(pos+Vector3.new(0,10,0)),Enum.Material.WoodPlanks,m,nil,Color3.fromRGB(73,61,50))
 P("BarnDoor",Vector3.new(7,7,.4),CFrame.new(pos+Vector3.new(0,3.5,-8.2)),Enum.Material.Wood,m,nil,Color3.fromRGB(92,57,38))
 for _,x in ipairs({-6,6})do P("BarnWindow",Vector3.new(3,2.5,.3),CFrame.new(pos+Vector3.new(x,5,-8.3)),Enum.Material.Glass,m)end
end
local function silo(pos)
 local m=Instance.new("Model",detail);m.Name="FarmSilo";local body=P("Silo",Vector3.new(7,12,7),CFrame.new(pos+Vector3.new(0,6,0)),Enum.Material.Metal,m,nil,Color3.fromRGB(150,150,145));body.Shape=Enum.PartType.Cylinder;P("SiloRoof",Vector3.new(7.5,2,7.5),CFrame.new(pos+Vector3.new(0,12.5,0)),Enum.Material.Metal,m,nil,Color3.fromRGB(105,105,100));end
local function well(pos)
 local m=Instance.new("Model",detail);m.Name="VillageWell";P("StoneRing",Vector3.new(5,1.2,5),CFrame.new(pos+Vector3.new(0,.6,0)),Enum.Material.Cobblestone,m);P("Water",Vector3.new(3.5,.15,3.5),CFrame.new(pos+Vector3.new(0,1.25,0)),Enum.Material.Water,m,.05);for _,x in ipairs({-2,2})do P("Post",Vector3.new(.45,4,.45),CFrame.new(pos+Vector3.new(x,3,0)),Enum.Material.Wood,m)end;P("Beam",Vector3.new(5,.4,.4),CFrame.new(pos+Vector3.new(0,5,0)),Enum.Material.Wood,m);end
local function windmill(pos)
 local m=Instance.new("Model",detail);m.Name="VillageWindmill";P("Tower",Vector3.new(4,18,4),CFrame.new(pos+Vector3.new(0,9,0)),Enum.Material.WoodPlanks,m,nil,Color3.fromRGB(126,93,65));P("Top",Vector3.new(6,4,6),CFrame.new(pos+Vector3.new(0,19,0)),Enum.Material.Wood,m);local hub=Vector3.new(pos.X,pos.Y+19,pos.Z-3.2);for i=0,3 do local a=i*math.pi/2;local x=math.cos(a)*7;local y=math.sin(a)*7;P("Blade",Vector3.new(.55,8,.35),CFrame.new(hub+Vector3.new(x,y,0))*CFrame.Angles(0,0,-a),Enum.Material.Wood,m)end end
local function flowerbed(pos,w,d)
 P("FlowerBed",Vector3.new(w,.25,d),CFrame.new(pos+Vector3.new(0,.13,0)),Enum.Material.Ground,detail,nil,Color3.fromRGB(77,58,42));for x=-w/2+1,w/2-1,2 do for z=-d/2+1,d/2-1,2 do ball("Flower",pos+Vector3.new(x,.7,z),Vector3.new(.65,.65,.65),Enum.Material.SmoothPlastic,Color3.fromHSV(math.random(),.7,1),detail)end end
end
local function cart(pos)
 local m=Instance.new("Model",detail);m.Name="FarmCart";P("Bed",Vector3.new(5,1.2,3),CFrame.new(pos+Vector3.new(0,1.7,0)),Enum.Material.Wood,m);for _,x in ipairs({-2,2})do for _,z in ipairs({-1.3,1.3})do local w=ball("Wheel",pos+Vector3.new(x,1.2,z),Vector3.new(1.6,1.6,.45),Enum.Material.Wood,Color3.fromRGB(65,48,34),m);w.Shape=Enum.PartType.Cylinder;w.Orientation=Vector3.new(0,90,0)end end;end
local function lamp(pos)
 local m=Instance.new("Model",detail);m.Name="VillageLamp";P("Pole",Vector3.new(.3,5,.3),CFrame.new(pos+Vector3.new(0,2.5,0)),Enum.Material.Metal,m,nil,Color3.fromRGB(45,45,42));local l=P("Lantern",Vector3.new(1,1,1),CFrame.new(pos+Vector3.new(0,5.2,0)),Enum.Material.Glass,m,.05);local pl=Instance.new("PointLight",l);pl.Range=18;pl.Brightness=1.3;pl.Shadows=true;end
local function rock(pos,s)
 s=s or math.random(7,14)/10;local p=ball("Rock",pos+Vector3.new(0,s*.25,0),Vector3.new(s*2,s,s*1.5),Enum.Material.Slate,Color3.fromRGB(100+math.random(0,30),100+math.random(0,25),95+math.random(0,25)),detail);p.Shape=Enum.PartType.Ball;p.Orientation=Vector3.new(math.random(0,30),math.random(0,180),math.random(0,30))end
if detail:GetAttribute("Built") then return end
detail:SetAttribute("Built",true)
-- farm district
barn(Vector3.new(-72,0,108),"RedBarn");barn(Vector3.new(70,0,108),"SheepBarn");silo(Vector3.new(-52,0,108));silo(Vector3.new(88,0,105));
fence(Vector3.new(-105,0,85),Vector3.new(-45,0,85));fence(Vector3.new(-105,0,85),Vector3.new(-105,0,125));fence(Vector3.new(-45,0,85),Vector3.new(-45,0,125));fence(Vector3.new(-105,0,125),Vector3.new(-45,0,125));
fence(Vector3.new(35,0,85),Vector3.new(105,0,85));fence(Vector3.new(35,0,85),Vector3.new(35,0,125));fence(Vector3.new(105,0,85),Vector3.new(105,0,125));fence(Vector3.new(35,0,125),Vector3.new(105,0,125));
for _,p in ipairs({Vector3.new(-75,0,78),Vector3.new(-50,0,72),Vector3.new(65,0,78),Vector3.new(92,0,70),Vector3.new(0,0,-60)})do well(p)end
windmill(Vector3.new(-115,0,105));windmill(Vector3.new(125,0,110))
-- yards and village clutter
for _,p in ipairs({Vector3.new(-92,0,-70),Vector3.new(-55,0,-92),Vector3.new(28,0,-92),Vector3.new(70,0,-70),Vector3.new(110,0,0),Vector3.new(110,0,72),Vector3.new(55,0,115),Vector3.new(-20,0,112)})do flowerbed(p,10,6);cart(p+Vector3.new(6,0,4))end
for _,p in ipairs({Vector3.new(-95,0,-50),Vector3.new(-35,0,-80),Vector3.new(20,0,-65),Vector3.new(70,0,-40),Vector3.new(100,0,20),Vector3.new(80,0,65),Vector3.new(-20,0,80),Vector3.new(-85,0,45)})do lamp(p)end
for i=1,55 do rock(Vector3.new(math.random(-135,135),0,math.random(-125,130)))end
for _,d in ipairs({{Vector3.new(-10,0,-82),"GENERAL STORE"},{Vector3.new(105,0,35),"FARM SHOP"}})do sign(d[1]+Vector3.new(0,13,-9),d[2],10)end
sign(Vector3.new(0,3,4),"SECRET VILLAGE",12)
