-- SECRET VILLAGE INSTALLER v35
-- Base world v31 + strict bear village exclusion.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local function download(path, suffix)
	return HttpService:GetAsync(BASE .. path .. (suffix or "?install=35"), true)
end

local ok, result = pcall(function()
	local installer = download("INSTALL.lua", "?install=31")
	local run = loadstring(installer)
	assert(run, "Unable to compile INSTALL.lua")
	run()
end)

if not ok then
	warn("V35 BASE INSTALL FAILED: " .. tostring(result))
	return
end

task.wait(1)

-- Remove the previous controller so two AI loops cannot fight each other.
for _, name in ipairs({"SecretVillageBearBoundary", "SecretVillageBearVillageGuard"}) do
	local old = ServerScriptService:FindFirstChild(name)
	if old then
		old:Destroy()
	end
end

local sourceOk, source = pcall(function()
	return download("src/ServerScriptService/SecretVillageBearVillageGuard.server.lua")
end)

if not sourceOk then
	warn("V35 BEAR GUARD DOWNLOAD FAILED: " .. tostring(source))
	return
end

local scriptObject = Instance.new("Script")
scriptObject.Name = "SecretVillageBearVillageGuard"
scriptObject.Parent = ServerScriptService

local wrote, writeError = pcall(function()
	ScriptEditorService:UpdateSourceAsync(scriptObject, function()
		return source
	end)
end)

if not wrote then
	scriptObject:Destroy()
	warn("V35 BEAR GUARD WRITE FAILED: " .. tostring(writeError))
	return
end

print("SECRET VILLAGE v35 INSTALLED: bears are restricted to the forest and cannot enter the village.")
