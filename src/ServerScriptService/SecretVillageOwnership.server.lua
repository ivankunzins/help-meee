-- SECRET VILLAGE — persistent upgrades/vehicles ownership
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local Store=DataStoreService:GetDataStore("SecretVillage_Ownership_v1")
local function load(p)
 local ok,d=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(d)=="table" then for k,v in pairs(d)do if v==true then p:SetAttribute(k,true)end end end
end
local function save(p)
 local d={}
 for k,v in pairs(p:GetAttributes())do if string.sub(k,1,4)=="Own_" and v==true then d[k]=true end end
 pcall(function()Store:SetAsync("u_"..p.UserId,d)end)
end
Players.PlayerAdded:Connect(function(p)task.defer(load,p)end)
Players.PlayerRemoving:Connect(save)
task.spawn(function()while true do task.wait(120);for _,p in ipairs(Players:GetPlayers())do save(p)end end end)
game:BindToClose(function()for _,p in ipairs(Players:GetPlayers())do save(p)end end)
