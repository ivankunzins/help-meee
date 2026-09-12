-- SECRET VILLAGE SOCIAL v2
-- Non-authoritative progression mirror. Core/DataStores remain authoritative.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local function setup(p)
 local f=p:FindFirstChild("Progress")or Instance.new("Folder");f.Name="Progress";f.Parent=p
 local function iv(n)
  local x=f:FindFirstChild(n)or Instance.new("IntValue");x.Name=n;x.Parent=f;return x
 end
 local dist=f:FindFirstChild("Distance")or Instance.new("NumberValue");dist.Name="Distance";dist.Parent=f
 return f,iv("Rounds"),iv("Secrets"),iv("Jobs"),dist
end
local function sync(p)
 local f,r,s,j,d=setup(p)
 r.Value=p:GetAttribute("Rounds")or 0;s.Value=p:GetAttribute("SecretsFound")or 0;j.Value=p:GetAttribute("JobsCompleted")or 0;d.Value=p:GetAttribute("LifetimeDistance")or 0
end
Players.PlayerAdded:Connect(function(p)
 setup(p)
 for _,a in ipairs({"Rounds","SecretsFound","JobsCompleted","LifetimeDistance"})do p:GetAttributeChangedSignal(a):Connect(function()sync(p)end)end
 p.CharacterAdded:Connect(function(c)
  local hrp=c:WaitForChild("HumanoidRootPart",10);if not hrp then return end
  local last=hrp.Position
  task.spawn(function()
   while c.Parent and p.Parent do task.wait(2);if hrp.Parent then local now=hrp.Position;local delta=(now-last).Magnitude;if delta<80 then local total=(p:GetAttribute("LifetimeDistance")or 0)+delta;p:SetAttribute("LifetimeDistance",total)end;last=now end end
  end)
 end)
 task.defer(sync,p)
end)
task.spawn(function()while true do task.wait(5);for _,p in ipairs(Players:GetPlayers())do sync(p);if (p:GetAttribute("SecretsFound")or 0)>=10 and not p:GetAttribute("MasterExplorer")then p:SetAttribute("MasterExplorer",true);local m=p:FindFirstChild("leaderstats")and p.leaderstats:FindFirstChild("Money");if m then m.Value+=5000 end;Notify:FireClient(p,"🏆 MASTER EXPLORER! +$5000")end end end end)
