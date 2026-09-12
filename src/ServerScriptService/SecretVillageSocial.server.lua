-- SECRET VILLAGE social/progression layer.
-- Badges/leaderboards are intentionally represented as stats first; IDs can be assigned later.

local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Notify=ReplicatedStorage:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")

local function setup(p)
 local folder=p:FindFirstChild("Progress") or Instance.new("Folder");folder.Name="Progress";folder.Parent=p
 local play=folder:FindFirstChild("Rounds") or Instance.new("IntValue");play.Name="Rounds";play.Parent=folder
 local found=folder:FindFirstChild("Secrets") or Instance.new("IntValue");found.Name="Secrets";found.Parent=folder
 local jobs=folder:FindFirstChild("Jobs") or Instance.new("IntValue");jobs.Name="Jobs";jobs.Parent=folder
 local distance=folder:FindFirstChild("Distance") or Instance.new("NumberValue");distance.Name="Distance";distance.Parent=folder
end

Players.PlayerAdded:Connect(function(p)
 setup(p)
 p.CharacterAdded:Connect(function(c)
  local root=c:WaitForChild("HumanoidRootPart",10)
  if not root then return end
  local last=root.Position
  task.spawn(function()
   while c.Parent and p.Parent do
    task.wait(2)
    if root.Parent then
     local now=root.Position
     local d=(now-last).Magnitude
     if d<80 then
      p.Progress.Distance.Value+=d
     end
     last=now
    end
   end
  end)
 end)
end)

-- Lightweight milestone rewards.
task.spawn(function()
 while true do
  task.wait(5)
  for _,p in ipairs(Players:GetPlayers()) do
   setup(p)
   local s=p:GetAttribute("SecretsFound") or 0
   p.Progress.Secrets.Value=s
   if s>=10 and not p:GetAttribute("MasterExplorer") then
    p:SetAttribute("MasterExplorer",true)
    local ls=p:FindFirstChild("leaderstats");local m=ls and ls:FindFirstChild("Money")
    if m then m.Value+=5000 end
    Notify:FireClient(p,"🏆 ДОСТИЖЕНИЕ: MASTER EXPLORER! +$5000")
   end
  end
 end
end)
