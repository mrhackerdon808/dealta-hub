--====================================
-- UTILITY HUB (DELTA SAFE)
-- Manual Coord Input + Slots
-- Made by mrhackerdon
--====================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- PLAYER
local LP = Players.LocalPlayer
local Char, Hum, HRP

local function setup(c)
	Char = c
	Hum = c:WaitForChild("Humanoid")
	HRP = c:WaitForChild("HumanoidRootPart")
end
setup(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setup)

local Cam = workspace.CurrentCamera

--====================================
-- STATES
--====================================
local Fly = false
local FlySpeed = 60
local SpeedOn = false
local JumpOn = false

-- 15 SESSION SLOTS
local Slots = {}
for i = 1,15 do
	Slots[i] = {name="Slot "..i, pos=nil}
end

--====================================
-- GUI
--====================================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "UtilityHub"
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.12,0.08)
openBtn.Position = UDim2.fromScale(0.85,0.75)
openBtn.Text = "⚙"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 26
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", openBtn)

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.42,0.8)
main.Position = UDim2.fromScale(-0.65,0.1)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.08,0)
title.Text = "UTILITY HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local credit = Instance.new("TextLabel", main)
credit.Position = UDim2.new(0,0,0.08,0)
credit.Size = UDim2.new(1,0,0.05,0)
credit.Text = "Made by mrhackerdon"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0.14,0)
scroll.Size = UDim2.new(1,0,0.86,0)
scroll.CanvasSize = UDim2.new(0,0,10,0)
scroll.ScrollBarImageTransparency = 0.3
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

--====================================
-- HELPERS
--====================================
local function section(text)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.new(0.95,0,0.07,0)
	b.Text = "▼ "..text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Instance.new("UICorner", b)
	return b
end

local function button(parent,text,cb)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0.92,0,0.065,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(cb)
	return b
end

--====================================
-- LIVE COORDS + COPY
--====================================
local coord = Instance.new("TextLabel", scroll)
coord.Size = UDim2.new(0.95,0,0.07,0)
coord.BackgroundColor3 = Color3.fromRGB(30,30,30)
coord.TextColor3 = Color3.fromRGB(0,255,120)
coord.Font = Enum.Font.Gotham
coord.TextSize = 13
Instance.new("UICorner", coord)

task.spawn(function()
	while task.wait(0.1) do
		if HRP then
			local p = HRP.Position
			coord.Text = string.format("X %.1f | Y %.1f | Z %.1f",p.X,p.Y,p.Z)
		end
	end
end)

button(scroll,"COPY COORDS",function()
	if setclipboard and HRP then
		local p = HRP.Position
		setclipboard(p.X..","..p.Y..","..p.Z)
	end
end)

--====================================
-- MANUAL COORD INPUT
--====================================
local input = Instance.new("TextBox", scroll)
input.Size = UDim2.new(0.95,0,0.07,0)
input.PlaceholderText = "Paste coords: x,y,z or Vector3.new(x,y,z)"
input.Text = ""
input.Font = Enum.Font.Gotham
input.TextSize = 13
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", input)

button(scroll,"TELEPORT TO INPUT",function()
	local text = input.Text
	text = text:gsub("Vector3.new","")
	text = text:gsub("[%(%)]","")
	local x,y,z = text:match("([^,]+),([^,]+),([^,]+)")
	if x and y and z then
		Char:PivotTo(CFrame.new(tonumber(x),tonumber(y),tonumber(z)))
	end
end)

--====================================
-- MOVEMENT
--====================================
local moveSec = section("Movement")
local moveFrame = Instance.new("Frame", scroll)
moveFrame.BackgroundTransparency = 1
local ml = Instance.new("UIListLayout", moveFrame)

local openM = true
moveSec.MouseButton1Click:Connect(function()
	openM = not openM
	moveFrame.Visible = openM
	moveSec.Text = (openM and "▼ " or "▶ ").."Movement"
end)

button(moveFrame,"Fly ON / OFF",function() Fly = not Fly end)
button(moveFrame,"Fly Speed +",function() FlySpeed += 10 end)
button(moveFrame,"Fly Speed -",function() FlySpeed = math.max(20,FlySpeed-10) end)

button(moveFrame,"Speed Boost",function()
	SpeedOn = not SpeedOn
	Hum.WalkSpeed = SpeedOn and 32 or 16
end)

button(moveFrame,"Jump Boost",function()
	JumpOn = not JumpOn
	Hum.JumpPower = JumpOn and 85 or 50
end)

button(moveFrame,"Teleport +15 UP",function()
	Char:PivotTo(HRP.CFrame + Vector3.new(0,15,0))
end)

button(moveFrame,"Teleport -15 DOWN",function()
	Char:PivotTo(HRP.CFrame - Vector3.new(0,15,0))
end)

-- Fly engine
local BV,BG
RunService.RenderStepped:Connect(function()
	if Fly and HRP then
		if not BV then
			BV = Instance.new("BodyVelocity",HRP)
			BV.MaxForce = Vector3.new(1e9,1e9,1e9)
			BG = Instance.new("BodyGyro",HRP)
			BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
		end
		BG.CFrame = Cam.CFrame
		BV.Velocity = Cam.CFrame.LookVector * FlySpeed
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end)

--====================================
-- TELEPORT SLOTS (15)
--====================================
local slotSec = section("Teleport Slots")
local slotFrame = Instance.new("Frame", scroll)
slotFrame.BackgroundTransparency = 1
local sl = Instance.new("UIListLayout", slotFrame)

local openS = true
slotSec.MouseButton1Click:Connect(function()
	openS = not openS
	slotFrame.Visible = openS
	slotSec.Text = (openS and "▼ " or "▶ ").."Teleport Slots"
end)

for i=1,15 do
	button(slotFrame,"Save "..Slots[i].name,function()
		Slots[i].pos = HRP.Position
	end)

	button(slotFrame,"Teleport "..Slots[i].name,function()
		if Slots[i].pos then
			Char:PivotTo(CFrame.new(Slots[i].pos))
		end
	end)
end

--====================================
-- OPEN / CLOSE
--====================================
local open = false
local function toggle()
	open = not open
	TweenService:Create(main,TweenInfo.new(0.4,Enum.EasingStyle.Quint),
		{Position = open and UDim2.fromScale(0.05,0.1) or UDim2.fromScale(-0.65,0.1)}
	):Play()
end

openBtn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.RightShift then toggle() end
end)