--====================================
-- SIMPLE GIANT + FLY + NOCLIP (DELTA)
-- Made by mrhackerdon
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- Character
local Char, Hum, HRP
local function loadChar()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid")
	HRP = Char:WaitForChild("HumanoidRootPart")
end
loadChar()

LP.CharacterAdded:Connect(function()
	task.wait(1)
	loadChar()
end)

-- States
local GIANT = false
local NOCLIP = false
local FLY = false

local FlySpeed = 60

-- Fly physics
local BV, BG

--==============================
-- MAIN LOOP (IMPORTANT)
--==============================
RunService.RenderStepped:Connect(function()
	-- NOCLIP (REAL)
	if NOCLIP and Char then
		for _,v in ipairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end

	-- GIANT (REAPPLY)
	if GIANT and Hum and Hum.RigType == Enum.HumanoidRigType.R15 then
		for _,s in ipairs(Hum:GetChildren()) do
			if s:IsA("NumberValue") then
				s.Value = 2
			end
		end
	end

	-- FLY
	if FLY and HRP then
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

--==============================
-- UI
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3,0.4)
frame.Position = UDim2.fromScale(0.05,0.3)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function button(text, cb)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function()
		cb(b)
	end)
end

-- Buttons
button("GIANT : OFF", function(b)
	GIANT = not GIANT
	b.Text = "GIANT : "..(GIANT and "ON" or "OFF")
end)

button("NOCLIP : OFF", function(b)
	NOCLIP = not NOCLIP
	b.Text = "NOCLIP : "..(NOCLIP and "ON" or "OFF")
end)

button("FLY : OFF", function(b)
	FLY = not FLY
	b.Text = "FLY : "..(FLY and "ON" or "OFF")
end)

button("FLY SPEED +", function()
	FlySpeed += 10
end)

button("FLY SPEED -", function()
	FlySpeed = math.max(20, FlySpeed - 10)
end)