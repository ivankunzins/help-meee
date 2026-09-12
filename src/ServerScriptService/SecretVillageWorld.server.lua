-- SECRET VILLAGE WORLD / expansion systems
-- Add alongside SecretVillage.server.lua.
-- Builds a richer village, collectibles, jobs, events, vehicles and secret progression.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local root = Workspace:FindFirstChild("SECRET_VILLAGE_WORLD") or Instance.new("Folder")
root.Name = "SECRET_VILLAGE_WORLD"
root.Parent = Workspace

local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")
local Job = remotes:WaitForChild("BuyJob")

local playerState = {}

local function notify(p, text)
    Notify:FireClient(p, text)
end

local function makePart(name, size, cf, material, parent)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent or root
    return p
end

local function label(part, text)
    local gui = Instance.new("BillboardGui")
    gui.Name = "Label"
    gui.Size = UDim2.fromOffset(220, 50)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.AlwaysOnTop = true
    gui.Parent = part
    local t = Instance.new("TextLabel")
    t.Size = UDim2.fromScale(1, 1)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextScaled = true
    t.Font = Enum.Font.GothamBold
    t.Parent = gui
end

local function makeHouse(pos, name, scale)
    local f = Instance.new("Folder")
    f.Name = name
    f.Parent = root
    local s = scale or 1
    local body = makePart("House", Vector3.new(18*s, 10*s, 16*s), CFrame.new(pos + Vector3.new(0,5*s,0)), Enum.Material.Brick, f)
    local roof = makePart("Roof", Vector3.new(20*s, 2*s, 18*s), CFrame.new(pos + Vector3.new(0,11*s,0)), Enum.Material.Slate, f)
    local door = makePart("Door", Vector3.new(4*s, 7*s, .5*s), CFrame.new(pos + Vector3.new(0,3.5*s,-8.2*s)), Enum.Material.Wood, f)
    local window1 = makePart("Window", Vector3.new(4*s,3*s,.3*s), CFrame.new(pos + Vector3.new(-5*s,6*s,-8.3*s)), Enum.Material.Glass, f)
    local window2 = makePart("Window", Vector3.new(4*s,3*s,.3*s), CFrame.new(pos + Vector3.new(5*s,6*s,-8.3*s)), Enum.Material.Glass, f)
    label(door, name)
end

local function makeTree(pos)
    local f = Instance.new("Folder")
    f.Name = "Tree"
    f.Parent = root
    makePart("Trunk", Vector3.new(2,8,2), CFrame.new(pos + Vector3.new(0,4,0)), Enum.Material.Wood, f)
    local crown = makePart("Crown", Vector3.new(8,8,8), CFrame.new(pos + Vector3.new(0,9,0)), Enum.Material.Grass, f)
    crown.Shape = Enum.PartType.Ball
end

local function makeWorld()
    if root:GetAttribute("Built") then return end
    root:SetAttribute("Built", true)

    -- Roads and village square.
    makePart("MainRoad", Vector3.new(230, .25, 14), CFrame.new(0,.2,0), Enum.Material.Asphalt)
    makePart("CrossRoad", Vector3.new(14, .25, 210), CFrame.new(0,.2,0), Enum.Material.Asphalt)
    local square = makePart("VillageSquare", Vector3.new(55,.3,55), CFrame.new(35,.25,30), Enum.Material.Cobblestone)
    label(square, "VILLAGE SQUARE")

    -- Buildings.
    makeHouse(Vector3.new(55,0,-5), "Bakery", 1)
    makeHouse(Vector3.new(90,0,45), "Village Shop", .9)
    makeHouse(Vector3.new(-70,0,-30), "Old House", 1.15)
    makeHouse(Vector3.new(70,0,90), "Garage", 1.1)
    makeHouse(Vector3.new(-75,0,75), "Forest Cabin", .85)

    -- Trees around the outskirts.
    for i=1,45 do
        local angle = math.random()*math.pi*2
        local radius = math.random(95,130)
        makeTree(Vector3.new(math.cos(angle)*radius,0,math.sin(angle)*radius))
    end

    -- Secret clue signs; intentionally subtle.
    local clue1 = makePart("ClueStone", Vector3.new(3,2,3), CFrame.new(-20,1,-48), Enum.Material.Slate)
    label(clue1, "...")
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Осмотреть"
    prompt.ObjectText = "Старая надпись"
    prompt.HoldDuration = .5
    prompt.Parent = clue1
    prompt.Triggered:Connect(function(p)
        notify(p,"🗿 На камне выбито: «Вода помнит то, что деревня забыла».")
    end)

    -- Wandering trader.
    local trader = makePart("WanderingTrader", Vector3.new(4,7,4), CFrame.new(105,3.5,-75), Enum.Material.Wood)
    label(trader,"WANDERING TRADER")
    local tp = Instance.new("ProximityPrompt")
    tp.ActionText = "Торговать"
    tp.ObjectText = "Странствующий торговец"
    tp.Parent = trader
    tp.Triggered:Connect(function(p)
        notify(p,"🛒 Торговец: сегодня у меня есть редкая вещь... но цена меняется каждый день.")
    end)
end

local function money(p)
    local ls = p:FindFirstChild("leaderstats")
    return ls and ls:FindFirstChild("Money")
end

-- Extra job: Fisher. Unlock for $250 and catch fish for $8.
local fisher = makePart("FisherJob", Vector3.new(4,6,4), CFrame.new(70,3,10), Enum.Material.Wood)
label(fisher,"FISHER — $250")
local fp = Instance.new("ProximityPrompt")
fp.ActionText = "Работать"
fp.ObjectText = "Рыбак"
fp.Parent = fisher
fp.Triggered:Connect(function(p)
    local m = money(p)
    if not m then return end
    if m.Value < 250 then notify(p,"❌ Рыбак стоит $250."); return end
    m.Value -= 250
    playerState[p] = playerState[p] or {}
    playerState[p].job = "Fisher"
    notify(p,"🎣 Ты стал рыбаком. Ищи рыбу у водоёма!")
end)

-- Fishing spots.
for i=1,12 do
    local x = 48 + math.random(-22,22)
    local z = -55 + math.random(-16,16)
    local fish = makePart("FishSpot_"..i, Vector3.new(2,1,2), CFrame.new(x,.6,z), Enum.Material.Neon)
    fish.Transparency = .35
    local pp = Instance.new("ProximityPrompt")
    pp.ActionText = "Ловить"
    pp.ObjectText = "Рыба"
    pp.HoldDuration = 1
    pp.Parent = fish
    pp.Triggered:Connect(function(p)
        local s = playerState[p]
        if not s or s.job ~= "Fisher" then notify(p,"🎣 Сначала устройся рыбаком."); return end
        if fish:GetAttribute("Cooldown") then notify(p,"⏳ Здесь пока ничего не клюёт."); return end
        fish:SetAttribute("Cooldown",true)
        local m = money(p)
        if m then m.Value += 8 end
        notify(p,"🐟 +$8")
        task.delay(12,function() fish:SetAttribute("Cooldown",nil) end)
    end)
end

-- Secret #002: stone clue + night event unlock.
local secret2 = makePart("Secret002", Vector3.new(3,3,3), CFrame.new(-90,1,40), Enum.Material.DiamondPlate)
secret2.Transparency = .9
local s2p = Instance.new("ProximityPrompt")
s2p.ActionText = "Открыть"
s2p.ObjectText = "Странный люк"
s2p.HoldDuration = 1
s2p.Parent = secret2
s2p.Triggered:Connect(function(p)
    if Workspace:GetAttribute("NightEvent") ~= true then
        notify(p,"🌙 Люк не реагирует. Возможно, ему нужна ночь...")
        return
    end
    local count = p:GetAttribute("SecretsFound") or 0
    if count < 2 then p:SetAttribute("SecretsFound",2) end
    secret2.Transparency = 0
    notify(p,"🔓 SECRET #002 найден! Ты открыл ночной люк.")
end)

makeWorld()

-- Dynamic events every 4–7 minutes.
task.spawn(function()
    while true do
        task.wait(math.random(240,420))
        local event = math.random(1,4)
        if event == 1 then
            Workspace:SetAttribute("NightEvent",true)
            game.Lighting.ClockTime = 0
            for _,p in ipairs(Players:GetPlayers()) do notify(p,"🌙 СОБЫТИЕ: наступила ночь! Ищи то, чего не видно днём.") end
            task.wait(90)
            Workspace:SetAttribute("NightEvent",false)
            game.Lighting.ClockTime = 14
        elseif event == 2 then
            for _,p in ipairs(Players:GetPlayers()) do notify(p,"🌫️ СОБЫТИЕ: деревню накрыл туман!") end
            game.Lighting.FogEnd = 120
            task.wait(75)
            game.Lighting.FogEnd = 100000
        elseif event == 3 then
            for _,p in ipairs(Players:GetPlayers()) do notify(p,"⚡ СОБЫТИЕ: отключение электричества! Где-то появился новый секрет.") end
            task.wait(60)
        else
            for _,p in ipairs(Players:GetPlayers()) do notify(p,"🚚 СОБЫТИЕ: в деревню приехал странный торговец!") end
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    playerState[p] = {}
end)
Players.PlayerRemoving:Connect(function(p)
    playerState[p] = nil
end)
