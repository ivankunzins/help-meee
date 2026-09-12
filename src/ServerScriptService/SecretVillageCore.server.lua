-- SECRET VILLAGE CORE v2
-- Authoritative round, economy, jobs and persistence controller.
-- This script intentionally replaces the old global-round logic.

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage:WaitForChild("SecretVillage"):WaitForChild("Config"))
local Store = DataStoreService:GetDataStore("SecretVillage_PlayerData_v2")

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
local StartJob = remote("StartJob")
local EndJob = remote("EndJob")
local BuyFisher = remote("BuyFisher")

local profiles = {}
local function notify(p, text) Notify:FireClient(p, text) end
local function money(p)
    local ls = p:FindFirstChild("leaderstats")
    return ls and ls:FindFirstChild("Money")
end
local function stats(p)
    local ls = p:FindFirstChild("leaderstats") or Instance.new("Folder")
    ls.Name = "leaderstats"; ls.Parent = p
    local m = ls:FindFirstChild("Money") or Instance.new("IntValue")
    m.Name = "Money"; m.Parent = ls
    return m
end

local function defaultProfile()
    return {
        Money = Config.StartingMoney,
        SecretsFound = 0,
        JanitorUnlocked = false,
        FisherUnlocked = false,
        TotalLeaves = 0,
        TotalFish = 0,
        Rounds = 0,
    }
end

local function load(p)
    local data
    local ok = pcall(function() data = Store:GetAsync("u_" .. p.UserId) end)
    local d = defaultProfile()
    if ok and type(data) == "table" then
        for k,v in pairs(d) do if data[k] ~= nil then d[k] = data[k] end end
    end
    profiles[p] = d
    stats(p).Value = d.Money
    p:SetAttribute("SecretsFound", d.SecretsFound)
    p:SetAttribute("InJob", false)
    p:SetAttribute("RoundSeconds", Config.RoundSeconds)
    p:SetAttribute("JanitorUnlocked", d.JanitorUnlocked)
    p:SetAttribute("FisherUnlocked", d.FisherUnlocked)
end

local function save(p)
    local d = profiles[p]; if not d then return end
    local m = stats(p)
    d.Money = m.Value
    d.SecretsFound = p:GetAttribute("SecretsFound") or d.SecretsFound
    d.JanitorUnlocked = p:GetAttribute("JanitorUnlocked") == true
    d.FisherUnlocked = p:GetAttribute("FisherUnlocked") == true
    pcall(function()
        Store:UpdateAsync("u_" .. p.UserId, function() return d end)
    end)
end

local function beginJob(p, kind)
    local d = profiles[p]; local m = money(p)
    if not d or not m then return end
    if p:GetAttribute("InJob") then notify(p,"🛑 Сначала закончи текущую смену."); return end
    local cost, attr, title
    if kind == "fisher" then cost=Config.FisherCost; attr="FisherUnlocked"; title="🎣 Рыбак" else cost=Config.JanitorCost; attr="JanitorUnlocked"; title="🧹 Дворник" end
    if not p:GetAttribute(attr) then
        if m.Value < cost then notify(p,"❌ Нужно $"..cost.."."); return end
        m.Value -= cost; p:SetAttribute(attr,true)
    end
    p:SetAttribute("InJob",true)
    p:SetAttribute("JobType",kind)
    p:SetAttribute("JobStarted",os.time())
    notify(p,title.." — смена началась. ⏸️ Твой таймер остановлен.")
end

StartJob.OnServerEvent:Connect(function(p) beginJob(p,"janitor") end)
BuyFisher.OnServerEvent:Connect(function(p) beginJob(p,"fisher") end)
EndJob.OnServerEvent:Connect(function(p)
    if not p:GetAttribute("InJob") then return end
    p:SetAttribute("InJob",false); p:SetAttribute("JobType","")
    notify(p,"✅ Смена закончена. Таймер снова идёт.")
end)

Hint.OnServerEvent:Connect(function(p)
    local m=money(p); if not m then return end
    if m.Value < Config.HintCost then notify(p,"❌ Нужно $"..Config.HintCost.."."); return end
    m.Value -= Config.HintCost
    notify(p,"🔎 Подсказка: "..Config.FoodSellerHint)
end)

Players.PlayerAdded:Connect(function(p)
    load(p)
    task.defer(function() notify(p,"🏘️ Добро пожаловать! У тебя 30 минут. Найди первый секрет.") end)
end)
Players.PlayerRemoving:Connect(function(p) save(p); profiles[p]=nil end)

task.spawn(function()
    while true do
        task.wait(1)
        for p,d in pairs(profiles) do
            if p.Parent then
                if not p:GetAttribute("InJob") then
                    local current = p:GetAttribute("RoundSeconds") or Config.RoundSeconds
                    current = math.max(0,current-1)
                    p:SetAttribute("RoundSeconds",current)
                    if current <= 0 then
                        d.Rounds += 1
                        save(p)
                        notify(p,"⏰ Раунд завершён! Прогресс сохранён.")
                        p:SetAttribute("InJob",false)
                        p:SetAttribute("RoundSeconds",Config.RoundSeconds)
                        if p.Character then p.Character:PivotTo(CFrame.new(0,5,0)) end
                    end
                end
            end
        end
    end
end)

-- Autosave protects progress during long sessions.
task.spawn(function()
    while true do
        task.wait(120)
        for p in pairs(profiles) do if p.Parent then save(p) end end
    end
end)
