-- SECRET VILLAGE INSTALLER v33
-- Runs the stable v31 installer, then installs the bear boundary behavior patch.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local function download(path, suffix)
	return HttpService:GetAsync(BASE .. path .. (suffix or "?install=33"), true)
end

local ok, result = pcall(function()
	local installer = download("INSTALL.lua", "?install=31")
	local run = loadstring(installer)
	assert(run, "Unable to compile INSTALL.lua")
	run()
end)

if not ok then
	warn("V33 BASE INSTALL FAILED: " .. tostring(result))
	return
end

task.wait(1)

local patchOk, patchSource = pcall(function()
	return download("src/ServerScriptService/SecretVillageBearBoundary.server.lua")
end)

if not patchOk then
	warn("V33 BEAR PATCH DOWNLOAD FAILED: " .. tostring(patchSource))
	return
end

local old = ServerScriptService:FindFirstChild("SecretVillageBearBoundary")
if old then
	old:Destroy()
end

local scriptObject = Instance.new("Script")
scriptObject.Name = "SecretVillageBearBoundary"
scriptObject.Parent = ServerScriptService

local wrote, writeError = pcall(function()
	ScriptEditorService:UpdateSourceAsync(scriptObject, function()
		return patchSource
	end)
end)

if not wrote then
	scriptObject:Destroy()
	warn("V33 BEAR PATCH WRITE FAILED: " .. tostring(writeError))
	return
end

print("SECRET VILLAGE v33 INSTALLED: bears chase only inside the forest boundary and return home afterward.")
