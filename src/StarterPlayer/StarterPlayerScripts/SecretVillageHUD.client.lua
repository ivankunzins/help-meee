-- SECRET VILLAGE polished HUD layer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")

local gui = Instance.new("ScreenGui")
gui.Name = "SecretVillagePolishedHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function makeLabel(size,pos,text)
    local x=Instance.new("TextLabel")
    x.Size=size;x.Position=pos;x.BackgroundTransparency=.15;x.Text=text
    x.TextScaled=true;x.Font=Enum.Font.GothamBold;x.Parent=gui
    return x
end

local money = makeLabel(UDim2.fromOffset(190,50),UDim2.new(1,-210,0,20),"💵 $0")
local secrets = makeLabel(UDim2.fromOffset(190,45),UDim2.new(1,-210,0,78),"🔐 0 / 100")
local objective = makeLabel(UDim2.fromOffset(330,54),UDim2.new(.5,-165,0,112),"🔎 Найди SECRET #001")

local toast = makeLabel(UDim2.fromOffset(500,65),UDim2.new(.5,-250,1,-95),"")
toast.Visible=false
local token=0
Notify.OnClientEvent:Connect(function(text)
    token+=1;local id=token
    toast.Text=text;toast.Visible=true
    task.delay(3,function() if id==token then toast.Visible=false end end)
end)

local function refresh()
    local ls=player:FindFirstChild("leaderstats")
    local m=ls and ls:FindFirstChild("Money")
    money.Text="💵 $"..tostring(m and m.Value or 0)
    secrets.Text="🔐 "..tostring(player:GetAttribute("SecretsFound") or 0).." / 100"
end

local ls=player:WaitForChild("leaderstats")
local m=ls:WaitForChild("Money")
m.Changed:Connect(refresh)
player:GetAttributeChangedSignal("SecretsFound"):Connect(refresh)
refresh()
