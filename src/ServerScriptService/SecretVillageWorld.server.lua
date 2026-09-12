-- SECRET VILLAGE WORLD v3
-- World generation + atmosphere/events only. Economy/jobs/secrets are owned by other systems.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local root = Workspace:FindFirstChild("SECRET_VILLAGE_WORLD") or Instance.new("Folder")
root.Name = "SECRET_VILLAGE_WORLD"
root.Parent = Workspace
local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")

local function notifyAll(text)
    for _, p in ipairs(Players:GetPlayers()) do Notify:FireClient(p, text) end
end
local function makePart(name, size, cf, material, parent, transparency)
    local p = Instance.new("Part")
    p.Name, p.Size, p.CFrame = name, size, cf
    p.Anchored = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
    p.Transparency = transparency or 0
    p.Parent = parent or root
    return p
end
local function label(part, text)
    local gui = Instance.new("BillboardGui")
    gui.Name, gui.Size, gui.StudsOffset, gui.AlwaysOnTop = "Label", UDim2.fromOffset(220,50), Vector3.new(0,4,0), true
    gui.Parent = part
    local t = Instance.new("TextLabel")
    t.Size, t.BackgroundTransparency, t.Text, t.TextScaled, t.Font = UDim2.fromScale(1,1), 1, text, true, Enum.Font.GothamBold
    t.Parent = gui
end
local function makeHouse(pos, name, scale)
    local f = Instance.new("Folder"); f.Name=name; f.Parent=root
    local s=scale or 1
    makePart("House",Vector3.new(18*s,10*s,16*s),CFrame.new(pos+Vector3.new(0,5*s,0)),Enum.Material.Brick,f)
    makePart("Roof",Vector3.new(20*s,2*s,18*s),CFrame.new(pos+Vector3.new(0,11*s,0)),Enum.Material.Slate,f)
    local door=makePart("Door",Vector3.new(4*s,7*s,.5*s),CFrame.new(pos+Vector3.new(0,3.5*s,-8.2*s)),Enum.Material.Wood,f)
    makePart("Window",Vector3.new(4*s,3*s,.3*s),CFrame.new(pos+Vector3.new(-5*s,6*s,-8.3*s)),Enum.Material.Glass,f)
    makePart("Window",Vector3.new(4*s,3*s,.3*s),CFrame.new(pos+Vector3.new(5*s,6*s,-8.3*s)),Enum.Material.Glass,f)
    label(door,name)
end
local function makeTree(pos)
    local f=Instance.new("Folder");f.Name="Tree";f.Parent=root
    makePart("Trunk",Vector3.new(2,8,2),CFrame.new(pos+Vector3.new(0,4,0)),Enum.Material.Wood,f)
    local crown=makePart("Crown",Vector3.new(8,8,8),CFrame.new(pos+Vector3.new(0,9,0)),Enum.Material.Grass,f); crown.Shape=Enum.PartType.Ball
end
local function makeWorld()
    if root:GetAttribute("Built") then return end
    root:SetAttribute("Built",true)
    makePart("MainRoad",Vector3.new(230,.25,14),CFrame.new(0,.2,0),Enum.Material.Asphalt)
    makePart("CrossRoad",Vector3.new(14,.25,210),CFrame.new(0,.2,0),Enum.Material.Asphalt)
    local square=makePart("VillageSquare",Vector3.new(55,.3,55),CFrame.new(35,.25,30),Enum.Material.Cobblestone);label(square,"VILLAGE SQUARE")
    -- Main river and a real submerged entrance.
    local river=makePart("River",Vector3.new(120,1,34),CFrame.new(-35,-.35,58),Enum.Material.Water)
    river.Color=Color3.fromRGB(35,120,170);river.Transparency=.25
    makePart("RiverBank",Vector3.new(124,1,4),CFrame.new(-35,.1,39),Enum.Material.Sand)
    makePart("RiverBank",Vector3.new(124,1,4),CFrame.new(-35,.1,77),Enum.Material.Sand)
    local door=makePart("UnderwaterDoor",Vector3.new(10,8,1),CFrame.new(-45,-3,65),Enum.Material.Metal)
    label(door,"???")
    local dp=Instance.new("ProximityPrompt");dp.ActionText="Открыть";dp.ObjectText="Подводная дверь";dp.HoldDuration=1.2;dp.Parent=door
    dp.Triggered:Connect(function(p)
        if (p:GetAttribute("SecretsFound") or 0)<1 then Notify:FireClient(p,"🌊 Дверь заперта. Сначала найди первый секрет.") else Notify:FireClient(p,"🚪 Подводная дверь разблокирована. За ней — тайная комната!") end
    end)
    local room=Instance.new("Folder");room.Name="SecretRoom";room.Parent=root
    makePart("RoomFloor",Vector3.new(30,1,24),CFrame.new(-45,-8,92),Enum.Material.Metal,room)
    makePart("RoomBack",Vector3.new(30,12,1),CFrame.new(-45,-2,104),Enum.Material.Metal,room)
    makePart("RoomLight",Vector3.new(2,2,2),CFrame.new(-45,-1,92),Enum.Material.Neon,room)
    makeHouse(Vector3.new(55,0,-5),"Bakery",1);makeHouse(Vector3.new(90,0,45),"Village Shop",.9);makeHouse(Vector3.new(-70,0,-30),"Old House",1.15);makeHouse(Vector3.new(70,0,90),"Garage",1.1);makeHouse(Vector3.new(-75,0,75),"Forest Cabin",.85)
    for i=1,45 do local a=math.random()*math.pi*2;local r=math.random(95,130);makeTree(Vector3.new(math.cos(a)*r,0,math.sin(a)*r)) end
    local clue=makePart("ClueStone",Vector3.new(3,2,3),CFrame.new(-20,1,-48),Enum.Material.Slate);label(clue,"...")
    local cp=Instance.new("ProximityPrompt");cp.ActionText="Осмотреть";cp.ObjectText="Старая надпись";cp.HoldDuration=.5;cp.Parent=clue
    cp.Triggered:Connect(function(p) Notify:FireClient(p,"🗿 На камне выбито: «Вода помнит то, что деревня забыла».") end)
    local trader=makePart("WanderingTrader",Vector3.new(4,7,4),CFrame.new(105,3.5,-75),Enum.Material.Wood);label(trader,"WANDERING TRADER")
    local tp=Instance.new("ProximityPrompt");tp.ActionText="Торговать";tp.ObjectText="Странствующий торговец";tp.Parent=trader
    tp.Triggered:Connect(function(p) Notify:FireClient(p,"🛒 Торговец: редкая вещь появится во время особого события.") end)
end
makeWorld()

task.spawn(function()
    while true do
        task.wait(math.random(240,420))
        local event=math.random(1,4)
        if event==1 then
            Workspace:SetAttribute("NightEvent",true);Lighting.ClockTime=0;notifyAll("🌙 СОБЫТИЕ: наступила ночь! Ищи то, чего не видно днём.");task.wait(90);Workspace:SetAttribute("NightEvent",false);Lighting.ClockTime=14
        elseif event==2 then
            notifyAll("🌫️ СОБЫТИЕ: деревню накрыл туман!");Lighting.FogEnd=120;task.wait(75);Lighting.FogEnd=100000
        elseif event==3 then
            Workspace:SetAttribute("BlackoutEvent",true);notifyAll("⚡ СОБЫТИЕ: отключение электричества! Где-то появился новый секрет.");task.wait(60);Workspace:SetAttribute("BlackoutEvent",false)
        else
            notifyAll("🚚 СОБЫТИЕ: в деревню приехал странный торговец!")
        end
    end
end)
