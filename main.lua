--=================================
-- Legit Combat & Assist System
-- All Features | One Script
--=================================

-- Services
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
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

--================ SETTINGS =================
local Settings = {
	TargetRange = 80,
	AttackRange = 6,
	CameraAssist = true,
	AutoPath = true,
	AutoEquip = true,
	SprintSpeed = 22,
	WalkSpeed = 16,
	MaxStamina = 100,
	StaminaDrain = 25,
	StaminaRegen = 15
}

--================ STAMINA ==================
local stamina = Settings.MaxStamina
local sprinting = false

UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.LeftShift then
		sprinting = true
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.LeftShift then
		sprinting = false
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if sprinting and stamina > 0 then
		Hum.WalkSpeed = Settings.SprintSpeed
		stamina = math.max(0, stamina - Settings.StaminaDrain * dt)
	else
		Hum.WalkSpeed = Settings.WalkSpeed
		stamina = math.min(Settings.MaxStamina, stamina + Settings.StaminaRegen * dt)
	end
end)

--================ TARGETING =================
local CurrentTarget

local function isValidTarget(m)
	return m:IsA("Model")
		and m ~= Char
		and m:FindFirstChild("Humanoid")
		and m.Humanoid.Health > 0
		and m:FindFirstChild("HumanoidRootPart")
end

local function getNearestTarget()
	local best, dist = nil, Settings.TargetRange
	for _, v in pairs(workspace:GetChildren()) do
		if isValidTarget(v) then
			local d = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
			if d < dist then
				dist = d
				best = v
			end
		end
	end
	return best
end

task.spawn(function()
	while task.wait(0.5) do
		CurrentTarget = getNearestTarget()
	end
end)

--================ CAMERA ASSIST =================
RunService.RenderStepped:Connect(function()
	if Settings.CameraAssist and CurrentTarget then
		local pos = CurrentTarget.HumanoidRootPart.Position
		local camCF = Cam.CFrame
		local look = CFrame.new(camCF.Position, pos)
		Cam.CFrame = camCF:Lerp(look, 0.08)
	end
end)

--================ PATHFINDING =================
local function walkTo(pos)
	local path = PathfindingService:CreatePath()
	path:ComputeAsync(HRP.Position, pos)
	for _, wp in ipairs(path:GetWaypoints()) do
		Hum:MoveTo(wp.Position)
		Hum.MoveToFinished:Wait()
	end
end

task.spawn(function()
	while task.wait(1) do
		if Settings.AutoPath and CurrentTarget then
			local d = (HRP.Position - CurrentTarget.HumanoidRootPart.Position).Magnitude
			if d > Settings.AttackRange then
				walkTo(CurrentTarget.HumanoidRootPart.Position)
			end
		end
	end
end)

--================ AUTO EQUIP =================
local function equipTool()
	for _, t in pairs(LP.Backpack:GetChildren()) do
		if t:IsA("Tool") then
			Hum:EquipTool(t)
			return
		end
	end
end

--================ AUTO COMBAT =================
task.spawn(function()
	while task.wait(0.4) do
		if CurrentTarget then
			if Settings.AutoEquip then
				equipTool()
			end
			local d = (HRP.Position - CurrentTarget.HumanoidRootPart.Position).Magnitude
			if d <= Settings.AttackRange then
				mouse1click()
			end
		end
	end
end)

--================ ENEMY OVERLAY =================
local function addOverlay(enemy)
	if enemy:FindFirstChild("InfoGui") then return end

	local gui = Instance.new("BillboardGui", enemy)
	gui.Name = "InfoGui"
	gui.Size = UDim2.fromScale(4,1)
	gui.StudsOffset = Vector3.new(0,3,0)
	gui.AlwaysOnTop = true

	local txt = Instance.new("TextLabel", gui)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,0,0)
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold

	RunService.RenderStepped:Connect(function()
		if enemy:FindFirstChild("Humanoid") then
			local hp = math.floor(enemy.Humanoid.Health)
			local dist = math.floor((HRP.Position - enemy.HumanoidRootPart.Position).Magnitude)
			txt.Text = "HP: "..hp.." | "..dist.."m"
		end
	end)
end

task.spawn(function()
	while task.wait(1) do
		for _, v in pairs(workspace:GetChildren()) do
			if isValidTarget(v) then
				addOverlay(v)
			end
		end
	end
end)