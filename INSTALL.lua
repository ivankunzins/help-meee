-- SECRET VILLAGE HTTP INSTALLER v2
-- Run in Roblox Studio Command Bar.
-- File source: https://github.com/ivankunzins/help-meee

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local files = {
    {path="src/ReplicatedStorage/SecretVillage/Config.lua", className="ModuleScript"},
    {path="src/ReplicatedStorage/SecretVillage/ShopConfig.lua", className="ModuleScript"},
    {path="src/ServerScriptService/SecretVillageCore.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageSecrets.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageSecretPersistence.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageSecretChain.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageWorld.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageItems.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageJobs.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageShop.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageOwnership.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageInventory.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageSocial.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageQuests.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageProgression.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageAchievements.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageDailyV2.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageVehicles.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageCoop.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageGraphics.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageEnvironmentArt.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageGraphicsArchitecture.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageGraphicsCinematic.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageGraphicsOverhaul.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageGraphicsOverhaul2.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageHeroAssets.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageHeroProps.server.lua", className="Script"},
    {path="src/ServerScriptService/SecretVillageInteriorsAndNight.server.lua", className="Script"},
    {path="src/StarterPlayer/StarterPlayerScripts/SecretVillage.client.lua", className="LocalScript"},
}

local function getDestination(path)
    if path:find("src/ReplicatedStorage/SecretVillage/", 1, true) then
        local rs = game:GetService("ReplicatedStorage")
        local folder = rs:FindFirstChild("SecretVillage")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "SecretVillage"
            folder.Parent = rs
        end
        return folder
    elseif path:find("src/StarterPlayer/StarterPlayerScripts/", 1, true) then
        return game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
    end
    return game:GetService("ServerScriptService")
end

local function cleanName(path)
    local name = path:match("([^/]+)$")
    return name:gsub("%.server%.lua$", ""):gsub("%.client%.lua$", ""):gsub("%.lua$", "")
end

print("========================================")
print("SECRET VILLAGE HTTP INSTALLER v2")
print("Starting: " .. #files .. " files")
print("========================================")

local okCount = 0
local failCount = 0

for i, item in ipairs(files) do
    local name = cleanName(item.path)
    print(string.format("[%02d/%02d] GET %s", i, #files, name))

    local success, sourceOrError = pcall(function()
        return HttpService:GetAsync(BASE .. item.path, true)
    end)

    if not success then
        failCount += 1
        warn(string.format("[%02d] FAILED HTTP: %s", i, tostring(sourceOrError)))
    else
        local parent = getDestination(item.path)
        local existing = parent:FindFirstChild(name)
        if existing then
            existing:Destroy()
        end

        local obj = Instance.new(item.className)
        obj.Name = name
        obj.Parent = parent

        local writeOk, writeError = pcall(function()
            ScriptEditorService:UpdateSourceAsync(obj, function()
                return sourceOrError
            end)
        end)

        if not writeOk then
            obj:Destroy()
            failCount += 1
            warn(string.format("[%02d] FAILED WRITE: %s", i, tostring(writeError)))
        else
            okCount += 1
            print(string.format("       OK — %d%%", math.floor(i / #files * 100)))
        end
    end
end

print("========================================")
print(string.format("SECRET VILLAGE: %d/%d FILES INSTALLED", okCount, #files))
print("FAILED: " .. failCount)
if failCount == 0 then
    print("INSTALL COMPLETE — press Play")
else
    warn("INSTALL FINISHED WITH ERRORS — see messages above")
end
print("========================================")
