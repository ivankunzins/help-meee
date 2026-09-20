-- SECRET VILLAGE INSTALLER v41
-- Installs the repaired shop server script.
local HttpService = game:GetService("HttpService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local ServerScriptService = game:GetService("ServerScriptService")

local url = "https://raw.githubusercontent.com/ivankunzins/help-meee/main/src/ServerScriptService/SecretVillageShop.server.lua"
local source = HttpService:GetAsync(url .. "?install=41")

local target = ServerScriptService:FindFirstChild("SecretVillageShop")
if not target then
	target = Instance.new("Script")
	target.Name = "SecretVillageShop"
	target.Parent = ServerScriptService
end

ScriptEditorService:UpdateSourceAsync(target, function()
	return source
end)

print("[INSTALL41] SecretVillageShop v5 installed. Purchase fallback and diagnostics enabled.")
