-- SECRET VILLAGE INSTALLER v40
-- Removes floating BillboardGui labels without removing physical building signs.

local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")

local URL = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/src/ServerScriptService/SecretVillageRemoveFloatingLabels.server.lua"
local source = HttpService:GetAsync(URL .. "?install=40")

local existing = ServerScriptService:FindFirstChild("SecretVillageRemoveFloatingLabels")
local scriptObject = existing
if not scriptObject then
	scriptObject = Instance.new("Script")
	scriptObject.Name = "SecretVillageRemoveFloatingLabels"
	scriptObject.Parent = ServerScriptService
end

ScriptEditorService:UpdateSourceAsync(scriptObject, function()
	return source
end)

print("[INSTALL40] Floating label cleanup installed. Physical SurfaceGui building signs are preserved.")
