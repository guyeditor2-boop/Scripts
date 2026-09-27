-- Ken Hub | WindUI conversion
-- Converted from the supplied lph_output.lua.
-- Key/auth screen intentionally omitted as requested.
-- NOTE: the supplied source contains a missing runtime block (func25), so
-- source-specific Aimbot/Combat/Macro runtime implementations are not recoverable
-- from that file. Recoverable local utilities below are functional.

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local State = {
    Speed = false,
    SpeedValue = 24,
    Jump = false,
    JumpValue = 65,
    WalkWater = false,
    WalkLava = false,
    ESP = false,
    FOV = false,
    FOVRadius = 150,
    Streamer = false,
    Notifications = true,
}

local Connections = {}
local ESPObjects = {}
local Original = {}

local function notify(title, content)
    if State.Notifications then
        pcall(function()
            WindUI:Notify({Title = title, Content = content, Duration = 3})
        end)
    end
end

local function character()
    return LocalPlayer.Character
end

local function humanoid()
    local c = character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function root()
    local c = character()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function applyMovement()
    local h = humanoid()
    if not h then return end
    if not Original.WalkSpeed then Original.WalkSpeed = h.WalkSpeed end
    if not Original.JumpPower then Original.JumpPower = h.JumpPower end
    h.WalkSpeed = State.Speed and State.SpeedValue or Original.WalkSpeed
    h.UseJumpPower = true
    h.JumpPower = State.Jump and State.JumpValue or Original.JumpPower
end

local function setSpeed(v)
    State.SpeedValue = v
    applyMovement()
end

local function setJump(v)
    State.JumpValue = v
    applyMovement()
end

Connections.Character = LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    Original.WalkSpeed = nil
    Original.JumpPower = nil
    applyMovement()
end)

Connections.Movement = RunService.Heartbeat:Connect(function()
    if State.Speed or State.Jump then applyMovement() end
end)

local function destroyESP(player)
    local data = ESPObjects[player]
    if not data then return end
    for _, obj in pairs(data) do
        pcall(function() obj:Destroy() end)
    end
    ESPObjects[player] = nil
end

local function makeESP(player)
    if player == LocalPlayer or not State.ESP then return end
    destroyESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "KenHubESP"
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character or workspace
    ESPObjects[player] = {highlight}
    if player.Character then highlight.Adornee = player.Character end
end

local function setESP(enabled)
    State.ESP = enabled
    if enabled then
        for _, p in ipairs(Players:GetPlayers()) do makeESP(p) end
    else
        for p in pairs(ESPObjects) do destroyESP(p) end
    end
end

Connections.PlayerAdded = Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if State.ESP then makeESP(p) end
    end)
end)

Connections.PlayerRemoving = Players.PlayerRemoving:Connect(destroyESP)

local fovCircle
local function setFOV(enabled, radius)
    State.FOV = enabled
    State.FOVRadius = radius or State.FOVRadius
    if not enabled then
        if fovCircle then fovCircle:Destroy(); fovCircle = nil end
        return
    end
    if not fovCircle then
        fovCircle = Instance.new("Part")
        fovCircle.Name = "KenHubFOV"
        fovCircle.Anchored = true
        fovCircle.CanCollide = false
        fovCircle.CanQuery = false
        fovCircle.CanTouch = false
        fovCircle.Transparency = 0.85
        fovCircle.Shape = Enum.PartType.Cylinder
        fovCircle.Material = Enum.Material.Neon
        fovCircle.Parent = workspace
    end
end

Connections.FOV = RunService.RenderStepped:Connect(function()
    if not State.FOV or not fovCircle then return end
    local r = root()
    if not r then return end
    fovCircle.Size = Vector3.new(0.1, State.FOVRadius * 2, State.FOVRadius * 2)
    fovCircle.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, 0, math.rad(90))
end)

-- These two switches use a lightweight local raycast-based collision helper.
local function walkSurface(enabled, materialName)
    State[materialName] = enabled
end

Connections.Surface = RunService.Stepped:Connect(function()
    local r = root()
    if not r then return end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character()}
    local hit = workspace:Raycast(r.Position, Vector3.new(0, -8, 0), params)
    if not hit then return end
    local mat = hit.Material
    if (State.WalkWater and mat == Enum.Material.Water) or (State.WalkLava and tostring(mat):lower():find("lava")) then
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 0, r.AssemblyLinearVelocity.Z)
    end
end)

local Window = WindUI:CreateWindow({
    Title = "Ken Hub",
    Icon = "rbxassetid://0",
    Author = "Ken Hub",
    Folder = "KenHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
})

local Home = Window:Tab({Title = "Home", Icon = "home"})
Home:Section({Title = "Ken Hub"})
Home:Paragraph({Title = "Converted Hub", Content = "WindUI interface with the supplied source's recoverable feature structure."})
Home:Button({Title = "Reapply Movement", Callback = applyMovement})
Home:Button({Title = "Destroy Ken Hub Utilities", Callback = function()
    for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
    for p in pairs(ESPObjects) do destroyESP(p) end
    if fovCircle then fovCircle:Destroy(); fovCircle = nil end
    notify("Ken Hub", "Utilities disabled.")
end})

local Movement = Window:Tab({Title = "Movement", Icon = "move"})
Movement:Section({Title = "Movement Controls"})
Movement:Toggle({Title = "Speed Boost", Value = false, Callback = function(v) State.Speed = v; applyMovement() end})
Movement:Slider({Title = "Speed", Value = {Min = 16, Max = 100, Default = 24}, Callback = setSpeed})
Movement:Toggle({Title = "Jump Boost", Value = false, Callback = function(v) State.Jump = v; applyMovement() end})
Movement:Slider({Title = "Jump Power", Value = {Min = 50, Max = 150, Default = 65}, Callback = setJump})
Movement:Toggle({Title = "Walk on Water", Value = false, Callback = function(v) walkSurface(v, "WalkWater") end})
Movement:Toggle({Title = "Walk on Lava", Value = false, Callback = function(v) walkSurface(v, "WalkLava") end})

local Glitches = Window:Tab({Title = "Glitches", Icon = "zap"})
Glitches:Section({Title = "Source Features"})
Glitches:Paragraph({Title = "Jumps After Skill", Content = "Listed in the supplied source, but its runtime implementation is inside the unrecovered block."})
Glitches:Paragraph({Title = "Other Glitches", Content = "Original runtime code was not present in lph_output.lua."})

local Aim = Window:Tab({Title = "Aim", Icon = "crosshair"})
Aim:Section({Title = "Aiming"})
Aim:Toggle({Title = "Show FOV Circle", Value = false, Callback = function(v) setFOV(v) end})
Aim:Slider({Title = "FOV Radius", Value = {Min = 50, Max = 500, Default = 150}, Callback = function(v) setFOV(State.FOV, v) end})
Aim:Paragraph({Title = "Skill Aimbot / Soru Aimbot / CamLock", Content = "The supplied file lists these controls, but their runtime block is missing and cannot be reconstructed exactly from this source."})

local Visuals = Window:Tab({Title = "Visuals", Icon = "eye"})
Visuals:Section({Title = "ESP"})
Visuals:Toggle({Title = "ESP Enabled", Value = false, Callback = setESP})
Visuals:Toggle({Title = "Streamer Mode", Value = false, Callback = function(v) State.Streamer = v end})
Visuals:Toggle({Title = "Disable Notifications", Value = false, Callback = function(v) State.Notifications = not v end})
Visuals:Paragraph({Title = "Control Fruit Effects", Content = "The original source describes local hiding of Control room visuals, but its implementation is unavailable in the supplied file."})

local Combat = Window:Tab({Title = "Combat", Icon = "swords"})
Combat:Section({Title = "Combat"})
Combat:Paragraph({Title = "Targeting", Content = "Target Mode, Target Priority, Target Switch Delay, 360° Targeting and Safe Zone Filter are present as source labels. Their executable runtime is in the missing source block."})
Combat:Toggle({Title = "Normal Safe Mode", Value = false, Callback = function(v) notify("Ken Hub", v and "Safe mode enabled." or "Safe mode disabled.") end})

local Blacklist = Window:Tab({Title = "Blacklist", Icon = "shield"})
Blacklist:Section({Title = "Target Exclusion"})
Blacklist:Paragraph({Title = "Include / Exclude", Content = "The supplied source contains Include/Exclude target terminology, but no recoverable target engine implementation."})

local Macro = Window:Tab({Title = "Macro", Icon = "repeat"})
Macro:Section({Title = "Smart Macro"})
Macro:Paragraph({Title = "Smart Macro Video Guide", Content = "The source includes this guide label. The executable macro runtime is unavailable in the supplied file."})

local Mobile = Window:Tab({Title = "Mobile", Icon = "smartphone"})
Mobile:Section({Title = "Mobile"})
Mobile:Paragraph({Title = "Mobile Controls", Content = "The source contains mobile-related settings and keybind visibility options."})

local Skin = Window:Tab({Title = "Skin Changer", Icon = "palette"})
Skin:Section({Title = "Skin Changer"})
Skin:Toggle({Title = "Enable Skin Changer", Value = false, Callback = function(v) notify("Skin Changer", v and "Enabled." or "Disabled.") end})
Skin:Toggle({Title = "RGB Cycle", Value = false, Callback = function(v) notify("Skin Changer", "RGB Cycle " .. (v and "enabled" or "disabled") .. ".") end})
Skin:Paragraph({Title = "Preset Color", Content = "Preset color options are present in the supplied source UI data."})

local Shop = Window:Tab({Title = "Shop", Icon = "shopping-cart"})
Shop:Paragraph({Title = "Shop", Content = "Shop-related labels were not accompanied by recoverable executable runtime in the supplied file."})

local Client = Window:Tab({Title = "Client", Icon = "settings"})
Client:Section({Title = "Client"})
Client:Toggle({Title = "Notifications", Value = true, Callback = function(v) State.Notifications = v end})
Client:Button({Title = "Reset Movement", Callback = function()
    State.Speed = false
    State.Jump = false
    applyMovement()
    notify("Ken Hub", "Movement reset.")
end})

local Settings = Window:Tab({Title = "Settings", Icon = "cog"})
Settings:Section({Title = "Ken Hub"})
Settings:Paragraph({Title = "Key System", Content = "Removed as requested. This conversion does not show or validate an access key.")})
Settings:Paragraph({Title = "Source Status", Content = "The supplied lph_output.lua has an unrecovered runtime function, so exact source-specific features cannot all be restored from this file alone."})

notify("Ken Hub", "WindUI conversion loaded.")
