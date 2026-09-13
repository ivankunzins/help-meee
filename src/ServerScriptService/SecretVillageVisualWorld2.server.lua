-- SECRET VILLAGE VISUAL WORLD v2
-- Second global art pass: stronger silhouettes, facade depth, farm structures,
-- village props, foliage variation and visual hierarchy.
local WS=game:GetService("Workspace")
if WS:FindFirstChild("VISUAL_WORLD_V2") then return end
local root=Instance.new("Folder");root.Name="VISUAL_WORLD_V2";root.Parent=WS
local function P(n,s,pos,mat,col,par,rot)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=CFrame.new(pos)*(rot or CFrame.new());p.Anchored=true;p.CanCollide=true;p.Material=mat or Enum.Material.Wood;p.Color=col or Color3.fromRGB(110,85,58);p.Parent=par or root;return p
end
local function C(n,r,h,pos,mat,col,par)
 local p=P(n,Vector3.new(r*2,h,r*2),pos,mat,col,par);p.Shape=Enum.PartType.Cylinder;return p
end
local wood=Color3.fromRGB(103,74,48);local dark=Color3.fromRGB(54,50,45);local stone=Color3.fromRGB(103,105,98);local leaf=Color3.fromRGB(61,91,49);local grass=Color3.fromRGB(82,110,61)
local function fence(cx,cz,w,d)
 local f=Instance.new("Folder");f.Name="RusticFence";f.Parent=root
 for x=-w/2,w/2,4 do
  P("Post",Vector3.new(.22,1.7,.22),Vector3.new(cx+x,.85,cz-d/2),Enum.Material.Wood,wood,f)
  P("Post",Vector3.new(.22,1.7,.22),Vector3.new(cx+x,.85,cz+d/2),Enum.Material.Wood,wood,f)
 end
 P("Rail",Vector3.new(w, .16,.16),Vector3.new(cx,.95,cz-d/2),Enum.Material.Wood,wood,f)
 P("Rail",Vector3.new(w, .16,.16),Vector3.new(cx,1.45,cz-d/2),Enum.Material.Wood,wood,f)
 P("Rail",Vector3.new(w, .16,.16),Vector3.new(cx,.95,cz+d/2),Enum.Material.Wood,wood,f)
 P("Rail",Vector3.new(w, .16,.16),Vector3.new(cx,1.45,cz+d/2),Enum.Material.Wood,wood,f)
end
-- Barns with large doors, roof overhang and loft openings.
local function barn(pos,name)
 local f=Instance.new("Model");f.Name=name;f.Parent=root
 local x,y,z=pos.X,pos.Y,pos.Z
 P("Body",Vector3.new(22,11,16),Vector3.new(x,y+5.5,z),Enum.Material.WoodPlanks,Color3.fromRGB(121,76,48),f)
 P("Base",Vector3.new(23,.6,17),Vector3.new(x,y+.3,z),Enum.Material.Slate,stone,f)
 P("Roof",Vector3.new(25,2.2,19),Vector3.new(x,y+12,z),Enum.Material.Slate,dark,f)
 P("RoofCap",Vector3.new(21,.35,1),Vector3.new(x,y+13,z),Enum.Material.Wood,wood,f)
 P("Door",Vector3.new(6,7,.25),Vector3.new(x,y+3.7,z-8.1),Enum.Material.Wood,Color3.fromRGB(79,51,36),f)
 for dx=-1.6,1.6,3.2 do P("DoorBrace",Vector3.new(.12,6,.12),Vector3.new(x+dx,y+3.7,z-8.3),Enum.Material.Wood,Color3.fromRGB(147,108,69),f) end
 P("Loft",Vector3.new(5,2.2,.2),Vector3.new(x,y+7.5,z-8.2),Enum.Material.Wood,Color3.fromRGB(55,48,41),f)
 for dx=-7,7,14 do P("Post",Vector3.new(.25,11,.25),Vector3.new(x+dx,y+5.5,z-8.15),Enum.Material.Wood,wood,f) end
 return f
end
barn(Vector3.new(-102,0,-102),"NorthBarn")
barn(Vector3.new(108,0,-83),"EastBarn")
fence(-102,-102,34,22);fence(108,-83,34,22)
-- Firewood shelters / stacked logs.
local function woodpile(x,z)
 local f=Instance.new("Folder");f.Name="Woodpile";f.Parent=root
 for row=0,2 do for i=0,5 do C("Log",.42,3.2,Vector3.new(x+i*.75-1.9,.5+row*.7,z),Enum.Material.Wood,Color3.fromRGB(112,77,48),f,CFrame.Angles(0,math.rad(90),0)) end end
 P("ShelterRoof",Vector3.new(5, .25,2),Vector3.new(x,.5+3*0.7,z),Enum.Material.WoodPlanks,wood,f)
end
woodpile(-84,-106);woodpile(123,-76)
-- Hay wagon: focal rustic prop.
local function wagon(x,z)
 local f=Instance.new("Model");f.Name="HayWagon";f.Parent=root
 P("Bed",Vector3.new(7,.7,3.2),Vector3.new(x,1,z),Enum.Material.WoodPlanks,wood,f)
 for dx=-2.7,2.7,5.4 do for zz=-1.1,1.1,2.2 do C("Wheel",1, .35,Vector3.new(x+dx,.85,z+zz),Enum.Material.Wood,Color3.fromRGB(72,55,40),f,CFrame.Angles(math.rad(90),0,0)) end end
 for i=1,5 do C("Hay",.7,1.4,Vector3.new(x-2.4+i*1.2,1.65,z),Enum.Material.Fabric,Color3.fromRGB(180,149,74),f,CFrame.Angles(0,math.rad(90),0)) end
end
wagon(-67,-96);wagon(92,-69)
-- Stone-lined well near the village center.
local well=Instance.new("Folder");well.Name="VillageWellFinal";well.Parent=root
C("WellBase",4.1,1,Vector3.new(25,.5,-45),Enum.Material.Slate,stone,well)
for i=1,12 do local a=i/12*math.pi*2;local x=25+math.cos(a)*3.4;local z=-45+math.sin(a)*3.4;C("Stone",.65,.9,Vector3.new(x,1,z),Enum.Material.Slate,Color3.fromRGB(121,119,108),well) end
P("RoofBeam",Vector3.new(.35,4,.35),Vector3.new(21.5,3,-45),Enum.Material.Wood,wood,well);P("RoofBeam",Vector3.new(.35,4,.35),Vector3.new(28.5,3,-45),Enum.Material.Wood,wood,well)
P("Roof",Vector3.new(9,.5,4),Vector3.new(25,5,-45),Enum.Material.WoodPlanks,Color3.fromRGB(70,54,42),well)
P("RoofTop",Vector3.new(7,.35,3),Vector3.new(25,5.45,-45),Enum.Material.Wood,wood,well)
-- Clothesline / laundry near homes gives the village life visual language.
local function clothes(x,z)
 local f=Instance.new("Folder");f.Name="Laundry";f.Parent=root
 for _,xx in ipairs({x,x+7}) do C("Pole",.12,4,Vector3.new(xx,2,z),Enum.Material.Wood,wood,f) end
 P("Line",Vector3.new(7,.05,.05),Vector3.new(x+3.5,3.4,z),Enum.Material.Metal,Color3.fromRGB(70,70,65),f)
 for i=1,5 do P("Cloth",Vector3.new(.9,1.1,.08),Vector3.new(x+i,2.9,z),Enum.Material.Fabric,Color3.fromRGB(150+((i*13)%50),140+((i*11)%50),130+((i*17)%60)),f) end
end
clothes(-57,-88);clothes(74,73)
-- Trees with trunk branching and three-level canopy, keeping counts moderate.
local forest=Instance.new("Folder");forest.Name="HeroFoliage";forest.Parent=root
math.randomseed(48122)
for i=1,48 do
 local a=math.random()*math.pi*2;local r=math.random(70,150);local x=math.cos(a)*r;local z=math.sin(a)*r
 local s=math.random(85,125)/100
 P("Trunk",Vector3.new(.8*s,6*s,.8*s),Vector3.new(x,3*s,z),Enum.Material.Wood,Color3.fromRGB(92,65,43),forest)
 P("Branch",Vector3.new(.35*s,3*s,.35*s),Vector3.new(x+.8*s,5*s,z),Enum.Material.Wood,Color3.fromRGB(92,65,43),forest,CFrame.Angles(0,0,math.rad(38)))
 for _,o in ipairs({Vector3.new(0,7,0),Vector3.new(2,6.5,0),Vector3.new(-2,6.2,1),Vector3.new(0,8,2)}) do local p=P("Canopy",Vector3.new(4.8,4.8,4.8)*s,Vector3.new(x+o.X*s,o.Y*s,z+o.Z*s),Enum.Material.Grass,leaf,forest);p.Shape=Enum.PartType.Ball;p.CanCollide=false end
end
-- Flower beds with borders, clustered rather than isolated flowers.
local function bed(x,z,w,d)
 local f=Instance.new("Folder");f.Name="FlowerBed";f.Parent=root
 P("Soil",Vector3.new(w,.16,d),Vector3.new(x,.15,z),Enum.Material.Ground,Color3.fromRGB(94,71,48),f)
 for xx=-w/2+1, w/2-1,2 do for zz=-d/2+1,d/2-1,2 do
  local stem=P("Stem",Vector3.new(.08,.45,.08),Vector3.new(x+xx,.45,z+zz),Enum.Material.Grass,grass,f);stem.CanCollide=false
  local fl=P("Flower",Vector3.new(.35,.16,.35),Vector3.new(x+xx,.7,z+zz),Enum.Material.SmoothPlastic,Color3.fromRGB(190+math.random(0,50),70+math.random(0,80),70+math.random(0,80)),f);fl.Shape=Enum.PartType.Ball;fl.CanCollide=false
 end end
end
bed(25,-28,14,5);bed(-12,-54,12,4);bed(72,39,12,4)
-- Mailboxes and barrels create believable house frontage.
for _,v in ipairs({{-94,-68},{-57,-91},{24,-101},{73,68},{110,18}}) do
 local x,z=v[1],v[2];local f=Instance.new("Folder");f.Name="HomeProp";f.Parent=root
 P("Post",Vector3.new(.18,1.5,.18),Vector3.new(x,.75,z),Enum.Material.Wood,wood,f)
 P("Mailbox",Vector3.new(1.2,.8,.7),Vector3.new(x,.95,z),Enum.Material.Metal,dark,f)
 P("Flag",Vector3.new(.06,.7,.06),Vector3.new(x+.55,1.2,z),Enum.Material.Metal,Color3.fromRGB(120,35,35),f)
 C("Barrel",.55,1,Vector3.new(x+2,.5,z),Enum.Material.Wood,wood,f)
end
print("SECRET VILLAGE: VISUAL WORLD V2 COMPLETE")