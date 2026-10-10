--[[
    ██╗   ██╗ ██████╗ ██╗██████╗     ██╗   ██╗██╗
    ██║   ██║██╔═══██╗██║██╔══██╗    ██║   ██║██║
    ██║   ██║██║   ██║██║██║  ██║    ██║   ██║██║
    ╚██╗ ██╔╝██║   ██║██║██║  ██║    ██║   ██║██║
     ╚████╔╝ ╚██████╔╝██║██████╔╝    ╚██████╔╝██║
      ╚═══╝   ╚═════╝ ╚═╝╚═════╝      ╚═════╝ ╚═╝

    Void-UI  •  v1.1
    Modern UI Library for Roblox Executors
    Style: Speed Hub X (compact, no shadow, elegant transparency)
    Author: Alex
]]

local VoidUI = {}
VoidUI.__index = VoidUI

-- ============================================
-- SERVICES
-- ============================================
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

-- ============================================
-- THEME (Speed Hub X style — transparent & slim)
-- ============================================
VoidUI.Theme = {
    Background     = Color3.fromRGB(15, 15, 20),
    BackgroundTr   = 0.15,          -- transparencia del fondo principal
    Panel          = Color3.fromRGB(22, 22, 30),
    PanelTr        = 0.10,
    Secondary      = Color3.fromRGB(30, 30, 40),
    SecondaryTr    = 0.05,
    Accent         = Color3.fromRGB(120, 60, 255),
    AccentHover    = Color3.fromRGB(145, 90, 255),
    Text           = Color3.fromRGB(240, 240, 250),
    SubText        = Color3.fromRGB(145, 145, 165),
    Stroke         = Color3.fromRGB(45, 45, 60),
    StrokeTr       = 0.4,           -- transparencia del borde
    Danger         = Color3.fromRGB(220, 60, 60),
    Success        = Color3.fromRGB(60, 200, 120),
}

VoidUI.Version = "1.1"
VoidUI.Name    = "Void-UI"

-- ============================================
-- INTERNAL UTILITIES
-- ============================================
local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or VoidUI.Theme.Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or VoidUI.Theme.StrokeTr
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.Parent = parent
    return p
end

-- ============================================
-- MAIN WINDOW
-- ============================================
function VoidUI:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, VoidUI)

    self.Name       = config.Name or "Void-UI"
    self.Subtitle   = config.Subtitle or "by Alex"
    self.ToggleKey  = config.ToggleKey or Enum.KeyCode.RightShift
    self.Tabs       = {}
    self.Flags      = {}
    self.Connections = {}

    -- ScreenGui
    self.ScreenGui = create("ScreenGui", {
        Name = "VoidUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })

    local ok = pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)
    if not ok then
        self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ============================================
    -- MAIN FRAME (compact, transparent, no shadow)
    -- ============================================
    self.Main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 500, 0, 340),
        Position = UDim2.new(0.5, -250, 0.5, -170),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = self.Theme.BackgroundTr,
        BorderSizePixel = 0,
        Active = true,
    })
    self.Main.Parent = self.ScreenGui
    corner(self.Main, 8)
    stroke(self.Main, self.Theme.Stroke, 1, self.Theme.StrokeTr)

    -- ============================================
    -- HEADER (slim)
    -- ============================================
    self.Header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = self.Theme.PanelTr,
        BorderSizePixel = 0,
    })
    self.Header.Parent = self.Main
    corner(self.Header, 8)

    -- Cover bottom rounded corners of header
    local headerFix = create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = self.Theme.PanelTr,
        BorderSizePixel = 0,
    })
    headerFix.Parent = self.Header

    -- Accent top line
    local topLine = create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
    })
    topLine.Parent = self.Main
    corner(topLine, 8)

    -- Logo
    local logo = create("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = "◈ " .. self.Name,
        TextColor3 = self.Theme.Accent,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    logo.Parent = self.Header

    -- Subtitle
    local subtitle = create("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -140, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Subtitle,
        TextColor3 = self.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    subtitle.Parent = self.Header

    -- Minimize button
    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.3,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    minBtn.Parent = self.Header
    corner(minBtn, 5)

    -- Close button
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -30, 0.5, -11),
        BackgroundColor3 = self.Theme.Danger,
        BackgroundTransparency = 0.2,
        Text = "×",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    closeBtn.Parent = self.Header
    corner(closeBtn, 5)

    -- Hover effects on buttons
    minBtn.MouseEnter:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.1 }):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.3 }):Play()
    end)
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.2 }):Play()
    end)

    -- ============================================
    -- SIDEBAR (slim, no stroke)
    -- ============================================
    self.Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 120, 1, -34),
        Position = UDim2.new(0, 0, 0, 34),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = self.Theme.PanelTr + 0.1,
        BorderSizePixel = 0,
    })
    self.Sidebar.Parent = self.Main
    padding(self.Sidebar, 8, 6, 8, 6)
    create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Sidebar,
    })

    -- ============================================
    -- PAGE CONTAINER
    -- ============================================
    self.PageContainer = create("Frame", {
        Name = "Pages",
        Size = UDim2.new(1, -120, 1, -34),
        Position = UDim2.new(0, 120, 0, 34),
        BackgroundTransparency = 1,
    })
    self.PageContainer.Parent = self.Main

    -- ========== DRAG ==========
    do
        local dragging, dragStart, startPos
        self.Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = self.Main.Position
            end
        end)
        table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                self.Main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end))
        table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end))
    end

    -- ========== MINIMIZE ==========
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local target = minimized and UDim2.new(0, 500, 0, 34) or UDim2.new(0, 500, 0, 340)
        TweenService:Create(self.Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Size = target
        }):Play()
        self.PageContainer.Visible = not minimized
        self.Sidebar.Visible = not minimized
        minBtn.Text = minimized and "+" or "—"
    end)

    -- ========== CLOSE ==========
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.Main, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }):Play()
        task.wait(0.25)
        self.ScreenGui.Enabled = false
    end)

    -- ========== TOGGLE KEY ==========
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end))

    return self
end

-- ============================================
-- CREATE TAB
-- ============================================
function VoidUI:CreateTab(tabName)
    local tab = {
        Name = tabName or "Tab",
        Library = self,
    }
    setmetatable(tab, { __index = VoidUI })

    local btn = create("TextButton", {
        Name = tabName,
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.5,
        Text = tabName,
        TextColor3 = self.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    btn.Parent = self.Sidebar
    corner(btn, 5)

    local page = create("ScrollingFrame", {
        Name = tabName .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollBarImageTransparency = 0.4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
    })
    page.Parent = self.PageContainer
    padding(page, 12, 10, 12, 10)
    local list = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 24)
    end)

    local function select()
        for _, child in pairs(self.PageContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        for _, child in pairs(self.Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.15), {
                    BackgroundColor3 = self.Theme.Background,
                    BackgroundTransparency = 0.5,
                    TextColor3 = self.Theme.SubText,
                }):Play()
            end
        end
        page.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0.15,
            TextColor3 = Color3.new(1, 1, 1),
        }):Play()
    end

    btn.MouseButton1Click:Connect(select)
    btn.MouseEnter:Connect(function()
        if not page.Visible then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Secondary,
                BackgroundTransparency = 0.3,
            }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not page.Visible then
            TweenService:Create(btn, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Background,
                BackgroundTransparency = 0.5,
            }):Play()
        end
    end)

    if #self.Tabs == 0 then select() end
    table.insert(self.Tabs, tab)

    tab.Page = page
    tab.Button = btn
    tab.List = list

    return tab
end

-- ============================================
-- COMPONENTS
-- ============================================

-- Section
function VoidUI:CreateSection(tab, text)
    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
    })
    frame.Parent = tab.Page

    local label = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = string.upper(text or "SECTION"),
        TextColor3 = self.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local line = create("Frame", {
        Size = UDim2.new(1, -90, 0, 1),
        Position = UDim2.new(0, 90, 0.5, 0),
        BackgroundColor3 = self.Theme.Stroke,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    })
    line.Parent = frame
    return frame
end

-- Toggle
function VoidUI:CreateToggle(tab, config)
    config = config or {}
    local state = config.Default or false
    local flag = config.Flag

    local frame = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.25,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    frame.Parent = tab.Page
    corner(frame, 5)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Toggle",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local indicator = create("Frame", {
        Size = UDim2.new(0, 32, 0, 16),
        Position = UDim2.new(1, -42, 0.5, -8),
        BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(60, 60, 70),
        BackgroundTransparency = state and 0.1 or 0.3,
        BorderSizePixel = 0,
    })
    indicator.Parent = frame
    corner(indicator, 8)

    local knob = create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    knob.Parent = indicator
    corner(knob, 6)

    local function setState(v, silent)
        state = v
        if flag then self.Flags[flag] = v end
        TweenService:Create(indicator, TweenInfo.new(0.2), {
            BackgroundColor3 = v and self.Theme.Accent or Color3.fromRGB(60, 60, 70),
            BackgroundTransparency = v and 0.1 or 0.3,
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = v and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
        }):Play()
        if not silent and config.Callback then task.spawn(config.Callback, v) end
    end

    frame.MouseButton1Click:Connect(function() setState(not state) end)
    if flag then self.Flags[flag] = state end

    return { Set = setState, Get = function() return state end }
end

-- Button
function VoidUI:CreateButton(tab, config)
    config = config or {}

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.15,
        Text = config.Name or "Button",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    btn.Parent = tab.Page
    corner(btn, 5)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.AccentHover,
            BackgroundTransparency = 0,
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0.15,
        }):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if config.Callback then task.spawn(config.Callback) end
    end)
    return btn
end

-- Slider
function VoidUI:CreateSlider(tab, config)
    config = config or {}
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.Default or min
    local flag = config.Flag

    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
    })
    frame.Parent = tab.Page
    corner(frame, 5)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 12, 0, 5),
        BackgroundTransparency = 1,
        Text = (config.Name or "Slider") .. ": " .. value,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local barBg = create("Frame", {
        Size = UDim2.new(1, -24, 0, 5),
        Position = UDim2.new(0, 12, 0, 29),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
    })
    barBg.Parent = frame
    corner(barBg, 3)

    local fill = create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
    })
    fill.Parent = barBg
    corner(fill, 3)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        label.Text = (config.Name or "Slider") .. ": " .. value
        if flag then self.Flags[flag] = value end
        if config.Callback then task.spawn(config.Callback, value) end
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end))
    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    if flag then self.Flags[flag] = value end
    return {
        Set = function(v)
            v = math.clamp(v, min, max)
            value = v
            local rel = (v - min) / (max - min)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = (config.Name or "Slider") .. ": " .. v
            if flag then self.Flags[flag] = v end
        end,
        Get = function() return value end,
    }
end

-- TextBox
function VoidUI:CreateTextBox(tab, config)
    config = config or {}
    local box = create("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.25,
        Text = config.Default or "",
        PlaceholderText = config.Placeholder or "Type here...",
        TextColor3 = self.Theme.Text,
        PlaceholderColor3 = self.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
    })
    box.Parent = tab.Page
    corner(box, 5)
    local s = stroke(box, self.Theme.Stroke, 1, 0.5)

    box.Focused:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.15), { Color = self.Theme.Accent, Transparency = 0 }):Play()
    end)
    box.FocusLost:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.15), { Color = self.Theme.Stroke, Transparency = 0.5 }):Play()
        if config.Callback then task.spawn(config.Callback, box.Text) end
    end)
    return box
end

-- Dropdown
function VoidUI:CreateDropdown(tab, config)
    config = config or {}
    local options = config.Options or {}
    local selected = config.Default or (options[1] or "")
    local open = false
    local flag = config.Flag

    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ClipsDescendants = false,
    })
    container.Parent = tab.Page
    corner(container, 5)

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
    })
    btn.Parent = container

    local label = create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = (config.Name and config.Name .. ": " or "") .. selected,
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = container

    local arrow = create("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = self.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
    })
    arrow.Parent = container

    local panel = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 10,
    })
    panel.Parent = container
    corner(panel, 5)
    stroke(panel, self.Theme.Stroke, 1, 0.4)
    local list = create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = panel,
    })
    padding(panel, 4, 4, 4, 4)

    local function selectOption(opt)
        selected = opt
        if flag then self.Flags[flag] = opt end
        label.Text = (config.Name and config.Name .. ": " or "") .. opt
        if config.Callback then task.spawn(config.Callback, opt) end
    end

    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.3,
            Text = tostring(opt),
            TextColor3 = self.Theme.Text,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            AutoButtonColor = false,
        })
        optBtn.Parent = panel
        corner(optBtn, 4)
        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = self.Theme.Accent,
                BackgroundTransparency = 0.1,
            }):Play()
        end)
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = self.Theme.Secondary,
                BackgroundTransparency = 0.3,
            }):Play()
        end)
        optBtn.MouseButton1Click:Connect(function()
            selectOption(opt)
            open = false
            panel.Visible = false
            TweenService:Create(container, TweenInfo.new(0.15), {
                Size = UDim2.new(1, 0, 0, 30)
            }):Play()
            arrow.Text = "▼"
        end)
    end
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        panel.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
    end)

    btn.MouseButton1Click:Connect(function()
        open = not open
        panel.Visible = open
        if open then
            local h = math.min(#options * 26 + 10, 130)
            TweenService:Create(container, TweenInfo.new(0.15), {
                Size = UDim2.new(1, 0, 0, 30 + h)
            }):Play()
            panel.Size = UDim2.new(1, 0, 0, h)
        else
            TweenService:Create(container, TweenInfo.new(0.15), {
                Size = UDim2.new(1, 0, 0, 30)
            }):Play()
        end
        arrow.Text = open and "▲" or "▼"
    end)

    if flag then self.Flags[flag] = selected end
    return {
        Set = function(v) selectOption(v) end,
        Get = function() return selected end,
    }
end

-- Keybind
function VoidUI:CreateKeybind(tab, config)
    config = config or {}
    local currentKey = config.Default or Enum.KeyCode.E
    local flag = config.Flag
    local listening = false

    local frame = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.25,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    frame.Parent = tab.Page
    corner(frame, 5)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -110, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Keybind",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local keyBtn = create("TextButton", {
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(1, -90, 0.5, -10),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.4,
        Text = currentKey.Name,
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    keyBtn.Parent = frame
    corner(keyBtn, 4)

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = self.Theme.Accent
    end)

    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            keyBtn.Text = currentKey.Name
            keyBtn.TextColor3 = self.Theme.Text
            listening = false
            if flag then self.Flags[flag] = currentKey end
            if config.OnChanged then task.spawn(config.OnChanged, currentKey) end
        elseif input.KeyCode == currentKey and not listening then
            if config.Callback then task.spawn(config.Callback) end
        end
    end))

    if flag then self.Flags[flag] = currentKey end
    return {
        Set = function(k)
            currentKey = k
            keyBtn.Text = k.Name
            if flag then self.Flags[flag] = k end
        end,
        Get = function() return currentKey end,
    }
end

-- Label
function VoidUI:CreateLabel(tab, text)
    local label = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })
    label.Parent = tab.Page
    return label
end

-- ============================================
-- NOTIFICATIONS (compact, transparent)
-- ============================================
VoidUI.NotifyIndex = 0

function VoidUI:Notify(config)
    config = config or {}
    VoidUI.NotifyIndex = VoidUI.NotifyIndex + 1
    local idx = VoidUI.NotifyIndex

    local notif = create("Frame", {
        Name = "Notify" .. idx,
        Size = UDim2.new(0, 240, 0, 56),
        Position = UDim2.new(1, 20, 0, 60 + (idx - 1) * 64),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
    })
    notif.Parent = self.ScreenGui
    corner(notif, 6)
    stroke(notif, self.Theme.Accent, 1, 0.3)

    local side = create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
    })
    side.Parent = notif
    corner(side, 6)

    local title = create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 14, 0, 7),
        BackgroundTransparency = 1,
        Text = config.Title or "Void-UI",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    title.Parent = notif

    local text = create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.new(0, 14, 0, 27),
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = self.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })
    text.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Position = UDim2.new(1, -260, 0, 60 + (idx - 1) * 64)
    }):Play()

    task.delay(config.Duration or 4, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, 0, 60 + (idx - 1) * 64)
        }):Play()
        task.wait(0.35)
        notif:Destroy()
        VoidUI.NotifyIndex = math.max(0, VoidUI.NotifyIndex - 1)
    end)
end

-- ============================================
-- CONFIG SAVE / LOAD
-- ============================================
function VoidUI:SaveConfig(filename)
    if not writefile then
        self:Notify({ Title = "Error", Text = "writefile not available" })
        return
    end
    filename = filename or "VoidUI_Config.json"
    local data = {}
    for k, v in pairs(self.Flags) do
        if typeof(v) == "EnumItem" then
            data[k] = { __type = "EnumItem", value = v.Name }
        else
            data[k] = v
        end
    end
    writefile(filename, game:GetService("HttpService"):JSONEncode(data))
    self:Notify({ Title = "Config", Text = "Saved to " .. filename })
end

function VoidUI:LoadConfig(filename)
    if not (isfile and readfile) then
        self:Notify({ Title = "Error", Text = "readfile not available" })
        return
    end
    filename = filename or "VoidUI_Config.json"
    if not isfile(filename) then
        self:Notify({ Title = "Error", Text = "File not found" })
        return
    end
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(filename))
    end)
    if not ok then
        self:Notify({ Title = "Error", Text = "Invalid config" })
        return
    end
    for k, v in pairs(data) do
        self.Flags[k] = v
    end
    self:Notify({ Title = "Config", Text = "Loaded from " .. filename })
end

-- ============================================
-- DESTROY
-- ============================================
function VoidUI:Destroy()
    for _, conn in pairs(self.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

-- ============================================
-- RETURN
-- ============================================
return VoidUI
