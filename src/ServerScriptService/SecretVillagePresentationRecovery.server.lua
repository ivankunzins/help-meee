-- SECRET VILLAGE PRESENTATION RECOVERY v2
-- Authoritative visual recovery: houses, river, forest visibility and hidden secrets.
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local Terrain=WS.Terrain

task.wait(6)
local root=WS:FindFirstChild("SECRET_VILLAGE_PRESENTATION_RECOVERY") or Instance.new("Folder",WS);root.Name="SECRET_VILLAGE_PRESENTATION_RECOVERY"
if root:GetAttribute("Built") then return end
root:SetAttribute("Built",true)

local function P(n,s,pos,mat,col,par,trans)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=CFrame.new(pos);p.Anchored=true;p.Material=mat or Enum.Material.Wood;p.Color=col or Color3.fromRGB(110,85,60);p.Transparency=trans or 0;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=par or root;return p
end
local function ball(n,s,pos,mat,col,par)
 local p=P(n,s,pos,mat,col,par);p.Shape=Enum.PartType.Ball;p.CanCollide=false;return p
end
local function roof(m,cx,cz,w,d,y)
 local a=P("RoofL",Vector3.new(w/2,d,4),Vector3.new(cx-w/4,y,cz),Enum.Material.Slate,Color3.fromRGB(61,58,55),m);a.CFrame=a.CFrame*CFrame.Angles(0,0,math.rad(9))
 local b=P("RoofR",Vector3.new(w/2,d,4),Vector3.new(cx+w/4,y,cz),Enum.Material.Slate,Color3.fromRGB(61,58,55),m);b.CFrame=b.CFrame*CFrame.Angles(0,0,math.rad(-9))
end
local function window(m,x,y,z)
 P("WindowFrame",Vector3.new(3,.22,2.5),Vector3.new(x,y,z),Enum.Material.Wood,Color3.fromRGB(73,58,44),m)
 P("WindowGlass",Vector3.new(2.55,.12,2.05),Vector3.new(x,y,z-.16),Enum.Material.Glass,Color3.fromRGB(125,177,190),m,.08)
 P("Mullion",Vector3.new(.12,.2,2.05),Vector3.new(x,y,z-.25),Enum.Material.Wood,Color3.fromRGB(73,58,44),m)
end
local function cottage(name,pos,w,d,wall)
 local existing=WS:FindFirstChild(name,true)
 if existing and existing:IsA("Model") then return existing end
 local m=Instance.new("Model");m.Name=name;m.Parent=root
 P("Foundation",Vector3.new(w+1,.45,d+1),Vector3.new(pos.X,.25,pos.Z),Enum.Material.Slate,Color3.fromRGB(72,72,67),m)
 P("Body",Vector3.new(w,7,d),Vector3.new(pos.X,3.7,pos.Z),Enum.Material.WoodPlanks,wall,m)
 P("FrontPorch",Vector3.new(math.min(10,w*.65),.3,2.6),Vector3.new(pos.X,.55,pos.Z-d/2-1.1),Enum.Material.WoodPlanks,Color3.fromRGB(121,87,55),m)
 P("Door",Vector3.new(2.2,3.5,.2),Vector3.new(pos.X,2.25,pos.Z-d/2-.12),Enum.Material.Wood,Color3.fromRGB(91,62,45),m)
 window(m,pos.X-w*.25,4.2,pos.Z-d/2-.14);window(m,pos.X+w*.25,4.2,pos.Z-d/2-.14)
 for dx=-3,3,6 do P("Post",Vector3.new(.22,2.7,.22),Vector3.new(pos.X+dx*.5,1.9,pos.Z-d/2-2),Enum.Material.Wood,Color3.fromRGB(78,56,41),m) end
 P("Eave",Vector3.new(w+1,.25,.35),Vector3.new(pos.X,7.05,pos.Z-d/2-.15),Enum.Material.Wood,Color3.fromRGB(68,55,43),m)
 roof(m,pos.X,pos.Z,w+1,d+1,8.7)
 P("Chimney",Vector3.new(1.5,2.8,1.5),Vector3.new(pos.X+w*.25,9.8,pos.Z+.5),Enum.Material.Brick,Color3.fromRGB(126,77,59),m)
 return m
end

-- Remove the oversized foreground grass objects that swallowed the camera view.
for _,f in ipairs({WS:FindFirstChild("FINAL_ART_PASS"),WS:FindFirstChild("SECRET_VILLAGE_FINAL_TERRAIN")}) do
 if f then
  for _,o in ipairs(f:GetDescendants()) do
   if o:IsA("BasePart") and (o.Name=="GrassPatch" or o.Name=="MeadowMound") then o:Destroy() end
  end
 end
end
for _,o in ipairs(WS:GetDescendants()) do
 if o:IsA("BasePart") then
  local n=o.Name:lower()
  if (n:find("grass") or n:find("foliage")) and o.Size.Y>7 and o.Size.X<4 and o.Size.Z<4 then o:Destroy() end
 end
end
Terrain.GrassLength=.08

-- If the normal village houses were hidden/missing, provide a coherent set of visible cottages.
cottage("RecoveryHouse1",Vector3.new(-48,0,-25),18,14,Color3.fromRGB(174,132,91))
cottage("RecoveryHouse2",Vector3.new(8,0,-20),20,15,Color3.fromRGB(154,116,83))
cottage("RecoveryHouse3",Vector3.new(55,0,10),18,14,Color3.fromRGB(188,146,104))
cottage("RecoveryHouse4",Vector3.new(90,0,45),21,16,Color3.fromRGB(165,126,91))
cottage("RecoveryHouse5",Vector3.new(-70,0,-60),20,15,Color3.fromRGB(180,137,96))
cottage("RecoveryHouse6",Vector3.new(25,0,70),18,14,Color3.fromRGB(159,120,86))

-- Authoritative visible river on the east side of the village.
local river=WS:FindFirstChild("SECRET_VILLAGE_RIVER_RECOVERY") or Instance.new("Folder",WS);river.Name="SECRET_VILLAGE_RIVER_RECOVERY"
if not river:GetAttribute("Built") then
 river:SetAttribute("Built",true)
 Terrain:FillBlock(CFrame.new(72,-1,45),Vector3.new(42,2,170),Enum.Material.Water)
 Terrain:FillBlock(CFrame.new(35,-1,45),Vector3.new(25,2,75),Enum.Material.Water)
 for z=-35,120,10 do
  local side=(z%20==0) and -1 or 1
  local x=49+side*20
  ball("BankRock",Vector3.new(4,1.4,3),Vector3.new(x,.6,z),Enum.Material.Slate,Color3.fromRGB(94,101,95),river)
 end
 for i=1,22 do
  local z=-25+i*6
  P("Reed",Vector3.new(.12,3,.12),Vector3.new(48+(i%3)*3,1.5,z),Enum.Material.Grass,Color3.fromRGB(59,104,57),river).CanCollide=false
 end
 local bridge=P("Bridge",Vector3.new(14,.5,26),Vector3.new(48,2,45),Enum.Material.WoodPlanks,Color3.fromRGB(112,78,50),river)
 for z=33,57,6 do
  P("RailPost",Vector3.new(.35,3,.35),Vector3.new(42,3.3,z),Enum.Material.Wood,Color3.fromRGB(78,55,40),river)
  P("RailPost",Vector3.new(.35,3,.35),Vector3.new(54,3.3,z),Enum.Material.Wood,Color3.fromRGB(78,55,40),river)
 end
 P("Rail",Vector3.new(.3,1.1,26),Vector3.new(42,4.2,45),Enum.Material.Wood,Color3.fromRGB(78,55,40),river)
 P("Rail",Vector3.new(.3,1.1,26),Vector3.new(54,4.2,45),Enum.Material.Wood,Color3.fromRGB(78,55,40),river)
end

-- Secrets remain completely hidden in the world. Only the interaction prompts survive.
local secret=WS:FindFirstChild("SECRET_DISCOVERIES")
if secret then
 for _,o in ipairs(secret:GetDescendants()) do
  if o:IsA("BillboardGui") or o:IsA("SurfaceGui") then o:Destroy() end
  if o:IsA("TextLabel") or o:IsA("TextButton") then o.Visible=false end
  if o:IsA("BasePart") and (o.Name=="SecretMarker" or o.Name=="SecretSign" or o.Name=="SecretLabel") then o.Transparency=1;o.CanCollide=false end
 end
end

-- No decorative world labels. Hide NPC display names without touching player characters.
for _,o in ipairs(WS:GetDescendants()) do
 if o:IsA("BillboardGui") or o:IsA("SurfaceGui") then
  local n=o.Name:lower()
  if n:find("secret") or n=="sign" or n=="rolelabel" or n=="label" or n:find("name") then o:Destroy() end
 end
 if o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(o) then
  local h=o:FindFirstChildOfClass("Humanoid");h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
 end
end

Terrain.WaterColor=Color3.fromRGB(39,126,165);Terrain.WaterTransparency=.16;Terrain.WaterReflectance=.3;Terrain.WaterWaveSize=.16;Terrain.WaterWaveSpeed=6
Lighting.GlobalShadows=true;Lighting.Brightness=2.05;Lighting.ExposureCompensation=.02
print("SECRET VILLAGE PRESENTATION RECOVERY v2: houses + river + hidden secrets + clean world labels READY")
