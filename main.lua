--==============================
-- LEGIT PLAYER UTILITY HUB
-- ALL IN ONE | DELTA SAFE
-- Made by mrhackerdon
--==============================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- PLAYER
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local Char, Hum, HRP

local function setup(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end

setup(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setup)

-- SETTINGS
local MAX = 500
local FlySpeed = 100
local WalkSpeed = 32

-- STATES
local Fly = false
local Speed = false
local NoClip = false
local ShowCoords = false
local ESP = false
local CamLock = false

-- TARGET (TEMP ONLY)
local TargetHead = nil
local TargetHum = nil

-- SLOTS (COORDS ONLY)
local Slots = {}
for i = 1,5 do Slots[i] = nil end

--==============================
-- COORD DISPLAY
--==============================
local coordGui = Instance.new("ScreenGui", LP.PlayerGui)
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

--==============================
-- MAIN UI
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
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
main.Size = UDim2.new(0.28,0,0.65,0)
main.Position = UDim2.new(-0.35,0,0.18,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.07,0)
title.Text = "UTILITY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0.07,0)
scroll.Size = UDim2.new(1,0,0.93,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarImageTransparency = 0.4
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function btn(text, cb)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(0.92,0,0.055,0)
	b.Text = text
	b.TextSize = 12
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	b.MouseButton1Click:Connect(function() cb(b) end)
	return b
end

--==============================
-- FEATURES
--==============================

btn("SHOW COORDS", function()
	ShowCoords = not ShowCoords
	coord.Visible = ShowCoords
end)

-- FLY
local bv,bg
btn("FLY : OFF", function(b)
	Fly = not Fly
	b.Text = "FLY : "..(Fly and "ON" or "OFF")
	if not Fly then
		if bv then bv:Destroy() bv=nil end
		if bg then bg:Destroy() bg=nil end
	end
end)

btn("FLY SPEED +", function() FlySpeed = math.clamp(FlySpeed+10,0,MAX) end)
btn("FLY SPEED -", function() FlySpeed = math.clamp(FlySpeed-10,0,MAX) end)

-- SPEED
btn("SPEED : OFF", function(b)
	Speed = not Speed
	b.Text = "SPEED : "..(Speed and "ON" or "OFF")
	Hum.WalkSpeed = Speed and WalkSpeed or 16
end)

-- NOCLIP
btn("NOCLIP", function()
	NoClip = not NoClip
end)

-- ESP
local ESPBoxes = {}
btn("ESP BOX : OFF", function(b)
	ESP = not ESP
	b.Text = "ESP BOX : "..(ESP and "ON" or "OFF")
	if not ESP then
		for _,v in pairs(ESPBoxes) do if v then v:Destroy() end end
		ESPBoxes = {}
	end
end)

-- CAMERA LOCK
btn("CAM LOCK : OFF", function(b)
	CamLock = not CamLock
	b.Text = "CAM LOCK : "..(CamLock and "ON" or "OFF")
	if not CamLock then
		TargetHead = nil
		TargetHum = nil
	end
end)

-- PLAYER SELECT (TEMP TARGET)
btn("SELECT PLAYER", function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
			btn("LOCK "..plr.Name, function()
				TargetHead = plr.Character.Head
				TargetHum = plr.Character:FindFirstChild("Humanoid")
				CamLock = true
			end)
		end
	end
end)

-- TELEPORT SLOTS (COORDS ONLY)
for i=1,5 do
	btn("SAVE SLOT "..i, function()
		Slots[i] = HRP.CFrame
	end)
	btn("TP SLOT "..i, function()
		if Slots[i] then HRP.CFrame = Slots[i] end
	end)
end

--==============================
-- TARGET ARROW
--==============================
local arrowGui = Instance.new("ScreenGui", LP.PlayerGui)
arrowGui.ResetOnSpawn = false

local arrow = Instance.new("ImageLabel", arrowGui)
arrow.Size = UDim2.new(0,40,0,40)
arrow.BackgroundTransparency = 1
arrow.Image = "rbxassetid://7072718367"
arrow.Visible = false

--==============================
-- UPDATE LOOP
--==============================
RunService.RenderStepped:Connect(function()
	-- COORDS
	if ShowCoords and HRP then
		local p = HRP.Position
		coord.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", p.X, p.Y, p.Z)
	end

	-- FLY
	if Fly and HRP then
		if not bv then
			bv = Instance.new("BodyVelocity", HRP)
			bv.MaxForce = Vector3.new(1e9,1e9,1e9)
			bg = Instance.new("BodyGyro", HRP)
			bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
		end
		bv.Velocity = Cam.CFrame.LookVector * FlySpeed
		bg.CFrame = Cam.CFrame
	end

	-- NOCLIP
	if NoClip and Char then
		for _,v in ipairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end

	-- ESP
	if ESP then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if not ESPBoxes[plr] then
					local box = Instance.new("BoxHandleAdornment")
					box.Size = Vector3.new(4,6,2)
					box.Color3 = Color3.fromRGB(0,255,0)
					box.Transparency = 0.6
					box.AlwaysOnTop = true
					box.Adornee = plr.Character.HumanoidRootPart
					box.Parent = Cam
					ESPBoxes[plr] = box
				end
			end
		end
	end

	-- CAMERA LOCK + ARROW
	if CamLock and TargetHead then
		Cam.CFrame = CFrame.new(Cam.CFrame.Position, TargetHead.Position)
		arrow.Visible = true
		local pos, onScreen = Cam:WorldToViewportPoint(TargetHead.Position)
		if onScreen then
			arrow.Position = UDim2.new(0,pos.X-20,0,pos.Y-20)
			arrow.Rotation = 0
		else
			local center = Cam.ViewportSize/2
			local dir = (Vector2.new(pos.X,pos.Y)-center).Unit
			arrow.Position = UDim2.new(0.5+dir.X*0.4,-20,0.5+dir.Y*0.4,-20)
			arrow.Rotation = math.deg(math.atan2(dir.Y,dir.X))
		end
	else
		arrow.Visible = false
	end
end)

-- OPEN / CLOSE
local open=false
openBtn.MouseButton1Click:Connect(function()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.3),
	{Position = open and UDim2.new(0.04,0,0.18,0) or UDim2.new(-0.35,0,0.18,0)}
	):Play()
end)