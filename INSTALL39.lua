-- SECRET VILLAGE INSTALLER v39
-- Full world visuals + realistic bears + grass and forest-edge meadows.
-- Run in Roblox Studio Command Bar.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")

local BASE = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/"

local function fetch(path)
	local ok, result = pcall(function()
		return HttpService:GetAsync(BASE .. path .. "?install=39", false)
	end)
	assert(ok, "Download failed: " .. tostring(result))
	return result
end

local function installSource(name, source)
	local old = ServerScriptService:FindFirstChild(name)
	if old then old:Destroy() end

	local scriptObject = Instance.new("Script")
	scriptObject.Name = name
	scriptObject.Parent = ServerScriptService

	local ok, err = pcall(function()
		ScriptEditorService:UpdateSourceAsync(scriptObject, function()
			return source
		end)
	end)
	if not ok then
		scriptObject:Destroy()
		error("Source write failed for " .. name .. ": " .. tostring(err))
	end
end

-- Install the base world and enhanced forest first.
local baseSource = fetch("INSTALL36.lua")
local baseRunner = loadstring(baseSource)
assert(baseRunner, "INSTALL36 compile failed")
baseRunner()

task.wait(1)

-- Install the complete bear visual layer.
local bearSource = fetch("src/ServerScriptService/SecretVillageBearRealismV2.server.lua")
installSource("SecretVillageBearRealismV2", bearSource)

task.wait(0.5)

-- Install grass coverage and meadow clearings before the forest.
local meadowSource = fetch("src/ServerScriptService/SecretVillageMeadowsAndGrass.server.lua")
installSource("SecretVillageMeadowsAndGrass", meadowSource)

print("SECRET VILLAGE INSTALLER v39 COMPLETE: base, forest, bears, grass and meadows installed")