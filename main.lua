-- LONG LEGS + FULL BODY CONTROL
-- LEGIT | R15 ONLY

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function applyBody()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    local desc = hum:GetAppliedDescription()

    -- 🔥 MAIN CONTROLS
    desc.HeightScale = 1.35      -- overall height (legs grow)
    desc.WidthScale = 0.9
    desc.DepthScale = 0.9
    desc.ProportionScale = 1     -- IMPORTANT for long legs
    desc.BodyTypeScale = 0

    -- Optional: make body slimmer
    desc.HeadScale = 0.95

    hum:ApplyDescription(desc)
end

applyBody()