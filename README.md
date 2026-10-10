<div align="center">

# ◈ Void-UI

**Modern & Lightweight UI Library for Roblox Executors**

[![Version](https://img.shields.io/badge/version-1.0-783CFF?style=for-the-badge)](https://github.com/alexgamingofficial2026-del/Void-UI)
[![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?style=for-the-badge&logo=lua)](https://www.lua.org/)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

A modern, lightweight and customizable UI library for Roblox scripts.

[Features](#-features) • [Installation](#-installation) • [Usage](#-quick-start) • [Components](#-components)

</div>

---

## 📖 Description

**Void-UI** is a UI library written in **Luau** for Roblox executors such as Delta, Fluxus, Wave, Solara and Xeno.

- ⚡ **Fast** — Animations powered by `TweenService`
- 🎨 **Modern** — Dark design with purple accent
- 📦 **Lightweight** — No external dependencies
- 🔧 **Easy** — Intuitive API in 3 lines

---

## ✨ Features

| Feature | Status |
|---------|:------:|
| Draggable window | ✅ |
| Minimize / Close animation | ✅ |
| Toggle key (hide/show) | ✅ |
| Tabs with sidebar | ✅ |
| Section separators | ✅ |
| Toggle switch | ✅ |
| Button with hover | ✅ |
| Numeric slider | ✅ |
| TextBox | ✅ |
| Dropdown | ✅ |
| Keybind | ✅ |
| Notifications | ✅ |
| Save / Load config | ✅ |

---

## 🚀 Installation

```lua
local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/alexgamingofficial2026-del/Void-UI/main/Void-UI.lua"))()
```

---

## 🎯 Quick Start

```lua
-- 1. Load the library
local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/alexgamingofficial2026-del/Void-UI/main/Void-UI.lua"))()

-- 2. Create the window
local Window = VoidUI:CreateWindow({
    Name = "My Script",
    Subtitle = "v1.0 by Alex",
    ToggleKey = Enum.KeyCode.RightShift
})

-- 3. Create a tab
local MainTab = Window:CreateTab("Main")

-- 4. Add components
MainTab:CreateButton({
    Name = "Hello world!",
    Callback = function()
        VoidUI:Notify({
            Title = "Void-UI",
            Text = "Working!"
        })
    end
})
```

---

## 🧩 Components

### Window
```lua
local Window = VoidUI:CreateWindow({
    Name = "Void-UI Demo",
    Subtitle = "by Alex",
    ToggleKey = Enum.KeyCode.RightShift
})
```

### Tab
```lua
local Tab = Window:CreateTab("Name")
```

### Section
```lua
Tab:CreateSection("Movement")
```

### Toggle
```lua
Tab:CreateToggle({
    Name = "Speed Hack",
    Default = false,
    Flag = "SpeedFlag",
    Callback = function(state)
       ` print("State:", state)
    end
})
```

### Button
```lua
Tab:CreateButton({
    Name = "Execute",
    Callback = function()
        print("Click!")
    end
})
```

### Slider
```lua
Tab:CreateSlider({
    Name = "Speed",
    Min = 16,
    Max = 300,
    Default = 16,
    Flag = "Speed",
    Callback = function(value)
        print("Value:", value)
    end
})
```

### TextBox
```lua
Tab:CreateTextBox({
    Name = "Message",
    Placeholder = "Type here...",
    Callback = function(text)
        print("You typed:", text)
    end
})
```

### Dropdown
```lua
Tab:CreateDropdown({
    Name = "Theme",
    Options = { "Purple", "Blue", "Red", "Green" },
    Default = "Purple",
    Flag = "Theme",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
```

### Keybind
```lua
Tab:CreateKeybind({
    Name = "Quick key",
    Default = Enum.KeyCode.F,
    Flag = "MyKey",
    Callback = function()
        print("Key pressed!")
    end
})
```

### Label
```lua
Tab:CreateLabel("Informative text")
```

### Notification
```lua
VoidUI:Notify({
    Title = "Void-UI",
    Text = "Script loaded successfully",
    Duration = 4
})
```

### Save / Load config
```lua
Window:SaveConfig("my_config.json")
Window:LoadConfig("my_config.json")
```

### Destroy UI
```lua
VoidUI:Destroy()
```

---

## 🎨 Theme Customization

```lua
VoidUI.Theme.Accent     = Color3.fromRGB(0, 170, 255)  -- Blue
VoidUI.Theme.Background = Color3.fromRGB(15, 15, 15)   -- Background
VoidUI.Theme.Text       = Color3.fromRGB(255, 255, 255)
```

### Default Palette

| Name | Hex |
|------|-----|
| `Background` | `#0F0F14` |
| `Panel` | `#16161E` |
| `Secondary` | `#1E1E28` |
| `Accent` | `#783CFF` |
| `AccentHover` | `#915AFF` |
| `Text | `#F0F0FA` |
| `SubText` | `#9191A5` |
| `Stroke` | `#2A2A37` |
| `Danger` | `#DC3C3C` |
| `Success` | `#3CC878` |

---

## 📦 Project Structure

```
Void-UI/
├── Void-UI.lua      # Main library
├── README.md        # This file
├── LICENSE          # MIT License
└── examples/
    └── demo.lua     # Example script
```

---

## 🤝 Compatibility

| Executor | Status |
|----------|:------:|
| Delta | ✅ |
| Fluxus | ✅ |
| Wave | ✅ |
| Solara | ✅ |
| Xeno | ✅ |
| Hydrogen | ✅ |
| Codex | ✅ |

---

## ⚠️ Legal Notice

> This project is for **educational purposes only**. Using executors **violates the Roblox Terms of Service** and may result in a **permanent account ban**. The developers of Void-UI are **not responsible** for any misuse.

---

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Alex** — [@alexgamingofficial2026-del](https://github.com/alexgamingofficial2026-del)

Repo: [Void-UI](https://github.com/alexgamingofficial2026-del/Void-UI)

---

<div align="center">

**⭐ If you like Void-UI, give the repo a star ⭐**

Made with 💜 by Alex

</div>
