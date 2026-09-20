-- SECRET VILLAGE QUESTS v6
-- Server-authoritative quests with safe initialization, duplicate-generation protection,
-- progress tracking, validation, throttling and cleanup.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")

local root = Workspace:FindFirstChild("SECRET_QUESTS")
if root then
	warn("[SecretVillage] SECRET_QUESTS already exists; quest script will not create duplicates.")
	return
end

root = Instance.new("Folder")
root.Name = "SECRET_QUESTS"
root.Parent = Workspace

local Complete = remotes:FindFirstChild("CompleteQuest") or Instance.new("RemoteEvent")
Complete.Name = "CompleteQuest"
Complete.Parent = remotes

local questCompleted = ReplicatedStorage:FindFirstChild("SecretVillageQuestCompleted") or Instance.new("BindableEvent")
questCompleted.Name = "SecretVillageQuestCompleted"
questCompleted.Parent = ReplicatedStorage

local quests = {
	{id = "delivery", name = "📦 Срочная доставка", text = "Отвези посылку к синему терминалу", reward = 180, xp = 40, target = Vector3.new(100, 0.5, 0)},
	{id = "taxi", name = "🚕 Пассажир", text = "Доставь пассажира к старому дому", reward = 300, xp = 60, target = Vector3.new(-70, 1, -30)},
	{id = "explore", name = "🔎 Следопыт", text = "Найди новый секрет после взятия задания", reward = 250, xp = 50, target = Vector3.zero},
	{id = "fisher", name = "🎣 Улов дня", text = "Поймай 5 новых рыб", reward = 220, xp = 45, target = Vector3.zero},
}

local byId = {}
for _, quest in ipairs(quests) do byId[quest.id] = quest end
local finishing, promptCooldown, completeCooldown, initialized = {}, {}, {}, {}

local function notify(player, message)
	if player and player.Parent then Notify:FireClient(player, message) end
end

local function loaded(player)
	return player:GetAttribute("CoreLoaded") == true
end

local function money(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local value = leaderstats and leaderstats:FindFirstChild("Money")
	if value and value:IsA("IntValue") and value.Value >= 0 then return value end
	return nil
end

local function clearQuest(player)
	player:SetAttribute("QuestActive", "")
	player:SetAttribute("QuestProgress", 0)
	player:SetAttribute("QuestTarget", Vector3.zero)
	player:SetAttribute("QuestStartSecrets", 0)
	player:SetAttribute("QuestStartFish", 0)
end

local function initializePlayer(player)
	if initialized[player] then return end
	initialized[player] = true
	if player:GetAttribute("QuestActive") == nil then player:SetAttribute("QuestActive", "") end
	if player:GetAttribute("QuestProgress") == nil then player:SetAttribute("QuestProgress", 0) end
	if player:GetAttribute("QuestTarget") == nil then player:SetAttribute("QuestTarget", Vector3.zero) end
	if player:GetAttribute("QuestStartSecrets") == nil then player:SetAttribute("QuestStartSecrets", 0) end
	if player:GetAttribute("QuestStartFish") == nil then player:SetAttribute("QuestStartFish", 0) end

	player:GetAttributeChangedSignal("TotalFish"):Connect(function()
		if player:GetAttribute("QuestActive") == "fisher" then
			local startFish = math.max(0, tonumber(player:GetAttribute("QuestStartFish")) or 0)
			local currentFish = math.max(0, tonumber(player:GetAttribute("TotalFish")) or 0)
			player:SetAttribute("QuestProgress", math.min(5, math.max(0, currentFish - startFish)))
		end
	end)
	player:GetAttributeChangedSignal("SecretsFound"):Connect(function()
		if player:GetAttribute("QuestActive") == "explore" then
			local startSecrets = math.max(0, tonumber(player:GetAttribute("QuestStartSecrets")) or 0)
			local currentSecrets = math.max(0, tonumber(player:GetAttribute("SecretsFound")) or 0)
			player:SetAttribute("QuestProgress", currentSecrets > startSecrets and 1 or 0)
		end
	end)
end

local function startQuest(player, questId)
	if not player or not player:IsA("Player") or not player.Parent then return end
	if not loaded(player) then notify(player, "⏳ Профиль ещё загружается."); return end
	if finishing[player] then return end
	local active = player:GetAttribute("QuestActive")
	if active and active ~= "" then notify(player, "📋 Сначала закончи текущее задание."); return end
	local quest = byId[questId]
	if not quest then return end
	player:SetAttribute("QuestActive", quest.id)
	player:SetAttribute("QuestProgress", 0)
	player:SetAttribute("QuestTarget", quest.target)
	player:SetAttribute("QuestStartSecrets", math.max(0, tonumber(player:GetAttribute("SecretsFound")) or 0))
	player:SetAttribute("QuestStartFish", math.max(0, tonumber(player:GetAttribute("TotalFish")) or 0))
	notify(player, quest.name .. " — " .. quest.text .. ". Награда $" .. quest.reward .. " +" .. quest.xp .. " XP")
end

local function createQuestNpc(name, position, title, questId)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = Vector3.new(5, 7, 5)
	part.Position = position
	part.Anchored = true
	part.Material = Enum.Material.Wood
	part.Parent = root
	local gui = Instance.new("BillboardGui")
	gui.Name = "QuestBillboard"
	gui.Size = UDim2.fromOffset(280, 55)
	gui.StudsOffset = Vector3.new(0, 5, 0)
	gui.AlwaysOnTop = true
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.Name = "Title"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = title
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = gui
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "QuestPrompt"
	prompt.ActionText = "Задание"
	prompt.ObjectText = name
	prompt.HoldDuration = 0.35
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = part
	prompt.Triggered:Connect(function(player) startQuest(player, questId) end)
end

createQuestNpc("CourierQuestNPC", Vector3.new(-20, 3.5, 35), "📦 КУРЬЕР", "delivery")
createQuestNpc("TaxiQuestNPC", Vector3.new(80, 3.5, 25), "🚕 ДИСПЕТЧЕР", "taxi")
createQuestNpc("ExplorerQuestNPC", Vector3.new(35, 3.5, 55), "🔎 ИССЛЕДОВАТЕЛЬ", "explore")
createQuestNpc("FishingQuestNPC", Vector3.new(65, 3.5, 25), "🎣 РЫБОЛОВ", "fisher")

local target = Instance.new("Part")
target.Name = "DeliveryTarget"
target.Size = Vector3.new(8, 0.5, 8)
target.Position = Vector3.new(100, 0.5, 0)
target.Anchored = true
target.Material = Enum.Material.Neon
target.Transparency = 0.35
target.Parent = root
local targetPrompt = Instance.new("ProximityPrompt")
targetPrompt.Name = "DeliveryPrompt"
targetPrompt.ActionText = "Сдать"
targetPrompt.ObjectText = "📦 Терминал доставки"
targetPrompt.MaxActivationDistance = 12
targetPrompt.RequiresLineOfSight = false
targetPrompt.Parent = target

local function finish(player, quest)
	if finishing[player] then return end
	finishing[player] = true
	local moneyValue = money(player)
	if not moneyValue or not loaded(player) then finishing[player] = nil; return end
	clearQuest(player)
	player:SetAttribute("QuestXP", math.max(0, tonumber(player:GetAttribute("QuestXP")) or 0) + quest.xp)
	moneyValue.Value += quest.reward
	questCompleted:Fire(player)
	notify(player, "✅ Задание «" .. quest.name .. "» выполнено! +$" .. quest.reward .. " +" .. quest.xp .. " XP")
	finishing[player] = nil
end

local function tryComplete(player)
	if not player or not player:IsA("Player") or not player.Parent or not loaded(player) then return end
	local now = os.clock()
	if now - (completeCooldown[player] or 0) < 0.75 then return end
	completeCooldown[player] = now
	if finishing[player] then return end
	local quest = byId[player:GetAttribute("QuestActive")]
	if not quest then return end
	local character = player.Character
	local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not playerRoot or not humanoid or humanoid.Health <= 0 then return end
	if quest.id == "delivery" then
		if (playerRoot.Position - target.Position).Magnitude > 14 then notify(player, "📦 Подойди к терминалу доставки."); return end
	elseif quest.id == "taxi" then
		local vehicleRoot = Workspace:FindFirstChild("SECRET_VILLAGE_VEHICLES")
		local seat = humanoid.SeatPart
		if not vehicleRoot or not seat or not seat:IsDescendantOf(vehicleRoot) or (playerRoot.Position - quest.target).Magnitude > 16 then notify(player, "🚕 Сядь в такси и привези пассажира к старому дому."); return end
		local vehicleModel = seat:FindFirstAncestorOfClass("Model")
		if not vehicleModel or vehicleModel:GetAttribute("OwnerUserId") ~= player.UserId or vehicleModel:GetAttribute("VehicleType") ~= "Taxi" then notify(player, "🚕 Для задания нужно использовать своё такси."); return end
	elseif quest.id == "explore" then
		local startSecrets = math.max(0, tonumber(player:GetAttribute("QuestStartSecrets")) or 0)
		local currentSecrets = math.max(0, tonumber(player:GetAttribute("SecretsFound")) or 0)
		if currentSecrets <= startSecrets then notify(player, "🔎 Найди новый секрет после взятия задания."); return end
		player:SetAttribute("QuestProgress", 1)
	elseif quest.id == "fisher" then
		local startFish = math.max(0, tonumber(player:GetAttribute("QuestStartFish")) or 0)
		local currentFish = math.max(0, tonumber(player:GetAttribute("TotalFish")) or 0)
		local progress = currentFish - startFish
		if progress < 5 then notify(player, "🎣 Нужно поймать ещё " .. math.max(0, 5 - progress) .. " рыб."); return end
		player:SetAttribute("QuestProgress", 5)
	end
	finish(player, quest)
end

Complete.OnServerEvent:Connect(tryComplete)
targetPrompt.Triggered:Connect(function(player)
	local now = os.clock()
	if now - (promptCooldown[player] or 0) < 1 then return end
	promptCooldown[player] = now
	tryComplete(player)
end)

Players.PlayerAdded:Connect(initializePlayer)
for _, player in ipairs(Players:GetPlayers()) do task.spawn(initializePlayer, player) end
Players.PlayerRemoving:Connect(function(player)
	initialized[player] = nil
	finishing[player] = nil
	promptCooldown[player] = nil
	completeCooldown[player] = nil
end)

print("SECRET VILLAGE QUESTS v6 READY: safe initialization + validation + no duplicate generation")
