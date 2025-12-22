-- =================================
-- Dealta Style Auto Farm Hub
-- =================================

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

-- Update character on respawn
LP.CharacterAdded:Connect(function(char)
    Character = char
end)

-- =========================
-- CONFIG
-- =========================
local Settings = {
    AutoFarm = false,
    AutoCollect = false,
    TweenSpeed = 0.25,
    DistanceFromEnemy = 3
}

-- =========================
-- UTILS
-- =========================
local function getHRP(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Tween teleport
local function tweenTo(cf)
    if not getHRP(Character) then return end
    TweenService:Create(
        Character.HumanoidRootPart,
        TweenInfo.new(Settings.TweenSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    ):Play()
end

-- Find nearest enemy
local function getNearestEnemy()
    local closest, dist = nil, math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model")
        and v ~= Character
        and v:FindFirstChild("Humanoid")
        and v.Humanoid.Health > 0
        and v:FindFirstChild("HumanoidRootPart") then

            local d = (Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    return closest
end

-- =========================
-- AUTO FARM
-- =========================
task.spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm and getHRP(Character) then
            local enemy = getNearestEnemy()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                tweenTo(enemy.HumanoidRootPart.CFrame * CFrame.new(0,0,-Settings.DistanceFromEnemy))
                mouse1click()
            end
        end
    end
end)

-- =========================
-- AUTO COLLECT
-- =========================
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoCollect and getHRP(Character) then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") then
                    firetouchinterest(Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
    end
end)

-- =========================
-- ANTI AFK
-- =========================
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- =========================
-- GUI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "DealtaHub"
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.2, 0.25)
frame.Position = UDim2.fromScale(0.05, 0.3)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function makeButton(text, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.fromScale(0.9, 0.2)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

makeButton("Auto Farm", UDim2.fromScale(0.05, 0.1), function()
    Settings.AutoFarm = not Settings.AutoFarm
    warn("AutoFarm:", Settings.AutoFarm)
end)

makeButton("Auto Collect", UDim2.fromScale(0.05, 0.4), function()
    Settings.AutoCollect = not Settings.AutoCollect
    warn("AutoCollect:", Settings.AutoCollect)
end)
