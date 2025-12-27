--====================================
-- GIANT AVATAR + FLY HUB
-- DELTA SAFE | R15 ONLY
-- Made by mrhackerdon
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

--==============================
-- CHARACTER
--==============================
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
	applyGiant()
end)

--==============================
-- STATES
--==============================
local Giant = false
local Fly = false
local NoClip = false

local FlySpeed = 80
local WalkSpeed = 32

--==============================
-- GIANT AVATAR
--==============================
function applyGiant()
	if Hum.RigType ~= Enum.HumanoidRigType.R15 then return end

	local function set(name, val)
		local s = Hum:FindFirstChild(name)
		if s then s.Value = val end
	end

	if Giant then
		set("BodyHeightScale", 2)
		set("BodyWidthScale", 1.5)
		set("BodyDepthScale", 1.5)
		set("HeadScale", 1.3)
	else
		set("BodyHeightScale", 1)
		set("BodyWidthScale", 1)
		set("BodyDepthScale", 1)
		set("HeadScale", 1)
	end
end

--==============================
-- FLY SYSTEM
--==============================
local BV, BG

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

	if NoClip and Char then
		for _,v in pairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--==============================
-- UI
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32,0.55)
frame.Position = UDim2.fromScale(0.04,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function btn(text, cb)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,36)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(function()
		cb(b)
	end)
end

--==============================
-- BUTTONS
--==============================

btn("GIANT : OFF", function(b)
	Giant = not Giant
	b.Text = "GIANT : "..(Giant and "ON" or "OFF")
	applyGiant()
end)

btn("FLY : OFF", function(b)
	Fly = not Fly
	b.Text = "FLY : "..(Fly and "ON" or "OFF")
end)

btn("FLY SPEED +10", function()
	FlySpeed += 10
end)

btn("FLY SPEED -10", function()
	FlySpeed = math.max(20, FlySpeed - 10)
end)

btn("SPEED BOOST", function()
	Hum.WalkSpeed = WalkSpeed
end)

btn("SPEED +5", function()
	WalkSpeed += 5
	Hum.WalkSpeed = WalkSpeed
end)

btn("SPEED -5", function()
	WalkSpeed = math.max(16, WalkSpeed - 5)
	Hum.WalkSpeed = WalkSpeed
end)

btn("NOCLIP : OFF", function(b)
	NoClip = not NoClip
	b.Text = "NOCLIP : "..(NoClip and "ON" or "OFF")
end)