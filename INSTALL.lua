-- SECRET VILLAGE HTTP INSTALLER v5
-- Run this entire script from Roblox Studio Command Bar.
-- Outer loader: raw.githubusercontent.com
-- Files are also fetched from raw.githubusercontent.com.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"
local CACHE_BUSTER = "?install=5"

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

local function getFolder(parent, name)
    local f = parent:FindFirstChild(name)
    if not f then
        f = Instance.new("Folder")
        f.Name = name
        f.Parent = parent
    end
    return f
end

local function destination(item)
    if item.path:find("src/ReplicatedStorage/SecretVillage/", 1, true) then
        return getFolder(game:GetService("ReplicatedStorage"), "SecretVillage")
    elseif item.path:find("src/StarterPlayer/StarterPlayerScripts/", 1, true) then
        return game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
    end
    return game:GetService("ServerScriptService")
end

local function objectName(path)
    return path:match("([^/]+)$")
        :gsub("%.server%.lua$", "")
        :gsub("%.client%.lua$", "")
        :gsub("%.lua$", "")
end

local function fetchSource(path)
    return HttpService:GetAsync(BASE .. path .. CACHE_BUSTER, true)
end

print("========================================")
print("SECRET VILLAGE HTTP INSTALLER v5")
print("Transport: raw.githubusercontent.com")
print("Files: " .. #files)
print("========================================")

local okCount = 0
local failCount = 0

for i, item in ipairs(files) do
    local name = objectName(item.path)
    print(string.format("[%02d/%02d] GET %s", i, #files, name))

    local ok, source = pcall(function()
        return fetchSource(item.path)
    end)

    if not ok then
        failCount += 1
        warn("DOWNLOAD FAILED: " .. item.path .. " | " .. tostring(source))
    else
        local parent = destination(item)
        local existing = parent:FindFirstChild(name)
        if existing then existing:Destroy() end

        local obj = Instance.new(item.className)
        obj.Name = name
        obj.Parent = parent

        local writeOk, writeErr = pcall(function()
            ScriptEditorService:UpdateSourceAsync(obj, function()
                return source
            end)
        end)

        if not writeOk then
            obj:Destroy()
            failCount += 1
            warn("WRITE FAILED: " .. item.path .. " | " .. tostring(writeErr))
        else
            okCount += 1
            print(string.format("       OK — %d%%", math.floor(i / #files * 100)))
        end
    end
end

print("========================================")
print(string.format("INSTALL COMPLETE: %d/%d OK", okCount, #files))
print("FAILED: " .. failCount)
if failCount == 0 then
    print("SUCCESS — press Play to test Secret Village")
else
    warn("INSTALL INCOMPLETE — check errors above")
end
print("========================================")
