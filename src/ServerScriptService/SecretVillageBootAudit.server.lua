-- SECRET VILLAGE BOOT AUDIT v1
-- Runs after the world has had time to build and reports missing critical systems.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
task.wait(15)
local pass,fail=0,0
local function check(label,ok)
 if ok then pass+=1;print("BOOT OK: "..label) else fail+=1;warn("BOOT FAIL: "..label) end
end
local rem=ReplicatedStorage:FindFirstChild("SecretVillageRemotes")
check("SecretVillageRemotes",rem~=nil)
for _,n in ipairs({"Notify","BuyHint","StartJob","EndJob","BuyFisher","SpawnVehicle","GetSecretStatus","BuyShopItem","CompleteQuest"}) do check("Remote:"..n,rem and rem:FindFirstChild(n)~=nil) end
check("SecretVillageUI source",game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts") and game:GetService("StarterPlayer").StarterPlayerScripts:FindFirstChild("SecretVillage"))
check("World",Workspace:FindFirstChild("SECRET_VILLAGE_WORLD")~=nil or Workspace:FindFirstChild("SECRET_VILLAGE_WORLD_MASTER")~=nil)
check("Secret discoveries",Workspace:FindFirstChild("SECRET_DISCOVERIES")~=nil)
check("Final visual recovery",Workspace:FindFirstChild("SECRET_VILLAGE_PRESENTATION_RECOVERY")~=nil)
check("Forest perimeter",Workspace:FindFirstChild("SECRET_VILLAGE_FINAL_MASTER") and Workspace.SECRET_VILLAGE_FINAL_MASTER:FindFirstChild("FOREST_PERIMETER")~=nil)
check("Dangerous bears",Workspace:FindFirstChild("SECRET_VILLAGE_FINAL_MASTER") and Workspace.SECRET_VILLAGE_FINAL_MASTER:FindFirstChild("DANGEROUS_BEAR_ZONE")~=nil)
local roadCount=0
for _,o in ipairs(Workspace:GetDescendants()) do
 if o:IsA("BasePart") and o.Transparency<1 then local n=o.Name:lower();if n:find("road",1,true) or n:find("asphalt",1,true) or o.Material==Enum.Material.Asphalt then roadCount+=1 end end
end
check("No visible roads",roadCount==0)
check("Terrain water",Workspace.Terrain.WaterTransparency>=0 and Workspace.Terrain.WaterTransparency<1)
print(string.format("SECRET VILLAGE BOOT AUDIT: %d PASS / %d FAIL",pass,fail))