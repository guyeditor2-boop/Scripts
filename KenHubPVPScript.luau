local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local v = workspace
local localPlayer = Players.LocalPlayer
local genv = type(getgenv) == "function" and getgenv() or _G

if genv.KenHubPvp and genv.KenHubPvp.Unload then
	pcall(genv.KenHubPvp.Unload)
	task.wait(0.25)
end

local tbl = { Name = "Ken Hub", Game = "Blox Fruits PvP", Build = "1.0" }
local flag = true
local tbl2 = {}
local tbl3 = {}
local currentCamera = v.CurrentCamera
local mouse = localPlayer:GetMouse()
local gethui_ = rawget(genv, "gethui")
local v2 = nil
local v3 = nil
local n = nil
local unit = nil
local v4 = nil
local position = nil
local position2 = nil
local unit2 = nil
local flag2 = false
local flag3 = false
local flag4 = false

local tbl4 = {
	pickMode = "Smart",
	smartHp = 50,
	part = "Head",
	useFov = true,
	fov = 160,
	maxDist = 1500,
	pred = 0.1,
	speed = false,
	speedValue = 80,
	jumpOn = false,
	jumpValue = 80,
	noclip = false,
	noStun = false,
	moverFilter = "Smart",
	fly = false,
	flyKey = "None",
	flyMode = "Smart",
	engageDist = 8,
	engageEdge = 10,
	retreatHp = 40,
	gankRange = 60,
	autoSkill = false,
	skillKeys = { Z = true, X = true, C = true, V = true },
	skillRange = 60,
	skillHold = 0.1,
	skillGap = 0.35,
	flySpeed = 200,
	flySafe = 180,
	flyDist = 10,
	flyUp = 8,
	kiteDist = 25,
	kiteSway = 6,
	antiAim = false,
	antiAimPower = 200,
	dodge = false,
	dodgeRange = 25,
	dodgeDist = 14,
	dodgeCd = 1.5,
	orbitRadius = 12,
	orbitSpeed = 2.5,
	flyNoclip = true,
	hitbox = false,
	hitboxSize = 12,
	hitboxShow = true,
	autoGun = false,
	gunPick = "Dragonstorm",
	gunRange = 150,
	gunRate = 0.35,
	gunSkills = false,
	gunBack = true,
	escape = false,
	escapeHp = 25,
	escapeUp = 250,
	killNote = true,
	teamCheck = true,
	wallCheck = false,
	skipFriends = false,
	lockKey = "T",
	aimbot = false,
	aimTrigger = "Hold right mouse",
	aimKey = "Q",
	smooth = 0.25,
	silent = false,
	chance = 100,
	aura = false,
	auraAll = true,
	auraRange = 55,
	auraRate = 0.12,
	auraWeapon = "Keep current",
	buso = false,
	ken = false,
	race = false,
	stick = false,
	stickUp = 6,
	stickBack = 3,
	stickRange = 150,
	spectate = false,
	infJump = false,
	antiAfk = true,
	esp = false,
	box = true,
	name = true,
	info = true,
	bar = true,
	hpText = true,
	chams = false,
	tracer = false,
	tracerFrom = "Bottom",
	espDist = 3000,
	espColor = "White",
	teamColor = false,
	showFov = true,
	tgtLine = true,
	lineFrom = "Character",
	tgtMark = true,
	tgtColor = "Red",
	uiKey = "RightControl",
}

local tbl5 = {
	White = Color3.fromRGB(240, 240, 240),
	Red = Color3.fromRGB(255, 70, 70),
	Green = Color3.fromRGB(80, 230, 120),
	Blue = Color3.fromRGB(80, 160, 255),
	Yellow = Color3.fromRGB(255, 215, 70),
	Purple = Color3.fromRGB(180, 110, 255),
	Cyan = Color3.fromRGB(70, 220, 230),
}

local tbl6 = { "White", "Red", "Green", "Blue", "Yellow", "Purple", "Cyan" }
Aura = { swings = 0, note = "Off" }
Move = { on = false, clip = {} }
Gun = { shots = 0, note = "Off", aimUntil = 0 }
Fly = { note = "Off", slowUntil = 0, rubber = 0, angle = 0, step = 0 }
Hit = { orig = {} }
Esp = { pool = {} }
UI = {}

bind = function(arg)
	tbl2[#tbl2 + 1] = arg
	return arg
end

spin = function(arg, arg2, arg3)
	task.spawn(function()
		local v5 = nil

		while flag do
			local ok, result, result2 = pcall(arg3)
			local flag5 = not ok and result or result == false and result2 or nil

			if flag5 and flag5 ~= v5 then
				local v6 = warn
				local str = ("! %*: %*"):format(arg, flag5)
				v6(str)
			end

			task.wait(type(arg2) == "function" and arg2() or arg2)
			v5 = flag5
		end
	end)
end

alive = function(arg)
	arg = arg and arg.Character
	local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
	if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
		return
	end
	return arg, humanoid, humanoidRootPart
end

friendly = function(arg)
	if tbl4.teamCheck and localPlayer.Team and arg.Team == localPlayer.Team and localPlayer.Team.Name == "Marines" then
		return true
	end
	return tbl4.skipFriends and tbl3[arg.UserId] == true
end

foe = function(arg)
	if arg == localPlayer or friendly(arg) then
		return
	end
	return alive(arg)
end

befriend = function(arg)
	if arg == localPlayer then
		return
	end

	task.spawn(function()
		local ok, result = pcall(localPlayer.IsFriendsWith, localPlayer, arg.UserId)
		tbl3[arg.UserId] = ok and result or nil
	end)
end

keyName = function(arg)
	return typeof(arg) == "EnumItem" and arg.Name or tostring(arg)
end

keyDown = function(arg)
	local ok, result = pcall(function()
		return Enum.KeyCode[arg]
	end)

	return ok and UserInputService:IsKeyDown(result)
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

seen = function(arg, arg2)
	raycastParams.FilterDescendantsInstances = { localPlayer.Character, arg }
	local position3 = currentCamera.CFrame.Position
	return v:Raycast(position3, arg2.Position - position3, raycastParams) == nil
end

pick = function()
	local v5, v6, v7 = alive(localPlayer)
	if not v7 then
		return
	end

	if v4 then
		local v8, v9, v10 = foe(v4)
		if v8 then
			return v4, v8:FindFirstChild(tbl4.part) or v10
		end
		v4 = nil
	end

	local mouseLocation = UserInputService:GetMouseLocation()
	local v8 = nil
	local v9 = nil
	local v10 = nil
	local v11 = nil

	for _, player in ipairs(Players:GetPlayers()) do
		local v12, v13, v14 = foe(player)

		if v12 then
			local v15 = v12:FindFirstChild(tbl4.part) or v14
			local magnitude = (v14.Position - v7.Position).Magnitude
			local v16, magnitude2 = currentCamera:WorldToViewportPoint(v15.Position)
			magnitude2 = magnitude2 and (Vector2.new(v16.X, v16.Y) - mouseLocation).Magnitude or math.huge
			local flag5 = magnitude <= tbl4.maxDist and (not tbl4.useFov or magnitude2 <= tbl4.fov or tbl4.fly and player == v2)
			local health

			if tbl4.pickMode == "Smart" then
				health = smart(magnitude, v13, magnitude2)
			else
				health = tbl4.pickMode == "Nearest cursor" and magnitude2 or tbl4.pickMode == "Lowest health" and v13.Health or magnitude
				flag5 = flag5 and health < math.huge
			end

			if flag5 and (not tbl4.wallCheck or seen(v12, v15)) then
				if player == v2 then
					v8 = health
				end

				if not v9 or health < v9 then
					v9 = health
					v10 = player
					v11 = v15
				end
			end
		end
	end

	if tbl4.pickMode == "Smart" and v8 and v10 ~= v2 and v9 > v8 - 0.08 then
		local v12, v13, v14 = alive(v2)
		return v2, v12:FindFirstChild(tbl4.part) or v14
	end
	return v10, v11
end

smart = function(arg, arg2, arg3)
	local n2 = tbl4.smartHp / 100 * 0.85
	local n3 = 0.85 - n2
	local n4 = arg2.MaxHealth > 0 and arg2.Health / arg2.MaxHealth or 1
	local n5 = arg3 == math.huge and 1

	if not n5 then
		n5 = math.clamp(arg3 / (tbl4.useFov and tbl4.fov or 800), 0, 1)
	end

	local n6 = n3 * math.clamp(arg / tbl4.maxDist, 0, 1) + n2 * n4 + 0.15 * n5

	if n4 <= 0.25 then
		n6 -= 0.2
	end

	return n6
end

triggered = function()
	if tbl4.aimTrigger == "Always" then
		return true
	end

	if tbl4.aimTrigger == "Hold key" then
		return keyDown(tbl4.aimKey)
	end
	return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end

dot = function(arg, arg2)
	return arg.X * arg2.X + arg.Y * arg2.Y + arg.Z * arg2.Z
end

bend = function(arg)
	local kind = typeof(arg)

	if kind == "Vector3" then
		if (arg - position2).Magnitude <= 12 then
			return n
		end

		if math.abs(arg.Magnitude - 1) < 0.01 and dot(arg, unit2) > 0.98 then
			return unit
		end
	elseif kind == "CFrame" then
		local position3 = arg.Position
		if (position3 - position2).Magnitude <= 12 then
			return CFrame.new(n)
		end

		if (position3 - position).Magnitude < 15 and dot(arg.LookVector, unit2) > 0.98 then
			return CFrame.lookAt(position3, n)
		end
	end

	return arg
end

hook = function()
	if flag3 then
		return true
	end

	if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
		return false, "No hookmetamethod"
	end

	if not (type(newcclosure) == "function" and newcclosure) then
		local function fn(arg)
			return arg
		end
	end

	error("devirt: value <luasym.LuaFunc object at 0x7fdb45a2e290> in an expression (at 69:17)")
end

jumpHeight = function(arg)
	return arg * arg / 2 * v.Gravity
end

local tbl7 = {
	Enum.HumanoidStateType.Ragdoll,
	Enum.HumanoidStateType.FallingDown,
	Enum.HumanoidStateType.PlatformStanding,
}

stunWrite = function(arg, arg2)
	if arg == "WalkSpeed" or arg == "JumpPower" or arg == "JumpHeight" then
		return type(arg2) == "number" and arg2 <= 1
	end

	if arg == "PlatformStand" then
		return arg2 == true
	end

	if arg == "AutoRotate" then
		return arg2 == false
	end
	return false
end

unstun = function(arg, stunHum, arg2)
	local flag5 = tbl4.noStun and stunHum ~= nil

	if flag5 and (not Move.stunOff or stunHum ~= Move.stunHum) then
		Move.stunSaved = {}

		for _, v5 in ipairs(tbl7) do
			Move.stunSaved[v5] = stunHum:GetStateEnabled(v5)
			stunHum:SetStateEnabled(v5, false)
		end

		local v5 = Move
		Move.stunOff = true
		v5.stunHum = stunHum
	elseif not flag5 and Move.stunOff then
		local stunHum2 = Move.stunHum

		if stunHum2 and stunHum2.Parent then
			local v5 = pairs
			local stunSaved = Move.stunSaved or {}

			for k, v6 in v5(stunSaved) do
				stunHum2:SetStateEnabled(k, v6)
			end
		end

		local v5 = Move
		Move.stunOff = false
		v5.stunHum = nil
	end

	if not flag5 then
		return
	end

	if stunHum.PlatformStand then
		stunHum.PlatformStand = false
	end

	if not stunHum.AutoRotate then
		stunHum.AutoRotate = true
	end

	if arg2.Anchored then
		arg2.Anchored = false
	end

	local stun = arg:FindFirstChild("Stun")

	if stun and stun:IsA("ValueBase") and type(stun.Value) == "number" and stun.Value ~= 0 then
		stun.Value = 0
	end

	local busy = arg:FindFirstChild("Busy")

	if busy and busy:IsA("BoolValue") and busy.Value then
		busy.Value = false
	end
end

movement = function()
	local v5, v6, v7 = alive(localPlayer)
	Move.root = v7
	pcall(unstun, v5, v6, v7)
	Move.watch = tbl4.noStun or Move.on

	if v6 ~= Move.hum then
		Move.hum = v6
		local v8 = Move
		Move.real = {}
		v8.forced = {}
	end

	Move.real = Move.real or {}
	Move.forced = Move.forced or {}
	if not v6 then
		Move.on = false
		return
	end
	local forced = {}

	if tbl4.speed then
		forced.WalkSpeed = tbl4.speedValue
	end

	if tbl4.jumpOn then
		forced.JumpPower = tbl4.jumpValue
		forced.JumpHeight = jumpHeight(tbl4.jumpValue)
	end

	for k, v8 in pairs(Move.real) do
		if forced[k] == nil then
			v6[k] = v8
			Move.real[k] = nil
		end
	end

	for k, v8 in pairs(forced) do
		if Move.real[k] == nil then
			Move.real[k] = v6[k]
		end

		if v6[k] ~= v8 then
			v6[k] = v8
		end
	end

	Move.forced = forced
	Move.on = next(forced) ~= nil
	Move.watch = tbl4.noStun or Move.on
end

noclip = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local noclip_ = tbl4.noclip or tbl4.fly and tbl4.flyNoclip and v2 ~= nil

	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if noclip_ then
				if Move.clip[descendant] == nil then
					Move.clip[descendant] = descendant.CanCollide
				end

				descendant.CanCollide = false
			elseif Move.clip[descendant] ~= nil then
				descendant.CanCollide = Move.clip[descendant]
				Move.clip[descendant] = nil
			end
		end
	end

	if not noclip_ then
		table.clear(Move.clip)
	end
end

escape = function()
	local v5, v6, v7 = alive(localPlayer)
	if not tbl4.escape or not v6 then
		return
	end
	local n2 = v6.MaxHealth > 0 and v6.Health / v6.MaxHealth * 100 or 100
	if tbl4.escapeHp < n2 then
		Move.fled = false
		return
	end

	if Move.fled then
		return
	end
	Move.fled = true
	v7.CFrame = v7.CFrame + Vector3.new(0, tbl4.escapeUp, 0)
	v7.AssemblyLinearVelocity = Vector3.zero

	if UI.note then
		local escapeUp = tbl4.escapeUp
		UI.note(("HP %*%%, escaped %* studs up"):format(math.floor(n2), escapeUp), "warn")
	end
end

findGun = function(arg)
	local flag5 = tbl4.gunPick == "Any gun"

	local function fn(arg2)
		if not arg2:IsA("Tool") then
			return false
		end

		if flag5 then
			return arg2.ToolTip == "Gun"
		end
		return string.find(string.lower(string.gsub(arg2.Name, "%s", "")), "dragonstorm", 1, true) ~= nil
	end

	for _, child in ipairs(arg:GetChildren()) do
		if fn(child) then
			return child, true
		end
	end

	for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
		if fn(child) then
			return child, false
		end
	end
end

press = function(arg)
	local ok, result = pcall(game.GetService, game, "VirtualInputManager")
	if not ok or not result then
		return
	end

	pcall(function()
		result:SendKeyEvent(true, Enum.KeyCode[arg], false, game)
		task.wait(0.06)
		result:SendKeyEvent(false, Enum.KeyCode[arg], false, game)
	end)
end

shoot = function()
	local v5, v6, v7 = alive(localPlayer)
	if not v5 then
		return false, "No character"
	end
	local v8, v9, v10 = alive(v2)
	if not v10 then
		return false, "No target"
	end

	if tbl4.gunRange < (v10.Position - v7.Position).Magnitude then
		return false, "Target out of range"
	end
	local v11, v12 = findGun(v5)
	if not v11 then
		return false, tbl4.gunPick == "Any gun" and "No gun in backpack" or "No Dragonstorm in backpack"
	end
	local v13, v14 = hook()
	if not v13 then
		return false, v14
	end
	local tool = v5:FindFirstChildOfClass("Tool")

	if not v12 then
		v6:EquipTool(v11)
		task.wait(0.12)
	end

	Gun.aimUntil = os.clock() + (tbl4.gunSkills and 0.9 or 0.4)
	v11:Activate()

	if tbl4.gunSkills then
		press("Z")
		press("X")
	end

	local v15 = Gun
	v15.shots = v15.shots + 1

	if tbl4.gunBack and tool and tool ~= v11 then
		task.delay(0.3, function()
			if tool.Parent == localPlayer.Backpack and alive(localPlayer) then
				v6:EquipTool(tool)
			end
		end)
	end

	return true, (("Shots %*"):format(Gun.shots))
end

net = function()
	local modules = ReplicatedStorage:FindFirstChild("Modules")
	modules = modules and modules:FindFirstChild("Net")
	return modules and modules:FindFirstChild("RE/RegisterAttack"), modules and modules:FindFirstChild("RE/RegisterHit")
end

remote = function(arg)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild(arg)
end

local tbl8 = { Melee = true, Sword = true }

arm = function(arg, arg2)
	local tool = arg:FindFirstChildOfClass("Tool")

	if tbl4.auraWeapon == "Keep current" then
		if tool and tbl8[tool.ToolTip] then
			return tool
		end
		return nil, "Hold a melee or sword"
	end

	if tool and tool.ToolTip == tbl4.auraWeapon then
		return tool
	end

	for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
		if child:IsA("Tool") and child.ToolTip == tbl4.auraWeapon then
			arg2:EquipTool(child)
			return child
		end
	end

	return nil, (("No %* in backpack"):format(tbl4.auraWeapon))
end

swing = function()
	local v5, v6, v7 = alive(localPlayer)
	if not v5 then
		return false, "No character"
	end
	local v8, v9 = net()
	if not v8 or not v9 then
		return false, "No combat api"
	end
	local tbl9 = {}

	for _, player in ipairs(Players:GetPlayers()) do
		local v10, v11, v12 = foe(player)

		if v10 and (tbl4.auraAll or player == v2) and (v12.Position - v7.Position).Magnitude <= tbl4.auraRange then
			local n2 = #tbl9 + 1
			local tbl10 = {}
			local head = v10:FindFirstChild("Head") or v12
			tbl10[1] = v10
			tbl10[2] = head
			tbl9[n2] = tbl10
		end
	end

	if #tbl9 == 0 then
		return false, "No one in range"
	end
	local v10, v11 = arm(v5, v6)
	if v11 then
		return false, v11
	end
	v8:FireServer(0)
	v9:FireServer(tbl9[1][2], tbl9)
	local v12 = Aura
	v12.swings = v12.swings + 1
	return true, (("Hit %*"):format(#tbl9))
end

buso = function()
	local v5 = alive(localPlayer)
	if not v5 or v5:FindFirstChild("HasBuso") then
		return
	end
	local CommF_ = remote("CommF_")
	if not CommF_ then
		return false, "No CommF_"
	end
	CommF_:InvokeServer("Buso")
end

ken = function()
	if not alive(localPlayer) then
		return
	end
	local CommE = remote("CommE")
	if not CommE then
		return false, "No CommE"
	end
	CommE:FireServer("Ken", true)
end

race = function()
	if not alive(localPlayer) then
		return false, "No character"
	end
	local CommE = remote("CommE")
	if not CommE then
		return false, "No CommE"
	end
	CommE:FireServer("ActivateAbility")
	return true
end

local tbl9 = {
	BodyVelocity = true,
	BodyPosition = true,
	BodyGyro = true,
	BodyForce = true,
	BodyAngularVelocity = true,
	BodyThrust = true,
	RocketPropulsion = true,
	LinearVelocity = true,
	AlignPosition = true,
	AlignOrientation = true,
	VectorForce = true,
	AngularVelocity = true,
}

stunMover = function(arg, arg2)
	if not tbl9[arg.ClassName] or arg:GetAttribute("KenHubPvp") then
		return false
	end

	if tbl4.moverFilter == "Remove all" or not arg2 then
		return true
	end
	local lookVector = arg2.CFrame.LookVector
	local velocity = arg:IsA("BodyVelocity") and arg.Velocity or arg:IsA("LinearVelocity") and arg.VectorVelocity or nil

	if velocity then
		if velocity.Magnitude < 1 then
			return true
		end
		return velocity.Unit:Dot(lookVector) < 0.3
	end

	local position3 = arg:IsA("BodyPosition") and arg.Position or arg:IsA("AlignPosition") and arg.Position or nil
	if position3 then
		local n2 = position3 - arg2.Position
		return n2.Magnitude < 4 or n2.Unit:Dot(lookVector) < 0.3
	end
	return true
end

watchMovers = function(arg)
	if Move.moverBond then
		Move.moverBond:Disconnect()
	end

	if not arg then
		return
	end

	Move.moverBond = bind(arg.DescendantAdded:Connect(function(descendant)
		if not tbl4.noStun or not tbl9[descendant.ClassName] then
			return
		end

		task.defer(function()
			if descendant.Parent and stunMover(descendant, arg:FindFirstChild("HumanoidRootPart")) then
				descendant:Destroy()
			end
		end)
	end))
end

sweepMovers = function()
	if not tbl4.noStun then
		return
	end
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	for _, descendant in ipairs(character:GetDescendants()) do
		if tbl9[descendant.ClassName] and stunMover(descendant, humanoidRootPart) then
			descendant:Destroy()
		end
	end
end

flyGoal = function(arg, arg2)
	local vector = Vector3.new(0, tbl4.flyUp, 0)

	if tbl4.flyMode == "Smart" then
		local v5, v6 = alive(localPlayer)
		local v7, v8 = alive(v2)
		local n2 = v6 and v6.MaxHealth > 0 and v6.Health / v6.MaxHealth or 1
		local n3 = v8 and v8.MaxHealth > 0 and v8.Health / v8.MaxHealth or 1
		local v9 = Fly
		local flag5 = n2 * 100 >= tbl4.retreatHp

		if flag5 then
			flag5 = (Fly.crowd or 0) <= 1
		end

		v9.push = flag5 and (n2 - n3) * 100 >= -tbl4.engageEdge
		local v10 = Fly
		v10.angle = v10.angle + arg2
		local n4 = -arg.CFrame.LookVector
		local vector2 = Vector3.new(n4.X, 0, n4.Z)
		local unit3 = vector2.Magnitude > 0.1 and vector2.Unit or Vector3.new(0, 0, 1)
		local vector3 = Vector3.new(-unit3.Z, 0, unit3.X)
		if Fly.push then
			return arg.Position + unit3 * tbl4.engageDist + Vector3.new(0, 2, 0)
		end
		local kiteSway = tbl4.kiteSway
		return arg.Position + unit3 * tbl4.kiteDist + vector3 * math.sin(Fly.angle * 2) * kiteSway + vector
	end

	if tbl4.flyMode == "Kite" then
		local v5 = Fly
		v5.angle = v5.angle + arg2
		local n2 = -arg.CFrame.LookVector
		local vector2 = Vector3.new(n2.X, 0, n2.Z)
		local unit3 = vector2.Magnitude > 0.1 and vector2.Unit or Vector3.new(0, 0, 1)
		local kiteSway = tbl4.kiteSway
		return arg.Position + unit3 * tbl4.kiteDist + Vector3.new(-unit3.Z, 0, unit3.X) * math.sin(Fly.angle * 2) * kiteSway + vector
	end

	if tbl4.flyMode == "Orbit" then
		local v5 = Fly
		v5.angle = v5.angle + tbl4.orbitSpeed * arg2
		local sin = math.sin
		local angle = Fly.angle
		local orbitRadius = tbl4.orbitRadius
		return arg.Position + Vector3.new(math.cos(Fly.angle), 0, sin(angle)) * orbitRadius + vector
	end

	local assemblyLinearVelocity = arg.AssemblyLinearVelocity
	local vector2 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
	if vector2.Magnitude > 2 then
		return arg.Position + vector2.Unit * tbl4.flyDist + vector
	end
	return arg.Position - arg.CFrame.LookVector * tbl4.flyDist + vector
end

fly = function(arg)
	if not tbl4.fly then
		local v5 = Fly
		Fly.expect = nil
		v5.note = "Off"
		return
	end

	local v5, v6, note = alive(localPlayer)
	local v7, v8, v9 = alive(v2)

	if not note or not v9 then
		Fly.expect = nil
		local v10 = Fly
		note = note and "No target" or "No character"
		v10.note = note
		return
	end

	if Fly.expect and (note.Position - Fly.expect).Magnitude > math.max(8, Fly.step * 3) then
		Fly.slowUntil = os.clock() + 6
		local v10 = Fly
		v10.rubber = v10.rubber + 1
	end

	local slowUntil = Fly.slowUntil
	local flySafe = os.clock() < slowUntil and tbl4.flySafe or tbl4.flySpeed
	local position3 = note.Position
	local n2 = flyGoal(v9, arg) - position3
	local step = math.min(n2.Magnitude, flySafe * arg)
	local position4 = n2.Magnitude > 0.05 and note.Position + n2.Unit * step or note.Position
	note.CFrame = CFrame.lookAt(position4, Vector3.new(v9.Position.X, position4.Y, v9.Position.Z))
	note.AssemblyLinearVelocity = Vector3.zero
	note.AssemblyAngularVelocity = Vector3.zero
	local v10 = Fly
	Fly.expect = position4
	v10.step = step
	local str = tbl4.flyMode == "Smart" and (Fly.push and "ATTACK  |  " or "KITE  |  ") or ""
	local rubber = Fly.rubber
	Fly.note = ("%*%* studs/s  |  %* away  |  pulled back %*x"):format(str, flySafe, math.floor(n2.Magnitude), rubber)
end

antiAimBeat = function()
	if not tbl4.antiAim then
		return
	end
	local v5, v6, v7 = alive(localPlayer)
	if not v7 then
		return
	end
	Fly.realVel = v7.AssemblyLinearVelocity
	local antiAimPower = tbl4.antiAimPower
	local random = math.random
	v7.AssemblyLinearVelocity = Vector3.new(math.random(-antiAimPower, antiAimPower), math.random(-antiAimPower, antiAimPower) * 0.3, random(-antiAimPower, antiAimPower))
end

antiAimStep = function()
	if not Fly.realVel then
		return
	end
	local v5, v6, v7 = alive(localPlayer)

	if v7 then
		v7.AssemblyLinearVelocity = Fly.realVel
	end

	Fly.realVel = nil
end

dodge = function()
	local flag5 = not tbl4.dodge

	if not flag5 then
		flag5 = os.clock() < (Move.dodgeAt or 0)
	end

	if flag5 then
		return
	end
	local v5, v6, v7 = alive(localPlayer)
	if not v7 then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		local v8, v9, v10 = foe(player)

		if v8 then
			local n2 = v7.Position - v10.Position
			local magnitude = n2.Magnitude

			if magnitude > 0.1 and magnitude < tbl4.dodgeRange and v10.CFrame.LookVector:Dot(n2.Unit) > 0.85 then
				local vector = Vector3.new(n2.X, 0, n2.Z)
				local unit3 = vector.Magnitude > 0.1 and Vector3.new(-vector.Z, 0, vector.X).Unit or Vector3.new(1, 0, 0)

				if math.random() < 0.5 then
					unit3 = -unit3
				end

				v7.CFrame = v7.CFrame + unit3 * tbl4.dodgeDist
				Fly.expect = nil
				local dodgeCd = tbl4.dodgeCd
				Move.dodgeAt = os.clock() + dodgeCd
				return
			end
		end
	end
end

crowd = function()
	local v5, v6, v7 = alive(localPlayer)
	if not v7 then
		Fly.crowd = 0
		return
	end
	local crowd_ = 0

	for _, player in ipairs(Players:GetPlayers()) do
		local v8, v9, v10 = foe(player)

		if v8 and (v10.Position - v7.Position).Magnitude <= tbl4.gankRange then
			crowd_ += 1
		end
	end

	local flag5 = crowd_ >= 2

	if flag5 then
		flag5 = (Fly.crowd or 0) < 2
	end

	if flag5 and UI.note then
		UI.note(("%* enemies around you, backing off"):format(crowd_), "warn")
	end

	Fly.crowd = crowd_
end

hold = function(arg, arg2)
	local ok, result = pcall(game.GetService, game, "VirtualInputManager")
	if not ok or not result then
		return
	end

	pcall(function()
		result:SendKeyEvent(true, Enum.KeyCode[arg], false, game)
		task.wait(math.max(arg2, 0.03))
		result:SendKeyEvent(false, Enum.KeyCode[arg], false, game)
	end)
end

skills = function()
	local v5, v6, v7 = alive(localPlayer)
	if not v5 then
		return false, "No character"
	end
	local v8, v9, v10 = alive(v2)
	if not v10 then
		return false, "No target"
	end

	if tbl4.skillRange < (v10.Position - v7.Position).Magnitude then
		return false, "Target out of range"
	end
	local v11, v12 = hook()
	if not v11 then
		return false, v12
	end

	for _, v13 in ipairs({ "Z", "X", "C", "V", "F" }) do
		if not (not tbl4.autoSkill or not alive(v2)) then
			if tbl4.skillKeys[v13] then
				local skillHold = tbl4.skillHold
				Gun.aimUntil = os.clock() + skillHold + 0.5
				hold(v13, tbl4.skillHold)
				task.wait(tbl4.skillGap)
			end

			continue
		end

		break
	end
end

hitboxes = function()
	for _, player in ipairs(Players:GetPlayers()) do
		local humanoidRootPart = player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			local v5 = Hit.orig[humanoidRootPart]

			if tbl4.hitbox and foe(player) then
				if not v5 then
					Hit.orig[humanoidRootPart] = { humanoidRootPart.Size, humanoidRootPart.Transparency, humanoidRootPart.CanCollide }
				end

				local size = Vector3.one * tbl4.hitboxSize

				if humanoidRootPart.Size ~= size then
					humanoidRootPart.Size = size
				end

				humanoidRootPart.Transparency = tbl4.hitboxShow and 0.8 or 1
				humanoidRootPart.CanCollide = false
			elseif v5 then
				local v6 = v5[1]
				local v7 = v5[2]
				local v8 = v5[3]
				humanoidRootPart.Size = v6
				humanoidRootPart.Transparency = v7
				humanoidRootPart.CanCollide = v8
				Hit.orig[humanoidRootPart] = nil
			end
		end
	end

	for k in pairs(Hit.orig) do
		if not k.Parent then
			Hit.orig[k] = nil
		end
	end
end

stick = function()
	if not tbl4.stick or not v2 or tbl4.fly then
		return
	end
	local v5, v6, v7 = alive(localPlayer)
	local v8, v9, v10 = alive(v2)
	if not v7 or not v10 or (v10.Position - v7.Position).Magnitude > tbl4.stickRange then
		return
	end
	local n2 = v10.Position - v10.CFrame.LookVector * tbl4.stickBack + Vector3.new(0, tbl4.stickUp, 0)
	v7.CFrame = CFrame.lookAt(n2, Vector3.new(v10.Position.X, n2.Y, v10.Position.Z))
	v7.AssemblyLinearVelocity = Vector3.zero
end

antiAfk = function()
	if type(getconnections) ~= "function" then
		return false, "No getconnections"
	end

	for _, v5 in ipairs(getconnections(localPlayer.Idled)) do
		pcall(function()
			if tbl4.antiAfk then
				v5:Disable()
			else
				v5:Enable()
			end
		end)
	end

	return true
end

local flag5 = type(Drawing) == "table" and type(Drawing.new) == "function"

draw = function(arg, arg2)
	local v5 = Drawing.new(arg)

	for k, v6 in pairs(arg2) do
		v5[k] = v6
	end

	return v5
end

kit = function(arg)
	local v5 = Esp.pool[arg]
	if v5 then
		return v5
	end

	local tbl10 = {
		edge = draw("Square", { Thickness = 3, Filled = false, Color = Color3.new(), Visible = false }),
		box = draw("Square", { Thickness = 1, Filled = false, Visible = false }),
		name = draw("Text", { Size = 14, Center = true, Outline = true, Visible = false }),
		info = draw("Text", {
			Size = 13,
			Center = true,
			Outline = true,
			Color = Color3.fromRGB(210, 210, 210),
			Visible = false,
		}),
		back = draw("Square", { Filled = true, Color = Color3.new(), Visible = false }),
		fill = draw("Square", { Filled = true, Visible = false }),
		hp = draw("Text", { Size = 12, Outline = true, Visible = false }),
		line = draw("Line", { Thickness = 1, Visible = false }),
	}

	Esp.pool[arg] = tbl10
	return tbl10
end

blank = function(arg)
	for k, v5 in pairs(arg) do
		if k ~= "cham" then
			v5.Visible = false
		end
	end
end

hide = function(arg)
	blank(arg)

	if arg.cham then
		arg.cham.Enabled = false
	end
end

drop = function(arg)
	local v5 = Esp.pool[arg]
	if not v5 then
		return
	end

	for _, v6 in pairs(v5) do
		pcall(function()
			v6:Destroy()
		end)
	end

	Esp.pool[arg] = nil
end

tintOf = function(arg)
	if arg == v2 and tbl4.tgtMark then
		return tbl5[tbl4.tgtColor]
	end

	if tbl4.teamColor and arg.Team then
		return arg.TeamColor.Color
	end
	return tbl5[tbl4.espColor]
end

lore = function(arg, arg2)
	local data = arg:FindFirstChild("Data")
	local level = data and data:FindFirstChild("Level")
	data = data and data:FindFirstChild("DevilFruit")
	local tbl10 = { (("%*m"):format(math.floor(arg2))) }

	if level then
		local insert = table.insert
		local str = ("Lv %*"):format(level.Value)
		insert(tbl10, 1, str)
	end

	if data and data.Value ~= "" then
		tbl10[#tbl10 + 1] = data.Value
	end

	return table.concat(tbl10, " | ")
end

cham = function(arg, parent, fillColor)
	if not tbl4.chams then
		if arg.cham then
			arg.cham.Enabled = false
		end

		return
	end

	if not arg.cham or arg.cham.Parent ~= parent then
		if arg.cham then
			arg.cham:Destroy()
		end

		local highlight = Instance.new("Highlight")
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.FillTransparency = 0.6
		highlight.Parent = parent
		arg.cham = highlight
	end

	arg.cham.Enabled = true
	local cham_ = arg.cham
	arg.cham.FillColor = fillColor
	cham_.OutlineColor = fillColor
end

paint = function(arg, arg2, arg3, arg4)
	local v5 = Esp.pool[arg]

	if not tbl4.esp then
		if v5 then
			hide(v5)
		end

		return
	end

	local v6 = kit(arg)
	local v7, v8, v9 = alive(arg)
	local magnitude = v7 and (v9.Position - arg2).Magnitude or math.huge
	if tbl4.espDist < magnitude then
		return hide(v6)
	end
	local v10 = tintOf(arg)
	cham(v6, v7, v10)
	local v11, v12 = currentCamera:WorldToViewportPoint(v9.Position + Vector3.new(0, 3, 0))
	local v13, v14 = currentCamera:WorldToViewportPoint(v9.Position - Vector3.new(0, 3.5, 0))
	local flag6 = v11.Z <= 0

	if not flag6 then
		flag6 = not (v12 or v14)
	end

	if flag6 then
		return blank(v6)
	end
	local n2 = math.max(v13.Y - v11.Y, 6)
	local n3 = n2 * 0.6
	local n4 = v11.X - n3 / 2
	local y = v11.Y
	local edge = v6.edge
	local box = tbl4.box
	v6.box.Visible = tbl4.box
	edge.Visible = box
	local box2 = v6.box
	local box3 = v6.box
	local box4 = v6.box
	local vector2 = Vector2.new(n3, n2)
	local vector22 = Vector2.new(n4, y)
	box2.Size = vector2
	box3.Position = vector22
	box4.Color = v10
	local edge2 = v6.edge
	local position3 = v6.box.Position
	v6.edge.Size = v6.box.Size
	edge2.Position = position3
	v6.name.Visible = tbl4.name
	v6.name.Text = arg == v2 and ("[ %* ]"):format(arg.DisplayName) or arg.DisplayName
	local name = v6.name
	v6.name.Position = Vector2.new(v11.X, y - 17)
	name.Color = v10
	v6.info.Visible = tbl4.info
	v6.info.Text = lore(arg, magnitude)
	v6.info.Position = Vector2.new(v11.X, y + n2 + 2)
	local n5 = math.clamp(v8.Health / math.max(v8.MaxHealth, 1), 0, 1)
	local v15 = Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(80, 230, 120), n5)
	local fill = v6.fill
	local bar = tbl4.bar
	v6.back.Visible = tbl4.bar
	fill.Visible = bar
	local back = v6.back
	local back2 = v6.back
	local vector23 = Vector2.new(n4 - 6, y - 1)
	local vector24 = Vector2.new(4, n2 + 2)
	back.Position = vector23
	back2.Size = vector24
	local fill2 = v6.fill
	local fill3 = v6.fill
	local fill4 = v6.fill
	local vector25 = Vector2.new(n4 - 5, y + n2 * (1 - n5))
	local vector26 = Vector2.new(2, n2 * n5)
	fill2.Position = vector25
	fill3.Size = vector26
	fill4.Color = v15
	v6.hp.Visible = tbl4.hpText
	v6.hp.Text = ("%*"):format(math.floor(v8.Health))
	local hp = v6.hp
	v6.hp.Position = Vector2.new(n4 - 10 - v6.hp.TextBounds.X, y + n2 * (1 - n5) - 6)
	hp.Color = v15
	v6.line.Visible = tbl4.tracer
	v6.line.From = tbl4.tracerFrom == "Center" and arg3 / 2 or tbl4.tracerFrom == "Mouse" and arg4 or Vector2.new(arg3.X / 2, arg3.Y)
	local line = v6.line
	v6.line.To = Vector2.new(v11.X, v13.Y)
	line.Color = v10
end

aimLine = function(arg, arg2, from)
	local tl = Esp.tl
	local mark = Esp.mark
	tl.Visible = false
	mark.Visible = false
	local flag6 = not v3

	if not flag6 then
		flag6 = not (tbl4.esp or tbl4.aimbot or tbl4.silent or tbl4.aura or v4)
	end

	if flag6 then
		return
	end
	local v5, v6 = currentCamera:WorldToViewportPoint(v3.Position)
	if not v6 then
		return
	end
	local vector2 = Vector2.new(v5.X, v5.Y)

	if tbl4.lineFrom == "Character" and arg then
		local v7 = currentCamera:WorldToViewportPoint(arg.Position)
		from = Vector2.new(v7.X, v7.Y)
	elseif tbl4.lineFrom == "Bottom" then
		from = Vector2.new(arg2.X / 2, arg2.Y)
	end

	local v7 = tbl5[tbl4.tgtColor]
	tl.Visible = tbl4.tgtLine
	tl.From = from
	tl.To = vector2
	tl.Color = v7
	local v8 = tbl5[tbl4.tgtColor]
	mark.Visible = tbl4.tgtMark
	mark.Position = vector2
	mark.Color = v8
end

Esp.step = function()
	if not flag5 then
		return
	end
	local viewportSize = currentCamera.ViewportSize
	local mouseLocation = UserInputService:GetMouseLocation()
	local v5, v6, v7 = alive(localPlayer)
	local position3 = v7 and v7.Position or currentCamera.CFrame.Position

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			paint(player, position3, viewportSize, mouseLocation)
		end
	end

	Esp.fov.Visible = tbl4.showFov and tbl4.useFov and (tbl4.aimbot or tbl4.silent)
	local fov = Esp.fov
	local fov2 = tbl4.fov
	Esp.fov.Position = mouseLocation
	fov.Radius = fov2
	aimLine(v7, viewportSize, mouseLocation)
end

Esp.clear = function()
	for k in pairs(Esp.pool) do
		drop(k)
	end

	for _, v5 in ipairs({ "fov", "tl", "mark" }) do
		if Esp[v5] then
			pcall(function()
				Esp[v5]:Destroy()
			end)
		end

		Esp[v5] = nil
	end
end

if flag5 then
	Esp.fov = draw("Circle", {
		Thickness = 1,
		NumSides = 64,
		Filled = false,
		Transparency = 0.7,
		Color = Color3.new(1, 1, 1),
		Visible = false,
	})

	Esp.tl = draw("Line", { Thickness = 2, Visible = false })
	Esp.mark = draw("Circle", { Thickness = 2, NumSides = 24, Radius = 8, Filled = false, Visible = false })
end

frame = function(arg)
	currentCamera = v.CurrentCamera
	local v5, v6, v7 = alive(localPlayer)
	position = v7 and v7.Position
	position2 = mouse.Hit.Position
	unit2 = position and (position2 - position).Unit
	local v8, v9 = pick()
	v2 = v8
	v3 = v9
	flag2 = false
	n = v3 and v3.Position + v3.AssemblyLinearVelocity * tbl4.pred
	unit = n and position and (n - position).Unit
	local silent = tbl4.silent

	if not silent then
		local aimUntil = Gun.aimUntil
		silent = os.clock() < aimUntil
	end

	flag2 = silent and flag3 and unit ~= nil

	if v2 ~= Move.lastTgt then
		local lastTgt = Move.lastTgt
		Move.lastTgt = v2
		local character = lastTgt and lastTgt.Character
		character = character and character:FindFirstChildOfClass("Humanoid")

		if tbl4.killNote and character and character.Health <= 0 and UI.note then
			UI.note(("Killed %*"):format(lastTgt.DisplayName), "good")
		end
	end

	if tbl4.aimbot and n and triggered() then
		local n2 = 1 - tbl4.smooth ^ (arg * 60)
		currentCamera.CFrame = currentCamera.CFrame:Lerp(CFrame.lookAt(currentCamera.CFrame.Position, n), n2)
	end

	local v10, v11 = alive(v2)

	if tbl4.spectate and v11 then
		if currentCamera.CameraSubject ~= v11 then
			currentCamera.CameraSubject = v11
		end

		flag4 = true
	elseif flag4 and v6 then
		currentCamera.CameraSubject = v6
		flag4 = false
	end

	Esp.step()
end

tgtText = function()
	if not v2 then
		return "No target"
	end
	local v5, v6, v7 = alive(v2)
	if not v5 then
		return (("%* dead"):format(v2.DisplayName))
	end
	local magnitude = position and (v7.Position - position).Magnitude or 0
	local concat = table.concat
	local tbl10 = {}
	local str = ("%* (@%*)%*"):format(v2.DisplayName, v2.Name, v4 == v2 and "  LOCKED" or "")
	local v8 = lore
	local str2 = ("HP %*/%*  |  %*"):format(math.floor(v6.Health), math.floor(v6.MaxHealth), v8(v2, magnitude))
	local str3 = ("Team %*"):format(v2.Team and v2.Team.Name or "None")
	tbl10[1] = str
	tbl10[2] = str2
	tbl10[3] = str3
	return concat(tbl10, "\n")
end

sweep = function()
	local tbl10 = { localPlayer:FindFirstChildOfClass("PlayerGui") }

	local ok, result = pcall(function()
		return gethui and gethui()
	end)

	if ok and typeof(result) == "Instance" then
		tbl10[#tbl10 + 1] = result
	end

	local ok2, result2 = pcall(function()
		return game:GetService("CoreGui")
	end)

	if ok2 and result2 then
		tbl10[#tbl10 + 1] = result2
	end

	for _, v5 in ipairs(tbl10) do
		pcall(function()
			for _, child in ipairs(v5:GetChildren()) do
				if child.Name == "KenHubUI" or child.Name == "KenHubUI_Old" then
					child:Destroy()
				end
			end
		end)
	end
end

buildUI = function()
	-- Ken Hub independent UI: no external UI library is loaded.
	sweep()

	local PlayersGui = localPlayer:WaitForChild("PlayerGui")
	local gui = Instance.new("ScreenGui")
	gui.Name = "KenHubUI"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PlayersGui

	local function make(className, props)
		local obj = Instance.new(className)
		for k, val in pairs(props or {}) do
			obj[k] = val
		end
		return obj
	end

	local main = make("Frame", {
		Name = "Main",
		Parent = gui,
		Size = UDim2.fromOffset(760, 520),
		Position = UDim2.new(0.5, -380, 0.5, -260),
		BackgroundColor3 = Color3.fromRGB(20, 20, 24),
		BorderSizePixel = 0,
	})
	make("UICorner", { Parent = main, CornerRadius = UDim.new(0, 10) })
	make("UIStroke", { Parent = main, Color = Color3.fromRGB(55, 55, 65), Thickness = 1 })

	local top = make("Frame", {
		Name = "TopBar",
		Parent = main,
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = Color3.fromRGB(27, 27, 33),
		BorderSizePixel = 0,
	})
	make("UICorner", { Parent = top, CornerRadius = UDim.new(0, 10) })

	local title = make("TextLabel", {
		Parent = top,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 5),
		Size = UDim2.new(1, -150, 0, 24),
		Font = Enum.Font.GothamBold,
		Text = "Ken Hub",
		TextColor3 = Color3.fromRGB(245, 245, 248),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local subtitle = make("TextLabel", {
		Parent = top,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(17, 27),
		Size = UDim2.new(1, -150, 0, 16),
		Font = Enum.Font.Gotham,
		Text = "Blox Fruits PvP  •  Build "..tbl.Build,
		TextColor3 = Color3.fromRGB(145, 145, 155),
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local minimizeButton = make("TextButton", {
		Parent = top,
		Size = UDim2.fromOffset(38, 30),
		Position = UDim2.new(1, -82, 0, 9),
		BackgroundColor3 = Color3.fromRGB(38, 38, 46),
		BorderSizePixel = 0,
		Text = "—",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(230, 230, 235),
	})
	make("UICorner", { Parent = minimizeButton, CornerRadius = UDim.new(0, 7) })

	local closeButton = make("TextButton", {
		Parent = top,
		Size = UDim2.fromOffset(38, 30),
		Position = UDim2.new(1, -40, 0, 9),
		BackgroundColor3 = Color3.fromRGB(38, 38, 46),
		BorderSizePixel = 0,
		Text = "×",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(235, 235, 240),
	})
	make("UICorner", { Parent = closeButton, CornerRadius = UDim.new(0, 7) })

	local body = make("Frame", {
		Name = "Body",
		Parent = main,
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(1, 0, 1, -48),
		BackgroundTransparency = 1,
	})

	local sidebar = make("Frame", {
		Parent = body,
		Size = UDim2.fromOffset(145, 1),
		BackgroundColor3 = Color3.fromRGB(24, 24, 29),
		BorderSizePixel = 0,
	})
	sidebar.Size = UDim2.new(0, 145, 1, 0)
	make("UIPadding", { Parent = sidebar, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
	local tabList = make("UIListLayout", { Parent = sidebar, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

	local content = make("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(145, 0),
		Size = UDim2.new(1, -145, 1, 0),
		BackgroundColor3 = Color3.fromRGB(18, 18, 22),
		BorderSizePixel = 0,
	})

	local tabs = {}
	local pages = {}
	local selectedTab

	local function createPage(tabName)
		local page = make("ScrollingFrame", {
			Name = tabName.."Page",
			Parent = content,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 5,
			ScrollBarImageColor3 = Color3.fromRGB(75, 75, 88),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
		})
		make("UIPadding", {
			Parent = page,
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 18),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
		})
		make("UIListLayout", { Parent = page, Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder })
		pages[tabName] = page
		return page
	end

	local function addTab(name)
		local button = make("TextButton", {
			Parent = sidebar,
			Size = UDim2.new(1, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(32, 32, 39),
			BorderSizePixel = 0,
			Text = "  "..name,
			Font = Enum.Font.GothamSemibold,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(185, 185, 195),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		make("UICorner", { Parent = button, CornerRadius = UDim.new(0, 7) })
		local page = createPage(name)
		local tab = { Button = button, Page = page }
		tabs[name] = tab
		button.MouseButton1Click:Connect(function()
			for _, t in pairs(tabs) do
				t.Page.Visible = false
				t.Button.BackgroundColor3 = Color3.fromRGB(32, 32, 39)
				t.Button.TextColor3 = Color3.fromRGB(185, 185, 195)
			end
			page.Visible = true
			button.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
			button.TextColor3 = Color3.fromRGB(245, 245, 248)
			selectedTab = name
		end)
		return page
	end

	local tabPages = {
		Combat = addTab("Combat"),
		["Kill Aura"] = addTab("Kill Aura"),
		Visuals = addTab("Visuals"),
		Player = addTab("Player"),
		Settings = addTab("Settings"),
	}

	local function section(page, name, icon)
		local box = make("Frame", {
			Parent = page,
			Size = UDim2.new(1, 0, 0, 48),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(25, 25, 31),
			BorderSizePixel = 0,
		})
		make("UICorner", { Parent = box, CornerRadius = UDim.new(0, 8) })
		make("UIStroke", { Parent = box, Color = Color3.fromRGB(45, 45, 54), Thickness = 1 })
		make("UIPadding", { Parent = box, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
		local head = make("TextLabel", {
			Parent = box,
			Size = UDim2.new(1, 0, 0, 25),
			BackgroundTransparency = 1,
			Text = name,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(240, 240, 245),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		local list = make("Frame", {
			Parent = box,
			Position = UDim2.fromOffset(0, 30),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		})
		make("UIListLayout", { Parent = list, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
		local obj = { Frame = list, Box = box }
		function obj:AddSection(n) return section(page, n) end
		return obj
	end

	local options = {}
	local function controlRow(parent, height)
		local row = make("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, height or 48),
			BackgroundColor3 = Color3.fromRGB(30, 30, 37),
			BorderSizePixel = 0,
		})
		make("UICorner", { Parent = row, CornerRadius = UDim.new(0, 6) })
		return row
	end

	local function labelPair(row, textValue, desc)
		local l = make("TextLabel", {
			Parent = row,
			Position = UDim2.fromOffset(10, 6),
			Size = UDim2.new(1, -150, 0, desc and 18 or 28),
			BackgroundTransparency = 1,
			Text = textValue,
			Font = Enum.Font.GothamSemibold,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(232, 232, 238),
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		if desc then
			local d = make("TextLabel", {
				Parent = row,
				Position = UDim2.fromOffset(10, 24),
				Size = UDim2.new(1, -150, 0, 18),
				BackgroundTransparency = 1,
				Text = desc,
				Font = Enum.Font.Gotham,
				TextSize = 9,
				TextColor3 = Color3.fromRGB(135, 135, 148),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})
		end
	end

	local function addToggle(sec, key, titleText, desc, icon, callback)
		local row = controlRow(sec.Frame, 48)
		labelPair(row, titleText, desc)
		local button = make("TextButton", {
			Parent = row,
			Position = UDim2.new(1, -68, 0.5, -12),
			Size = UDim2.fromOffset(56, 24),
			BackgroundColor3 = tbl4[key] and Color3.fromRGB(70, 145, 90) or Color3.fromRGB(55, 55, 65),
			BorderSizePixel = 0,
			Text = tbl4[key] and "ON" or "OFF",
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(245, 245, 245),
		})
		make("UICorner", { Parent = button, CornerRadius = UDim.new(1, 0) })
		local opt = {}
		function opt:SetValue(val)
			tbl4[key] = val
			button.Text = val and "ON" or "OFF"
			button.BackgroundColor3 = val and Color3.fromRGB(70, 145, 90) or Color3.fromRGB(55, 55, 65)
			if callback then callback(val) end
		end
		button.MouseButton1Click:Connect(function() opt:SetValue(not tbl4[key]) end)
		options[key] = opt
	end

	local function addSlider(sec, key, titleText, desc, icon, min, max, rounding)
		local row = controlRow(sec.Frame, 58)
		labelPair(row, titleText, desc)
		local box = make("TextBox", {
			Parent = row,
			Position = UDim2.new(1, -112, 0.5, -13),
			Size = UDim2.fromOffset(92, 26),
			BackgroundColor3 = Color3.fromRGB(40, 40, 48),
			BorderSizePixel = 0,
			Text = tostring(tbl4[key]),
			Font = Enum.Font.GothamSemibold,
			TextSize = 11,
			TextColor3 = Color3.fromRGB(235, 235, 240),
			ClearTextOnFocus = false,
		})
		make("UICorner", { Parent = box, CornerRadius = UDim.new(0, 5) })
		box.FocusLost:Connect(function()
			local n = tonumber(box.Text)
			if n then
				n = math.clamp(n, min, max)
				if rounding and rounding > 0 then
					local p = 10 ^ rounding
					n = math.floor(n * p + 0.5) / p
				end
				tbl4[key] = n
				box.Text = tostring(n)
			else
				box.Text = tostring(tbl4[key])
			end
		end)
	end

	local function addDropdown(sec, key, titleText, desc, icon, values)
		local row = controlRow(sec.Frame, 58)
		labelPair(row, titleText, desc)
		local button = make("TextButton", {
			Parent = row,
			Position = UDim2.new(1, -170, 0.5, -13),
			Size = UDim2.fromOffset(150, 26),
			BackgroundColor3 = Color3.fromRGB(40, 40, 48),
			BorderSizePixel = 0,
			Text = tostring(tbl4[key]),
			Font = Enum.Font.GothamSemibold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(235, 235, 240),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		make("UICorner", { Parent = button, CornerRadius = UDim.new(0, 5) })
		local index = 1
		for i, value in ipairs(values) do
			if value == tbl4[key] then index = i break end
		end
		button.MouseButton1Click:Connect(function()
			index = index % #values + 1
			tbl4[key] = values[index]
			button.Text = tostring(values[index])
		end)
	end

	local function addKeybind(sec, key, titleText, desc, icon)
		local row = controlRow(sec.Frame, 58)
		labelPair(row, titleText, desc)
		local button = make("TextButton", {
			Parent = row,
			Position = UDim2.new(1, -150, 0.5, -13),
			Size = UDim2.fromOffset(130, 26),
			BackgroundColor3 = Color3.fromRGB(40, 40, 48),
			BorderSizePixel = 0,
			Text = tostring(tbl4[key]),
			Font = Enum.Font.GothamSemibold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(235, 235, 240),
		})
		make("UICorner", { Parent = button, CornerRadius = UDim.new(0, 5) })
		local listening = false
		button.MouseButton1Click:Connect(function()
			listening = true
			button.Text = "Press key..."
		end)
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, processed)
			if listening and not processed and input.UserInputType == Enum.UserInputType.Keyboard then
				tbl4[key] = input.KeyCode.Name
				button.Text = input.KeyCode.Name
				listening = false
			end
		end)
		table.insert(tbl2, conn)
		options[key] = { SetValue = function(_, value) tbl4[key] = keyName(value); button.Text = tbl4[key] end }
	end

	local function addParagraph(sec, key, titleText, defaultText, icon)
		local row = controlRow(sec.Frame, 60)
		labelPair(row, titleText, defaultText)
		local value = make("TextLabel", {
			Parent = row,
			Position = UDim2.new(1, -145, 0, 8),
			Size = UDim2.fromOffset(130, 42),
			BackgroundTransparency = 1,
			Text = defaultText,
			Font = Enum.Font.Gotham,
			TextSize = 9,
			TextColor3 = Color3.fromRGB(155, 155, 165),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
		})
		tbl11[key] = { SetContent = function(_, text) value.Text = tostring(text) end }
	end

	local function addButton(sec, data)
		local row = controlRow(sec.Frame, 46)
		labelPair(row, data.Title or "Action", data.Description)
		local button = make("TextButton", {
			Parent = row,
			Position = UDim2.new(1, -112, 0.5, -13),
			Size = UDim2.fromOffset(100, 26),
			BackgroundColor3 = Color3.fromRGB(48, 48, 58),
			BorderSizePixel = 0,
			Text = data.Label or "Run",
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(235, 235, 240),
		})
		make("UICorner", { Parent = button, CornerRadius = UDim.new(0, 5) })
		button.MouseButton1Click:Connect(function()
			if data.Callback then data.Callback() end
		end)
	end

	local function sectionAdapter(page, name, icon)
		local sec = section(page, name, icon)
		function sec:AddToggle(key, data) addToggle(sec, key, data.Title or key, data.Description, data.Icon, data.Callback) end
		function sec:AddSlider(key, data) addSlider(sec, key, data.Title or key, data.Description, data.Icon, data.Min, data.Max, data.Rounding or 0) end
		function sec:AddDropdown(key, data) addDropdown(sec, key, data.Title or key, data.Description, data.Icon, data.Values or {}) end
		function sec:AddKeybind(key, data) addKeybind(sec, key, data.Title or key, data.Description, data.Icon) end
		function sec:AddParagraph(data) addParagraph(sec, data.Title or "Status", data.Title or "Status", data.Content or "...", data.Icon) end
		function sec:AddButton(data) addButton(sec, data) end
		return sec
	end

	local function pageAdapter(page)
		local obj = {}
		function obj:AddSection(name, icon) return sectionAdapter(page, name, icon) end
		return obj
	end

	-- Compatibility objects keep the existing feature-building code intact while
	-- rendering everything through the independent Ken Hub UI above.
	local tbl10 = {
		fight = pageAdapter(tabPages.Combat),
		aura = pageAdapter(tabPages["Kill Aura"]),
		eye = pageAdapter(tabPages.Visuals),
		body = pageAdapter(tabPages.Player),
		conf = pageAdapter(tabPages.Settings),
	}
	local tbl11, tbl12 = {}, {}

	local function note(message, kind)
		local color = kind == "warn" and Color3.fromRGB(235, 170, 75) or Color3.fromRGB(105, 200, 130)
		local toast = make("TextLabel", {
			Parent = gui,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -18, 0, 62),
			Size = UDim2.fromOffset(300, 44),
			BackgroundColor3 = Color3.fromRGB(30, 30, 37),
			BorderSizePixel = 0,
			Text = "  "..tbl.Name.."  •  "..tostring(message),
			Font = Enum.Font.GothamSemibold,
			TextSize = 11,
			TextColor3 = color,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		make("UICorner", { Parent = toast, CornerRadius = UDim.new(0, 7) })
		task.delay(4, function() pcall(function() toast:Destroy() end) end)
	end

	local function fn(sec, key, titleText, icon)
		tbl11[key] = { SetContent = function(_, text) end }
	end
	local function post(key, textValue)
		local item = tbl11[key]
		if item and item.SetContent then pcall(function() item:SetContent(textValue) end) end
	end
	local function mirror(key, value)
		local item = tbl12[key]
		if item and item.SetValue then pcall(function() item:SetValue(value) end) end
	end
	local function fn2(page, name, icon)
		return page:AddSection(name, icon)
	end
	local function fn3(sec, key, titleText, desc, icon, callback)
		addToggle(sec, key, titleText, desc, icon, callback)
		tbl12[key] = options[key]
	end
	local function fn4(sec, key, titleText, desc, icon, min, max, rounding)
		addSlider(sec, key, titleText, desc, icon, min, max, rounding)
	end
	local function fn5(sec, key, titleText, desc, icon, values)
		addDropdown(sec, key, titleText, desc, icon, values)
	end
	local function fn6(sec, key, titleText, desc, icon)
		addKeybind(sec, key, titleText, desc, icon)
	end

	-- Build the existing controls on the new independent UI.
	local targeting = fn2(tbl10.fight, "Targeting", "target")
	fn5(targeting, "pickMode", "Pick target by", "Target selection mode.", "list-filter", { "Smart", "Nearest cursor", "Nearest distance", "Lowest health" })
	fn4(targeting, "smartHp", "Smart: health vs distance", "Weight used by Smart target selection.", "scale", 0, 100, 0)
	fn3(targeting, "killNote", "Kill Notify", "Shows a notification when your target dies.", "skull")
	fn5(targeting, "part", "Aim part", "Preferred target body part.", "scan", { "Head", "HumanoidRootPart" })
	fn3(targeting, "useFov", "Limit To FOV", "Only pick players inside the cursor FOV.", "circle")
	fn4(targeting, "fov", "FOV radius", "Screen pixels.", "circle", 30, 600, 0)
	fn4(targeting, "maxDist", "Max distance", "Maximum target distance.", "ruler", 50, 5000, 0)
	fn4(targeting, "pred", "Prediction", "Projectile prediction time.", "trending-up", 0, 0.5, 2)
	fn3(targeting, "teamCheck", "Team Check", "Skip teammates.", "shield")
	fn3(targeting, "wallCheck", "Wall Check", "Skip targets behind walls.", "brick-wall")
	fn3(targeting, "skipFriends", "Ignore Friends", "Never pick Roblox friends.", "heart")
	fn6(targeting, "lockKey", "Lock target key", "Press to lock or unlock the current target.", "lock")
	fn(targeting, "target", "Current target", "user")

	local aimbot = fn2(tbl10.fight, "Aimbot", "crosshair")
	fn3(aimbot, "aimbot", "Aimbot", "Turns the camera toward the target.", "crosshair")
	fn5(aimbot, "aimTrigger", "Trigger", "When aimbot is allowed to run.", "mouse-pointer", { "Hold right mouse", "Hold key", "Always" })
	fn6(aimbot, "aimKey", "Aim key", "Key used when Trigger is Hold key.", "keyboard")
	fn4(aimbot, "smooth", "Smoothness", "Camera smoothing amount.", "wind", 0, 0.95, 2)

	local silentAim = fn2(tbl10.fight, "Silent Aim", "scan-eye")
	fn3(silentAim, "silent", "Silent Aim", "Redirects matching aim positions.", "scan-eye", function(arg)
		if not arg then return end
		local v6, v7 = hook()
		if v6 then return end
		tbl4.silent = false
		mirror("silent", false)
		note("Silent aim: "..tostring(v7), "warn")
	end)
	fn4(silentAim, "chance", "Hit chance", "Percent of shots redirected.", "percent", 1, 100, 0)

	local pvPMode = fn2(tbl10.fight, "PvP Mode", "flame")
	pvPMode:AddButton({
		Title = "PvP Mode",
		Description = "Enable the main PvP features together.",
		Label = "Enable",
		Callback = function()
			for k, val in pairs({
				pickMode = "Smart", silent = true, fly = true, flyMode = "Smart",
				autoSkill = true, noStun = true, antiAim = true, dodge = true,
				hitbox = true, buso = true, ken = true, esp = true, killNote = true,
			}) do
				tbl4[k] = val
				if options[k] and options[k].SetValue then pcall(function() options[k]:SetValue(val) end) end
			end
			note("PvP Mode on")
		end,
	})
	fn3(pvPMode, "autoSkill", "Auto Skills", "Automatically presses selected skill keys.", "flame", function(arg)
		if not arg then return end
		local v6, v7 = hook()
		if v6 then return end
		tbl4.autoSkill = false
		mirror("autoSkill", false)
		note("Auto skills: "..tostring(v7), "warn")
	end)
	local skillKeyRow = controlRow(pvPMode.Frame, 62)
	labelPair(skillKeyRow, "Skill keys", "Toggle the keys used by Auto Skills.")
	local skillButtons = {}
	local skillValues = { "Z", "X", "C", "V", "F" }
	for i, keyNameValue in ipairs(skillValues) do
		local b = make("TextButton", {
			Parent = skillKeyRow,
			Position = UDim2.new(1, -170 + ((i - 1) * 32), 0.5, -13),
			Size = UDim2.fromOffset(28, 26),
			BackgroundColor3 = tbl4.skillKeys[keyNameValue] and Color3.fromRGB(70, 145, 90) or Color3.fromRGB(40, 40, 48),
			BorderSizePixel = 0,
			Text = keyNameValue,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(235, 235, 240),
		})
		make("UICorner", { Parent = b, CornerRadius = UDim.new(0, 5) })
		skillButtons[keyNameValue] = b
		b.MouseButton1Click:Connect(function()
			tbl4.skillKeys[keyNameValue] = not tbl4.skillKeys[keyNameValue]
			b.BackgroundColor3 = tbl4.skillKeys[keyNameValue] and Color3.fromRGB(70, 145, 90) or Color3.fromRGB(40, 40, 48)
		end)
	end
	fn4(pvPMode, "skillRange", "Skill range", "Studs.", "ruler", 10, 300, 0)
	fn4(pvPMode, "skillHold", "Hold time", "Seconds.", "timer", 0.03, 2, 2)
	fn4(pvPMode, "skillGap", "Gap between skills", "Seconds.", "timer", 0.05, 2, 2)

	local hitbox = fn2(tbl10.fight, "Hitbox", "box")
	fn3(hitbox, "hitbox", "Hitbox Expander", "Expands enemy root parts.", "box")
	fn4(hitbox, "hitboxSize", "Hitbox size", "Studs.", "maximize", 4, 40, 0)
	fn3(hitbox, "hitboxShow", "Show Hitbox", "Show enlarged hitboxes.", "eye")

	local autoGun = fn2(tbl10.fight, "Auto Gun", "target")
	fn3(autoGun, "autoGun", "Auto Shoot", "Automatically fires at the target.", "flame", function(arg)
		if not arg then return end
		local v6, v7 = hook()
		if v6 then return end
		tbl4.autoGun = false
		mirror("autoGun", false)
		note("Auto gun: "..tostring(v7), "warn")
	end)
	fn5(autoGun, "gunPick", "Gun", "Gun selection.", "crosshair", { "Dragonstorm", "Any gun" })
	fn4(autoGun, "gunRange", "Fire range", "Studs.", "locate", 20, 400, 0)
	fn4(autoGun, "gunRate", "Fire delay", "Seconds.", "timer", 0.1, 2, 2)
	fn3(autoGun, "gunSkills", "Use Gun Skills", "Also presses gun skills.", "wand-2")
	fn3(autoGun, "gunBack", "Swap Back", "Re-equips the previous weapon.", "undo-2")
	fn(autoGun, "gun", "Auto Gun", "activity")

	local killAura = fn2(tbl10.aura, "Kill Aura", "swords")
	fn3(killAura, "aura", "Kill Aura", "Swings at players in range.", "swords")
	fn3(killAura, "auraAll", "Hit Everyone In Range", "Hit every target in range.", "users")
	fn4(killAura, "auraRange", "Range", "Studs.", "locate", 5, 100, 0)
	fn4(killAura, "auraRate", "Swing delay", "Seconds.", "timer", 0.05, 1, 2)
	fn5(killAura, "auraWeapon", "Weapon", "Weapon selection.", "hand", { "Keep current", "Melee", "Sword" })
	fn(killAura, "aura", "Kill Aura", "activity")
	local haki = fn2(tbl10.aura, "Haki & Race", "flame")
	fn3(haki, "buso", "Auto Buso Haki", "Keeps armament active.", "shield-plus")
	fn3(haki, "ken", "Auto Observation", "Uses observation periodically.", "eye")
	fn3(haki, "race", "Auto Race Ability", "Uses race ability periodically.", "flame")
	haki:AddButton({ Title = "Use race ability", Label = "Use", Callback = function()
		local okRace, msg = race()
		if not okRace then note("Race: "..tostring(msg), "warn") end
	end })

	local playerEsp = fn2(tbl10.eye, "Player ESP", "eye")
	if not flag5 then fn(playerEsp, "draw", "Drawing API", "triangle-alert") end
	fn3(playerEsp, "esp", "ESP", "Master ESP switch.", "eye")
	fn3(playerEsp, "box", "Box", "2D player boxes.", "square")
	fn3(playerEsp, "name", "Name", "Player names.", "user")
	fn3(playerEsp, "info", "Info", "Extra player information.", "info")
	fn3(playerEsp, "bar", "Health Bar", "Draw health bars.", "bar-chart")
	fn3(playerEsp, "hpText", "HP Text", "Show HP text.", "heart-pulse")
	fn3(playerEsp, "chams", "Chams", "Highlight players.", "layers")
	fn3(playerEsp, "tracer", "Tracer", "Draw target tracers.", "move")
	fn5(playerEsp, "tracerFrom", "Tracer origin", "Tracer start position.", "arrow-down", { "Bottom", "Center", "Mouse" })
	fn4(playerEsp, "espDist", "ESP distance", "Maximum distance.", "ruler", 100, 5000, 0)
	fn5(playerEsp, "espColor", "ESP color", "ESP color.", "palette", tbl6)
	fn3(playerEsp, "teamColor", "Team colors", "Use team colors when possible.", "users")
	fn3(playerEsp, "showFov", "Show FOV", "Draw the target FOV.", "circle")
	fn3(playerEsp, "tgtLine", "Target line", "Draw line to current target.", "move")
	fn5(playerEsp, "lineFrom", "Line origin", "Target line origin.", "arrow-up", { "Character", "Mouse" })
	fn3(playerEsp, "tgtMark", "Target marker", "Mark the current target.", "target")
	fn5(playerEsp, "tgtColor", "Target color", "Target marker color.", "palette", { "Red", "Green", "Blue", "Yellow", "Purple", "Cyan", "White" })

	local targetVisuals = fn2(tbl10.eye, "Target Visuals", "target")
	fn3(targetVisuals, "showFov", "Show FOV Circle", "Draw the target FOV while aiming.", "circle")
	fn3(targetVisuals, "tgtLine", "Target Line", "Draw a line to the current target.", "move")
	fn5(targetVisuals, "lineFrom", "Line origin", "Where the target line starts.", "move", { "Character", "Bottom", "Mouse" })
	fn3(targetVisuals, "tgtMark", "Target Marker", "Mark the current target.", "crosshair")
	fn5(targetVisuals, "tgtColor", "Target color", "Target marker and line color.", "palette", { "Red", "Green", "Blue", "Yellow", "Purple", "Cyan", "White" })

	local movement = fn2(tbl10.body, "Movement", "footprints")
	fn3(movement, "speed", "Walk Speed", "Holds your configured WalkSpeed while enabled.", "gauge")
	fn4(movement, "speedValue", "Speed", "Walk speed value.", "gauge", 16, 350, 0)
	fn3(movement, "jumpOn", "Jump Power", "Holds your configured jump value while enabled.", "arrow-up")
	fn4(movement, "jumpValue", "Jump", "JumpPower value.", "arrow-up", 50, 400, 0)
	fn3(movement, "noclip", "Noclip", "Walk through walls.", "ghost")
	fn3(movement, "infJump", "Infinite Jump", "Jump again in mid air.", "arrow-up-from-line")

	local survival = fn2(tbl10.body, "Survival", "heart-pulse")
	fn3(survival, "noStun", "No Stun", "Blocks common movement stuns and clears stun/busy values.", "shield-off")
	fn5(survival, "moverFilter", "Stun filter", "Choose how movement movers are handled.", "filter", { "Smart", "Remove all" })
	fn3(survival, "escape", "Escape At Low HP", "Jumps upward once when health falls below the limit.", "shield-alert")
	fn4(survival, "escapeHp", "HP limit", "Percent of max health.", "heart", 5, 80, 0)
	fn4(survival, "escapeUp", "Escape height", "Studs.", "arrow-up", 50, 1000, 0)

	local flyToTarget = fn2(tbl10.body, "Fly To Target", "plane")
	fn3(flyToTarget, "fly", "Fly To Target", "Flies to the current target.", "plane")
	fn6(flyToTarget, "flyKey", "Fly key", "Toggles Fly To Target.", "keyboard")
	fn5(flyToTarget, "flyMode", "Mode", "Smart, Kite, Predict or Orbit.", "compass", { "Smart", "Kite", "Predict", "Orbit" })
	fn4(flyToTarget, "engageDist", "Smart: attack distance", "Studs behind the target while attacking.", "swords", 3, 30, 0)
	fn4(flyToTarget, "engageEdge", "Smart: HP disadvantage allowed", "Allowed HP disadvantage while attacking.", "scale", 0, 50, 0)
	fn4(flyToTarget, "retreatHp", "Smart: retreat below HP", "Your HP percentage that switches to kiting.", "heart", 10, 80, 0)
	fn4(flyToTarget, "gankRange", "Smart: gank range", "Nearby enemy range used for gank avoidance.", "users", 20, 150, 0)
	fn4(flyToTarget, "kiteDist", "Kite distance", "Distance behind the target in Kite mode.", "ruler", 8, 80, 0)
	fn4(flyToTarget, "kiteSway", "Kite sway", "Side-to-side movement in Kite mode.", "move", 0, 20, 0)
	fn4(flyToTarget, "flySpeed", "Speed", "Studs per second.", "gauge", 50, 400, 0)
	fn4(flyToTarget, "flySafe", "Speed after pull back", "Temporary safe speed after a server pull-back.", "gauge", 50, 400, 0)
	fn4(flyToTarget, "flyDist", "Distance", "Distance from the target in Predict mode.", "ruler", 2, 20, 0)
	fn4(flyToTarget, "flyUp", "Height", "Studs above the target.", "arrow-up", 0, 30, 0)
	fn4(flyToTarget, "orbitRadius", "Orbit radius", "Studs.", "circle", 4, 40, 0)
	fn4(flyToTarget, "orbitSpeed", "Orbit speed", "Radians per second.", "rotate-cw", 0.5, 8, 1)
	fn3(flyToTarget, "flyNoclip", "Noclip While Flying", "Pass through walls while flying.", "ghost")
	fn(flyToTarget, "fly", "Fly", "activity")

	local defense = fn2(tbl10.body, "Defense", "shield")
	fn3(defense, "antiAim", "Anti Aim", "Applies fake movement velocity.", "shield")
	fn4(defense, "antiAimPower", "Anti aim strength", "Fake velocity strength.", "gauge", 50, 1000, 0)
	fn3(defense, "dodge", "Auto Dodge", "Side-step threats.", "move")
	fn4(defense, "dodgeRange", "Dodge range", "Studs.", "ruler", 8, 60, 0)
	fn4(defense, "dodgeDist", "Dodge distance", "Studs.", "move", 5, 40, 0)
	fn4(defense, "dodgeCd", "Dodge cooldown", "Seconds.", "timer", 0.3, 5, 1)

	local targetMovement = fn2(tbl10.body, "Target Movement", "move")
	fn3(targetMovement, "stick", "Stick To Target", "Stay behind and above the target.", "magnet")
	fn4(targetMovement, "stickUp", "Height", "Studs above target.", "arrow-up", 0, 80, 0)
	fn4(targetMovement, "stickBack", "Behind", "Studs behind target.", "arrow-left", 1, 15, 0)
	fn4(targetMovement, "stickRange", "Engage range", "Studs.", "locate", 20, 300, 0)
	fn3(targetMovement, "spectate", "Spectate Target", "Move camera to target.", "video")

	local misc = fn2(tbl10.conf, "Misc", "settings")
	fn3(misc, "antiAfk", "Anti AFK", "Disable the idle kick connection.", "coffee", function()
		local v7, v8 = antiAfk()
		if not v7 then note("Anti AFK: "..tostring(v8), "warn") end
	end)
	addKeybind(misc, "uiKey", "Toggle key", "Press a key to toggle the UI.", "keyboard")
	misc:AddButton({
		Title = "Unload",
		Description = "Stops loops, clears drawings and closes Ken Hub.",
		Label = "Unload",
		Callback = function()
			if genv.KenHubPvp then genv.KenHubPvp.Unload() end
		end,
	})

	-- Make the keybind actually toggle the independent UI.
	local uiListening = false
	local uiKeyButton = nil
	for _, descendant in ipairs(misc.Frame:GetDescendants()) do
		if descendant:IsA("TextButton") and descendant.Text == "RightControl" then
			uiKeyButton = descendant
			break
		end
	end
	if uiKeyButton then
		uiKeyButton.MouseButton1Click:Connect(function()
			uiListening = true
			uiKeyButton.Text = "Press key..."
		end)
	end
	table.insert(tbl2, UserInputService.InputBegan:Connect(function(input, processed)
		if uiListening and not processed and input.UserInputType == Enum.UserInputType.Keyboard then
			tbl4.uiKey = input.KeyCode.Name
			uiKeyButton.Text = tbl4.uiKey
			uiListening = false
		end
		if processed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == tbl4.uiKey then
			main.Visible = not main.Visible
		end
	end))

	-- Initial tab.
	tabs.Combat.Page.Visible = true
	tabs.Combat.Button.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
	tabs.Combat.Button.TextColor3 = Color3.fromRGB(245, 245, 248)
	selectedTab = "Combat"

	-- Dragging.
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging, dragStart, startPos = true, input.Position, main.Position
		end
	end)
	top.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	table.insert(tbl2, UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))

	local minimized = false
	minimizeButton.MouseButton1Click:Connect(function()
		minimized = not minimized
		body.Visible = not minimized
		main.Size = minimized and UDim2.fromOffset(760, 48) or UDim2.fromOffset(760, 520)
		minimizeButton.Text = minimized and "+" or "—"
	end)

	closeButton.MouseButton1Click:Connect(function()
		if genv.KenHubPvp then genv.KenHubPvp.Unload() end
	end)

	-- Public UI bridge used by the rest of the script.
	UI.Night = gui
	UI.Window = {
		Close = function()
			main.Visible = false
		end,
		SetKey = function(_, key)
			tbl4.uiKey = keyName(key)
		end,
	}
	UI.note = note
	UI.post = post
	UI.mirror = mirror

	return true
end

unload = function()
	flag = false
	flag2 = false

	pcall(function()
		RunService:UnbindFromRenderStep("KenHubAim")
	end)

	if flag4 then
		local v5, v6 = alive(localPlayer)

		if v6 then
			currentCamera.CameraSubject = v6
		end
	end

	for _, v5 in ipairs(tbl2) do
		pcall(function()
			v5:Disconnect()
		end)
	end

	table.clear(tbl2)
	local v5 = tbl4
	local v6 = tbl4
	local v7 = tbl4
	local v8 = tbl4
	local v9 = tbl4
	local v10 = tbl4
	local v11 = tbl4
	local v12 = tbl4
	tbl4.speed = false
	v5.jumpOn = false
	v6.noclip = false
	v7.autoGun = false
	v8.noStun = false
	v9.fly = false
	v10.hitbox = false
	v11.antiAim = false
	v12.dodge = false
	tbl4.autoSkill = false
	pcall(antiAimStep)
	pcall(hitboxes)
	pcall(movement)
	pcall(noclip)
	Move.on = false
	pcall(Esp.clear)

	pcall(function()
			UI.Window:Close()
	end)
	pcall(function()
			UI.Night:Destroy()
	end)

	genv.KenHubPvp = nil
end

local ok, result, result2 = pcall(buildUI)
genv.gethui = gethui_

if not ok or not result then
	local v5 = warn
	local str = ("! UI: %*"):format(ok and result2 or result)
	v5(str)
	Esp.clear()
	return
end

for _, player in ipairs(Players:GetPlayers()) do
	befriend(player)
end

bind(Players.PlayerAdded:Connect(befriend))

bind(Players.PlayerRemoving:Connect(function(player)
	drop(player)
	tbl3[player.UserId] = nil

	if v4 == player then
		v4 = nil
	end
end))

bind(UserInputService.InputBegan:Connect(function(input)
	if UserInputService:GetFocusedTextBox() or input.KeyCode.Name ~= tbl4.lockKey then
		return
	end

	if v4 then
		v4 = nil
		UI.note("Target unlocked")
		return
	end

	if not v2 then
		return UI.note("No target", "warn")
	end
	v4 = v2
	local note = UI.note
	local str = ("Locked %*"):format(v2.DisplayName)
	note(str)
end))

bind(UserInputService.InputBegan:Connect(function(input)
	if UserInputService:GetFocusedTextBox() or tbl4.flyKey == "None" or input.KeyCode.Name ~= tbl4.flyKey then
		return
	end
	tbl4.fly = not tbl4.fly
	UI.mirror("fly", tbl4.fly)
	UI.note(tbl4.fly and "Fly on" or "Fly off")
end))

bind(UserInputService.JumpRequest:Connect(function()
	if not tbl4.infJump then
		return
	end
	local v5, v6 = alive(localPlayer)

	if v6 then
		v6:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))

bind(RunService.Heartbeat:Connect(stick))

bind(RunService.Heartbeat:Connect(function()
	pcall(movement)
end))

bind(RunService.Stepped:Connect(function()
	pcall(antiAimStep)

	if tbl4.noclip or tbl4.fly or next(Move.clip) then
		pcall(noclip)
	end
end))

bind(RunService.Heartbeat:Connect(function(deltaTime)
	pcall(fly, deltaTime)
	pcall(sweepMovers)
	pcall(antiAimBeat)
end))

watchMovers(localPlayer.Character)
bind(localPlayer.CharacterAdded:Connect(watchMovers))
spin("Hitbox", 0.3, hitboxes)
spin("Dodge", 0.05, dodge)
spin("Crowd", 0.25, crowd)

spin("Skills", 0.1, function()
	if tbl4.autoSkill then
		return skills()
	end
end)

spin("Gun", function()
	return tbl4.autoGun and tbl4.gunRate or 0.3
end, function()
	if not tbl4.autoGun then
		Gun.note = "Off"
		return
	end
	local v5
	v5, v5 = shoot()
	Gun.note = v5
end)

spin("Escape", 0.1, escape)
RunService:BindToRenderStep("KenHubAim", Enum.RenderPriority.Camera.Value + 1, frame)

spin("Aura", function()
	return tbl4.aura and tbl4.auraRate or 0.3
end, function()
	if not tbl4.aura then
		Aura.note = "Off"
		return
	end
	local v5
	v5, v5 = swing()
	Aura.note = v5
end)

spin("Buso", 2, function()
	if tbl4.buso then
		return buso()
	end
end)

spin("Ken", 10, function()
	if tbl4.ken then
		return ken()
	end
end)

spin("Race", 5, function()
	if tbl4.race then
		return race()
	end
end)

spin("Panels", 0.5, function()
	UI.post("target", tgtText())
	local post = UI.post
	local str = ("Swings %*  |  %*"):format(Aura.swings, Aura.note)
	post("aura", str)
	local post2 = UI.post
	local str2 = ("Shots %*  |  %*"):format(Gun.shots, Gun.note)
	post2("gun", str2)
	UI.post("fly", Fly.note)
end)

if tbl4.antiAfk then
	antiAfk()
end

genv.KenHubPvp = { Hub = tbl, State = tbl4, Aura = Aura, Esp = Esp, Unload = unload }
local note = UI.note
local str = ("Ready - %* build %*"):format(tbl.Game, tbl.Build)
note(str)
