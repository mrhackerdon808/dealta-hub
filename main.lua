--====================================
-- UTILITY HUB | FIXED ALL IN ONE
-- Made by mrhackerdon
--====================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Player
local LP = Players.LocalPlayer
local Char, Hum, HRP

local function setupChar(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end

setupChar(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setupChar)

local Cam = workspace.CurrentCamera

--====================================
-- SETTINGS
--====================================
local Fly = false
local FlySpeed = 60
local SpeedOn = false
local WalkSpeed = 32
local JumpOn = false
local JumpPower = 85

-- Coord slots
local Slots = {nil, nil, nil}

--====================================
-- GUI
--====================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "UtilityHub"
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.12,0.08)
openBtn.Position = UDim2.fromScale(0.85,0.75)
openBtn.Text = "⚙"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 26
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn)

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.32,0.65)
main.Position = UDim2.fromScale(-0.45,0.2)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "UTILITY HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local credit = Instance.new("TextLabel", main)
credit.Position = UDim2.new(0,0,0.1,0)
credit.Size = UDim2.new(1,0,0.05,0)
credit.Text = "Made by mrhackerdon"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0.16,0)
scroll.Size = UDim2.new(1,0,0.84,0)
scroll.CanvasSize = UDim2.new(0,0,3,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarImageTransparency = 0.3

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--====================================
-- BUTTON MAKER
--====================================
local function btn(text, fn)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(0.9,0,0.08,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function()
		if HRP then fn(b) end
	end)
	return b
end

--====================================
-- LIVE COORDS (FIXED)
--====================================
local coord = Instance.new("TextLabel", scroll)
coord.Size = UDim2.new(0.9,0,0.08,0)
coord.Font = Enum.Font.Gotham
coord.TextSize = 13
coord.TextColor3 = Color3.fromRGB(0,255,120)
coord.BackgroundColor3 = Color3.fromRGB(35,35,35)
coord.Text = "Coords: Loading..."
Instance.new("UICorner", coord)

task.spawn(function()
	while task.wait(0.1) do
		if HRP then
			local p = HRP.Position
			coord.Text = string.format(
				"Coords: X %.1f | Y %.1f | Z %.1f",
				p.X, p.Y, p.Z
			)
		end
	end
end)

--====================================
-- MOVEMENT
--====================================
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

btn("Speed Boost", function()
	SpeedOn = not SpeedOn
	Hum.WalkSpeed = SpeedOn and WalkSpeed or 16
end)

btn("Jump Boost", function()
	JumpOn = not JumpOn
	Hum.JumpPower = JumpOn and JumpPower or 50
end)

--====================================
-- TELEPORT UP / DOWN
--====================================
btn("Teleport +10 UP", function()
	Char:PivotTo(HRP.CFrame + Vector3.new(0,10,0))
end)

btn("Teleport -10 DOWN", function()
	Char:PivotTo(HRP.CFrame - Vector3.new(0,10,0))
end)

--====================================
-- SLOT COORD SAVE / TELEPORT (FIXED)
--====================================
for i=1,3 do
	btn("Save Slot "..i, function(b)
		Slots[i] = HRP.Position
		b.Text = "Slot "..i.." Saved"
	end)

	btn("Teleport Slot "..i, function(b)
		if Slots[i] then
			Char:PivotTo(CFrame.new(Slots[i]))
		else
			b.Text = "Slot "..i.." EMPTY"
			task.delay(1,function()
				b.Text = "Teleport Slot "..i
			end)
		end
	end)
end

--====================================
-- OPEN / CLOSE
--====================================
local open=false
local function toggle()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.4,Enum.EasingStyle.Quint),
	{Position = open and UDim2.fromScale(0.05,0.2) or UDim2.fromScale(-0.45,0.2)}):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode==Enum.KeyCode.RightShift then
		toggle()
	end
end)