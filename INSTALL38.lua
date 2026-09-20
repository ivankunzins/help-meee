-- SECRET VILLAGE INSTALLER v38
-- Installs the full visual pass for every bear.
-- Run in Roblox Studio Command Bar.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")

local BASE_URL = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/INSTALL36.lua?install=36"
local VISUAL_URL = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/src/ServerScriptService/SecretVillageBearRealismV2.server.lua"

local function fetch(url)
	local ok, result = pcall(function()
		return HttpService:GetAsync(url, false)
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
		error("Source write failed: " .. tostring(err))
	end
end

-- Remove previous visual layer so v1 and v2 cannot stack.
for _, child in ipairs(ServerScriptService:GetChildren()) do
	if child:IsA("Script") and (child.Name == "SecretVillageBearRealism" or child.Name == "SecretVillageBearRealismV2") then
		child:Destroy()
	end
end

-- Base installer is downloaded to verify availability; run INSTALL36 separately if needed.
fetch(BASE_URL)
local visual = fetch(VISUAL_URL)
installSource("SecretVillageBearRealismV2", visual)

print("SECRET VILLAGE INSTALLER v38 COMPLETE: all bears received full visual pass")
