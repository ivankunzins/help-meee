-- SECRET VILLAGE SHOP v5
-- Reliable purchases with built-in item fallback, clear diagnostics and rollback.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local village = ReplicatedStorage:WaitForChild("SecretVillage")
local ShopConfig = require(village:WaitForChild("ShopConfig"))
local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")
local Buy = remotes:FindFirstChild("BuyShopItem") or Instance.new("RemoteEvent")
Buy.Name = "BuyShopItem"
Buy.Parent = remotes

local byId = {}
for _, item in ipairs(ShopConfig) do
	if type(item) == "table" and type(item.Id) == "string" and type(item.Price) == "number" then
		byId[item.Id] = item
	end
end

local processing = {}
local lastRequest = {}

local function notify(player, message)
	if player and player.Parent then
		Notify:FireClient(player, tostring(message))
	end
end

local function moneyValue(player)
	local stats = player:FindFirstChild("leaderstats")
	local money = stats and stats:FindFirstChild("Money")
	if money and money:IsA("IntValue") and money.Value >= 0 then
		return money
	end
	return nil
end

local function validRequest(player)
	local now = os.clock()
	if now - (lastRequest[player] or 0) < 0.5 then return false end
	lastRequest[player] = now
	return true
end

local function makeTool(player, id, name)
	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	if not backpack then return false end
	if backpack:FindFirstChild(id) or (player.Character and player.Character:FindFirstChild(id)) then return true end

	local tool = Instance.new("Tool")
	tool.Name = name or id
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool:SetAttribute("SecretVillageItem", id)

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.7, 0.7, 0.7)
	handle.CanCollide = false
	handle.Massless = true
	handle.Color = Color3.fromRGB(80, 80, 90)
	handle.Parent = tool

	if id == "Flashlight" then
		handle.Color = Color3.fromRGB(35, 35, 35)
		local light = Instance.new("SpotLight")
		light.Name = "FlashlightBeam"
		light.Brightness = 3
		light.Range = 32
		light.Angle = 65
		light.Enabled = true
		light.Parent = handle
	elseif id == "Detector" then
		handle.Color = Color3.fromRGB(35, 120, 180)
	elseif id == "Diving" then
		handle.Color = Color3.fromRGB(30, 150, 220)
	elseif id == "MagicCarpet" then
		handle.Size = Vector3.new(2, 0.2, 3)
		handle.Color = Color3.fromRGB(150, 45, 180)
	end

	tool.Parent = backpack
	return true
end

local function builtInGrant(player, id, item)
	if id == "MysteryBox" then
		local money = moneyValue(player)
		if not money then return false end
		local prize = math.random(250, 2500)
		money.Value += prize
		notify(player, "🎁 Mystery Box: ты получил $" .. prize)
		return true
	end
	return makeTool(player, id, item and item.Name or id)
end

local function grant(player, id)
	local item = byId[id]
	if not item then return false, "Товар не найден в ShopConfig." end

	local external = _G.SecretVillageGiveItem
	if type(external) == "function" then
		local ok, result = pcall(external, player, id)
		if ok and result == true then return true end
	end

	if builtInGrant(player, id, item) then return true end
	return false, "Не удалось выдать предмет. Backpack ещё не готов или инвентарь недоступен."
end

Buy.OnServerEvent:Connect(function(player, id)
	if not player or not player.Parent or processing[player] or not validRequest(player) then return end
	if type(id) ~= "string" or #id == 0 or #id > 64 then return end

	if player:GetAttribute("CoreLoaded") ~= true then
		notify(player, "⏳ Профиль ещё загружается. Попробуй через несколько секунд.")
		return
	end

	local item = byId[id]
	local money = moneyValue(player)
	if not item then notify(player, "⚠️ Товар не найден. Обнови магазин."); return end
	if not money then notify(player, "⚠️ Баланс ещё не готов. Перезайди в игру."); return end
	if id ~= "MysteryBox" and player:GetAttribute("Own_" .. id) == true then
		notify(player, "✅ Этот предмет уже у тебя.")
		return
	end
	if money.Value < item.Price then
		notify(player, "❌ Не хватает $" .. (item.Price - money.Value) .. ".")
		return
	end

	processing[player] = true
	local before = money.Value
	money.Value = before - item.Price
	local ok, granted, reason = pcall(function()
		return grant(player, id)
	end)

	if not ok or granted ~= true then
		money.Value = before
		notify(player, "⚠️ Покупка не выполнена. Деньги возвращены. " .. tostring(reason or "Неизвестная ошибка"))
	else
		if id ~= "MysteryBox" then player:SetAttribute("Own_" .. id, true) end
		notify(player, "🛍️ Куплено: " .. tostring(item.Name or id))
	end
	processing[player] = nil
end)

Players.PlayerRemoving:Connect(function(player)
	processing[player] = nil
	lastRequest[player] = nil
end)

print("[SecretVillageShop] v5 loaded")
