-- SECRET VILLAGE INSTALLER v36
-- Base world + enhanced forest and tree visuals.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")
local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local function get(path)
	return HttpService:GetAsync(BASE .. path .. "?install=36", true)
end

local ok, err = pcall(function()
	local base = loadstring(get("INSTALL.lua"))
	assert(base, "Base installer compile failed")
	base()
end)
if not ok then warn("V36 BASE INSTALL FAILED: " .. tostring(err)) return end

task.wait(1)
local old = ServerScriptService:FindFirstChild("SecretVillageForestVisuals")
if old then old:Destroy() end
local source = get("src/ServerScriptService/SecretVillageForestVisuals.server.lua")
local scriptObject = Instance.new("Script")
scriptObject.Name = "SecretVillageForestVisuals"
scriptObject.Parent = ServerScriptService
local wrote, writeErr = pcall(function()
	ScriptEditorService:UpdateSourceAsync(scriptObject, function() return source end)
end)
if not wrote then scriptObject:Destroy() warn("V36 FOREST VISUALS FAILED: " .. tostring(writeErr)) return end
print("SECRET VILLAGE v36 COMPLETE: enhanced trees, canopies, bushes and forest atmosphere")