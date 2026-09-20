-- SECRET VILLAGE SOCIAL v3
-- Non-authoritative progression mirror. Core/DataStores remain authoritative.
-- Distance tracking and milestone rewards are handled by dedicated systems.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local function setup(p)
 local f=p:FindFirstChild("Progress") or Instance.new("Folder")
 f.Name="Progress"
 f.Parent=p
 local function iv(n)
  local x=f:FindFirstChild(n) or Instance.new("IntValue")
  x.Name=n
  x.Parent=f
  return x
 end
 local dist=f:FindFirstChild("Distance") or Instance.new("NumberValue")
 dist.Name="Distance"
 dist.Parent=f
 return f,iv("Rounds"),iv("Secrets"),iv("Jobs"),dist
end
local function sync(p)
 local f,r,s,j,d=setup(p)
 r.Value=math.max(0,tonumber(p:GetAttribute("Rounds")) or 0)
 s.Value=math.max(0,tonumber(p:GetAttribute("SecretsFound")) or 0)
 j.Value=math.max(0,tonumber(p:GetAttribute("JobsCompleted")) or 0)
 d.Value=math.max(0,tonumber(p:GetAttribute("LifetimeDistance")) or 0)
end
local function onPlayerAdded(p)
 setup(p)
 for _,a in ipairs({"Rounds","SecretsFound","JobsCompleted","LifetimeDistance"}) do
  p:GetAttributeChangedSignal(a):Connect(function()
   if p.Parent then sync(p) end
  end)
 end
 task.defer(sync,p)
end
Players.PlayerAdded:Connect(onPlayerAdded)
for _,p in ipairs(Players:GetPlayers()) do task.spawn(onPlayerAdded,p) end
