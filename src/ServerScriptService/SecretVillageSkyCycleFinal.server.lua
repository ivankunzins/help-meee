-- SECRET VILLAGE SKY CYCLE FINAL v1
-- Full day/night cycle with procedural sky, stars, moon, clouds and lighting transitions.
local Lighting=game:GetService("Lighting")
local WS=game:GetService("Workspace")
local cycle=WS:FindFirstChild("SECRET_VILLAGE_SKY_CYCLE") or Instance.new("Folder",WS);cycle.Name="SECRET_VILLAGE_SKY_CYCLE"
if cycle:GetAttribute("Built") then return end
cycle:SetAttribute("Built",true)

-- Remove only skies owned by this visual system; keep gameplay effects intact.
local old=Lighting:FindFirstChild("SecretVillageSky");if old then old:Destroy()end
local sky=Instance.new("Sky");sky.Name="SecretVillageSky";sky.CelestialBodiesShown=true;sky.StarCount=3200;sky.SunAngularSize=13;sky.MoonAngularSize=11;sky.SkyboxBk="rbxassetid://159454299";sky.SkyboxDn="rbxassetid://159454299";sky.SkyboxFt="rbxassetid://159454299";sky.SkyboxLf="rbxassetid://159454299";sky.SkyboxRt="rbxassetid://159454299";sky.SkyboxUp="rbxassetid://159454299";sky.Parent=Lighting

local clouds=WS.Terrain:FindFirstChild("SecretVillageClouds") or Instance.new("Clouds",WS.Terrain);clouds.Name="SecretVillageClouds";clouds.Cover=.38;clouds.Density=.27;clouds.Color=Color3.fromRGB(236,241,245)

local function atmosphere(name)
 local a=Lighting:FindFirstChild(name) or Instance.new("Atmosphere",Lighting);a.Name=name;return a
end
local at=atmosphere("SecretVillageSkyAtmosphere");at.Density=.29;at.Offset=.08;at.Haze=1.05;at.Glare=.08
local bloom=Lighting:FindFirstChild("SecretVillageSkyBloom") or Instance.new("BloomEffect",Lighting);bloom.Name="SecretVillageSkyBloom";bloom.Intensity=.08;bloom.Size=22;bloom.Threshold=1.1
local rays=Lighting:FindFirstChild("SecretVillageSkyRays") or Instance.new("SunRaysEffect",Lighting);rays.Name="SecretVillageSkyRays";rays.Intensity=.055;rays.Spread=.75

local day=Lighting:FindFirstChild("SecretVillageDayColor") or Instance.new("ColorCorrectionEffect",Lighting);day.Name="SecretVillageDayColor"

local function apply(t)
 Lighting.ClockTime=t
 local night=(t<5.5 or t>19.5)
 local dawn=(t>=5.5 and t<7.5)
 local dusk=(t>=18 and t<19.5)
 if night then
  Lighting.Brightness=.7;Lighting.ExposureCompensation=-.35;Lighting.EnvironmentDiffuseScale=.22;Lighting.EnvironmentSpecularScale=.4
  at.Density=.36;at.Haze=1.45;at.Glare=0;clouds.Color=Color3.fromRGB(105,116,132)
  day.Brightness=-.015;day.Contrast=.12;day.Saturation=-.05
 elseif dawn or dusk then
  Lighting.Brightness=1.35;Lighting.ExposureCompensation=-.08;Lighting.EnvironmentDiffuseScale=.38;Lighting.EnvironmentSpecularScale=.52
  at.Density=.32;at.Haze=1.25;at.Glare=.12;clouds.Color=Color3.fromRGB(225,224,224)
  day.Brightness=.01;day.Contrast=.1;day.Saturation=.05
 else
  Lighting.Brightness=2.1;Lighting.ExposureCompensation=.03;Lighting.EnvironmentDiffuseScale=.6;Lighting.EnvironmentSpecularScale=.72
  at.Density=.28;at.Haze=.95;at.Glare=.09;clouds.Color=Color3.fromRGB(240,244,247)
  day.Brightness=.01;day.Contrast=.08;day.Saturation=.07
 end
end

apply(14)
-- 24 in-game hours take 18 real minutes: slow enough to notice the change, fast enough to matter in a session.
local secondsPerDay=1080
local step=.04
local increment=24/(secondsPerDay/step)
task.spawn(function()
 local t=14
 while cycle.Parent do
  task.wait(step)
  t=(t+increment)%24
  -- Do not fight a temporary blackout/night event: preserve the cycle's clock but allow event scripts to override visuals.
  if not Lighting:GetAttribute("SecretVillageEventOverride") then apply(t) else Lighting.ClockTime=t end
 end
end)
