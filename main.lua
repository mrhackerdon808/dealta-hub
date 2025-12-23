--==============================
-- UTILITY HUB (ALL IN ONE)
-- Compact UI | Delta Safe
-- Made by mrhackerdon
--==============================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Player
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

-- STATES
local Fly = false
local FlySpeed = 60
local SpeedBoost = false
local WalkSpeedValue = 32
local JumpBoost = false
local JumpPowerValue = 85

-- SLOTS (SESSION)
local Slots = {}
for i=1,3 do Slots[i] = nil end

--================ GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

-- Open Button
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.1,0.07)
openBtn.Position = UDim2.fromScale(0.86,0.75)
openBtn.Text = "⚙"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22
openBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- Main
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.26,0.55)
main.Position = UDim2.fromScale(-0.35,0.2)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "UTILITY HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Credit
local credit = Instance.new("TextLabel", main)
credit.Size = UDim2.new(1,0,0.05,0)
credit.Position = UDim2.new(0,0,0.1,0)
credit.Text = "mrhackerdon"
credit.Font = Enum.Font.Gotham
credit.TextSize = 11
credit.TextColor3 = Color3.fromRGB(160,160,160)
credit.BackgroundTransparency = 1

-- Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0.15,0)
scroll.Size = UDim2.new(1,0,0.85,0)
scroll.BackgroundTransparency = 1
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarImageTransparency = 0.4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUTTON MAKER (SMALL)
local function btn(text, callback)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(0.92,0,0.055,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(function()
		callback(b)
	end)
	return b
end

--================ FEATURES =================

-- Fly
local BV,BG
btn("Fly : OFF", function(b)
	Fly = not Fly
	b.Text = "Fly : "..(Fly and "ON" or "OFF")
end)

btn("Fly Speed +", function() FlySpeed += 10 end)
btn("Fly Speed -", function() FlySpeed = math.max(20,FlySpeed-10) end)

RunService.RenderStepped:Connect(function()
	if Fly and HRP then
		if not BV then
			BV = Instance.new("BodyVelocity", HRP)
			BV.MaxForce = Vector3.new(1e9,1e9,1e9)
			BG = Instance.new("BodyGyro", HRP)
			BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
		end
		BG.CFrame = Cam.CFrame
		BV.Velocity = Cam.CFrame.LookVector * FlySpeed
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end)

-- Speed
btn("Speed Boost", function()
	SpeedBoost = not SpeedBoost
	Hum.WalkSpeed = SpeedBoost and WalkSpeedValue or 16
end)

btn("Speed +", function()
	WalkSpeedValue += 5
	if SpeedBoost then Hum.WalkSpeed = WalkSpeedValue end
end)

btn("Speed -", function()
	WalkSpeedValue = math.max(16,WalkSpeedValue-5)
	if SpeedBoost then Hum.WalkSpeed = WalkSpeedValue end
end)

-- Jump
btn("Jump Boost", function()
	JumpBoost = not JumpBoost
	Hum.JumpPower = JumpBoost and JumpPowerValue or 50
end)

-- Teleport
btn("Teleport +10 UP", function()
	HRP.CFrame += Vector3.new(0,10,0)
end)

btn("Teleport -10 DOWN", function()
	HRP.CFrame -= Vector3.new(0,10,0)
end)

-- Slots
for i=1,3 do
	btn("Save Slot "..i, function()
		Slots[i] = HRP.CFrame
	end)

	btn("TP Slot "..i, function()
		if Slots[i] then
			HRP.CFrame = Slots[i]
		end
	end)
end

--================ OPEN / CLOSE =================
local open = false
local function toggle()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.35,Enum.EasingStyle.Quint),
		{Position = open and UDim2.fromScale(0.05,0.2) or UDim2.fromScale(-0.35,0.2)}
	):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then
		toggle()
	end
end)