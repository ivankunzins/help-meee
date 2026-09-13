-- SECRET VILLAGE PRESENTATION RECOVERY v3
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local Terrain=WS.Terrain
task.wait(5)
local old=WS:FindFirstChild("SECRET_VILLAGE_PRESENTATION_RECOVERY")
if old then old:Destroy() end
local root=Instance.new("Folder");root.Name="SECRET_VILLAGE_PRESENTATION_RECOVERY";root:SetAttribute("Version",3);root.Parent=WS
local function P(n,s,pos,mat,col,par,trans)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=CFrame.new(pos);p.Anchored=true;p.Material=mat or Enum.Material.Wood;p.Color=col or Color3.fromRGB(110,85,60);p.Transparency=trans or 0;p.Parent=par or root;return p
end
local function roof(m,x,z,w,d,y)
 local a=P("RoofL",Vector3.new(w/2,d,4),Vector3.new(x-w/4,y,z),Enum.Material.Slate,Color3.fromRGB(62,58,55),m);a.CFrame=a.CFrame*CFrame.Angles(0,0,math.rad(10))
 local b=P("RoofR",Vector3.new(w/2,d,4),Vector3.new(x+w/4,y,z),Enum.Material.Slate,Color3.fromRGB(62,58,55),m);b.CFrame=b.CFrame*CFrame.Angles(0,0,math.rad(-10))
end
local function house(name,x,z,w,d,wall)
 local m=Instance.new("Model");m.Name=name;m.Parent=root
 P("Body",Vector3.new(w,7,d),Vector3.new(x,3.5,z),Enum.Material.WoodPlanks,wall,m)
 P("Foundation",Vector3.new(w+1,.45,d+1),Vector3.new(x,.25,z),Enum.Material.Slate,Color3.fromRGB(72,72,67),m)
 P("Door",Vector3.new(2.3,3.6,.2),Vector3.new(x,2.3,z-d/2-.12),Enum.Material.Wood,Color3.fromRGB(88,60,43),m)
 for sx in {-w*.25,w*.25} do P("Window",Vector3.new(3,.18,2.4),Vector3.new(x+sx,4.2,z-d/2-.14),Enum.Material.Glass,Color3.fromRGB(126,177,190),m,.08) end
 P("Porch",Vector3.new(math.min(10,w*.6),.3,2.5),Vector3.new(x,.55,z-d/2-1.15),Enum.Material.WoodPlanks,Color3.fromRGB(121,87,55),m)
 roof(m,x,z,w+1,d+1,8.7)
 P("Chimney",Vector3.new(1.5,2.8,1.5),Vector3.new(x+w*.25,9.8,z+.5),Enum.Material.Brick,Color3.fromRGB(126,77,59),m)
end
-- Remove the tall blade-like decorative parts that cover the camera.
for _,o in ipairs(WS:GetDescendants()) do
 if o:IsA("BasePart") then
  local n=o.Name:lower()
  if ((n:find("grass") or n:find("foliage") or n:find("tuft")) and o.Size.Y>3 and o.Size.X<5 and o.Size.Z<5) then o:Destroy() end
 end
end
Terrain.GrassLength=.08
-- Keep a compact village silhouette visible from spawn.
house("RecoveryCottageA",-45,-28,18,14,Color3.fromRGB(176,133,92))
house("RecoveryCottageB",-8,-32,20,15,Color3.fromRGB(158,118,84))
house("RecoveryCottageC",32,-18,18,14,Color3.fromRGB(188,146,104))
house("RecoveryCottageD",72,8,21,16,Color3.fromRGB(165,126,91))
house("RecoveryCottageE",-72,-58,20,15,Color3.fromRGB(180,137,96))
house("RecoveryCottageF",18,55,18,14,Color3.fromRGB(159,120,86))
-- Visible river corridor with a safe riverbed.
local river=WS:FindFirstChild("SECRET_VILLAGE_RIVER_RECOVERY") or Instance.new("Folder",WS);river.Name="SECRET_VILLAGE_RIVER_RECOVERY"
if not river:GetAttribute("Built") then
 river:SetAttribute("Built",true)
 Terrain:FillBlock(CFrame.new(72,-1,45),Vector3.new(40,2,170),Enum.Material.Water)
 Terrain:FillBlock(CFrame.new(45,-1,45),Vector3.new(22,2,80),Enum.Material.Water)
 local bed=P("RiverBed",Vector3.new(40,.8,170),Vector3.new(72,-2.8,45),Enum.Material.Slate,Color3.fromRGB(64,72,67),river)
 bed.CanCollide=true
end
-- Secret clues are hidden; only prompts from the secret system remain.
local secret=WS:FindFirstChild("SECRET_DISCOVERIES")
if secret then for _,o in ipairs(secret:GetDescendants()) do
 if o:IsA("BillboardGui") or o:IsA("SurfaceGui") then o:Destroy() end
 if o:IsA("BasePart") and (o.Name=="SecretMarker" or o.Name=="SecretSign" or o.Name=="SecretLabel") then o.Transparency=1;o.CanCollide=false end
end end
-- Hide world text that exposes secret locations; do not touch the player HUD.
for _,o in ipairs(WS:GetDescendants()) do
 if o:IsA("BillboardGui") or o:IsA("SurfaceGui") then
  local text=""
  for _,d in ipairs(o:GetDescendants()) do if d:IsA("TextLabel") or d:IsA("TextButton") then text=text.." "..d.Text:lower() end end
  if text:find("secret") or text:find("underwater") or text:find("diving area") or o.Name:lower()=="sign" then o:Destroy() end
 end
 if o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(o) then o:FindFirstChildOfClass("Humanoid").DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None end
end
Lighting.GlobalShadows=true;Lighting.Brightness=2.05;Lighting.ExposureCompensation=.02
print("SECRET VILLAGE PRESENTATION RECOVERY v3 READY: houses + river + hidden secrets")