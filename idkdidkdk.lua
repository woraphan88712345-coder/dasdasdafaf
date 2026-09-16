--v12321

repeat task.wait() until game:IsLoaded()

_G.config = {
Farm = true,
AutoExecute = true,
TweenDuration = 3,
PostTweenWait = 2,
Debug = false
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function DebugPrint(msg)
if _G.config.Debug then
print("[FARM] " .. tostring(msg))
end
end

-- =========================================================
-- Auto Click System
-- =========================================================

_G.AutoClick = true

local function click_btn(btn)
if not btn then
return false
end

if not (btn:IsA("ImageButton") or btn:IsA("TextButton")) then
    return false
end

DebugPrint("Clicking: " .. btn.Name)

if firesignal then
    pcall(function()
        firesignal(btn.MouseButton1Click)
    end)
end

pcall(function()
    btn:Activate()
end)

pcall(function()
    btn.MouseButton1Click:Fire()
end)

return true

end

task.spawn(function()
while _G.AutoClick do
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- Check BleedoutGui
    local BleedoutGui = PlayerGui:FindFirstChild("BleedoutGui")

    if BleedoutGui and BleedoutGui.Enabled then
        local Frame = BleedoutGui:FindFirstChild("Frame")

        if Frame then
            local ReviveBtn = Frame:FindFirstChild("Revive")

            if ReviveBtn then
                click_btn(ReviveBtn)
                task.wait(0.3)
            end
        end
    end

    -- Check EndFrame
    local EndFrame = PlayerGui:FindFirstChild("EndFrame")

    if EndFrame and EndFrame.Enabled then
        local Frame = EndFrame:FindFirstChild("Frame")

        if Frame then
            local ReplayBtn = Frame:FindFirstChild("Replay")

            if ReplayBtn then
                click_btn(ReplayBtn)
                task.wait(0.3)
            end
        end
    end

    task.wait(0.1)
end

end)

-- =========================================================
-- Auto-execute on teleport
-- =========================================================

if _G.config.AutoExecute then
local AUTOEXEC = [[
task.wait(5)
loadstring(game:HttpGet(
"https://pastebin.com/raw/zkC5E6rT"
))()
]]

if type(queue_on_teleport) == "function" then
    queue_on_teleport(AUTOEXEC)
end


end

-- =========================================================
-- Tween teleport
-- =========================================================

local function TeleportTween(x, y, z)
if Character and Character:FindFirstChild("HumanoidRootPart") then
local RootPart = Character.HumanoidRootPart

    local TweenInfo = TweenInfo.new(
        _G.config.TweenDuration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )

    local Tween = TweenService:Create(
        RootPart,
        TweenInfo,
        {
            CFrame = CFrame.new(x, y, z)
        }
    )

    Tween:Play()

    return Tween
end

end

-- =========================================================
-- Reset character
-- =========================================================

local function ResetCharacter()
if Character and Character:FindFirstChild("Humanoid") then
Character.Humanoid.Health = 0

    Character = LocalPlayer.CharacterAdded:Wait()

    task.wait(0.5)
end

end

-- =========================================================
-- Farm loop
-- =========================================================

if _G.config.Farm then

local function FarmCycle()

    while _G.config.Farm do

        if not Character or not Character:FindFirstChild("Humanoid") then
            Character = LocalPlayer.CharacterAdded:Wait()
            task.wait(1)
        end

        DebugPrint("=== CYCLE START ===")

        -- Tween to start position
        TeleportTween(1250, 2250, 83600)

        task.wait(_G.config.TweenDuration)

        -- Wait post-tween
        task.wait(_G.config.PostTweenWait)

        -- Reset character
        ResetCharacter()

        task.wait(1)

        -- AutoClick system handles Revive + Replay
        task.wait(5)
    end
end

task.spawn(FarmCycle)

end
