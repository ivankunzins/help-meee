-- SECRET VILLAGE — FULL PLAYABLE PROTOTYPE
-- Put this Script in ServerScriptService.
-- IMPORTANT: disable/delete the older SecretVillage.server.lua to avoid duplicate systems.

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local CONFIG = {
    Round = 1800,
    HintCost = 500,
    JobCost = 100,
    LeafReward = 1,
    JobDuration = 300,
    FoodPrices = {Apple=8, Bread=15, Fish=25, Mushroom=18, Corn=12},
}

local Store = DataStoreService:GetDataStore("SecretVillage_Full_v2")
local playerState = {}
local roundStart = os.time()
local world

local remotes = ReplicatedStorage:FindFirstChild("SecretVillageRemotes") or Instance.new("Folder")
remotes.Name = "SecretVillageRemotes"
remotes.Parent = ReplicatedStorage
local function R(name)
    local r = remotes:FindFirstChild(name) or Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = remotes
    return r
end
local Notify, BuyHint, StartJob, BuyItem, EndJob = R("Notify"),R("BuyHint"),R("StartJob"),R("BuyItem"),R("EndJob")

local function say(p,msg) Notify:FireClient(p,msg) end
local function stats(p)
    local f=p:FindFirstChild("leaderstats") or Instance.new("Folder",p); f.Name="leaderstats"
    local m=f:FindFirstChild("Money") or Instance.new("IntValue",f); m.Name="Money"
    return m
end
local function addMoney(p,n) stats(p).Value=math.max(0,stats(p).Value+n) end
local function save(p)
    local s=playerState[p]; if not s then return end
    pcall(function() Store:SetAsync("u_"..p.UserId,{Money=stats(p).Value,Secrets=s.secrets,Job=s.job,Items=s.items,Best=s.best}) end)
end
local function load(p)
    local d; pcall(function() d=Store:GetAsync("u_"..p.UserId) end)
    playerState[p]={secrets=(d and d.Secrets) or 0,job=(d and d.Job) or false,inJob=false,jobUntil=0,items=(d and d.Items) or {},best=(d and d.Best) or 0}
    stats(p).Value=(d and d.Money) or 0
    p:SetAttribute("RoundSeconds",CONFIG.Round); p:SetAttribute("SecretsFound",playerState[p].secrets); p:SetAttribute("InJob",false)
end
local function mk(name,size,pos,mat,parent)
    local x=Instance.new("Part"); x.Name=name;x.Size=size;x.Position=pos;x.Anchored=true;x.Material=mat or Enum.Material.SmoothPlastic;x.Parent=parent or world; return x
end
local function prompt(parent,action,obj,callback)
    local q=Instance.new("ProximityPrompt");q.ActionText=action;q.ObjectText=obj;q.HoldDuration=.25;q.MaxActivationDistance=10;q.RequiresLineOfSight=false;q.Parent=parent;q.Triggered:Connect(callback);return q
end
local function label(parent,text,pos,size)
    local b=Instance.new("BillboardGui");b.Size=UDim2.fromOffset(size or 180,55);b.StudsOffset=pos or Vector3.new(0,5,0);b.AlwaysOnTop=true;b.Parent=parent
    local t=Instance.new("TextLabel",b);t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=text;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextStrokeTransparency=.25;return b
end

local function house(pos,rotation,houseName)
    local f=Instance.new("Model");f.Name=houseName;f.Parent=world
    local base=mk("House",Vector3.new(24,10,20),pos,Enum.Material.WoodPlanks,f);base.CFrame=CFrame.new(pos)*CFrame.Angles(0,math.rad(rotation or 0),0)
    local roof=mk("Roof",Vector3.new(27,2,23),pos+Vector3.new(0,6,0),Enum.Material.Slate,f);roof.CFrame=CFrame.new(pos+Vector3.new(0,6,0))*CFrame.Angles(0,math.rad(rotation or 0),math.rad(0))
    local door=mk("Door",Vector3.new(4,7,.5),pos+Vector3.new(0,-1,-10.2),Enum.Material.Wood,f);door.Color=Color3.fromRGB(80,45,25)
    local window=mk("Window",Vector3.new(5,4,.4),pos+Vector3.new(6,1,-10.25),Enum.Material.Glass,f);window.Transparency=.2
    return f
end

local function createVehicle(name,pos,seatColor,speed)
    local m=Instance.new("Model");m.Name=name;m.Parent=world
    local body=mk("Body",Vector3.new(10,2.5,6),pos+Vector3.new(0,2,0),Enum.Material.Metal,m);body.Color=seatColor
    local seat=Instance.new("VehicleSeat");seat.Name="DriverSeat";seat.Size=Vector3.new(2,1,2);seat.Position=pos+Vector3.new(0,4,0);seat.MaxSpeed=speed;seat.Parent=m
    for _,off in ipairs({Vector3.new(-4,-.2,-2.5),Vector3.new(4,-.2,-2.5),Vector3.new(-4,-.2,2.5),Vector3.new(4,-.2,2.5)}) do
        local w=mk("Wheel",Vector3.new(1.6,1.6,1.6),pos+off,Enum.Material.Rubber,m);w.Shape=Enum.PartType.Cylinder;w.Orientation=Vector3.new(0,0,90)
    end
    label(body,name,Vector3.new(0,3,0),150)
    return m
end

local function giveItem(p,item)
    local s=playerState[p];s.items[item]=(s.items[item] or 0)+1
    p:SetAttribute("Item_"..item,s.items[item]);say(p,"🎒 Получено: "..item)
    save(p)
end

local function secretRoom()
    local room=Instance.new("Model");room.Name="SecretRoom";room.Parent=world
    mk("Floor",Vector3.new(50,2,40),Vector3.new(-55,-14,82),Enum.Material.Metal,room)
    mk("Back",Vector3.new(50,16,2),Vector3.new(-55,-6,101),Enum.Material.Metal,room)
    for i,item in ipairs({"MagicCarpet","EnergySword","RocketBlaster","BoomCannon"}) do
        local x=mk(item,Vector3.new(5,2,5),Vector3.new(-73+(i-1)*12,-10,82),Enum.Material.Neon,room)
        label(x,item,Vector3.new(0,3,0),130)
        prompt(x,"Взять",item,function(p) giveItem(p,item);x.Transparency=1;x.CanCollide=false end)
    end
    local exit=mk("Exit",Vector3.new(8,8,1),Vector3.new(-55,-6,62),Enum.Material.Metal,room)
    prompt(exit,"Выйти","Деревня",function(p) p.Character:PivotTo(CFrame.new(-55,3,55)) end)
end

local function buildWorld()
    if Workspace:FindFirstChild("SECRET_VILLAGE_FULL") then return end
    world=Instance.new("Folder");world.Name="SECRET_VILLAGE_FULL";world.Parent=Workspace
    mk("Ground",Vector3.new(320,2,320),Vector3.new(0,-1,0),Enum.Material.Grass)
    -- roads
    mk("MainRoad",Vector3.new(300,.25,18),Vector3.new(0,.2,0),Enum.Material.Concrete)
    mk("CrossRoad",Vector3.new(18,.25,300),Vector3.new(0,.21,0),Enum.Material.Concrete)
    -- river and pond
    local river=mk("SecretRiver",Vector3.new(32,.8,190),Vector3.new(-58,.1,20),Enum.Material.Glass);river.Color=Color3.fromRGB(35,145,220);river.Transparency=.25
    local pond=mk("VillagePond",Vector3.new(65,.8,52),Vector3.new(75,.1,-70),Enum.Material.Glass);pond.Color=Color3.fromRGB(35,145,220);pond.Transparency=.25
    -- bridge
    mk("Bridge",Vector3.new(45,2,12),Vector3.new(-58,2,0),Enum.Material.WoodPlanks)
    -- houses
    house(Vector3.new(38,5,35),0,"BakerHouse");house(Vector3.new(88,5,25),0,"FarmerHouse");house(Vector3.new(35,5,-45),180,"OldHouse");house(Vector3.new(95,5,45),180,"TraderHouse");house(Vector3.new(-10,5,65),0,"GuardHouse")
    -- town square fountain
    local fountain=mk("Fountain",Vector3.new(12,3,12),Vector3.new(20,1,15),Enum.Material.Marble);label(fountain,"VILLAGE",Vector3.new(0,4,0),160)
    -- seller
    local seller=mk("FoodSeller",Vector3.new(4,7,4),Vector3.new(45,3.5,48),Enum.Material.Wood);label(seller,"🍎 ПРОДАВЕЦ",Vector3.new(0,4,0),180)
    prompt(seller,"Торговать","Продавец еды",function(p)say(p,"🍎 Я покупаю еду! Я также знаю кое-что о реке. Попробуй поискать под водой.")end)
    for i,item in ipairs({"Apple","Bread","Fish","Mushroom","Corn"}) do
        local q=mk(item,Vector3.new(2,2,2),Vector3.new(34+i*3,2,53),Enum.Material.SmoothPlastic);label(q,item.." $"..CONFIG.FoodPrices[item],Vector3.new(0,2,0),100)
        prompt(q,"Продать",item,function(p)addMoney(p,CONFIG.FoodPrices[item]);say(p,"💰 +$"..CONFIG.FoodPrices[item]);end)
    end
    -- secret door
    local door=mk("SecretDoor",Vector3.new(10,7,1),Vector3.new(-58,-4,88),Enum.Material.Metal);door.Color=Color3.fromRGB(35,35,40);label(door,"???",Vector3.new(0,5,0),100)
    prompt(door,"Открыть","Странная дверь",function(p)
        local s=playerState[p];if s.secrets<1 then s.secrets=1;p:SetAttribute("SecretsFound",1);say(p,"🔓 SECRET #001 НАЙДЕН! Ты нашёл тайный бункер!");save(p) end
        if not world:FindFirstChild("SecretRoom") then secretRoom() end
        p.Character:PivotTo(CFrame.new(-58,-11,78))
    end)
    -- job office
    local office=mk("JanitorOffice",Vector3.new(6,6,6),Vector3.new(-15,3,45),Enum.Material.Wood);label(office,"🧹 РАБОТА",Vector3.new(0,4,0),170)
    prompt(office,"Устроиться","Дворник — $100",function(p)
        local s=playerState[p]
        if s.inJob then say(p,"Ты уже на смене.");return end
        if not s.job then if stats(p).Value<CONFIG.JobCost then say(p,"❌ Нужно $100.");return end;addMoney(p,-CONFIG.JobCost);s.job=true end
        s.inJob=true;s.jobUntil=os.time()+CONFIG.JobDuration;p:SetAttribute("InJob",true);say(p,"🧹 Смена началась! Таймер остановлен на 5 минут.")
    end)
    -- leaves
    local leaves=Instance.new("Folder");leaves.Name="Leaves";leaves.Parent=world
    math.randomseed(os.time())
    for i=1,90 do
        local x=math.random(-135,135);local z=math.random(-135,135)
        if math.abs(x+58)>18 then
            local leaf=mk("Leaf_"..i,Vector3.new(1.6,.35,1.6),Vector3.new(x,.45,z),Enum.Material.Grass,leaves);leaf.Shape=Enum.PartType.Ball;leaf.Color=Color3.fromRGB(170,105,30)
            prompt(leaf,"Убрать","Лист",function(p)
                local s=playerState[p];if not s or not s.inJob or leaf:GetAttribute("Taken") then return end
                leaf:SetAttribute("Taken",true);leaf.Transparency=1;leaf.CanCollide=false;addMoney(p,CONFIG.LeafReward);say(p,"🍂 +$1")
            end)
        end
    end
    -- vehicles
    createVehicle("Village Car",Vector3.new(120,0,0),Color3.fromRGB(180,180,180),45)
    createVehicle("Taxi",Vector3.new(-120,0,0),Color3.fromRGB(240,210,40),55)
    createVehicle("Fast Car",Vector3.new(0,0,125),Color3.fromRGB(120,120,120),70)
    -- trader
    local trader=mk("WanderingTrader",Vector3.new(5,7,5),Vector3.new(-5,3,105),Enum.Material.Wood);label(trader,"🛒 СТРАНСТВУЮЩИЙ",Vector3.new(0,5,0),200)
    prompt(trader,"Поговорить","Странствующий продавец",function(p)say(p,"🛒 Сегодня я продаю странные вещи... Следующий раунд меня здесь может уже не быть!")end)
    -- spawn
    local spawn=Instance.new("SpawnLocation");spawn.Name="VillageSpawn";spawn.Size=Vector3.new(12,1,12);spawn.Position=Vector3.new(20,1,30);spawn.Anchored=true;spawn.Neutral=true;spawn.Parent=world
end

BuyHint.OnServerEvent:Connect(function(p)
    if stats(p).Value<CONFIG.HintCost then say(p,"❌ Для подсказки нужно $500.");return end
    addMoney(p,-CONFIG.HintCost);local s=playerState[p]
    if s.secrets>=1 then say(p,"🔎 Ты уже нашёл главный секрет этой локации.");return end
    say(p,"🔎 ПОДСКАЗКА: вода скрывает вход. Ищи на дне реки, а не у берега.");save(p)
end)
BuyItem.OnServerEvent:Connect(function(p,item)
    if item=="MagicCarpet" then giveItem(p,item) end
end)
EndJob.OnServerEvent:Connect(function(p)
    local s=playerState[p];if not s or not s.inJob then return end;s.inJob=false;s.jobUntil=0;p:SetAttribute("InJob",false);say(p,"🧹 Смена закончена! Возвращайся исследовать деревню.");save(p)
end)

Players.PlayerAdded:Connect(function(p)load(p);task.delay(2,function()if p.Parent then say(p,"🏘️ Добро пожаловать! Найди SECRET #001 за 30 минут.")end end)end)
Players.PlayerRemoving:Connect(function(p)save(p);playerState[p]=nil end)
buildWorld()

task.spawn(function()
    while true do
        task.wait(1)
        for p,s in pairs(playerState) do
            if p.Parent then
                if s.inJob then
                    p:SetAttribute("RoundSeconds",-1)
                    if os.time()>=s.jobUntil then s.inJob=false;p:SetAttribute("InJob",false);say(p,"⏰ Смена закончилась! Таймер снова идёт.");save(p) end
                else
                    local rem=math.max(0,CONFIG.Round-(os.time()-roundStart));p:SetAttribute("RoundSeconds",rem)
                    if rem==0 then
                        say(p,"⏰ Время вышло! Прогресс сохранён — новый раунд.")
                        if p.Character then p.Character:PivotTo(CFrame.new(20,5,30)) end
                        roundStart=os.time()
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(120)
        for p in pairs(playerState) do save(p) end
    end
end)
