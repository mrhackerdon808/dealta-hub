--====================================
-- ULTRA BIG AVATAR (DELTA SAFE)
-- By mrhackerdon
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Char, Hum, HRP

local function setup()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid")
	HRP = Char:WaitForChild("HumanoidRootPart")
end

setup()
LP.CharacterAdded:Connect(function()
	task.wait(1)
	setup()
end)

-- 🔥 BIG SETTINGS
local SIZE_MULTIPLIER = 3.5   -- BIGGER (try 4 or 5)
local CAM_HEIGHT = 14         -- camera height boost

RunService.RenderStepped:Connect(function()
	if not Char or not HRP or not Hum then return end

	-- Massive height feel
	Hum.HipHeight = 2 * SIZE_MULTIPLIER

	-- Extra camera height
	Camera.CFrame = Camera.CFrame + Vector3.new(0, CAM_HEIGHT * 0.02, 0)
end)