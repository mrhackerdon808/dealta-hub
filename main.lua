--=================================
-- Unified Legit Utility Hub
-- Mobile + PC | ONE SCRIPT
--=================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
local S = {
	Master = true,

	-- Fly
	Fly = false,
	FlySpeed = 60,

	-- Items
	BringItems = false,
	SelectedItem = "Wood",
	StackAmount = 10,

	-- Auto Harvest
	AutoHarvest = false,
	HarvestDistance = 7,

	-- ESP
	ItemESP = false
}

--================ ITEM CHECK =================
local function isItem(obj)
	return obj:IsA("Tool")
		or (obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") and not obj:FindFirstChild("Humanoid"))
end

--================ FLY (MOBILE SAFE) =================
local BV, BG

RunService.RenderStepped:Connect(function()
	if not S.Master or not S.Fly or not HRP then
		if BV then BV:Destroy() BV = nil end
		if BG then BG:Destroy() BG = nil end
		return
	end

	if not BV then
		BV = Instance.new("BodyVelocity", HRP)
		BV.MaxForce = Vector3.new(1e9,1e9,1e9)

		BG = Instance.new("BodyGyro", HRP)
		BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
	end

	BG.CFrame = Cam.CFrame

	if UIS.TouchEnabled or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
		BV.Velocity = Cam.CFrame.LookVector * S.FlySpeed
	else
		BV.Velocity = Vector3.zero
	end
end)

--================ BRING ITEMS (STACKED) =================
task.spawn(function()
	while task.wait(0.4) do
		if S.Master and S.BringItems and HRP then
			local count = 0
			for _, v in pairs(workspace:GetChildren()) do
				if count >= S.StackAmount then break end

				if isItem(v) and v.Name:lower():find(S.SelectedItem:lower()) then
					local part = v:IsA("Tool") and v:FindFirstChild("Handle")
						or v:FindFirstChildWhichIsA("BasePart")

					if part then
						count += 1
						part.CFrame = HRP.CFrame * CFrame.new(math.random(-4,4),2,math.random(-4,4))
					end
				end
			end
		end
	end
end)

--================ AUTO HARVEST / CHOP =================
task.spawn(function()
	while task.wait(0.3) do
		if S.Master and S.AutoHarvest and HRP then
			for _, v in pairs(workspace:GetChildren()) do
				if v:IsA("Model")
					and v.Name:lower():find("tree")
					and v:FindFirstChildWhichIsA("BasePart") then

					local part = v:FindFirstChildWhichIsA("BasePart")
					if (HRP.Position - part.Position).Magnitude <= S.HarvestDistance then
						mouse1click()
					end
				end
			end
		end
	end
end)

--================ ITEM ESP ONLY =================
local function addItemESP(item)
	if item:FindFirstChild("ItemESP") then return end

	local bb = Instance.new("BillboardGui", item)
	bb.Name = "ItemESP"
	bb.Size = UDim2.fromScale(4,1)
	bb.StudsOffset = Vector3.new(0,2,0)
	bb.AlwaysOnTop = true

	local txt = Instance.new("TextLabel", bb)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.fromRGB(0,255,0)
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold
	txt.Text = item.Name
end

task.spawn(function()
	while task.wait(1) do
		if S.ItemESP then
			for _, v in pairs(workspace:GetChildren()) do
				if isItem(v) then
					addItemESP(v)
				end
			end
		end
	end
end)

--================ GUI (MOBILE FRIENDLY) =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "UnifiedHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.26,0.75)
frame.Position = UDim2.fromScale(0.03,0.12)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function btn(text, y, cb)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.08)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.MouseButton1Click:Connect(cb)
end

btn("MASTER",0.02,function() S.Master = not S.Master end)
btn("FLY",0.12,function() S.Fly = not S.Fly end)
btn("Fly Speed +",0.22,function() S.FlySpeed += 10 end)
btn("Fly Speed -",0.30,function() S.FlySpeed = math.max(20,S.FlySpeed-10) end)

btn("Bring Items",0.40,function() S.BringItems = not S.BringItems end)
btn("Stack +5",0.48,function() S.StackAmount += 5 end)
btn("Stack -5",0.56,function() S.StackAmount = math.max(1,S.StackAmount-5) end)

btn("Select Wood",0.64,function() S.SelectedItem="Wood" end)
btn("Select Sapling",0.72,function() S.SelectedItem="Sapling" end)

btn("Auto Harvest",0.80,function() S.AutoHarvest = not S.AutoHarvest end)
btn("Item ESP",0.88,function() S.ItemESP = not S.ItemESP end)

-- Toggle UI
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then
		frame.Visible = not frame.Visible
	end
end)