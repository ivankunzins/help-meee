-- SECRET VILLAGE OWNERSHIP v2
-- Persistent ownership with validation, retries and save locking.

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local Store = DataStoreService:GetDataStore("SecretVillage_Ownership_v1")
local loaded = {}
local saving = {}

local function isValidKey(key)
	return type(key) == "string"
		and #key > 4
		and #key <= 80
		and string.sub(key, 1, 4) == "Own_"
end

local function load(player)
	if not player or not player.Parent then
		return
	end

	local ok, data = pcall(function()
		return Store:GetAsync("u_" .. player.UserId)
	end)

	if not ok then
		warn("[SecretVillageOwnership] Load failed for " .. player.Name)
		player:SetAttribute("OwnershipLoaded", false)
		return
	end

	if type(data) == "table" then
		for key, value in pairs(data) do
			if isValidKey(key) and value == true then
				player:SetAttribute(key, true)
			end
		end
	end

	loaded[player] = true
	player:SetAttribute("OwnershipLoaded", true)
end

local function collectOwnership(player)
	local data = {}

	for key, value in pairs(player:GetAttributes()) do
		if isValidKey(key) and value == true then
			data[key] = true
		end
	end

	return data
end

local function save(player)
	if not player or not player.Parent or not loaded[player] then
		return false
	end

	if saving[player] then
		return false
	end

	saving[player] = true
	local data = collectOwnership(player)
	local success = false

	for attempt = 1, 3 do
		local ok = pcall(function()
			Store:UpdateAsync("u_" .. player.UserId, function(old)
				old = type(old) == "table" and old or {}

				for key, value in pairs(data) do
					if isValidKey(key) and value == true then
						old[key] = true
					end
				end

				return old
			end)
		end)

		if ok then
			success = true
			break
		end

		task.wait(attempt)
	end

	if not success then
		warn("[SecretVillageOwnership] Save failed for " .. player.Name)
	end

	saving[player] = nil
	return success
end

Players.PlayerAdded:Connect(function(player)
	task.spawn(load, player)
end)

Players.PlayerRemoving:Connect(function(player)
	save(player)
	loaded[player] = nil
	saving[player] = nil
end)

task.spawn(function()
	while true do
		task.wait(120)
		for _, player in ipairs(Players:GetPlayers()) do
			task.spawn(save, player)
		end
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		save(player)
	end
end)
