--[[
    Void-UI v1.3 — Fixed button visibility
    Style: Haci
    Author: Alex
]]

local VoidUI = {}
VoidUI.__index = VoidUI

-- Services
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- Theme
VoidUI.Theme = {
    Background   = Color3.fromRGB(18, 18, 24),
    BackgroundTr = 0.10,
    Panel        = Color3.fromRGB(24, 24, 32),
    PanelTr      = 0.05,
    Secondary    = Color3.fromRGB(32, 32, 42),
    SecondaryTr  = 0.15,
    Accent       = Color3.fromRGB(140, 82, 255),
    AccentHover  = Color3.fromRGB(160, 110, 255),
    Text         = Color3.fromRGB(235, 235, 245),
    SubText      = Color3.fromRGB(140, 140, 160),
    Stroke       = Color3.fromRGB(40, 40, 52),
    StrokeTr     = 0.6,
    Danger       = Color3.fromRGB(230, 70, 70),
}

VoidUI.Version = "1.3"
VoidUI.Name    = "Void-UI"

-- Utilities
local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do inst[k] = v end
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
-- WINDOW
-- ============================================
function VoidUI:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, VoidUI)

    self.Name       = config.Name or "Void-UI"
    self.Subtitle   = config.Subtitle or "v1.3"
    self.ToggleKey  = config.ToggleKey or Enum.KeyCode.RightShift
    self.Tabs       = {}
    self.Flags      = {}
    self.Connections = {}

    self.ScreenGui = create("ScreenGui", {
        Name = "VoidUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })
    local ok = pcall(function() self.ScreenGui.Parent = CoreGui end)
    if not ok then self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- Main
    self.Main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 420, 0, 260),
        Position = UDim2.new(0.5, -210, 0.5, -130),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = self.Theme.BackgroundTr,
        BorderSizePixel = 0,
        Active = true,
    })
    self.Main.Parent = self.ScreenGui
    corner(self.Main, 8)
    stroke(self.Main, self.Theme.Stroke, 1, self.Theme.StrokeTr)

    -- Header
    self.Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = self.Theme.PanelTr,
        BorderSizePixel = 0,
    })
    self.Header.Parent = self.Main
    corner(self.Header, 8)

    local headerFix = create("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = self.Theme.PanelTr,
        BorderSizePixel = 0,
    })
    headerFix.Parent = self.Header

    local accentLine = create("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 1, -1),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
    })
    accentLine.Parent = self.Header

    local logo = create("TextLabel", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "◈ " .. self.Name,
        TextColor3 = self.Theme.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    logo.Parent = self.Header

    local subtitle = create("TextLabel", {
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(1, -120, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Subtitle,
        TextColor3 = self.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    subtitle.Parent = self.Header

    local minBtn = create("TextButton", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.5,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    minBtn.Parent = self.Header
    corner(minBtn, 4)

    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -24, 0.5, -9),
        BackgroundColor3 = self.Theme.Danger,
        BackgroundTransparency = 0.3,
        Text = "×",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    })
    closeBtn.Parent = self.Header
    corner(closeBtn, 4)

    -- Sidebar (sin UIListLayout problemático)
    self.Sidebar = create("Frame", {
        Size = UDim2.new(0, 100, 1, -28),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = self.Theme.PanelTr + 0.05,
        BorderSizePixel = 0,
    })
    self.Sidebar.Parent = self.Main
    padding(self.Sidebar, 6, 5, 6, 5)

    -- Lista interna que SÍ maneja bien los frames
    self.SidebarList = create("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Sidebar,
    })

    -- Page container
    self.PageContainer = create("Frame", {
        Size = UDim2.new(1, -100, 1, -28),
        Position = UDim2.new(0, 100, 0, 28),
        BackgroundTransparency = 1,
    })
    self.PageContainer.Parent = self.Main

    -- Drag
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

    -- Minimize
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local target = minimized and UDim2.new(0, 420, 0, 28) or UDim2.new(0, 420, 0, 260)
        TweenService:Create(self.Main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = target
        }):Play()
        self.PageContainer.Visible = not minimized
        self.Sidebar.Visible = not minimized
        minBtn.Text = minimized and "+" or "—"
    end)

    -- Close
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.Main, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        }):Play()
        task.wait(0.25)
        self.ScreenGui.Enabled = false
    end)

    -- Toggle key
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end))

    return self
end

-- ============================================
-- TAB
-- ============================================
function VoidUI:CreateTab(tabName)
    tabName = tabName or "Tab"

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    })
    holder.Parent = self.Sidebar
    corner(holder, 4)

    local accentBar = create("Frame", {
        Size = UDim2.new(0, 2, 0.6, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Visible = false,
    })
    accentBar.Parent = holder
    corner(accentBar, 2)

    local btn = create("TextButton", {
        Size = UDim2.new(1, -6, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = tabName,
        TextColor3 = self.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    btn.Parent = holder

    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
    })
    page.Parent = self.PageContainer
    padding(page, 10, 8, 10, 8)
    local list = create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)

    local tab = {
        Name = tabName,
        Page = page,
        Button = btn,
        Holder = holder,
        AccentBar = accentBar,
        Library = self,
    }

    local function select()
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
            t.AccentBar.Visible = false
            t.Button.TextColor3 = self.Theme.SubText
            TweenService:Create(t.Holder, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Background,
                BackgroundTransparency = 0.5,
            }):Play()
        end
        page.Visible = true
        btn.TextColor3 = self.Theme.Text
        accentBar.Visible = true
        TweenService:Create(holder, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.4,
        }):Play()
    end

    tab.Select = select

    btn.MouseButton1Click:Connect(select)
    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            select()
        end
    end)

    holder.MouseEnter:Connect(function()
        if not page.Visible then
            TweenService:Create(holder, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Secondary,
                BackgroundTransparency = 0.6,
            }):Play()
        end
    end)
    holder.MouseLeave:Connect(function()
        if not page.Visible then
            TweenService:Create(holder, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Background,
                BackgroundTransparency = 0.5,
            }):Play()
        end
    end)

    table.insert(self.Tabs, tab)
    setmetatable(tab, { __index = VoidUI })

    if #self.Tabs == 1 then select() end

    return tab
end

-- ============================================
-- COMPONENTS
-- ============================================

function VoidUI:CreateSection(tab, text)
    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
    })
    frame.Parent = tab.Page

    local label = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = string.upper(text or "SECTION"),
        TextColor3 = self.Theme.SubText,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame
end

function VoidUI:CreateToggle(tab, config)
    config = config or {}
    local state = config.Default or false
    local flag = config.Flag

    local frame = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.Theme.SecondaryTr,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    frame.Parent = tab.Page
    corner(frame, 5)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Toggle",
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local indicator = create("Frame", {
        Size = UDim2.new(0, 26, 0, 13),
        Position = UDim2.new(1, -34, 0.5, -6.5),
        BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(55, 55, 68),
        BackgroundTransparency = state and 0.1 or 0.3,
        BorderSizePixel = 0,
    })
    indicator.Parent = frame
    corner(indicator, 7)

    local knob = create("Frame", {
        Size = UDim2.new(0, 9, 0, 9),
        Position = state and UDim2.new(1, -11, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    knob.Parent = indicator
    corner(knob, 5)

    local function setState(v, silent)
        state = v
        if flag then self.Flags[flag] = v end
        TweenService:Create(indicator, TweenInfo.new(0.15), {
            BackgroundColor3 = v and self.Theme.Accent or Color3.fromRGB(55, 55, 68),
            BackgroundTransparency = v and 0.1 or 0.3,
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = v and UDim2.new(1, -11, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5),
        }):Play()
        if not silent and config.Callback then task.spawn(config.Callback, v) end
    end

    frame.MouseButton1Click:Connect(function() setState(not state) end)
    if flag then self.Flags[flag] = state end
    return { Set = setState, Get = function() return state end }
end

function VoidUI:CreateButton(tab, config)
    config = config or {}

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.15,
        Text = config.Name or "Button",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 11,
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

function VoidUI:CreateSlider(tab, config)
    config = config or {}
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.Default or min
    local flag = config.Flag

    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.Theme.SecondaryTr,
        BorderSizePixel = 0,
    })
    frame.Parent = tab.Page
    corner(frame, 5)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 16),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = (config.Name or "Slider") .. ": " .. value,
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local barBg = create("Frame", {
        Size = UDim2.new(1, -20, 0, 4),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundColor3 = Color3.fromRGB(50, 50, 62),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
    })
    barBg.Parent = frame
    corner(barBg, 2)

    local fill = create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
    })
    fill.Parent = barBg
    corner(fill, 2)

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
            fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
            label.Text = (config.Name or "Slider") .. ": " .. v
        end,
        Get = function() return value end,
    }
end

function VoidUI:CreateTextBox(tab, config)
    config = config or {}
    local box = create("TextBox", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.Theme.SecondaryTr,
        Text = config.Default or "",
        PlaceholderText = config.Placeholder or "Type here...",
        TextColor3 = self.Theme.Text,
        PlaceholderColor3 = self.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
    })
    box.Parent = tab.Page
    corner(box, 5)
    box.FocusLost:Connect(function()
        if config.Callback then task.spawn(config.Callback, box.Text) end
    end)
    return box
end

function VoidUI:CreateDropdown(tab, config)
    config = config or {}
    local options = config.Options or {}
    local selected = config.Default or (options[1] or "")
    local flag = config.Flag

    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.Theme.SecondaryTr,
        BorderSizePixel = 0,
    })
    container.Parent = tab.Page
    corner(container, 5)

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
    })
    btn.Parent = container

    local label = create("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = (config.Name and config.Name .. ": " or "") .. selected,
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = container

    local arrow = create("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = self.Theme.SubText,
        TextSize = 8,
        Font = Enum.Font.Gotham,
    })
    arrow.Parent = container

    local panel = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 10,
    })
    panel.Parent = container
    corner(panel, 5)
    stroke(panel, self.Theme.Stroke, 1, 0.5)

    local list = create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = panel,
    })
    padding(panel, 3, 3, 3, 3)

    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.3,
            Text = tostring(opt),
            TextColor3 = self.Theme.Text,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            AutoButtonColor = false,
        })
        optBtn.Parent = panel
        corner(optBtn, 3)
        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            if flag then self.Flags[flag] = opt end
            label.Text = (config.Name and config.Name .. ": " or "") .. opt
            if config.Callback then task.spawn(config.Callback, opt) end
            panel.Visible = false
            TweenService:Create(container, TweenInfo.new(0.15), {
                Size = UDim2.new(1, 0, 0, 26)
            }):Play()
            arrow.Text = "▼"
        end)
    end
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        panel.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 6)
    end)

    btn.MouseButton1Click:Connect(function()
        local open = not panel.Visible
        panel.Visible = open
        if open then
            local h = math.min(#options * 24 + 8, 120)
            TweenService:Create(container, TweenInfo.new(0.15), {
                Size = UDim2.new(1, 0, 0, 26 + h)
            }):Play()
            panel.Size = UDim2.new(1, 0, 0, h)
        else
            TweenService:Create(container, TweenInfo.new(0.15), {
                Size = UDim2.new(1, 0, 0, 26)
            }):Play()
        end
        arrow.Text = open and "▲" or "▼"
    end)

    if flag then self.Flags[flag] = selected end
    return {
        Set = function(v)
            selected = v
            label.Text = (config.Name and config.Name .. ": " or "") .. v
        end,
        Get = function() return selected end,
    }
end

function VoidUI:CreateKeybind(tab, config)
    config = config or {}
    local currentKey = config.Default or Enum.KeyCode.E
    local flag = config.Flag
    local listening = false

    local frame = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = self.Theme.SecondaryTr,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    frame.Parent = tab.Page
    corner(frame, 5)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Keybind",
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    label.Parent = frame

    local keyBtn = create("TextButton", {
        Size = UDim2.new(0, 70, 0, 18),
        Position = UDim2.new(1, -78, 0.5, -9),
        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = 0.4,
        Text = currentKey.Name,
        TextColor3 = self.Theme.Text,
        TextSize = 10,
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
        end,
        Get = function() return currentKey end,
    }
end

function VoidUI:CreateLabel(tab, text)
    local label = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = self.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })
    label.Parent = tab.Page
end

-- ============================================
-- NOTIFICATIONS
-- ============================================
VoidUI.NotifyIndex = 0

function VoidUI:Notify(config)
    config = config or {}
    VoidUI.NotifyIndex += 1
    local idx = VoidUI.NotifyIndex

    local notif = create("Frame", {
        Size = UDim2.new(0, 210, 0, 46),
        Position = UDim2.new(1, 20, 0, 40 + (idx - 1) * 54),
        BackgroundColor3 = self.Theme.Panel,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
    })
    notif.Parent = self.ScreenGui
    corner(notif, 6)

    local side = create("Frame", {
        Size = UDim2.new(0, 2, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
    })
    side.Parent = notif
    corner(side, 6)

    local title = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 14),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = config.Title or "Void-UI",
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    title.Parent = notif

    local text = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 12, 0, 22),
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = self.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })
    text.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -230, 0, 40 + (idx - 1) * 54)
    }):Play()

    task.delay(config.Duration or 4, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, 0, 40 + (idx - 1) * 54)
        }):Play()
        task.wait(0.35)
        notif:Destroy()
        VoidUI.NotifyIndex = math.max(0, VoidUI.NotifyIndex - 1)
    end)
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

return VoidUI
