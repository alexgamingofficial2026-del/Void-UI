--[[
    ◈ Void-UI — Example Script
    Author: Alex (alexgamingofficial2026-del)
    Version: 1.0

    This script demonstrates every component available in Void-UI.
]]

-- ============================================
-- 1. LOAD THE LIBRARY
-- ============================================
local VoidUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/alexgamingofficial2026-del/Void-UI/main/Void-UI.lua"
))()

-- Services
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local Workspace        = game:GetService("Workspace")
local LocalPlayer      = Players.LocalPlayer

-- ============================================
-- 2. CREATE WINDOW
-- ============================================
local Window = VoidUI:CreateWindow({
    Name      = "Void-UI Demo",
    Subtitle  = "v1.0 by Alex",
    ToggleKey = Enum.KeyCode.RightShift
})

-- ============================================
-- 3. TABS
-- ============================================
local MainTab     = Window:CreateTab("Main")
local VisualTab   = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

-- ============================================
-- MAIN TAB
-- ============================================
MainTab:CreateSection("MOVEMENT")

MainTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16, Max = 300, Default = 16,
    Flag = "WalkSpeed",
    Callback = function(v)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end
})

MainTab:CreateSlider({
    Name = "Jump Power",
    Min = 50, Max = 500, Default = 50,
    Flag = "JumpPower",
    Callback = function(v)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = v
        end
    end
})

local infJumpConn = nil
MainTab:CreateToggle({
    Name = "Infinite Jump",
    Default = false, Flag = "InfiniteJump",
    Callback = function(state)
        if state then
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
        end
    end
})

local noclipConn = nil
MainTab:CreateToggle({
    Name = "Noclip",
    Default = false, Flag = "Noclip",
    Callback = function(state)
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        end
    end
})

MainTab:CreateSection("ACTIONS")

MainTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        local char = LocalPlayer.Character
        if char then char:BreakJoints() end
    end
})

MainTab:CreateButton({
    Name = "Test Notification",
    Callback = function()
        VoidUI:Notify({
            Title = "Void-UI",
            Text  = "Everything is working! ✅",
            Duration = 4
        })
    end
})

-- ============================================
-- VISUALS TAB
-- ============================================
VisualTab:CreateSection("INTERFACE")

VisualTab:CreateDropdown({
    Name = "Accent Color",
    Options = { "Purple", "Blue", "Red", "Green", "Orange" },
    Default = "Purple", Flag = "AccentColor",
    Callback = function(option)
        local themes = {
            Purple = Color3.fromRGB(120, 60, 255),
            Blue   = Color3.fromRGB(0, 120, 255),
            Red    = Color3.fromRGB(220, 60, 60),
            Green  = Color3.fromRGB(60, 200, 120),
            Orange = Color3.fromRGB(255, 140, 0),
        }
        if themes[option] then VoidUI.Theme.Accent = themes[option] end
    end
})

VisualTab:CreateSection("LIGHTING")

VisualTab:CreateToggle({
    Name = "Fullbright",
    Default = false, Flag = "Fullbright",
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(255,255,255)
            Lighting.Brightness = 3
        else
            Lighting.Ambient = Color3.fromRGB(70,70,70)
            Lighting.Brightness = 1
        end
    end
})

VisualTab:CreateSlider({
    Name = "Time of Day",
    Min = 0, Max = 24, Default = 14,
    Flag = "TimeOfDay",
    Callback = function(v) Lighting.ClockTime = v end
})

VisualTab:CreateToggle({
    Name = "Remove Fog",
    Default = false, Flag = "NoFog",
    Callback = function(state)
        if state then
            Lighting.FogEnd = 1e5
            Lighting.FogStart = 1e5
        else
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
        end
    end
})

-- ============================================
-- SETTINGS TAB
-- ============================================
SettingsTab:CreateSection("KEYBINDS")

SettingsTab:CreateKeybind({
    Name = "Quick Notification",
    Default = Enum.KeyCode.F, Flag = "NotifyKey",
    Callback = function()
        VoidUI:Notify({
            Title = "Keybind",
            Text  = "You pressed the quick key!"
        })
    end
})

SettingsTab:CreateSection("CONFIGURATION")

SettingsTab:CreateTextBox({
    Name = "Notes",
    Placeholder = "Type anything here...",
    Default = "",
    Callback = function(text)
        print("[Void-UI] Notes:", text)
    end
})

SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function() Window:SaveConfig("voidui_config.json") end
})

SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function() Window:LoadConfig("voidui_config.json") end
})

SettingsTab:CreateSection("DANGER ZONE")

SettingsTab:CreateButton({
    Name = "Unload Void-UI",
    Callback = function()
        VoidUI:Notify({
            Title = "Void-UI",
            Text  = "Unloading in 2 seconds...",
            Duration = 2
        })
        task.wait(2)
        VoidUI:Destroy()
    end
})

-- ============================================
-- 4. WELCOME
-- ============================================
VoidUI:Notify({
    Title = "Void-UI",
    Text  = "Loaded successfully! Press RightShift to toggle.",
    Duration = 5
})
