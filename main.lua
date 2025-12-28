--====================================
-- LONG LEGS AVATAR (DELTA SAFE)
-- By mrhackerdon
--====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Char, Hum

local function setup()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid")

	-- Fix camera (no shake)
	Camera.CameraSubject = Hum
	Camera.CameraType = Enum.CameraType.Custom

	-- R15 required
	if Hum.RigType ~= Enum.HumanoidRigType.R15 then
		warn("R15 avatar required")
		return
	end
end

setup()
LP.CharacterAdded:Connect(function()
	task.wait(1)
	setup()
end)

-- 🔧 SETTINGS
local LEG_SCALE = 3.5        -- increase for longer legs (max ~5)
local CAMERA_OFFSET = 8      -- camera height

RunService.RenderStepped:Connect(function()
	if not Hum then return end

	-- Long legs only
	Hum.BodyHeightScale.Value = LEG_SCALE
	Hum.BodyDepthScale.Value = 1
	Hum.BodyWidthScale.Value = 1
	Hum.HeadScale.Value = 1

	-- Balance body
	Hum.HipHeight = LEG_SCALE * 1.4

	-- Stable camera
	Camera.CameraOffset = Vector3.new(0, CAMERA_OFFSET, 0)
end)