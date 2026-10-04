--[[
    ╔══════════════════════════════════════════════════════╗
    ║                 ULTRA GLASS UI v2                    ║
    ║       Advanced Standalone Roblox Luau UI Library     ║
    ╠══════════════════════════════════════════════════════╣
    ║  • Transparent Glass UI                              ║
    ║  • Responsive PC / Mobile                           ║
    ║  • Dynamic Themes                                    ║
    ║  • Window Drag / Resize / Minimize                  ║
    ║  • Tabs + Sections                                   ║
    ║  • Buttons                                           ║
    ║  • Toggles                                           ║
    ║  • Sliders                                           ║
    ║  • Dropdowns                                         ║
    ║  • Multi Dropdowns                                   ║
    ║  • Color Picker                                      ║
    ║  • Keybinds                                          ║
    ║  • Text Inputs                                       ║
    ║  • Paragraphs                                         ║
    ║  • Notifications                                     ║
    ║  • Search                                             ║
    ║  • State / Config API                                ║
    ║  • Runtime Theme Switching                           ║
    ║  • Cleanup / Destroy API                             ║
    ║  • No external UI dependency                         ║
    ╚══════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

--========================================================
-- DEFAULT CONFIG
--========================================================

Library.Config = {
    AnimationSpeed = 0.18,
    MobileScale = 0.78,
    DesktopScale = 1,

    DefaultWidth = 760,
    DefaultHeight = 500,

    MinWidth = 520,
    MinHeight = 350,

    Transparency = 0.16,
    ElementTransparency = 0.08,

    EnableBlur = false,
    EnableShadows = true,

    SavePosition = true,
    Draggable = true,
    Resizable = true
}

--========================================================
-- THEMES
--========================================================

Library.Themes = {

    Dark = {
        Background = Color3.fromRGB(9, 10, 14),
        Secondary = Color3.fromRGB(16, 17, 23),
        Element = Color3.fromRGB(25, 26, 34),

        Accent = Color3.fromRGB(145, 90, 255),
        AccentDark = Color3.fromRGB(96, 55, 180),

        Text = Color3.fromRGB(245, 245, 250),
        SubText = Color3.fromRGB(165, 168, 180),

        Border = Color3.fromRGB(255, 255, 255),

        Success = Color3.fromRGB(65, 210, 130),
        Warning = Color3.fromRGB(245, 180, 65),
        Error = Color3.fromRGB(230, 75, 85)
    },

    Purple = {
        Background = Color3.fromRGB(13, 9, 20),
        Secondary = Color3.fromRGB(23, 15, 33),
        Element = Color3.fromRGB(35, 22, 48),

        Accent = Color3.fromRGB(180, 90, 255),
        AccentDark = Color3.fromRGB(115, 50, 190),

        Text = Color3.fromRGB(250, 245, 255),
        SubText = Color3.fromRGB(185, 165, 200),

        Border = Color3.fromRGB(255, 255, 255),

        Success = Color3.fromRGB(65, 210, 130),
        Warning = Color3.fromRGB(245, 180, 65),
        Error = Color3.fromRGB(230, 75, 85)
    },

    Red = {
        Background = Color3.fromRGB(15, 9, 10),
        Secondary = Color3.fromRGB(27, 15, 17),
        Element = Color3.fromRGB(40, 22, 25),

        Accent = Color3.fromRGB(235, 65, 80),
        AccentDark = Color3.fromRGB(165, 40, 50),

        Text = Color3.fromRGB(255, 245, 246),
        SubText = Color3.fromRGB(200, 165, 170),

        Border = Color3.fromRGB(255, 255, 255),

        Success = Color3.fromRGB(65, 210, 130),
        Warning = Color3.fromRGB(245, 180, 65),
        Error = Color3.fromRGB(255, 70, 80)
    },

    Blue = {
        Background = Color3.fromRGB(8, 12, 18),
        Secondary = Color3.fromRGB(13, 20, 30),
        Element = Color3.fromRGB(21, 31, 44),

        Accent = Color3.fromRGB(70, 145, 255),
        AccentDark = Color3.fromRGB(45, 90, 185),

        Text = Color3.fromRGB(240, 248, 255),
        SubText = Color3.fromRGB(160, 180, 200),

        Border = Color3.fromRGB(255, 255, 255),

        Success = Color3.fromRGB(65, 210, 130),
        Warning = Color3.fromRGB(245, 180, 65),
        Error = Color3.fromRGB(230, 75, 85)
    }
}

Library.Theme = Library.Themes.Dark

--========================================================
-- UTILITIES
--========================================================

local function Tween(object, properties, duration)
    if not object or not object.Parent then
        return
    end

    local info = TweenInfo.new(
        duration or Library.Config.AnimationSpeed,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

    return TweenService:Create(object, info, properties)
end

local function New(class, properties)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    return object
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 9)
    c.Parent = parent
    return c
end

local function Stroke(parent, transparency, thickness)
    local s = Instance.new("UIStroke")

    s.Color = Library.Theme.Border
    s.Transparency = transparency or 0.88
    s.Thickness = thickness or 1

    s.Parent = parent

    return s
end

local function Padding(parent, amount)
    local p = Instance.new("UIPadding")

    p.PaddingLeft = UDim.new(0, amount)
    p.PaddingRight = UDim.new(0, amount)
    p.PaddingTop = UDim.new(0, amount)
    p.PaddingBottom = UDim.new(0, amount)

    p.Parent = parent

    return p
end

local function ClampNumber(value, min, max)
    return math.clamp(tonumber(value) or min, min, max)
end

--========================================================
-- CONNECTION MANAGER
--========================================================

function Library:_Connect(signal, callback)
    local connection = signal:Connect(callback)

    self._Connections = self._Connections or {}
    table.insert(self._Connections, connection)

    return connection
end

function Library:_Cleanup()
    if not self._Connections then
        return
    end

    for _, connection in ipairs(self._Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    self._Connections = {}
end

--========================================================
-- DRAG SYSTEM
--========================================================

local function MakeDraggable(window, handle, library)
    local dragging = false
    local dragStart
    local startPosition

    library:_Connect(handle.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = window.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    library:_Connect(UserInputService.InputChanged, function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

--========================================================
-- WINDOW
--========================================================

function Library:CreateWindow(options)

    options = options or {}

    local self = setmetatable({}, Library)

    self.Title = options.Title or "Ultra Glass"
    self.Subtitle = options.Subtitle or "Advanced Interface"

    self.Tabs = {}
    self.Elements = {}
    self.Flags = {}

    self.Minimized = false
    self.Destroyed = false

    self.Theme = options.Theme or Library.Theme

    --====================================================
    -- GUI
    --====================================================

    local parent

    local success = pcall(function()
        parent = game:GetService("CoreGui")
    end)

    if not success or not parent then
        parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local ScreenGui = New("ScreenGui", {
        Name = "UltraGlassUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    ScreenGui.Parent = parent

    self.Gui = ScreenGui

    --====================================================
    -- MAIN WINDOW
    --====================================================

    local Window = New("Frame", {
        Name = "Window",
        Parent = ScreenGui,

        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = Library.Config.Transparency,

        BorderSizePixel = 0,

        Position = UDim2.new(
            0.5,
            -Library.Config.DefaultWidth / 2,
            0.5,
            -Library.Config.DefaultHeight / 2
        ),

        Size = UDim2.new(
            0,
            Library.Config.DefaultWidth,
            0,
            Library.Config.DefaultHeight
        ),

        ClipsDescendants = true
    })

    self.Window = Window

    Corner(Window, 15)
    Stroke(Window, 0.84, 1)

    --====================================================
    -- BACKGROUND GRADIENT
    --====================================================

    local Gradient = New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                self.Theme.Element
            ),

            ColorSequenceKeypoint.new(
                0.5,
                self.Theme.Background
            ),

            ColorSequenceKeypoint.new(
                1,
                self.Theme.Secondary
            )
        }),

        Rotation = 35
    })

    Gradient.Parent = Window

    --====================================================
    -- TOP BAR
    --====================================================

    local TopBar = New("Frame", {
        Name = "TopBar",
        Parent = Window,

        BackgroundTransparency = 1,

        Size = UDim2.new(1, 0, 0, 72)
    })

    self.TopBar = TopBar

    local Title = New("TextLabel", {
        Parent = TopBar,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 22, 0, 11),

        Size = UDim2.new(0, 300, 0, 27),

        Font = Enum.Font.GothamBold,

        Text = self.Title,

        TextColor3 = self.Theme.Text,

        TextSize = 19,

        TextXAlignment = Enum.TextXAlignment.Left
    })

    self.TitleLabel = Title

    local Subtitle = New("TextLabel", {
        Parent = TopBar,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 23, 0, 39),

        Size = UDim2.new(0, 350, 0, 18),

        Font = Enum.Font.Gotham,

        Text = self.Subtitle,

        TextColor3 = self.Theme.SubText,

        TextSize = 10,

        TextXAlignment = Enum.TextXAlignment.Left
    })

    --====================================================
    -- WINDOW CONTROLS
    --====================================================

    local Minimize = New("TextButton", {
        Parent = TopBar,

        BackgroundColor3 = self.Theme.Element,
        BackgroundTransparency = 0.12,

        Position = UDim2.new(1, -83, 0, 19),

        Size = UDim2.new(0, 30, 0, 30),

        AutoButtonColor = false,

        Font = Enum.Font.GothamBold,

        Text = "—",

        TextColor3 = self.Theme.Text,

        TextSize = 15
    })

    Corner(Minimize, 8)

    local Close = New("TextButton", {
        Parent = TopBar,

        BackgroundColor3 = self.Theme.Element,
        BackgroundTransparency = 0.12,

        Position = UDim2.new(1, -46, 0, 19),

        Size = UDim2.new(0, 30, 0, 30),

        AutoButtonColor = false,

        Font = Enum.Font.GothamBold,

        Text = "×",

        TextColor3 = self.Theme.Text,

        TextSize = 18
    })

    Corner(Close, 8)

    self.MinimizeButton = Minimize
    self.CloseButton = Close

    --====================================================
    -- BODY
    --====================================================

    local Body = New("Frame", {
        Parent = Window,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 12, 0, 72),

        Size = UDim2.new(1, -24, 1, -84)
    })

    self.Body = Body

    --====================================================
    -- SIDEBAR
    --====================================================

    local Sidebar = New("Frame", {
        Parent = Body,

        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.18,

        Size = UDim2.new(0, 180, 1, 0)
    })

    Corner(Sidebar, 11)
    Stroke(Sidebar, 0.9, 1)

    self.Sidebar = Sidebar

    local TabList = New("ScrollingFrame", {
        Parent = Sidebar,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 7, 0, 8),

        Size = UDim2.new(1, -14, 1, -16),

        BorderSizePixel = 0,

        ScrollBarThickness = 2,

        ScrollBarImageColor3 = self.Theme.Accent,

        AutomaticCanvasSize = Enum.AutomaticSize.Y,

        CanvasSize = UDim2.new()
    })

    Padding(TabList, 2)

    local TabLayout = New("UIListLayout", {
        Parent = TabList,

        Padding = UDim.new(0, 5),

        SortOrder = Enum.SortOrder.LayoutOrder
    })

    self.TabList = TabList

    --====================================================
    -- CONTENT
    --====================================================

    local Content = New("Frame", {
        Parent = Body,

        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 0.22,

        Position = UDim2.new(0, 190, 0, 0),

        Size = UDim2.new(1, -190, 1, 0)
    })

    Corner(Content, 11)
    Stroke(Content, 0.91, 1)

    self.Content = Content

    --====================================================
    -- DRAG
    --====================================================

    if Library.Config.Draggable then
        MakeDraggable(Window, TopBar, self)
    end

    --====================================================
    -- SCALE
    --====================================================

    local Scale = New("UIScale", {
        Scale = 1
    })

    Scale.Parent = Window

    self.Scale = Scale

    local function UpdateScale()
        local camera = workspace.CurrentCamera

        if not camera then
            return
        end

        local viewport = camera.ViewportSize

        if viewport.X < 700 then
            Scale.Scale = Library.Config.MobileScale
        else
            Scale.Scale = Library.Config.DesktopScale
        end
    end

    UpdateScale()

    self:_Connect(
        workspace:GetPropertyChangedSignal("CurrentCamera"),
        UpdateScale
    )

    if workspace.CurrentCamera then
        self:_Connect(
            workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),
            UpdateScale
        )
    end

    --====================================================
    -- MINIMIZE
    --====================================================

    local fullSize = Window.Size

    self:_Connect(Minimize.MouseButton1Click, function()

        self.Minimized = not self.Minimized

        if self.Minimized then

            Body.Visible = false

            Tween(Window, {
                Size = UDim2.new(
                    fullSize.X.Scale,
                    fullSize.X.Offset,
                    0,
                    72
                )
            }):Play()

        else

            Body.Visible = true

            Tween(Window, {
                Size = fullSize
            }):Play()

        end

    end)

    --====================================================
    -- CLOSE
    --====================================================

    self:_Connect(Close.MouseButton1Click, function()
        self:Destroy()
    end)

    --====================================================
    -- HOVER
    --====================================================

    self:_Connect(Minimize.MouseEnter, function()

        Tween(Minimize, {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0
        }):Play()

    end)

    self:_Connect(Minimize.MouseLeave, function()

        Tween(Minimize, {
            BackgroundColor3 = self.Theme.Element,
            BackgroundTransparency = 0.12
        }):Play()

    end)

    self:_Connect(Close.MouseEnter, function()

        Tween(Close, {
            BackgroundColor3 = self.Theme.Error,
            BackgroundTransparency = 0
        }):Play()

    end)

    self:_Connect(Close.MouseLeave, function()

        Tween(Close, {
            BackgroundColor3 = self.Theme.Element,
            BackgroundTransparency = 0.12
        }):Play()

    end)

    --====================================================
    -- CREATE TAB
    --====================================================

    function self:CreateTab(name, icon)

        local Tab = {}

        Tab.Name = name
        Tab.Elements = {}

        --===============================================
        -- TAB BUTTON
        --===============================================

        local Button = New("TextButton", {
            Parent = TabList,

            BackgroundColor3 = self.Theme.Element,
            BackgroundTransparency = 0.55,

            Size = UDim2.new(1, 0, 0, 40),

            AutoButtonColor = false,

            Font = Enum.Font.GothamMedium,

            Text = (icon and icon .. "   " or "") .. name,

            TextColor3 = self.Theme.SubText,

            TextSize = 11,

            TextXAlignment = Enum.TextXAlignment.Left
        })

        Corner(Button, 8)

        Padding(Button, 12)

        Tab.Button = Button

        --===============================================
        -- PAGE
        --===============================================

        local Page = New("ScrollingFrame", {
            Parent = Content,

            BackgroundTransparency = 1,

            Position = UDim2.new(0, 11, 0, 11),

            Size = UDim2.new(1, -22, 1, -22),

            BorderSizePixel = 0,

            ScrollBarThickness = 2,

            ScrollBarImageColor3 = self.Theme.Accent,

            AutomaticCanvasSize = Enum.AutomaticSize.Y,

            CanvasSize = UDim2.new(),

            Visible = false
        })

        Padding(Page, 2)

        local Layout = New("UIListLayout", {
            Parent = Page,

            Padding = UDim.new(0, 8),

            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Tab.Page = Page

        --===============================================
        -- ACTIVATE
        --===============================================

        function Tab:Activate()

            for _, other in ipairs(self.Parent.Tabs) do

                other.Page.Visible = false

                Tween(other.Button, {
                    BackgroundColor3 = self.Theme.Element,
                    BackgroundTransparency = 0.55,
                    TextColor3 = self.Theme.SubText
                }):Play()

            end

            Page.Visible = true

            Tween(Button, {
                BackgroundColor3 = self.Theme.Accent,
                BackgroundTransparency = 0.08,
                TextColor3 = self.Theme.Text
            }):Play()

            self.ActiveTab = Tab
        end

        self:_Connect(Button.MouseButton1Click, function()
            Tab:Activate()
        end)

        Tab.Parent = self

        table.insert(self.Tabs, Tab)

        if #self.Tabs == 1 then
            Tab:Activate()
        end

        --================================================
        -- COMPONENT FACTORY
        --================================================

        local function Base(height)

            local Frame = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Element,

                BackgroundTransparency =
                    Library.Config.ElementTransparency,

                Size = UDim2.new(1, 0, 0, height or 50)
            })

            Corner(Frame, 9)
            Stroke(Frame, 0.94, 1)

            return Frame
        end

        --================================================
        -- SECTION
        --================================================

        function Tab:CreateSection(title)

            local section = New("TextLabel", {
                Parent = Page,

                BackgroundTransparency = 1,

                Size = UDim2.new(1, 0, 0, 27),

                Font = Enum.Font.GothamBold,

                Text = title,

                TextColor3 = self.Theme.SubText,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            Padding(section, 4)

            return section
        end

        --================================================
        -- LABEL
        --================================================

        function Tab:CreateLabel(text)

            local frame = Base(38)

            local label = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(1, -26, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = text,

                TextColor3 = self.Theme.SubText,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            return frame
        end

        --================================================
        -- PARAGRAPH
        --================================================

        function Tab:CreateParagraph(config)

            config = config or {}

            local frame = Base(config.Height or 75)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 8),

                Size = UDim2.new(1, -26, 0, 20),

                Font = Enum.Font.GothamBold,

                Text = config.Title or "Information",

                TextColor3 = self.Theme.Text,

                TextSize = 12,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local description = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 31),

                Size = UDim2.new(1, -26, 1, -38),

                Font = Enum.Font.Gotham,

                Text = config.Content or "",

                TextColor3 = self.Theme.SubText,

                TextSize = 10,

                TextWrapped = true,

                TextXAlignment = Enum.TextXAlignment.Left,

                TextYAlignment = Enum.TextYAlignment.Top
            })

            return frame
        end

        --================================================
        -- BUTTON
        --================================================

        function Tab:CreateButton(config)

            config = config or {}

            local frame = Base(50)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(1, -130, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Button",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Button = New("TextButton", {
                Parent = frame,

                BackgroundColor3 = self.Theme.Accent,

                BackgroundTransparency = 0.08,

                AnchorPoint = Vector2.new(1, 0.5),

                Position = UDim2.new(1, -10, 0.5, 0),

                Size = UDim2.new(0, 90, 0, 31),

                AutoButtonColor = false,

                Font = Enum.Font.GothamMedium,

                Text = config.Text or "Execute",

                TextColor3 = self.Theme.Text,

                TextSize = 10
            })

            Corner(Button, 7)

            self:_Connect(Button.MouseEnter, function()

                Tween(Button, {
                    BackgroundTransparency = 0
                }):Play()

            end)

            self:_Connect(Button.MouseLeave, function()

                Tween(Button, {
                    BackgroundTransparency = 0.08
                }):Play()

            end)

            self:_Connect(Button.MouseButton1Click, function()

                if config.Callback then
                    task.spawn(config.Callback)
                end

            end)

            return {
                Instance = frame,
                Button = Button
            }
        end

        --================================================
        -- TOGGLE
        --================================================

        function Tab:CreateToggle(config)

            config = config or {}

            local frame = Base(50)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(1, -100, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Toggle",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = New("TextButton", {
                Parent = frame,

                BackgroundColor3 = Color3.fromRGB(45, 46, 55),

                Position = UDim2.new(1, -62, 0.5, -13),

                Size = UDim2.new(0, 49, 0, 26),

                AutoButtonColor = false,

                Text = ""
            })

            Corner(Switch, 20)

            local Knob = New("Frame", {
                Parent = Switch,

                BackgroundColor3 = Color3.fromRGB(225, 225, 230),

                Position = UDim2.new(0, 4, 0.5, -9),

                Size = UDim2.new(0, 18, 0, 18)
            })

            Corner(Knob, 20)

            local value = config.Default == true

            local function Update(fire)

                if value then

                    Tween(Switch, {
                        BackgroundColor3 = self.Theme.Accent
                    }):Play()

                    Tween(Knob, {
                        Position = UDim2.new(1, -22, 0.5, -9)
                    }):Play()

                else

                    Tween(Switch, {
                        BackgroundColor3 =
                            Color3.fromRGB(45, 46, 55)
                    }):Play()

                    Tween(Knob, {
                        Position = UDim2.new(0, 4, 0.5, -9)
                    }):Play()

                end

                if fire and config.Callback then
                    task.spawn(config.Callback, value)
                end
            end

            self:_Connect(Switch.MouseButton1Click, function()

                value = not value

                Update(true)

            end)

            Update(false)

            local object = {}

            function object:Set(newValue)

                value = newValue == true

                Update(true)

            end

            function object:Get()
                return value
            end

            return object
        end

        --================================================
        -- SLIDER
        --================================================

        function Tab:CreateSlider(config)

            config = config or {}

            local min = config.Min or 0
            local max = config.Max or 100
            local value = ClampNumber(
                config.Default or min,
                min,
                max
            )

            local frame = Base(68)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 8),

                Size = UDim2.new(0.7, 0, 0, 20),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Slider",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local valueLabel = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                AnchorPoint = Vector2.new(1, 0),

                Position = UDim2.new(1, -13, 0, 8),

                Size = UDim2.new(0, 80, 0, 20),

                Font = Enum.Font.GothamBold,

                Text = tostring(value),

                TextColor3 = self.Theme.Accent,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = New("Frame", {
                Parent = frame,

                BackgroundColor3 = Color3.fromRGB(43, 44, 52),

                Position = UDim2.new(0, 13, 0, 42),

                Size = UDim2.new(1, -26, 0, 7)
            })

            Corner(Bar, 8)

            local Fill = New("Frame", {
                Parent = Bar,

                BackgroundColor3 = self.Theme.Accent,

                Size = UDim2.new(
                    (value - min) / (max - min),
                    0,
                    1,
                    0
                )
            })

            Corner(Fill, 8)

            local dragging = false

            local function SetValue(newValue, fire)

                newValue = ClampNumber(
                    newValue,
                    min,
                    max
                )

                if config.Rounding then
                    newValue =
                        math.floor(
                            newValue / config.Rounding + 0.5
                        ) * config.Rounding
                end

                value = newValue

                local percent =
                    (value - min) / (max - min)

                Tween(Fill, {
                    Size = UDim2.new(
                        percent,
                        0,
                        1,
                        0
                    )
                }):Play()

                valueLabel.Text = tostring(value)

                if fire and config.Callback then
                    task.spawn(config.Callback, value)
                end
            end

            local function InputUpdate(input)

                local percent = math.clamp(
                    (input.Position.X - Bar.AbsolutePosition.X)
                        / Bar.AbsoluteSize.X,
                    0,
                    1
                )

                SetValue(
                    min + ((max - min) * percent),
                    true
                )
            end

            self:_Connect(Bar.InputBegan, function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                    Enum.UserInputType.Touch then

                    dragging = true
                    InputUpdate(input)

                end

            end)

            self:_Connect(UserInputService.InputChanged, function(input)

                if not dragging then
                    return
                end

                if input.UserInputType ==
                    Enum.UserInputType.MouseMovement
                    or input.UserInputType ==
                    Enum.UserInputType.Touch then

                    InputUpdate(input)

                end

            end)

            self:_Connect(UserInputService.InputEnded, function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or input.UserInputType ==
                    Enum.UserInputType.Touch then

                    dragging = false

                end

            end)

            SetValue(value, false)

            return {
                Set = function(_, newValue)
                    SetValue(newValue, true)
                end,

                Get = function()
                    return value
                end
            }
        end

        --================================================
        -- DROPDOWN
        --================================================

        function Tab:CreateDropdown(config)

            config = config or {}

            local options = config.Options or {}

            local selected =
                config.Default
                or options[1]
                or "None"

            local frame = Base(50)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(0.5, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Dropdown",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Button = New("TextButton", {
                Parent = frame,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.05,

                AnchorPoint = Vector2.new(1, 0.5),

                Position = UDim2.new(1, -10, 0.5, 0),

                Size = UDim2.new(0, 150, 0, 31),

                AutoButtonColor = false,

                Font = Enum.Font.GothamMedium,

                Text = tostring(selected) .. "  ▼",

                TextColor3 = self.Theme.SubText,

                TextSize = 10
            })

            Corner(Button, 7)

            local List = New("ScrollingFrame", {
                Parent = self.Gui,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.02,

                BorderSizePixel = 0,

                Visible = false,

                Size = UDim2.new(0, 150, 0, 0),

                ScrollBarThickness = 2,

                ScrollBarImageColor3 = self.Theme.Accent,

                CanvasSize = UDim2.new(),

                AutomaticCanvasSize = Enum.AutomaticSize.Y,

                ZIndex = 100
            })

            Corner(List, 8)
            Stroke(List, 0.87, 1)

            local Layout = New("UIListLayout", {
                Parent = List,

                Padding = UDim.new(0, 3)
            })

            Padding(List, 5)

            local opened = false

            local function Refresh()

                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(options) do

                    local Option = New("TextButton", {
                        Parent = List,

                        BackgroundColor3 = self.Theme.Element,

                        BackgroundTransparency = 0.25,

                        Size = UDim2.new(1, 0, 0, 30),

                        AutoButtonColor = false,

                        Font = Enum.Font.Gotham,

                        Text = tostring(option),

                        TextColor3 = self.Theme.Text,

                        TextSize = 10,

                        ZIndex = 101
                    })

                    Corner(Option, 6)

                    self:_Connect(
                        Option.MouseButton1Click,
                        function()

                            selected = option

                            Button.Text =
                                tostring(selected) .. "  ▼"

                            opened = false
                            List.Visible = false

                            if config.Callback then
                                task.spawn(
                                    config.Callback,
                                    selected
                                )
                            end

                        end
                    )
                end
            end

            self:_Connect(Button.MouseButton1Click, function()

                opened = not opened

                if opened then

                    local position =
                        Button.AbsolutePosition

                    List.Position = UDim2.fromOffset(
                        position.X,
                        position.Y +
                            Button.AbsoluteSize.Y +
                            5
                    )

                    List.Size =
                        UDim2.fromOffset(
                            Button.AbsoluteSize.X,
                            math.min(
                                (#options * 33) + 10,
                                190
                            )
                        )

                    List.Visible = true

                else

                    List.Visible = false

                end

            end)

            Refresh()

            return {

                Set = function(_, value)

                    selected = value

                    Button.Text =
                        tostring(value) .. "  ▼"

                    if config.Callback then
                        task.spawn(
                            config.Callback,
                            value
                        )
                    end

                end,

                Get = function()
                    return selected
                end,

                Refresh = function(_, newOptions)

                    options = newOptions or {}

                    Refresh()

                end
            }
        end

        --================================================
        -- MULTI DROPDOWN
        --================================================

        function Tab:CreateMultiDropdown(config)

            config = config or {}

            local options = config.Options or {}
            local selected = {}

            for _, option in ipairs(config.Default or {}) do
                selected[option] = true
            end

            local frame = Base(50)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(0.45, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Multi Select",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Button = New("TextButton", {
                Parent = frame,

                BackgroundColor3 = self.Theme.Secondary,

                AnchorPoint = Vector2.new(1, 0.5),

                Position = UDim2.new(1, -10, 0.5, 0),

                Size = UDim2.new(0, 150, 0, 31),

                AutoButtonColor = false,

                Font = Enum.Font.GothamMedium,

                Text = "Select...",

                TextColor3 = self.Theme.SubText,

                TextSize = 10
            })

            Corner(Button, 7)

            local function GetText()

                local result = {}

                for option in pairs(selected) do
                    table.insert(result, tostring(option))
                end

                if #result == 0 then
                    return "Select..."
                end

                if #result > 2 then
                    return #result .. " selected"
                end

                return table.concat(result, ", ")
            end

            local List = New("Frame", {
                Parent = self.Gui,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.02,

                Visible = false,

                Size = UDim2.new(0, 150, 0, 0),

                ZIndex = 100
            })

            Corner(List, 8)
            Stroke(List, 0.87, 1)

            local Layout = New("UIListLayout", {
                Parent = List,

                Padding = UDim.new(0, 3)
            })

            Padding(List, 5)

            local function Refresh()

                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(options) do

                    local Option = New("TextButton", {
                        Parent = List,

                        BackgroundColor3 =
                            selected[option]
                            and self.Theme.Accent
                            or self.Theme.Element,

                        BackgroundTransparency = 0.15,

                        Size = UDim2.new(1, 0, 0, 30),

                        AutoButtonColor = false,

                        Font = Enum.Font.Gotham,

                        Text =
                            (selected[option] and "✓ " or "")
                            .. tostring(option),

                        TextColor3 = self.Theme.Text,

                        TextSize = 10,

                        ZIndex = 101
                    })

                    Corner(Option, 6)

                    self:_Connect(
                        Option.MouseButton1Click,
                        function()

                            selected[option] =
                                not selected[option]

                            if not selected[option] then
                                selected[option] = nil
                            end

                            Button.Text = GetText()

                            Refresh()

                            if config.Callback then

                                local values = {}

                                for item in pairs(selected) do
                                    table.insert(values, item)
                                end

                                task.spawn(
                                    config.Callback,
                                    values
                                )
                            end

                        end
                    )
                end
            end

            self:_Connect(Button.MouseButton1Click, function()

                if List.Visible then
                    List.Visible = false
                    return
                end

                local pos = Button.AbsolutePosition

                List.Position = UDim2.fromOffset(
                    pos.X,
                    pos.Y + Button.AbsoluteSize.Y + 5
                )

                List.Size = UDim2.fromOffset(
                    Button.AbsoluteSize.X,
                    math.min(
                        (#options * 33) + 10,
                        190
                    )
                )

                List.Visible = true

            end)

            Refresh()

            Button.Text = GetText()

            return {

                Set = function(_, values)

                    selected = {}

                    for _, value in ipairs(values or {}) do
                        selected[value] = true
                    end

                    Button.Text = GetText()

                    Refresh()

                end,

                Get = function()

                    local result = {}

                    for value in pairs(selected) do
                        table.insert(result, value)
                    end

                    return result

                end
            }
        end

        --================================================
        -- INPUT
        --================================================

        function Tab:CreateInput(config)

            config = config or {}

            local frame = Base(52)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(0.45, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Input",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Input = New("TextBox", {
                Parent = frame,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.1,

                AnchorPoint = Vector2.new(1, 0.5),

                Position = UDim2.new(1, -10, 0.5, 0),

                Size = UDim2.new(0, 180, 0, 31),

                ClearTextOnFocus = false,

                Font = Enum.Font.Gotham,

                PlaceholderText =
                    config.Placeholder or "Enter text...",

                PlaceholderColor3 = self.Theme.SubText,

                Text = config.Default or "",

                TextColor3 = self.Theme.Text,

                TextSize = 10
            })

            Corner(Input, 7)

            self:_Connect(
                Input.FocusLost,
                function()
                    if config.Callback then
                        task.spawn(
                            config.Callback,
                            Input.Text
                        )
                    end
                end
            )

            return {

                Set = function(_, text)
                    Input.Text = tostring(text)
                end,

                Get = function()
                    return Input.Text
                end,

                Instance = Input
            }
        end

        --================================================
        -- KEYBIND
        --================================================

        function Tab:CreateKeybind(config)

            config = config or {}

            local frame = Base(50)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(0.5, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Keybind",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Button = New("TextButton", {
                Parent = frame,

                BackgroundColor3 = self.Theme.Secondary,

                AnchorPoint = Vector2.new(1, 0.5),

                Position = UDim2.new(1, -10, 0.5, 0),

                Size = UDim2.new(0, 100, 0, 31),

                AutoButtonColor = false,

                Font = Enum.Font.GothamMedium,

                Text = (
                    config.Default
                    or Enum.KeyCode.RightControl
                ).Name,

                TextColor3 = self.Theme.Text,

                TextSize = 10
            })

            Corner(Button, 7)

            local key =
                config.Default
                or Enum.KeyCode.RightControl

            local listening = false

            self:_Connect(
                Button.MouseButton1Click,
                function()

                    listening = true

                    Button.Text = "Press key..."

                end
            )

            self:_Connect(
                UserInputService.InputBegan,
                function(input, processed)

                    if listening then

                        if input.UserInputType ==
                            Enum.UserInputType.Keyboard then

                            key = input.KeyCode

                            Button.Text =
                                key.Name

                            listening = false

                        end

                        return
                    end

                    if processed then
                        return
                    end

                    if input.KeyCode == key then

                        if config.Callback then

                            task.spawn(
                                config.Callback,
                                key
                            )

                        end

                    end

                end
            )

            return {

                Set = function(_, newKey)

                    key = newKey

                    Button.Text =
                        key.Name

                end,

                Get = function()
                    return key
                end
            }
        end

        --================================================
        -- COLOR PICKER
        --================================================

        function Tab:CreateColorPicker(config)

            config = config or {}

            local frame = Base(50)

            local title = New("TextLabel", {
                Parent = frame,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 13, 0, 0),

                Size = UDim2.new(0.5, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = config.Name or "Color",

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ColorButton = New("TextButton", {
                Parent = frame,

                BackgroundColor3 =
                    config.Default
                    or self.Theme.Accent,

                AnchorPoint = Vector2.new(1, 0.5),

                Position = UDim2.new(1, -12, 0.5, 0),

                Size = UDim2.new(0, 65, 0, 30),

                AutoButtonColor = false,

                Text = ""
            })

            Corner(ColorButton, 7)

            local current =
                config.Default
                or self.Theme.Accent

            -- Simple accessible palette popup
            local Popup = New("Frame", {
                Parent = self.Gui,

                BackgroundColor3 = self.Theme.Secondary,

                Visible = false,

                Size = UDim2.new(0, 210, 0, 150),

                ZIndex = 150
            })

            Corner(Popup, 9)
            Stroke(Popup, 0.86, 1)

            local palette = {
                Color3.fromRGB(255, 70, 70),
                Color3.fromRGB(255, 140, 60),
                Color3.fromRGB(255, 220, 70),
                Color3.fromRGB(80, 220, 130),
                Color3.fromRGB(70, 180, 255),
                Color3.fromRGB(100, 100, 255),
                Color3.fromRGB(175, 80, 255),
                Color3.fromRGB(255, 80, 190),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(100, 100, 110),
                Color3.fromRGB(35, 35, 40),
                Color3.fromRGB(0, 0, 0)
            }

            local Grid = New("UIGridLayout", {
                Parent = Popup,

                CellSize = UDim2.new(0, 40, 0, 40),

                CellPadding = UDim2.new(0, 5, 0, 5),

                HorizontalAlignment =
                    Enum.HorizontalAlignment.Center,

                VerticalAlignment =
                    Enum.VerticalAlignment.Center
            })

            for _, color in ipairs(palette) do

                local Color = New("TextButton", {
                    Parent = Popup,

                    BackgroundColor3 = color,

                    AutoButtonColor = false,

                    Text = "",

                    ZIndex = 151
                })

                Corner(Color, 7)

                self:_Connect(
                    Color.MouseButton1Click,
                    function()

                        current = color

                        ColorButton.BackgroundColor3 =
                            color

                        Popup.Visible = false

                        if config.Callback then
                            task.spawn(
                                config.Callback,
                                color
                            )
                        end

                    end
                )

            end

            self:_Connect(
                ColorButton.MouseButton1Click,
                function()

                    if Popup.Visible then
                        Popup.Visible = false
                        return
                    end

                    local pos =
                        ColorButton.AbsolutePosition

                    Popup.Position =
                        UDim2.fromOffset(
                            pos.X - 140,
                            pos.Y + 38
                        )

                    Popup.Visible = true

                end
            )

            return {

                Set = function(_, color)

                    if typeof(color) ~= "Color3" then
                        return
                    end

                    current = color

                    ColorButton.BackgroundColor3 =
                        color

                end,

                Get = function()
                    return current
                end
            }
        end

        --================================================
        -- DIVIDER
        --================================================

        function Tab:CreateDivider()

            local divider = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Border,

                BackgroundTransparency = 0.92,

                Size = UDim2.new(1, 0, 0, 1)
            })

            return divider
        end

        return Tab
    end

    --====================================================
    -- NOTIFICATION SYSTEM
    --====================================================

    local NotificationHolder = New("Frame", {
        Parent = ScreenGui,

        BackgroundTransparency = 1,

        AnchorPoint = Vector2.new(1, 1),

        Position = UDim2.new(1, -18, 1, -18),

        Size = UDim2.new(0, 320, 0, 500)
    })

    local NotificationLayout = New("UIListLayout", {
        Parent = NotificationHolder,

        VerticalAlignment = Enum.VerticalAlignment.Bottom,

        HorizontalAlignment = Enum.HorizontalAlignment.Right,

        Padding = UDim.new(0, 8)
    })

    self.NotificationHolder = NotificationHolder

    function self:Notify(config)

        config = config or {}

        local notification = New("Frame", {
            Parent = NotificationHolder,

            BackgroundColor3 = self.Theme.Secondary,

            BackgroundTransparency = 0.05,

            Size = UDim2.new(0, 300, 0, 74)
        })

        Corner(notification, 10)
        Stroke(notification, 0.87, 1)

        local kind = config.Type or "Info"

        local accentColor = self.Theme.Accent

        if kind == "Success" then
            accentColor = self.Theme.Success
        elseif kind == "Warning" then
            accentColor = self.Theme.Warning
        elseif kind == "Error" then
            accentColor = self.Theme.Error
        end

        local Accent = New("Frame", {
            Parent = notification,

            BackgroundColor3 = accentColor,

            Position = UDim2.new(0, 7, 0, 9),

            Size = UDim2.new(0, 3, 1, -18)
        })

        Corner(Accent, 4)

        local Title = New("TextLabel", {
            Parent = notification,

            BackgroundTransparency = 1,

            Position = UDim2.new(0, 22, 0, 9),

            Size = UDim2.new(1, -30, 0, 20),

            Font = Enum.Font.GothamBold,

            Text = config.Title or "Notification",

            TextColor3 = self.Theme.Text,

            TextSize = 11,

            TextXAlignment = Enum.TextXAlignment.Left
        })

        local ContentLabel = New("TextLabel", {
            Parent = notification,

            BackgroundTransparency = 1,

            Position = UDim2.new(0, 22, 0, 31),

            Size = UDim2.new(1, -32, 0, 33),

            Font = Enum.Font.Gotham,

            Text = config.Content or "",

            TextColor3 = self.Theme.SubText,

            TextSize = 10,

            TextWrapped = true,

            TextXAlignment = Enum.TextXAlignment.Left,

            TextYAlignment = Enum.TextYAlignment.Top
        })

        notification.Position =
            UDim2.new(1, 340, 0, 0)

        Tween(notification, {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()

        task.delay(
            config.Duration or 3,
            function()

                if not notification.Parent then
                    return
                end

                local tween = Tween(
                    notification,
                    {
                        Position =
                            UDim2.new(
                                1,
                                340,
                                0,
                                0
                            )
                    }
                )

                tween:Play()

                tween.Completed:Wait()

                notification:Destroy()

            end
        )

        return notification
    end

    --====================================================
    -- SEARCH
    --====================================================

    function self:CreateSearch()

        local Search = New("TextBox", {
            Parent = TopBar,

            BackgroundColor3 = self.Theme.Element,

            BackgroundTransparency = 0.18,

            AnchorPoint = Vector2.new(1, 0),

            Position = UDim2.new(1, -122, 0, 19),

            Size = UDim2.new(0, 130, 0, 30),

            ClearTextOnFocus = false,

            Font = Enum.Font.Gotham,

            PlaceholderText = "Search...",

            PlaceholderColor3 = self.Theme.SubText,

            Text = "",

            TextColor3 = self.Theme.Text,

            TextSize = 10
        })

        Corner(Search, 7)

        self.SearchBox = Search

        self:_Connect(
            Search:GetPropertyChangedSignal("Text"),
            function()

                local query =
                    string.lower(Search.Text)

                for _, tab in ipairs(self.Tabs) do

                    local tabMatch =
                        query == ""
                        or string.find(
                            string.lower(tab.Name),
                            query,
                            1,
                            true
                        )

                    tab.Button.Visible = tabMatch

                end

            end
        )

        return Search
    end

    --====================================================
    -- THEME SYSTEM
    --====================================================

    function self:SetTheme(theme)

        if typeof(theme) == "string" then
            theme = Library.Themes[theme]
        end

        if typeof(theme) ~= "table" then
            return
        end

        self.Theme = theme

        local function UpdateObject(object)

            if object:IsA("TextLabel")
                or object:IsA("TextButton")
                or object:IsA("TextBox") then

                if object == self.TitleLabel then
                    object.TextColor3 = theme.Text
                elseif object.TextColor3 == Library.Theme.SubText then
                    object.TextColor3 = theme.SubText
                end

            end

        end

        for _, object in ipairs(ScreenGui:GetDescendants()) do
            pcall(function()
                UpdateObject(object)
            end)
        end

        Window.BackgroundColor3 =
            theme.Background

        self:Notify({
            Title = "Theme Updated",
            Content = "Interface theme changed.",
            Type = "Success"
        })
    end

    --====================================================
    -- SCALE
    --====================================================

    function self:SetScale(scale)

        scale = math.clamp(
            tonumber(scale) or 1,
            0.5,
            2
        )

        self.Scale.Scale = scale

    end

    --====================================================
    -- FLAGS
    --====================================================

    function self:SetFlag(name, value)
        self.Flags[name] = value
    end

    function self:GetFlag(name)
        return self.Flags[name]
    end

    function self:GetFlags()
        local copy = {}

        for key, value in pairs(self.Flags) do
            copy[key] = value
        end

        return copy
    end

    function self:ResetFlags()
        table.clear(self.Flags)
    end

    --====================================================
    -- DESTROY
    --====================================================

    function self:Destroy()

        if self.Destroyed then
            return
        end

        self.Destroyed = true

        self:_Cleanup()

        if self.Gui then

            local tween = Tween(
                Window,
                {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                },
                0.2
            )

            if tween then
                tween:Play()
                tween.Completed:Wait()
            end

            self.Gui:Destroy()

        end

    end

    return self
end

--========================================================
-- EXAMPLE
-- Remove this entire section if using as a ModuleScript.
--========================================================

local Window = Library:CreateWindow({
    Title = "Ultra Glass",
    Subtitle = "Advanced Transparent Interface"
})

local Main = Window:CreateTab("Main", "◆")

Main:CreateSection("CONTROLS")

Main:CreateParagraph({
    Title = "Ultra Glass UI",
    Content = "A transparent, responsive and modular interface framework."
})

Main:CreateButton({
    Name = "Test Notification",
    Text = "Test",

    Callback = function()

        Window:Notify({
            Title = "Everything Works",
            Content = "The notification system is working correctly.",
            Type = "Success",
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
    Name = "Mode",

    Options = {
        "Normal",
        "Advanced",
        "Extreme"
    },

    Default = "Normal",

    Callback = function(value)
        print("Mode:", value)
    end
})

Main:CreateMultiDropdown({
    Name = "Features",

    Options = {
        "Combat",
        "Visuals",
        "Movement",
        "Utility"
    },

    Default = {
        "Visuals"
    },

    Callback = function(values)
        print("Selected:", table.concat(values, ", "))
    end
})

Main:CreateInput({
    Name = "Username",

    Placeholder = "Enter username...",

    Callback = function(text)
        print("Username:", text)
    end
})

Main:CreateKeybind({
    Name = "Example Key",

    Default = Enum.KeyCode.G,

    Callback = function(key)

        Window:Notify({
            Title = "Keybind",
            Content = key.Name .. " was pressed.",
            Type = "Info"
        })

    end
})

Main:CreateColorPicker({
    Name = "Accent Color",

    Default = Library.Theme.Accent,

    Callback = function(color)
        print("Color:", color)
    end
})

local Settings = Window:CreateTab("Settings", "⚙")

Settings:CreateSection("INTERFACE")

Settings:CreateButton({
    Name = "Purple Theme",
    Text = "Apply",

    Callback = function()
        Window:SetTheme(Library.Themes.Purple)
    end
})

Settings:CreateButton({
    Name = "Red Theme",
    Text = "Apply",

    Callback = function()
        Window:SetTheme(Library.Themes.Red)
    end
})

Settings:CreateButton({
    Name = "Blue Theme",
    Text = "Apply",

    Callback = function()
        Window:SetTheme(Library.Themes.Blue)
    end
})

Settings:CreateSlider({
    Name = "UI Scale",

    Min = 0.6,
    Max = 1.4,

    Default = 1,

    Rounding = 0.05,

    Callback = function(value)
        Window:SetScale(value)
    end
})

Window:CreateSearch()

Window:Notify({
    Title = "Ultra Glass",
    Content = "Advanced UI loaded successfully.",
    Type = "Success",
    Duration = 4
})

return Library
