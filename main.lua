--==============================
-- LEGIT PLAYER UTILITY HUB V2
-- ALL IN ONE | DELTA SAFE
-- Updated by ChatGPT
-- Original by mrhackerdon
--==============================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- Player
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Char, Hum, HRP

local function setupChar(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end

setupChar(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setupChar)

-- SETTINGS
local MAX = 500
local FlySpeed = 120
local WalkSpeed = 32

-- STATES
local Fly = false
local Speed = false
local NoClip = false
local ShowCoords = false

-- SAVE SLOTS
local Slots = {}
for i = 1,5 do Slots[i] = nil end

--==============================
-- COORD GUI
--==============================
local coordGui = Instance.new("ScreenGui", LP.PlayerGui)
coordGui.Name = "CoordGui"
coordGui.ResetOnSpawn = false

local coord = Instance.new("TextLabel", coordGui)
coord.Size = UDim2.new(0.45,0,0.045,0)
coord.Position = UDim2.new(0.275,0,0.02,0)
coord.BackgroundColor3 = Color3.fromRGB(20,20,20)
coord.TextColor3 = Color3.fromRGB(0,255,120)
coord.Font = Enum.Font.GothamBold
coord.TextSize = 13
coord.BorderSizePixel = 0
coord.Visible = false
Instance.new("UICorner", coord).CornerRadius = UDim.new(0,8)

RunService.RenderStepped:Connect(function()
	if ShowCoords and HRP then
		local p = HRP.Position
		coord.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", p.X, p.Y, p.Z)
	end
end)

--==============================
-- UI
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "UtilityHub"
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0.1,0,0.07,0)
openBtn.Position = UDim2.new(0.86,0,0.75,0)
openBtn.Text = "⚙"
openBtn.TextSize = 22
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0.28,0,0.6,0)
main.Position = UDim2.new(-0.35,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.08,0)
title.Text = "UTILITY HUB V2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0.08,0)
scroll.Size = UDim2.new(1,0,0.92,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarImageTransparency = 0.4
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function button(text, callback)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(0.92,0,0.055,0)
	b.Text = text
	b.TextSize = 12
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(function()
		callback(b)
	end)
	return b
end

--==============================
-- FEATURES
--==============================

button("SHOW COORDS", function()
	ShowCoords = not ShowCoords
	coord.Visible = ShowCoords
end)

-- SPEED
button("SPEED : OFF", function(b)
	Speed = not Speed
	b.Text = "SPEED : "..(Speed and "ON" or "OFF")
	Hum.WalkSpeed = Speed and WalkSpeed or 16
end)

-- NOCLIP
button("NOCLIP : OFF", function(b)
	NoClip = not NoClip
	b.Text = "NOCLIP : "..(NoClip and "ON" or "OFF")
	if not NoClip and Char then
		for _,v in ipairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)

-- FLY
local bv, bg
button("FLY : OFF", function(b)
	Fly = not Fly
	b.Text = "FLY : "..(Fly and "ON" or "OFF")

	if not Fly then
		if bv then bv:Destroy() bv = nil end
		if bg then bg:Destroy() bg = nil end
	end
end)

button("FLY SPEED +", function()
	FlySpeed = math.clamp(FlySpeed + 20, 0, MAX)
end)

button("FLY SPEED -", function()
	FlySpeed = math.clamp(FlySpeed - 20, 0, MAX)
end)

-- TELEPORT
button("TP +10 FRONT", function()
	HRP.CFrame += Camera.CFrame.LookVector * 10
end)

button("TP +10 UP", function()
	HRP.CFrame += Vector3.new(0,10,0)
end)

-- SAVE SLOTS
for i = 1,5 do
	button("SAVE SLOT "..i, function()
		Slots[i] = HRP.CFrame
	end)

	button("TP SLOT "..i, function()
		if Slots[i] then
			HRP.CFrame = Slots[i]
		end
	end)
end

--==============================
-- MAIN LOOP
--==============================
RunService.RenderStepped:Connect(function()
	if Fly and HRP then
		if not bv then
			bv = Instance.new("BodyVelocity", HRP)
			bv.MaxForce = Vector3.new(1e9,1e9,1e9)

			bg = Instance.new("BodyGyro", HRP)
			bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
		end

		bv.Velocity = Camera.CFrame.LookVector * FlySpeed
		bg.CFrame = Camera.CFrame
	end

	if NoClip and Char then
		for _,v in ipairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- OPEN / CLOSE
local open = false
openBtn.MouseButton1Click:Connect(function()
	open = not open
	TweenService:Create(
		main,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad),
		{Position = open and UDim2.new(0.04,0,0.2,0) or UDim2.new(-0.35,0,0.2,0)}
	):Play()
end)