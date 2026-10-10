-- ==========================================================================
-- SOVEREIGN HUB [ BLADE BALL ] - Fully Integrated Script with Key System
-- Custom Independent UI Matching Key System Theme (Dark/Red) & Original Logic
-- ==========================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local Debris = game:GetService("Debris")

-- // Key System UI //
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "SovereignKeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 240)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = KeyGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(180, 50, 50)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Sovereign Hub [ Blade Ball ] - Key System"
Title.TextColor3 = Color3.fromRGB(240, 230, 230)
Title.TextSize = 14
Title.Parent = MainFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 340, 0, 40)
KeyInput.Position = UDim2.new(0.5, -170, 0, 65)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
KeyInput.BorderSizePixel = 0
KeyInput.PlaceholderText = "Enter Key here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 130, 130)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 14
KeyInput.Parent = MainFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInput

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 160, 0, 35)
SubmitBtn.Position = UDim2.new(0.5, -170, 0, 120)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
SubmitBtn.Text = "Submit Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 13
SubmitBtn.Parent = MainFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitBtn

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 160, 0, 35)
DiscordBtn.Position = UDim2.new(0.5, 10, 0, 120)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
DiscordBtn.Text = "Join Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 13
DiscordBtn.Parent = MainFrame

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 6)
DiscordCorner.Parent = DiscordBtn

local NoticeLabel = Instance.new("TextLabel")
NoticeLabel.Size = UDim2.new(1, -40, 0, 40)
NoticeLabel.Position = UDim2.new(0, 20, 0, 170)
NoticeLabel.BackgroundTransparency = 1
NoticeLabel.Font = Enum.Font.Gotham
NoticeLabel.Text = "join our discord to get key discord : https://discord.gg/HSWFDjA78Q"
NoticeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
NoticeLabel.TextSize = 11
NoticeLabel.TextWrapped = true
NoticeLabel.Parent = MainFrame

local authorized = false

DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/HSWFDjA78Q")
    end)
    NoticeLabel.Text = "Discord link copied to clipboard!"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "SOVEREIGNEMPIRE" then
        authorized = true
        KeyGui:Destroy()
    else
        NoticeLabel.Text = "Incorrect Key! Get it from https://discord.gg/HSWFDjA78Q"
        NoticeLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
    end
end)

repeat task.wait() until authorized

-- // Configuration & Original Script Setup \\
_G.primas = true
setfpscap(9999)

cloneref = cloneref or function(x) return x end

_G.config = {
    accuracy = 100,
    spam_threshold = 3,
    curve_keybind = nil,
    manual_notify = false,
    curve_notify = false,
    curve_method = 'Camera',
    anti_phantom = false,
    anti_cooldown = false,
    skin_changer = false,
    manual_spam = false,
    manual_spam_kps = 100,
    ability_esp = false,
    auto_parry = false,
    ball_debug = false,
    auto_spam = false,
    ping_fix = false,
    names = '',
    avatar_changer = false,
    avatar_name = '',
    random_target = false,
    ui_keybind = "RightShift",
    det_infinity = false,
    det_deathslash = false,
    det_timehole = false,
    det_pull = false,
    det_singularity = false,
    det_slashes = false,
    det_slashes_delay = 0.05,
    det_slashes_max = 36,
    det_forcefield = false,
    det_staff = false,
    det_staff_action = "Notification",
    animfix_parry = false,
    animfix_spam = false,
    animfix_manual = false,
    player_cosmetics = false,
    triggerbot_notify = false,
    manual_spam_ui = false,
    triggerbot_ui = false,
    thunder_dash_nocd = false,
    super_jump_nocd = false,
    dash_nocd = false,
    immortality = false,
    immortal_notify = false,
    immortal_radius = 25,
    immortal_height = 30,
    custom_announcer = false,
    announcer_text = "",
}

if not isfolder("angeli/configs") then
    makefolder("angeli/configs")
end
local CONFIG_PATH = "angeli/configs/blade_ball.json"

local function save_cfg()
    writefile(CONFIG_PATH, HttpService:JSONEncode(_G.config))
end

local function load_cfg()
    if isfile(CONFIG_PATH) then
        _G.config = HttpService:JSONDecode(readfile(CONFIG_PATH))
    end
end

load_cfg()

task.spawn(function()
    repeat
        save_cfg()
        task.wait(1)
    until not _G.primas
end)

-- // Custom Independent UI Library Construction \\
local SovereignUI = {}

function SovereignUI:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SovereignHubMain"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Name = "MainContainer"
    Main.Size = UDim2.new(0, 580, 0, 400)
    Main.Position = UDim2.new(0.5, -290, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(180, 50, 50)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = Main

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 36)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(240, 230, 230)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Tab Panel Container (Left)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 135, 1, -46)
    TabContainer.Position = UDim2.new(0, 8, 0, 42)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = Main

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabContainer

    -- Content Scroll Panels Container (Right)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -155, 1, -46)
    ContentContainer.Position = UDim2.new(0, 148, 0, 42)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main

    local WindowObj = {}
    local firstTab = true

    function WindowObj:CreateTab(tabName)
        local TabScroll = Instance.new("ScrollingFrame")
        TabScroll.Size = UDim2.new(1, 0, 1, 0)
        TabScroll.BackgroundTransparency = 1
        TabScroll.ScrollBarThickness = 2
        TabScroll.Visible = firstTab
        TabScroll.Parent = ContentContainer

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabScroll

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = firstTab and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(30, 15, 15)
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Color3.fromRGB(240, 230, 230)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = TabContainer

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in ipairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then child.BackgroundColor3 = Color3.fromRGB(30, 15, 15) end
            end
            TabScroll.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end)

        firstTab = false

        local TabObj = {}

        function TabObj:CreateSection(sectionName)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 22)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.Text = "  " .. sectionName
            SecLabel.TextColor3 = Color3.fromRGB(180, 50, 50)
            SecLabel.TextSize = 11
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabScroll
        end

        function TabObj:CreateToggle(opts)
            local title = opts.Title or opts[1] or "Toggle"
            local default = opts.Default or opts.CurrentValue or false
            local callback = opts.Callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabScroll

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = ToggleFrame

            local TLabel = Instance.new("TextLabel")
            TLabel.Size = UDim2.new(1, -60, 1, 0)
            TLabel.Position = UDim2.new(0, 10, 0, 0)
            TLabel.BackgroundTransparency = 1
            TLabel.Font = Enum.Font.GothamBold
            TLabel.Text = title
            TLabel.TextColor3 = Color3.fromRGB(230, 220, 220)
            TLabel.TextSize = 12
            TLabel.TextXAlignment = Enum.TextXAlignment.Left
            TLabel.Parent = ToggleFrame

            local StateBox = Instance.new("TextButton")
            StateBox.Size = UDim2.new(0, 40, 0, 20)
            StateBox.Position = UDim2.new(1, -48, 0.5, -10)
            StateBox.BackgroundColor3 = default and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(60, 30, 30)
            StateBox.Text = ""
            StateBox.Parent = ToggleFrame

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = StateBox

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            Indicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Parent = StateBox

            local ICorner = Instance.new("UICorner")
            ICorner.CornerRadius = UDim.new(1, 0)
            ICorner.Parent = Indicator

            local active = default
            StateBox.MouseButton1Click:Connect(function()
                active = not active
                StateBox.BackgroundColor3 = active and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(60, 30, 30)
                Indicator.Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                pcall(callback, active)
            end)

            local ToggleObj = {}
            function ToggleObj:Set(val)
                active = val
                StateBox.BackgroundColor3 = active and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(60, 30, 30)
                Indicator.Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                pcall(callback, active)
            end
            function ToggleObj:Get() return active end
            return ToggleObj
        end

        function TabObj:CreateSlider(opts)
            local title = opts.Title or "Slider"
            local min = opts.Min or (opts.Range and opts.Range[1]) or 0
            local max = opts.Max or (opts.Range and opts.Range[2]) or 100
            local default = opts.Default or opts.CurrentValue or min
            local callback = opts.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabScroll

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 6)
            SCorner.Parent = SliderFrame

            local SLabel = Instance.new("TextLabel")
            SLabel.Size = UDim2.new(1, -20, 0, 24)
            SLabel.Position = UDim2.new(0, 10, 0, 4)
            SLabel.BackgroundTransparency = 1
            SLabel.Font = Enum.Font.GothamBold
            SLabel.Text = title .. ": " .. tostring(default)
            SLabel.TextColor3 = Color3.fromRGB(230, 220, 220)
            SLabel.TextSize = 12
            SLabel.TextXAlignment = Enum.TextXAlignment.Left
            SLabel.Parent = SliderFrame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 6)
            Track.Position = UDim2.new(0, 10, 0, 34)
            Track.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            Track.BorderSizePixel = 0
            Track.Parent = SliderFrame

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(1, 0)
            TCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(math.clamp((default - min)/(max - min), 0, 1), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local dragging = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos + 0.5)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    SLabel.Text = title .. ": " .. tostring(val)
                    pcall(callback, val)
                end
            end)
        end

        function TabObj:CreateDropdown(opts)
            local title = opts.Title or opts[1] or "Dropdown"
            local options = opts.Options or {}
            local default = opts.CurrentOption or opts.Default or options[1] or ""
            local callback = opts.Callback or function() end

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 36)
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
            DropFrame.BorderSizePixel = 0
            DropFrame.Parent = TabScroll

            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 6)
            DCorner.Parent = DropFrame

            local DLabel = Instance.new("TextLabel")
            DLabel.Size = UDim2.new(0.5, 0, 1, 0)
            DLabel.Position = UDim2.new(0, 10, 0, 0)
            DLabel.BackgroundTransparency = 1
            DLabel.Font = Enum.Font.GothamBold
            DLabel.Text = title
            DLabel.TextColor3 = Color3.fromRGB(230, 220, 220)
            DLabel.TextSize = 12
            DLabel.TextXAlignment = Enum.TextXAlignment.Left
            DLabel.Parent = DropFrame

            local SelectBtn = Instance.new("TextButton")
            SelectBtn.Size = UDim2.new(0, 140, 0, 24)
            SelectBtn.Position = UDim2.new(1, -150, 0.5, -12)
            SelectBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            SelectBtn.Text = tostring(default)
            SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectBtn.Font = Enum.Font.Gotham
            SelectBtn.TextSize = 11
            SelectBtn.Parent = DropFrame

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 4)
            SCorner.Parent = SelectBtn

            local idx = 1
            for i, v in ipairs(options) do
                if v == default then idx = i break end
            end

            SelectBtn.MouseButton1Click:Connect(function()
                idx = idx + 1
                if idx > #options then idx = 1 end
                local chosen = options[idx]
                SelectBtn.Text = tostring(chosen)
                pcall(callback, chosen)
            end)
        end

        function TabObj:CreateButton(opts)
            local title = opts.Title or opts.Name or "Button"
            local callback = opts.Callback or function() end

            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Size = UDim2.new(1, 0, 0, 36)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
            BtnFrame.BorderSizePixel = 0
            BtnFrame.Text = "  " .. title
            BtnFrame.TextColor3 = Color3.fromRGB(230, 220, 220)
            BtnFrame.Font = Enum.Font.GothamBold
            BtnFrame.TextSize = 12
            BtnFrame.TextXAlignment = Enum.TextXAlignment.Left
            BtnFrame.Parent = TabScroll

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = BtnFrame

            BtnFrame.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function TabObj:CreateInput(opts)
            local title = opts.Title or "Input"
            local default = opts.CurrentValue or ""
            local callback = opts.Callback or function() end

            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 42)
            InputFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabScroll

            local ICorner = Instance.new("UICorner")
            ICorner.CornerRadius = UDim.new(0, 6)
            ICorner.Parent = InputFrame

            local ILabel = Instance.new("TextLabel")
            ILabel.Size = UDim2.new(0.5, 0, 1, 0)
            ILabel.Position = UDim2.new(0, 10, 0, 0)
            ILabel.BackgroundTransparency = 1
            ILabel.Font = Enum.Font.GothamBold
            ILabel.Text = title
            ILabel.TextColor3 = Color3.fromRGB(230, 220, 220)
            ILabel.TextSize = 12
            ILabel.TextXAlignment = Enum.TextXAlignment.Left
            ILabel.Parent = InputFrame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0, 140, 0, 26)
            TextBox.Position = UDim2.new(1, -150, 0.5, -13)
            TextBox.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            TextBox.Text = tostring(default)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderText = "Type here..."
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 11
            TextBox.Parent = InputFrame

            local TBCorner = Instance.new("UICorner")
            TBCorner.CornerRadius = UDim.new(0, 4)
            TBCorner.Parent = TextBox

            TextBox.FocusLost:Connect(function()
                pcall(callback, TextBox.Text)
            end)
        end

        function TabObj:CreateKeybind(opts)
            local title = opts.Title or "Keybind"
            local default = opts.Default or Enum.KeyCode.RightShift
            local callback = opts.Callback or function() end

            local KeyFrame = Instance.new("Frame")
            KeyFrame.Size = UDim2.new(1, 0, 0, 36)
            KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
            KeyFrame.BorderSizePixel = 0
            KeyFrame.Parent = TabScroll

            local KCorner = Instance.new("UICorner")
            KCorner.CornerRadius = UDim.new(0, 6)
            KCorner.Parent = KeyFrame

            local KLabel = Instance.new("TextLabel")
            KLabel.Size = UDim2.new(0.5, 0, 1, 0)
            KLabel.Position = UDim2.new(0, 10, 0, 0)
            KLabel.BackgroundTransparency = 1
            KLabel.Font = Enum.Font.GothamBold
            KLabel.Text = title
            KLabel.TextColor3 = Color3.fromRGB(230, 220, 220)
            KLabel.TextSize = 12
            KLabel.TextXAlignment = Enum.TextXAlignment.Left
            KLabel.Parent = KeyFrame

            local KeyBtn = Instance.new("TextButton")
            KeyBtn.Size = UDim2.new(0, 100, 0, 24)
            KeyBtn.Position = UDim2.new(1, -110, 0.5, -12)
            KeyBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            KeyBtn.Text = tostring(default.Name or default)
            KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeyBtn.Font = Enum.Font.GothamBold
            KeyBtn.TextSize = 11
            KeyBtn.Parent = KeyFrame

            local KBtnCorner = Instance.new("UICorner")
            KBtnCorner.CornerRadius = UDim.new(0, 4)
            KBtnCorner.Parent = KeyBtn

            local binding = false
            KeyBtn.MouseButton1Click:Connect(function()
                binding = true
                KeyBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    binding = false
                    KeyBtn.Text = input.KeyCode.Name
                    pcall(callback, input.KeyCode)
                end
            end)
        end

        return TabObj
    end

    return WindowObj
end

-- // Feature Implementations matching Original Logic \\
local Window = SovereignUI:CreateWindow("Sovereign Hub [ Blade Ball ]")

local MainTab = Window:CreateTab("Main")
local DetectionsTab = Window:CreateTab("Detections")
local VisualTab = Window:CreateTab("Visual")
local ExclusiveTab = Window:CreateTab("Exclusive")
local SettingsTab = Window:CreateTab("UI Settings")

-- Helpers & Core Utilities
local BallHelper = {}
function BallHelper.get_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then return ball end
    end
end

function BallHelper.parry()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.02)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

-- Exclusive Features: No Cooldown
local noCdState = {}
local function startNoCooldown(name)
    noCdState[name] = task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                local shared = ReplicatedStorage:FindFirstChild("Shared")
                local abilities = shared and shared:FindFirstChild("Abilities")
                local m = abilities and abilities:FindFirstChild(name)
                if m then
                    local mod = require(m)
                    mod.cooldown = 0
                    mod.cooldownReductionPerUpgrade = 0
                end
            end)
        end
    end)
end

local function stopNoCooldown(name)
    if noCdState[name] then
        task.cancel(noCdState[name])
        noCdState[name] = nil
    end
end

ExclusiveTab:CreateSection("No Cooldown")
ExclusiveTab:CreateToggle({
    Title = "Thunder Dash 0 Cooldown",
    CurrentValue = _G.config.thunder_dash_nocd,
    Callback = function(enabled)
        _G.config.thunder_dash_nocd = enabled
        if enabled then startNoCooldown("Thunder Dash") else stopNoCooldown("Thunder Dash") end
    end
})

ExclusiveTab:CreateToggle({
    Title = "Dash 0 Cooldown",
    CurrentValue = _G.config.dash_nocd,
    Callback = function(enabled)
        _G.config.dash_nocd = enabled
        if enabled then startNoCooldown("Dash") else stopNoCooldown("Dash") end
    end
})

ExclusiveTab:CreateToggle({
    Title = "Super Jump 0 Cooldown",
    CurrentValue = _G.config.super_jump_nocd,
    Callback = function(enabled)
        _G.config.super_jump_nocd = enabled
        if enabled then startNoCooldown("Super Jump") else stopNoCooldown("Super Jump") end
    end
})

-- Exclusive Features: Immortality & Desync Orbit
local immortalConn
ExclusiveTab:CreateSection("Immortality")
ExclusiveTab:CreateToggle({
    Title = "Immortality",
    CurrentValue = _G.config.immortality,
    Callback = function(enabled)
        _G.config.immortality = enabled
        if enabled then
            immortalConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and workspace:FindFirstChild("Alive") and char.Parent == workspace.Alive then
                        local orig = hrp.CFrame
                        local angle = math.random(-100, 100)
                        hrp.CFrame = CFrame.new(orig.Position.X + math.cos(angle) * _G.config.immortal_radius, orig.Position.Y + _G.config.immortal_height, orig.Position.Z + math.sin(angle) * _G.config.immortal_radius)
                        RunService.RenderStepped:Wait()
                        hrp.CFrame = orig
                    end
                end)
            end)
        else
            if immortalConn then immortalConn:Disconnect() immortalConn = nil end
        end
    end
})

ExclusiveTab:CreateSlider({
    Title = "Immortal Radius",
    Min = 0, Max = 100,
    CurrentValue = _G.config.immortal_radius,
    Callback = function(val) _G.config.immortal_radius = val end
})

ExclusiveTab:CreateSlider({
    Title = "Immortal Height",
    Min = 0, Max = 60,
    CurrentValue = _G.config.immortal_height,
    Callback = function(val) _G.config.immortal_height = val end
})

-- Main Tab Features
MainTab:CreateSection("Automatic")
local autoParryConn
MainTab:CreateToggle({
    Title = "Auto Parry",
    CurrentValue = _G.config.auto_parry,
    Callback = function(enabled)
        _G.config.auto_parry = enabled
        if enabled then
            autoParryConn = RunService.PreSimulation:Connect(function()
                pcall(function()
                    local ball = BallHelper.get_ball()
                    if not ball or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                    local target = ball:GetAttribute("target")
                    if target == LocalPlayer.Name and dist <= 28 then
                        BallHelper.parry()
                    end
                end)
            end)
        else
            if autoParryConn then autoParryConn:Disconnect() autoParryConn = nil end
        end
    end
})

MainTab:CreateSlider({
    Title = "Parry Accuracy",
    Min = 1, Max = 100,
    CurrentValue = _G.config.accuracy,
    Callback = function(val) _G.config.accuracy = val end
})

MainTab:CreateDropdown({
    Title = "Curve Method",
    Options = {"Camera", "Dot", "Backwards", "Slow", "Random"},
    CurrentOption = _G.config.curve_method,
    Callback = function(val) _G.config.curve_method = val end
})

MainTab:CreateToggle({
    Title = "Random Target",
    CurrentValue = _G.config.random_target,
    Callback = function(enabled) _G.config.random_target = enabled end
})

-- Detections Tab Features
DetectionsTab:CreateSection("Detections")
DetectionsTab:CreateToggle({
    Title = "Anti Phantom",
    CurrentValue = _G.config.anti_phantom,
    Callback = function(enabled) _G.config.anti_phantom = enabled end
})

DetectionsTab:CreateToggle({
    Title = "Infinity Detection",
    CurrentValue = _G.config.det_infinity,
    Callback = function(enabled) _G.config.det_infinity = enabled end
})

DetectionsTab:CreateToggle({
    Title = "DeathSlash Detection",
    CurrentValue = _G.config.det_deathslash,
    Callback = function(enabled) _G.config.det_deathslash = enabled end
})

DetectionsTab:CreateToggle({
    Title = "TimeHole Detection",
    CurrentValue = _G.config.det_timehole,
    Callback = function(enabled) _G.config.det_timehole = enabled end
})

DetectionsTab:CreateToggle({
    Title = "Pull Detection",
    CurrentValue = _G.config.det_pull,
    Callback = function(enabled) _G.config.det_pull = enabled end
})

DetectionsTab:CreateToggle({
    Title = "Forcefield Detection",
    CurrentValue = _G.config.det_forcefield,
    Callback = function(enabled) _G.config.det_forcefield = enabled end
})

-- Visual Tab Features
VisualTab:CreateSection("Visuals & ESP")
VisualTab:CreateToggle({
    Title = "Ability ESP",
    CurrentValue = _G.config.ability_esp,
    Callback = function(enabled)
        _G.config.ability_esp = enabled
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local bb = head:FindFirstChild("SovereignESP")
                    if enabled and not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = "SovereignESP"
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = head
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lbl.TextSize = 11
                        lbl.Font = Enum.Font.GothamBold
                        lbl.Text = plr.DisplayName .. " [" .. tostring(plr:GetAttribute("EquippedAbility") or "None") .. "]"
                        lbl.Parent = bb
                    elseif not enabled and bb then
                        bb:Destroy()
                    end
                end
            end
        end
    end
})

VisualTab:CreateToggle({
    Title = "Player Cosmetics",
    CurrentValue = _G.config.player_cosmetics,
    Callback = function(enabled) _G.config.player_cosmetics = enabled end
})

-- Settings Tab Features
SettingsTab:CreateSection("Custom UI Options")
SettingsTab:CreateKeybind({
    Title = "Toggle UI Keybind",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key) _G.config.ui_keybind = key.Name end
})

SettingsTab:CreateButton({
    Title = "Unload Hub",
    Callback = function()
        pcall(function()
            if autoParryConn then autoParryConn:Disconnect() end
            if immortalConn then immortalConn:Disconnect() end
            for k, _ in pairs(noCdState) do stopNoCooldown(k) end
            PlayerGui:FindFirstChild("SovereignHubMain"):Destroy()
        end)
    end
})
