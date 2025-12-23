--==============================
-- ALL IN ONE UTILITY HUB
-- DELTA SAFE | OLD UI
-- Made by mrhackerdon
--==============================

local Players = game:GetService("Players")
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

-- STATES
local Fly = false
local FlySpeed = 60
local ShowCoords = false

-- TELEPORT SLOTS (SESSION)
local Slots = {}
for i=1,15 do Slots[i] = nil end

--================ GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45,0.8)
main.Position = UDim2.fromScale(0.03,0.1)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.08,0)
title.Text = "UTILITY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

local credit = Instance.new("TextLabel", main)
credit.Position = UDim2.new(0,0,0.08,0)
credit.Size = UDim2.new(1,0,0.04,0)
credit.Text = "Made by mrhackerdon"
credit.TextColor3 = Color3.fromRGB(170,170,170)
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0.12,0)
scroll.Size = UDim2.new(1,0,0.88,0)
scroll.CanvasSize = UDim2.new(0,0,30,0)
scroll.ScrollBarImageTransparency = 0.3
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

-- BUTTON MAKER
local function btn(text, cb)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(0.95,0,0.06,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.MouseButton1Click:Connect(cb)
	return b
end

--================ COORD DISPLAY =================
local coordGui = Instance.new("ScreenGui", LP.PlayerGui)
coordGui.ResetOnSpawn = false

local coordLabel = Instance.new("TextLabel", coordGui)
coordLabel.Size = UDim2.fromScale(0.4,0.06)
coordLabel.Position = UDim2.fromScale(0.3,0.02)
coordLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
coordLabel.TextColor3 = Color3.fromRGB(0,255,120)
coordLabel.Font = Enum.Font.GothamBold
coordLabel.TextSize = 14
coordLabel.Visible = false
coordLabel.BorderSizePixel = 0

RunService.RenderStepped:Connect(function()
	if ShowCoords and HRP then
		local p = HRP.Position
		coordLabel.Text = string.format(
			"X: %.1f | Y: %.1f | Z: %.1f",
			p.X,p.Y,p.Z
		)
	end
end)

btn("SHOW / HIDE COORDS", function()
	ShowCoords = not ShowCoords
	coordLabel.Visible = ShowCoords
end)

btn("COPY COORDS", function()
	if setclipboard and HRP then
		local p = HRP.Position
		setclipboard(string.format("Vector3.new(%.2f, %.2f, %.2f)",p.X,p.Y,p.Z))
	end
end)

-- MANUAL INPUT
local input = Instance.new("TextBox", scroll)
input.Size = UDim2.new(0.95,0,0.06,0)
input.PlaceholderText = "Paste coords: x,y,z"
input.Text = ""
input.BackgroundColor3 = Color3.fromRGB(40,40,40)
input.TextColor3 = Color3.new(1,1,1)
input.Font = Enum.Font.Gotham
input.TextSize = 13

btn("TELEPORT TO INPUT", function()
	local x,y,z = input.Text:match("([^,]+),([^,]+),([^,]+)")
	if x then
		Char:PivotTo(CFrame.new(tonumber(x),tonumber(y),tonumber(z)))
	end
end)

-- MOVEMENT
btn("FLY ON / OFF", function()
	Fly = not Fly
end)

btn("FLY SPEED +", function()
	FlySpeed += 10
end)

btn("FLY SPEED -", function()
	FlySpeed = math.max(20, FlySpeed-10)
end)

btn("SPEED BOOST", function()
	Hum.WalkSpeed = (Hum.WalkSpeed == 16 and 32 or 16)
end)

btn("JUMP BOOST", function()
	Hum.JumpPower = (Hum.JumpPower == 50 and 85 or 50)
end)

btn("TP +15 UP", function()
	Char:PivotTo(HRP.CFrame + Vector3.new(0,15,0))
end)

btn("TP -15 DOWN", function()
	Char:PivotTo(HRP.CFrame - Vector3.new(0,15,0))
end)

-- FLY ENGINE
local BV,BG
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

-- TELEPORT SLOTS
for i=1,15 do
	btn("SAVE SLOT "..i, function()
		Slots[i] = HRP.Position
	end)

	btn("TP SLOT "..i, function()
		if Slots[i] then
			Char:PivotTo(CFrame.new(Slots[i]))
		end
	end)
end