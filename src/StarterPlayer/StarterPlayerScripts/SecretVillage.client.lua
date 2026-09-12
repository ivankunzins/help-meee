-- SECRET VILLAGE — unified mobile/PC HUD v2
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify")
local Hint=remotes:WaitForChild("BuyHint")
local StartJob=remotes:WaitForChild("StartJob")
local EndJob=remotes:WaitForChild("EndJob")
local SpawnVehicle=remotes:WaitForChild("SpawnVehicle")
local gui=Instance.new("ScreenGui");gui.Name="SecretVillageUI";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.Parent=player:WaitForChild("PlayerGui")
local function panel(size,pos)local f=Instance.new("Frame");f.Size=size;f.Position=pos;f.BackgroundTransparency=.12;f.BorderSizePixel=0;f.Parent=gui;local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,14);c.Parent=f;return f end
local function label(size,pos,str,parent)local t=Instance.new("TextLabel");t.Size=size;t.Position=pos;t.BackgroundTransparency=1;t.Text=str;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.new(1,1,1);t.Parent=parent;return t end
local top=panel(UDim2.new(.9,0,0,96),UDim2.new(.05,0,0,14));label(UDim2.fromScale(.6,.4),UDim2.fromScale(.02,.04),"🔎 SECRET VILLAGE",top)
local timer=label(UDim2.fromScale(.6,.48),UDim2.fromScale(.02,.43),"⏱️ 30:00",top);local money=label(UDim2.fromScale(.32,.42),UDim2.fromScale(.66,.06),"💰 $0",top);local secrets=label(UDim2.fromScale(.32,.42),UDim2.fromScale(.66,.50),"🔐 0 / 100",top)
local objective=panel(UDim2.new(.9,0,0,55),UDim2.new(.05,0,0,122));local objectiveText=label(UDim2.fromScale(1,1),UDim2.fromScale(0,0),"🎯 Цель: найди первый секрет",objective)
local buttons=panel(UDim2.fromOffset(235,210),UDim2.new(0,14,1,-228))
local function button(y,str,fn)local b=Instance.new("TextButton");b.Size=UDim2.new(1,-10,0,42);b.Position=UDim2.new(0,5,0,y);b.Text=str;b.TextScaled=true;b.Font=Enum.Font.GothamBold;b.Parent=buttons;local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,10);c.Parent=b;b.Activated:Connect(fn);return b end
button(5,"🔎 Подсказка — $500",function()Hint:FireServer()end)
local jobButton=button(51,"🧹 Работа — $100",function()if player:GetAttribute("InJob") then EndJob:FireServer() else StartJob:FireServer() end end)
button(97,"🚗 Машина",function()SpawnVehicle:FireServer("VillageCar")end)
button(143,"🚕 Такси — $500",function()SpawnVehicle:FireServer("Taxi")end)
button(189,"📦 Фургон — $750",function()SpawnVehicle:FireServer("DeliveryVan")end)
local toast=label(UDim2.new(.8,0,0,70),UDim2.new(.1,0,1,-90),"",gui);toast.Visible=false;toast.TextWrapped=true;local toastToken=0
Notify.OnClientEvent:Connect(function(msg)toastToken+=1;local id=toastToken;toast.Text=msg;toast.Visible=true;task.delay(3.5,function()if id==toastToken then toast.Visible=false end end)end)
local function update()
 local s=player:GetAttribute("RoundSeconds");if s==nil then timer.Text="⏳ Загрузка..." else timer.Text=string.format("⏱️ %02d:%02d",math.floor(s/60),s%60) end;if player:GetAttribute("InJob") then timer.Text="🧹 РАБОТА — ТАЙМЕР ПАУЗА" end
 local ls=player:FindFirstChild("leaderstats");local m=ls and ls:FindFirstChild("Money");if m then money.Text="💰 $"..m.Value end
 local n=player:GetAttribute("SecretsFound") or 0;secrets.Text="🔐 "..n.." / 100";jobButton.Text=player:GetAttribute("InJob") and "🛑 Закончить смену" or "🧹 Работа — $100";if n>=10 then objectiveText.Text="🏆 Цель: открыть MASTER EXPLORER" elseif n>0 then objectiveText.Text="🎯 Цель: найди следующий секрет" end
end
local ls=player:WaitForChild("leaderstats",20);if ls and ls:FindFirstChild("Money") then ls.Money:GetPropertyChangedSignal("Value"):Connect(update) end
for _,a in ipairs({"RoundSeconds","SecretsFound","InJob"}) do player:GetAttributeChangedSignal(a):Connect(update) end
update()
