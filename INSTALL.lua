-- SECRET VILLAGE HTTP INSTALLER v4
-- Run this entire script from Roblox Studio Command Bar.
-- The outer loader can be the simple raw.githubusercontent.com loadstring.
-- Files are fetched through the GitHub Contents API and decoded locally.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local API = "https://api.github.com/repos/ivankunzins/help-meee/contents/"
local REF = "?ref=main"

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

-- Roblox Studio's HttpService does not provide Base64Decode on all Studio versions.
-- Decode GitHub's base64 content locally so the installer works without that method.
local BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function decodeBase64(input)
    input = input:gsub("%s", ""):gsub("=+$", "")
    local out = {}
    local buffer = 0
    local bits = 0

    for i = 1, #input do
        local c = input:sub(i, i)
        local value = BASE64:find(c, 1, true)
        if not value then
            error("Invalid base64 character: " .. tostring(c))
        end
        value -= 1
        buffer = buffer * 64 + value
        bits += 6

        while bits >= 8 do
            bits -= 8
            local byte = math.floor(buffer / (2 ^ bits)) % 256
            out[#out + 1] = string.char(byte)
        end
    end

    return table.concat(out)
end

local function fetchSource(path)
    local raw = HttpService:GetAsync(API .. path .. REF, true)
    local data = HttpService:JSONDecode(raw)
    if not data.content then
        error("GitHub returned no file content")
    end
    return decodeBase64(data.content)
end

print("========================================")
print("SECRET VILLAGE HTTP INSTALLER v4")
print("Transport: api.github.com")
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
        if existing then
            existing:Destroy()
        end

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
