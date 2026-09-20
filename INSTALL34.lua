-- SECRET VILLAGE INSTALLER v34
-- Base world v31 + forest blaster pickup and bear damage.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local function download(path, suffix)
	return HttpService:GetAsync(BASE .. path .. (suffix or "?install=34"), true)
end

local ok, result = pcall(function()
	local installer = download("INSTALL.lua", "?install=31")
	local run = loadstring(installer)
	assert(run, "Unable to compile INSTALL.lua")
	run()
end)

if not ok then
	warn("V34 BASE INSTALL FAILED: " .. tostring(result))
	return
end

task.wait(1)

local function install(path, className, parent, name)
	local sourceOk, source = pcall(function()
		return download(path)
	end)
	if not sourceOk then
		warn("V34 DOWNLOAD FAILED: " .. path .. " | " .. tostring(source))
		return false
	end

	local old = parent:FindFirstChild(name)
	if old then
		old:Destroy()
	end

	local obj = Instance.new(className)
	obj.Name = name
	obj.Parent = parent
	local wrote, err = pcall(function()
		ScriptEditorService:UpdateSourceAsync(obj, function()
			return source
		end)
	end)
	if not wrote then
		obj:Destroy()
		warn("V34 WRITE FAILED: " .. path .. " | " .. tostring(err))
		return false
	end
	print("V34 OK: " .. path)
	return true
end

local serverOk = install(
	"src/ServerScriptService/SecretVillageForestBlaster.server.lua",
	"Script",
	SSS,
	"SecretVillageForestBlaster"
)

local templateFolder = RS:FindFirstChild("SecretVillageWeaponTemplates")
if not templateFolder then
	templateFolder = Instance.new("Folder")
	templateFolder.Name = "SecretVillageWeaponTemplates"
	templateFolder.Parent = RS
end

local clientOk = install(
	"src/ReplicatedStorage/ForestBlasterClient.client.lua",
	"LocalScript",
	templateFolder,
	"ForestBlasterClient"
)

print(string.format("SECRET VILLAGE v34 COMPLETE: blaster server=%s client=%s", tostring(serverOk), tostring(clientOk)))
print("Find the Forest Blaster near the forest edge, press E to pick it up, then click/tap to fire.")
