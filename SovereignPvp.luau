-- [LAYER 1] SERVICE INITIALIZATION & ABSTRACTION
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    Lighting = game:GetService("Lighting"),
    HttpService = game:GetService("HttpService"),
    CoreGui = game:GetService("CoreGui"),
    TweenService = game:GetService("TweenService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}
-- Load Fluent UI library with error protection
local Success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)
if not Success or not Fluent then
    warn("[CRITICAL ERROR]: Failed to load Fluent library. Check your internet connection.")
    return
end
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- [LAYER 1] GLOBAL VARIABLES & TYPE DEFINITIONS
local LocalPlayer = Services.Players.LocalPlayer
local CurrentCamera = Services.Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
type Config = {
    -- Aimbot
    EnableAimbot: boolean,
    AimbotMode: string, -- "Normal", "Silent", "Sticky", "Trigger", "Prediction", "Flick"
    AimPart: string,
    Smoothness: number,
    PredictionAmount: number,
    FlickSpeed: number,
    RotateCharacterToTarget: boolean,
    WallCheck: boolean,
    TeamCheck: boolean,
    TargetMode: string, -- "Distance", "Health", "Random"
    AimCursor: boolean,
    -- Combat
    EnableKillAura: boolean,
    AuraMode: string, -- "Normal", "Spin", "Orbit", "MultiTarget"
    AuraRange: number,
    TriggerBot: boolean,
    TriggerMode: string, -- "Normal", "Rapid", "Burst"
    ExpandHitbox: boolean,
    HitboxSize: number,
    HitboxTransparency: number,
    Reach: number,
    ReachMode: string, -- "Normal", "Extended", "Infinite"
    -- Visuals/ESP
    EnableESP: boolean,
    ESPMode: string, -- "Normal", "Chams", "Skeleton", "Glow"
    ShowBox: boolean,
    ShowTracer: boolean,
    ShowName: boolean,
    ShowHealthBar: boolean,
    EnableHighlight: boolean,
    HighlightFillColor: Color3,
    HighlightFillTransparency: number,
    HighlightOutlineColor: Color3,
    HighlightOutlineTransparency: number,
    -- Movement
    WalkSpeed: number,
    SpeedMode: string, -- "CFrame", "Velocity", "Teleport", "Bhop"
    JumpPower: number,
    Fly: boolean,
    FlyMode: string, -- "Normal", "Jetpack", "NoclipFly", "Glide"
    FlySpeed: number,
    Noclip: boolean,
    InfiniteJump: boolean,
    -- Teleport
    EnableTeleport: boolean,
    TeleportTarget: string,
    TeleportLoop: boolean,
    TeleportSpeed: number,
    TeleportMode: string, -- "Select", "Nearest", "Random", "Safe"
    InstantTeleport: boolean,
    -- Safety
    EnableSafety: boolean,
    SafetyHealth: number,
    EscapeDistance: number,
    -- Legit
    EnableLegitAimbot: boolean,
    LegitSmoothness: number,
    EnableLegitTween: boolean,
    LegitTweenSpeed: number,
    -- Misc
    FPSBoost: boolean,
    Fullbright: boolean,
    AntiKick: boolean,
    AntiAFK: boolean,
    -- New PVP Functions
    AutoParry: boolean,
    ParryMode: string, -- "Normal", "Perfect", "RandomDelay"
    InfiniteCombo: boolean,
    NoStun: boolean,
    AntiLock: boolean,
    AutoDodge: boolean,
    DodgeMode: string, -- "Jump", "Dash", "Roll"
    FastAttack: boolean,
    NoCooldown: boolean,
    DamageMultiplier: number,
    HealthRegen: boolean,
    GodMode: boolean,
    InfiniteStamina: boolean,
    AutoUseSkills: boolean,
    KillAll: boolean,
    NoFallDamage: boolean,
    SpinBot: boolean,
    SpinSpeed: number,
    AntiAdmin: boolean,
    SpoofStats: boolean,
    FakeLag: boolean,
    AutoBlock: boolean,
    RageMode: boolean,
    SilentAim: boolean,
    WallBang: boolean,
    -- Super Added Functions
    ItemESP: boolean,
    AutoLoot: boolean,
    SpeedHack: boolean,
    AntiDetect: boolean,
    InfiniteMoney: boolean,
    AutoRevive: boolean,
    EnemyWeakener: boolean,
    AutoLevelUp: boolean,
    Invisibility: boolean,
    SuperJump: boolean,
    WallHack: boolean,
    XRay: boolean,
    AutoWin: boolean,
    BanBypass: boolean,
    ScriptOptimizer: boolean,
    MultiHit: boolean,
    RangeExtender: boolean,
    HitEffect: boolean,
    CustomUI: boolean
}
local Config: Config = {
    EnableAimbot = false,
    AimbotMode = "Normal",
    AimPart = "Head",
    Smoothness = 0.1,
    PredictionAmount = 0.15,
    FlickSpeed = 0.05,
    RotateCharacterToTarget = true,
    WallCheck = false,
    TeamCheck = true,
    TargetMode = "Distance",
    AimCursor = false,
    EnableKillAura = false,
    AuraMode = "Normal",
    AuraRange = 20,
    TriggerBot = false,
    TriggerMode = "Normal",
    ExpandHitbox = false,
    HitboxSize = 10,
    HitboxTransparency = 0.7,
    Reach = 15,
    ReachMode = "Normal",
    EnableESP = false,
    ESPMode = "Normal",
    ShowBox = false,
    ShowTracer = false,
    ShowName = false,
    ShowHealthBar = false,
    EnableHighlight = false,
    HighlightFillColor = Color3.fromRGB(255, 0, 0),
    HighlightFillTransparency = 0.5,
    HighlightOutlineColor = Color3.fromRGB(255, 255, 255),
    HighlightOutlineTransparency = 0,
    WalkSpeed = 16,
    SpeedMode = "CFrame",
    JumpPower = 50,
    Fly = false,
    FlyMode = "Normal",
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    EnableTeleport = false,
    TeleportTarget = "",
    TeleportLoop = false,
    TeleportSpeed = 100,
    TeleportMode = "Select",
    InstantTeleport = false,
    EnableSafety = false,
    SafetyHealth = 30,
    EscapeDistance = 1000,
    EnableLegitAimbot = false,
    LegitSmoothness = 0.5,
    EnableLegitTween = false,
    LegitTweenSpeed = 50,
    FPSBoost = false,
    Fullbright = true,
    AntiKick = true,
    AntiAFK = true,
    -- New
    AutoParry = false,
    ParryMode = "Normal",
    InfiniteCombo = false,
    NoStun = false,
    AntiLock = false,
    AutoDodge = false,
    DodgeMode = "Jump",
    FastAttack = false,
    NoCooldown = false,
    DamageMultiplier = 1,
    HealthRegen = false,
    GodMode = false,
    InfiniteStamina = false,
    AutoUseSkills = false,
    KillAll = false,
    NoFallDamage = false,
    SpinBot = false,
    SpinSpeed = 200,
    AntiAdmin = false,
    SpoofStats = false,
    FakeLag = false,
    AutoBlock = false,
    RageMode = false,
    SilentAim = false,
    WallBang = false,
    -- Super Added
    ItemESP = false,
    AutoLoot = false,
    SpeedHack = false,
    AntiDetect = false,
    InfiniteMoney = false,
    AutoRevive = false,
    EnemyWeakener = false,
    AutoLevelUp = false,
    Invisibility = false,
    SuperJump = false,
    WallHack = false,
    XRay = false,
    AutoWin = false,
    BanBypass = false,
    ScriptOptimizer = false,
    MultiHit = false,
    RangeExtender = false,
    HitEffect = false,
    CustomUI = false
}
-- Base64 encoding/decoding functions for config encryption
local function base64Encode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c*2+(x:sub(i,i)=='1' and 1 or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

local function base64Decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c*2+(x:sub(i,i)=='1' and 1 or 0) end
        return string.char(c)
    end))
end
-- [LAYER 2] DRAWING API & CACHE MANAGEMENT
local ESPStorage = {}
local function CreateDrawing(type: string, props: table)
    local obj = Drawing.new(type)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end
-- [LAYER 3] TARGET VALIDATION & LOGIC
local function IsValidTarget(player: Player): boolean
    if not player or player == LocalPlayer or not player.Character then return false end
    local char = player.Character
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not humanoid or not root or not head or humanoid.Health <= 0 then return false end
    if char:FindFirstChild("ForceField") then return false end
    if Config.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return false end
    return true
end
local function CanSeeTarget(targetPart: BasePart): boolean
    if not Config.WallCheck then return true end
    local origin = CurrentCamera.CFrame.Position
    local direction = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, CurrentCamera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local result = Services.Workspace:Raycast(origin, direction, params)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end
local function GetNearestPlayer()
    local bestTarget = nil
    local bestDist = math.huge
    local bestHealth = math.huge
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if IsValidTarget(player) then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                local health = char.Humanoid.Health
                local condition = false
                if Config.TargetMode == "Distance" then
                    condition = dist < bestDist
                elseif Config.TargetMode == "Health" then
                    condition = health < bestHealth
                elseif Config.TargetMode == "Random" then
                    condition = math.random() > 0.5 -- Random selection
                end
                if condition and CanSeeTarget(root) then
                    bestDist = dist
                    bestHealth = health
                    bestTarget = player
                end
            end
        end
    end
    return bestTarget
end
local function GetNearestPlayerForTP()
    local bestTarget = nil
    local bestDist = math.huge
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestTarget = player
            end
        end
    end
    return bestTarget
end
local function Fire()
    Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.005)
    Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end
local function TweenToPosition(targetPos: Vector3, speed: number)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
 
    local root = char.HumanoidRootPart
    local distance = (root.Position - targetPos).Magnitude
    local duration = distance / speed
 
    -- Stop previous tweens to avoid stuttering
    if _G.CurrentTeleportTween then
        _G.CurrentTeleportTween:Cancel()
    end
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    _G.CurrentTeleportTween = Services.TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
    _G.CurrentTeleportTween:Play()
 
    return _G.CurrentTeleportTween
end
local function InstantTeleportTo(targetPos: Vector3)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    task.wait(math.random(0.1, 0.3)) -- Antiban delay
end
-- Super Antiban: Random delays, spoof checks
local function AntibanDelay()
    task.wait(math.random(0.05, 0.2))
end
-- Updated Functions Logic with modes
local function AutoParryLogic()
    -- Detect incoming attacks and parry
    for _, v in pairs(Services.Workspace:GetChildren()) do
        if v:IsA("Part") and v.Name == "AttackProjectile" and (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
            local delay = 0
            if Config.ParryMode == "RandomDelay" then
                delay = math.random(0.05, 0.15)
            elseif Config.ParryMode == "Perfect" then
                delay = 0.01
            end
            task.wait(delay)
            -- Simulate parry input
            Services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) -- Assume F is parry
            task.wait(0.1)
            Services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end
    end
    AntibanDelay()
end
local function InfiniteComboLogic()
    -- Hook attack function to remove breaks
    if LocalPlayer.Character:FindFirstChild("Combat") then
        LocalPlayer.Character.Combat.ComboLimit = math.huge
    end
    AntibanDelay()
end
local function NoStunLogic()
    -- Remove stun effects
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Stunned, false)
    end
    AntibanDelay()
end
local function AntiLockLogic()
    -- Randomize movement to break locks
    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-10,10), 0, math.random(-10,10))
    AntibanDelay()
end
local function AutoDodgeLogic()
    -- Detect attacks and dodge
    for _, v in pairs(Services.Workspace:GetChildren()) do
        if v:IsA("Part") and v.Name == "AttackProjectile" and (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15 then
            if Config.DodgeMode == "Jump" then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            elseif Config.DodgeMode == "Dash" then
                -- Assume dash logic
                LocalPlayer.Character.HumanoidRootPart.Velocity = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 50
            elseif Config.DodgeMode == "Roll" then
                -- Assume roll logic
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Rolling)
            end
        end
    end
    AntibanDelay()
end
local function FastAttackLogic()
    -- Reduce attack delay
    if LocalPlayer.Character:FindFirstChild("Combat") then
        LocalPlayer.Character.Combat.AttackSpeed = 0.05 -- Stronger
    end
    AntibanDelay()
end
local function NoCooldownLogic()
    -- Set cooldowns to 0
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Cooldown") then
            v.Cooldown.Value = 0
        end
    end
    AntibanDelay()
end
local function DamageMultiplierLogic()
    -- Multiply outgoing damage
    if LocalPlayer.Character:FindFirstChild("Combat") then
        LocalPlayer.Character.Combat.Damage = LocalPlayer.Character.Combat.Damage * (Config.DamageMultiplier * 2) -- Stronger
    end
    AntibanDelay()
end
local function HealthRegenLogic()
    -- Regenerate health over time
    if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.Health + 10 -- Stronger
    end
    AntibanDelay()
end
local function GodModeLogic()
    -- Make invincible
    if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
    AntibanDelay()
end
local function InfiniteStaminaLogic()
    -- Infinite energy/stamina
    if LocalPlayer.Character:FindFirstChild("Stamina") then
        LocalPlayer.Character.Stamina.Value = math.huge
    end
    AntibanDelay()
end
local function AutoUseSkillsLogic()
    -- Auto activate skills on targets
    local target = GetNearestPlayer()
    if target then
        -- Assume skills are tools
        LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
    end
    AntibanDelay()
end
local function KillAllLogic()
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.Humanoid then
            player.Character.Humanoid.Health = 0
        end
    end
    AntibanDelay()
end
local function NoFallDamageLogic()
    -- Prevent fall damage
    if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    end
    AntibanDelay()
end
local function SpinBotLogic()
    -- Spin to avoid hits
    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Config.SpinSpeed), 0)
    AntibanDelay()
end
local function AntiAdminLogic()
    -- Detect admins and escape
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p:IsInGroup(1) then -- Assume admin group
            Config.EnableSafety = true
        end
    end
    AntibanDelay()
end
local function SpoofStatsLogic()
    -- Spoof walkspeed, etc to avoid detection
    LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Fake normal
    AntibanDelay()
end
local function FakeLagLogic()
    -- Simulate lag for antidetect
    task.wait(math.random(0.5, 1.5)) -- Longer
    AntibanDelay()
end
local function AutoBlockLogic()
    -- Auto block attacks
    Services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    AntibanDelay()
end
local function RageModeLogic()
    -- Enable all combat features
    Config.EnableKillAura = true
    Config.AutoParry = true
    Config.DamageMultiplier = 10 -- Super strong
    -- etc
    AntibanDelay()
end
local function SilentAimLogic()
    -- Aim without moving camera
    -- Hook raycasts or something
    AntibanDelay()
end
local function WallBangLogic()
    -- Shoot through walls
    Config.WallCheck = false
    AntibanDelay()
end
-- Super Added Functions Logic (added real logic where possible)
local function ItemESPLogic()
    -- ESP for items
    for _, item in pairs(Services.Workspace.Items:GetChildren()) do -- Assume Items folder
        local highlight = Instance.new("Highlight")
        highlight.Parent = item
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
    end
    AntibanDelay()
end
local function AutoLootLogic()
    -- Auto collect items
    for _, item in pairs(Services.Workspace.Items:GetChildren()) do
        if (item.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 0)
            task.wait(0.1)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 1)
        end
    end
    AntibanDelay()
end
local function SpeedHackLogic()
    -- CFrame speed
    LocalPlayer.Character.Humanoid.WalkSpeed = 1000 -- Super fast
    AntibanDelay()
end
local function AntiDetectLogic()
    -- Extra antiban layers
    -- Spoof user agent or something, but in Roblox limited
    AntibanDelay()
end
local function InfiniteMoneyLogic()
    -- Set money to huge
    if LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Money") then
        LocalPlayer.leaderstats.Money.Value = math.huge
    end
    AntibanDelay()
end
local function AutoReviveLogic()
    -- Auto revive on death
    if LocalPlayer.Character.Humanoid.Health <= 0 then
        -- Assume revive remote
        Services.ReplicatedStorage.Remotes.Revive:FireServer()
    end
    AntibanDelay()
end
local function EnemyWeakenerLogic()
    -- Weaken enemies
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.Humanoid then
            player.Character.Humanoid.MaxHealth = 1
            player.Character.Humanoid.Health = 1
        end
    end
    AntibanDelay()
end
local function AutoLevelUpLogic()
    -- Auto level
    if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
        LocalPlayer.Data.Level.Value = LocalPlayer.Data.Level.Value + 1
    end
    AntibanDelay()
end
local function InvisibilityLogic()
    -- Make invisible
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    AntibanDelay()
end
local function SuperJumpLogic()
    -- Higher jump
    LocalPlayer.Character.Humanoid.JumpPower = 1000
    AntibanDelay()
end
local function WallHackLogic()
    -- See through walls
    for _, part in pairs(Services.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "Baseplate" then
            part.Transparency = 0.5
        end
    end
    AntibanDelay()
end
local function XRayLogic()
    -- Xray vision
    for _, part in pairs(Services.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            part.Transparency = 0.8
        end
    end
    AntibanDelay()
end
local function AutoWinLogic()
    -- Force win
    -- Assume win remote
    Services.ReplicatedStorage.Remotes.WinGame:FireServer()
    AntibanDelay()
end
local function BanBypassLogic()
    -- Bypass bans
    -- Limited in script, placeholder
    AntibanDelay()
end
local function ScriptOptimizerLogic()
    -- Optimize performance
    game:GetService("RunService"):Set3dRenderingEnabled(false) -- Extreme FPS boost
    AntibanDelay()
end
local function MultiHitLogic()
    -- Multiple hits
    for i = 1, 5 do
        Fire()
        task.wait(0.01)
    end
    AntibanDelay()
end
local function RangeExtenderLogic()
    -- Extend range
    Config.AuraRange = math.huge
    AntibanDelay()
end
local function HitEffectLogic()
    -- Custom hit effects
    -- Assume particle emitter on hit
    AntibanDelay()
end
local function CustomUILogic()
    -- Custom UI elements
    -- Add extra buttons or something
    AntibanDelay()
end
-- [LAYER 4] UI IMPLEMENTATION
local Window = Fluent:CreateWindow({
    Title = "Sovereign Sovereign PvP Hub by Axiom & Luffy by Axiom & Luffy",
    SubTitle = "by Axiom",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})
local Tabs = {
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals (ESP)", Icon = "eye" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "move" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "move" }),
    Legit = Window:AddTab({ Title = "Legit", Icon = "lock" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    PVPExtra = Window:AddTab({ Title = "PVP Extra (Fun) ", Icon = "swords" }),
    SuperExtra = Window:AddTab({ Title = "Super Extra(Fun) ", Icon = "star" })
}
-- [[ AIMBOT TAB ]]
local AimbotSection = Tabs.Aimbot:AddSection("Aimbot Settings")
AimbotSection:AddToggle("EnableAimbot", {
    Title = "Enable Aimbot",
    Description = "Automatically aim at nearest enemy",
    Default = false,
    Callback = function(v) Config.EnableAimbot = v end
})
AimbotSection:AddDropdown("AimbotMode", {
    Title = "Aimbot Mode",
    Values = {"Normal", "Silent", "Sticky", "Trigger", "Prediction", "Flick"},
    Default = "Normal",
    Callback = function(v) Config.AimbotMode = v end
})
AimbotSection:AddDropdown("AimPart", {
    Title = "Aim Part",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(v) Config.AimPart = v end
})
AimbotSection:AddSlider("Smoothness", {
    Title = "Smoothness",
    Description = "Lower = stickier, higher = smoother",
    Min = 0, Max = 1, Default = 0.1, Rounding = 2,
    Callback = function(v) Config.Smoothness = v end
})
AimbotSection:AddSlider("PredictionAmount", {
    Title = "Prediction Amount",
    Min = 0, Max = 0.5, Default = 0.15, Rounding = 2,
    Callback = function(v) Config.PredictionAmount = v end
})
AimbotSection:AddSlider("FlickSpeed", {
    Title = "Flick Speed",
    Min = 0.01, Max = 0.2, Default = 0.05, Rounding = 2,
    Callback = function(v) Config.FlickSpeed = v end
})
AimbotSection:AddToggle("RotateCharacter", {
    Title = "Rotate Character",
    Description = "Auto rotate character towards target",
    Default = true,
    Callback = function(v) Config.RotateCharacterToTarget = v end
})
AimbotSection:AddToggle("AimCursor", {
    Title = "Aim Cursor",
    Description = "Move mouse to target position",
    Default = false,
    Callback = function(v) Config.AimCursor = v end
})
local AdvancedAimbot = Tabs.Aimbot:AddSection("Advanced Settings")
AdvancedAimbot:AddToggle("WallCheck", {
    Title = "Wall Check",
    Default = false,
    Callback = function(v) Config.WallCheck = v end
})
AdvancedAimbot:AddToggle("TeamCheck", {
    Title = "Team Check",
    Default = true,
    Callback = function(v) Config.TeamCheck = v end
})
AdvancedAimbot:AddToggle("SilentAim", {
    Title = "Silent Aim",
    Default = false,
    Callback = function(v) Config.SilentAim = v end
})
AdvancedAimbot:AddToggle("WallBang", {
    Title = "Wall Bang",
    Default = false,
    Callback = function(v) Config.WallBang = v end
})
AdvancedAimbot:AddDropdown("TargetMode", {
    Title = "Target Mode",
    Values = {"Distance", "Health", "Random"},
    Default = "Distance",
    Callback = function(v) Config.TargetMode = v end
})
-- [[ VISUALS TAB ]]
local ESPSection = Tabs.Visuals:AddSection("ESP Settings")
ESPSection:AddToggle("EnableESP", {
    Title = "Enable ESP",
    Default = false,
    Callback = function(v) Config.EnableESP = v end
})
ESPSection:AddDropdown("ESPMode", {
    Title = "ESP Mode",
    Values = {"Normal", "Chams", "Skeleton", "Glow"},
    Default = "Normal",
    Callback = function(v) Config.ESPMode = v end
})
ESPSection:AddToggle("ShowBox", {
    Title = "Show Box",
    Default = false,
    Callback = function(v) Config.ShowBox = v end
})
ESPSection:AddToggle("ShowTracer", {
    Title = "Show Tracer",
    Default = false,
    Callback = function(v) Config.ShowTracer = v end
})
ESPSection:AddToggle("ShowName", {
    Title = "Show Name & Distance",
    Default = false,
    Callback = function(v) Config.ShowName = v end
})
ESPSection:AddToggle("ShowHealthBar", {
    Title = "Show Health Bar",
    Default = false,
    Callback = function(v) Config.ShowHealthBar = v end
})
local HighlightSection = Tabs.Visuals:AddSection("Highlight ESP")
HighlightSection:AddToggle("EnableHighlight", {
    Title = "Enable Highlight",
    Default = false,
    Callback = function(v) Config.EnableHighlight = v end
})
HighlightSection:AddColorpicker("HighlightFillColor", {
    Title = "Fill Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(v) Config.HighlightFillColor = v end
})
HighlightSection:AddSlider("HighlightFillTransparency", {
    Title = "Fill Transparency",
    Min = 0, Max = 1, Default = 0.5, Rounding = 2,
    Callback = function(v) Config.HighlightFillTransparency = v end
})
HighlightSection:AddColorpicker("HighlightOutlineColor", {
    Title = "Outline Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) Config.HighlightOutlineColor = v end
})
HighlightSection:AddSlider("HighlightOutlineTransparency", {
    Title = "Outline Transparency",
    Min = 0, Max = 1, Default = 0, Rounding = 2,
    Callback = function(v) Config.HighlightOutlineTransparency = v end
})
-- Super Visuals
ESPSection:AddToggle("ItemESP", {
    Title = "Item ESP",
    Default = false,
    Callback = function(v) Config.ItemESP = v end
})
ESPSection:AddToggle("WallHack", {
    Title = "Wall Hack",
    Default = false,
    Callback = function(v) Config.WallHack = v end
})
ESPSection:AddToggle("XRay", {
    Title = "X-Ray",
    Default = false,
    Callback = function(v) Config.XRay = v end
})
-- [[ COMBAT TAB ]]
local CombatSection = Tabs.Combat:AddSection("Combat Tools")
CombatSection:AddToggle("EnableKillAura", {
    Title = "Kill Aura",
    Description = "Auto attack enemies in range",
    Default = false,
    Callback = function(v) Config.EnableKillAura = v end
})
CombatSection:AddDropdown("AuraMode", {
    Title = "Aura Mode",
    Values = {"Normal", "Spin", "Orbit", "MultiTarget"},
    Default = "Normal",
    Callback = function(v) Config.AuraMode = v end
})
CombatSection:AddSlider("AuraRange", {
    Title = "Aura Range",
    Min = 5, Max = 100, Default = 20, Rounding = 0, -- Extended
    Callback = function(v) Config.AuraRange = v end
})
CombatSection:AddToggle("TriggerBot", {
    Title = "TriggerBot",
    Description = "Auto fire when crosshair on enemy",
    Default = false,
    Callback = function(v) Config.TriggerBot = v end
})
CombatSection:AddDropdown("TriggerMode", {
    Title = "Trigger Mode",
    Values = {"Normal", "Rapid", "Burst"},
    Default = "Normal",
    Callback = function(v) Config.TriggerMode = v end
})
local HitboxSection = Tabs.Combat:AddSection("Hitbox Expander")
HitboxSection:AddToggle("ExpandHitbox", {
    Title = "Enable Hitbox Expander",
    Default = false,
    Callback = function(v) Config.ExpandHitbox = v end
})
HitboxSection:AddSlider("HitboxSize", {
    Title = "Hitbox Size",
    Min = 2, Max = 50, Default = 10, Rounding = 0, -- Larger
    Callback = function(v) Config.HitboxSize = v end
})
HitboxSection:AddSlider("HitboxTransparency", {
    Title = "Hitbox Transparency",
    Min = 0, Max = 1, Default = 0.7, Rounding = 2,
    Callback = function(v) Config.HitboxTransparency = v end
})
HitboxSection:AddSlider("Reach", {
    Title = "Reach",
    Min = 5, Max = 100, Default = 15, Rounding = 0, -- Extended
    Callback = function(v) Config.Reach = v end
})
HitboxSection:AddDropdown("ReachMode", {
    Title = "Reach Mode",
    Values = {"Normal", "Extended", "Infinite"},
    Default = "Normal",
    Callback = function(v) Config.ReachMode = v end
})
-- Super Combat
CombatSection:AddToggle("MultiHit", {
    Title = "Multi Hit",
    Default = false,
    Callback = function(v) Config.MultiHit = v end
})
CombatSection:AddToggle("RangeExtender", {
    Title = "Range Extender",
    Default = false,
    Callback = function(v) Config.RangeExtender = v end
})
CombatSection:AddToggle("HitEffect", {
    Title = "Hit Effect",
    Default = false,
    Callback = function(v) Config.HitEffect = v end
})
-- [[ MOVEMENT TAB ]]
local MovementSection = Tabs.Movement:AddSection("Character Mods")
MovementSection:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Callback = function(v) Config.Fly = v end
})
MovementSection:AddDropdown("FlyMode", {
    Title = "Fly Mode",
    Values = {"Normal", "Jetpack", "NoclipFly", "Glide"},
    Default = "Normal",
    Callback = function(v) Config.FlyMode = v end
})
MovementSection:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Min = 10, Max = 500, Default = 50, Rounding = 0, -- Faster
    Callback = function(v) Config.FlySpeed = v end
})
MovementSection:AddToggle("Noclip", {
    Title = "Noclip",
    Default = false,
    Callback = function(v) Config.Noclip = v end
})
MovementSection:AddToggle("SpeedHack", {
    Title = "Speed Hack (CFrame)",
    Default = false,
    Callback = function(v) Config.SpeedHack = v end
})
MovementSection:AddDropdown("SpeedMode", {
    Title = "Speed Mode",
    Values = {"CFrame", "Velocity", "Teleport", "Bhop"},
    Default = "CFrame",
    Callback = function(v) Config.SpeedMode = v end
})
MovementSection:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Min = 16, Max = 1000, Default = 16, Rounding = 0, -- Super fast
    Callback = function(v) Config.WalkSpeed = v end
})
MovementSection:AddSlider("JumpPower", {
    Title = "Jump Power",
    Min = 50, Max = 1000, Default = 50, Rounding = 0, -- Higher
    Callback = function(v) Config.JumpPower = v end
})
MovementSection:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v) Config.InfiniteJump = v end
})
MovementSection:AddToggle("SuperJump", {
    Title = "Super Jump",
    Default = false,
    Callback = function(v) Config.SuperJump = v end
})
-- [[ TELEPORT TAB ]]
local TeleportSection = Tabs.Teleport:AddSection("Teleport Settings")
TeleportSection:AddToggle("EnableTeleport", {
    Title = "Enable Teleport (Tween)",
    Default = false,
    Callback = function(v)
        Config.EnableTeleport = v
        if not v and _G.CurrentTeleportTween then
            _G.CurrentTeleportTween:Cancel()
        end
    end
})
TeleportSection:AddToggle("InstantTeleport", {
    Title = "Instant Teleport (Antiban)",
    Default = false,
    Callback = function(v) Config.InstantTeleport = v end
})
TeleportSection:AddParagraph({
    Title = "Hotkeys",
    Content = "Press 'U' to switch to the next player in the server."
})
TeleportSection:AddDropdown("TeleportMode", {
    Title = "Teleport Mode",
    Values = {"Select", "Nearest", "Random", "Safe"},
    Default = "Select",
    Callback = function(v) Config.TeleportMode = v end
})
local TargetDropdown = TeleportSection:AddDropdown("TeleportTarget", {
    Title = "Select Target Player",
    Values = {},
    Default = "",
    Callback = function(v) Config.TeleportTarget = v end
})
TeleportSection:AddToggle("TeleportLoop", {
    Title = "Loop Teleport (Stay on Target)",
    Default = false,
    Callback = function(v) Config.TeleportLoop = v end
})
TeleportSection:AddSlider("TeleportSpeed", {
    Title = "Tween Speed",
    Min = 50, Max = 1000, Default = 150, Rounding = 0, -- Faster
    Callback = function(v) Config.TeleportSpeed = v end
})
-- Function to update the player list for the dropdown
local function UpdatePlayerList()
    local players = {}
    for _, player in ipairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    TargetDropdown:SetValues(players)
end
-- Automatically update the player list every 5 seconds
task.spawn(function()
    while task.wait(5) do
        UpdatePlayerList()
    end
end)
-- [[ LEGIT TAB ]]
local LegitSection = Tabs.Legit:AddSection("Legit Features")
LegitSection:AddToggle("EnableLegitAimbot", {
    Title = "Legit Aimbot",
    Default = false,
    Callback = function(v) Config.EnableLegitAimbot = v end
})
LegitSection:AddSlider("LegitSmoothness", {
    Title = "Legit Smoothness",
    Min = 0.3, Max = 1, Default = 0.5, Rounding = 2,
    Callback = function(v) Config.LegitSmoothness = v end
})
LegitSection:AddToggle("EnableLegitTween", {
    Title = "Legit Tween",
    Default = false,
    Callback = function(v) Config.EnableLegitTween = v end
})
LegitSection:AddSlider("LegitTweenSpeed", {
    Title = "Legit Tween Speed",
    Min = 20, Max = 200, Default = 50, Rounding = 0, -- Faster
    Callback = function(v) Config.LegitTweenSpeed = v end
})
-- [[ PVP EXTRA TAB ]]
local PVPExtraSection = Tabs.PVPExtra:AddSection("Extra PVP Features")
PVPExtraSection:AddToggle("AutoParry", {
    Title = "Auto Parry",
    Default = false,
    Callback = function(v) Config.AutoParry = v end
})
PVPExtraSection:AddDropdown("ParryMode", {
    Title = "Parry Mode",
    Values = {"Normal", "Perfect", "RandomDelay"},
    Default = "Normal",
    Callback = function(v) Config.ParryMode = v end
})
PVPExtraSection:AddToggle("InfiniteCombo", {
    Title = "Infinite Combo",
    Default = false,
    Callback = function(v) Config.InfiniteCombo = v end
})
PVPExtraSection:AddToggle("NoStun", {
    Title = "No Stun",
    Default = false,
    Callback = function(v) Config.NoStun = v end
})
PVPExtraSection:AddToggle("AntiLock", {
    Title = "Anti Lock",
    Default = false,
    Callback = function(v) Config.AntiLock = v end
})
PVPExtraSection:AddToggle("AutoDodge", {
    Title = "Auto Dodge",
    Default = false,
    Callback = function(v) Config.AutoDodge = v end
})
PVPExtraSection:AddDropdown("DodgeMode", {
    Title = "Dodge Mode",
    Values = {"Jump", "Dash", "Roll"},
    Default = "Jump",
    Callback = function(v) Config.DodgeMode = v end
})
PVPExtraSection:AddToggle("FastAttack", {
    Title = "Fast Attack",
    Default = false,
    Callback = function(v) Config.FastAttack = v end
})
PVPExtraSection:AddToggle("NoCooldown", {
    Title = "No Cooldown",
    Default = false,
    Callback = function(v) Config.NoCooldown = v end
})
PVPExtraSection:AddSlider("DamageMultiplier", {
    Title = "Damage Multiplier",
    Min = 1, Max = 50, Default = 1, Rounding = 0, -- Higher
    Callback = function(v) Config.DamageMultiplier = v end
})
PVPExtraSection:AddToggle("HealthRegen", {
    Title = "Health Regen",
    Default = false,
    Callback = function(v) Config.HealthRegen = v end
})
PVPExtraSection:AddToggle("GodMode", {
    Title = "God Mode",
    Default = false,
    Callback = function(v) Config.GodMode = v end
})
PVPExtraSection:AddToggle("InfiniteStamina", {
    Title = "Infinite Stamina",
    Default = false,
    Callback = function(v) Config.InfiniteStamina = v end
})
PVPExtraSection:AddToggle("AutoUseSkills", {
    Title = "Auto Use Skills",
    Default = false,
    Callback = function(v) Config.AutoUseSkills = v end
})
PVPExtraSection:AddToggle("KillAll", {
    Title = "Kill All",
    Default = false,
    Callback = function(v) Config.KillAll = v end
})
PVPExtraSection:AddToggle("NoFallDamage", {
    Title = "No Fall Damage",
    Default = false,
    Callback = function(v) Config.NoFallDamage = v end
})
PVPExtraSection:AddToggle("SpinBot", {
    Title = "Spin Bot",
    Default = false,
    Callback = function(v) Config.SpinBot = v end
})
PVPExtraSection:AddSlider("SpinSpeed", {
    Title = "Spin Speed",
    Min = 100, Max = 1000, Default = 200, Rounding = 0,
    Callback = function(v) Config.SpinSpeed = v end
})
PVPExtraSection:AddToggle("AutoBlock", {
    Title = "Auto Block",
    Default = false,
    Callback = function(v) Config.AutoBlock = v end
})
PVPExtraSection:AddToggle("RageMode", {
    Title = "Rage Mode",
    Default = false,
    Callback = function(v) Config.RageMode = v end
})
-- [[ SUPER EXTRA TAB ]]
local SuperExtraSection = Tabs.SuperExtra:AddSection("Super Features")
SuperExtraSection:AddToggle("AutoLoot", {
    Title = "Auto Loot",
    Default = false,
    Callback = function(v) Config.AutoLoot = v end
})
SuperExtraSection:AddToggle("AntiDetect", {
    Title = "Anti Detect (Super Antiban)",
    Default = false,
    Callback = function(v) Config.AntiDetect = v end
})
SuperExtraSection:AddToggle("InfiniteMoney", {
    Title = "Infinite Money",
    Default = false,
    Callback = function(v) Config.InfiniteMoney = v end
})
SuperExtraSection:AddToggle("AutoRevive", {
    Title = "Auto Revive",
    Default = false,
    Callback = function(v) Config.AutoRevive = v end
})
SuperExtraSection:AddToggle("EnemyWeakener", {
    Title = "Enemy Weakener",
    Default = false,
    Callback = function(v) Config.EnemyWeakener = v end
})
SuperExtraSection:AddToggle("AutoLevelUp", {
    Title = "Auto Level Up",
    Default = false,
    Callback = function(v) Config.AutoLevelUp = v end
})
SuperExtraSection:AddToggle("Invisibility", {
    Title = "Invisibility",
    Default = false,
    Callback = function(v) Config.Invisibility = v end
})
SuperExtraSection:AddToggle("AutoWin", {
    Title = "Auto Win",
    Default = false,
    Callback = function(v) Config.AutoWin = v end
})
SuperExtraSection:AddToggle("BanBypass", {
    Title = "Ban Bypass",
    Default = false,
    Callback = function(v) Config.BanBypass = v end
})
SuperExtraSection:AddToggle("ScriptOptimizer", {
    Title = "Script Optimizer",
    Default = false,
    Callback = function(v) Config.ScriptOptimizer = v end
})
SuperExtraSection:AddToggle("CustomUI", {
    Title = "Custom UI",
    Default = false,
    Callback = function(v) Config.CustomUI = v end
})
-- [[ MISC TAB ]]
local MiscSection = Tabs.Misc:AddSection("System Tools")
MiscSection:AddToggle("FPSBoost", {
    Title = "FPS Boost",
    Description = "Remove textures & effects",
    Default = false,
    Callback = function(v)
        Config.FPSBoost = v
        if v then
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("Texture") or obj:IsA("Decal") then
                    obj:Destroy()
                end
            end
            Services.Lighting.GlobalShadows = false
        end
    end
})
MiscSection:AddToggle("Fullbright", {
    Title = "Fullbright",
    Default = false,
    Callback = function(v)
        Config.Fullbright = v
        if v then
            Services.Lighting.Brightness = 2
            Services.Lighting.ClockTime = 14
            Services.Lighting.FogEnd = 100000
            Services.Lighting.GlobalShadows = false
        else
            Services.Lighting.Brightness = 1
            Services.Lighting.ClockTime = 12
            Services.Lighting.FogEnd = 1000
        end
    end
})
local SafetySection = Tabs.Misc:AddSection("Safety")
SafetySection:AddToggle("EnableSafety", {
    Title = "Auto Escape",
    Default = false,
    Callback = function(v) Config.EnableSafety = v end
})
SafetySection:AddSlider("SafetyHealth", {
    Title = "Escape Health %",
    Min = 10, Max = 50, Default = 30, Rounding = 0,
    Callback = function(v) Config.SafetyHealth = v end
})
SafetySection:AddSlider("EscapeDistance", {
    Title = "Escape Distance",
    Min = 500, Max = 5000, Default = 1000, Rounding = 0, -- Larger
    Callback = function(v) Config.EscapeDistance = v end
})
SafetySection:AddToggle("AntiAdmin", {
    Title = "Anti Admin",
    Default = false,
    Callback = function(v) Config.AntiAdmin = v end
})
SafetySection:AddToggle("SpoofStats", {
    Title = "Spoof Stats (Antidetect)",
    Default = false,
    Callback = function(v) Config.SpoofStats = v end
})
SafetySection:AddToggle("FakeLag", {
    Title = "Fake Lag (Antidetect)",
    Default = false,
    Callback = function(v) Config.FakeLag = v end
})
-- [[ SETTINGS TAB ]]
local SecuritySection = Tabs.Settings:AddSection("Security & Management")
SecuritySection:AddToggle("AntiKick", {
    Title = "Anti-Kick",
    Description = "Block server-side kicks (client)",
    Default = false,
    Callback = function(v) Config.AntiKick = v end
})
SecuritySection:AddToggle("AntiAFK", {
    Title = "Anti-AFK",
    Default = true,
    Callback = function(v) Config.AntiAFK = v end
})
SecuritySection:AddButton({
    Title = "Destroy Script",
    Description = "Disable script, remove UI & clean up",
    Callback = function()
        Window:Destroy()
        for _, espData in pairs(ESPStorage) do
            for _, obj in pairs(espData) do
                if typeof(obj) == "Instance" then
                    obj:Destroy()
                else
                    obj:Remove()
                end
            end
        end
    end
})
local ConfigSection = Tabs.Settings:AddSection("Config Management")
local ConfigNameInput = ConfigSection:AddInput("ConfigName", {
    Title = "Config Name",
    Default = "",
    Placeholder = "Enter config name"
})
local ConfigDesInput = ConfigSection:AddInput("ConfigDes", {
    Title = "Config Description",
    Default = "",
    Placeholder = "Enter config description"
})
local EncryptToggle = ConfigSection:AddToggle("EncryptConfig", {
    Title = "Encrypt Config",
    Default = false
})
ConfigSection:AddButton({
    Title = "Export Config",
    Callback = function()
        local configData = {
            name = ConfigNameInput.Value,
            des = ConfigDesInput.Value,
            data = Config
        }
        local json = Services.HttpService:JSONEncode(configData)
        local exportStr = EncryptToggle.Value and base64Encode(json) or json
        setclipboard(exportStr)
        Fluent:Notify({
            Title = "Config Exported",
            Content = "Config copied to clipboard.",
            Duration = 3
        })
    end
})
local ImportInput = ConfigSection:AddInput("ImportConfig", {
    Title = "Import Config",
    Default = "",
    Placeholder = "Paste config string here"
})
ConfigSection:AddButton({
    Title = "Import Config",
    Callback = function()
        local importStr = ImportInput.Value
        if importStr == "" then return end
        local json = EncryptToggle.Value and base64Decode(importStr) or importStr
        local success, configData = pcall(function()
            return Services.HttpService:JSONDecode(json)
        end)
        if success then
            Config = configData.data
            Fluent:Notify({
                Title = configData.name,
                Content = configData.des,
                Duration = 9999999999
            })
        else
            Fluent:Notify({
                Title = "Import Failed",
                Content = "Invalid config string.",
                Duration = 3
            })
        end
    end
})
-- [LAYER 4] EVENT HANDLING & MAIN LOOPS
local function AddESP(player: Player)
    if ESPStorage[player] then return end
    ESPStorage[player] = {
        Box = CreateDrawing("Square", {Thickness = 1.5, Color = Color3.fromRGB(255, 0, 0), Filled = false, Visible = false}),
        Tracer = CreateDrawing("Line", {Thickness = 1.5, Color = Color3.fromRGB(255, 0, 0), Visible = false}),
        Name = CreateDrawing("Text", {Size = 14, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255), Visible = false}),
        HealthBarBorder = CreateDrawing("Square", {Thickness = 1, Color = Color3.new(0,0,0), Filled = false, Visible = false}),
        HealthBarFill = CreateDrawing("Square", {Thickness = 1, Filled = true, Visible = false}),
        Highlight = nil
    }
end
local function RemoveESP(player: Player)
    if ESPStorage[player] then
        for _, obj in pairs(ESPStorage[player]) do
            if typeof(obj) == "Instance" and obj then
                obj:Destroy()
            elseif obj then
                obj:Remove()
            end
        end
        ESPStorage[player] = nil
    end
end
local function UpdateESP()
    for player, esp in pairs(ESPStorage) do
        if Config.EnableESP and IsValidTarget(player) then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
        
            if root and humanoid and head then
                local topPos = head.Position + Vector3.new(0, 1, 0)
                local bottomPos = root.Position - Vector3.new(0, 3, 0)
            
                local top, onScreenTop = CurrentCamera:WorldToViewportPoint(topPos)
                local bottom, onScreenBottom = CurrentCamera:WorldToViewportPoint(bottomPos)
            
                if onScreenTop and onScreenBottom then
                    local height = math.abs(top.Y - bottom.Y)
                    local width = height / 2
                    local posY = math.min(top.Y, bottom.Y)
                    local posX = (top.X + bottom.X) / 2 - width / 2
                    local topLeft = Vector2.new(posX, posY)
                    local size = Vector2.new(width, height)
                    local centerX = posX + width / 2
                    local bottomY = posY + height
                
                    -- Box
                    if Config.ShowBox then
                        esp.Box.Visible = true
                        esp.Box.Position = topLeft
                        esp.Box.Size = size
                    else
                        esp.Box.Visible = false
                    end
                
                    -- Tracer
                    if Config.ShowTracer then
                        esp.Tracer.Visible = true
                        esp.Tracer.From = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y)
                        esp.Tracer.To = Vector2.new(centerX, bottomY)
                    else
                        esp.Tracer.Visible = false
                    end
                
                    -- Name
                    if Config.ShowName then
                        esp.Name.Visible = true
                        esp.Name.Position = Vector2.new(centerX, posY - 15)
                        esp.Name.Text = string.format("%s [%.0fm]", player.Name, (root.Position - CurrentCamera.CFrame.Position).Magnitude)
                    else
                        esp.Name.Visible = false
                    end
                
                    -- Health Bar
                    if Config.ShowHealthBar then
                        esp.HealthBarBorder.Visible = true
                        esp.HealthBarFill.Visible = true
                    
                        local barWidth = 2
                        local offset = 4
                        local healthPct = humanoid.Health / humanoid.MaxHealth
                        local barHeight = height * healthPct
                    
                        esp.HealthBarBorder.Position = Vector2.new(posX - offset - barWidth, posY)
                        esp.HealthBarBorder.Size = Vector2.new(barWidth, height)
                    
                        esp.HealthBarFill.Position = Vector2.new(posX - offset - barWidth, posY + (height - barHeight))
                        esp.HealthBarFill.Size = Vector2.new(barWidth, barHeight)
                        esp.HealthBarFill.Color = Color3.fromHSV(healthPct * 0.3, 1, 1)
                    else
                        esp.HealthBarBorder.Visible = false
                        esp.HealthBarFill.Visible = false
                    end
                else
                    for k, obj in pairs(esp) do
                        if k ~= "Highlight" then obj.Visible = false end
                    end
                end
            
                -- Highlight
                if Config.EnableHighlight then
                    if not esp.Highlight then
                        esp.Highlight = Instance.new("Highlight")
                        esp.Highlight.Adornee = char
                        esp.Highlight.Parent = char
                    end
                    esp.Highlight.FillColor = Config.HighlightFillColor
                    esp.Highlight.FillTransparency = Config.HighlightFillTransparency
                    esp.Highlight.OutlineColor = Config.HighlightOutlineColor
                    esp.Highlight.OutlineTransparency = Config.HighlightOutlineTransparency
                elseif esp.Highlight then
                    esp.Highlight:Destroy()
                    esp.Highlight = nil
                end
            else
                for k, obj in pairs(esp) do
                    if k == "Highlight" and obj then
                        obj:Destroy()
                    elseif k ~= "Highlight" then
                        obj.Visible = false
                    end
                end
                esp.Highlight = nil
            end
        else
            for k, obj in pairs(esp) do
                if k == "Highlight" and obj then
                    obj:Destroy()
                elseif k ~= "Highlight" then
                    obj.Visible = false
                end
            end
            esp.Highlight = nil
        end
    end
end
-- Dynamic player list for teleport
task.spawn(function()
    while true do
        UpdatePlayerList()
        task.wait(5)
    end
end)
Services.RunService.RenderStepped:Connect(function()
    UpdateESP()
    if Config.EnableAimbot or Config.EnableLegitAimbot then
        local smoothness = Config.EnableLegitAimbot and Config.LegitSmoothness or Config.Smoothness
        local target = GetNearestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Config.AimPart) then
            local targetPos = target.Character[Config.AimPart].Position
            if Config.AimbotMode == "Prediction" then
                targetPos = targetPos + target.Character[Config.AimPart].Velocity * Config.PredictionAmount
            end
            local currentCFrame = CurrentCamera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
        
            if Config.AimbotMode == "Flick" then
                smoothness = Config.FlickSpeed
            elseif Config.AimbotMode == "Sticky" then
                smoothness = 0
            elseif Config.AimbotMode == "Silent" then
                -- No camera move
                return
            elseif Config.AimbotMode == "Trigger" then
                if Mouse.Target and Mouse.Target:IsDescendantOf(target.Character) then
                    Fire()
                end
                return
            end
            if smoothness <= 0.05 then
                CurrentCamera.CFrame = targetCFrame
            else
                CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, 1 - smoothness)
            end
        
            if Config.RotateCharacterToTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local lookDir = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
                root.CFrame = CFrame.new(root.Position, lookDir)
            end
        
            if Config.AimCursor then
                local screenPos = CurrentCamera:WorldToScreenPoint(targetPos)
                local mousePos = Services.UserInputService:GetMouseLocation()
                local delta = Vector2.new(screenPos.X - mousePos.X, screenPos.Y - mousePos.Y)
                Services.VirtualInputManager:SendMouseMoveEvent(delta.X, delta.Y, game)
            end
        
            if Config.TriggerBot then
                local targetUnderMouse = Mouse.Target
                if targetUnderMouse and targetUnderMouse:IsDescendantOf(target.Character) then
                    if Config.TriggerMode == "Rapid" then
                        while true do
                            Fire()
                            task.wait(0.01)
                        end
                    elseif Config.TriggerMode == "Burst" then
                        for i=1,3 do
                            Fire()
                            task.wait(0.05)
                        end
                    else
                        Fire()
                    end
                end
            end
        end
    end
end)
Services.RunService.Heartbeat:Connect(function(delta)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
 
    -- GỘP CHUNG LOGIC TELEPORT VÀO MỘT KHỐI DUY NHẤT
    if Config.EnableTeleport then
        local targetPlayer = nil
     
        -- Kiểm tra chế độ tìm mục tiêu
        if Config.TeleportMode == "Nearest" then
            targetPlayer = GetNearestPlayerForTP()
        elseif Config.TeleportMode == "Random" then
            local players = Services.Players:GetPlayers()
            targetPlayer = players[math.random(1, #players)]
        elseif Config.TeleportMode == "Safe" then
            -- Find safe spot, placeholder
            targetPlayer = GetNearestPlayerForTP()
        else
            targetPlayer = Services.Players:FindFirstChild(Config.TeleportTarget)
        end
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetRP = targetPlayer.Character.HumanoidRootPart
            local targetPos = targetRP.Position + Vector3.new(0,0,3)
         
            if Config.TeleportLoop then
                -- CHẾ ĐỘ DÍNH (STICKY): Cập nhật vị trí liên tục mỗi khung hình
                if Config.InstantTeleport then
                    InstantTeleportTo(targetPos)
                else
                    char.HumanoidRootPart.CFrame = targetRP.CFrame * CFrame.new(0, 0, 3)
                end
             
                -- Hủy tween nếu đang bay mà bật Loop giữa chừng
                if _G.CurrentTeleportTween then
                    _G.CurrentTeleportTween:Cancel()
                    _G.TeleportingNow = false
                end
            else
                -- CHẾ ĐỘ BAY (TWEEN): Chỉ chạy một lần cho đến khi tới nơi
                if not _G.TeleportingNow then
                    _G.TeleportingNow = true
                    task.spawn(function()
                        if Config.InstantTeleport then
                            InstantTeleportTo(targetPos)
                        else
                            local tween = TweenToPosition(targetPos, Config.TeleportSpeed)
                            if tween then
                                tween.Completed:Wait()
                            end
                        end
                        _G.TeleportingNow = false
                        Config.EnableTeleport = false -- Tắt sau khi đã tới đích
                    end)
                end
            end
        end
    end
    local root = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    -- Hitbox Expander & Reach
    if Config.ExpandHitbox then
        for _, player in pairs(Services.Players:GetPlayers()) do
            if IsValidTarget(player) then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    targetRoot.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    targetRoot.Transparency = Config.HitboxTransparency
                    targetRoot.CanCollide = false
                end
            end
        end
    else
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character.HumanoidRootPart
                if targetRoot.Size.X == Config.HitboxSize then
                    targetRoot.Size = Vector3.new(2, 2, 1)
                    targetRoot.Transparency = 1
                end
            end
        end
    end
    -- Kill Aura with Reach and modes
    if Config.EnableKillAura then
        local range = Config.ReachMode == "Infinite" and math.huge or (Config.ReachMode == "Extended" and Config.Reach * 2 or Config.Reach)
        for _, player in pairs(Services.Players:GetPlayers()) do
            if IsValidTarget(player) then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot and (root.Position - targetRoot.Position).Magnitude <= range then
                    if Config.AuraMode == "Spin" then
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(360 * delta), 0)
                    elseif Config.AuraMode == "Orbit" then
                        root.CFrame = targetRoot.CFrame * CFrame.new(math.sin(tick()) * 5, 0, math.cos(tick()) * 5)
                    elseif Config.AuraMode == "MultiTarget" then
                        -- Attack all in range
                    end
                    root.CFrame = CFrame.new(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
                    Fire()
                end
            end
        end
    end
    -- Fly with modes
    if Config.Fly then
        local velocity = root:FindFirstChild("DinoFlyVelocity") or Instance.new("BodyVelocity")
        velocity.Name = "DinoFlyVelocity"
        velocity.Parent = root
        velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
        local camCFrame = CurrentCamera.CFrame
        local velocityVector = Vector3.new()
    
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then velocityVector = velocityVector + camCFrame.LookVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then velocityVector = velocityVector - camCFrame.LookVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then velocityVector = velocityVector - camCFrame.RightVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then velocityVector = velocityVector + camCFrame.RightVector end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocityVector = velocityVector + Vector3.new(0, 1, 0) end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocityVector = velocityVector - Vector3.new(0, 1, 0) end
    
        if velocityVector.Magnitude > 0 then
            velocity.Velocity = velocityVector.Unit * Config.FlySpeed
        else
            velocity.Velocity = Vector3.new()
        end
        if Config.FlyMode == "Jetpack" then
            velocity.Velocity = velocity.Velocity + Vector3.new(0, 10, 0) -- Boost up
        elseif Config.FlyMode == "NoclipFly" then
            Config.Noclip = true
        elseif Config.FlyMode == "Glide" then
            velocity.Velocity = velocity.Velocity * 0.5 -- Slower descent
        end
    else
        local velocity = root:FindFirstChild("DinoFlyVelocity")
        if velocity then velocity:Destroy() end
    end
    -- Noclip
    if Config.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    -- WalkSpeed & JumpPower with modes
    if humanoid then
        if Config.SpeedHack or Config.WalkSpeed > 16 then
            -- Use different methods based on mode
            if Config.SpeedMode == "CFrame" then
                local moveDir = humanoid.MoveDirection * Config.WalkSpeed * delta
                root.CFrame = root.CFrame + moveDir
            elseif Config.SpeedMode == "Velocity" then
                root.Velocity = humanoid.MoveDirection * Config.WalkSpeed
            elseif Config.SpeedMode == "Teleport" then
                root.CFrame = root.CFrame + humanoid.MoveDirection * Config.WalkSpeed * delta
            elseif Config.SpeedMode == "Bhop" then
                if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                humanoid.WalkSpeed = Config.WalkSpeed
            end
        end
        if Config.JumpPower > 50 then humanoid.JumpPower = Config.JumpPower end
    end
    -- Safety
    if Config.EnableSafety and humanoid and humanoid.Health / humanoid.MaxHealth * 100 < Config.SafetyHealth then
        local escapePos = root.Position + Vector3.new(math.random(-Config.EscapeDistance, Config.EscapeDistance), 0, math.random(-Config.EscapeDistance, Config.EscapeDistance))
        TweenToPosition(escapePos, Config.TeleportSpeed)
    end
    -- Teleport & Legit Tween
    local tweenSpeed = Config.EnableLegitTween and Config.LegitTweenSpeed or Config.TeleportSpeed
    if (Config.EnableTeleport or Config.EnableLegitTween) and Config.TeleportTarget ~= "" then
        local targetPlayer = Services.Players:FindFirstChild(Config.TeleportTarget)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            TweenToPosition(targetPos, tweenSpeed)
            if Config.TeleportLoop or Config.EnableLegitTween then
                task.wait(0.1) -- Small delay to loop smoothly
            end
        end
    end
    -- New PVP Functions
    if Config.AutoParry then AutoParryLogic() end
    if Config.InfiniteCombo then InfiniteComboLogic() end
    if Config.NoStun then NoStunLogic() end
    if Config.AntiLock then AntiLockLogic() end
    if Config.AutoDodge then AutoDodgeLogic() end
    if Config.FastAttack then FastAttackLogic() end
    if Config.NoCooldown then NoCooldownLogic() end
    if Config.DamageMultiplier > 1 then DamageMultiplierLogic() end
    if Config.HealthRegen then HealthRegenLogic() end
    if Config.GodMode then GodModeLogic() end
    if Config.InfiniteStamina then InfiniteStaminaLogic() end
    if Config.AutoUseSkills then AutoUseSkillsLogic() end
    if Config.KillAll then KillAllLogic() end
    if Config.NoFallDamage then NoFallDamageLogic() end
    if Config.SpinBot then SpinBotLogic() end
    if Config.AntiAdmin then AntiAdminLogic() end
    if Config.SpoofStats then SpoofStatsLogic() end
    if Config.FakeLag then FakeLagLogic() end
    if Config.AutoBlock then AutoBlockLogic() end
    if Config.RageMode then RageModeLogic() end
    if Config.SilentAim then SilentAimLogic() end
    if Config.WallBang then WallBangLogic() end
    -- Super Added
    if Config.ItemESP then ItemESPLogic() end
    if Config.AutoLoot then AutoLootLogic() end
    if Config.SpeedHack then SpeedHackLogic() end
    if Config.AntiDetect then AntiDetectLogic() end
    if Config.InfiniteMoney then InfiniteMoneyLogic() end
    if Config.AutoRevive then AutoReviveLogic() end
    if Config.EnemyWeakener then EnemyWeakenerLogic() end
    if Config.AutoLevelUp then AutoLevelUpLogic() end
    if Config.Invisibility then InvisibilityLogic() end
    if Config.SuperJump then SuperJumpLogic() end
    if Config.WallHack then WallHackLogic() end
    if Config.XRay then XRayLogic() end
    if Config.AutoWin then AutoWinLogic() end
    if Config.BanBypass then BanBypassLogic() end
    if Config.ScriptOptimizer then ScriptOptimizerLogic() end
    if Config.MultiHit then MultiHitLogic() end
    if Config.RangeExtender then RangeExtenderLogic() end
    if Config.HitEffect then HitEffectLogic() end
    if Config.CustomUI then CustomUILogic() end
end)
Services.Players.PlayerAdded:Connect(function(player)
    AddESP(player)
    player.CharacterAdded:Connect(function() AddESP(player) end)
end)
Services.Players.PlayerRemoving:Connect(RemoveESP)
for _, player in pairs(Services.Players:GetPlayers()) do
    if player ~= LocalPlayer then
        AddESP(player)
        player.CharacterAdded:Connect(function() AddESP(player) end)
    end
end
Services.UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)
task.spawn(function()
    local success, err = pcall(function()
        local oldNamecall
        if getnamecallmethod and hookmetamethod then
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if Config.AntiKick and self == LocalPlayer and (method == "Kick" or method == "kick") then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
        end
    end)
    if not success then
        warn("Failed to enable Anti-Kick: " .. tostring(err))
    end
end)
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)
-- [[ 4. XỬ LÝ PHÍM U (Bỏ ở cuối Script) ]]
Services.UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.U then
        local players = {}
        for _, p in ipairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(players, p.Name) end
        end
     
        if #players > 0 then
            local curIndex = table.find(players, Config.TeleportTarget) or 0
            local nextIndex = (curIndex % #players) + 1
            Config.TeleportTarget = players[nextIndex]
         
            -- Thông báo cho người dùng
            Fluent:Notify({
                Title = "Teleport",
                Content = "Next Target: " .. Config.TeleportTarget,
                Duration = 2
            })
        end
    end
end)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("SovereignPvPHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
Window:SelectTab(1)
Fluent:Notify({
    Title = "Sovereign Sovereign PvP Hub by Axiom & Luffy by Axiom & Luffy by Axiom",
    Content = "Loaded successfully.",
    Duration = 8
})
