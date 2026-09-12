-- SECRET VILLAGE / MVP
-- Paste this Script into ServerScriptService in Roblox Studio.
-- The script creates the first playable prototype automatically.

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local STORE = DataStoreService:GetDataStore("SecretVillage_PlayerData_v1")
local ROUND_SECONDS = 30 * 60
local HINT_COST = 500
local JOB_COST = 100
local LEAF_REWARD = 1

local state = {}
local roundStartedAt = os.time()

local remotes = ReplicatedStorage:FindFirstChild("SecretVillageRemotes") or Instance.new("Folder")
remotes.Name = "SecretVillageRemotes"
remotes.Parent = ReplicatedStorage

local function remote(name)
    local r = remotes:FindFirstChild(name) or Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = remotes
    return r
end

local Notify = remote("Notify")
local Hint = remote("BuyHint")
local Job = remote("BuyJob")

local function notify(player, text)
    Notify:FireClient(player, text)
end

local function leaderstats(player)
    local folder = player:FindFirstChild("leaderstats") or Instance.new("Folder")
    folder.Name = "leaderstats"
    folder.Parent = player

    local money = folder:FindFirstChild("Money") or Instance.new("IntValue")
    money.Name = "Money"
    money.Parent = folder
    return money
end

local function save(player)
    local s = state[player]
    if not s then return end
    local money = leaderstats(player).Value
    pcall(function()
        STORE:SetAsync("u_" .. player.UserId, {
            Money = money,
            SecretsFound = s.secretsFound or 0,
            JobUnlocked = s.jobUnlocked == true,
        })
    end)
end

local function load(player)
    local data
    pcall(function()
        data = STORE:GetAsync("u_" .. player.UserId)
    end)
    local s = {
        secretsFound = (data and data.SecretsFound) or 0,
        jobUnlocked = (data and data.JobUnlocked) or false,
        inJob = false,
    }
    state[player] = s
    leaderstats(player).Value = (data and data.Money) or 0
end

local function part(name, size, pos, material)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = pos
    p.Anchored = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.Parent = Workspace
    return p
end

local function makePrototypeWorld()
    if Workspace:FindFirstChild("SECRET_VILLAGE_MVP") then return end
    local root = Instance.new("Folder")
    root.Name = "SECRET_VILLAGE_MVP"
    root.Parent = Workspace

    local ground = part("VillageGround", Vector3.new(260, 2, 260), Vector3.new(0, -1, 0), Enum.Material.Grass)
    ground.Parent = root

    -- Two water bodies.
    local riverA = part("River_Secret", Vector3.new(28, 1, 150), Vector3.new(-45, 0, 10), Enum.Material.Glass)
    riverA.Color = Color3.fromRGB(40, 150, 210)
    riverA.Transparency = 0.25
    riverA.Parent = root

    local pond = part("Pond_Normal", Vector3.new(55, 1, 45), Vector3.new(65, 0, -55), Enum.Material.Glass)
    pond.Color = Color3.fromRGB(40, 150, 210)
    pond.Transparency = 0.25
    pond.Parent = root

    -- Hidden underwater door.
    local door = part("SECRET_DOOR", Vector3.new(10, 8, 1), Vector3.new(-45, -3, 65), Enum.Material.Metal)
    door.Color = Color3.fromRGB(35, 35, 40)
    door.Parent = root

    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Открыть"
    prompt.ObjectText = "Странная дверь"
    prompt.HoldDuration = 1
    prompt.MaxActivationDistance = 10
    prompt.Parent = door

    prompt.Triggered:Connect(function(player)
        local s = state[player]
        if not s then return end
        if s.secretsFound < 1 then
            s.secretsFound = 1
            notify(player, "🔓 SECRET #001 найден! Добро пожаловать в тайную комнату.")
        end

        local room = root:FindFirstChild("SecretRoom")
        if not room then
            room = Instance.new("Folder")
            room.Name = "SecretRoom"
            room.Parent = root
            local floor = part("SecretFloor", Vector3.new(36, 2, 28), Vector3.new(-45, -8, 75), Enum.Material.Metal)
            floor.Parent = room
            local back = part("SecretBack", Vector3.new(36, 14, 2), Vector3.new(-45, -1, 89), Enum.Material.Metal)
            back.Parent = room
            local sign = part("SecretSign", Vector3.new(14, 5, 1), Vector3.new(-45, 2, 88), Enum.Material.Neon)
            sign.Color = Color3.fromRGB(255, 190, 50)
            sign.Parent = room
        end
        player.Character:PivotTo(CFrame.new(-45, -5, 78))
        save(player)
    end)

    -- Job leaves around the village.
    local leaves = Instance.new("Folder")
    leaves.Name = "Leaves"
    leaves.Parent = root
    for i = 1, 60 do
        local x = math.random(-115, 115)
        local z = math.random(-115, 115)
        local leaf = part("Leaf_" .. i, Vector3.new(2, 0.3, 2), Vector3.new(x, 0.5, z), Enum.Material.Grass)
        leaf.Shape = Enum.PartType.Ball
        leaf.Color = Color3.fromRGB(180, 110, 35)
        leaf.Parent = leaves
        local pp = Instance.new("ProximityPrompt")
        pp.ActionText = "Убрать"
        pp.ObjectText = "Лист"
        pp.HoldDuration = 0.15
        pp.MaxActivationDistance = 7
        pp.Parent = leaf
        pp.Triggered:Connect(function(player)
            local s = state[player]
            if not s or not s.inJob or leaf:GetAttribute("Taken") then return end
            leaf:SetAttribute("Taken", true)
            leaf.Transparency = 1
            pp.Enabled = false
            leaderstats(player).Value += LEAF_REWARD
            notify(player, "+$1 🍂")
        end)
    end

    -- Seller.
    local seller = part("FoodSeller", Vector3.new(5, 7, 5), Vector3.new(20, 3.5, 35), Enum.Material.Wood)
    seller.Parent = root
    local sp = Instance.new("ProximityPrompt")
    sp.ActionText = "Поговорить"
    sp.ObjectText = "Продавец еды"
    sp.Parent = seller
    sp.Triggered:Connect(function(player)
        notify(player, "🍎 Продавец: Я слышал странный шум у воды... Если хочешь подсказку — $500.")
    end)
end

Hint.OnServerEvent:Connect(function(player)
    local money = leaderstats(player)
    if money.Value < HINT_COST then
        notify(player, "❌ Нужно $500 для подсказки.")
        return
    end
    money.Value -= HINT_COST
    notify(player, "🔎 Подсказка: ищи там, где вода скрывает то, чего не должно быть видно.")
    save(player)
end)

Job.OnServerEvent:Connect(function(player)
    local s = state[player]
    if not s then return end
    local money = leaderstats(player)
    if not s.jobUnlocked then
        if money.Value < JOB_COST then
            notify(player, "❌ Чтобы стать дворником, нужно $100.")
            return
        end
        money.Value -= JOB_COST
        s.jobUnlocked = true
    end
    s.inJob = true
    notify(player, "🧹 Ты на работе! Таймер остановлен лично для тебя. Убирай листья.")
    save(player)
end)

Players.PlayerAdded:Connect(function(player)
    load(player)
    task.defer(function()
        notify(player, "🏘️ Добро пожаловать! У тебя 30 минут. Найди SECRET #001.")
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    save(player)
    state[player] = nil
end)

makePrototypeWorld()

-- Global round timer. Players in Work Mode are exempt from countdown.
task.spawn(function()
    while true do
        task.wait(1)
        for player, s in pairs(state) do
            if player.Parent and not s.inJob then
                local remaining = math.max(0, ROUND_SECONDS - (os.time() - roundStartedAt))
                player:SetAttribute("RoundSeconds", remaining)
                if remaining == 0 then
                    notify(player, "⏰ Раунд закончен! Твои деньги и секреты сохранены.")
                    player:LoadCharacter()
                    s.inJob = false
                    roundStartedAt = os.time()
                end
            else
                player:SetAttribute("RoundSeconds", -1)
            end
        end
    end
end)
