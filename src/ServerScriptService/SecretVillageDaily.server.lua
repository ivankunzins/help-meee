-- SECRET VILLAGE — daily challenge system
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Daily_v1")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local root=workspace:FindFirstChild("SECRET_DAILY") or Instance.new("Folder");root.Name="SECRET_DAILY";root.Parent=workspace
local today=os.date("!*t");local day=today.year*10000+today.month*100+today.day
local quests={{id="secrets",name="Найди 3 секрета",target=3,reward=750},{id="leaves",name="Убери 25 листьев",target=25,reward=500},{id="fish",name="Поймай 10 рыб",target=10,reward=650},{id="distance",name="Пройди 1500 studs",target=1500,reward=600}}
local q=quests[(day%#quests)+1]
local label=Instance.new("StringValue");label.Name="DailyChallenge";label.Value=q.name;label.Parent=root
local function money(p)local ls=p:FindFirstChild("leaderstats");return ls and ls:FindFirstChild("Money")end
local function load(p)
 local d={day=day,progress=0,claimed=false};local ok,x=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(x)=="table" and x.day==day then d=x end
 p:SetAttribute("DailyQuest",q.name);p:SetAttribute("DailyProgress",d.progress);p:SetAttribute("DailyTarget",q.target);p:SetAttribute("DailyClaimed",d.claimed)
end
local function save(p)
 local d={day=day,progress=p:GetAttribute("DailyProgress")or 0,claimed=p:GetAttribute("DailyClaimed")==true};pcall(function()Store:SetAsync("u_"..p.UserId,d)end)
end
local function progress(p,n)
 if p:GetAttribute("DailyClaimed") then return end
 local v=math.min(q.target,(p:GetAttribute("DailyProgress")or 0)+n);p:SetAttribute("DailyProgress",v)
 if v>=q.target then p:SetAttribute("DailyClaimed",true);local m=money(p);if m then m.Value+=q.reward end;Notify:FireClient(p,"🎯 ЕЖЕДНЕВНОЕ ЗАДАНИЕ ВЫПОЛНЕНО! +$"..q.reward);save(p)end
end
Players.PlayerAdded:Connect(function(p)
 task.defer(load,p)
 p:GetAttributeChangedSignal("SecretsFound"):Connect(function()if q.id=="secrets" then progress(p,1)end end)
 p:GetAttributeChangedSignal("TotalLeaves"):Connect(function()if q.id=="leaves" then progress(p,1)end end)
 p:GetAttributeChangedSignal("TotalFish"):Connect(function()if q.id=="fish" then progress(p,1)end end)
 p:GetAttributeChangedSignal("DailyProgress"):Connect(function()end)
end)
Players.PlayerRemoving:Connect(save)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do save(p)end end end)
