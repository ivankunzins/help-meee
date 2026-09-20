-- SECRET VILLAGE INSTALLER v32
-- Runs the stable v31 installer, then installs the world-sign cleanup patch.
local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")
local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local function download(path)
	return HttpService:GetAsync(BASE .. path .. "?install=32", true)
end

local ok, result = pcall(function()
	local installer = download("INSTALL.lua")
	local run = loadstring(installer)
	assert(run, "Unable to compile INSTALL.lua")
	run()
end)

if not ok then
	warn("V32 BASE INSTALL FAILED: " .. tostring(result))
end

task.wait(1)

local cleanupOk, cleanupSource = pcall(function()
	return download("src/ServerScriptService/SecretVillageSignCleanup.server.lua")
end)

if cleanupOk then
	local old = ServerScriptService:FindFirstChild("SecretVillageSignCleanup")
	if old then
		old:Destroy()
	end

	local scriptObject = Instance.new("Script")
	scriptObject.Name = "SecretVillageSignCleanup"
	scriptObject.Parent = ServerScriptService

	local wrote, writeError = pcall(function()
		ScriptEditorService:UpdateSourceAsync(scriptObject, function()
			return cleanupSource
		end)
	end)

	if wrote then
		print("SECRET VILLAGE v32 PATCH INSTALLED: overlapping world signs will be removed.")
	else
		scriptObject:Destroy()
		warn("V32 PATCH WRITE FAILED: " .. tostring(writeError))
	end
else
	warn("V32 PATCH DOWNLOAD FAILED: " .. tostring(cleanupSource))
end
