-- SECRET VILLAGE SIGN CLEANUP v1
-- Removes obsolete world-facing GUI signs that can overlap after old visual layers.
local Workspace = game:GetService("Workspace")

local function allowed(gui)
	local n = string.lower(gui.Name)
	return n:find("secret", 1, true) ~= nil
		or n:find("quest", 1, true) ~= nil
		or n == "divesign"
end

local function clean()
	for _, item in ipairs(Workspace:GetDescendants()) do
		if item:IsA("BillboardGui") or item:IsA("SurfaceGui") then
			if not allowed(item) then
				item:Destroy()
			end
		end
	end
end

clean()
while Workspace.Parent do
	task.wait(3)
	clean()
end
