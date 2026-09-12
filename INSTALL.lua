-- SECRET VILLAGE HTTP INSTALLER
-- Run in Roblox Studio Command Bar.
-- Requires Studio HTTP requests enabled.

local HttpService = game:GetService("HttpService")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local files = {
    {path="src/ReplicatedStorage/SecretVillage/Config.lua", className="ModuleScript", parent=function() return game:GetService("ReplicatedStorage") end},
    {path="src/ReplicatedStorage/SecretVillage/ShopConfig.lua", className="ModuleScript", parent=function() return game:GetService("ReplicatedStorage") end},
    {path="src/ServerScriptService/SecretVillageCore.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageSecrets.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageSecretPersistence.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageSecretChain.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageWorld.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageItems.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageJobs.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageShop.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageOwnership.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageInventory.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageSocial.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageQuests.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageProgression.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageAchievements.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageDailyV2.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageVehicles.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageCoop.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageGraphics.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageEnvironmentArt.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageGraphicsArchitecture.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageGraphicsCinematic.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageGraphicsOverhaul.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageGraphicsOverhaul2.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageHeroAssets.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageHeroProps.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/ServerScriptService/SecretVillageInteriorsAndNight.server.lua", className="Script", parent=function() return game:GetService("ServerScriptService") end},
    {path="src/StarterPlayer/StarterPlayerScripts/SecretVillage.client.lua", className="LocalScript", parent=function() return game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts") end},
}

local function folder(parent, name)
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
        local rs = game:GetService("ReplicatedStorage")
        return folder(rs, "SecretVillage")
    elseif item.path:find("src/StarterPlayer/StarterPlayerScripts/", 1, true) then
        return game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
    else
        return game:GetService("ServerScriptService")
    end
end

print("========================================")
print("SECRET VILLAGE HTTP INSTALLER")
print("Starting download of " .. #files .. " files...")
print("========================================")

local okCount = 0
local failCount = 0

for i, item in ipairs(files) do
    local name = item.path:match("([^/]+)$")
    io.write = nil
    print(string.format("[%02d/%02d] Downloading %s", i, #files, name))

    local ok, source = pcall(function()
        return HttpService:GetAsync(BASE .. item.path)
    end)

    if not ok then
        warn("FAILED: " .. item.path .. " | " .. tostring(source))
        failCount += 1
    else
        local parent = destination(item)
        local existing = parent:FindFirstChild(name)
        if existing then
            existing:Destroy()
        end

        local obj = Instance.new(item.className)
        obj.Name = name:gsub("%.server%.lua$", ""):gsub("%.client%.lua$", ""):gsub("%.lua$", "")
        obj.Source = source
        obj.Parent = parent

        okCount += 1
        print(string.format("        OK  %d%%", math.floor(i / #files * 100)))
    end
end

print("========================================")
print(string.format("SECRET VILLAGE INSTALL COMPLETE: %d/%d OK", okCount, #files))
print("Failed: " .. failCount)
print("Press Play to test the game.")
print("========================================")

if failCount > 0 then
    warn("Some files failed to download. Check Output above.")
end
