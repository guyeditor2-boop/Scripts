--[[
    Transparent Ultra UI
    Standalone Roblox Luau UI Library
    No external UI libraries required.

    Features:
    • Transparent glass UI
    • Draggable window
    • Mobile + PC support
    • Tabs
    • Buttons
    • Toggles
    • Sliders
    • Dropdowns
    • Keybinds
    • Textboxes
    • Search
    • Notifications
    • Minimize button "—"
    • Close button
    • Theme configuration
    • UI scaling
    • Smooth animations
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

--==================================================
-- CONFIG
--==================================================

Library.Theme = {
    Background = Color3.fromRGB(10, 10, 14),
    Secondary = Color3.fromRGB(18, 18, 24),
    Element = Color3.fromRGB(25, 25, 33),

    Accent = Color3.fromRGB(145, 90, 255),
    AccentDark = Color3.fromRGB(95, 55, 180),

    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(170, 170, 185),

    Border = Color3.fromRGB(255, 255, 255),

    Transparency = 0.18,
    ElementTransparency = 0.12,

    CornerRadius = 10
}

Library.Options = {
    AnimationSpeed = 0.18,
    MobileScale = 0.85,
    EnableBlur = true
}

--==================================================
-- INTERNAL UTILITIES
--==================================================

local function Tween(object, properties, duration)
    local info = TweenInfo.new(
        duration or Library.Options.AnimationSpeed,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

    return TweenService:Create(object, info, properties)
end

local function New(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    return object
end

local function Corner(parent, radius)
    local corner = New("UICorner", {
        CornerRadius = UDim.new(0, radius or Library.Theme.CornerRadius)
    })

    corner.Parent = parent
    return corner
end

local function Stroke(parent, color, transparency, thickness)
    local stroke = New("UIStroke", {
        Color = color or Library.Theme.Border,
        Transparency = transparency or 0.88,
        Thickness = thickness or 1
    })

    stroke.Parent = parent
    return stroke
end

local function Padding(parent, left, right, top, bottom)
    local padding = New("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0)
    })

    padding.Parent = parent
    return padding
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPosition

    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

--==================================================
-- GUI ROOT
--==================================================

local function GetGuiParent()
    local success, result = pcall(function()
        return CoreGui
    end)

    if success and result then
        return result
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

--==================================================
-- WINDOW
--==================================================

function Library:CreateWindow(config)
    config = config or {}

    local self = setmetatable({}, Library)

    self.Title = config.Title or "Ultra UI"
    self.Subtitle = config.Subtitle or "Transparent Interface"
    self.MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false

    local gui = New("ScreenGui", {
        Name = "TransparentUltraUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
    end)

    gui.Parent = GetGuiParent()

    self.Gui = gui

    --==================================================
    -- MAIN WINDOW
    --==================================================

    local Main = New("Frame", {
        Name = "MainWindow",
        Parent = gui,
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = Library.Theme.Transparency,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 720, 0, 460),
        Position = UDim2.new(0.5, -360, 0.5, -230),
        ClipsDescendants = true
    })

    self.Main = Main

    Corner(Main, 14)
    Stroke(Main, Library.Theme.Border, 0.86, 1)

    -- subtle background gradient
    local Gradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 42)),
            ColorSequenceKeypoint.new(0.5, Library.Theme.Background),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 17))
        }),
        Rotation = 35
    })

    Gradient.Parent = Main

    --==================================================
    -- TOP BAR
    --==================================================

    local TopBar = New("Frame", {
        Name = "TopBar",
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 66)
    })

    local Title = New("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 22, 0, 11),
        Size = UDim2.new(1, -150, 0, 27),
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = Library.Theme.Text,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Subtitle = New("TextLabel", {
        Name = "Subtitle",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 23, 0, 37),
        Size = UDim2.new(1, -160, 0, 18),
        Font = Enum.Font.Gotham,
        Text = self.Subtitle,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    --==================================================
    -- MINIMIZE
    --==================================================

    local Minimize = New("TextButton", {
        Name = "Minimize",
        Parent = TopBar,
        BackgroundColor3 = Library.Theme.Element,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(1, -83, 0, 17),
        Size = UDim2.new(0, 31, 0, 31),
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        Text = "—",
        TextColor3 = Library.Theme.Text,
        TextSize = 16
    })

    Corner(Minimize, 8)

    Minimize.MouseEnter:Connect(function()
        Tween(Minimize, {
            BackgroundTransparency = 0,
            BackgroundColor3 = Library.Theme.Accent
        }):Play()
    end)

    Minimize.MouseLeave:Connect(function()
        Tween(Minimize, {
            BackgroundTransparency = 0.15,
            BackgroundColor3 = Library.Theme.Element
        }):Play()
    end)

    --==================================================
    -- CLOSE
    --==================================================

    local Close = New("TextButton", {
        Name = "Close",
        Parent = TopBar,
        BackgroundColor3 = Library.Theme.Element,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(1, -45, 0, 17),
        Size = UDim2.new(0, 31, 0, 31),
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Library.Theme.Text,
        TextSize = 18
    })

    Corner(Close, 8)

    Close.MouseEnter:Connect(function()
        Tween(Close, {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(180, 55, 65)
        }):Play()
    end)

    Close.MouseLeave:Connect(function()
        Tween(Close, {
            BackgroundTransparency = 0.15,
            BackgroundColor3 = Library.Theme.Element
        }):Play()
    end)

    --==================================================
    -- BODY
    --==================================================

    local Body = New("Frame", {
        Name = "Body",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 66),
        Size = UDim2.new(1, -24, 1, -78)
    })

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar = New("Frame", {
        Name = "Sidebar",
        Parent = Body,
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.18,
        Size = UDim2.new(0, 175, 1, 0),
        ClipsDescendants = true
    })

    Corner(Sidebar, 11)
    Stroke(Sidebar, Library.Theme.Border, 0.91, 1)

    local TabList = New("ScrollingFrame", {
        Name = "TabList",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 7, 0, 10),
        Size = UDim2.new(1, -14, 1, -20),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        BorderSizePixel = 0
    })

    local TabLayout = New("UIListLayout", {
        Parent = TabList,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Padding(TabList, 2, 2, 2, 2)

    --==================================================
    -- CONTENT
    --==================================================

    local Content = New("Frame", {
        Name = "Content",
        Parent = Body,
        BackgroundColor3 = Library.Theme.Secondary,
        BackgroundTransparency = 0.22,
        Position = UDim2.new(0, 187, 0, 0),
        Size = UDim2.new(1, -187, 1, 0)
    })

    Corner(Content, 11)
    Stroke(Content, Library.Theme.Border, 0.91, 1)

    self.Content = Content
    self.TabList = TabList

    --==================================================
    -- DRAG
    --==================================================

    MakeDraggable(Main, TopBar)

    --==================================================
    -- MINIMIZE LOGIC
    --==================================================

    local normalSize = Main.Size

    local function SetMinimized(state)
        self.Minimized = state

        if state then
            Tween(Main, {
                Size = UDim2.new(0, normalSize.X.Offset, 0, 66)
            }):Play()

            Body.Visible = false
        else
            Body.Visible = true

            Tween(Main, {
                Size = normalSize
            }):Play()
        end
    end

    Minimize.MouseButton1Click:Connect(function()
        SetMinimized(not self.Minimized)
    end)

    Close.MouseButton1Click:Connect(function()
        Tween(Main, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()

        task.wait(0.2)
        gui:Destroy()
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == self.MinimizeKey then
            SetMinimized(not self.Minimized)
        end
    end)

    --==================================================
    -- MOBILE SCALING
    --==================================================

    local Camera = workspace.CurrentCamera

    local function UpdateScale()
        if not Camera then
            return
        end

        local viewport = Camera.ViewportSize

        local scale = Main:FindFirstChild("UIScale")

        if not scale then
            scale = Instance.new("UIScale")
            scale.Parent = Main
        end

        if viewport.X < 700 then
            scale.Scale = Library.Options.MobileScale
        else
            scale.Scale = 1
        end
    end

    UpdateScale()

    if Camera then
        Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
    end

    --==================================================
    -- TAB CREATION
    --==================================================

    function self:CreateTab(name)
        local Tab = {}

        Tab.Name = name
        Tab.Elements = {}

        local Button = New("TextButton", {
            Name = name .. "Tab",
            Parent = TabList,
            BackgroundColor3 = Library.Theme.Element,
            BackgroundTransparency = 0.65,
            Size = UDim2.new(1, 0, 0, 38),
            AutoButtonColor = false,
            Font = Enum.Font.GothamMedium,
            Text = "   " .. name,
            TextColor3 = Library.Theme.SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Corner(Button, 8)

        local Page = New("ScrollingFrame", {
            Name = name .. "Page",
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            BorderSizePixel = 0,
            Visible = false
        })

        local PageLayout = New("UIListLayout", {
            Parent = Page,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Padding(Page, 3, 3, 3, 3)

        Tab.Button = Button
        Tab.Page = Page

        local function Activate()
            for _, other in pairs(self.Tabs) do
                other.Page.Visible = false

                Tween(other.Button, {
                    BackgroundTransparency = 0.65,
                    BackgroundColor3 = Library.Theme.Element,
                    TextColor3 = Library.Theme.SubText
                }):Play()
            end

            Page.Visible = true

            Tween(Button, {
                BackgroundTransparency = 0.05,
                BackgroundColor3 = Library.Theme.Accent,
                TextColor3 = Library.Theme.Text
            }):Play()

            self.ActiveTab = Tab
        end

        Button.MouseButton1Click:Connect(Activate)

        table.insert(self.Tabs, Tab)

        if not self.ActiveTab then
            Activate()
        end

        --==================================================
        -- ELEMENT BASE
        --==================================================

        local function CreateBase(height)
            local Element = New("Frame", {
                Parent = Page,
                BackgroundColor3 = Library.Theme.Element,
                BackgroundTransparency = Library.Theme.ElementTransparency,
                Size = UDim2.new(1, 0, 0, height or 48)
            })

            Corner(Element, 9)
            Stroke(Element, Library.Theme.Border, 0.94, 1)

            return Element
        end

        --==================================================
        -- LABEL
        --==================================================

        function Tab:CreateLabel(text)
            local element = CreateBase(36)

            local label = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -26, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = text,
                TextColor3 = Library.Theme.SubText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            return element
        end

        --==================================================
        -- BUTTON
        --==================================================

        function Tab:CreateButton(config)
            config = config or {}

            local element = CreateBase(48)

            local title = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -125, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Button",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local button = New("TextButton", {
                Parent = element,
                BackgroundColor3 = Library.Theme.Accent,
                BackgroundTransparency = 0.08,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 85, 0, 30),
                AutoButtonColor = false,
                Font = Enum.Font.GothamMedium,
                Text = config.Text or "Execute",
                TextColor3 = Library.Theme.Text,
                TextSize = 11
            })

            Corner(button, 7)

            button.MouseEnter:Connect(function()
                Tween(button, {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(0, 90, 0, 31)
                }):Play()
            end)

            button.MouseLeave:Connect(function()
                Tween(button, {
                    BackgroundTransparency = 0.08,
                    Size = UDim2.new(0, 85, 0, 30)
                }):Play()
            end)

            button.MouseButton1Click:Connect(function()
                if config.Callback then
                    task.spawn(config.Callback)
                end
            end)

            return element
        end

        --==================================================
        -- TOGGLE
        --==================================================

        function Tab:CreateToggle(config)
            config = config or {}

            local element = CreateBase(48)

            local title = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -90, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Toggle",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local switch = New("TextButton", {
                Parent = element,
                BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                BackgroundTransparency = 0,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.new(0, 48, 0, 25),
                AutoButtonColor = false,
                Text = ""
            })

            Corner(switch, 13)

            local knob = New("Frame", {
                Parent = switch,
                BackgroundColor3 = Color3.fromRGB(220, 220, 225),
                Position = UDim2.new(0, 3, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18)
            })

            Corner(knob, 20)

            local enabled = config.Default or false

            local function Update()
                if enabled then
                    Tween(switch, {
                        BackgroundColor3 = Library.Theme.Accent
                    }):Play()

                    Tween(knob, {
                        Position = UDim2.new(1, -21, 0.5, -9)
                    }):Play()
                else
                    Tween(switch, {
                        BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                    }):Play()

                    Tween(knob, {
                        Position = UDim2.new(0, 3, 0.5, -9)
                    }):Play()
                end

                if config.Callback then
                    task.spawn(config.Callback, enabled)
                end
            end

            switch.MouseButton1Click:Connect(function()
                enabled = not enabled
                Update()
            end)

            Update()

            return {
                Set = function(_, value)
                    enabled = value
                    Update()
                end,

                Get = function()
                    return enabled
                end
            }
        end

        --==================================================
        -- SLIDER
        --==================================================

        function Tab:CreateSlider(config)
            config = config or {}

            local min = config.Min or 0
            local max = config.Max or 100
            local default = math.clamp(config.Default or min, min, max)

            local element = CreateBase(65)

            local title = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 7),
                Size = UDim2.new(1, -90, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Slider",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local valueLabel = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -13, 0, 7),
                Size = UDim2.new(0, 60, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = tostring(default),
                TextColor3 = Library.Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local bar = New("Frame", {
                Parent = element,
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Position = UDim2.new(0, 13, 0, 38),
                Size = UDim2.new(1, -26, 0, 7)
            })

            Corner(bar, 8)

            local fill = New("Frame", {
                Parent = bar,
                BackgroundColor3 = Library.Theme.Accent,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })

            Corner(fill, 8)

            local dragging = false
            local current = default

            local function SetValue(value)
                value = math.clamp(value, min, max)

                if config.Rounding then
                    value = math.floor(value / config.Rounding + 0.5) * config.Rounding
                end

                current = value

                local percent = (value - min) / (max - min)

                Tween(fill, {
                    Size = UDim2.new(percent, 0, 1, 0)
                }):Play()

                valueLabel.Text = tostring(value)

                if config.Callback then
                    task.spawn(config.Callback, value)
                end
            end

            local function Update(input)
                local percent = math.clamp(
                    (input.Position.X - bar.AbsolutePosition.X) /
                    bar.AbsoluteSize.X,
                    0,
                    1
                )

                SetValue(min + ((max - min) * percent))
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging then
                    if input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch then

                        Update(input)
                    end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    dragging = false
                end
            end)

            return {
                Set = function(_, value)
                    SetValue(value)
                end,

                Get = function()
                    return current
                end
            }
        end

        --==================================================
        -- DROPDOWN
        --==================================================

        function Tab:CreateDropdown(config)
            config = config or {}

            local options = config.Options or {}
            local current = config.Default or options[1] or "None"

            local element = CreateBase(48)

            local title = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -180, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Dropdown",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local dropdown = New("TextButton", {
                Parent = element,
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                BackgroundTransparency = 0.1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 145, 0, 31),
                AutoButtonColor = false,
                Font = Enum.Font.GothamMedium,
                Text = tostring(current) .. "  ▼",
                TextColor3 = Library.Theme.SubText,
                TextSize = 11
            })

            Corner(dropdown, 7)

            local list = New("Frame", {
                Parent = element,
                BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.03,
                Position = UDim2.new(0, 0, 1, 5),
                Size = UDim2.new(1, 0, 0, 0),
                Visible = false,
                ZIndex = 20,
                ClipsDescendants = true
            })

            Corner(list, 8)
            Stroke(list, Library.Theme.Border, 0.88, 1)

            local layout = New("UIListLayout", {
                Parent = list,
                Padding = UDim.new(0, 3)
            })

            Padding(list, 5, 5, 5, 5)

            local opened = false

            local function Rebuild()
                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(options) do
                    local optionButton = New("TextButton", {
                        Parent = list,
                        BackgroundColor3 = Library.Theme.Element,
                        BackgroundTransparency = 0.4,
                        Size = UDim2.new(1, 0, 0, 30),
                        AutoButtonColor = false,
                        Font = Enum.Font.Gotham,
                        Text = tostring(option),
                        TextColor3 = Library.Theme.Text,
                        TextSize = 11,
                        ZIndex = 21
                    })

                    Corner(optionButton, 6)

                    optionButton.MouseButton1Click:Connect(function()
                        current = option
                        dropdown.Text = tostring(option) .. "  ▼"

                        opened = false
                        list.Visible = false

                        Tween(list, {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()

                        if config.Callback then
                            task.spawn(config.Callback, option)
                        end
                    end)
                end
            end

            dropdown.MouseButton1Click:Connect(function()
                opened = not opened

                if opened then
                    list.Visible = true

                    local height = math.min(#options * 33 + 10, 180)

                    Tween(list, {
                        Size = UDim2.new(1, 0, 0, height)
                    }):Play()
                else
                    Tween(list, {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()

                    task.delay(0.18, function()
                        if not opened then
                            list.Visible = false
                        end
                    end)
                end
            end)

            Rebuild()

            return {
                Set = function(_, value)
                    current = value
                    dropdown.Text = tostring(value) .. "  ▼"

                    if config.Callback then
                        task.spawn(config.Callback, value)
                    end
                end,

                Get = function()
                    return current
                end,

                Refresh = function(_, newOptions)
                    options = newOptions
                    Rebuild()
                end
            }
        end

        --==================================================
        -- TEXTBOX
        --==================================================

        function Tab:CreateInput(config)
            config = config or {}

            local element = CreateBase(52)

            local title = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(0.45, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Input",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local input = New("TextBox", {
                Parent = element,
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                BackgroundTransparency = 0.05,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 170, 0, 31),
                ClearTextOnFocus = false,
                Font = Enum.Font.Gotham,
                PlaceholderText = config.Placeholder or "Type here...",
                PlaceholderColor3 = Library.Theme.SubText,
                Text = config.Default or "",
                TextColor3 = Library.Theme.Text,
                TextSize = 11
            })

            Corner(input, 7)

            input.FocusLost:Connect(function()
                if config.Callback then
                    task.spawn(config.Callback, input.Text)
                end
            end)

            return input
        end

        --==================================================
        -- KEYBIND
        --==================================================

        function Tab:CreateKeybind(config)
            config = config or {}

            local element = CreateBase(48)

            local title = New("TextLabel", {
                Parent = element,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 13, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = config.Name or "Keybind",
                TextColor3 = Library.Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local bind = New("TextButton", {
                Parent = element,
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 90, 0, 30),
                AutoButtonColor = false,
                Font = Enum.Font.GothamMedium,
                Text = (config.Default or Enum.KeyCode.RightControl).Name,
                TextColor3 = Library.Theme.Text,
                TextSize = 11
            })

            Corner(bind, 7)

            local currentKey = config.Default or Enum.KeyCode.RightControl
            local listening = false

            bind.MouseButton1Click:Connect(function()
                listening = true
                bind.Text = "Press key..."
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        bind.Text = currentKey.Name
                        listening = false
                    end

                    return
                end

                if not processed and input.KeyCode == currentKey then
                    if config.Callback then
                        task.spawn(config.Callback, currentKey)
                    end
                end
            end)

            return {
                Set = function(_, key)
                    currentKey = key
                    bind.Text = key.Name
                end,

                Get = function()
                    return currentKey
                end
            }
        end

        --==================================================
        -- SEPARATOR
        --==================================================

        function Tab:CreateSeparator()
            local separator = New("Frame", {
                Parent = Page,
                BackgroundColor3 = Library.Theme.Border,
                BackgroundTransparency = 0.92,
                Size = UDim2.new(1, 0, 0, 1)
            })

            return separator
        end

        --==================================================
        -- SEARCH SUPPORT
        --==================================================

        Tab._PageLayout = PageLayout

        return Tab
    end

    --==================================================
    -- NOTIFICATION SYSTEM
    --==================================================

    function self:Notify(config)
        config = config or {}

        local holder = gui:FindFirstChild("Notifications")

        if not holder then
            holder = New("Frame", {
                Name = "Notifications",
                Parent = gui,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, -18, 1, -18),
                Size = UDim2.new(0, 310, 1, -30)
            })

            local layout = New("UIListLayout", {
                Parent = holder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 8)
            })
        end

        local notification = New("Frame", {
            Parent = holder,
            BackgroundColor3 = Library.Theme.Secondary,
            BackgroundTransparency = 0.08,
            Size = UDim2.new(0, 290, 0, 70)
        })

        Corner(notification, 10)
        Stroke(notification, Library.Theme.Border, 0.88, 1)

        local accent = New("Frame", {
            Parent = notification,
            BackgroundColor3 = Library.Theme.Accent,
            Size = UDim2.new(0, 3, 1, -16),
            Position = UDim2.new(0, 7, 0, 8)
        })

        Corner(accent, 5)

        local title = New("TextLabel", {
            Parent = notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 22, 0, 10),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = config.Title or "Notification",
            TextColor3 = Library.Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local message = New("TextLabel", {
            Parent = notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 22, 0, 31),
            Size = UDim2.new(1, -30, 0, 28),
            Font = Enum.Font.Gotham,
            Text = config.Content or "",
            TextColor3 = Library.Theme.SubText,
            TextSize = 10,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })

        notification.Position = UDim2.new(1, 320, 0, 0)

        Tween(notification, {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()

        task.delay(config.Duration or 3, function()
            if notification and notification.Parent then
                local tween = Tween(notification, {
                    Position = UDim2.new(1, 320, 0, 0)
                })

                tween:Play()

                tween.Completed:Wait()

                notification:Destroy()
            end
        end)

        return notification
    end

    --==================================================
    -- SEARCH BAR
    --==================================================

    function self:CreateSearch()
        local search = New("TextBox", {
            Name = "Search",
            Parent = TopBar,
            BackgroundColor3 = Library.Theme.Element,
            BackgroundTransparency = 0.2,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -122, 0, 18),
            Size = UDim2.new(0, 130, 0, 30),
            ClearTextOnFocus = false,
            Font = Enum.Font.Gotham,
            PlaceholderText = "Search...",
            PlaceholderColor3 = Library.Theme.SubText,
            Text = "",
            TextColor3 = Library.Theme.Text,
            TextSize = 10
        })

        Corner(search, 7)

        search.FocusLost:Connect(function()
            local query = string.lower(search.Text)

            if query == "" then
                return
            end

            for _, tab in ipairs(self.Tabs) do
                if string.find(string.lower(tab.Name), query, 1, true) then
                    tab.Button:Activate()
                    return
                end
            end
        end)

        return search
    end

    return self
end

--==================================================
-- DEFAULT USAGE EXAMPLE
--==================================================

local Window = Library:CreateWindow({
    Title = "Ultra Glass UI",
    Subtitle = "Transparent • Mobile Friendly • 4K Ready",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Main = Window:CreateTab("Main")

Main:CreateLabel("Welcome to the transparent interface.")

Main:CreateButton({
    Name = "Test Button",
    Text = "Execute",
    Callback = function()
        Window:Notify({
            Title = "Success",
            Content = "The button is working correctly.",
            Duration = 3
        })
    end
})

Main:CreateToggle({
    Name = "Example Toggle",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

Main:CreateSlider({
    Name = "Example Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})

Main:CreateDropdown({
    Name = "Example Dropdown",
    Options = {
        "Option 1",
        "Option 2",
        "Option 3",
        "Option 4"
    },
    Default = "Option 1",
    Callback = function(value)
        print("Selected:", value)
    end
})

Main:CreateInput({
    Name = "Username",
    Placeholder = "Enter username...",
    Callback = function(text)
        print("Input:", text)
    end
})

Main:CreateKeybind({
    Name = "Example Keybind",
    Default = Enum.KeyCode.G,
    Callback = function(key)
        Window:Notify({
            Title = "Keybind",
            Content = key.Name .. " was pressed.",
            Duration = 2
        })
    end
})

local Settings = Window:CreateTab("Settings")

Settings:CreateLabel("Interface Settings")

Settings:CreateToggle({
    Name = "Example Setting",
    Default = true,
    Callback = function(value)
        print("Setting:", value)
    end
})

Window:CreateSearch()

Window:Notify({
    Title = "Ultra Glass UI",
    Content = "Interface loaded successfully.",
    Duration = 4
})

return Library
