-- SECRET VILLAGE INSTALLER v37
-- Run in Roblox Studio Command Bar.

local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local ScriptEditorService = game:GetService("ScriptEditorService")

local BASE_URL = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/INSTALL36.lua?install=36"
local VISUAL_URL = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/src/ServerScriptService/SecretVillageBearRealism.server.lua"

local function fetch(url)
	local ok, result = pcall(function() return HttpService:GetAsync(url, false) end)
	if not ok then error("Download failed: " .. tostring(result)) end
	return result
end

local function installSource(scriptName, source)
	local existing = game:GetService("ServerScriptService"):FindFirstChild(scriptName)
	if existing and existing:IsA("Script") then
		local ok, err = pcall(function()
			ScriptEditorService:UpdateSourceAsync(existing, function() return source end)
		end)
		if not ok then existing.Source = source end
	else
		local scriptObject = Instance.new("Script")
		scriptObject.Name = scriptName
		scriptObject.Source = source
		scriptObject.Parent = game:GetService("ServerScriptService")
	end
end

for _, child in ipairs(game:GetService("ServerScriptService"):GetChildren()) do
	if child:IsA("Script") and child.Name == "SecretVillageBearRealism" then
		child:Destroy()
	end
end

local base = fetch(BASE_URL)
local visual = fetch(VISUAL_URL)

-- The base installer is executed separately by the user if needed.
-- This installer only installs the visual layer to avoid nested execution limits.
installSource("SecretVillageBearRealism", visual)
print("SECRET VILLAGE INSTALLER v37 COMPLETE: realistic bear visuals installed")
