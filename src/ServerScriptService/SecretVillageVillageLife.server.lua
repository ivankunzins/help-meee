-- SECRET VILLAGE VILLAGE LIFE v2
-- Visual cleanup: no filler roads, primitive placeholder houses, or blocky NPC/animal models.
-- Keeps the natural meadow, safe underwater floor, and diving gameplay.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local WS=game:GetService("Workspace")
local root=WS:FindFirstChild("SECRET_VILLAGE_WORLD") or WS
local life=WS:FindFirstChild("SECRET_VILLAGE_LIFE") or Instance.new("Folder",WS)
life.Name="SECRET_VILLAGE_LIFE"
local Notify=RS:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")

local function P(n,s,c,m,par,t,col)
 local p=Instance.new("Part")
 p.Name=n;p.Size=s;p.CFrame=c;p.Anchored=true;p.CanCollide=true
 p.Material=m or Enum.Material.SmoothPlastic;p.Transparency=t or 0
 if col then p.Color=col end;p.Parent=par or life
 return p
end

local function breathGui(p)
 local pg=p:FindFirstChildOfClass("PlayerGui");if not pg then return end
 local g=pg:FindFirstChild("DivingBreathGui") or Instance.new("ScreenGui",pg)
 g.Name="DivingBreathGui";g.ResetOnSpawn=false;g.Enabled=false
 local t=g:FindFirstChild("Text") or Instance.new("TextLabel",g)
 t.Name="Text";t.Size=UDim2.fromOffset(300,45);t.Position=UDim2.fromScale(.5,.9)
 t.AnchorPoint=Vector2.new(.5,.5);t.BackgroundTransparency=.2;t.TextScaled=true;t.Font=Enum.Font.GothamBold
end

-- Large soft meadow patches make the village read as grass instead of an asphalt grid.
local function meadow(center,size)
 local p=P("Meadow",Vector3.new(size,.18,size),CFrame.new(center.X,-.02,center.Z),Enum.Material.Grass,life)
 p.Color=Color3.fromRGB(91,125,67)
 p.CanCollide=true
 return p
end

local W={x1=-95,x2=25,z1=41,z2=75,s=.15}
local function inW(p)return p.X>=W.x1 and p.X<=W.x2 and p.Z>=W.z1 and p.Z<=W.z2 end

if not life:GetAttribute("Built") then
 life:SetAttribute("Built",true)

 -- Remove old visual filler if a place was upgraded in Studio without a clean publish.
 for _,obj in ipairs(life:GetChildren()) do
  if obj:IsA("Model") and (obj.Name=="Village House" or obj.Name=="Marta" or obj.Name=="Anton" or obj.Name=="Nina" or obj.Name=="Oleg" or obj.Name=="Lena" or obj.Name=="Max" or obj.Name=="Vera" or obj.Name=="Roman" or obj.Name=="Cow" or obj.Name=="Sheep" or obj.Name=="Chicken" or obj.Name=="VillageGeneralStore" or obj.Name=="FarmShop") then
   obj:Destroy()
  elseif obj:IsA("BasePart") and (obj.Name=="DirtVillageRoad" or obj.Name=="DirtVillageRoadCross" or obj.Name=="DirtPath") then
   obj:Destroy()
  end
 end

 -- Any older road geometry is hidden. The village is meadow + organic paths, not a road grid.
 for _,n in ipairs({"MainRoad","CrossRoad"}) do
  local p=root:FindFirstChild(n)
  if p and p:IsA("BasePart") then p.Transparency=1;p.CanCollide=false end
 end

 meadow(Vector3.new(0,0,0),240)
 meadow(Vector3.new(-115,0,-5),90)
 meadow(Vector3.new(115,0,-5),90)
 meadow(Vector3.new(-75,0,-105),85)
 meadow(Vector3.new(80,0,-105),85)
 meadow(Vector3.new(-70,0,105),85)
 meadow(Vector3.new(75,0,105),85)

 -- Guaranteed solid riverbed: players never fall through the water into the void.
 local river=root:FindFirstChild("River")
 if river and river:IsA("BasePart") then river.CanCollide=false;river.Transparency=.28 end
 local old=life:FindFirstChild("UnderwaterFloor")
 if old then old:Destroy() end
 P("UnderwaterFloor",Vector3.new(122,1.5,38),CFrame.new(-35,-6.4,58),Enum.Material.Sand,life,nil,Color3.fromRGB(177,154,105))

 for _,p in ipairs(Players:GetPlayers()) do breathGui(p) end
 Players.PlayerAdded:Connect(function(p)
  p.CharacterAdded:Connect(function()
   task.wait(1);breathGui(p)
  end)
 end)

 -- Diving: entering the marked water area starts a short oxygen countdown.
 task.spawn(function()
  while true do
   task.wait(.25)
   for _,p in ipairs(Players:GetPlayers()) do
    local c=p.Character;local h=c and c:FindFirstChild("HumanoidRootPart");local hum=c and c:FindFirstChildOfClass("Humanoid")
    if h and hum then
     local iw=inW(h.Position) and h.Position.Y<W.s+.5
     local diving=p:GetAttribute("DivingActive") or false
     if iw and not diving then
      p:SetAttribute("DivingActive",true);p:SetAttribute("BreathLeft",10)
      h.AssemblyLinearVelocity=Vector3.new(h.AssemblyLinearVelocity.X,-10,h.AssemblyLinearVelocity.Z)
      Notify:FireClient(p,"🌊 Ты под водой! Воздуха на 10 секунд.")
     elseif not iw and diving then
      p:SetAttribute("DivingActive",false);p:SetAttribute("BreathLeft",10)
      local g=p.PlayerGui:FindFirstChild("DivingBreathGui");if g then g.Enabled=false end
     end
     if p:GetAttribute("DivingActive") then
      local left=(p:GetAttribute("BreathLeft") or 10)-.25;p:SetAttribute("BreathLeft",left)
      local g=p.PlayerGui:FindFirstChild("DivingBreathGui")
      if g then g.Enabled=true;g.Text.Text="🌊 Дыхание: "..math.max(0,math.ceil(left)).."с" end
      if left<=0 then hum:TakeDamage(5) end
     end
    end
   end
  end
 end)
end
