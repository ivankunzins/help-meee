-- SECRET VILLAGE UI OVERHAUL v1
-- Visual-only layer for the existing HUD. Does not change gameplay actions.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local gui=player:WaitForChild("PlayerGui"):WaitForChild("SecretVillageUI",20)
if not gui then return end

local function corner(obj,r)
 local c=obj:FindFirstChild("UIOverhaulCorner") or Instance.new("UICorner")
 c.Name="UIOverhaulCorner";c.CornerRadius=UDim.new(0,r);c.Parent=obj
end
local function stroke(obj,trans,thick)
 local s=obj:FindFirstChild("UIOverhaulStroke") or Instance.new("UIStroke")
 s.Name="UIOverhaulStroke";s.Transparency=trans;s.Thickness=thick;s.Color=Color3.fromRGB(214,224,219);s.Parent=obj
end
local function gradient(obj,a,b)
 local g=obj:FindFirstChild("UIOverhaulGradient") or Instance.new("UIGradient")
 g.Name="UIOverhaulGradient";g.Color=ColorSequence.new(a,b);g.Rotation=90;g.Parent=obj
end

-- Main palette: dark translucent glass + warm accent, readable in daylight and night.
local panelA=Color3.fromRGB(24,31,32)
local panelB=Color3.fromRGB(42,48,45)
local buttonA=Color3.fromRGB(42,52,50)
local buttonB=Color3.fromRGB(61,70,64)
local accent=Color3.fromRGB(227,186,112)

for _,obj in ipairs(gui:GetDescendants()) do
 if obj:IsA("Frame") then
  obj.BackgroundColor3=panelA;obj.BackgroundTransparency=.08;corner(obj,14);stroke(obj,.72,1);gradient(obj,panelA,panelB)
 elseif obj:IsA("TextButton") then
  obj.BackgroundColor3=buttonA;obj.BackgroundTransparency=.02;obj.TextColor3=Color3.fromRGB(247,243,231);obj.AutoButtonColor=false
  corner(obj,11);stroke(obj,.78,1);gradient(obj,buttonA,buttonB)
  obj.MouseEnter:Connect(function()
   TweenService:Create(obj,TweenInfo.new(.12),{BackgroundTransparency=0,Size=UDim2.new(obj.Size.X.Scale,obj.Size.X.Offset,obj.Size.Y.Scale,obj.Size.Y.Offset+2)}):Play()
  end)
  obj.MouseLeave:Connect(function()
   TweenService:Create(obj,TweenInfo.new(.12),{BackgroundTransparency=.02,Size=UDim2.new(obj.Size.X.Scale,obj.Size.X.Offset,obj.Size.Y.Scale,obj.Size.Y.Offset-2)}):Play()
  end)
 elseif obj:IsA("TextLabel") then
  obj.TextColor3=Color3.fromRGB(244,241,232)
  obj.TextStrokeTransparency=.72
  obj.TextStrokeColor3=Color3.fromRGB(0,0,0)
 end
end

local top=gui:FindFirstChildWhichIsA("Frame")
if top then
 top.BackgroundTransparency=.02
 stroke(top,.55,1.5)
 local title=top:FindFirstChildWhichIsA("TextLabel")
 if title then title.TextColor3=accent;title.TextStrokeTransparency=.65 end
end

-- Add a slim progress bar under the top HUD without changing the existing labels.
if not gui:FindFirstChild("SecretProgressVisual") then
 local bar=Instance.new("Frame");bar.Name="SecretProgressVisual";bar.AnchorPoint=Vector2.new(.5,0);bar.Position=UDim2.new(.5,0,0,103);bar.Size=UDim2.new(.9,0,0,5);bar.BackgroundColor3=Color3.fromRGB(15,20,20);bar.BorderSizePixel=0;bar.Parent=gui;corner(bar,5)
 local fill=Instance.new("Frame");fill.Name="Fill";fill.Size=UDim2.fromScale(0,1);fill.BackgroundColor3=accent;fill.BorderSizePixel=0;fill.Parent=bar;corner(fill,5)
 local function update()
  local n=player:GetAttribute("SecretsFound")or 0;fill.Size=UDim2.fromScale(math.clamp(n/100,0,1),1)
 end
 player:GetAttributeChangedSignal("SecretsFound"):Connect(update);update()
end

-- Subtle vignette: two translucent edge panels, no impact on touch controls.
if not gui:FindFirstChild("EdgeShade") then
 local left=Instance.new("Frame");left.Name="EdgeShade";left.Size=UDim2.new(.08,0,1,0);left.BackgroundTransparency=.92;left.BorderSizePixel=0;left.Parent=gui
 local right=left:Clone();right.Name="EdgeShadeRight";right.Position=UDim2.new(.92,0,0,0);right.Parent=gui
end

-- Toast gets a premium notification-card appearance.
local toast=nil
for _,x in ipairs(gui:GetChildren()) do if x:IsA("TextLabel") and x.Text=="" then toast=x end end
if toast then
 toast.BackgroundColor3=panelA;toast.BackgroundTransparency=.06;corner(toast,15);stroke(toast,.6,1.2);toast.TextColor3=Color3.fromRGB(255,244,214);toast.TextStrokeTransparency=.7
end

print("[SecretVillageUIOverhaul] PREMIUM HUD VISUALS INITIALIZED")
