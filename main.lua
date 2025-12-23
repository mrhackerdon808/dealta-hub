--==============================
-- DEALTA ALL IN ONE HUB (STABLE)
-- PC + MOBILE | ONE SCRIPT
--==============================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

--==============================
-- SETTINGS
--==============================
local S = {
	Fly = false,
	FlySpeed = 60,

	Speed = false,
	SpeedValue = 28,

	Jump = false,
	JumpValue = 70,

	SafeMode = true, -- anti-flag limits
	SavedCords = {} -- slots 1-5
}

--==============================
-- SAFE CLAMPS
--==============================
local function clamp()
	if S.SafeMode then
		S.FlySpeed = math.clamp(S.FlySpeed, 30, 120)
		S.SpeedValue = math.clamp(S.SpeedValue, 16, 40)
		S.JumpValue = math.clamp(S.JumpValue, 50, 90)
	end
end

--==============================
-- GUI
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "DealtaAll"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.28,0.75)
frame.Position = UDim2.fromScale(0.04,0.12)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

local function btn(text, cb)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-12,0,36)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(cb)
end

--==============================
-- FLY (WASD + MOBILE)
--==============================
local BV, BG
RunService.RenderStepped:Connect(function()
	if not S.Fly or not HRP then
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
		return
	end

	clamp()

	if not BV then
		BV = Instance.new("BodyVelocity", HRP)
		BV.MaxForce = Vector3.new(1e9,1e9,1e9)

		BG = Instance.new("BodyGyro", HRP)
		BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
	end

	BG.CFrame = Cam.CFrame

	local dir = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

	-- Mobile forward fly
	if UIS.TouchEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		dir = Cam.CFrame.LookVector
	end

	BV.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
end)

--==============================
-- SPEED / JUMP
--==============================
RunService.Heartbeat:Connect(function()
	clamp()
	Hum.WalkSpeed = S.Speed and S.SpeedValue or 16
	Hum.JumpPower = S.Jump and S.JumpValue or 50
end)

--==============================
-- TELEPORT FUNCTIONS
--==============================
local function tpOffset(v)
	if HRP then HRP.CFrame = HRP.CFrame + v end
end

--==============================
-- SAVE / TELEPORT CORDS
--==============================
local function saveSlot(slot)
	if HRP then
		S.SavedCords[slot] = HRP.CFrame
	end
end

local function loadSlot(slot)
	if S.SavedCords[slot] and HRP then
		HRP.CFrame = S.SavedCords[slot]
	end
end

--==============================
-- BUTTONS
--==============================
btn("Fly ON/OFF", function() S.Fly = not S.Fly end)
btn("Fly Speed +", function() S.FlySpeed += 10 end)
btn("Fly Speed -", function() S.FlySpeed -= 10 end)

btn("Speed ON/OFF", function() S.Speed = not S.Speed end)
btn("Speed +", function() S.SpeedValue += 4 end)
btn("Speed -", function() S.SpeedValue -= 4 end)

btn("Jump ON/OFF", function() S.Jump = not S.Jump end)

btn("TP +10 Forward", function()
	tpOffset(Cam.CFrame.LookVector * 10)
end)

btn("TP +10 Up", function() tpOffset(Vector3.new(0,10,0)) end)
btn("TP -10 Down", function() tpOffset(Vector3.new(0,-10,0)) end)

btn("Save Slot 1", function() saveSlot(1) end)
btn("TP Slot 1", function() loadSlot(1) end)

btn("Save Slot 2", function() saveSlot(2) end)
btn("TP Slot 2", function() loadSlot(2) end)

btn("Save Slot 3", function() saveSlot(3) end)
btn("TP Slot 3", function() loadSlot(3) end)

btn("Safe Mode ON/OFF", function()
	S.SafeMode = not S.SafeMode
end)

--==============================
-- TOGGLE UI
--==============================
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)