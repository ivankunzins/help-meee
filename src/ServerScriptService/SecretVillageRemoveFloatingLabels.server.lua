-- SECRET VILLAGE FLOATING LABEL CLEANUP v2
-- Removes only floating BillboardGui labels.
-- SurfaceGui signs attached to physical boards are preserved.

local Workspace = game:GetService("Workspace")

local function removeFloatingLabels(root)
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			obj:Destroy()
		end
	end
end

removeFloatingLabels(Workspace)

Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BillboardGui") then
		obj:Destroy()
	end
end)

print("[FloatingLabelCleanup] Floating BillboardGui labels removed; physical signboards preserved.")
