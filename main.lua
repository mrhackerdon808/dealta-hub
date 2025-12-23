--=================================
-- Dealta Hub | ALL-IN-ONE (Mobile)
-- CAMERA LOCK REMOVED
--=================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Char, Hum, HRP

local function setup(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end
setup(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setup)

--================ SETTINGS =================
local S = {
	Master = true,

	AutoTarget = true,
	AutoAttack = true,
	AutoEquip = true,

	KillAura = false,
	AuraRange = 15,

	BringAll = false,
	AutoCollect = false,

	Fly = false,
	Speed = false,
	Jump = false,
	Noclip = false,

	TargetRange = 80,
	AttackRange = 6,
	WalkSpeed = 60,
	JumpPower = 120,
	FlySpeed = 70
}

--================ UTILS =================
local function validEnemy(m)
	return m:IsA("Model")
	and m ~= Char
	and m:FindFirstChild("Humanoid")
	and m.Humanoid.Health > 0
	and m:FindFirstChild("HumanoidRootPart")
end

local function nearestEnemy(range)
	local best, dist = nil, range or math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if validEnemy(v) then
			local d = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				best = v
			end
		end
	end
	return best
end

local function equipTool()
	for _, t in pairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") then
			Hum:EquipTool(t)
			return
		end
	end
end

--================ TARGET =================
local CurrentTarget
task.spawn(function()
	while task.wait(0.5) do
		if S.Master and S.AutoTarget then
			CurrentTarget = nearestEnemy(S.TargetRange)
		else
			CurrentTarget = nil
		end
	end
end)

--================ AUTO ATTACK =================
task.spawn(function()
	while task.wait(0.3) do
		if S.Master and S.AutoAttack and CurrentTarget then
			if (HRP.Position - CurrentTarget.HumanoidRootPart.Position).Magnitude <= S.AttackRange then
				if S.AutoEquip then equipTool() end
				mouse1click()
			end
		end
	end
end)

--================ KILL AURA =================
task.spawn(function()
	while task.wait(0.2) do
		if S.Master and S.KillAura then
			for _, v in pairs(workspace:GetDescendants()) do
				if validEnemy(v) and (HRP.Position - v.HumanoidRootPart.Position).Magnitude <= S.AuraRange then
					mouse1click()
				end
			end
		end
	end
end)

--================ BRING ALL =================
task.spawn(function()
	while task.wait(0.4) do
		if S.Master and S.BringAll then
			for _, v in pairs(workspace:GetDescendants()) do
				if validEnemy(v) then
					v.HumanoidRootPart.CFrame = HRP.CFrame * CFrame.new(0,0,-4)
				end
			end
		end
	end
end)

--================ AUTO COLLECT =================
task.spawn(function()
	while task.wait(1) do
		if S.Master and S.AutoCollect then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("TouchTransmitter") then
					firetouchinterest(HRP, v.Parent, 0)
					firetouchinterest(HRP, v.Parent, 1)
				end
			end
		end
	end
end)

--================ FLY =================
local BV, BG
RunService.RenderStepped:Connect(function()
	if S.Master and S.Fly then
		if not BV then
			BV = Instance.new("BodyVelocity", HRP)
			BV.MaxForce = Vector3.new(1e9,1e9,1e9)
			BG = Instance.new("BodyGyro", HRP)
			BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
		end

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end

		BV.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
		BG.CFrame = cam.CFrame
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end)

--================ SPEED / JUMP =================
task.spawn(function()
	while task.wait(0.3) do
		if Hum then
			Hum.WalkSpeed = S.Speed and S.WalkSpeed or 16
			Hum.JumpPower = S.Jump and S.JumpPower or 50
		end
	end
end)

--================ NOCLIP =================
RunService.Stepped:Connect(function()
	if S.Master and S.Noclip then
		for _, v in pairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

--================ ANTI AFK =================
LP.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

--================ MOBILE GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.28, 0.8)
frame.Position = UDim2.fromScale(0.02, 0.12)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local minimized = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.fromScale(0.12, 0.06)
toggleBtn.Position = UDim2.fromScale(0.02, 0.03)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Text = "☰ MENU"

toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	frame.Visible = not minimized
	toggleBtn.Text = minimized and "☰ OPEN" or "☰ MENU"
end)

if UIS.TouchEnabled then
	minimized = true
	frame.Visible = false
	toggleBtn.Text = "☰ OPEN"
end

local function button(txt, y, key)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9, 0.06)
	b.Position = UDim2.fromScale(0.05, y)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Text = txt .. ": ON"
	b.MouseButton1Click:Connect(function()
		S[key] = not S[key]
		b.Text = txt .. ": " .. (S[key] and "ON" or "OFF")
	end)
end

local y = 0.02
for _, v in ipairs({
	{"Master","Master"},
	{"Auto Attack","AutoAttack"},
	{"Kill Aura","KillAura"},
	{"Bring All","BringAll"},
	{"Auto Collect","AutoCollect"},
	{"Fly","Fly"},
	{"Speed","Speed"},
	{"Jump","Jump"},
	{"Noclip","Noclip"},
}) do
	button(v[1], y, v[2])
	y += 0.065
end