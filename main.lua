--=================================
-- Unified Legit Utility Hub
-- Mobile + PC | ONE SCRIPT
--=================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()--=================================
-- Dealta Hub | ALL-IN-ONE (Mobile)
-- CAMERA LOCK REMOVED
--=================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Char, Hum, HRP

local function setup(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end
setup(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setup)

--================ SETTINGS =================
local S = {
	Master = true,

	AutoTarget = true,
	AutoAttack = true,
	AutoEquip = true,

	KillAura = false,
	AuraRange = 15,

	BringAll = false,
	AutoCollect = false,

	Fly = false,
	Speed = false,
	Jump = false,
	Noclip = false,

	TargetRange = 80,
	AttackRange = 6,
	WalkSpeed = 60,
	JumpPower = 120,
	FlySpeed = 70
}

--================ UTILS =================
local function validEnemy(m)
	return m:IsA("Model")
	and m ~= Char
	and m:FindFirstChild("Humanoid")
	and m.Humanoid.Health > 0
	and m:FindFirstChild("HumanoidRootPart")
end

local function nearestEnemy(range)
	local best, dist = nil, range or math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if validEnemy(v) then
			local d = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				best = v
			end
		end
	end
	return best
end

local function equipTool()
	for _, t in pairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") then
			Hum:EquipTool(t)
			return
		end
	end
end

--================ TARGET =================
local CurrentTarget
task.spawn(function()
	while task.wait(0.5) do
		if S.Master and S.AutoTarget then
			CurrentTarget = nearestEnemy(S.TargetRange)
		else
			CurrentTarget = nil
		end
	end
end)

--================ AUTO ATTACK =================
task.spawn(function()
	while task.wait(0.3) do
		if S.Master and S.AutoAttack and CurrentTarget then
			if (HRP.Position - CurrentTarget.HumanoidRootPart.Position).Magnitude <= S.AttackRange then
				if S.AutoEquip then equipTool() end
				mouse1click()
			end
		end
	end
end)

--================ KILL AURA =================
task.spawn(function()
	while task.wait(0.2) do
		if S.Master and S.KillAura then
			for _, v in pairs(workspace:GetDescendants()) do
				if validEnemy(v) and (HRP.Position - v.HumanoidRootPart.Position).Magnitude <= S.AuraRange then
					mouse1click()
				end
			end
		end
	end
end)

--================ BRING ALL =================
task.spawn(function()
	while task.wait(0.4) do
		if S.Master and S.BringAll then
			for _, v in pairs(workspace:GetDescendants()) do
				if validEnemy(v) then
					v.HumanoidRootPart.CFrame = HRP.CFrame * CFrame.new(0,0,-4)
				end
			end
		end
	end
end)

--================ AUTO COLLECT =================
task.spawn(function()
	while task.wait(1) do
		if S.Master and S.AutoCollect then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("TouchTransmitter") then
					firetouchinterest(HRP, v.Parent, 0)
					firetouchinterest(HRP, v.Parent, 1)
				end
			end
		end
	end
end)

--================ FLY =================
local BV, BG
RunService.RenderStepped:Connect(function()
	if S.Master and S.Fly then
		if not BV then
			BV = Instance.new("BodyVelocity", HRP)
			BV.MaxForce = Vector3.new(1e9,1e9,1e9)
			BG = Instance.new("BodyGyro", HRP)
			BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
		end

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end

		BV.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
		BG.CFrame = cam.CFrame
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end)

--================ SPEED / JUMP =================
task.spawn(function()
	while task.wait(0.3) do
		if Hum then
			Hum.WalkSpeed = S.Speed and S.WalkSpeed or 16
			Hum.JumpPower = S.Jump and S.JumpPower or 50
		end
	end
end)

--================ NOCLIP =================
RunService.Stepped:Connect(function()
	if S.Master and S.Noclip then
		for _, v in pairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

--================ ANTI AFK =================
LP.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

--================ MOBILE GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.28, 0.8)
frame.Position = UDim2.fromScale(0.02, 0.12)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local minimized = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.fromScale(0.12, 0.06)
toggleBtn.Position = UDim2.fromScale(0.02, 0.03)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Text = "☰ MENU"

toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	frame.Visible = not minimized
	toggleBtn.Text = minimized and "☰ OPEN" or "☰ MENU"
end)

if UIS.TouchEnabled then
	minimized = true
	frame.Visible = false
	toggleBtn.Text = "☰ OPEN"
end

local function button(txt, y, key)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9, 0.06)
	b.Position = UDim2.fromScale(0.05, y)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Text = txt .. ": ON"
	b.MouseButton1Click:Connect(function()
		S[key] = not S[key]
		b.Text = txt .. ": " .. (S[key] and "ON" or "OFF")
	end)
end

local y = 0.02
for _, v in ipairs({
	{"Master","Master"},
	{"Auto Attack","AutoAttack"},
	{"Kill Aura","KillAura"},
	{"Bring All","BringAll"},
	{"Auto Collect","AutoCollect"},
	{"Fly","Fly"},
	{"Speed","Speed"},
	{"Jump","Jump"},
	{"Noclip","Noclip"},
}) do
	button(v[1], y, v[2])
	y += 0.065
end--=================================
-- Legit Combat & Assist System
-- All Features | One Script
--=================================

-- Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
local Cam = workspace.CurrentCamera

LP.CharacterAdded:Connect(function(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end)

--================ SETTINGS =================
local Settings = {
	TargetRange = 80,
	AttackRange = 6,
	CameraAssist = true,
	AutoPath = true,
	AutoEquip = true,
	SprintSpeed = 22,
	WalkSpeed = 16,
	MaxStamina = 100,
	StaminaDrain = 25,
	StaminaRegen = 15
}

--================ STAMINA ==================
local stamina = Settings.MaxStamina
local sprinting = false

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.LeftShift then
		sprinting = true
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.LeftShift then
		sprinting = false
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if sprinting and stamina > 0 then
		Hum.WalkSpeed = Settings.SprintSpeed
		stamina = math.max(0, stamina - Settings.StaminaDrain * dt)
	else
		Hum.WalkSpeed = Settings.WalkSpeed
		stamina = math.min(Settings.MaxStamina, stamina + Settings.StaminaRegen * dt)
	end
end)

--================ TARGETING =================
local CurrentTarget

local function isValidTarget(m)
	return m:IsA("Model")
		and m ~= Char
		and m:FindFirstChild("Humanoid")
		and m.Humanoid.Health > 0
		and m:FindFirstChild("HumanoidRootPart")
end

local function getNearestTarget()
	local best, dist = nil, Settings.TargetRange
	for _, v in pairs(workspace:GetChildren()) do
		if isValidTarget(v) then
			local d = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				best = v
			end
		end
	end
	return best
end

task.spawn(function()
	while task.wait(0.5) do
		CurrentTarget = getNearestTarget()
	end
end)

--================ CAMERA ASSIST =================
RunService.RenderStepped:Connect(function()
	if Settings.CameraAssist and CurrentTarget then
		local pos = CurrentTarget.HumanoidRootPart.Position
		local camCF = Cam.CFrame
		local look = CFrame.new(camCF.Position, pos)
		Cam.CFrame = camCF:Lerp(look, 0.08)
	end
end)

--================ PATHFINDING =================
local function walkTo(pos)
	local path = PathfindingService:CreatePath()
	path:ComputeAsync(HRP.Position, pos)
	for _, wp in ipairs(path:GetWaypoints()) do
		Hum:MoveTo(wp.Position)
		Hum.MoveToFinished:Wait()
	end
end

task.spawn(function()
	while task.wait(1) do
		if Settings.AutoPath and CurrentTarget then
			local d = (HRP.Position - CurrentTarget.HumanoidRootPart.Position).Magnitude
			if d > Settings.AttackRange then
				walkTo(CurrentTarget.HumanoidRootPart.Position)
			end
		end
	end
end)

--================ AUTO EQUIP =================
local function equipTool()
	for _, t in pairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") then
			Hum:EquipTool(t)
			return
		end
	end
end

--================ AUTO COMBAT =================
task.spawn(function()
	while task.wait(0.4) do
		if CurrentTarget then
			if Settings.AutoEquip then
				equipTool()
			end
			local d = (HRP.Position - CurrentTarget.HumanoidRootPart.Position).Magnitude
			if d <= Settings.AttackRange then
				mouse1click()
			end
		end
	end
end)

--================ ENEMY OVERLAY =================
local function addOverlay(enemy)
	if enemy:FindFirstChild("InfoGui") then return end

	local gui = Instance.new("BillboardGui", enemy)
	gui.Name = "InfoGui"
	gui.Size = UDim2.fromScale(4,1)
	gui.StudsOffset = Vector3.new(0,3,0)
	gui.AlwaysOnTop = true

	local txt = Instance.new("TextLabel", gui)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,0,0)
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold

	RunService.RenderStepped:Connect(function()
		if enemy:FindFirstChild("Humanoid") then
			local hp = math.floor(enemy.Humanoid.Health)
			local dist = math.floor((HRP.Position - enemy.HumanoidRootPart.Position).Magnitude)
			txt.Text = "HP: "..hp.." | "..dist.."m"
		end
	end)
end

task.spawn(function()
	while task.wait(1) do
		for _, v in pairs(workspace:GetChildren()) do
			if isValidTarget(v) then
				addOverlay(v)
			end
		end
	end
end)--=================================
-- Dealta Hub | ALL FEATURES +
-- Kill Aura Range + Bring All
--=================================

-- Services
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local VirtualUser=game:GetService("VirtualUser")

local LP=Players.LocalPlayer
local Char,Hum,HRP

local function setup(c)
    Char=c
    Hum=c:WaitForChild("Humanoid")
    HRP=c:WaitForChild("HumanoidRootPart")
end
setup(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setup)

-- Settings
local S={
    Master=true,
    AutoFarm=false,AutoCollect=false,KillAura=false,
    Fly=false,Speed=false,Jump=false,Noclip=false,ESP=false,
    BringAll=false,
    WalkSpeed=80,JumpPower=120,FlySpeed=70,
    TweenSpeed=0.25,Distance=3,
    AuraRange=15
}

-- Utils
local function tweenTo(cf)
    if HRP then
        TweenService:Create(
            HRP,
            TweenInfo.new(S.TweenSpeed,Enum.EasingStyle.Linear),
            {CFrame=cf}
        ):Play()
    end
end

local function validEnemy(m)
    return m:IsA("Model")
    and m~=Char
    and m:FindFirstChild("Humanoid")
    and m.Humanoid.Health>0
    and m:FindFirstChild("HumanoidRootPart")
end

local function nearestEnemy()
    local best,dist=nil,math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if validEnemy(v) then
            local d=(HRP.Position-v.HumanoidRootPart.Position).Magnitude
            if d<dist then dist=d best=v end
        end
    end
    return best
end

-- Auto Farm
task.spawn(function()
    while task.wait(0.3) do
        if S.Master and S.AutoFarm and HRP then
            local e=nearestEnemy()
            if e then
                tweenTo(e.HumanoidRootPart.CFrame*CFrame.new(0,0,-S.Distance))
                mouse1click()
            end
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.2) do
        if S.Master and S.KillAura and HRP then
            for _,v in pairs(workspace:GetDescendants()) do
                if validEnemy(v) then
                    if (HRP.Position-v.HumanoidRootPart.Position).Magnitude<=S.AuraRange then
                        mouse1click()
                    end
                end
            end
        end
    end
end)

-- Bring All Enemies To Player
task.spawn(function()
    while task.wait(0.3) do
        if S.Master and S.BringAll and HRP then
            for _,v in pairs(workspace:GetDescendants()) do
                if validEnemy(v) then
                    v.HumanoidRootPart.CFrame=HRP.CFrame*CFrame.new(0,0,-5)
                end
            end
        end
    end
end)

-- Auto Collect
task.spawn(function()
    while task.wait(1) do
        if S.Master and S.AutoCollect and HRP then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") then
                    firetouchinterest(HRP,v.Parent,0)
                    firetouchinterest(HRP,v.Parent,1)
                end
            end
        end
    end
end)

-- Fly
local BV,BG
RunService.RenderStepped:Connect(function()
    if S.Master and S.Fly and HRP then
        if not BV then
            BV=Instance.new("BodyVelocity",HRP)
            BV.MaxForce=Vector3.new(1e9,1e9,1e9)
            BG=Instance.new("BodyGyro",HRP)
            BG.MaxTorque=Vector3.new(1e9,1e9,1e9)
        end
        local cam=workspace.CurrentCamera
        local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir+=cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=cam.CFrame.UpVector end
        BV.Velocity=dir.Magnitude>0 and dir.Unit*S.FlySpeed or Vector3.zero
        BG.CFrame=cam.CFrame
    else
        if BV then BV:Destroy() BV=nil end
        if BG then BG:Destroy() BG=nil end
    end
end)

-- Speed / Jump
task.spawn(function()
    while task.wait(0.3) do
        if Hum then
            Hum.WalkSpeed=S.Speed and S.WalkSpeed or 16
            Hum.JumpPower=S.Jump and S.JumpPower or 50
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if S.Master and S.Noclip and Char then
        for _,v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

-- Anti AFK
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- GUI
local gui=Instance.new("ScreenGui",LP.PlayerGui)
local f=Instance.new("Frame",gui)
f.Size=UDim2.fromScale(0.26,0.8)
f.Position=UDim2.fromScale(0.03,0.12)
f.BackgroundColor3=Color3.fromRGB(25,25,25)

local function btn(t,y,cb)
    local b=Instance.new("TextButton",f)
    b.Size=UDim2.fromScale(0.9,0.07)
    b.Position=UDim2.fromScale(0.05,y)
    b.Text=t
    b.BackgroundColor3=Color3.fromRGB(40,40,40)
    b.TextColor3=Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

btn("MASTER ON/OFF",0.02,function()S.Master=not S.Master end)
btn("Auto Farm",0.10,function()S.AutoFarm=not S.AutoFarm end)
btn("Auto Collect",0.18,function()S.AutoCollect=not S.AutoCollect end)
btn("Kill Aura",0.26,function()S.KillAura=not S.KillAura end)
btn("Aura Range +5",0.34,function()S.AuraRange+=5 end)
btn("Aura Range -5",0.42,function()S.AuraRange=math.max(5,S.AuraRange-5) end)
btn("Bring All Enemies",0.50,function()S.BringAll=not S.BringAll end)
btn("Fly",0.58,function()S.Fly=not S.Fly end)
btn("Speed",0.66,function()S.Speed=not S.Speed end)
btn("Jump Boost",0.74,function()S.Jump=not S.Jump end)

UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode==Enum.KeyCode.RightShift then
        f.Visible=not f.Visible
    end
end)-- =================================
-- Dealta Style Auto Farm Hub
-- =================================

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

-- Update character on respawn
LP.CharacterAdded:Connect(function(char)
    Character = char
end)

-- =========================
-- CONFIG
-- =========================
local Settings = {
    AutoFarm = false,
    AutoCollect = false,
    TweenSpeed = 0.25,
    DistanceFromEnemy = 3
}

-- =========================
-- UTILS
-- =========================
local function getHRP(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Tween teleport
local function tweenTo(cf)
    if not getHRP(Character) then return end
    TweenService:Create(
        Character.HumanoidRootPart,
        TweenInfo.new(Settings.TweenSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    ):Play()
end

-- Find nearest enemy
local function getNearestEnemy()
    local closest, dist = nil, math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model")
        and v ~= Character
        and v:FindFirstChild("Humanoid")
        and v.Humanoid.Health > 0
        and v:FindFirstChild("HumanoidRootPart") then

            local d = (Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

-- =========================
-- AUTO FARM
-- =========================
task.spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm and getHRP(Character) then
            local enemy = getNearestEnemy()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                tweenTo(enemy.HumanoidRootPart.CFrame * CFrame.new(0,0,-Settings.DistanceFromEnemy))
                mouse1click()
            end
        end
    end
end)

-- =========================
-- AUTO COLLECT
-- =========================
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoCollect and getHRP(Character) then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") then
                    firetouchinterest(Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
    end
end)

-- =========================
-- ANTI AFK
-- =========================
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- =========================
-- GUI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "DealtaHub"
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.2, 0.25)
frame.Position = UDim2.fromScale(0.05, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function makeButton(text, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.fromScale(0.9, 0.2)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

makeButton("Auto Farm", UDim2.fromScale(0.05, 0.1), function()
    Settings.AutoFarm = not Settings.AutoFarm
    warn("AutoFarm:", Settings.AutoFarm)
end)

makeButton("Auto Collect", UDim2.fromScale(0.05, 0.4), function()
    Settings.AutoCollect = not Settings.AutoCollect
    warn("AutoCollect:", Settings.AutoCollect)
end)-- =================================
-- Dealta Style Auto Farm Hub
-- =================================

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

-- Update character on respawn
LP.CharacterAdded:Connect(function(char)
    Character = char
end)

-- =========================
-- CONFIG
-- =========================
local Settings = {
    AutoFarm = false,
    AutoCollect = false,
    TweenSpeed = 0.25, -- lower = faster
    DistanceFromEnemy = 3
}

-- =========================
-- UTILS
-- =========================
local function getHRP(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Tween teleport (safer)
local function tweenTo(cf)
    if not getHRP(Character) then return end
    local tween = TweenService:Create(
        Character.HumanoidRootPart,
        TweenInfo.new(Settings.TweenSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )
    tween:Play()
end

-- Find nearest enemy
local function getNearestEnemy()
    local closest, dist = nil, math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model")
        and v ~= Character
        and v:FindFirstChild("Humanoid")
        and v.Humanoid.Health > 0
        and v:FindFirstChild("HumanoidRootPart") then

            local d = (Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end

    return closest
end
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
local Cam = workspace.CurrentCamera

LP.CharacterAdded:Connect(function(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end)

--================ SETTINGS =================
local S = {
	Master = true,

	-- Fly
	Fly = false,
	FlySpeed = 60,

	-- Items
	BringItems = false,
	SelectedItem = "Wood",
	StackAmount = 10,

	-- Auto Harvest
	AutoHarvest = false,
	HarvestDistance = 7,

	-- ESP
	ItemESP = false
}

--================ ITEM CHECK =================
local function isItem(obj)
	return obj:IsA("Tool")
		or (obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") and not obj:FindFirstChild("Humanoid"))
end

--================ FLY (MOBILE SAFE) =================
local BV, BG

RunService.RenderStepped:Connect(function()
	if not S.Master or not S.Fly or not HRP then
		if BV then BV:Destroy() BV = nil end
		if BG then BG:Destroy() BG = nil end
		return
	end

	if not BV then
		BV = Instance.new("BodyVelocity", HRP)
		BV.MaxForce = Vector3.new(1e9,1e9,1e9)

		BG = Instance.new("BodyGyro", HRP)
		BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
	end

	BG.CFrame = Cam.CFrame

	if UIS.TouchEnabled or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		BV.Velocity = Cam.CFrame.LookVector * S.FlySpeed
	else
		BV.Velocity = Vector3.zero
	end
end)

--================ BRING ITEMS (STACKED) =================
task.spawn(function()
	while task.wait(0.4) do
		if S.Master and S.BringItems and HRP then
			local count = 0
			for _, v in pairs(workspace:GetChildren()) do
				if count >= S.StackAmount then break end

				if isItem(v) and v.Name:lower():find(S.SelectedItem:lower()) then
					local part = v:IsA("Tool") and v:FindFirstChild("Handle")
						or v:FindFirstChildWhichIsA("BasePart")

					if part then
						count += 1
						part.CFrame = HRP.CFrame * CFrame.new(math.random(-4,4),2,math.random(-4,4))
					end
				end
			end
		end
	end
end)

--================ AUTO HARVEST / CHOP =================
task.spawn(function()
	while task.wait(0.3) do
		if S.Master and S.AutoHarvest and HRP then
			for _, v in pairs(workspace:GetChildren()) do
				if v:IsA("Model")
					and v.Name:lower():find("tree")
					and v:FindFirstChildWhichIsA("BasePart") then

					local part = v:FindFirstChildWhichIsA("BasePart")
					if (HRP.Position - part.Position).Magnitude <= S.HarvestDistance then
						mouse1click()
					end
				end
			end
		end
	end
end)

--================ ITEM ESP ONLY =================
local function addItemESP(item)
	if item:FindFirstChild("ItemESP") then return end

	local bb = Instance.new("BillboardGui", item)
	bb.Name = "ItemESP"
	bb.Size = UDim2.fromScale(4,1)
	bb.StudsOffset = Vector3.new(0,2,0)
	bb.AlwaysOnTop = true

	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.fromRGB(0,255,0)
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold
	txt.Text = item.Name
end

task.spawn(function()
	while task.wait(1) do
		if S.ItemESP then
			for _, v in pairs(workspace:GetChildren()) do
				if isItem(v) then
					addItemESP(v)
				end
			end
		end
	end
end)

--================ GUI (MOBILE FRIENDLY) =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "UnifiedHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.26,0.75)
frame.Position = UDim2.fromScale(0.03,0.12)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function btn(text, y, cb)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.08)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.MouseButton1Click:Connect(cb)
end

btn("MASTER",0.02,function() S.Master = not S.Master end)
btn("FLY",0.12,function() S.Fly = not S.Fly end)
btn("Fly Speed +",0.22,function() S.FlySpeed += 10 end)
btn("Fly Speed -",0.30,function() S.FlySpeed = math.max(20,S.FlySpeed-10) end)

btn("Bring Items",0.40,function() S.BringItems = not S.BringItems end)
btn("Stack +5",0.48,function() S.StackAmount += 5 end)
btn("Stack -5",0.56,function() S.StackAmount = math.max(1,S.StackAmount-5) end)

btn("Select Wood",0.64,function() S.SelectedItem="Wood" end)
btn("Select Sapling",0.72,function() S.SelectedItem="Sapling" end)

btn("Auto Harvest",0.80,function() S.AutoHarvest = not S.AutoHarvest end)
btn("Item ESP",0.88,function() S.ItemESP = not S.ItemESP end)

-- Toggle UI
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)