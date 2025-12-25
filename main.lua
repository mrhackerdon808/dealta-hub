--==================================================
-- PLAYER LOCK SYSTEM (MOBILE)
-- Floating Button + Manual Lock + Save Target + ESP
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- SETTINGS
local LOCK = false
local ESP_ENABLED = true
local SMOOTH = 0.2
local TARGET = nil
local SAVED_TARGET_NAME = nil

--========================
-- UI ROOT
--========================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

--========================
-- FLOATING BUTTON
--========================
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromScale(0.14, 0.08)
floatBtn.Position = UDim2.fromScale(0.8, 0.4)
floatBtn.Text = "LOCK"
floatBtn.TextScaled = true
floatBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.Active = true
floatBtn.Draggable = true

floatBtn.MouseButton1Click:Connect(function()
	LOCK = not LOCK
	floatBtn.Text = LOCK and "UNLOCK" or "LOCK"
end)

--========================
-- PLAYER LIST PANEL
--========================
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromScale(0.3, 0.5)
panel.Position = UDim2.fromScale(0.02, 0.25)
panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
panel.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", panel)
layout.Padding = UDim.new(0,5)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,35)
title.Text = "PLAYERS (TAP TO LOCK)"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

--========================
-- ESP TOGGLE BUTTON
--========================
local espBtn = Instance.new("TextButton", gui)
espBtn.Size = UDim2.fromScale(0.18,0.07)
espBtn.Position = UDim2.fromScale(0.55,0.85)
espBtn.Text = "ESP : ON"
espBtn.TextScaled = true
espBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
espBtn.TextColor3 = Color3.new(1,1,1)

espBtn.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	espBtn.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"
end)

--========================
-- PLAYER LIST LOGIC
--========================
local buttons = {}

local function refreshPlayers()
	for _,b in pairs(buttons) do b:Destroy() end
	buttons = {}

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LP then
			local btn = Instance.new("TextButton", panel)
			btn.Size = UDim2.new(1,-10,0,30)
			btn.Text = plr.Name
			btn.TextScaled = true
			btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
			btn.TextColor3 = Color3.new(1,1,1)

			btn.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("Head") then
					TARGET = plr.Character.Head
					SAVED_TARGET_NAME = plr.Name -- (5) Save target
					LOCK = true
					floatBtn.Text = "UNLOCK"
				end
			end)

			table.insert(buttons, btn)
		end
	end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

--========================
-- RESTORE SAVED TARGET
--========================
local function restoreSavedTarget()
	if not SAVED_TARGET_NAME then return end
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Name == SAVED_TARGET_NAME and plr.Character then
			TARGET = plr.Character:FindFirstChild("Head")
		end
	end
end

LP.CharacterAdded:Connect(function()
	task.wait(1)
	restoreSavedTarget()
end)

--========================
-- ESP BOX (2D)
--========================
local espBox = Drawing.new("Square")
espBox.Thickness = 2
espBox.Color = Color3.fromRGB(0,255,0)
espBox.Filled = false
espBox.Visible = false

--========================
-- MAIN LOOP
--========================
RunService.RenderStepped:Connect(function()
	-- Camera lock
	if LOCK and TARGET then
		if TARGET.Parent and TARGET.Parent:FindFirstChild("Humanoid") then
			local camPos = Camera.CFrame.Position
			local look = CFrame.new(camPos, TARGET.Position)
			Camera.CFrame = Camera.CFrame:Lerp(look, SMOOTH)
		end
	end

	-- ESP
	if ESP_ENABLED and TARGET and TARGET.Parent then
		local root = TARGET.Parent:FindFirstChild("HumanoidRootPart")
		if root then
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
			if onScreen then
				espBox.Size = Vector2.new(80,120)
				espBox.Position = Vector2.new(pos.X-40, pos.Y-60)
				espBox.Visible = true
			else
				espBox.Visible = false
			end
		end
	else
		espBox.Visible = false
	end
end)