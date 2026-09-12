-- SECRET VILLAGE — persistent individual secret ownership
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Store=DataStoreService:GetDataStore("SecretVillage_Secrets_v1")
local award=ReplicatedStorage:FindFirstChild("SecretAward") or Instance.new("BindableEvent");award.Name="SecretAward";award.Parent=ReplicatedStorage
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local status=remotes:FindFirstChild("GetSecretStatus") or Instance.new("RemoteFunction");status.Name="GetSecretStatus";status.Parent=remotes
local data={}
local function load(p)
 local saved={};local ok,result=pcall(function()return Store:GetAsync("u_"..p.UserId)end)
 if ok and type(result)=="table" then saved=result end;data[p]=saved
 local count=0
 for id,v in pairs(saved) do if v==true then p:SetAttribute("Secret_"..id,true);count+=1 end end
 if count>(p:GetAttribute("SecretsFound") or 0) then p:SetAttribute("SecretsFound",count) end
end
local function save(p)
 local d=data[p];if not d then return end
 pcall(function()Store:UpdateAsync("u_"..p.UserId,function()return d end)end)
end
award.Event:Connect(function(p,id,reward,name)
 if not p or not p.Parent or type(id)~="number" or p:GetAttribute("Secret_"..id) then return end
 data[p]=data[p] or {};data[p][tostring(id)]=true;p:SetAttribute("Secret_"..id,true)
 local m=p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Money");if m then m.Value+=reward end
 p:SetAttribute("SecretsFound",(p:GetAttribute("SecretsFound") or 0)+1)
 Notify:FireClient(p,string.format("🔐 SECRET #%03d найден: %s  +$%d",id,name,reward))
 save(p)
end)
status.OnServerInvoke=function(p)
 local result={};local d=data[p] or {}
 for i=1,100 do result[i]=d[tostring(i)]==true or p:GetAttribute("Secret_"..i)==true end
 return result
end
Players.PlayerAdded:Connect(function(p)task.defer(load,p)end)
Players.PlayerRemoving:Connect(function(p)save(p);data[p]=nil end)
task.spawn(function()while true do task.wait(120);for p in pairs(data)do if p.Parent then save(p)end end end end)
game:BindToClose(function()for p in pairs(data)do if p.Parent then save(p)end end end)
