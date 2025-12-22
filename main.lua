--=================================
-- Dealta Hub | ALL FEATURES +
-- Kill Aura Range + Bring All
--=================================

-- Services
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local VirtualUser=game:GetService("VirtualUser")

local LP=Players.LocalPlayer
local Char,Hum,HRP

local function setup(c)
    Char=c
    Hum=c:WaitForChild("Humanoid")
    HRP=c:WaitForChild("HumanoidRootPart")
end
setup(LP.Character or LP.CharacterAdded:Wait())
LP.CharacterAdded:Connect(setup)

-- Settings
local S={
    Master=true,
    AutoFarm=false,AutoCollect=false,KillAura=false,
    Fly=false,Speed=false,Jump=false,Noclip=false,ESP=false,
    BringAll=false,
    WalkSpeed=80,JumpPower=120,FlySpeed=70,
    TweenSpeed=0.25,Distance=3,
    AuraRange=15
}

-- Utils
local function tweenTo(cf)
    if HRP then
        TweenService:Create(
            HRP,
            TweenInfo.new(S.TweenSpeed,Enum.EasingStyle.Linear),
            {CFrame=cf}
        ):Play()
    end
end

local function validEnemy(m)
    return m:IsA("Model")
    and m~=Char
    and m:FindFirstChild("Humanoid")
    and m.Humanoid.Health>0
    and m:FindFirstChild("HumanoidRootPart")
end

local function nearestEnemy()
    local best,dist=nil,math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if validEnemy(v) then
            local d=(HRP.Position-v.HumanoidRootPart.Position).Magnitude
            if d<dist then dist=d best=v end
        end
    end
    return best
end

-- Auto Farm
task.spawn(function()
    while task.wait(0.3) do
        if S.Master and S.AutoFarm and HRP then
            local e=nearestEnemy()
            if e then
                tweenTo(e.HumanoidRootPart.CFrame*CFrame.new(0,0,-S.Distance))
                mouse1click()
            end
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.2) do
        if S.Master and S.KillAura and HRP then
            for _,v in pairs(workspace:GetDescendants()) do
                if validEnemy(v) then
                    if (HRP.Position-v.HumanoidRootPart.Position).Magnitude<=S.AuraRange then
                        mouse1click()
                    end
                end
            end
        end
    end
end)

-- Bring All Enemies To Player
task.spawn(function()
    while task.wait(0.3) do
        if S.Master and S.BringAll and HRP then
            for _,v in pairs(workspace:GetDescendants()) do
                if validEnemy(v) then
                    v.HumanoidRootPart.CFrame=HRP.CFrame*CFrame.new(0,0,-5)
                end
            end
        end
    end
end)

-- Auto Collect
task.spawn(function()
    while task.wait(1) do
        if S.Master and S.AutoCollect and HRP then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") then
                    firetouchinterest(HRP,v.Parent,0)
                    firetouchinterest(HRP,v.Parent,1)
                end
            end
        end
    end
end)

-- Fly
local BV,BG
RunService.RenderStepped:Connect(function()
    if S.Master and S.Fly and HRP then
        if not BV then
            BV=Instance.new("BodyVelocity",HRP)
            BV.MaxForce=Vector3.new(1e9,1e9,1e9)
            BG=Instance.new("BodyGyro",HRP)
            BG.MaxTorque=Vector3.new(1e9,1e9,1e9)
        end
        local cam=workspace.CurrentCamera
        local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir+=cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=cam.CFrame.UpVector end
        BV.Velocity=dir.Magnitude>0 and dir.Unit*S.FlySpeed or Vector3.zero
        BG.CFrame=cam.CFrame
    else
        if BV then BV:Destroy() BV=nil end
        if BG then BG:Destroy() BG=nil end
    end
end)

-- Speed / Jump
task.spawn(function()
    while task.wait(0.3) do
        if Hum then
            Hum.WalkSpeed=S.Speed and S.WalkSpeed or 16
            Hum.JumpPower=S.Jump and S.JumpPower or 50
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if S.Master and S.Noclip and Char then
        for _,v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

-- Anti AFK
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- GUI
local gui=Instance.new("ScreenGui",LP.PlayerGui)
local f=Instance.new("Frame",gui)
f.Size=UDim2.fromScale(0.26,0.8)
f.Position=UDim2.fromScale(0.03,0.12)
f.BackgroundColor3=Color3.fromRGB(25,25,25)

local function btn(t,y,cb)
    local b=Instance.new("TextButton",f)
    b.Size=UDim2.fromScale(0.9,0.07)
    b.Position=UDim2.fromScale(0.05,y)
    b.Text=t
    b.BackgroundColor3=Color3.fromRGB(40,40,40)
    b.TextColor3=Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

btn("MASTER ON/OFF",0.02,function()S.Master=not S.Master end)
btn("Auto Farm",0.10,function()S.AutoFarm=not S.AutoFarm end)
btn("Auto Collect",0.18,function()S.AutoCollect=not S.AutoCollect end)
btn("Kill Aura",0.26,function()S.KillAura=not S.KillAura end)
btn("Aura Range +5",0.34,function()S.AuraRange+=5 end)
btn("Aura Range -5",0.42,function()S.AuraRange=math.max(5,S.AuraRange-5) end)
btn("Bring All Enemies",0.50,function()S.BringAll=not S.BringAll end)
btn("Fly",0.58,function()S.Fly=not S.Fly end)
btn("Speed",0.66,function()S.Speed=not S.Speed end)
btn("Jump Boost",0.74,function()S.Jump=not S.Jump end)

UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode==Enum.KeyCode.RightShift then
        f.Visible=not f.Visible
    end
end)