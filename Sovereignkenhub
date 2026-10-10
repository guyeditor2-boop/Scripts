-- ==========================================================================
-- SOVEREIGN HUB [ BLADE BALL ]
-- All-in-One Integrated Script with Key System & Full Wind UI Integration
-- ==========================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // Key System UI Implementation \\
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

-- // Main Sovereign Hub / Blade Ball Script Execution \\
_G.primas = true

setfpscap(9999)

cloneref = cloneref or function(x) return x end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))
local Debris = cloneref(game:GetService("Debris"))
local Stats = cloneref(game:GetService("Stats"))

_G.config = {
    accuracy = nil,
    spam_threshold = nil,
    curve_keybind = nil,
    manual_notify = nil,
    curve_notify = nil,
    curve_method = '',
    anti_phantom = nil,
    anti_cooldown = nil,
    skin_changer = nil,
    manual_spam = nil,
    manual_spam_kps = nil,
    ability_esp = nil,
    auto_parry = nil,
    ball_debug = nil,
    auto_spam = nil,
    ping_fix = nil,
    names = '',
    avatar_changer = nil,
    avatar_name = '',
    random_target = nil,
    theme_accent = nil,
    theme_accent_dark = nil,
    theme_background = nil,
    theme_text = nil,
    ui_keybind = nil,
    det_infinity = nil,
    det_deathslash = nil,
    det_timehole = nil,
    det_pull = nil,
    det_singularity = nil,
    det_slashes = nil,
    det_slashes_delay = nil,
    det_slashes_max = nil,
    det_forcefield = nil,
    det_staff = nil,
    det_staff_action = nil,
    animfix_parry = nil,
    animfix_spam = nil,
    animfix_manual = nil,
    player_cosmetics = nil,
    triggerbot_notify = nil,
    manual_spam_ui = nil,
    triggerbot_ui = nil,
    thunder_dash_nocd = nil,
    super_jump_nocd = nil,
    dash_nocd = nil,
    immortality = nil,
    immortal_notify = nil,
    immortal_radius = nil,
    immortal_height = nil,
    custom_announcer = nil,
    announcer_text = nil,
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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()

local Window = Library:CreateWindow({
    Name = "Sovereign Hub",
    LoadingSubtitle = "Blade Ball",
    ToggleUIKeybind = _G.config.ui_keybind or "RightShift",
})

local MainTab = Window:CreateTab({ Name = "Main", Desc = "Blade Ball", Icon = "swords" })
local DetectionsTab = Window:CreateTab({ Name = "Detections", Icon = "shield" })
local VisualTab = Window:CreateTab({ Name = "Visual", Desc = "esp and overlays", Icon = "eye" })
local ExclusiveTab = Window:CreateTab({ Name = "Exclusive", Icon = "star" })
local SettingsTab = Window:CreateTab({ Name = "UI Settings", Desc = "menu and keybinds", Icon = "settings" })

-- Feature integrations mapping completely from provided source logic --
local noCdState = {}
local function ensureAbilityMod(name)
    local st = noCdState[name]
    if not st then
        st = {}
        noCdState[name] = st
    end
    if st.mod then return true end
    local shared = ReplicatedStorage:FindFirstChild("Shared")
    local abilities = shared and shared:FindFirstChild("Abilities")
    local m = abilities and abilities:FindFirstChild(name)
    if not m then return false end
    local ok, result = pcall(require, m)
    if ok and result then
        st.mod = result
        st.origCd = result.cooldown
        st.origCdr = result.cooldownReductionPerUpgrade
        return true
    end
    return false
end

local function applyNoCooldown(name)
    if not ensureAbilityMod(name) then return end
    local st = noCdState[name]
    pcall(function()
        st.mod.cooldown = 0
        st.mod.cooldownReductionPerUpgrade = 0
    end)
end

local function restoreCooldown(name)
    local st = noCdState[name]
    if not st or not st.mod then return end
    pcall(function()
        st.mod.cooldown = st.origCd
        st.mod.cooldownReductionPerUpgrade = st.origCdr
    end)
end

local function startNoCooldown(name)
    local st = noCdState[name]
    if not st then
        st = {}
        noCdState[name] = st
    end
    if st.conn then return end
    applyNoCooldown(name)
    st.conn = task.spawn(function()
        while st.conn do
            applyNoCooldown(name)
            task.wait(0.5)
        end
    end)
end

local function stopNoCooldown(name)
    local st = noCdState[name]
    if st then st.conn = nil end
    restoreCooldown(name)
end

ExclusiveTab:CreateSection("No Cooldown")

ExclusiveTab:CreateToggle({
    Name = "Thunder Dash 0 Cooldown",
    CurrentValue = _G.config.thunder_dash_nocd or false,
    Flag = "ThunderDashNoCd",
    Callback = function(enabled)
        _G.config.thunder_dash_nocd = enabled
        if enabled then startNoCooldown("Thunder Dash") else stopNoCooldown("Thunder Dash") end
    end
})

ExclusiveTab:CreateToggle({
    Name = "Dash 0 Cooldown",
    CurrentValue = _G.config.dash_nocd or false,
    Flag = "DashNoCd",
    Callback = function(enabled)
        _G.config.dash_nocd = enabled
        if enabled then startNoCooldown("Dash") else stopNoCooldown("Dash") end
    end
})

ExclusiveTab:CreateToggle({
    Name = "Super Jump 0 Cooldown",
    CurrentValue = _G.config.super_jump_nocd or false,
    Flag = "SuperJumpNoCd",
    Callback = function(enabled)
        _G.config.super_jump_nocd = enabled
        if enabled then startNoCooldown("Super Jump") else stopNoCooldown("Super Jump") end
    end
})

local immortalState = { enabled = false, notify = false, heartbeatConnection = nil }
local immortalDesync = { originalCFrame = nil, originalVelocity = nil }
local immortalCache = { character = nil, hrp = nil, head = nil, aliveFolder = nil }
local immortalOldIndex = nil
local immortalConsts = {
    emptyCFrame = CFrame.new(),
    radius = math.clamp(tonumber(_G.config.immortal_radius) or 25, 0, 100),
    baseHeight = 5,
    riseHeight = math.clamp(tonumber(_G.config.immortal_height) or 30, 0, 60),
    cycleSpeed = 11.9,
    velocity = Vector3.new(1, 1, 1),
}

local function updateImmortalCache()
    local character = LocalPlayer.Character
    if character ~= immortalCache.character then
        immortalCache.character = character
        if character then
            immortalCache.hrp = character:FindFirstChild("HumanoidRootPart")
            immortalCache.head = character:FindFirstChild("Head")
            immortalCache.aliveFolder = workspace:FindFirstChild("Alive")
            if immortalCache.hrp then
                immortalCache.headOffset = Vector3.new(0, immortalCache.hrp.Size.Y * 0.5 + 0.5, 0)
            end
        else
            immortalCache.hrp = nil
            immortalCache.head = nil
        end
    end
end

local function isImmortalAlive()
    return immortalCache.aliveFolder and immortalCache.character and immortalCache.character.Parent == immortalCache.aliveFolder
end

local function calcOrbitPosition(hrp)
    local angle = math.random(-2147483647, 2147483647) * 1000
    local cycle = math.floor(tick() * immortalConsts.cycleSpeed) % 2
    local yOffset = cycle == 0 and 0 or immortalConsts.riseHeight
    local pos = hrp.Position
    local yBase = pos.Y - hrp.Size.Y * 0.5 + immortalConsts.baseHeight + yOffset
    return CFrame.new(
        pos.X + math.cos(angle) * immortalConsts.radius,
        yBase,
        pos.Z + math.sin(angle) * immortalConsts.radius
    )
end

local function performImmortalDesync()
    updateImmortalCache()
    if not immortalState.enabled or not immortalCache.hrp or not isImmortalAlive() then return end
    local hrp = immortalCache.hrp
    immortalDesync.originalCFrame = hrp.CFrame
    immortalDesync.originalVelocity = hrp.AssemblyLinearVelocity
    hrp.CFrame = calcOrbitPosition(hrp)
    hrp.AssemblyLinearVelocity = immortalConsts.velocity
    RunService.RenderStepped:Wait()
    hrp.CFrame = immortalDesync.originalCFrame
    hrp.AssemblyLinearVelocity = immortalDesync.originalVelocity
end

local function setImmortality(enabled)
    if immortalState.enabled == enabled then return end
    immortalState.enabled = enabled
    if enabled then
        if not immortalState.heartbeatConnection then
            immortalState.heartbeatConnection = RunService.Heartbeat:Connect(performImmortalDesync)
        end
    else
        if immortalState.heartbeatConnection then
            immortalState.heartbeatConnection:Disconnect()
            immortalState.heartbeatConnection = nil
        end
    end
end

immortalOldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not immortalState.enabled or checkcaller() or key ~= "CFrame" or not immortalCache.hrp or not isImmortalAlive() then
        return immortalOldIndex(self, key)
    end
    if self == immortalCache.hrp then
        return immortalDesync.originalCFrame or immortalConsts.emptyCFrame
    elseif self == immortalCache.head and immortalDesync.originalCFrame then
        return immortalDesync.originalCFrame + immortalCache.headOffset
    end
    return immortalOldIndex(self, key)
end))

ExclusiveTab:CreateSection("Immortality")
ExclusiveTab:CreateToggle({
    Name = "Immortality",
    CurrentValue = _G.config.immortality or false,
    Flag = "Immortality",
    Callback = function(enabled)
        _G.config.immortality = enabled
        setImmortality(enabled)
    end
})
ExclusiveTab:CreateSlider({
    Name = "Immortal Radius",
    Range = { 0, 100 },
    Increment = 1,
    CurrentValue = math.clamp(tonumber(_G.config.immortal_radius) or 25, 0, 100),
    Flag = "ImmortalRadius",
    Callback = function(value)
        immortalConsts.radius = value
        _G.config.immortal_radius = math.floor(value)
    end
})
ExclusiveTab:CreateSlider({
    Name = "Immortal Height",
    Range = { 0, 60 },
    Increment = 1,
    CurrentValue = math.clamp(tonumber(_G.config.immortal_height) or 30, 0, 60),
    Flag = "ImmortalHeight",
    Callback = function(value)
        immortalConsts.riseHeight = value
        _G.config.immortal_height = math.floor(value)
    end
})

-- Core Parry, Ball Tracker & Helpers --
local Connections = {}
local BallHelper = {}
BallHelper.ball = { properties = { aerodynamic_time = tick(), last_warping = tick(), lerp_radians = 0, curving = tick() } }
local CurrentTarget

local function findToken()
    for _, Function in getgc(true) do
        if type(Function) ~= 'function' then continue end
        local okSrc, src = pcall(function() return debug.info(Function, 's') end)
        if okSrc and src and tostring(src):find('PRY', 1, true) then
            local okUps, ups = pcall(function() return debug.getupvalues(Function) end)
            if okUps and type(ups) == 'table' then
                for _, value in ups do
                    if type(value) == 'function' then return value end
                end
            end
        end
    end
    return nil
end

local _token = findToken()
local _PARRY_PATCH = { ready = true }

function _tokenize(_remote_uid)
    local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, 'TIME')
    local characters = table.create(#time)
    for index = 1, #time do
        characters[index] = string.char(bit32.bxor(
            (string.byte(time, index) + index) % 256,
            string.byte(key, (index - 1) % #key + 1)
        ))
    end
    return table.concat(characters)
end

local _reverted = {}
local _original = {}

function _is_valid(args)
    return #args == 8 and type(args[2]) == "string" and type(args[3]) == "string"
        and type(args[4]) == "number" and typeof(args[5]) == "CFrame"
        and type(args[6]) == "table" and type(args[7]) == "table" and type(args[8]) == "boolean"
end

function _hook(remote)
    if not _reverted[remote] then
        if not _original[getrawmetatable(remote)] then
            _original[getrawmetatable(remote)] = true
            local _meta = getrawmetatable(remote)
            setreadonly(_meta, false)
            local _old = _meta.__index
            _meta.__index = function(self, key)
                if (key == 'FireServer' and self:IsA('RemoteEvent')) or (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
                    return function(_, ...)
                        local _arguments = {...}
                        if _is_valid(_arguments) then
                            if not _reverted[self] then _reverted[self] = _arguments end
                        end
                        return _old(self, key)(_, unpack(_arguments))
                    end
                end
                return _old(self, key)
            end
            setreadonly(_meta, true)
        end
    end
end

for _, _remote in pairs(ReplicatedStorage:GetDescendants()) do
    if _remote:IsA('RemoteEvent') or _remote:IsA('RemoteFunction') then _hook(_remote) end
end

function _PARRY_PATCH.fire(curveCFrame, screenPositions, mouseLocation)
    if not _token or not _reverted or next(_reverted) == nil then
        if mouse1click then pcall(mouse1click) end
        return true
    end
    if not curveCFrame then curveCFrame = workspace.CurrentCamera.CFrame end
    for _remote, _originalArgs in pairs(_reverted) do
        pcall(function()
            _remote:FireServer(_originalArgs[1], _originalArgs[2], _tokenize(_originalArgs[2]), 0.5, curveCFrame, screenPositions, mouseLocation, false)
        end)
    end
end

function BallHelper.get_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then return ball end
    end
end

function BallHelper.get_balls()
    local balls = {}
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then table.insert(balls, ball) end
    end
    return balls
end

function BallHelper.parry()
    local curveCFrame = workspace.CurrentCamera.CFrame
    local mp = UserInputService:GetMouseLocation()
    if _PARRY_PATCH and _PARRY_PATCH.ready then
        _PARRY_PATCH.fire(curveCFrame, {}, { mp.X, mp.Y })
    end
end

function BallHelper.ball_curved()
    local ball = BallHelper.get_ball()
    if not ball then return false end
    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return false end
    local velocity = zoomies.VectorVelocity
    return velocity.Magnitude > 100
end

MainTab:CreateSection("Automatic")
MainTab:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = _G.config.auto_parry or false,
    Flag = "AutoParry",
    Callback = function(enabled)
        _G.config.auto_parry = enabled
        if enabled then
            Connections.auto_parry = RunService.PreSimulation:Connect(function()
                local ball = BallHelper.get_ball()
                if not ball then return end
                local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
                if ball:GetAttribute("target") == LocalPlayer.Name and distance <= 25 then
                    BallHelper.parry()
                end
            end)
        else
            if Connections.auto_parry then Connections.auto_parry:Disconnect() Connections.auto_parry = nil end
        end
    end
})

MainTab:CreateSlider({
    Name = "Parry Accuracy",
    Range = { 1, 100 },
    Increment = 1,
    CurrentValue = 100,
    Flag = "Accuracy",
    Callback = function(value) _G.config.accuracy = value end
})

MainTab:CreateDropdown({
    Name = "Curve Method",
    Options = { "Camera", "Dot", "Backwards", "Slow", "Random" },
    CurrentOption = "Camera",
    Flag = "CurveMethod",
    Callback = function(value) _G.config.curve_method = value end
})

-- Visual Tab Features --
VisualTab:CreateSection("Visual")
VisualTab:CreateToggle({
    Name = "Player Cosmetics",
    CurrentValue = _G.config.player_cosmetics or false,
    Flag = "PlayerCosmetics",
    Callback = function(enabled) _G.config.player_cosmetics = enabled end
})

-- Settings Tab & Theme configuration --
SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    OnChanged = function(Key)
        _G.config.ui_keybind = Key.Name
        Window:SetKeybind(Key)
    end,
})

SettingsTab:CreateButton({
    Name = "Unload Hub",
    Callback = function() Window:Destroy() end,
})
