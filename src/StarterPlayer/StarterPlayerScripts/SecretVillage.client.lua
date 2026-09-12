-- SECRET VILLAGE — unified mobile/PC HUD v4
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local remotes=ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify=remotes:WaitForChild("Notify");local Hint=remotes:WaitForChild("BuyHint");local StartJob=remotes:WaitForChild("StartJob");local EndJob=remotes:WaitForChild("EndJob");local BuyFisher=remotes:WaitForChild("BuyFisher");local SpawnVehicle=remotes:WaitForChild("SpawnVehicle");local GetSecretStatus=remotes:WaitForChild("GetSecretStatus")
local gui=Instance.new("ScreenGui");gui.Name="SecretVillageUI";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.Parent=player:WaitForChild("PlayerGui")
local function corner(x)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,12);c.Parent=x end
local function panel(size,pos)local f=Instance.new("Frame");f.Size=size;f.Position=pos;f.BackgroundTransparency=.12;f.BorderSizePixel=0;f.Parent=gui;corner(f);return f end
local function text(size,pos,str,parent)local t=Instance.new("TextLabel");t.Size=size;t.Position=pos;t.BackgroundTransparency=1;t.Text=str;t.TextScaled=true;t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.new(1,1,1);t.Parent=parent;return t end
local top=panel(UDim2.new(.9,0,0,96),UDim2.new(.05,0,0,14));text(UDim2.fromScale(.6,.4),UDim2.fromScale(.02,.04),"🔎 SECRET VILLAGE",top)
local timer=text(UDim2.fromScale(.6,.48),UDim2.fromScale(.02,.43),"⏱️ 30:00",top);local money=text(UDim2.fromScale(.32,.42),UDim2.fromScale(.66,.06),"💰 $0",top);local secrets=text(UDim2.fromScale(.32,.42),UDim2.fromScale(.66,.50),"🔐 0 / 100",top)
local objective=panel(UDim2.new(.9,0,0,55),UDim2.new(.05,0,0,122));local objectiveText=text(UDim2.fromScale(1,1),UDim2.fromScale(0,0),"🎯 Цель: найди первый секрет",objective)
local buttons=panel(UDim2.fromOffset(235,300),UDim2.new(0,14,1,-318))
local function button(y,str,fn)local b=Instance.new("TextButton");b.Size=UDim2.new(1,-10,0,40);b.Position=UDim2.new(0,5,0,y);b.Text=str;b.TextScaled=true;b.Font=Enum.Font.GothamBold;b.Parent=buttons;corner(b);b.Activated:Connect(fn);return b end
button(5,"🔎 Подсказка — $500",function()Hint:FireServer()end)
local jobButton=button(49,"🧹 Работа — $100",function()if player:GetAttribute("InJob")then EndJob:FireServer()else StartJob:FireServer()end end)
button(93,"🎣 Рыбак — $250",function()BuyFisher:FireServer()end)
button(137,"🚗 Машина",function()SpawnVehicle:FireServer("VillageCar")end)
button(181,"🚕 Такси — $500",function()SpawnVehicle:FireServer("Taxi")end)
button(225,"📦 Фургон — $750",function()SpawnVehicle:FireServer("DeliveryVan")end)
local book
local bookButton=button(269,"📖 Книга тайн",function()book.Visible=not book.Visible;if book.Visible then refreshBook()end end)
book=panel(UDim2.new(.78,0,0,390),UDim2.new(.11,0,.5,-195));book.Visible=false
text(UDim2.new(1,-20,0,44),UDim2.new(0,10,0,8),"📖 КНИГА ТАЙН",book)
local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(40,36);close.Position=UDim2.new(1,-50,0,8);close.Text="✕";close.TextScaled=true;close.Parent=book;corner(close);close.Activated:Connect(function()book.Visible=false end)
local scroll=Instance.new("ScrollingFrame");scroll.Size=UDim2.new(1,-20,1,-60);scroll.Position=UDim2.new(0,10,0,55);scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0;scroll.ScrollBarThickness=6;scroll.CanvasSize=UDim2.new();scroll.Parent=book
local layout=Instance.new("UIListLayout");layout.Padding=UDim.new(0,5);layout.Parent=scroll
function refreshBook()
 for _,x in ipairs(scroll:GetChildren())do if x:IsA("TextLabel")then x:Destroy()end end
 local ok,status=pcall(function()return GetSecretStatus:InvokeServer()end);if not ok then return end
 for i=1,100 do local row=Instance.new("TextLabel");row.Size=UDim2.new(1,-8,0,30);row.BackgroundTransparency=.2;row.TextXAlignment=Enum.TextXAlignment.Left;row.TextScaled=true;row.Font=Enum.Font.Gotham;row.Text=status[i] and "🔓 #"..string.format("%03d",i).."  НАЙДЕН" or "🔒 #"..string.format("%03d",i).."  ???";row.Parent=scroll;corner(row)end
 task.defer(function()scroll.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+10)end)
end
local toast=text(UDim2.new(.8,0,0,70),UDim2.new(.1,0,1,-90),"",gui);toast.Visible=false;toast.TextWrapped=true;local token=0
Notify.OnClientEvent:Connect(function(msg)token+=1;local id=token;toast.Text=msg;toast.Visible=true;if book.Visible then refreshBook()end;task.delay(3.5,function()if id==token then toast.Visible=false end end)end)
local function update()
 local s=player:GetAttribute("RoundSeconds");if s==nil then timer.Text="⏳ Загрузка..."else timer.Text=string.format("⏱️ %02d:%02d",math.floor(s/60),s%60)end;if player:GetAttribute("InJob")then timer.Text="🧹 РАБОТА — ТАЙМЕР ПАУЗА"end
 local ls=player:FindFirstChild("leaderstats");local m=ls and ls:FindFirstChild("Money");if m then money.Text="💰 $"..m.Value end
 local n=player:GetAttribute("SecretsFound")or 0;secrets.Text="🔐 "..n.." / 100";jobButton.Text=player:GetAttribute("InJob")and "🛑 Закончить смену"or "🧹 Дворник — $100";objectiveText.Text=n>=50 and "👑 Цель: собрать половину коллекции" or n>=10 and "🏆 Цель: MASTER EXPLORER" or n>0 and "🎯 Цель: найди следующий секрет" or "🎯 Цель: найди первый секрет"
end
local ls=player:WaitForChild("leaderstats",20);if ls and ls:FindFirstChild("Money")then ls.Money:GetPropertyChangedSignal("Value"):Connect(update)end
for _,a in ipairs({"RoundSeconds","SecretsFound","InJob"})do player:GetAttributeChangedSignal(a):Connect(update)end
update()
