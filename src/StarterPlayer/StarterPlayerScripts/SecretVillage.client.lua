-- SECRET VILLAGE — FULL UI
-- LocalScript: StarterPlayer > StarterPlayerScripts

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local Hint=remotes:WaitForChild("BuyHint")
local StartJob=remotes:WaitForChild("StartJob")
local EndJob=remotes:WaitForChild("EndJob")

local gui=Instance.new("ScreenGui");gui.Name="SecretVillageUI";gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local function frame(size,pos,parent)
 local f=Instance.new("Frame");f.Size=size;f.Position=pos;f.BackgroundTransparency=.12;f.Parent=parent;return f
end
local function text(size,pos,str,parent)
 local t=Instance.new("TextLabel");t.Size=size;t.Position=pos;t.BackgroundTransparency=1;t.Text=str;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.Parent=parent;return t
end
local top=frame(UDim2.fromOffset(360,100),UDim2.new(.5,-180,0,16),gui)
text(UDim2.fromScale(1,.38),UDim2.fromScale(0,0),"🔎 SECRET VILLAGE",top)
local timer=text(UDim2.fromScale(1,.55),UDim2.fromScale(0,.36),"⏱️ 30:00",top)
local money=text(UDim2.fromOffset(190,50),UDim2.new(1,-205,0,125),"💰 $0",gui)
local secrets=text(UDim2.fromOffset(180,50),UDim2.new(0,18,0,125),"🔐 0 / 100",gui)
local buttons=frame(UDim2.fromOffset(230,120),UDim2.new(0,18,1,-150),gui)
local function button(y,str,fn)
 local b=Instance.new("TextButton");b.Size=UDim2.new(1,-10,0,48);b.Position=UDim2.new(0,5,0,y);b.Text=str;b.TextScaled=true;b.Font=Enum.Font.GothamBold;b.Parent=buttons;b.Activated:Connect(fn);return b
end
button(5,"🔎 Подсказка — $500",function()Hint:FireServer()end)
local jobButton=button(61,"🧹 Работа — $100",function()StartJob:FireServer()end)
local toast=text(UDim2.fromOffset(600,70),UDim2.new(.5,-300,1,-100),"",gui);toast.Visible=false
local toastToken=0
Notify.OnClientEvent:Connect(function(msg)
 toastToken+=1;local id=toastToken;toast.Text=msg;toast.Visible=true
 task.delay(3,function()if id==toastToken then toast.Visible=false end end)
end)

local function update()
 local s=player:GetAttribute("RoundSeconds")
 if s==nil then timer.Text="⏳ Загрузка..." elseif s<0 then timer.Text="🧹 РАБОТА — ТАЙМЕР ПАУЗА" else timer.Text=string.format("⏱️ %02d:%02d",math.floor(s/60),s%60) end
 local m=player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Money")
 if m then money.Text="💰 $"..m.Value end
 secrets.Text="🔐 "..tostring(player:GetAttribute("SecretsFound") or 0).." / 100"
 if player:GetAttribute("InJob") then jobButton.Text="🛑 Закончить смену" else jobButton.Text="🧹 Работа — $100" end
end
local m=player:WaitForChild("leaderstats"):WaitForChild("Money");m:GetPropertyChangedSignal("Value"):Connect(update)
player:GetAttributeChangedSignal("RoundSeconds"):Connect(update);player:GetAttributeChangedSignal("SecretsFound"):Connect(update);player:GetAttributeChangedSignal("InJob"):Connect(function()
 if player:GetAttribute("InJob") then jobButton.Text="🛑 Закончить смену" else jobButton.Text="🧹 Работа — $100" end
end)
jobButton.Activated:Connect(function()if player:GetAttribute("InJob") then EndJob:FireServer() end end)
update()
