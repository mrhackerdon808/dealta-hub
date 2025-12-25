--==================================================
-- ALL IN ONE: HEAD LOCK + AUTO ATTACK + ESP + NOCLIP
-- LEGIT | DELTA SAFE | SINGLE SCRIPT
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- PLAYER
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- STATES
local LOCKED = false
local AUTO_ATTACK = false
local ESP_ON = false
local NOCLIP = false

-- TARGET
local TARGET_HEAD = nil
local TARGET_HUM = nil
local TARGET_ROOT = nil

-- SETTINGS
local ATTACK_RANGE = 8
local SMOOTH = 0.18
local ATTACK_COOLDOWN = 0.25
local lastAttack = 0

--==================================================
-- UI
--==================================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromScale(0.34, 0.48)
panel.Position = UDim2.fromScale(0.03, 0.25)
panel.BackgroundColor3 = Color3.fromRGB(18,18,18)
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,40)
title.Text = "TARGET CONTROL HUB"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

--========================
-- TOGGLE BAR
--========================
local toggles = Instance.new("Frame", panel)
toggles.Position = UDim2.new(0,0,0,40)
toggles.Size = UDim2.new(1,0,0,42)
toggles.BackgroundTransparency = 1

local tl = Instance.new("UIListLayout", toggles)
tl.FillDirection = Enum.FillDirection.Horizontal
tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
tl.Padding = UDim.new(0,6)

local function toggleBtn(text)
	local b = Instance.new("TextButton", toggles)
	b.Size = UDim2.new(0.22,0,1,-6)
	b.Text = text.." : OFF"
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local lockBtn   = toggleBtn("LOCK")
local atkBtn    = toggleBtn("ATTACK")
local espBtn    = toggleBtn("ESP")
local noclipBtn = toggleBtn("NOCLIP")

--========================
-- PLAYER LIST
--========================
local list = Instance.new("ScrollingFrame", panel)
list.Position = UDim2.new(0,0,0,82)
list.Size = UDim2.new(1,0,1,-82)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ScrollBarImageTransparency = 0.4
list.BackgroundTransparency = 1

local ll = Instance.new("UIListLayout", list)
ll.Padding = UDim.new(0,6)
ll.HorizontalAlignment = Enum.HorizontalAlignment.Center

local buttons = {}

--========================
-- ESP
--========================
local espBox

local function updateESP()
	if espBox then espBox:Destroy() espBox = nil end
	if ESP_ON and TARGET_ROOT then
		espBox = Instance.new("BoxHandleAdornment")
		espBox.Size = Vector3.new(4,6,2)
		espBox.Color3 = Color3.fromRGB(0,255,0)
		espBox.Transparency = 0.6
		espBox.AlwaysOnTop = true
		espBox.Adornee = TARGET_ROOT
		espBox.Parent = Camera
	end
end

--========================
-- RESET
--========================
local function resetTarget()
	LOCKED = false
	AUTO_ATTACK = false
	TARGET_HEAD = nil
	TARGET_HUM = nil
	TARGET_ROOT = nil
	updateESP()

	lockBtn.Text = "LOCK : OFF"
	atkBtn.Text  = "ATTACK : OFF"
	lockBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	atkBtn.BackgroundColor3  = Color3.fromRGB(45,45,45)
end

--========================
-- TOGGLES
--========================
lockBtn.MouseButton1Click:Connect(function()
	LOCKED = not LOCKED
	lockBtn.Text = "LOCK : "..(LOCKED and "ON" or "OFF")
	lockBtn.BackgroundColor3 = LOCKED and Color3.fromRGB(70,140,70) or Color3.fromRGB(45,45,45)
	if not LOCKED then resetTarget() end
end)

atkBtn.MouseButton1Click:Connect(function()
	AUTO_ATTACK = not AUTO_ATTACK
	atkBtn.Text = "ATTACK : "..(AUTO_ATTACK and "ON" or "OFF")
	atkBtn.BackgroundColor3 = AUTO_ATTACK and Color3.fromRGB(140,70,70) or Color3.fromRGB(45,45,45)
end)

espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = "ESP : "..(ESP_ON and "ON" or "OFF")
	espBtn.BackgroundColor3 = ESP_ON and Color3.fromRGB(70,110,140) or Color3.fromRGB(45,45,45)
	updateESP()
end)

noclipBtn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	noclipBtn.Text = "NOCLIP : "..(NOCLIP and "ON" or "OFF")
	noclipBtn.BackgroundColor3 = NOCLIP and Color3.fromRGB(140,140,70) or Color3.fromRGB(45,45,45)
end)

--========================
-- PLAYER LIST
--========================
local function refreshPlayers()
	for _,b in pairs(buttons) do b:Destroy() end
	buttons = {}

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP then
			local b = Instance.new("TextButton", list)
			b.Size = UDim2.new(0.9,0,0,34)
			b.Text = plr.Name
			b.Font = Enum.Font.Gotham
			b.TextScaled = true
			b.BackgroundColor3 = Color3.fromRGB(30,30,30)
			b.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

			b.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("Head") then
					TARGET_HEAD = plr.Character.Head
					TARGET_HUM = plr.Character:FindFirstChild("Humanoid")
					TARGET_ROOT = plr.Character:FindFirstChild("HumanoidRootPart")
					LOCKED = true
					lockBtn.Text = "LOCK : ON"
					lockBtn.BackgroundColor3 = Color3.fromRGB(70,140,70)
					updateESP()
					if TARGET_HUM then
						TARGET_HUM.Died:Connect(resetTarget)
					end
				end
			end)

			table.insert(buttons, b)
		end
	end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

--========================
-- NOCLIP FUNCTION
--========================
local function applyNoClip()
	if not NOCLIP then return end
	local char = LP.Character
	if not char then return end
	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
end

--========================
-- MAIN LOOP
--========================
RunService.RenderStepped:Connect(function()
	applyNoClip()

	if not LOCKED or not TARGET_HEAD then return end
	if not TARGET_HUM or TARGET_HUM.Health <= 0 then
		resetTarget()
		return
	end

	-- Camera lock
	local camPos = Camera.CFrame.Position
	Camera.CFrame = Camera.CFrame:Lerp(
		CFrame.new(camPos, TARGET_HEAD.Position),
		SMOOTH
	)

	-- Auto attack
	if AUTO_ATTACK then
		local char = LP.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if tool and hrp and TARGET_ROOT then
			local dist = (hrp.Position - TARGET_ROOT.Position).Magnitude
			if dist <= ATTACK_RANGE and tick() - lastAttack >= ATTACK_COOLDOWN then
				lastAttack = tick()
				tool:Activate()
			end
		end
	end
end)