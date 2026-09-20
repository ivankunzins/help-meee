-- SECRET VILLAGE BOOT AUDIT v3
-- Runtime diagnostics aligned with the current world-generation scripts.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
task.wait(12)
local pass,fail=0,0
local function check(label,ok)
 if ok then pass+=1;print("BOOT OK: "..label)
 else fail+=1;warn("BOOT FAIL: "..label)end
end
local rem=ReplicatedStorage:FindFirstChild("SecretVillageRemotes")
check("SecretVillageRemotes",rem~=nil)
for _,n in ipairs({"Notify","BuyHint","StartJob","EndJob","BuyFisher","SpawnVehicle","GetSecretStatus","BuyShopItem","CompleteQuest"})do
 check("Remote:"..n,rem and rem:FindFirstChild(n)~=nil)
end
local sps=game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
check("SecretVillageUI source",sps and sps:FindFirstChild("SecretVillage")~=nil)
local unified=Workspace:FindFirstChild("SECRET_VILLAGE_UNIFIED_WORLD")
local finalMaster=Workspace:FindFirstChild("SECRET_VILLAGE_FINAL_MASTER")
check("World generator",unified~=nil or finalMaster~=nil)
check("River",(unified and unified:FindFirstChild("RIVER")~=nil) or Workspace:FindFirstChild("River")~=nil)
check("Forest",(unified and unified:FindFirstChild("FOREST")~=nil) or (finalMaster and finalMaster:FindFirstChild("FOREST_PERIMETER")~=nil))
check("Bears",(unified and unified:FindFirstChild("BEARS")~=nil) or (finalMaster and finalMaster:FindFirstChild("DANGEROUS_BEAR_ZONE")~=nil))
check("Secret discoveries",Workspace:FindFirstChild("SECRET_DISCOVERIES")~=nil)
check("Quest system",rem and rem:FindFirstChild("CompleteQuest")~=nil)
check("Job system",Workspace:FindFirstChild("SECRET_JOBS")~=nil)
check("Co-op secret",Workspace:FindFirstChild("SECRET_COOP")~=nil)
local roadCount=0
for _,o in ipairs(Workspace:GetDescendants())do
 if o:IsA("BasePart") and o.Transparency<1 then
  local n=o.Name:lower()
  if n:find("road",1,true) or n:find("asphalt",1,true) or o.Material==Enum.Material.Asphalt then roadCount+=1 end
 end
end
check("No visible roads",roadCount==0)
print(string.format("SECRET VILLAGE BOOT AUDIT v3: %d PASS / %d FAIL",pass,fail))
