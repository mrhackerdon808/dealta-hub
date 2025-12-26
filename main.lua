--==================================================
-- ALL IN ONE : MOBILE UI + CAMERA + ATTACK + ESP + NOCLIP
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- PLAYER
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- STATES
local CAM_LOCK = false
local AUTO_ATTACK = false
local ESP_ON = false
local NOCLIP = false
local UI_VISIBLE = true

-- TARGET
local TARGET_HEAD
local TARGET_ROOT
local TARGET_HUM

-- SETTINGS
local ATTACK_RANGE = 8
local SMOOTH = 0.25
local COOLDOWN = 0.25
local lastAttack = 0

--==================================================
-- MOBILE UI (SMALL)
--==================================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.26,0.32)
frame.Position = UDim2.fromScale(0.03,0.32)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local function makeBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0.18,0)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local espBtn   = makeBtn("ESP : OFF",    0.04)
local atkBtn   = makeBtn("ATTACK : OFF", 0.24)
local camBtn   = makeBtn("CAMERA : OFF", 0.44)
local nocBtn   = makeBtn("NOCLIP : OFF", 0.64)
local hideBtn  = makeBtn("HIDE UI",      0.84)

--==================================================
-- ESP
--==================================================
local espBox
local function updateESP()
	if espBox then espBox:Destroy() espBox=nil end
	if ESP_ON and TARGET_ROOT then
		espBox = Instance.new("BoxHandleAdornment")
		espBox.Adornee = TARGET_ROOT
		espBox.Size = Vector3.new(4,6,2)
		espBox.Color3 = Color3.fromRGB(0,255,0)
		espBox.Transparency = 0.6
		espBox.AlwaysOnTop = true
		espBox.Parent = Camera
	end
end

--==================================================
-- GET CLOSEST TARGET
--==================================================
local function getClosest()
	local closest, dist = nil, math.huge
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			local r = p.Character:FindFirstChild("HumanoidRootPart")
			local hd = p.Character:FindFirstChild("Head")
			if h and r and hd and h.Health > 0 then
				local d = (hrp.Position - r.Position).Magnitude
				if d < dist then
					dist = d
					closest = p
				end
			end
		end
	end
	return closest
end

--==================================================
-- BUTTONS
--==================================================
espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = "ESP : "..(ESP_ON and "ON" or "OFF")
	updateESP()
end)

atkBtn.MouseButton1Click:Connect(function()
	AUTO_ATTACK = not AUTO_ATTACK
	atkBtn.Text = "ATTACK : "..(AUTO_ATTACK and "ON" or "OFF")
end)

camBtn.MouseButton1Click:Connect(function()
	CAM_LOCK = not CAM_LOCK
	camBtn.Text = "CAMERA : "..(CAM_LOCK and "ON" or "OFF")
end)

nocBtn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	nocBtn.Text = "NOCLIP : "..(NOCLIP and "ON" or "OFF")
end)

hideBtn.MouseButton1Click:Connect(function()
	UI_VISIBLE = not UI_VISIBLE
	frame.Visible = UI_VISIBLE
end)

--==================================================
-- MAIN LOOP
--==================================================
RunService.RenderStepped:Connect(function()
	-- NOCLIP
	if NOCLIP then
		local char = LP.Character
		if char then
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end

	-- TARGET
	local target = getClosest()
	if target and target.Character then
		TARGET_HEAD = target.Character:FindFirstChild("Head")
		TARGET_ROOT = target.Character:FindFirstChild("HumanoidRootPart")
		TARGET_HUM  = target.Character:FindFirstChildOfClass("Humanoid")
		updateESP()
	end

	-- CAMERA LOCK
	if CAM_LOCK and TARGET_HEAD then
		local camPos = Camera.CFrame.Position
		Camera.CFrame = Camera.CFrame:Lerp(
			CFrame.new(camPos, TARGET_HEAD.Position),
			SMOOTH
		)
	end

	-- AUTO ATTACK
	if AUTO_ATTACK and TARGET_ROOT then
		local char = LP.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if tool and hrp then
			if (hrp.Position - TARGET_ROOT.Position).Magnitude <= ATTACK_RANGE then
				if tick() - lastAttack >= COOLDOWN then
					lastAttack = tick()
					tool:Activate()
				end
			end
		end
	end
end)