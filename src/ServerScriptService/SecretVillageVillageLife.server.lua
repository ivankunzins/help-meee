-- SECRET VILLAGE VILLAGE LIFE v1
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local WS=game:GetService("Workspace")
local root=WS:FindFirstChild("SECRET_VILLAGE_WORLD") or WS
local life=WS:FindFirstChild("SECRET_VILLAGE_LIFE") or Instance.new("Folder",WS);life.Name="SECRET_VILLAGE_LIFE"
local Notify=RS:WaitForChild("SecretVillageRemotes"):WaitForChild("Notify")
local function P(n,s,c,m,par,t,col)local p=Instance.new("Part");p.Name=n;p.Size=s;p.CFrame=c;p.Anchored=true;p.CanCollide=true;p.Material=m or Enum.Material.SmoothPlastic;p.Transparency=t or 0;if col then p.Color=col end;p.Parent=par or life;return p end
local function L(p,t)local g=Instance.new("BillboardGui",p);g.Size=UDim2.fromOffset(190,40);g.StudsOffset=Vector3.new(0,5,0);g.AlwaysOnTop=true;local x=Instance.new("TextLabel",g);x.Size=UDim2.fromScale(1,1);x.BackgroundTransparency=1;x.Text=t;x.TextScaled=true;x.Font=Enum.Font.GothamBold;x.TextColor3=Color3.new(1,1,1);x.TextStrokeTransparency=.3 end
local function house(pos,name,s)
 s=s or 1;local f=Instance.new("Model",life);f.Name=name
 P("Body",Vector3.new(16,8,14)*s,CFrame.new(pos+Vector3.new(0,4*s,0)),Enum.Material.Brick,f)
 P("Roof",Vector3.new(19,2,17)*s,CFrame.new(pos+Vector3.new(0,9*s,0)),Enum.Material.WoodPlanks,f)
 P("Door",Vector3.new(3,6,.5)*s,CFrame.new(pos+Vector3.new(0,3*s,-7.2*s)),Enum.Material.Wood,f)
 for _,x in ipairs({-4.5,4.5})do P("Window",Vector3.new(3.5,2.7,.25)*s,CFrame.new(pos+Vector3.new(x*s,5*s,-7.3*s)),Enum.Material.Glass,f)end
 L(P("Chimney",Vector3.new(2,4,2)*s,CFrame.new(pos+Vector3.new(5*s,11*s,3*s)),Enum.Material.Brick,f),name)
end
local function shop(pos,name,sign)
 local f=Instance.new("Model",life);f.Name=name
 P("Body",Vector3.new(22,9,16),CFrame.new(pos+Vector3.new(0,4.5,0)),Enum.Material.Brick,f);P("Roof",Vector3.new(24,2,18),CFrame.new(pos+Vector3.new(0,10,0)),Enum.Material.WoodPlanks,f);P("Awning",Vector3.new(18,1,5),CFrame.new(pos+Vector3.new(0,7.5,-9)),Enum.Material.Fabric,f);P("Door",Vector3.new(4,7,.5),CFrame.new(pos+Vector3.new(0,3.5,-8.2)),Enum.Material.Wood,f);L(P("Sign",Vector3.new(10,3,.4),CFrame.new(pos+Vector3.new(0,10.5,-9.2)),Enum.Material.Wood,f),sign)
end
local function tree(pos,s)
 s=s or 1;local f=Instance.new("Model",life);f.Name="VillageTree";P("Trunk",Vector3.new(1.8,7,1.8)*s,CFrame.new(pos+Vector3.new(0,3.5*s,0)),Enum.Material.Wood,f)
 for _,o in ipairs({Vector3.new(0,8,0),Vector3.new(2,7,0),Vector3.new(-2,7,1),Vector3.new(0,9,2)})do local c=P("Crown",Vector3.new(5.5,5.5,5.5)*s,CFrame.new(pos+o*s),Enum.Material.Grass,f);c.Shape=Enum.PartType.Ball;c.CanCollide=false end
end
local function npc(pos,name,role)
 local m=Instance.new("Model",life);m.Name=name;local h=P("HumanoidRootPart",Vector3.new(2,2,1),CFrame.new(pos+Vector3.new(0,3,0)),nil,m,1);h.CanCollide=false
 P("Body",Vector3.new(2.4,3,1.4),CFrame.new(pos+Vector3.new(0,3,0)),Enum.Material.SmoothPlastic,m,nil,Color3.fromHSV(math.random(),.5,.8));local head=P("Head",Vector3.new(2,2,2),CFrame.new(pos+Vector3.new(0,5.4,0)),Enum.Material.SmoothPlastic,m,nil,Color3.fromRGB(232,190,150));head.Shape=Enum.PartType.Ball
 for _,x in ipairs({-1,1})do P("Leg",Vector3.new(.7,2.2,.7),CFrame.new(pos+Vector3.new(x*.65,1.1,0)),nil,m);P("Arm",Vector3.new(.6,2.4,.6),CFrame.new(pos+Vector3.new(x*1.5,3,0)),nil,m)end
 local hum=Instance.new("Humanoid",m);hum.DisplayName=name;hum.WalkSpeed=7;m.PrimaryPart=h;L(head,role);return m
end
local function animal(pos,species,s)
 s=s or 1;local m=Instance.new("Model",life);m.Name=species;local sz=species=="Cow" and Vector3.new(4.6,2.7,2.5) or species=="Sheep" and Vector3.new(3.8,2.7,2.4) or Vector3.new(2.2,1.3,2);local col=species=="Cow" and Color3.fromRGB(75,70,65) or species=="Sheep" and Color3.fromRGB(225,225,215) or Color3.fromRGB(230,175,65);local body=P("Body",sz*s,CFrame.new(pos+Vector3.new(0,sz.Y*.55*s,0)),nil,m,nil,col);local head=P("Head",(species=="Chicken" and Vector3.new(1.2,1.2,1.2) or Vector3.new(1.7,1.6,1.6))*s,CFrame.new(pos+Vector3.new(sz.X*.48*s,sz.Y*.85*s,0)),nil,m,nil,col);head.Shape=Enum.PartType.Ball
 local n=species=="Chicken" and 2 or 4;for i=1,n do local x=((i%2==0)and 1 or -1)*sz.X*.28*s;local z=(i<=2 and -1 or 1)*sz.Z*.25*s;P("Leg",Vector3.new(.4,.9,.4)*s,CFrame.new(pos+Vector3.new(x,.45*s,z)),Enum.Material.Wood,m)end;m.PrimaryPart=body;return m
end
local function wander(m,c,r)
 task.spawn(function()while m.Parent do local a=m:GetPivot();local q=c+Vector3.new(math.random(-r,r),0,math.random(-r,r));local b=CFrame.lookAt(Vector3.new(q.X,a.Position.Y,q.Z),a.Position+Vector3.new(0,0,-1));local d=math.clamp((b.Position-a.Position).Magnitude/4,2,7);local t=os.clock();while m.Parent and os.clock()-t<d do m:PivotTo(a:Lerp(b,math.clamp((os.clock()-t)/d,0,1)));task.wait(.05)end;task.wait(math.random(1,3))end end)
end
local function breathGui(p)local pg=p:FindFirstChildOfClass("PlayerGui");if not pg then return end;local g=pg:FindFirstChild("DivingBreathGui") or Instance.new("ScreenGui",pg);g.Name="DivingBreathGui";g.ResetOnSpawn=false;g.Enabled=false;local t=g:FindFirstChild("Text") or Instance.new("TextLabel",g);t.Name="Text";t.Size=UDim2.fromOffset(300,45);t.Position=UDim2.fromScale(.5,.9);t.AnchorPoint=Vector2.new(.5,.5);t.BackgroundTransparency=.2;t.TextScaled=true;t.Font=Enum.Font.GothamBold end
local W={x1=-95,x2=25,z1=41,z2=75,s=.15}
local function inW(p)return p.X>=W.x1 and p.X<=W.x2 and p.Z>=W.z1 and p.Z<=W.z2 end
if not life:GetAttribute("Built")then
 life:SetAttribute("Built",true)
 for _,n in ipairs({"MainRoad","CrossRoad"})do local p=root:FindFirstChild(n);if p then p.Transparency=1;p.CanCollide=false end end
 P("DirtVillageRoad",Vector3.new(230,.22,12),CFrame.new(0,.12,0),Enum.Material.Ground,life);P("DirtVillageRoadCross",Vector3.new(12,.22,210),CFrame.new(0,.12,0),Enum.Material.Ground,life)
 for _,z in ipairs({-85,-55,25,105})do P("DirtPath",Vector3.new(110,.18,7),CFrame.new(15,.14,z),Enum.Material.Ground,life)end
 for _,p in ipairs({Vector3.new(-95,0,-70),Vector3.new(-55,0,-92),Vector3.new(25,0,-92),Vector3.new(70,0,-70),Vector3.new(108,0,0),Vector3.new(108,0,72),Vector3.new(55,0,115),Vector3.new(-20,0,112),Vector3.new(-100,0,105),Vector3.new(-120,0,35)})do house(p,"Village House",math.random(85,110)/100)end
 shop(Vector3.new(-10,0,-82),"VillageGeneralStore","GENERAL STORE");shop(Vector3.new(105,0,35),"FarmShop","FARM SHOP")
 for i=1,110 do local a=math.random()*math.pi*2;local r=math.random(85,150);tree(Vector3.new(math.cos(a)*r,0,math.sin(a)*r))end
 local nd={{Vector3.new(18,0,8),"Marta","Farmer"},{Vector3.new(-5,0,-35),"Anton","Carpenter"},{Vector3.new(45,0,25),"Nina","Baker"},{Vector3.new(75,0,-10),"Oleg","Fisherman"},{Vector3.new(-45,0,25),"Lena","Gardener"},{Vector3.new(85,0,60),"Max","Courier"},{Vector3.new(-80,0,5),"Vera","Shepherd"},{Vector3.new(10,0,90),"Roman","Mechanic"}};for _,d in ipairs(nd)do local m=npc(d[1],d[2],d[3]);wander(m,d[1],18)end
 for i=1,5 do local m=animal(Vector3.new(-70+math.random(-20,20),0,95+math.random(-12,12)),"Cow");wander(m,Vector3.new(-70,0,95),28)end
 for i=1,7 do local m=animal(Vector3.new(60+math.random(-25,25),0,105+math.random(-15,15)),"Sheep",.95);wander(m,Vector3.new(60,0,105),30)end
 for i=1,10 do local m=animal(Vector3.new(45+math.random(-35,35),0,-75+math.random(-20,20)),"Chicken",.8);wander(m,Vector3.new(45,0,-75),40)end
 local river=root:FindFirstChild("River");if river then river.CanCollide=false;river.Transparency=.28 end;P("UnderwaterFloor",Vector3.new(120,.5,34),CFrame.new(-35,-7,58),Enum.Material.Sand,life)
 for _,p in ipairs(Players:GetPlayers())do breathGui(p)end;Players.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()task.wait(1);breathGui(p)end)end)
 task.spawn(function()while true do task.wait(.25);for _,p in ipairs(Players:GetPlayers())do local c=p.Character;local h=c and c:FindFirstChild("HumanoidRootPart");local hum=c and c:FindFirstChildOfClass("Humanoid");if h and hum then local iw=inW(h.Position)and h.Position.Y<W.s+.5;local diving=p:GetAttribute("DivingActive")or false;if iw and not diving then p:SetAttribute("DivingActive",true);p:SetAttribute("BreathLeft",10);h.AssemblyLinearVelocity=Vector3.new(h.AssemblyLinearVelocity.X,-18,h.AssemblyLinearVelocity.Z);Notify:FireClient(p,"🌊 Ты провалился под воду! Воздуха на 10 секунд.")elseif not iw and diving then p:SetAttribute("DivingActive",false);p:SetAttribute("BreathLeft",10);local g=p.PlayerGui:FindFirstChild("DivingBreathGui");if g then g.Enabled=false end end;if p:GetAttribute("DivingActive")then local left=(p:GetAttribute("BreathLeft")or 10)-.25;p:SetAttribute("BreathLeft",left);local g=p.PlayerGui:FindFirstChild("DivingBreathGui");if g then g.Enabled=true;g.Text.Text="🌊 Дыхание: "..math.max(0,math.ceil(left)).."с"end;if left<=0 then hum:TakeDamage(5)end end end end end end)
end
