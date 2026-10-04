--[[
    Compact Glass UI Library
    Standalone / Single File
    Roblox Luau

    Features:
    - Compact responsive UI
    - Mobile + PC support
    - Transparent glass style
    - Draggable window
    - WindUI-style minimize launcher
    - Tabs
    - Buttons
    - Toggles
    - Sliders
    - Dropdowns
    - Multi-dropdowns
    - Text inputs
    - Keybinds
    - Color picker
    - Sections / labels / paragraphs
    - Notifications
    - Search
    - Themes
    - Flags / state system
    - Cleanup / destroy
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

--==================================================
-- CONFIG
--==================================================

Library.Config = {
    AnimationSpeed = 0.18,

    DefaultWidth = 600,
    DefaultHeight = 400,

    MinWidth = 420,
    MinHeight = 280,

    MobileScale = 0.68,
    DesktopScale = 0.82,

    Transparency = 0.14,
    ElementTransparency = 0.06,

    Draggable = true,

    Theme = "Dark"
}

--==================================================
-- THEMES
--==================================================

Library.Themes = {

    Dark = {
        Background = Color3.fromRGB(14, 14, 18),
        Secondary = Color3.fromRGB(21, 21, 27),
        Tertiary = Color3.fromRGB(29, 29, 36),

        Accent = Color3.fromRGB(145, 90, 255),
        AccentDark = Color3.fromRGB(105, 55, 205),

        Text = Color3.fromRGB(245, 245, 250),
        SubText = Color3.fromRGB(165, 165, 175),

        Border = Color3.fromRGB(65, 65, 75),

        Success = Color3.fromRGB(80, 220, 130),
        Warning = Color3.fromRGB(255, 190, 70),
        Danger = Color3.fromRGB(255, 80, 90)
    },

    Purple = {
        Background = Color3.fromRGB(18, 12, 25),
        Secondary = Color3.fromRGB(29, 19, 40),
        Tertiary = Color3.fromRGB(42, 27, 55),

        Accent = Color3.fromRGB(170, 85, 255),
        AccentDark = Color3.fromRGB(120, 50, 200),

        Text = Color3.fromRGB(250, 245, 255),
        SubText = Color3.fromRGB(175, 160, 190),

        Border = Color3.fromRGB(85, 60, 100),

        Success = Color3.fromRGB(80, 220, 130),
        Warning = Color3.fromRGB(255, 190, 70),
        Danger = Color3.fromRGB(255, 80, 90)
    },

    Red = {
        Background = Color3.fromRGB(23, 12, 14),
        Secondary = Color3.fromRGB(34, 18, 21),
        Tertiary = Color3.fromRGB(48, 24, 28),

        Accent = Color3.fromRGB(255, 70, 80),
        AccentDark = Color3.fromRGB(190, 40, 50),

        Text = Color3.fromRGB(255, 245, 245),
        SubText = Color3.fromRGB(190, 165, 170),

        Border = Color3.fromRGB(100, 55, 60),

        Success = Color3.fromRGB(80, 220, 130),
        Warning = Color3.fromRGB(255, 190, 70),
        Danger = Color3.fromRGB(255, 60, 70)
    },

    Blue = {
        Background = Color3.fromRGB(10, 16, 25),
        Secondary = Color3.fromRGB(16, 26, 40),
        Tertiary = Color3.fromRGB(23, 38, 58),

        Accent = Color3.fromRGB(75, 150, 255),
        AccentDark = Color3.fromRGB(45, 105, 200),

        Text = Color3.fromRGB(240, 248, 255),
        SubText = Color3.fromRGB(160, 180, 200),

        Border = Color3.fromRGB(55, 80, 110),

        Success = Color3.fromRGB(80, 220, 130),
        Warning = Color3.fromRGB(255, 190, 70),
        Danger = Color3.fromRGB(255, 80, 90)
    }
}

--==================================================
-- UTILITIES
--==================================================

local function Tween(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or Library.Config.AnimationSpeed,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()
    return tween
end

local function New(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    return object
end

local function Corner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
    return corner
end

local function Stroke(object, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")

    stroke.Color = color or Color3.new(1, 1, 1)
    stroke.Transparency = transparency or 0
    stroke.Thickness = thickness or 1

    stroke.Parent = object

    return stroke
end

local function Padding(object, left, right, top, bottom)
    local padding = Instance.new("UIPadding")

    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)

    padding.Parent = object

    return padding
end

local function Clamp(value, min, max)
    return math.clamp(value, min, max)
end

--==================================================
-- CONNECTION MANAGEMENT
--==================================================

function Library:_Connect(connection)
    self._Connections = self._Connections or {}

    table.insert(self._Connections, connection)

    return connection
end

function Library:_CleanupConnections()
    if not self._Connections then
        return
    end

    for _, connection in ipairs(self._Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(self._Connections)
end

--==================================================
-- DRAGGING
--==================================================

function Library:_MakeDraggable(handle, window)
    if not Library.Config.Draggable then
        return
    end

    local dragging = false
    local dragStart
    local startPosition

    self:_Connect(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = window.Position

            local connection

            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false

                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end))

    self:_Connect(UserInputService.InputChanged:Connect(function(input)
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
            startPosition.Y.Offset + delta.Y
        )
    end))
end

--==================================================
-- CREATE WINDOW
--==================================================

function Library:CreateWindow(options)

    options = options or {}

    local self = setmetatable({}, Library)

    self.Title = options.Title or "Example Hub"
    self.Subtitle = options.Subtitle or "Compact UI"
    self.Theme = Library.Themes[options.Theme or Library.Config.Theme]
        or Library.Themes.Dark

    self.Flags = {}
    self.Tabs = {}
    self._Connections = {}

    --==================================================
    -- SCREEN GUI
    --==================================================

    local ScreenGui = New("ScreenGui", {
        Name = "CompactGlassUI",
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    self.ScreenGui = ScreenGui

    --==================================================
    -- MAIN WINDOW
    --==================================================

    local Window = New("Frame", {
        Parent = ScreenGui,

        BackgroundColor3 = self.Theme.Background,
        BackgroundTransparency = Library.Config.Transparency,

        BorderSizePixel = 0,

        AnchorPoint = Vector2.new(0.5, 0.5),

        Position = UDim2.new(0.5, 0, 0.5, 0),

        Size = UDim2.new(
            0,
            Library.Config.DefaultWidth,
            0,
            Library.Config.DefaultHeight
        ),

        ClipsDescendants = true,

        ZIndex = 10
    })

    self.Window = Window

    Corner(Window, 12)

    self.WindowStroke = Stroke(
        Window,
        self.Theme.Border,
        0.35,
        1
    )

    --==================================================
    -- SCALE
    --==================================================

    local UIScale = Instance.new("UIScale")
    UIScale.Parent = Window

    self.UIScale = UIScale

    local function UpdateScale()

        local viewport = workspace.CurrentCamera
            and workspace.CurrentCamera.ViewportSize
            or Vector2.new(1920, 1080)

        if viewport.X <= 700 then
            UIScale.Scale = Library.Config.MobileScale
        else
            UIScale.Scale = Library.Config.DesktopScale
        end
    end

    UpdateScale()

    if workspace.CurrentCamera then
        self:_Connect(
            workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")
                :Connect(UpdateScale)
        )
    end

    --==================================================
    -- TOP BAR
    --==================================================

    local TopBar = New("Frame", {
        Parent = Window,

        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = Library.Config.ElementTransparency,

        BorderSizePixel = 0,

        Size = UDim2.new(1, 0, 0, 52),

        ZIndex = 20
    })

    self.TopBar = TopBar

    local Title = New("TextLabel", {
        Parent = TopBar,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 17, 0, 7),

        Size = UDim2.new(1, -105, 0, 20),

        Font = Enum.Font.GothamBold,

        Text = self.Title,

        TextColor3 = self.Theme.Text,

        TextSize = 15,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 22
    })

    local Subtitle = New("TextLabel", {
        Parent = TopBar,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 17, 0, 27),

        Size = UDim2.new(1, -105, 0, 16),

        Font = Enum.Font.Gotham,

        Text = self.Subtitle,

        TextColor3 = self.Theme.SubText,

        TextSize = 9,

        TextXAlignment = Enum.TextXAlignment.Left,

        ZIndex = 22
    })

    --==================================================
    -- MINIMIZE BUTTON
    --==================================================

    local MinimizeButton = New("TextButton", {
        Parent = TopBar,

        BackgroundTransparency = 1,

        Position = UDim2.new(1, -65, 0, 7),

        Size = UDim2.new(0, 25, 0, 25),

        Font = Enum.Font.GothamBold,

        Text = "—",

        TextColor3 = self.Theme.SubText,

        TextSize = 18,

        AutoButtonColor = false,

        ZIndex = 25
    })

    --==================================================
    -- CLOSE BUTTON
    --==================================================

    local CloseButton = New("TextButton", {
        Parent = TopBar,

        BackgroundTransparency = 1,

        Position = UDim2.new(1, -35, 0, 7),

        Size = UDim2.new(0, 25, 0, 25),

        Font = Enum.Font.GothamBold,

        Text = "×",

        TextColor3 = self.Theme.SubText,

        TextSize = 18,

        AutoButtonColor = false,

        ZIndex = 25
    })

    self:_Connect(MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {
            TextColor3 = self.Theme.Text
        })
    end))

    self:_Connect(MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {
            TextColor3 = self.Theme.SubText
        })
    end))

    self:_Connect(CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {
            TextColor3 = self.Theme.Danger
        })
    end))

    self:_Connect(CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {
            TextColor3 = self.Theme.SubText
        })
    end))

    --==================================================
    -- BODY
    --==================================================

    local Body = New("Frame", {
        Parent = Window,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 0, 0, 52),

        Size = UDim2.new(1, 0, 1, -52),

        ZIndex = 11
    })

    self.Body = Body

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar = New("Frame", {
        Parent = Body,

        BackgroundColor3 = self.Theme.Secondary,

        BackgroundTransparency = 0.1,

        BorderSizePixel = 0,

        Size = UDim2.new(0, 145, 1, 0),

        ZIndex = 12
    })

    self.Sidebar = Sidebar

    Padding(Sidebar, 8, 8, 8, 8)

    local TabList = New("ScrollingFrame", {
        Parent = Sidebar,

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        Size = UDim2.new(1, 0, 1, 0),

        CanvasSize = UDim2.new(0, 0, 0, 0),

        AutomaticCanvasSize = Enum.AutomaticSize.Y,

        ScrollBarThickness = 2,

        ScrollBarImageColor3 = self.Theme.Accent,

        ScrollingDirection = Enum.ScrollingDirection.Y,

        ZIndex = 15
    })

    local TabLayout = New("UIListLayout", {
        Parent = TabList,

        Padding = UDim.new(0, 5),

        SortOrder = Enum.SortOrder.LayoutOrder
    })

    --==================================================
    -- CONTENT
    --==================================================

    local Content = New("Frame", {
        Parent = Body,

        BackgroundTransparency = 1,

        Position = UDim2.new(0, 153, 0, 0),

        Size = UDim2.new(1, -153, 1, 0),

        ZIndex = 12
    })

    self.Content = Content

    --==================================================
    -- MINIMIZED LAUNCHER
    --==================================================

    local MinimizedButton = New("TextButton", {
        Parent = ScreenGui,

        BackgroundColor3 = self.Theme.Secondary,

        BackgroundTransparency = 0.05,

        AnchorPoint = Vector2.new(0.5, 0),

        Position = UDim2.new(0.5, 0, 0, 10),

        Size = UDim2.new(0, 145, 0, 36),

        AutoButtonColor = false,

        Font = Enum.Font.GothamBold,

        Text = self.Title,

        TextColor3 = self.Theme.Text,

        TextSize = 11,

        Visible = false,

        ZIndex = 500
    })

    Corner(MinimizedButton, 10)

    self.MinimizedStroke = Stroke(
        MinimizedButton,
        self.Theme.Border,
        0.25,
        1
    )

    self.MinimizedButton = MinimizedButton

    --==================================================
    -- DRAG
    --==================================================

    self:_MakeDraggable(TopBar, Window)

    --==================================================
    -- TAB CREATOR
    --==================================================

    function self:CreateTab(name, icon)

        local Tab = {}

        Tab.Name = name
        Tab.Elements = {}

        local TabButton = New("TextButton", {
            Parent = TabList,

            BackgroundColor3 = self.Theme.Tertiary,

            BackgroundTransparency = 0.45,

            BorderSizePixel = 0,

            Size = UDim2.new(1, 0, 0, 34),

            AutoButtonColor = false,

            Font = Enum.Font.GothamMedium,

            Text = "",

            ZIndex = 20
        })

        Corner(TabButton, 7)

        local TabText = New("TextLabel", {
            Parent = TabButton,

            BackgroundTransparency = 1,

            Position = UDim2.new(0, 10, 0, 0),

            Size = UDim2.new(1, -18, 1, 0),

            Font = Enum.Font.GothamMedium,

            Text = (icon and icon .. "  " or "") .. name,

            TextColor3 = self.Theme.SubText,

            TextSize = 10,

            TextXAlignment = Enum.TextXAlignment.Left,

            ZIndex = 22
        })

        local Page = New("ScrollingFrame", {
            Parent = Content,

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            Size = UDim2.new(1, 0, 1, 0),

            CanvasSize = UDim2.new(0, 0, 0, 0),

            AutomaticCanvasSize = Enum.AutomaticSize.Y,

            ScrollBarThickness = 2,

            ScrollBarImageColor3 = self.Theme.Accent,

            Visible = false,

            ZIndex = 15
        })

        Padding(Page, 5, 8, 8, 8)

        local Layout = New("UIListLayout", {
            Parent = Page,

            Padding = UDim.new(0, 7),

            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Tab.Button = TabButton
        Tab.Page = Page
        Tab.Layout = Layout

        table.insert(self.Tabs, Tab)

        local function Select()

            for _, other in ipairs(self.Tabs) do

                other.Page.Visible = false

                Tween(other.Button, {
                    BackgroundColor3 = self.Theme.Tertiary,
                    BackgroundTransparency = 0.45
                })

                Tween(other.Button:FindFirstChildOfClass("TextLabel"), {
                    TextColor3 = self.Theme.SubText
                })
            end

            Page.Visible = true

            Tween(TabButton, {
                BackgroundColor3 = self.Theme.Accent,
                BackgroundTransparency = 0.1
            })

            Tween(TabText, {
                TextColor3 = self.Theme.Text
            })
        end

        self:_Connect(TabButton.MouseButton1Click:Connect(Select))

        if #self.Tabs == 1 then
            Select()
        end

        --==================================================
        -- SECTION
        --==================================================

        function Tab:CreateSection(text)

            local Section = New("TextLabel", {
                Parent = Page,

                BackgroundTransparency = 1,

                Size = UDim2.new(1, 0, 0, 22),

                Font = Enum.Font.GothamBold,

                Text = text,

                TextColor3 = self.Theme.Text,

                TextSize = 11,

                TextXAlignment = Enum.TextXAlignment.Left,

                ZIndex = 20
            })

            return Section
        end

        --==================================================
        -- LABEL
        --==================================================

        function Tab:CreateLabel(text)

            local Label = New("TextLabel", {
                Parent = Page,

                BackgroundTransparency = 1,

                Size = UDim2.new(1, 0, 0, 25),

                Font = Enum.Font.Gotham,

                Text = text,

                TextColor3 = self.Theme.SubText,

                TextSize = 10,

                TextWrapped = true,

                TextXAlignment = Enum.TextXAlignment.Left,

                ZIndex = 20
            })

            return Label
        end

        --==================================================
        -- PARAGRAPH
        --==================================================

        function Tab:CreateParagraph(data)

            data = data or {}

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.15,

                BorderSizePixel = 0,

                AutomaticSize = Enum.AutomaticSize.Y,

                Size = UDim2.new(1, 0, 0, 0),

                ZIndex = 20
            })

            Corner(Holder, 7)

            Padding(Holder, 10, 10, 8, 8)

            local Title = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Size = UDim2.new(1, 0, 0, 18),

                Font = Enum.Font.GothamBold,

                Text = data.Title or "Information",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Description = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 0, 0, 20),

                AutomaticSize = Enum.AutomaticSize.Y,

                Size = UDim2.new(1, 0, 0, 0),

                Font = Enum.Font.Gotham,

                Text = data.Content or data.Description or "",

                TextColor3 = self.Theme.SubText,

                TextSize = 9,

                TextWrapped = true,

                TextXAlignment = Enum.TextXAlignment.Left,

                TextYAlignment = Enum.TextYAlignment.Top
            })

            return Holder
        end

        --==================================================
        -- BUTTON
        --==================================================

        function Tab:CreateButton(data)

            data = data or {}

            local Button = New("TextButton", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Tertiary,

                BackgroundTransparency = 0.08,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 36),

                AutoButtonColor = false,

                Font = Enum.Font.GothamMedium,

                Text = data.Name or data.Text or "Button",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                ZIndex = 20
            })

            Corner(Button, 7)

            Stroke(
                Button,
                self.Theme.Border,
                0.55,
                1
            )

            self:_Connect(Button.MouseEnter:Connect(function()
                Tween(Button, {
                    BackgroundColor3 = self.Theme.Accent
                })
            end))

            self:_Connect(Button.MouseLeave:Connect(function()
                Tween(Button, {
                    BackgroundColor3 = self.Theme.Tertiary
                })
            end))

            self:_Connect(Button.MouseButton1Click:Connect(function()

                if typeof(data.Callback) == "function" then
                    task.spawn(function()
                        pcall(data.Callback)
                    end)
                end

            end))

            return {
                Button = Button
            }
        end

        --==================================================
        -- TOGGLE
        --==================================================

        function Tab:CreateToggle(data)

            data = data or {}

            local state = data.CurrentValue == true
                or data.Default == true

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.12,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 40),

                ZIndex = 20
            })

            Corner(Holder, 7)

            local Label = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 0),

                Size = UDim2.new(1, -60, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Toggle",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = New("TextButton", {
                Parent = Holder,

                BackgroundColor3 = self.Theme.Tertiary,

                BorderSizePixel = 0,

                Position = UDim2.new(1, -46, 0.5, -9),

                Size = UDim2.new(0, 36, 0, 18),

                Text = "",

                AutoButtonColor = false
            })

            Corner(Switch, 20)

            local Knob = New("Frame", {
                Parent = Switch,

                BackgroundColor3 = self.Theme.SubText,

                BorderSizePixel = 0,

                Size = UDim2.new(0, 14, 0, 14),

                Position = UDim2.new(0, 2, 0.5, -7)
            })

            Corner(Knob, 20)

            local function Set(value, callback)

                state = value == true

                if state then

                    Tween(Switch, {
                        BackgroundColor3 = self.Theme.Accent
                    })

                    Tween(Knob, {
                        Position = UDim2.new(1, -16, 0.5, -7),
                        BackgroundColor3 = self.Theme.Text
                    })

                else

                    Tween(Switch, {
                        BackgroundColor3 = self.Theme.Tertiary
                    })

                    Tween(Knob, {
                        Position = UDim2.new(0, 2, 0.5, -7),
                        BackgroundColor3 = self.Theme.SubText
                    })

                end

                if data.Flag then
                    self.Flags[data.Flag] = state
                end

                local callbackFunction = callback or data.Callback

                if typeof(callbackFunction) == "function" then
                    task.spawn(function()
                        pcall(callbackFunction, state)
                    end)
                end
            end

            self:_Connect(Switch.MouseButton1Click:Connect(function()
                Set(not state)
            end))

            Set(state, nil)

            return {
                Set = Set,

                Get = function()
                    return state
                end
            }
        end

        --==================================================
        -- SLIDER
        --==================================================

        function Tab:CreateSlider(data)

            data = data or {}

            local min = data.Range and data.Range[1] or data.Min or 0
            local max = data.Range and data.Range[2] or data.Max or 100

            local value = data.CurrentValue
                or data.Default
                or min

            value = Clamp(value, min, max)

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.12,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 52),

                ZIndex = 20
            })

            Corner(Holder, 7)

            local Name = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 6),

                Size = UDim2.new(0.7, 0, 0, 18),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Slider",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0.7, 0, 0, 6),

                Size = UDim2.new(0.25, 0, 0, 18),

                Font = Enum.Font.GothamMedium,

                Text = tostring(value),

                TextColor3 = self.Theme.Accent,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = New("Frame", {
                Parent = Holder,

                BackgroundColor3 = self.Theme.Tertiary,

                BorderSizePixel = 0,

                Position = UDim2.new(0, 10, 0, 33),

                Size = UDim2.new(1, -20, 0, 5)
            })

            Corner(Bar, 5)

            local Fill = New("Frame", {
                Parent = Bar,

                BackgroundColor3 = self.Theme.Accent,

                BorderSizePixel = 0,

                Size = UDim2.new(
                    (value - min) / math.max(max - min, 1),
                    0,
                    1,
                    0
                )
            })

            Corner(Fill, 5)

            local dragging = false

            local function Set(newValue)

                value = Clamp(
                    newValue,
                    min,
                    max
                )

                local percent =
                    (value - min) / math.max(max - min, 1)

                Tween(Fill, {
                    Size = UDim2.new(percent, 0, 1, 0)
                })

                ValueLabel.Text = tostring(value)

                if data.Flag then
                    self.Flags[data.Flag] = value
                end

                if typeof(data.Callback) == "function" then
                    task.spawn(function()
                        pcall(data.Callback, value)
                    end)
                end
            end

            local function Update(input)

                local percent =
                    (input.Position.X - Bar.AbsolutePosition.X)
                    / Bar.AbsoluteSize.X

                percent = Clamp(percent, 0, 1)

                local newValue =
                    min + (max - min) * percent

                if data.Increment then
                    newValue =
                        math.floor(
                            newValue / data.Increment + 0.5
                        ) * data.Increment
                else
                    newValue = math.floor(newValue + 0.5)
                end

                Set(newValue)
            end

            self:_Connect(Bar.InputBegan:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    dragging = true
                    Update(input)
                end
            end))

            self:_Connect(UserInputService.InputChanged:Connect(function(input)

                if not dragging then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then

                    Update(input)
                end
            end))

            self:_Connect(UserInputService.InputEnded:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    dragging = false
                end
            end))

            Set(value)

            return {
                Set = Set,

                Get = function()
                    return value
                end
            }
        end

        --==================================================
        -- DROPDOWN
        --==================================================

        function Tab:CreateDropdown(data)

            data = data or {}

            local values = data.Options or data.Values or {}

            local selected = data.CurrentOption
                or data.Default
                or values[1]
                or "Select"

            local open = false

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.1,

                BorderSizePixel = 0,

                AutomaticSize = Enum.AutomaticSize.Y,

                Size = UDim2.new(1, 0, 0, 40),

                ZIndex = 30
            })

            Corner(Holder, 7)

            local MainButton = New("TextButton", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Size = UDim2.new(1, 0, 0, 40),

                Font = Enum.Font.GothamMedium,

                Text = "",

                AutoButtonColor = false
            })

            local Label = New("TextLabel", {
                Parent = MainButton,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 0),

                Size = UDim2.new(0.5, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Dropdown",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Value = New("TextLabel", {
                Parent = MainButton,

                BackgroundTransparency = 1,

                Position = UDim2.new(0.5, 0, 0, 0),

                Size = UDim2.new(0.45, 0, 1, 0),

                Font = Enum.Font.Gotham,

                Text = tostring(selected) .. "  ▾",

                TextColor3 = self.Theme.Accent,

                TextSize = 9,

                TextXAlignment = Enum.TextXAlignment.Right
            })

            local OptionsFrame = New("Frame", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 6, 0, 43),

                Size = UDim2.new(1, -12, 0, 0),

                Visible = false,

                ZIndex = 50
            })

            local OptionsLayout = New("UIListLayout", {
                Parent = OptionsFrame,

                Padding = UDim.new(0, 4)
            })

            local function Rebuild()

                for _, child in ipairs(OptionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(values) do

                    local OptionButton = New("TextButton", {
                        Parent = OptionsFrame,

                        BackgroundColor3 = self.Theme.Tertiary,

                        BackgroundTransparency = 0.05,

                        BorderSizePixel = 0,

                        Size = UDim2.new(1, 0, 0, 30),

                        Font = Enum.Font.Gotham,

                        Text = tostring(option),

                        TextColor3 = self.Theme.Text,

                        TextSize = 9,

                        AutoButtonColor = false,

                        ZIndex = 60
                    })

                    Corner(OptionButton, 6)

                    self:_Connect(
                        OptionButton.MouseButton1Click:Connect(function()

                            selected = option

                            Value.Text =
                                tostring(selected) .. "  ▾"

                            open = false

                            OptionsFrame.Visible = false

                            if data.Flag then
                                self.Flags[data.Flag] = selected
                            end

                            if typeof(data.Callback) == "function" then
                                task.spawn(function()
                                    pcall(
                                        data.Callback,
                                        selected
                                    )
                                end)
                            end

                        end)
                    )
                end

                OptionsFrame.Size = UDim2.new(
                    1,
                    -12,
                    0,
                    OptionsLayout.AbsoluteContentSize.Y
                )
            end

            self:_Connect(MainButton.MouseButton1Click:Connect(function()

                open = not open

                OptionsFrame.Visible = open

                if open then
                    Rebuild()
                end
            end))

            return {
                Set = function(option)

                    selected = option

                    Value.Text =
                        tostring(selected) .. "  ▾"

                    if data.Flag then
                        self.Flags[data.Flag] = selected
                    end
                end,

                Get = function()
                    return selected
                end,

                Refresh = function(newOptions)
                    values = newOptions or {}
                    Rebuild()
                end
            }
        end

        --==================================================
        -- MULTI DROPDOWN
        --==================================================

        function Tab:CreateMultiDropdown(data)

            data = data or {}

            local values = data.Options or data.Values or {}

            local selected = {}

            for _, value in ipairs(data.CurrentOptions or {}) do
                selected[value] = true
            end

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.1,

                BorderSizePixel = 0,

                AutomaticSize = Enum.AutomaticSize.Y,

                Size = UDim2.new(1, 0, 0, 40),

                ZIndex = 30
            })

            Corner(Holder, 7)

            local Button = New("TextButton", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Size = UDim2.new(1, 0, 0, 40),

                Text = "",

                AutoButtonColor = false
            })

            local Label = New("TextLabel", {
                Parent = Button,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 0),

                Size = UDim2.new(0.45, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Multi Dropdown",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Value = New("TextLabel", {
                Parent = Button,

                BackgroundTransparency = 1,

                Position = UDim2.new(0.45, 0, 0, 0),

                Size = UDim2.new(0.5, 0, 1, 0),

                Font = Enum.Font.Gotham,

                Text = "None  ▾",

                TextColor3 = self.Theme.Accent,

                TextSize = 9,

                TextXAlignment = Enum.TextXAlignment.Right
            })

            local OptionsFrame = New("Frame", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 6, 0, 43),

                Size = UDim2.new(1, -12, 0, 0),

                Visible = false,

                ZIndex = 50
            })

            local Layout = New("UIListLayout", {
                Parent = OptionsFrame,

                Padding = UDim.new(0, 4)
            })

            local function UpdateText()

                local result = {}

                for _, option in ipairs(values) do
                    if selected[option] then
                        table.insert(result, tostring(option))
                    end
                end

                if #result == 0 then
                    Value.Text = "None  ▾"
                else
                    local text = table.concat(result, ", ")

                    if #text > 22 then
                        text = string.sub(text, 1, 22) .. "..."
                    end

                    Value.Text = text .. "  ▾"
                end

                if data.Flag then
                    self.Flags[data.Flag] = result
                end

                if typeof(data.Callback) == "function" then
                    task.spawn(function()
                        pcall(data.Callback, result)
                    end)
                end
            end

            for _, option in ipairs(values) do

                local Option = New("TextButton", {
                    Parent = OptionsFrame,

                    BackgroundColor3 = self.Theme.Tertiary,

                    BorderSizePixel = 0,

                    Size = UDim2.new(1, 0, 0, 30),

                    Font = Enum.Font.Gotham,

                    Text = tostring(option),

                    TextColor3 = self.Theme.Text,

                    TextSize = 9,

                    AutoButtonColor = false,

                    ZIndex = 60
                })

                Corner(Option, 6)

                self:_Connect(
                    Option.MouseButton1Click:Connect(function()

                        selected[option] =
                            not selected[option]

                        if selected[option] then
                            Option.BackgroundColor3 =
                                self.Theme.Accent
                        else
                            Option.BackgroundColor3 =
                                self.Theme.Tertiary
                        end

                        UpdateText()
                    end)
                )
            end

            OptionsFrame.Size = UDim2.new(
                1,
                -12,
                0,
                Layout.AbsoluteContentSize.Y
            )

            self:_Connect(Button.MouseButton1Click:Connect(function()

                OptionsFrame.Visible =
                    not OptionsFrame.Visible
            end))

            UpdateText()

            return {
                Get = function()
                    local result = {}

                    for _, option in ipairs(values) do
                        if selected[option] then
                            table.insert(result, option)
                        end
                    end

                    return result
                end,

                Set = function(newValues)

                    table.clear(selected)

                    for _, option in ipairs(newValues or {}) do
                        selected[option] = true
                    end

                    UpdateText()
                end
            }
        end

        --==================================================
        -- INPUT
        --==================================================

        function Tab:CreateInput(data)

            data = data or {}

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.1,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 56),

                ZIndex = 20
            })

            Corner(Holder, 7)

            local Label = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 5),

                Size = UDim2.new(1, -20, 0, 17),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Input",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Input = New("TextBox", {
                Parent = Holder,

                BackgroundColor3 = self.Theme.Tertiary,

                BackgroundTransparency = 0.1,

                BorderSizePixel = 0,

                Position = UDim2.new(0, 8, 0, 27),

                Size = UDim2.new(1, -16, 0, 23),

                Font = Enum.Font.Gotham,

                PlaceholderText = data.PlaceholderText or "Enter text...",

                PlaceholderColor3 = self.Theme.SubText,

                Text = data.CurrentValue or data.Default or "",

                TextColor3 = self.Theme.Text,

                TextSize = 9,

                ClearTextOnFocus = false,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            Corner(Input, 5)

            Padding(Input, 8, 8, 0, 0)

            self:_Connect(Input.FocusLost:Connect(function()

                if data.Flag then
                    self.Flags[data.Flag] = Input.Text
                end

                if typeof(data.Callback) == "function" then
                    task.spawn(function()
                        pcall(data.Callback, Input.Text)
                    end)
                end
            end))

            return {
                Input = Input,

                Get = function()
                    return Input.Text
                end,

                Set = function(value)
                    Input.Text = tostring(value)
                end
            }
        end

        --==================================================
        -- KEYBIND
        --==================================================

        function Tab:CreateKeybind(data)

            data = data or {}

            local currentKey =
                data.CurrentKeybind
                or data.Default
                or Enum.KeyCode.RightShift

            local listening = false

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.1,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 40),

                ZIndex = 20
            })

            Corner(Holder, 7)

            local Label = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 0),

                Size = UDim2.new(0.6, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Keybind",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local KeyButton = New("TextButton", {
                Parent = Holder,

                BackgroundColor3 = self.Theme.Tertiary,

                BorderSizePixel = 0,

                Position = UDim2.new(1, -105, 0.5, -12),

                Size = UDim2.new(0, 95, 0, 24),

                Font = Enum.Font.GothamMedium,

                Text = currentKey.Name,

                TextColor3 = self.Theme.Text,

                TextSize = 9,

                AutoButtonColor = false
            })

            Corner(KeyButton, 5)

            self:_Connect(KeyButton.MouseButton1Click:Connect(function()

                listening = true

                KeyButton.Text = "Press key..."

                Tween(KeyButton, {
                    BackgroundColor3 = self.Theme.Accent
                })
            end))

            self:_Connect(UserInputService.InputBegan:Connect(function(input, processed)

                if processed then
                    return
                end

                if listening then

                    if input.UserInputType == Enum.UserInputType.Keyboard then

                        currentKey = input.KeyCode

                        KeyButton.Text =
                            currentKey.Name

                        listening = false

                        Tween(KeyButton, {
                            BackgroundColor3 =
                                self.Theme.Tertiary
                        })

                    end

                    return
                end

                if input.KeyCode == currentKey then

                    if typeof(data.Callback) == "function" then
                        task.spawn(function()
                            pcall(data.Callback)
                        end)
                    end
                end
            end))

            return {
                Set = function(key)
                    currentKey = key
                    KeyButton.Text = key.Name
                end,

                Get = function()
                    return currentKey
                end
            }
        end

        --==================================================
        -- COLOR PICKER
        --==================================================

        function Tab:CreateColorPicker(data)

            data = data or {}

            local colors = data.Colors or {
                Color3.fromRGB(255, 80, 80),
                Color3.fromRGB(255, 150, 70),
                Color3.fromRGB(255, 220, 70),
                Color3.fromRGB(80, 220, 120),
                Color3.fromRGB(70, 160, 255),
                Color3.fromRGB(140, 80, 255),
                Color3.fromRGB(255, 80, 200),
                Color3.fromRGB(255, 255, 255)
            }

            local current =
                data.CurrentColor
                or data.Default
                or colors[1]

            local Holder = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Secondary,

                BackgroundTransparency = 0.1,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 40),

                ZIndex = 30
            })

            Corner(Holder, 7)

            local Label = New("TextLabel", {
                Parent = Holder,

                BackgroundTransparency = 1,

                Position = UDim2.new(0, 10, 0, 0),

                Size = UDim2.new(0.6, 0, 1, 0),

                Font = Enum.Font.GothamMedium,

                Text = data.Name or "Color",

                TextColor3 = self.Theme.Text,

                TextSize = 10,

                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Preview = New("TextButton", {
                Parent = Holder,

                BackgroundColor3 = current,

                BorderSizePixel = 0,

                Position = UDim2.new(1, -48, 0.5, -11),

                Size = UDim2.new(0, 38, 0, 22),

                Text = "",

                AutoButtonColor = false
            })

            Corner(Preview, 5)

            local Picker = New("Frame", {
                Parent = Holder,

                BackgroundColor3 = self.Theme.Tertiary,

                BorderSizePixel = 0,

                Position = UDim2.new(0, 5, 0, 44),

                Size = UDim2.new(1, -10, 0, 40),

                Visible = false,

                ZIndex = 80
            })

            Corner(Picker, 6)

            local Grid = New("UIGridLayout", {
                Parent = Picker,

                CellSize = UDim2.new(0, 24, 0, 24),

                CellPadding = UDim2.new(0, 5, 0, 5),

                HorizontalAlignment = Enum.HorizontalAlignment.Center,

                VerticalAlignment = Enum.VerticalAlignment.Center
            })

            for _, color in ipairs(colors) do

                local ColorButton = New("TextButton", {
                    Parent = Picker,

                    BackgroundColor3 = color,

                    BorderSizePixel = 0,

                    Text = "",

                    AutoButtonColor = false,

                    ZIndex = 90
                })

                Corner(ColorButton, 5)

                self:_Connect(
                    ColorButton.MouseButton1Click:Connect(function()

                        current = color

                        Preview.BackgroundColor3 =
                            current

                        Picker.Visible = false

                        if data.Flag then
                            self.Flags[data.Flag] = current
                        end

                        if typeof(data.Callback) == "function" then
                            task.spawn(function()
                                pcall(
                                    data.Callback,
                                    current
                                )
                            end)
                        end
                    end)
                )
            end

            self:_Connect(Preview.MouseButton1Click:Connect(function()
                Picker.Visible = not Picker.Visible
            end))

            return {
                Set = function(color)

                    current = color

                    Preview.BackgroundColor3 =
                        current

                    if data.Flag then
                        self.Flags[data.Flag] =
                            current
                    end
                end,

                Get = function()
                    return current
                end
            }
        end

        --==================================================
        -- DIVIDER
        --==================================================

        function Tab:CreateDivider()

            local Divider = New("Frame", {
                Parent = Page,

                BackgroundColor3 = self.Theme.Border,

                BackgroundTransparency = 0.45,

                BorderSizePixel = 0,

                Size = UDim2.new(1, 0, 0, 1)
            })

            return Divider
        end

        return Tab
    end

    --==================================================
    -- MINIMIZE
    --==================================================

    local minimized = false

    function self:Minimize()

        if minimized then
            return
        end

        minimized = true

        Body.Visible = false

        Tween(Window, {
            BackgroundTransparency = 1
        })

        task.delay(Library.Config.AnimationSpeed, function()

            if not self.Window then
                return
            end

            Window.Visible = false

            MinimizedButton.Visible = true

            MinimizedButton.Size =
                UDim2.new(0, 20, 0, 36)

            MinimizedButton.TextTransparency = 1

            Tween(
                MinimizedButton,
                {
                    Size = UDim2.new(0, 145, 0, 36)
                }
            )

            Tween(
                MinimizedButton,
                {
                    TextTransparency = 0
                }
            )
        end)
    end

    --==================================================
    -- RESTORE
    --==================================================

    function self:Restore()

        if not minimized then
            return
        end

        minimized = false

        MinimizedButton.Visible = false

        Window.Visible = true

        Window.BackgroundTransparency = 1

        Body.Visible = true

        Tween(Window, {
            BackgroundTransparency =
                Library.Config.Transparency
        })
    end

    --==================================================
    -- MINIMIZE BUTTON EVENTS
    --==================================================

    self:_Connect(
        MinimizeButton.MouseButton1Click:Connect(function()
            self:Minimize()
        end)
    )

    self:_Connect(
        MinimizedButton.MouseButton1Click:Connect(function()
            self:Restore()
        end)
    )

    --==================================================
    -- CLOSE
    --==================================================

    self:_Connect(
        CloseButton.MouseButton1Click:Connect(function()
            self:Destroy()
        end)
    )

    --==================================================
    -- NOTIFICATIONS
    --==================================================

    self.NotificationHolder = New("Frame", {
        Parent = ScreenGui,

        BackgroundTransparency = 1,

        AnchorPoint = Vector2.new(1, 1),

        Position = UDim2.new(1, -15, 1, -15),

        Size = UDim2.new(0, 260, 1, -30),

        ZIndex = 1000
    })

    local NotificationLayout = New("UIListLayout", {
        Parent = self.NotificationHolder,

        Padding = UDim.new(0, 7),

        HorizontalAlignment = Enum.HorizontalAlignment.Right,

        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    function self:Notify(data)

        data = data or {}

        local notification = New("Frame", {
            Parent = self.NotificationHolder,

            BackgroundColor3 = self.Theme.Secondary,

            BackgroundTransparency = 0.05,

            BorderSizePixel = 0,

            Size = UDim2.new(0, 245, 0, 65),

            ZIndex = 1001
        })

        Corner(notification, 8)

        Stroke(
            notification,
            self.Theme.Border,
            0.35,
            1
        )

        local title = New("TextLabel", {
            Parent = notification,

            BackgroundTransparency = 1,

            Position = UDim2.new(0, 10, 0, 8),

            Size = UDim2.new(1, -20, 0, 18),

            Font = Enum.Font.GothamBold,

            Text = data.Title or "Notification",

            TextColor3 = self.Theme.Text,

            TextSize = 10,

            TextXAlignment = Enum.TextXAlignment.Left
        })

        local content = New("TextLabel", {
            Parent = notification,

            BackgroundTransparency = 1,

            Position = UDim2.new(0, 10, 0, 28),

            Size = UDim2.new(1, -20, 0, 28),

            Font = Enum.Font.Gotham,

            Text = data.Content or data.Text or "",

            TextColor3 = self.Theme.SubText,

            TextSize = 9,

            TextWrapped = true,

            TextXAlignment = Enum.TextXAlignment.Left
        })

        notification.Position =
            UDim2.new(1, 30, 0, 0)

        Tween(notification, {
            Position = UDim2.new(0, 0, 0, 0)
        })

        task.delay(data.Duration or 3, function()

            if notification.Parent then

                Tween(notification, {
                    Position =
                        UDim2.new(1, 30, 0, 0),
                    BackgroundTransparency = 1
                })

                task.wait(
                    Library.Config.AnimationSpeed
                )

                notification:Destroy()
            end
        end)

        return notification
    end

    --==================================================
    -- SEARCH
    --==================================================

    function self:CreateSearch()

        local Search = New("TextBox", {
            Parent = Sidebar,

            BackgroundColor3 = self.Theme.Tertiary,

            BackgroundTransparency = 0.1,

            BorderSizePixel = 0,

            Position = UDim2.new(0, 8, 0, 8),

            Size = UDim2.new(1, -16, 0, 30),

            Font = Enum.Font.Gotham,

            PlaceholderText = "Search...",

            PlaceholderColor3 = self.Theme.SubText,

            Text = "",

            TextColor3 = self.Theme.Text,

            TextSize = 9,

            ClearTextOnFocus = false,

            ZIndex = 40
        })

        Corner(Search, 6)

        Padding(Search, 8, 8, 0, 0)

        TabList.Position =
            UDim2.new(0, 0, 0, 43)

        TabList.Size =
            UDim2.new(1, 0, 1, -43)

        self:_Connect(Search:GetPropertyChangedSignal("Text"):Connect(function()

            local query =
                string.lower(Search.Text)

            for _, tab in ipairs(self.Tabs) do

                local name =
                    string.lower(tab.Name)

                tab.Button.Visible =
                    query == ""
                    or string.find(name, query, 1, true) ~= nil
            end
        end))

        return Search
    end

    --==================================================
    -- THEME
    --==================================================

    function self:SetTheme(theme)

        local selectedTheme =
            Library.Themes[theme]

        if not selectedTheme then
            return
        end

        self.Theme = selectedTheme

        Window.BackgroundColor3 =
            selectedTheme.Background

        TopBar.BackgroundColor3 =
            selectedTheme.Secondary

        Sidebar.BackgroundColor3 =
            selectedTheme.Secondary

        self.WindowStroke.Color =
            selectedTheme.Border

        MinimizedButton.BackgroundColor3 =
            selectedTheme.Secondary

        self.MinimizedStroke.Color =
            selectedTheme.Border
    end

    --==================================================
    -- SCALE
    --==================================================

    function self:SetScale(scale)

        scale = tonumber(scale)

        if not scale then
            return
        end

        UIScale.Scale = math.clamp(
            scale,
            0.4,
            1.5
        )
    end

    --==================================================
    -- FLAGS
    --==================================================

    function self:SetFlag(name, value)
        self.Flags[name] = value
    end

    function self:GetFlag(name)
        return self.Flags[name]
    end

    function self:GetFlags()
        return self.Flags
    end

    function self:ResetFlags()
        table.clear(self.Flags)
    end

    --==================================================
    -- DESTROY
    --==================================================

    function self:Destroy()

        self:_CleanupConnections()

        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end

        self.ScreenGui = nil
        self.Window = nil
    end

    return self
end

return Library
