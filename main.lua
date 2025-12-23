--====================================================
-- DEALTA HUB V3 — ALL IN ONE (FINAL FIXED)
-- Fly • Speed • Jump • Teleport • FPS/Ping
-- Mobile + PC • R6 + R15 • Respawn Safe
--====================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

-- PLAYER
local LP = Players.LocalPlayer
local Char, Hum, HRP

local function loadChar(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
	Hum.UseJumpPower = true
end

loadChar(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(loadChar)

--====================================================
-- STATES
--====================================================
local FLY = false
local SPEED = false
local JUMP = false
local SHOW_STATS = false

local FLY_SPEED = 60
local SPEED_VALUE = 32
local JUMP_VALUE = 90

--====================================================
-- GUI
--====================================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "DealtaHubV3"
gui.ResetOnSpawn = false

-- OPEN BUTTON
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.12,0.08)
openBtn.Position = UDim2.fromScale(0.85,0.75)
openBtn.Text = "⚡"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 26
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.3,0.6)
main.Position = UDim2.fromScale(-0.35,0.2)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- GRADIENT
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120,0,255))
}

RunService.RenderStepped:Connect(function()
	grad.Rotation += 0.1
end)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.12,0)
title.Text = "DEALTA HUB V3"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0,10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUTTON MAKER
local function makeBtn(text)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.9,0,0.085,0)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local flyBtn = makeBtn("Fly")
local speedBtn = makeBtn("Speed")
local jumpBtn = makeBtn("Jump")
local tpBtn = makeBtn("Teleport +10")
local statsBtn = makeBtn("FPS / Ping")

local function glow(btn,on)
	TweenService:Create(btn,TweenInfo.new(0.25),
		{BackgroundColor3 = on and Color3.fromRGB(0,170,255) or Color3.fromRGB(35,35,35)}
	):Play()
end

--====================================================
-- FLY (R6 + R15 SAFE)
--====================================================
local flying = false
local lv, ao, att

local function startFly()
	if not HRP then return end
	att = Instance.new("Attachment", HRP)

	lv = Instance.new("LinearVelocity", HRP)
	lv.Attachment0 = att
	lv.MaxForce = math.huge

	ao = Instance.new("AlignOrientation", HRP)
	ao.Attachment0 = att
	ao.MaxTorque = math.huge
	ao.Responsiveness = 30
end

local function stopFly()
	if lv then lv:Destroy() lv = nil end
	if ao then ao:Destroy() ao = nil end
	if att then att:Destroy() att = nil end
end

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly : "..(flying and "ON" or "OFF")
	glow(flyBtn,flying)

	if flying then
		startFly()
	else
		stopFly()
	end
end)

RunService.RenderStepped:Connect(function()
	if not flying or not lv or not HRP then return end
	local cam = workspace.CurrentCamera
	ao.CFrame = cam.CFrame
	lv.VectorVelocity = cam.CFrame.LookVector * FLY_SPEED
end)

--====================================================
-- SPEED (ANTI RESET)
--====================================================
speedBtn.MouseButton1Click:Connect(function()
	SPEED = not SPEED
	speedBtn.Text = "Speed : "..(SPEED and "ON" or "OFF")
	glow(speedBtn,SPEED)
end)

--====================================================
-- JUMP
--====================================================
jumpBtn.MouseButton1Click:Connect(function()
	JUMP = not JUMP
	jumpBtn.Text = "Jump : "..(JUMP and "ON" or "OFF")
	glow(jumpBtn,JUMP)
end)

RunService.Heartbeat:Connect(function()
	if Hum then
		Hum.WalkSpeed = SPEED and SPEED_VALUE or 16
		Hum.JumpPower = JUMP and JUMP_VALUE or 50
	end
end)

--====================================================
-- TELEPORT +10 STUDS
--====================================================
tpBtn.MouseButton1Click:Connect(function()
	if HRP then
		local cam = workspace.CurrentCamera
		HRP.CFrame = HRP.CFrame + (cam.CFrame.LookVector * 10)
	end
end)

--====================================================
-- FPS / PING
--====================================================
local overlay = Instance.new("TextLabel", gui)
overlay.Size = UDim2.fromScale(0.18,0.08)
overlay.Position = UDim2.fromScale(0.4,0.05)
overlay.BackgroundColor3 = Color3.fromRGB(20,20,20)
overlay.TextColor3 = Color3.new(1,1,1)
overlay.Font = Enum.Font.Gotham
overlay.TextSize = 14
overlay.Visible = false
overlay.Active = true
overlay.Draggable = true
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0,10)

statsBtn.MouseButton1Click:Connect(function()
	SHOW_STATS = not SHOW_STATS
	overlay.Visible = SHOW_STATS
	statsBtn.Text = "FPS / Ping : "..(SHOW_STATS and "ON" or "OFF")
	glow(statsBtn,SHOW_STATS)
end)

RunService.RenderStepped:Connect(function(dt)
	if SHOW_STATS then
		local fps = math.floor(1/dt)
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		overlay.Text = "FPS: "..fps.." | Ping: "..ping.." ms"
	end
end)

--====================================================
-- OPEN / CLOSE
--====================================================
local open = false
local function toggle()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.4,Enum.EasingStyle.Quint),
		{Position = open and UDim2.fromScale(0.05,0.2) or UDim2.fromScale(-0.35,0.2)}
	):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then
		toggle()
	end
end)