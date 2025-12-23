-- DEALTA HUB V3 (LEGIT)
-- Gradient UI + FPS/Ping + Admin Check

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- ===== ADMIN LIST =====
local ADMINS = {
	[player.UserId] = true -- replace with your UserId
}

local isAdmin = ADMINS[player.UserId] or game.CreatorId == player.UserId

-- ================= GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DealtaV3"
gui.ResetOnSpawn = false

-- OPEN BUTTON (MOBILE)
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
main.Size = UDim2.fromScale(0.3,0.55)
main.Position = UDim2.fromScale(-0.35,0.22)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- GRADIENT
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120,0,255))
}

RS.RenderStepped:Connect(function()
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

-- ================= BUTTON MAKER =================
local function makeBtn(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0.085,0)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.AutoButtonColor = false
	b.Parent = main
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local flyBtn = makeBtn("Fly")
local speedBtn = makeBtn("Speed")
local jumpBtn = makeBtn("Jump")
local fpsBtn = makeBtn("FPS / Ping")

local resetBtn = makeBtn("Reset (Admin)")
local healBtn = makeBtn("Heal (Admin)")

-- ================= ANIMATION =================
local function glow(btn,on)
	TweenService:Create(btn,TweenInfo.new(0.25),
		{BackgroundColor3 = on and Color3.fromRGB(0,170,255) or Color3.fromRGB(35,35,35)}
	):Play()
end

-- ================= FEATURES =================
-- Fly
local flying = false
local bv
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly : "..(flying and "ON" or "OFF")
	glow(flyBtn,flying)

	if flying then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	else
		if bv then bv:Destroy() end
	end
end)

RS.RenderStepped:Connect(function()
	if flying and bv then
		bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
	end
end)

-- Speed
local speed = false
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	speedBtn.Text = "Speed : "..(speed and "ON" or "OFF")
	glow(speedBtn,speed)
	hum.WalkSpeed = speed and 32 or 16
end)

-- Jump
local jump = false
jumpBtn.MouseButton1Click:Connect(function()
	jump = not jump
	jumpBtn.Text = "Jump : "..(jump and "ON" or "OFF")
	glow(jumpBtn,jump)
	hum.JumpPower = jump and 85 or 50
end)

-- ================= FPS / PING OVERLAY =================
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

local showStats = false
fpsBtn.MouseButton1Click:Connect(function()
	showStats = not showStats
	overlay.Visible = showStats
	fpsBtn.Text = "FPS / Ping : "..(showStats and "ON" or "OFF")
	glow(fpsBtn,showStats)
end)

RS.RenderStepped:Connect(function(dt)
	if showStats then
		local fps = math.floor(1/dt)
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		overlay.Text = "FPS: "..fps.." | Ping: "..ping.." ms"
	end
end)

-- ================= ADMIN TOOLS =================
resetBtn.MouseButton1Click:Connect(function()
	if isAdmin then hum.Health = 0 end
end)

healBtn.MouseButton1Click:Connect(function()
	if isAdmin then hum.Health = hum.MaxHealth end
end)

-- ================= OPEN / CLOSE =================
local open = false
local function toggle()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.4,Enum.EasingStyle.Quint),
		{Position = open and UDim2.fromScale(0.05,0.22) or UDim2.fromScale(-0.35,0.22)}
	):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,gp)
	if not gp and i.KeyCode == Enum.KeyCode.RightShift then
		toggle()
	end
end)