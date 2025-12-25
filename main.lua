--==================================================
-- ALL IN ONE: HEAD LOCK + AUTO ATTACK (LEGIT)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- SETTINGS
local LOCKED = false
local TARGET_HEAD = nil
local TARGET_HUM = nil
local ATTACK_RANGE = 8
local SMOOTH = 0.18

--==================================================
-- UI ROOT
--==================================================
local gui = Instance.new("ScreenGui")
gui.Parent = LP.PlayerGui
gui.ResetOnSpawn = false

--========================
-- MAIN PANEL
--========================
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromScale(0.32, 0.45)
panel.Position = UDim2.fromScale(0.03, 0.25)
panel.BackgroundColor3 = Color3.fromRGB(18,18,18)
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,40)
title.Text = "TARGET LOCK"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

local listLayout = Instance.new("UIListLayout", panel)
listLayout.Padding = UDim.new(0,6)
listLayout.HorizontalAlignment = Center

--========================
-- FLOATING LOCK BUTTON
--========================
local lockBtn = Instance.new("TextButton", gui)
lockBtn.Size = UDim2.fromScale(0.18,0.075)
lockBtn.Position = UDim2.fromScale(0.75,0.82)
lockBtn.Text = "LOCK"
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextScaled = true
lockBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
lockBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1,0)

lockBtn.MouseButton1Click:Connect(function()
	LOCKED = not LOCKED
	lockBtn.Text = LOCKED and "UNLOCK" or "LOCK"
	lockBtn.BackgroundColor3 = LOCKED
		and Color3.fromRGB(70,140,70)
		or Color3.fromRGB(45,45,45)
end)

--========================
-- RESET LOCK FUNCTION
--========================
local function resetLock()
	LOCKED = false
	TARGET_HEAD = nil
	TARGET_HUM = nil
	lockBtn.Text = "LOCK"
	lockBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
end

--========================
-- PLAYER LIST
--========================
local buttons = {}

local function refreshPlayers()
	for _,b in pairs(buttons) do b:Destroy() end
	buttons = {}

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP then
			local btn = Instance.new("TextButton", panel)
			btn.Size = UDim2.new(0.9,0,0,34)
			btn.Text = plr.Name
			btn.Font = Enum.Font.Gotham
			btn.TextScaled = true
			btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
			btn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

			btn.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("Head") then
					TARGET_HEAD = plr.Character.Head
					TARGET_HUM = plr.Character:FindFirstChild("Humanoid")
					LOCKED = true
					lockBtn.Text = "UNLOCK"
					lockBtn.BackgroundColor3 = Color3.fromRGB(70,140,70)

					-- Auto unlock on death
					if TARGET_HUM then
						TARGET_HUM.Died:Connect(resetLock)
					end
				end
			end)

			table.insert(buttons, btn)
		end
	end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function(plr)
	if TARGET_HEAD and TARGET_HEAD.Parent
	and TARGET_HEAD.Parent.Name == plr.Name then
		resetLock()
	end
	refreshPlayers()
end)

refreshPlayers()

--========================
-- MAIN LOOP
--========================
RunService.RenderStepped:Connect(function()
	if not LOCKED or not TARGET_HEAD or not TARGET_HEAD.Parent then
		return
	end

	-- Auto unlock safety
	if not TARGET_HUM or TARGET_HUM.Health <= 0 then
		resetLock()
		return
	end

	-- Camera lock on HEAD
	local camPos = Camera.CFrame.Position
	local lookAt = CFrame.new(camPos, TARGET_HEAD.Position)
	Camera.CFrame = Camera.CFrame:Lerp(lookAt, SMOOTH)

	-- Legit auto attack (tool activate only)
	local char = LP.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local targetRoot = TARGET_HEAD.Parent:FindFirstChild("HumanoidRootPart")

	if tool and hrp and targetRoot then
		local dist = (hrp.Position - targetRoot.Position).Magnitude
		if dist <= ATTACK_RANGE then
			tool:Activate()
		end
	end
end)