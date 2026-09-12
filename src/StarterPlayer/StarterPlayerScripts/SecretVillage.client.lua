-- SECRET VILLAGE / MVP client UI
-- Put this LocalScript into StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("SecretVillageRemotes")
local Notify = remotes:WaitForChild("Notify")
local Hint = remotes:WaitForChild("BuyHint")
local Job = remotes:WaitForChild("BuyJob")

local gui = Instance.new("ScreenGui")
gui.Name = "SecretVillageUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local top = Instance.new("Frame")
top.Size = UDim2.fromOffset(330, 82)
top.Position = UDim2.new(0.5, -165, 0, 18)
top.BackgroundTransparency = 0.15
top.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.45, 0)
title.BackgroundTransparency = 1
title.Text = "🔎 SECRET VILLAGE"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = top

local timer = Instance.new("TextLabel")
timer.Position = UDim2.new(0, 0, 0.45, 0)
timer.Size = UDim2.new(1, 0, 0.55, 0)
timer.BackgroundTransparency = 1
timer.TextScaled = true
timer.Font = Enum.Font.GothamBold
timer.Parent = top

local buttons = Instance.new("Frame")
buttons.Size = UDim2.fromOffset(210, 120)
buttons.Position = UDim2.new(0, 18, 1, -145)
buttons.BackgroundTransparency = 1
buttons.Parent = gui

local function button(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 52)
    b.Position = UDim2.new(0, 0, 0, y)
    b.Text = text
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.Parent = buttons
    b.Activated:Connect(callback)
end

button("🔎 Подсказка — $500", 0, function() Hint:FireServer() end)
button("🧹 Стать дворником — $100", 58, function() Job:FireServer() end)

local toast = Instance.new("TextLabel")
toast.Size = UDim2.fromOffset(520, 70)
toast.Position = UDim2.new(0.5, -260, 1, -105)
toast.BackgroundTransparency = 0.1
toast.TextScaled = true
toast.Font = Enum.Font.GothamBold
toast.Visible = false
toast.Parent = gui

local toastId = 0
Notify.OnClientEvent:Connect(function(message)
    toastId += 1
    local id = toastId
    toast.Text = message
    toast.Visible = true
    task.delay(3, function()
        if id == toastId then toast.Visible = false end
    end)
end)

local function updateTimer()
    local seconds = player:GetAttribute("RoundSeconds")
    if seconds == nil then
        timer.Text = "Загрузка..."
    elseif seconds < 0 then
        timer.Text = "🧹 РАБОТА — ТАЙМЕР ПАУЗА"
    else
        local m = math.floor(seconds / 60)
        local s = seconds % 60
        timer.Text = string.format("⏱️ %02d:%02d", m, s)
    end
end

player:GetAttributeChangedSignal("RoundSeconds"):Connect(updateTimer)
updateTimer()
