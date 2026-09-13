-- SECRET VILLAGE BOOT AUDIT v2
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
task.wait(12)
local pass,fail=0,0
local function check(label,ok)if ok then pass+=1;print("BOOT OK: "..label)else fail+=1;warn("BOOT FAIL: "..label)end end
local rem=ReplicatedStorage:FindFirstChild("SecretVillageRemotes")
check("SecretVillageRemotes",rem~=nil)
for _,n in ipairs({"Notify","BuyHint","StartJob","EndJob","BuyFisher","SpawnVehicle","GetSecretStatus","BuyShopItem","CompleteQuest"})do check("Remote:"..n,rem and rem:FindFirstChild(n)~=nil)end
local sps=game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
check("SecretVillageUI source",sps and sps:FindFirstChild("SecretVillage")~=nil)
local world=Workspace:FindFirstChild("SECRET_VILLAGE_UNIFIED_WORLD")
check("Unified world",world~=nil)
check("River",world and world:FindFirstChild("RIVER")~=nil)
check("Forest",world and world:FindFirstChild("FOREST")~=nil)
check("Bears",world and world:FindFirstChild("BEARS")~=nil)
check("Secret discoveries",Workspace:FindFirstChild("SECRET_DISCOVERIES")~=nil)
check("Quest system",rem and rem:FindFirstChild("CompleteQuest")~=nil)
local roadCount=0
for _,o in ipairs(Workspace:GetDescendants())do if o:IsA("BasePart") and o.Transparency<1 then local n=o.Name:lower();if n:find("road",1,true) or n:find("asphalt",1,true) or o.Material==Enum.Material.Asphalt then roadCount+=1 end end end
check("No visible roads",roadCount==0)
local textCount=0
for _,o in ipairs(Workspace:GetDescendants())do if o:IsA("BillboardGui") or o:IsA("SurfaceGui") then textCount+=1 end end
check("No world text layers",textCount==0)
print(string.format("SECRET VILLAGE BOOT AUDIT v2: %d PASS / %d FAIL",pass,fail))