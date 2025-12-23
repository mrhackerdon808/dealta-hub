--====================================
-- DEALTA HUB V3 (OLD UI RESTORED)
-- ALL IN ONE | PC + MOBILE
--====================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

player.CharacterAdded:Connect(function(c)
	char = c
	hum = c:WaitForChild("Humanoid")
	hrp = c:WaitForChild("HumanoidRootPart")
end)

--====================================
-- SETTINGS
--====================================
local S = {
	Fly = false,
	FlySpeed = 60,

	Speed = false,
	SpeedValue = 28,

	Jump = false,
	JumpValue = 70,

	Saved = {}
}

--====================================
-- GUI (OLD STYLE)
--====================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DealtaV3"
gui.ResetOnSpawn = false

-- OPEN BUTTON
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.12,0.08)
openBtn.Position = UDim2.fromScale(0.85,0.75)
openBtn.Text = "⚡"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 26
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.32,0.62)
main.Position = UDim2.fromScale(-0.4,0.2)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- GRADIENT
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120,0,255))
}

RS.RenderStepped:Connect(function()
	grad.Rotation += 0.1
end)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "DEALTA HUB V3"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--====================================
-- BUTTON MAKER
--====================================
local function makeBtn(text)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.9,0,0.08,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

--====================================
-- BUTTONS
--====================================
local flyBtn = makeBtn("Fly : OFF")
local flyP = makeBtn("Fly Speed +")
local flyM = makeBtn("Fly Speed -")

local speedBtn = makeBtn("Speed : OFF")
local speedP = makeBtn("Speed +")
local speedM = makeBtn("Speed -")

local jumpBtn = makeBtn("Jump : OFF")

local tpF = makeBtn("TP +10 Forward")
local tpU = makeBtn("TP +10 Up")
local tpD = makeBtn("TP -10 Down")

local save1 = makeBtn("Save Slot 1")
local tp1 = makeBtn("TP Slot 1")
local save2 = makeBtn("Save Slot 2")
local tp2 = makeBtn("TP Slot 2")
local save3 = makeBtn("Save Slot 3")
local tp3 = makeBtn("TP Slot 3")

--====================================
-- FLY
--====================================
local bv, bg
RS.RenderStepped:Connect(function()
	if not S.Fly then
		if bv then bv:Destroy() bv=nil end
		if bg then bg:Destroy() bg=nil end
		return
	end

	if not bv then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e9,1e9,1e9)
		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
	end

	bg.CFrame = cam.CFrame

	local dir = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

	if UIS.TouchEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		dir = cam.CFrame.LookVector
	end

	bv.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
end)

flyBtn.MouseButton1Click:Connect(function()
	S.Fly = not S.Fly
	flyBtn.Text = "Fly : "..(S.Fly and "ON" or "OFF")
end)

flyP.MouseButton1Click:Connect(function() S.FlySpeed += 10 end)
flyM.MouseButton1Click:Connect(function() S.FlySpeed = math.max(20,S.FlySpeed-10) end)

--====================================
-- SPEED / JUMP
--====================================
speedBtn.MouseButton1Click:Connect(function()
	S.Speed = not S.Speed
	speedBtn.Text = "Speed : "..(S.Speed and "ON" or "OFF")
end)

speedP.MouseButton1Click:Connect(function() S.SpeedValue += 4 end)
speedM.MouseButton1Click:Connect(function() S.SpeedValue = math.max(16,S.SpeedValue-4) end)

jumpBtn.MouseButton1Click:Connect(function()
	S.Jump = not S.Jump
	jumpBtn.Text = "Jump : "..(S.Jump and "ON" or "OFF")
end)

RS.Heartbeat:Connect(function()
	hum.WalkSpeed = S.Speed and S.SpeedValue or 16
	hum.JumpPower = S.Jump and S.JumpValue or 50
end)

--====================================
-- TELEPORT
--====================================
tpF.MouseButton1Click:Connect(function()
	hrp.CFrame += cam.CFrame.LookVector * 10
end)

tpU.MouseButton1Click:Connect(function()
	hrp.CFrame += Vector3.new(0,10,0)
end)

tpD.MouseButton1Click:Connect(function()
	hrp.CFrame -= Vector3.new(0,10,0)
end)

local function save(slot) S.Saved[slot] = hrp.CFrame end
local function load(slot) if S.Saved[slot] then hrp.CFrame = S.Saved[slot] end end

save1.MouseButton1Click:Connect(function() save(1) end)
tp1.MouseButton1Click:Connect(function() load(1) end)
save2.MouseButton1Click:Connect(function() save(2) end)
tp2.MouseButton1Click:Connect(function() load(2) end)
save3.MouseButton1Click:Connect(function() save(3) end)
tp3.MouseButton1Click:Connect(function() load(3) end)

--====================================
-- OPEN / CLOSE
--====================================
local open = false
openBtn.MouseButton1Click:Connect(function()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.4,Enum.EasingStyle.Quint),
		{Position = open and UDim2.fromScale(0.05,0.2) or UDim2.fromScale(-0.4,0.2)}
	):Play()
end)