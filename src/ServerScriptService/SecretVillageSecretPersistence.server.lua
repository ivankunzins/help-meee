-- SECRET VILLAGE — persistent individual secret ownership v2
local Players=game:GetService("Players")
local DataStoreService=game:GetService("DataStoreService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")

local Store=DataStoreService:GetDataStore("SecretVillage_Secrets_v1")
local award=ReplicatedStorage:FindFirstChild("SecretAward") or Instance.new("BindableEvent")
award.Name="SecretAward"
award.Parent=ReplicatedStorage

local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local status=remotes:FindFirstChild("GetSecretStatus") or Instance.new("RemoteFunction")
status.Name="GetSecretStatus"
status.Parent=remotes

local data={}
local loading={}
local loaded={}
local saving={}

local function notify(p,text)
 if p and p.Parent then
  Notify:FireClient(p,text)
 end
end

local function load(p)
 loading[p]=true
 loaded[p]=false

 local saved={}
 local ok,result=pcall(function()
  return Store:GetAsync("u_"..p.UserId)
 end)

 if not ok then
  warn("SecretVillage: secret data load failed for "..p.Name..": "..tostring(result))
  data[p]=nil
  loading[p]=nil
  return false
 end

 if type(result)=="table" then
  saved=result
 end

 data[p]=saved
 local count=0
 for id,value in pairs(saved) do
  if value==true then
   local numericId=tonumber(id)
   if numericId and numericId>=1 and numericId<=100 then
    p:SetAttribute("Secret_"..numericId,true)
    count+=1
   end
  end
 end

 p:SetAttribute("SecretsFound",math.max(p:GetAttribute("SecretsFound") or 0,count))
 p:SetAttribute("SecretsLoaded",true)
 loaded[p]=true
 loading[p]=nil
 return true
end

local function save(p)
 local d=data[p]
 if not d or not loaded[p] or saving[p] then
  return false
 end

 saving[p]=true
 local success=false
 for attempt=1,3 do
  local ok,err=pcall(function()
   Store:UpdateAsync("u_"..p.UserId,function()
    return d
   end)
  end)
  if ok then
   success=true
   break
  end
  warn("SecretVillage: secret data save attempt "..attempt.." failed for "..p.Name..": "..tostring(err))
  task.wait(attempt)
 end
 saving[p]=nil
 return success
end

award.Event:Connect(function(p,id,reward,name)
 if not p or not p.Parent or type(id)~="number" then return end
 if id<1 or id>100 or id%1~=0 then return end
 if not loaded[p] or loading[p] then
  notify(p,"⏳ Коллекция секретов ещё загружается. Попробуй через секунду.")
  return
 end
 if p:GetAttribute("Secret_"..id) then
  notify(p,"✅ Этот секрет уже есть в коллекции.")
  return
 end

 data[p]=data[p] or {}
 data[p][tostring(id)]=true
 p:SetAttribute("Secret_"..id,true)
 p:SetAttribute("SecretsFound",(p:GetAttribute("SecretsFound") or 0)+1)

 local money=p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Money")
 if money and type(reward)=="number" and reward>0 then
  money.Value+=math.floor(reward)
 end

 notify(p,string.format("🔐 SECRET #%03d найден: %s  +$%d",id,tostring(name or "Секрет"),math.max(0,math.floor(reward or 0))))
 save(p)
end)

status.OnServerInvoke=function(p)
 local result={}
 local d=data[p] or {}
 for i=1,100 do
  result[i]=d[tostring(i)]==true or p:GetAttribute("Secret_"..i)==true
 end
 return result
end

Players.PlayerAdded:Connect(function(p)
 task.defer(load,p)
end)

for _,p in ipairs(Players:GetPlayers()) do
 task.defer(load,p)
end

Players.PlayerRemoving:Connect(function(p)
 save(p)
 data[p]=nil
 loading[p]=nil
 loaded[p]=nil
 saving[p]=nil
end)

task.spawn(function()
 while true do
  task.wait(120)
  for p in pairs(data) do
   if p.Parent then
    save(p)
   end
  end
 end
end)

game:BindToClose(function()
 for p in pairs(data) do
  save(p)
 end
end)
