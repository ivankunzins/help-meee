-- SECRET VILLAGE FLOATING LABEL CLEANUP v1
-- Removes floating BillboardGui labels and floating text objects from the generated world.

local Workspace = game:GetService("Workspace")

local function removeFloatingText(root)
	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			obj:Destroy()
		elseif obj:IsA("SurfaceGui") then
			local hasText = false
			for _, child in ipairs(obj:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					hasText = true
					break
				end
			end
			if hasText then
				obj:Destroy()
			end
		end
	end
end

removeFloatingText(Workspace)

Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BillboardGui") then
		obj:Destroy()
	elseif obj:IsA("SurfaceGui") then
		task.defer(function()
			if not obj.Parent then return end
			for _, child in ipairs(obj:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					obj:Destroy()
					return
				end
			end
		end)
	end
end)

print("[FloatingLabelCleanup] Floating labels removed and blocked.")
