-- SECRET VILLAGE HERO PROPS v1
-- Hero-object pass: fountain, bridge, dock, storefronts, secret entrance and trader.
-- Visual-only. Existing gameplay systems are untouched.
local Workspace=game:GetService("Workspace")
local world=Workspace:WaitForChild("SECRET_VILLAGE_WORLD")
local art=world:FindFirstChild("GRAPHICS_HERO_PROPS") or Instance.new("Folder")
art.Name="GRAPHICS_HERO_PROPS";art.Parent=world
if art:GetAttribute("Built") then return end
art:SetAttribute("Built",true)

local function part(name,size,cf,mat,color,parent,collide)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true;p.CanTouch=false;p.CanQuery=false
 p.CanCollide=collide~=false;p.Material=mat or Enum.Material.SmoothPlastic
 if color then p.Color=color end
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent or art;return p
end
local function cyl(name,r,h,cf,mat,color,parent)
 local p=part(name,Vector3.new(r*2,h,r*2),cf,mat,color,parent,false);p.Shape=Enum.PartType.Cylinder;return p
end
local function ball(name,s,cf,mat,color,parent)
 local p=part(name,Vector3.new(s,s,s),cf,mat,color,parent,false);p.Shape=Enum.PartType.Ball;return p
end
local function light(parent,color,b,range)
 local l=Instance.new("PointLight");l.Color=color;l.Brightness=b;l.Range=range;l.Shadows=true;l.Parent=parent;return l
end
local function label(parent,text)
 local g=Instance.new("BillboardGui");g.Size=UDim2.fromOffset(180,36);g.StudsOffset=Vector3.new(0,3.2,0);g.AlwaysOnTop=true;g.Parent=parent
 local t=Instance.new("TextLabel");t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.fromRGB(245,235,215);t.TextStrokeTransparency=.55;t.Parent=g
end
local wood=Color3.fromRGB(103,72,46);local dark=Color3.fromRGB(47,43,38);local stone=Color3.fromRGB(125,122,112)
local green=Color3.fromRGB(63,101,49);local green2=Color3.fromRGB(92,128,65);local water=Color3.fromRGB(73,157,184)
local warm=Color3.fromRGB(255,205,142);local brass=Color3.fromRGB(173,132,65);local glass=Color3.fromRGB(91,160,178)

-- FOUNTAIN: layered basin, inner bowl and four water jets.
do
 local f=Instance.new("Folder");f.Name="HeroFountain";f.Parent=art
 cyl("Base",5.2,.45,CFrame.new(25,.65,-45),Enum.Material.Marble,stone,f)
 cyl("Basin",4.5,.38,CFrame.new(25,.93,-45),Enum.Material.Marble,Color3.fromRGB(151,149,140),f)
 cyl("WaterSurface",3.9,.12,CFrame.new(25,1.15,-45),Enum.Material.Glass,water,f)
 cyl("Pedestal",1.25,2.1,CFrame.new(25,1.95,-45),Enum.Material.Marble,stone,f)
 cyl("UpperBowl",2.05,.3,CFrame.new(25,3.05,-45),Enum.Material.Marble,Color3.fromRGB(151,149,140),f)
 for _,v in ipairs({{25,3.55,-45},{25,1.35,-45}}) do
  local q=ball("WaterGlow",.28,CFrame.new(v[1],v[2],v[3]),Enum.Material.Neon,water,f);light(q,water,.35,5)
 end
 for i=1,4 do
  local a=i*math.pi/2;local q=part("WaterJet",Vector3.new(.12,2.4,.12),CFrame.new(25+math.cos(a)*1.2,2.1,-45+math.sin(a)*1.2)*CFrame.Angles(math.rad(12),0,math.rad(12)),Enum.Material.Neon,water,f,false)
 end
 label(f:FindFirstChild("Base"),"VILLAGE FOUNTAIN")
end

-- BRIDGE: wooden deck, side beams, posts and rails.
do
 local f=Instance.new("Folder");f.Name="HeroBridge";f.Parent=art
 for x=-42,-28,2 do part("DeckPlank",Vector3.new(1.8,.28,37),CFrame.new(x,1.45,58),Enum.Material.WoodPlanks,wood,f) end
 for _,x in ipairs({-44,-27}) do
  for z=42,74,8 do
   cyl("RailPost",.16,2.4,CFrame.new(x,2.5,z),Enum.Material.Wood,dark,f)
  end
  part("RailTop",Vector3.new(.22, .22, 37),CFrame.new(x,3.65,58),Enum.Material.Wood,dark,f)
 end
 part("BridgeBeam",Vector3.new(19,.35,2),CFrame.new(-35,1.05,42),Enum.Material.Wood,dark,f)
 part("BridgeBeam",Vector3.new(19,.35,2),CFrame.new(-35,1.05,74),Enum.Material.Wood,dark,f)
end

-- DOCK: planks, cleats, posts and a small lantern.
do
 local f=Instance.new("Folder");f.Name="HeroDock";f.Parent=art
 for x=-96,-74,2 do part("DockPlank",Vector3.new(1.8,.25,8),CFrame.new(x,.98,58),Enum.Material.WoodPlanks,wood,f) end
 for _,x in ipairs({-96,-88,-80,-74}) do
  cyl("DockPost",.18,2.4,CFrame.new(x,.1,58),Enum.Material.Wood,dark,f)
 end
 for _,x in ipairs({-92,-78}) do
  local c=cyl("MooringCleat",.12,.7,CFrame.new(x,1.35,58),Enum.Material.Metal,brass,f)
  c.Shape=Enum.PartType.Cylinder
 end
 local lantern=part("DockLantern",Vector3.new(.45,.7,.45),CFrame.new(-85,2.15,58),Enum.Material.Glass,warm,f,false);light(lantern,warm,.9,9)
end

-- SHOPFRONTS: projecting signboards, door frames, steps and window mullions.
local function storefront(x,z,title,s)
 local f=Instance.new("Folder");f.Name=title.."HeroFront";f.Parent=art
 local w=18*s;local d=16*s
 part("FacadeTrim",Vector3.new(w+.5,.28,.25),CFrame.new(x,9.85*s,z-d/2-.2),Enum.Material.Wood,dark,f,false)
 part("DoorFrameL",Vector3.new(.22,7*s,.35),CFrame.new(x-2.25*s,3.5*s,z-d/2-.45),Enum.Material.Wood,dark,f,false)
 part("DoorFrameR",Vector3.new(.22,7*s,.35),CFrame.new(x+2.25*s,3.5*s,z-d/2-.45),Enum.Material.Wood,dark,f,false)
 part("DoorHeader",Vector3.new(4.7*s,.22,.35),CFrame.new(x,7*s,z-d/2-.45),Enum.Material.Wood,dark,f,false)
 for sx=-1,1,2 do part("Step",Vector3.new(3*s,.18,.7*s),CFrame.new(x+sx*5*s,.25,z-d/2-.75),Enum.Material.Slate,stone,f,false) end
 local board=part("Signboard",Vector3.new(7*s,1.5*s,.18),CFrame.new(x,8.15*s,z-d/2-1.05),Enum.Material.Wood,wood,f,false)
 label(board,title)
 for sx=-1,1,2 do
  local win=part("WindowMullionV",Vector3.new(.12,2.8*s,.12),CFrame.new(x+sx*5*s,6*s,z-d/2-.48),Enum.Material.Wood,dark,f,false)
  part("WindowMullionH",Vector3.new(4*s,.12,.12),CFrame.new(x+sx*5*s,6*s,z-d/2-.48),Enum.Material.Wood,dark,f,false)
 end
end
storefront(55,-5,"BAKERY",1)
storefront(90,45,"VILLAGE SHOP",.9)

-- SECRET ENTRANCE: metal frame, bolts, warning lamps and a visible underwater hatch glow.
do
 local f=Instance.new("Folder");f.Name="HeroUnderwaterEntrance";f.Parent=art
 local x,z=-45,65
 part("DoorFrameTop",Vector3.new(11,.5,.5),CFrame.new(x,-3,z-0.65),Enum.Material.Metal,dark,f,false)
 part("DoorFrameL",Vector3.new(.5,8,.5),CFrame.new(x-5,-3,z-0.65),Enum.Material.Metal,dark,f,false)
 part("DoorFrameR",Vector3.new(.5,8,.5),CFrame.new(x+5,-3,z-0.65),Enum.Material.Metal,dark,f,false)
 for _,v in ipairs({{-3.8,-5.5},{3.8,-5.5},{-3.8,-.5},{3.8,-.5}}) do
  cyl("Bolt",.14,.12,CFrame.new(x+v[1],v[2],z-1.05)*CFrame.Angles(math.rad(90),0,0),Enum.Material.Metal,brass,f)
 end
 local glow=part("HatchGlow",Vector3.new(7,5,.08),CFrame.new(x,-3,z-1.12),Enum.Material.Neon,Color3.fromRGB(57,157,183),f,false);light(glow,Color3.fromRGB(57,157,183),1.2,12)
 label(glow,"UNDERWATER")
end

-- WANDERING TRADER: stall, canopy, crates and lantern around the existing NPC marker.
do
 local f=Instance.new("Folder");f.Name="HeroTraderStall";f.Parent=art
 local x,z=105,-75
 part("Table",Vector3.new(9,.3,3),CFrame.new(x,.95,z),Enum.Material.Wood,wood,f)
 for _,sx in ipairs({-3.6,3.6}) do for _,zz in ipairs({-1,1}) do part("Leg",Vector3.new(.18,1.7,.18),CFrame.new(x+sx,.1,z+zz),Enum.Material.Wood,dark,f,false) end end
 part("Canopy",Vector3.new(11,.25,5),CFrame.new(x,6,z),Enum.Material.Fabric,Color3.fromRGB(92,69,53),f,false)
 for _,sx in ipairs({-5,5}) do cyl("CanopyPost",.12,5,CFrame.new(x+sx,3.5,z),Enum.Material.Wood,dark,f) end
 for i=1,5 do
  local bx=x-3.5+i*1.5
  part("Goods",Vector3.new(1.1,.7,1),CFrame.new(bx,1.45,z),Enum.Material.Wood,Color3.fromRGB(133,99,62),f,false)
 end
 local lantern=part("TraderLantern",Vector3.new(.5,.7,.5),CFrame.new(x+4.2,3.8,z+1.8),Enum.Material.Glass,warm,f,false);light(lantern,warm,1,10)
 label(part("StallSign",Vector3.new(5,1.1,.15),CFrame.new(x,6.8,z-2.5),Enum.Material.Wood,wood,f,false),"RARE GOODS")
end

print("[SecretVillageHeroProps] Hero landmarks visual pass initialized")