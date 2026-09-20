-- SECRET VILLAGE CLEAN INSTALLER v30
-- Installs gameplay and the authoritative world plus cozy village visual layers.
local HttpService=game:GetService("HttpService")
local ScriptEditorService=game:GetService("ScriptEditorService")
local SSS=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local SPS=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local WS=game:GetService("Workspace")
local BASE="https://raw.githubusercontent.com/ivankunzins/help-meee/main/"
local CACHE="?install=30"

local legacy={
 "SecretVillageWorld","SecretVillageVillageLife","SecretVillageRuralDetail","SecretVillageGraphics","SecretVillageEnvironmentArt",
 "SecretVillageGraphicsArchitecture","SecretVillageGraphicsCinematic","SecretVillageGraphicsOverhaul","SecretVillageGraphicsOverhaul2",
 "SecretVillageHeroAssets","SecretVillageHeroProps","SecretVillageInteriorsAndNight","SecretVillageFinalArt","SecretVillageArchitectureFinal",
 "SecretVillageVisualWorld2","SecretVillageWorldFinal","SecretVillageVisualMaster",
 "SecretVillageVisualPresentationFinal","SecretVillagePresentationRecovery","SecretVillageFinalTerrainCleanup","SecretVillageForestBearsFinal"
}
for _,n in ipairs(legacy) do local x=SSS:FindFirstChild(n);if x then x:Destroy()end end

local oldWorld={"SECRET_VILLAGE_LIFE","FINAL_ART_PASS","SECRET_VILLAGE_WORLD_FINAL","SECRET_VILLAGE_FINAL_MASTER","GRAPHICS_OVERHAUL","GRAPHICS_OVERHAUL_V2","GRAPHICS_CINEMATIC","GRAPHICS_HERO_PROPS","GRAPHICS_HERO_ASSETS","ARCHITECTURE_FINAL","VISUAL_WORLD_V2","WORLD_FINAL","VISUAL_MASTER","VISUAL_PRESENTATION_FINAL","SECRET_VILLAGE_RURAL_DETAIL","SECRET_VILLAGE_PRESENTATION_RECOVERY","TerrainFinish","ArchitectureFinish","VillageSquareFinish","RiverFinish","FarmFinish","FOREST_PERIMETER","FOREST_FLOOR","DANGEROUS_BEAR_ZONE"}
for _,n in ipairs(oldWorld) do local x=WS:FindFirstChild(n);if x then x:Destroy()end end

local files={
 {"src/ReplicatedStorage/SecretVillage/Config.lua","ModuleScript"},{"src/ReplicatedStorage/SecretVillage/ShopConfig.lua","ModuleScript"},
 {"src/ServerScriptService/SecretVillageCore.server.lua","Script"},{"src/ServerScriptService/SecretVillageSecrets.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageSecretPersistence.server.lua","Script"},{"src/ServerScriptService/SecretVillageSecretChain.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageItems.server.lua","Script"},{"src/ServerScriptService/SecretVillageJobs.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageShop.server.lua","Script"},{"src/ServerScriptService/SecretVillageOwnership.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageInventory.server.lua","Script"},{"src/ServerScriptService/SecretVillageSocial.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageQuests.server.lua","Script"},{"src/ServerScriptService/SecretVillageProgression.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageAchievements.server.lua","Script"},{"src/ServerScriptService/SecretVillageDailyV2.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageVehicles.server.lua","Script"},{"src/ServerScriptService/SecretVillageCoop.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageUnifiedWorld.server.lua","Script"},{"src/ServerScriptService/SecretVillageFinalWorldMaster.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageCozyVillage.server.lua","Script"},{"src/ServerScriptService/SecretVillageCozyDetails.server.lua","Script"},
 {"src/ServerScriptService/SecretVillageSkyCycleFinal.server.lua","Script"},{"src/ServerScriptService/SecretVillageBootAudit.server.lua","Script"},
 {"src/StarterPlayer/StarterPlayerScripts/SecretVillage.client.lua","LocalScript"}
}
local function parentFor(path)
 if path:find("src/ReplicatedStorage/SecretVillage/",1,true) then return RS:FindFirstChild("SecretVillage") or Instance.new("Folder",RS) end
 if path:find("src/StarterPlayer/StarterPlayerScripts/",1,true) then return SPS end
 return SSS
end
local function objName(path)return path:match("([^/]+)$"):gsub("%.server%.lua$",""):gsub("%.client%.lua$",""):gsub("%.lua$","") end
local sec=RS:FindFirstChild("SecretVillage") or Instance.new("Folder");sec.Name="SecretVillage";sec.Parent=RS
print("SECRET VILLAGE CLEAN INSTALLER v30 | FILES: "..#files)
local okCount,failCount=0,0
for i,item in ipairs(files) do
 local path,className=item[1],item[2];local name=objName(path)
 local ok,source=pcall(function()return HttpService:GetAsync(BASE..path..CACHE,true)end)
 if not ok then failCount+=1;warn("DOWNLOAD FAILED: "..path.." | "..tostring(source))
 else
  local parent=parentFor(path);local old=parent:FindFirstChild(name);if old then old:Destroy()end
  local obj=Instance.new(className);obj.Name=name;obj.Parent=parent
  local wrote,err=pcall(function()ScriptEditorService:UpdateSourceAsync(obj,function()return source end)end)
  if not wrote then obj:Destroy();failCount+=1;warn("WRITE FAILED: "..path.." | "..tostring(err)) else okCount+=1;print(string.format("[%02d/%02d] OK",i,#files))end
 end
end
print(string.format("INSTALL COMPLETE: %d/%d OK",okCount,#files));print("FAILED: "..failCount)
if failCount==0 then print("SUCCESS — AUTHORITATIVE WORLD + COZY VILLAGE + COZY DETAILS. Press Play and wait 10 seconds.")end