-- SECRET VILLAGE FINAL TERRAIN CLEANUP v2
local WS=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local folder=WS:FindFirstChild("SECRET_VILLAGE_FINAL_TERRAIN") or Instance.new("Folder",WS);folder.Name="SECRET_VILLAGE_FINAL_TERRAIN"
if folder:GetAttribute("Built") then return end
folder:SetAttribute("Built",true)
local function patch(n,s,cf,mat,col,trans)
 local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=cf;p.Anchored=true;p.CanCollide=true;p.Material=mat;p.Color=col;p.Transparency=trans or 0;p.Parent=folder;return p
end
local roadNames={MainRoad=true,CrossRoad=true,DirtVillageRoad=true,DirtVillageRoadCross=true,Road=true,RoadMark=true,CenterLine=true,Curbs=true}
for _,obj in ipairs(WS:GetDescendants()) do if obj:IsA("BasePart") and roadNames[obj.Name] then obj.Transparency=1;obj.CanCollide=false end end
-- Low meadow base: no tall decorative grass blades.
local meadows={{Vector3.new(0,-.16,0),Vector3.new(250,.28,250)},{Vector3.new(-80,-.13,70),Vector3.new(105,.24,80)},{Vector3.new(80,-.13,-65),Vector3.new(100,.24,90)}}
for i,v in ipairs(meadows) do patch("Meadow_"..i,v[2],CFrame.new(v[1]),Enum.Material.Grass,Color3.fromRGB(91,125,66)) end
local paths={{Vector3.new(-35,.02,15),Vector3.new(8,.18,105),math.rad(-18)},{Vector3.new(30,.02,25),Vector3.new(8,.18,90),math.rad(22)},{Vector3.new(-10,.02,-35),Vector3.new(95,.18,7),math.rad(4)}}
for i,v in ipairs(paths) do patch("NaturalFootpath_"..i,v[2],CFrame.new(v[1])*CFrame.Angles(0,v[3],0),Enum.Material.Ground,Color3.fromRGB(126,104,72)) end
-- Remove oversized grass/foliage Parts from all visual folders, while leaving trees intact.
for _,o in ipairs(WS:GetDescendants()) do
 if o:IsA("BasePart") then
  local n=o.Name:lower()
  if (n:find("grass") or n:find("foliage")) and o.Size.Y>7 and o.Size.X<4 and o.Size.Z<4 then o:Destroy() end
 end
end
-- Remove only world labels that reveal secrets or are decorative. Interaction prompts are preserved.
for _,o in ipairs(WS:GetDescendants()) do
 if o:IsA("BillboardGui") or o:IsA("SurfaceGui") then
  local text=""
  for _,d in ipairs(o:GetDescendants()) do if d:IsA("TextLabel") or d:IsA("TextButton") then text=text.." "..d.Text:lower() end end
  if text:find("secret") or text:find("underwater") or text:find("diving area") or o.Name:lower()=="sign" then o:Destroy() end
 end
 if o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") and not game.Players:GetPlayerFromCharacter(o) then o:FindFirstChildOfClass("Humanoid").DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None end
end
Lighting.GlobalShadows=true;Lighting.Brightness=2.05;Lighting.ExposureCompensation=.02
print("SECRET VILLAGE TERRAIN CLEANUP v2 READY")