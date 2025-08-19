local p=game:GetService("Players").LocalPlayer
local uis=game:GetService("UserInputService")
local rs=game:GetService("RunService")
local cam=workspace.CurrentCamera
local lighting=game:GetService("Lighting")
local tween=game:GetService("TweenService")
local http=game:GetService("HttpService")

local function hasfs() return (writefile and readfile and isfile)~=nil end
local cfgname="namhub_config.json"
local cfg={
	UIPos={x=0.5,y=0.5},Minimized=false,
	Noclip=false,Fly=false,InfJump=false,
	WalkSpeed=16,JumpPower=50,
	ESP_Survivor=false,ESP_Killer=false,ESP_Item=false,ESP_Gen=false,
	FullBright=false,FixLag=false,AutoPickup=false,AutoFixGen=false
}
local function loadcfg()
	if hasfs() and isfile(cfgname) then
		local ok,data=pcall(function() return http:JSONDecode(readfile(cfgname)) end)
		if ok and type(data)=="table" then
			for k,v in pairs(cfg) do if data[k]~=nil then cfg[k]=data[k] end end
		end
	end
end
local function savecfg()
	if hasfs() then
		local ok,js=pcall(function() return http:JSONEncode(cfg) end)
		if ok then pcall(function() writefile(cfgname,js) end) end
	end
end
loadcfg()

local gui=Instance.new("ScreenGui")
gui.Name="NamHubUI"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Global
gui.Parent=game:GetService("CoreGui")

local main=Instance.new("Frame")
main.Name="Main"
main.Size=UDim2.new(0,540,0,360)
main.AnchorPoint=Vector2.new(0.5,0.5)
main.Position=UDim2.new(cfg.UIPos.x,0,cfg.UIPos.y,0)
main.BackgroundColor3=Color3.fromRGB(36,45,60)
main.BorderSizePixel=0
main.Active=true
main.Parent=gui

local round=function(o,r) local u=Instance.new("UICorner",o) u.CornerRadius=UDim.new(0,r) end
round(main,14)

local shadow=Instance.new("ImageLabel",main)
shadow.AnchorPoint=Vector2.new(0.5,0.5)
shadow.Position=UDim2.new(0.5,0,0.5,8)
shadow.Size=UDim2.new(1,28,1,28)
shadow.BackgroundTransparency=1
shadow.Image="rbxassetid://5028857084"
shadow.ImageTransparency=0.35
shadow.ScaleType=Enum.ScaleType.Slice
shadow.SliceCenter=Rect.new(24,24,276,276)
shadow.ZIndex=0

local top=Instance.new("Frame",main)
top.Size=UDim2.new(1,0,0,44)
top.BackgroundColor3=Color3.fromRGB(28,36,52)
top.BorderSizePixel=0
round(top,14)

local logoL=Instance.new("TextLabel",top)
logoL.Size=UDim2.new(0,40,1,0)
logoL.Position=UDim2.new(0,4,0,0)
logoL.BackgroundTransparency=1
logoL.Font=Enum.Font.GothamBlack
logoL.Text="⚡"
logoL.TextScaled=true
logoL.TextColor3=Color3.fromRGB(120,190,255)

local title=Instance.new("TextLabel",top)
title.Size=UDim2.new(1,-80,1,0)
title.Position=UDim2.new(0,40,0,0)
title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold
title.Text="NamHub"
title.TextScaled=true
title.TextColor3=Color3.fromRGB(220,235,255)

local logoR=logoL:Clone()
logoR.Parent=top
logoR.Position=UDim2.new(1,-44,0,0)

local btnHide=Instance.new("TextButton",top)
btnHide.Size=UDim2.new(0,44,1,0)
btnHide.Position=UDim2.new(1,-44,0,0)
btnHide.Text="✖"
btnHide.Font=Enum.Font.GothamBold
btnHide.TextScaled=true
btnHide.TextColor3=Color3.fromRGB(225,235,255)
btnHide.BackgroundColor3=Color3.fromRGB(22,28,40)
btnHide.AutoButtonColor=false
round(btnHide,10)

local body=Instance.new("Frame",main)
body.Position=UDim2.new(0,0,0,44)
body.Size=UDim2.new(1,0,1,-44)
body.BackgroundColor3=Color3.fromRGB(45,58,80)
body.BorderSizePixel=0
round(body,14)

local tabs=Instance.new("Frame",body)
tabs.Size=UDim2.new(0,140,1,0)
tabs.BackgroundColor3=Color3.fromRGB(33,42,60)
tabs.BorderSizePixel=0
round(tabs,14)

local content=Instance.new("Frame",body)
content.Position=UDim2.new(0,140,0,0)
content.Size=UDim2.new(1,-140,1,0)
content.BackgroundColor3=Color3.fromRGB(52,66,92)
content.BorderSizePixel=0
round(content,14)

local function mkTab(text,order)
	local b=Instance.new("TextButton",tabs)
	b.Size=UDim2.new(1,-16,0,40)
	b.Position=UDim2.new(0,8,0,10+(order-1)*48)
	b.BackgroundColor3=Color3.fromRGB(47,61,86)
	b.AutoButtonColor=false
	b.Text=text
	b.Font=Enum.Font.GothamSemibold
	b.TextScaled=true
	b.TextColor3=Color3.fromRGB(210,225,255)
	round(b,10)
	return b
end

local tabPlayer=mkTab("Player",1)
local tabForsaken=mkTab("Forsaken",2)
local tabMisc=mkTab("Misc",3)

local function mkPage()
	local f=Instance.new("Frame",content)
	f.Size=UDim2.new(1,0,1,0)
	f.BackgroundTransparency=1
	f.Visible=false
	return f
end

local pagePlayer=mkPage()
local pageForsaken=mkPage()
local pageMisc=mkPage()

local function showPage(pg)
	for _,v in ipairs(content:GetChildren()) do if v:IsA("Frame") then v.Visible=false end end
	pg.Visible=true
end
showPage(pagePlayer)

local function mkLabel(parent,text,y)
	local l=Instance.new("TextLabel",parent)
	l.BackgroundTransparency=1
	l.Position=UDim2.new(0,18,0,y)
	l.Size=UDim2.new(1,-36,0,24)
	l.Font=Enum.Font.GothamBold
	l.Text=text
	l.TextXAlignment=Enum.TextXAlignment.Left
	l.TextScaled=true
	l.TextColor3=Color3.fromRGB(210,225,255)
	return l
end

local function mkToggle(parent,text,y)
	local b=Instance.new("TextButton",parent)
	b.Size=UDim2.new(0,240,0,38)
	b.Position=UDim2.new(0,18,0,y)
	b.BackgroundColor3=Color3.fromRGB(70,90,120)
	b.AutoButtonColor=false
	b.Text=text..": OFF"
	b.Font=Enum.Font.GothamSemibold
	b.TextScaled=true
	b.TextColor3=Color3.fromRGB(230,240,255)
	round(b,10)
	return b
end

local function mkBox(parent,ph,x,y,w)
	local t=Instance.new("TextBox",parent)
	t.PlaceholderText=ph
	t.ClearTextOnFocus=false
	t.Size=UDim2.new(0,w or 240,0,38)
	t.Position=UDim2.new(0,x or 18,0,y)
	t.BackgroundColor3=Color3.fromRGB(60,78,110)
	t.Text=""
	t.Font=Enum.Font.GothamSemibold
	t.TextScaled=true
	t.TextColor3=Color3.fromRGB(230,240,255)
	round(t,10)
	return t
end

local function mkBtn(parent,text,x,y,w)
	local b=Instance.new("TextButton",parent)
	b.Size=UDim2.new(0,w or 240,0,38)
	b.Position=UDim2.new(0,x or 18,0,y)
	b.BackgroundColor3=Color3.fromRGB(78,102,140)
	b.AutoButtonColor=false
	b.Text=text
	b.Font=Enum.Font.GothamBold
	b.TextScaled=true
	b.TextColor3=Color3.fromRGB(230,240,255)
	round(b,10)
	return b
end

mkLabel(pagePlayer,"Movement",8)
local tNoclip=mkToggle(pagePlayer,"Noclip",36)
local tFly=mkToggle(pagePlayer,"Fly",82)
local tInfJump=mkToggle(pagePlayer,"InfiniteJump",128)
local wsBox=mkBox(pagePlayer,"WalkSpeed (16-300)",18,174,240) wsBox.Text=tostring(cfg.WalkSpeed)
local jpBox=mkBox(pagePlayer,"JumpPower (20-300)",270,174,240) jpBox.Text=tostring(cfg.JumpPower)
local tpBox=mkBox(pagePlayer,"Teleport to Player",18,222,240)
local tpBtn=mkBtn(pagePlayer,"Teleport",270,222,240)

mkLabel(pageForsaken,"ESP",8)
local tESPs=mkToggle(pageForsaken,"ESP Survivors",36)
local tESPk=mkToggle(pageForsaken,"ESP Killer",82)
local tESPi=mkToggle(pageForsaken,"ESP Items",128)
local tESPg=mkToggle(pageForsaken,"ESP Generators",174)
mkLabel(pageForsaken,"Automation",220)
local tAutoGen=mkToggle(pageForsaken,"Auto Fix Generator",248)
local tAutoPickup=mkToggle(pageForsaken,"Auto Pickup Item",294)

mkLabel(pageMisc,"Visual",8)
local tFullBright=mkToggle(pageMisc,"FullBright",36)
mkLabel(pageMisc,"System",90)
local tFixLag=mkToggle(pageMisc,"Fix Lag Mode",118)
local recBtn=mkBtn(pageMisc,"Recenter UI",18,166,240)
local saveBtn=mkBtn(pageMisc,"Force Save",270,166,240)

tabPlayer.MouseButton1Click:Connect(function() showPage(pagePlayer) end)
tabForsaken.MouseButton1Click:Connect(function() showPage(pageForsaken) end)
tabMisc.MouseButton1Click:Connect(function() showPage(pageMisc) end)

local mini=Instance.new("Frame",gui)
mini.Size=UDim2.new(0,160,0,44)
mini.BackgroundColor3=Color3.fromRGB(33,42,60)
mini.Visible=false
round(mini,12)
local miniBtn=Instance.new("TextButton",mini)
miniBtn.Size=UDim2.new(1,0,1,0)
miniBtn.BackgroundTransparency=1
miniBtn.Text="⚡ NamHub ⚡"
miniBtn.Font=Enum.Font.GothamBold
miniBtn.TextScaled=true
miniBtn.TextColor3=Color3.fromRGB(210,230,255)

btnHide.MouseButton1Click:Connect(function()
	main.Visible=false
	mini.Visible=true
	cfg.Minimized=true
	savecfg()
	local vp=cam.ViewportSize
	mini.Position=UDim2.new(0,math.floor(vp.X/2-80),0,math.floor(vp.Y-60))
end)
miniBtn.MouseButton1Click:Connect(function()
	mini.Visible=false
	main.Visible=true
	cfg.Minimized=false
	savecfg()
end)
if cfg.Minimized then btnHide:Activate() end

local dragging=false
local dragOffset=Vector2.new()
top.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragOffset=Vector2.new(i.Position.X,i.Position.Y)-Vector2.new(main.AbsolutePosition.X,main.AbsolutePosition.Y)
	end
end)
uis.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=false
		local vp=cam.ViewportSize
		cfg.UIPos={x=main.AbsolutePosition.X/vp.X+main.AbsoluteSize.X/vp.X/2,y=main.AbsolutePosition.Y/vp.Y+main.AbsoluteSize.Y/vp.Y/2}
		savecfg()
	end
end)
uis.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local vp=cam.ViewportSize
		local x=i.Position.X-dragOffset.X
		local y=i.Position.Y-dragOffset.Y
		x=math.clamp(x,0,math.max(0,vp.X-main.AbsoluteSize.X))
		y=math.clamp(y,0,math.max(0,vp.Y-main.AbsoluteSize.Y))
		main.Position=UDim2.new(0,x,0,y)
	end
end)
recBtn.MouseButton1Click:Connect(function()
	main.Position=UDim2.new(0.5,0,0.5,0)
	cfg.UIPos={x=0.5,y=0.5}
	savecfg()
end)

local function setToggle(btn,on) btn.Text=btn.Text:match("^[^:]+")..": "..(on and "ON" or "OFF"); tween:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=on and Color3.fromRGB(60,150,100) or Color3.fromRGB(70,90,120)}):Play() end
local function parseNum(s,def,min,max) local v=tonumber(s) if not v then return def end if min then v=math.max(min,v) end if max then v=math.min(max,v) end return v end
local function hum() local c=p.Character if not c then return nil end return c:FindFirstChildOfClass("Humanoid") end

local function applyStats()
	local h=hum() if not h then return end
	h.WalkSpeed=parseNum(wsBox.Text,16,1,300)
	h.JumpPower=parseNum(jpBox.Text,50,1,300)
	cfg.WalkSpeed=h.WalkSpeed
	cfg.JumpPower=h.JumpPower
end
wsBox.FocusLost:Connect(function() applyStats() savecfg() end)
jpBox.FocusLost:Connect(function() applyStats() savecfg() end)

local noclip=cfg.Noclip setToggle(tNoclip,noclip)
tNoclip.MouseButton1Click:Connect(function() noclip=not noclip cfg.Noclip=noclip setToggle(tNoclip,noclip) savecfg() end)
rs.Stepped:Connect(function()
	if noclip and p.Character then
		for _,v in ipairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end
	end
end)

local fly=cfg.Fly local bv,bg setToggle(tFly,fly)
local function startFly()
	local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		bv=Instance.new("BodyVelocity",hrp) bv.MaxForce=Vector3.new(9e9,9e9,9e9) bv.Velocity=Vector3.new()
		bg=Instance.new("BodyGyro",hrp) bg.MaxTorque=Vector3.new(9e9,9e9,9e9) bg.CFrame=cam.CFrame
	end
end
local function stopFly() if bv then bv:Destroy() bv=nil end if bg then bg:Destroy() bg=nil end end
if fly then startFly() end
tFly.MouseButton1Click:Connect(function() fly=not fly cfg.Fly=fly setToggle(tFly,fly) if fly then startFly() else stopFly() end savecfg() end)
rs.Heartbeat:Connect(function()
	if fly and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		local hrp=p.Character.HumanoidRootPart
		local dir=Vector3.new()
		if uis:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
		if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir=dir-Vector3.new(0,1,0) end
		local m=(math.abs(dir.X)+math.abs(dir.Y)+math.abs(dir.Z))>0 and 1 or 0
		if bv then bv.Velocity=(dir.Unit*(cfg.WalkSpeed*4))*m end
		if bg then bg.CFrame=cam.CFrame end
	end
end)

local infJump=cfg.InfJump setToggle(tInfJump,infJump)
tInfJump.MouseButton1Click:Connect(function() infJump=not infJump cfg.InfJump=infJump setToggle(tInfJump,infJump) savecfg() end)
uis.JumpRequest:Connect(function() if infJump then local h=hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

tpBtn.MouseButton1Click:Connect(function()
	local name=tpBox.Text if not name or #name==0 then return end
	for _,pl in ipairs(game:GetService("Players"):GetPlayers()) do
		if string.lower(pl.Name):find(string.lower(name),1,true) then
			local me=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
			local to=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
			if me and to then me.CFrame=to.CFrame*CFrame.new(0,0,-3) end
			break
		end
	end
end)

local espFolder=Instance.new("Folder",gui) espFolder.Name="NamHubESP"
local function clearESP(tag) for _,v in ipairs(espFolder:GetChildren()) do if tag==nil or (v.Name:find(tag)) then v:Destroy() end end end
local function makeHL(model,color,tag,text)
	local h=Instance.new("Highlight") h.Name=tag h.FillTransparency=1 h.OutlineColor=color h.OutlineTransparency=0 h.Adornee=model h.Parent=espFolder
	local head=model:FindFirstChild("Head")
	if head then
		local bb=Instance.new("BillboardGui") bb.Name=tag.."_BB" bb.Size=UDim2.new(0,120,0,18) bb.StudsOffset=Vector3.new(0,2.6,0) bb.AlwaysOnTop=true bb.Adornee=head bb.Parent=espFolder
		local lbl=Instance.new("TextLabel",bb) lbl.Size=UDim2.new(1,0,1,0) lbl.BackgroundTransparency=1 lbl.Font=Enum.Font.GothamBold lbl.TextScaled=true lbl.TextColor3=color lbl.Text=text
	end
end

local function alive(pl) local h=pl.Character and pl.Character:FindFirstChildOfClass("Humanoid") return h and h.Health>0 end
local function isKiller(pl)
	local c=pl.Character if not c then return false end
	if c:FindFirstChild("Killer") or c:FindFirstChild("IsKiller") then return true end
	for _,d in ipairs(c:GetDescendants()) do if d:IsA("BoolValue") and (d.Name:lower():find("killer") or d.Value==true and d.Name:lower()=="iskiller") then return true end end
	return false
end

local espS,espK,espI,espG=cfg.ESP_Survivor,cfg.ESP_Killer,cfg.ESP_Item,cfg.ESP_Gen
setToggle(tESPs,espS) setToggle(tESPk,espK) setToggle(tESPi,espI) setToggle(tESPg,espG)
tESPs.MouseButton1Click:Connect(function() espS=not espS cfg.ESP_Survivor=espS setToggle(tESPs,espS) if not espS then clearESP("SURV_") end savecfg() end)
tESPk.MouseButton1Click:Connect(function() espK=not espK cfg.ESP_Killer=espK setToggle(tESPk,espK) if not espK then clearESP("KILL_") end savecfg() end)
tESPi.MouseButton1Click:Connect(function() espI=not espI cfg.ESP_Item=espI setToggle(tESPi,espI) if not espI then clearESP("ITEM_") end savecfg() end)
tESPg.MouseButton1Click:Connect(function() espG=not espG cfg.ESP_Gen=espG setToggle(tESPg,espG) if not espG then clearESP("GEN_") end savecfg() end)

local lastScan=0
rs.Heartbeat:Connect(function(dt)
	lastScan=lastScan+dt
	if lastScan<0.25 then return end
	lastScan=0
	if espS or espK then
		for _,pl in ipairs(game:GetService("Players"):GetPlayers()) do
			if pl~=p and pl.Character and pl.Character:FindFirstChild("Head") and alive(pl) then
				if espK and isKiller(pl) then
					if not espFolder:FindFirstChild("KILL_"..pl.Name) then makeHL(pl.Character,Color3.fromRGB(255,80,80),"KILL_"..pl.Name,"Killer: "..pl.Name) end
				elseif espS then
					if not espFolder:FindFirstChild("SURV_"..pl.Name) then makeHL(pl.Character,Color3.fromRGB(90,255,120),"SURV_"..pl.Name,"Survivor: "..pl.Name) end
				end
			end
		end
	end
	if espI or cfg.AutoPickup then
		for _,d in ipairs(workspace:GetDescendants()) do
			if d:IsA("BasePart") then
				if espI and (d.Name:lower():find("item") or d.Name:lower():find("tool")) and not espFolder:FindFirstChild("ITEM_"..d:GetDebugId()) then
					local m=d:FindFirstAncestorOfClass("Model") or d
					local h=Instance.new("Highlight") h.Name="ITEM_"..d:GetDebugId() h.OutlineColor=Color3.fromRGB(255,255,0) h.FillTransparency=1 h.OutlineTransparency=0 h.Adornee=m h.Parent=espFolder
				end
				if cfg.AutoPickup and (d.Name:lower():find("item") or d.Name:lower():find("tool") or d.Parent and d.Parent:IsA("Tool")) then
					local me=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
					if me and (me.Position-d.Position).Magnitude<8 then
						if firetouchinterest then
							pcall(function() firetouchinterest(me,d,0) firetouchinterest(me,d,1) end)
						end
					end
				end
			end
		end
	end
	if espG then
		for _,d in ipairs(workspace:GetDescendants()) do
			if d:IsA("BasePart") and (d.Name:lower():find("generator") or d.Name:lower():find("gen")) and not espFolder:FindFirstChild("GEN_"..d:GetDebugId()) then
				local m=d:FindFirstAncestorOfClass("Model") or d
				local h=Instance.new("Highlight") h.Name="GEN_"..d:GetDebugId() h.OutlineColor=Color3.fromRGB(120,180,255) h.FillTransparency=1 h.OutlineTransparency=0 h.Adornee=m h.Parent=espFolder
			end
		end
	end
	for _,v in ipairs(espFolder:GetChildren()) do
		if v:IsA("Highlight") then local ad=v.Adornee if not ad or not ad.Parent or not ad:IsDescendantOf(workspace) then v:Destroy() end end
		if v:IsA("BillboardGui") then if not v.Adornee or not v.Adornee:IsDescendantOf(workspace) then v:Destroy() end end
	end
end)

local fb=cfg.FullBright
local oldAmb=lighting.Ambient
local oldOut=lighting.OutdoorAmbient or Color3.fromRGB(128,128,128)
local oldBright=lighting.Brightness
local oldFog=lighting.FogEnd
local function setFB(on)
	if on then
		oldAmb=lighting.Ambient; oldOut=lighting.OutdoorAmbient; oldBright=lighting.Brightness; oldFog=lighting.FogEnd
		lighting.Ambient=Color3.new(1,1,1)
		lighting.OutdoorAmbient=Color3.new(1,1,1)
		lighting.Brightness=2
		lighting.FogEnd=1e9
	else
		lighting.Ambient=oldAmb
		lighting.OutdoorAmbient=oldOut
		lighting.Brightness=oldBright
		lighting.FogEnd=oldFog
	end
end
setToggle(tFullBright,fb) setFB(fb)
tFullBright.MouseButton1Click:Connect(function() fb=not fb cfg.FullBright=fb setToggle(tFullBright,fb) setFB(fb) savecfg() end)

local fixLag=cfg.FixLag
local oldTech=lighting.Technology
local oldShadow=lighting.GlobalShadows
local oldTerrainDec=(workspace.Terrain and workspace.Terrain.Decoration) or false
local function applyLag(on)
	if on then
		oldTech=lighting.Technology; oldShadow=lighting.GlobalShadows; if workspace.Terrain then oldTerrainDec=workspace.Terrain.Decoration end
		lighting.Technology=Enum.Technology.Compatibility
		lighting.GlobalShadows=false
		if workspace.Terrain then workspace.Terrain.Decoration=false end
		for _,d in ipairs(workspace:GetDescendants()) do
			if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") then d.Enabled=false end
			if d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then d.Enabled=false end
		end
	else
		lighting.Technology=oldTech
		lighting.GlobalShadows=oldShadow
		if workspace.Terrain then workspace.Terrain.Decoration=oldTerrainDec end
		for _,d in ipairs(workspace:GetDescendants()) do
			if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") then d.Enabled=true end
			if d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then d.Enabled=true end
		end
	end
end
applyLag(fixLag) setToggle(tFixLag,fixLag)
tFixLag.MouseButton1Click:Connect(function() fixLag=not fixLag cfg.FixLag=fixLag setToggle(tFixLag,fixLag) applyLag(fixLag) savecfg() end)

local function tryPrompt(pp)
	if fireproximityprompt then pcall(function() fireproximityprompt(pp,1) end)
	else
		local t=time() while time()-t<0.3 do rs.Heartbeat:Wait() end
	end
end
local function nearest(parts,origin,maxd)
	local best=nil local bd=maxd or 999
	for _,part in ipairs(parts) do
		local d=(part.Position-origin).Magnitude
		if d<bd then best=part bd=d end
	end
	return best
end
local autoGen=cfg.AutoFixGen setToggle(tAutoGen,autoGen)
local autoPickup=cfg.AutoPickup setToggle(tAutoPickup,autoPickup)
tAutoGen.MouseButton1Click:Connect(function() autoGen=not autoGen cfg.AutoFixGen=autoGen setToggle(tAutoGen,autoGen) savecfg() end)
tAutoPickutAutoPickup.MouseButton1Click:Connect(function() 
    autoPickup = not autoPickup 
    cfg.AutoPickup = autoPickup 
    setToggle(tAutoPickup, autoPickup) 
    savecfg() 
end)

-- Auto Generator & Auto Pickup loop
rs.Heartbeat:Connect(function()
    if autoGen then
        for _,d in ipairs(workspace:GetDescendants()) do
            if d:IsA("ProximityPrompt") and (d.Name:lower():find("gen") or d.Name:lower():find("generator")) then
                local me = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if me and (me.Position - d.Parent.Position).Magnitude < 15 then
                    tryPrompt(d)
                end
            end
        end
    end
    if autoPickup then
        for _,d in ipairs(workspace:GetDescendants()) do
            if d:IsA("ProximityPrompt") and (d.Name:lower():find("item") or d.Name:lower():find("tool")) then
                local me = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if me and (me.Position - d.Parent.Position).Magnitude < 15 then
