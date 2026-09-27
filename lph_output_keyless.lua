-- Keyless build: licensing/authentication UI and remote license checks removed.
local v = {
    Finished = true,
    Valid = true,
    Details = {
        subscriptionTier = "Keyless",
        expiresAt = nil,
        serverTime = nil,
    },
}


if type(v) ~= "table" then
	return
end

while not v.Finished do
	task.wait(0.05)
end

if not v.Valid then
	return
end

print("Auth Success! Waiting load script...")

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Night Hub", Text = "Auth Success! Waiting load script...", Duration = 5 })
end)

while not game:IsLoaded() do
end

local obj = setmetatable({}, { __index = function(arg, arg2)
	return game:GetService(arg2)
end })

local v2 = (getgenv or getrenv or getfenv)() or _G

local tbl = {
	["Enable Fast Attack"] = true,
	["Accept Quests"] = true,
	["Select Tool"] = "Melee",
	["Select Mode Farm"] = "Level",
	["Select Mastery"] = "Blox Fruit",
	["Health %"] = 25,
	["Tween Speed"] = 180,
	["Bring Amount"] = 4,
	["Spin Radius"] = 25,
	["Spin Speed"] = 4,
	["Select Team"] = "Pirates",
	["Select Chest Count"] = "30",
	["Stop If Legendary Item"] = true,
	["Safe Tween"] = true,
}

local tbl2 = {}
local tbl3 = {}
local tbl4 = {}
local tbl5 = {}
local tbl6 = {}
local tbl7 = {}
local tbl8 = {}
local tbl9 = {}
local tbl10 = {}
local tbl11 = {}
local tbl12 = {}
local tbl13 = {}
local workspace = obj.Workspace
local replicatedStorage = obj.ReplicatedStorage
local players = obj.Players
local collectionService = obj.CollectionService
local httpService = obj.HttpService
local lighting = obj.Lighting
local virtualUser = obj.VirtualUser
local virtualInputManager = obj.VirtualInputManager
local localPlayer = players and players.LocalPlayer

for i = 1, 30 do
	if not localPlayer.Team then
		pcall(function()
			replicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", tbl["Select Team"])
		end)

		task.wait(2)
		continue
	end

	break
end

local worldOrigin = workspace:WaitForChild("_WorldOrigin")
local enemies = workspace:WaitForChild("Enemies")
local characters = workspace:WaitForChild("Characters")
local level = localPlayer:WaitForChild("Data"):WaitForChild("Level")
local playerGui = localPlayer:WaitForChild("PlayerGui")
local remotes = replicatedStorage:WaitForChild("Remotes")
local commF = remotes:WaitForChild("CommF_")
local commE = remotes:WaitForChild("CommE")
local modules = replicatedStorage:WaitForChild("Modules")
local net = modules:WaitForChild("Net")
local reRegisterHit = net:WaitForChild("RE/RegisterHit")
local reRegisterAttack = net:WaitForChild("RE/RegisterAttack")

local function fn2(arg, ...)
	for _, value7 in pairs({ ... }) do
		arg = arg and arg:FindFirstChild(value7)
	end

	if not arg then
		return nil
	end
	local ok, result = pcall(require, arg)
	return ok and typeof(result) == "table" and result or nil
end

local guideModule = fn2(replicatedStorage, "GuideModule")
local quests = fn2(replicatedStorage, "Quests")
local itemReplicationService = fn2(replicatedStorage, "ItemReplicationService")
local itemReplicationService2 = fn2(replicatedStorage, "ItemReplicationService", "KEYS")
local itemConfig = fn2(replicatedStorage, "ItemConfig")
local enemySpawns = worldOrigin:FindFirstChild("EnemySpawns")
local tbl14 = { "BartiloQuest", "Trainees", "MarineQuest", "CitizenQuest" }
local tbl15 = { "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker" }
local tbl16 = { "Cocoa Warrior", "Chocolate Bar Battler" }

local function fn3(...)
	print("[LOG]:", ...)
end

local function fn4(...)
	local v3 = print
	local packed = table.pack(...)
	v3("[DEBUG]:", table.unpack(packed, 1, packed.n))
end
--[=[ 𝖲𝗈𝗎𝗋𝖼𝖾 𝖫𝖾𝖺𝗄 (𝖲𝖫) ]=] -- discord.gg/x7YbZeezpm

local function fn5(arg)
	if not arg or typeof(arg) ~= "string" then
		return nil, "Invaild file!"
	end

	if not isfile or not isfile(arg) then
		return nil, arg .. " not found in workspace!"
	end

	local ok, result = pcall(function()
		return loadstring(readfile(arg), arg)()
	end)

	if not ok then
		return nil, tostring(result)
	end
	return result
end

tbl11.Fire = function(...)
	return commF:InvokeServer(...)
end

tbl10.GetCharacter = function()
	if not localPlayer or not localPlayer.Character then
		return nil, "Player Dead or Unknown Error!"
	end
	return localPlayer.Character, ""
end

tbl10.GetH = function(arg)
	local tbl17 = { "Humanoid", "HumanoidRootPart" }
	local v3, v4 = tbl10.GetCharacter()
	if not v3 then
		return false, v4
	end
	return v3 and v3:FindFirstChild(tbl17[arg])
end

tbl10.ScanPlayer = function()
	local list = {}
	local v3 = next
	local children, v4 = localPlayer.Backpack:GetChildren()

	for _, value8 in v3, children, v4 do
		list[#list + 1] = value8
	end

	local v5 = next
	local children2, v6 = localPlayer.Character:GetChildren()

	for _, value9 in v5, children2, v6 do
		list[#list + 1] = value9
	end

	return list
end

tbl10.GetToolByToolTip = function(arg)
	local v3 = tbl10.ScanPlayer()

	for _, value10 in pairs(v3) do
		if value10:IsA("Tool") and value10.ToolTip == arg then
			return value10
		end
	end

	return nil, "Not found!"
end

tbl10.CheckTool = function(arg)
	local v3 = tbl10.ScanPlayer()

	for _, value11 in pairs(v3) do
		if value11:IsA("Tool") and value11.Name == arg or string.find(value11.Name, arg) then
			return value11
		end
	end

	return nil, "Not found!"
end

tbl10.EquipToolName = function(arg)
	local v3, v4 = tbl10.GetH(1)
	if not v3 then
		return nil, v4
	end
	local v5 = next
	local children, v6 = localPlayer.Backpack:GetChildren()

	for _, value12 in v5, children, v6 do
		if value12 and value12:IsA("Tool") and value12.Name == arg then
			v3:EquipTool(value12)
			return true, ""
		end
	end

	return nil, "Unknown Error"
end

tbl10.EquipWeapon = function(arg)
	if not arg or arg == "" then
		return nil, "No weapon type"
	end
	local v3 = tbl10.GetCharacter()
	local v4 = tbl10.GetH(1)
	if not v3 or not v4 then
		return nil, "No Character found!"
	end

	for _, child in pairs(v3:GetChildren()) do
		if child:IsA("Tool") and child.ToolTip == arg then
			return child
		end
	end

	for _, child in pairs(localPlayer.Backpack:GetChildren()) do
		if child:IsA("Tool") and child.ToolTip == arg then
			v4:EquipTool(child)
			return child
		end
	end

	return nil, "Not found!"
end

tbl10.BusoAt = 0

tbl10.BatBuso = function()
	local busoAt = tbl10.BusoAt
	if tick() - busoAt < 1 then
		return
	end
	tbl10.BusoAt = tick()
	local v3 = tbl10.GetCharacter()
	if not v3 then
		return false, "No Character found!"
	end
	-- SOURCE LEAK (SL) // discord.gg/x7YbZeezpm

	if v3:FindFirstChild("HasBuso") then
		return true, ""
	end
	tbl11.Fire("Buso")
end

tbl10.HasItem = function(arg)
	local character = localPlayer.Character
	return localPlayer.Backpack:FindFirstChild(arg) or character and character:FindFirstChild(arg)
end

tbl10.ItemNames = {}

tbl10.GetItemName = function(arg)
	if tbl10.ItemNames[arg] then
		return tbl10.ItemNames[arg]
	end

	local ok, result = pcall(function()
		return itemConfig.match(arg):unwrap().Index.DebugLabel
	end)

	if not ok or not result then
		return
	end
	tbl10.ItemNames[arg] = result
	return result
end

tbl10.GetMaterial = function(arg)
	if not itemReplicationService or not itemReplicationService2 or not itemConfig then
		return 0
	end

	if itemReplicationService.IsInitialized ~= true then
		return 0
	end
	local v3 = pairs
	local items = itemReplicationService:GetItems(itemReplicationService2.QUANTITY) or {}

	for _, item in v3(items) do
		local v4 = tbl10.GetItemName(item.ItemId)
		if v4 and v4:find(arg, 1, true) then
			return item.Value
		end
	end

	return 0
end

tbl10.TurnOnV4 = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	local raceEnergy = character:FindFirstChild("RaceEnergy")
	if not raceEnergy or raceEnergy.Value < 1 then
		return
	end
	local raceTransformed = character:FindFirstChild("RaceTransformed")
	if not raceTransformed or raceTransformed.Value then
		return
	end
	local awakening = localPlayer.Backpack:FindFirstChild("Awakening") or character:FindFirstChild("Awakening")
	awakening = awakening and awakening:FindFirstChild("RemoteFunction")
	if not awakening then
		return
	end
	awakening:InvokeServer(true)
end

tbl10.TurnOnV3 = function()
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	commE:FireServer("ActivateAbility")
end

tbl9.ReadyToTween = function()
	local v3, v4 = tbl10.GetCharacter()
	if not v3 then
		return false, v4
	end
	local v5 = tbl10.GetH(1)
	if not v5 or v5.Health <= 0 then
		return false, "No Humanoid or Player dead!"
	end
	local v6, v7 = tbl10.GetH(2)
	if not v6 then
		return false, v7
	end
	return true
end

tbl9.AllToCFrame = function(obj)
	if typeof(obj) == "Vector3" then
		return CFrame.new(obj)
	end

	if typeof(obj) == "Instance" then
		if obj:IsA("Model") then
			return obj:GetPivot()
		end

		if obj:IsA("Part") then
			return obj.CFrame
		end
	end

	return obj
end

tbl9.Distance = function(arg, part, arg3)
	if not arg then
		return
	end
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local v4 = tbl9.AllToCFrame(arg)
	part = part and tbl9.AllToCFrame(part) or v3.CFrame
	return (Vector3.new(v4.Position.X, arg3 and 0 or v4.Position.Y, v4.Position.Z) - Vector3.new(part.Position.X, arg3 and 0 or part.Position.Y, part.Position.Z)).Magnitude
end

tbl9.Velocity = function(arg)
	local v3 = tbl10.GetCharacter()
	if not v3 then
		return
	end
	local head = v3:FindFirstChild("Head") or v3:FindFirstChild("HumanoidRootPart")
	if not head then
		return
	end

	if not arg then
		for _, descendant in pairs(v3:GetDescendants()) do
			if descendant:IsA("BodyVelocity") and descendant.Name == "BodyVelocity" then
				descendant:Destroy()
			end
		end

		return
	end

	if head:FindFirstChild("BodyVelocity") then
		return
	end
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Name = "BodyVelocity"
	bodyVelocity.P = 15000
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = head
end
-- 𝖲𝗈𝗎𝗋𝖼𝖾 𝖫𝖾𝖺𝗄 (𝖲𝖫) // discord.gg/x7YbZeezpm

tbl10.NoClipParts = {}

tbl10.NoClip = function(arg)
	if arg then
		local v3 = tbl10.GetCharacter()
		if not v3 then
			return
		end

		for _, child in pairs(v3:GetChildren()) do
			local isBasePart = child:IsA("BasePart") and child or child:FindFirstChild("Handle")

			if isBasePart and isBasePart:IsA("BasePart") and isBasePart.CanCollide then
				tbl10.NoClipParts[isBasePart] = true
				isBasePart.CanCollide = false
			end
		end

		return
	end

	for k in pairs(tbl10.NoClipParts) do
		if k.Parent then
			k.CanCollide = true
		end
	end

	tbl10.NoClipParts = {}
end

tbl10.FpsBoost = function()
	pcall(function()
		workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
		workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
		workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
		lighting.GlobalShadows = false
		lighting.FogEnd = 9e9
		local terrain = workspace:FindFirstChildOfClass("Terrain")

		if terrain then
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
		end

		settings().Rendering.QualityLevel = "Level01"
	end)

	for _, child in pairs(lighting:GetChildren()) do
		if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
			pcall(function()
				child.Enabled = false
			end)
		end
	end

	for _, descendant in pairs(workspace:GetDescendants()) do
		pcall(function()
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
				descendant.Lifetime = NumberRange.new(0)
			elseif descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") or descendant:IsA("SpotLight") or descendant:IsA("PointLight") or descendant:IsA("SurfaceLight") then
				descendant.Enabled = false
			elseif descendant:IsA("Explosion") then
				descendant.BlastPressure = 0
				descendant.BlastRadius = 0
			end
		end)
	end
end

tbl9.StopTween = function()
	if not tbl9.Runtime then
		return
	end
	tbl9.Runtime.IsTweening = false
	tbl9.Runtime.LastTweenId = -1
	tbl9.Runtime.LastPos = nil
end

tbl9.SafeStep = function(obj, part2, part3, arg4, arg5)
	local flag = not tbl["Safe Tween"]

	if not flag then
		local segment = arg5.Segment
		flag = tick() - segment <= 3
	end

	if flag then
		return
	end
	task.wait(0.5 + math.random() * 0.2)
	arg5.Segment = tick()
	arg5.Pauses = arg5.Pauses + 1
	if arg5.Pauses < 3 and (part2.Position - arg5.LastPosition).Magnitude <= 500 then
		return
	end
	arg5.Restarts = arg5.Restarts + 1
	if arg5.Restarts >= 3 then
		return true
	end
	task.wait(0.3)
	obj.LastTargetCFrame = part2.CFrame
	obj.StartTime = tick()
	arg5.DeltaPos = part3.Position - part2.Position
	arg5.TotalD = arg5.DeltaPos.Magnitude / arg4
	arg5.Segment = tick()
	arg5.Pauses = 0
end

tbl9.Tween = function(j,w,g,m)if  tbl9 .ReadyToTween()then if not  tbl9 .Runtime then  tbl9 .Runtime={LastPos=nil,TweenId=0,LastTweenId=0,IsTweening=false,Target=nil,LastTargetCFrame=nil,Process=0,StartTime=tick()};end;local m= tbl9 .AllToCFrame(j);if not m or typeof(m)~="CFrame"then return false,"No Tween Target or Target Tween is not CFrame";end;if  tbl9 .Runtime.LastPos and(m.Position- tbl9 .Runtime.LastPos.Position).Magnitude<=1 then return false,"Same Target Tween";end;local j= tbl10 .GetH(2);if not j then return;end;local Z=g or j; tbl9 .Runtime.LastPos=m; tbl9 .Runtime.TweenId= tbl9 .Runtime.TweenId+1; tbl9 .Runtime.LastTweenId= tbl9 .Runtime.TweenId; tbl9 .Runtime.Target=Z or j; tbl9 .Runtime.LastTargetCFrame= tbl9 .Runtime.Target.CFrame; tbl9 .Runtime.StartTime=tick(); tbl9 .Runtime.IsTweening=true;local g= tbl9 .Runtime.Target;Z,j=w or  tbl ["Tween Speed"],{DeltaPos=m.Position-g.Position,Segment=tick(),Pauses=0,Restarts=0,LastPosition=g.Position};j.TotalD=j.DeltaPos.Magnitude/Z;local function w()g.AssemblyLinearVelocity=g.AssemblyLinearVelocity+Vector3.new(math.random(-10,10),math.random(-100,12),math.random(-10,10));end;while  tbl9 .Runtime.IsTweening and  tbl9 .Runtime.TweenId== tbl9 .Runtime.LastTweenId and( tbl9 .ReadyToTween())and(m.Position-g.Position).Magnitude>=10 do if math.abs(g.Position.Y-m.Position.Y)>50 then g.CFrame=CFrame.new(g.Position.X,m.Position.Y,g.Position.Z);end;local l=math.clamp((tick()- tbl9 .Runtime.StartTime)/j.TotalD,0,1);local V= tbl9 .Runtime.LastTargetCFrame.Position+j.DeltaPos*l;g.CFrame=CFrame.new(V);pcall(w);j.LastPosition=V;if  tbl9 .SafeStep( tbl9 .Runtime,g,m,Z,j)then break;end;task.wait();end; tbl9 .Runtime.LastTweenId=-1; tbl9 .Runtime.LastPos=nil;if  tbl9 .Distance(m, tbl9 .Runtime.Target,true)<=50 then  tbl9 .Runtime.Target.CFrame=m;end;return true,"";end;return false,"Not ready to tween";end

tbl8.Alive = function(obj)
	return obj.Parent and obj:FindFirstChild("Humanoid") and not obj:FindFirstChild("VehicleSeat") and obj.Humanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart")
end

tbl8.StripLevel = function(arg)
	return (tostring(arg):gsub(" %p?Lv%.? ?%d+%p?", ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

tbl8.MobKeys = {}

tbl8.MobKey = function(arg)
	local v3 = tbl8.MobKeys[arg]
	if v3 then
		return v3
	end
	local str = tbl8.StripLevel(arg):lower()
	tbl8.MobKeys[arg] = str
	return str
end

tbl8.SameMob = function(arg, arg2)
	return tbl8.MobKey(arg) == tbl8.MobKey(arg2)
end

tbl8.Match = function(arg, arg2)
	for _, value13 in pairs(arg2) do
		if tbl8.SameMob(arg, value13) then
			return true
		end
	end

	return false
end

tbl8.GetBoss = function(arg)
	local tbl17 = typeof(arg) == "string" and { arg } or arg

	for _, value14 in pairs(tbl17) do
		local v4 = enemies:FindFirstChild(value14) or replicatedStorage:FindFirstChild(value14)
		if v4 and v4:IsA("Model") and tbl8.Alive(v4) then
			return v4
		end
	end

	for _, getEnemy in pairs(tbl8.GetEnemies()) do
		if tbl8.Match(getEnemy.Name, tbl17) and tbl8.Alive(getEnemy) then
			return getEnemy
		end
	end
end

tbl8.GetSpawnPart = function(arg)
	if not enemySpawns then
		return
	end

	for _, child in pairs(enemySpawns:GetChildren()) do
		if child:IsA("BasePart") and tbl8.SameMob(child.Name, arg) and not child:FindFirstChild("Ignored") then
			return child
		end
	end
end

tbl8.GetLevelQuest = function()
	local npcList = guideModule and guideModule.Data and guideModule.Data.NPCList
	if not npcList or not quests then
		return
	end

	for _, value15 in pairs(npcList) do
		local internalQuestName = value15.InternalQuestName

		if internalQuestName and quests[internalQuestName] and not table.find(tbl14, internalQuestName) then
			for k in pairs(value15.Levels) do
				local task_ = quests[internalQuestName][k] and quests[internalQuestName][k].Task

				if task_ then
					next(task_)
				end
			end
		end
	end

	return nil
end

tbl8.EnemyAt = 0
tbl8.EnemyCache = {}

tbl8.GetEnemies = function()
	local enemyAt = tbl8.EnemyAt
	if tick() - enemyAt < 0.1 then
		return tbl8.EnemyCache
	end
	tbl8.EnemyAt = tick()
	tbl8.EnemyCache = enemies:GetChildren()
	return tbl8.EnemyCache
end

tbl8.GetMobs = function(arg, arg2)
	local tbl17 = typeof(arg) == "string" and { arg } or arg
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local position = v3.Position
	local huge = math.huge
	local value16 = nil

	for _, getEnemy2 in pairs(tbl8.GetEnemies()) do
		if tbl8.Match(getEnemy2.Name, tbl17) and tbl8.Alive(getEnemy2) then
			local magnitude = (getEnemy2.HumanoidRootPart.Position - position).Magnitude

			if magnitude <= huge and (not arg2 or magnitude <= arg2) then
				huge = magnitude
				value16 = getEnemy2
			end
		end
	end

	return value16
end

tbl8.BringPosCache = {}

tbl8.GetMidBringPos = function(arg)
	local v3 = tbl8.MobKey(arg)
	if tbl8.BringPosCache[v3] then
		return tbl8.BringPosCache[v3]
	end
	local fortBuilderReplicatedSpawnPositi = replicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
	if not fortBuilderReplicatedSpawnPositi then
		return
	end
	local n = 0
	local vector = Vector3.zero

	for _, child in pairs(fortBuilderReplicatedSpawnPositi:GetChildren()) do
		if tbl8.SameMob(child.Name, arg) then
			n += 1
			vector += child.Position
		end
	end

	if n == 0 then
		return
	end
	tbl8.BringPosCache[v3] = vector / n
	return vector / n
end

tbl8.WaitMob = function(arg, arg2)
	local tbl17 = typeof(arg) == "string" and { arg } or arg
	local fortBuilderReplicatedSpawnPositi = replicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
	if not fortBuilderReplicatedSpawnPositi then
		return
	end

	for _, child in pairs(fortBuilderReplicatedSpawnPositi:GetChildren()) do
		if child and tbl8.Match(child.Name, tbl17) then
			if not (tbl8.GetMobs(tbl17) or not tbl[arg2]) then
				while true do
					wait()
					tbl9.Tween(child.CFrame * CFrame.new(0, 25, 0))
					if not (tbl8.GetMobs(tbl17) or not tbl[arg2] or tbl9.Distance(child) <= 30) then
						continue
					end
					break
				end

				continue
			end
		else
			continue
		end

		break
	end
end

tbl8.IsNearPlayers = function(arg)
	for _, child in pairs(characters:GetChildren()) do
		if child ~= localPlayer.Character and tbl8.Alive(child) and tbl9.Distance(child.HumanoidRootPart) <= arg then
			return true
		end
	end

	return false
end

tbl8.MobTweens = setmetatable({}, { __mode = "k" })
tbl8.BringSpeed = 250

tbl8.TweenMob = function(part4, part5)
	local v3 = tbl8.MobTweens[part4]

	if v3 then
		pcall(v3.Cancel, v3)
	end

	local tween = obj.TweenService:Create(part4, TweenInfo.new((part5.Position - part4.Position).Magnitude / tbl8.BringSpeed, Enum.EasingStyle.Linear), { CFrame = part5 })
	tbl8.MobTweens[part4] = tween
	tween:Play()
end

tbl8.BringMobs = function(obj)
	if not obj then
		return
	end

	if not tbl8.Alive(obj) then
		return
	end

	if sethiddenproperty then
		pcall(sethiddenproperty, localPlayer, "SimulationRadius", 5000)
	end

	local position = tbl8.GetMidBringPos(obj.Name) or obj.HumanoidRootPart.Position
	local n = math.clamp(tonumber(tbl["Bring Amount"]) or 4, 2, 10)
	local v3 = tbl8.GetEnemies()
	local n2 = 0

	for i = 1, #v3 do
		local entry = v3[i]

		if not (n <= n2) then
			if entry.Name == obj.Name and tbl8.Alive(entry) then
				n2 += 1
				local humanoidRootPart = entry.HumanoidRootPart

				if not humanoidRootPart:FindFirstChild("Lock") then
					local humanoid = entry:FindFirstChild("Humanoid")

					if humanoid then
						humanoid.WalkSpeed = 0
						humanoid.JumpPower = 0
						local animator = humanoid:FindFirstChildOfClass("Animator")

						if animator then
							animator:Destroy()
						end
					end

					for _, child in pairs(entry:GetChildren()) do
						if child:IsA("BasePart") then
							child.CanCollide = false
						end
					end

					local bodyVelocity = Instance.new("BodyVelocity")
					bodyVelocity.Name = "Lock"
					bodyVelocity.P = 15000
					bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
					bodyVelocity.Velocity = Vector3.zero
					bodyVelocity.Parent = humanoidRootPart
				end

				local v5 = tbl9.Distance(humanoidRootPart, position, true)
				local flag = not isnetworkowner or isnetworkowner(humanoidRootPart)

				if (v5 >= 1 or tbl8.IsNearPlayers(250)) and v5 <= 300 and flag then
					local cframe = CFrame.new(0, 0, 0)

					if tbl["Random Bring Pos When Detect Near Players"] then
						local random = math.random
						local cframe2 = CFrame.Angles
						cframe = CFrame.new(math.random(-45, 45), math.random(-25, 25), random(-45, 45)) * cframe2(0, math.rad(math.random(0, 360)), 0)
					end

					tbl8.TweenMob(humanoidRootPart, CFrame.new(position) * cframe)
				end
			end

			continue
		end

		break
	end
end

tbl4.Toggle = "Auto Farm All Sword to 600 Mastery"
tbl4.Masteries = {}
tbl4.MasteryAt = 0
tbl4.Owned = {}
tbl4.OwnedAt = 0
tbl4.LoadAt = 0

tbl4.RefreshMasteries = function()
	local masteryAt = tbl4.MasteryAt
	if tick() - masteryAt < 3 then
		return
	end
	tbl4.MasteryAt = tick()
	if not itemReplicationService or not itemReplicationService2 or itemReplicationService.IsInitialized ~= true then
		return
	end
	local v3 = pairs
	local items = itemReplicationService:GetItems(itemReplicationService2.MASTERY) or {}

	for _, item in v3(items) do
		local match = tbl10.GetItemName(item.ItemId)
		match = match and match:match("^(.-) %[")

		if match then
			tbl4.Masteries[match] = item.Value
		end
	end
end

tbl4.RefreshOwned = function()
	local ownedAt = tbl4.OwnedAt
	if tick() - ownedAt < 30 then
		return
	end
	tbl4.OwnedAt = tick()
	local ok, result = pcall(tbl11.Fire, "getInventoryWeapons")
	if not ok or type(result) ~= "table" then
		return
	end
	local owned = {}

	for _, value17 in pairs(result) do
		if type(value17) == "table" and value17.Type == "Sword" and value17.Name then
			owned[value17.Name] = true
		end
	end

	tbl4.Owned = owned
end

tbl4.AddCarried = function(arg, instance2)
	if not instance2 then
		return
	end

	for _, child in pairs(instance2:GetChildren()) do
		if child:IsA("Tool") and child.ToolTip == "Sword" then
			arg[child.Name] = true
		end
	end
end
-- 𝐒𝐋 | https://discord.gg/x7YbZeezpm

tbl4.PickSword = function()
	tbl4.RefreshOwned()
	tbl4.RefreshMasteries()
	local v3 = table.clone(tbl4.Owned)
	tbl4.AddCarried(v3, localPlayer.Backpack)
	tbl4.AddCarried(v3, localPlayer.Character)
	local current = tbl4.Current
	local flag = current and v3[current]

	if flag then
		flag = (tbl4.Masteries[current] or 0) < 600
	end

	if flag then
		return current
	end
	local n = -1
	local value18 = nil

	for k in pairs(v3) do
		local n2 = tbl4.Masteries[k] or 0

		if n2 < 600 and n2 > n then
			n = n2
			value18 = k
		end
	end

	tbl4.Current = value18
	return value18
end

tbl4.EquipSword = function(arg)
	local character = localPlayer.Character
	if not character or character:FindFirstChild(arg) then
		return
	end

	if not localPlayer.Backpack:FindFirstChild(arg) then
		local loadAt = tbl4.LoadAt
		if tick() - loadAt < 2 then
			return
		end
		tbl4.LoadAt = tick()
		pcall(tbl11.Fire, "LoadItem", arg)
		return
	end

	tbl10.EquipToolName(arg)
end

tbl4.EquipAt = 0

tbl4.EquipFarmWeapon = function()
	local equipAt = tbl4.EquipAt
	if tick() - equipAt < 0.3 then
		return
	end
	tbl4.EquipAt = tick()

	if tbl[tbl4.Toggle] and (not tbl["Farm Mastery After V4 Awakening"] or tbl4.V4Active()) then
		local v3 = tbl4.PickSword()
		if v3 then
			tbl4.Done = false
			return tbl4.EquipSword(v3)
		end

		if not tbl4.Done then
			tbl4.Done = true
			tbl13.Notify("All swords are 600 mastery, back to Select Tool")
		end
	end

	tbl10.EquipWeapon(tbl["Select Tool"] or "Melee")
end

tbl4.Keys = { "Z", "X", "C", "V", "F" }
tbl4.LowAt = 0
tbl4.Bend = function(j)local w,g= tbl4 .Aim,typeof(j);if g=="Vector3"then if j.Magnitude<0.01 then return j;end;if math.abs(j.Magnitude-1)<0.01 then return(w.Position-w.Origin).Unit;end;return w.Position;end;if g=="CFrame"then if(j.Position-w.Origin).Magnitude<15 then return CFrame.lookAt(j.Position,w.Position);end;return CFrame.new(w.Position);end;return j;end
tbl4.Remap = function(j,w)if j.Name=="LeftClickRemote"then w[1]=Vector3.new(0,-500,0);return;end;for j=1,w.n,1 do w[j]= tbl4 .Bend(w[j]);end;end

tbl4.Hook = function()
	local nightHubBFAim = v2.NightHubBFAim or { Until = 0, Position = Vector3.zero, Origin = Vector3.zero }
	nightHubBFAim.Remap = tbl4.Remap
	tbl4.Aim = nightHubBFAim
	if v2.NightHubBFAim then
		return
	end

	if not hookmetamethod or not getnamecallmethod or not checkcaller then
		return
	end
	v2.NightHubBFAim = nightHubBFAim
	localPlayer:GetMouse()

	local fn6 = newcclosure or function(arg)
		return arg
	end

	hookmetamethod(game, "__namecall", fn6(function(...)  end))
	hookmetamethod(game, "__index", fn6(function(...)  end))
end

tbl4.StopAim = function()
	if not tbl4.Aim then
		return
	end
	tbl4.Aim.Until = 0
	tbl4.Aim.Part = nil
end

tbl4.SetAim = function(obj, part6)
	local aim = tbl4.Aim
	if not aim then
		return
	end
	aim.Part = obj.HumanoidRootPart
	aim.Position = obj.HumanoidRootPart.Position
	aim.Origin = part6.Position
	aim.Until = os.clock() + 0.5
end

tbl4.AimActive = function()
	return tbl["Auto Farm Mastery"] and tbl4.Aim and tbl4.Aim.Until > os.clock()
end

tbl4.IsLow = function(obj, part7)
	if not obj or not tbl8.Alive(obj) then
		return
	end
	local humanoid = obj.Humanoid
	if (tbl["Health %"] or 25) < humanoid.Health / humanoid.MaxHealth * 100 then
		return
	end
	local magnitude = (obj.HumanoidRootPart.Position - part7.Position).Magnitude
	if magnitude > 120 then
		return
	end
	return magnitude
end

tbl4.FindLow = function(arg)
	local lowAt = tbl4.LowAt
	if os.clock() - lowAt < 0.1 then
		return tbl4.IsLow(tbl4.Low, arg) and tbl4.Low
	end
	tbl4.LowAt = os.clock()
	local huge = math.huge
	local value19 = nil

	for _, getEnemy3 in ipairs(tbl8.GetEnemies()) do
		local v5 = tbl4.IsLow(getEnemy3, arg)

		if v5 and v5 < huge then
			huge = v5
			value19 = getEnemy3
		end
	end

	tbl4.Low = value19
	return value19
end

tbl4.SkillReady = function(obj, arg2)
	local selectSkill = tbl["Select Skill"]
	if not selectSkill or not selectSkill[arg2] then
		return
	end
	local main = playerGui:FindFirstChild("Main")
	main = main and main:FindFirstChild("Skills")
	main = main and main:FindFirstChild(obj.Name)
	main = main and main:FindFirstChild(arg2)
	main = main and main:FindFirstChild("Cooldown")
	if not main then
		return
	end
	return main.Size.X.Scale <= 0
end

tbl4.AnyReady = function(arg)
	for _, key in ipairs(tbl4.Keys) do
		if tbl4.SkillReady(arg, key) then
			return true
		end
	end
end

tbl4.ClickM1 = function(obj)
	if os.clock() - (tbl4.ClickAt or 0) < 0.15 then
		return
	end

	if obj.Parent ~= localPlayer.Character then
		return
	end
	tbl4.ClickAt = os.clock()
	obj:Activate()
end

tbl4.CastKey = function(arg)
	if not tbl4.AimActive() then
		return
	end
	local tool = tbl4.Tool
	if not tool or not tool.Parent then
		return
	end

	if not tbl4.SkillReady(tool, arg) then
		return
	end
	virtualInputManager:SendKeyEvent(true, Enum.KeyCode[arg], false, game)
	task.wait(math.max(tbl["Hold " .. arg] or 0, 0.05))
	virtualInputManager:SendKeyEvent(false, Enum.KeyCode[arg], false, game)
	task.wait(0.15)
end

tbl4.CastSkills = function()
	tbl4.Casting = true

	for _, key in ipairs(tbl4.Keys) do
		pcall(tbl4.CastKey, key)
	end

	task.wait(0.1)
	tbl4.Casting = false
end

tbl4.V4Active = function()
	local character = localPlayer.Character
	character = character and character:FindFirstChild("RaceTransformed")
	return character and character.Value
end

tbl4.FarmSkill = function()
	if not tbl["Auto Farm Mastery"] then
		return
	end

	if tbl["Farm Mastery After V4 Awakening"] and not tbl4.V4Active() then
		tbl4.StopAim()
		return
	end
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local v4 = tbl4.FindLow(v3)
	if not v4 then
		tbl4.StopAim()
		return
	end
	local v5 = tbl10.EquipWeapon(tbl["Select Mastery"])
	if not v5 then
		tbl4.StopAim()
		return
	end
	tbl4.Tool = v5
	tbl4.SetAim(v4, v3)
	if tbl4.Casting then
		return true
	end

	if tbl4.AnyReady(v5) then
		task.spawn(tbl4.CastSkills)
		return true
	end

	if not v5:FindFirstChild("LeftClickRemote") then
		return true
	end
	tbl4.ClickM1(v5)
	return true, v4.HumanoidRootPart.CFrame * CFrame.new(0, 2, 5)
end

tbl8.Kill = function(arg, arg2, arg3)
	if not arg or not arg2 then
		return false, "No Mob or no ToggleStop"
	end

	if not tbl8.Alive(arg) or not tbl[arg2] then
		return false, "Mob dead or toggle off"
	end

	if not tbl8.BringTick then
		tbl8.BringTick = tick()
	end

	tbl10.BatBuso()
	local v3, v4 = tbl4.FarmSkill()

	if not v3 then
		tbl4.EquipFarmWeapon()
	end

	local flag = not arg3

	if flag then
		local bringTick = tbl8.BringTick
		flag = tick() - bringTick >= 1
	end

	if flag then
		tbl8.BringTick = tick()
		pcall(tbl8.BringMobs, arg)
	end

	tbl9.Tween(v4 or tbl8.GetSpinPos(arg))
	return true
end

tbl8.SpinAngle = 0

tbl8.GetSpinPos = function(obj)
	obj = obj and obj:FindFirstChild("HumanoidRootPart")
	if not obj then
		return
	end

	if not tbl["Spin Farm"] then
		return obj.CFrame * CFrame.new(3, 25, -3)
	end
	local n = math.abs(tbl["Spin Radius"] or 25)
	local n2 = math.abs(tbl["Spin Speed"] or 4)
	local spinAngle = (tbl8.SpinAngle + math.rad(n2)) % 6.2831853071795862
	tbl8.SpinAngle = spinAngle
	return obj.CFrame * CFrame.new(math.cos(spinAngle) * n, 25, math.sin(spinAngle) * n)
end

tbl8.GetQuestText = function()
	local trackedQuestFrame = playerGui:FindFirstChild("TrackedQuestFrame")
	if not trackedQuestFrame then
		return
	end
	local frame = trackedQuestFrame:FindFirstChild("Frame")
	frame = frame and frame:FindFirstChild("header")
	frame = frame and frame:FindFirstChild("textLabel")
	return frame and frame.Text
end

tbl8.CheckQuest = function(text)
	local v3 = tbl8.GetQuestText()
	if not v3 then
		return false
	end
	local str = v3:gsub("^Defeat%s+", ""):gsub("^%d+%s+", ""):gsub("s$", "")
	local str2 = text:gsub("s$", "")
	return str:find(str2)
end

tbl8.SafeClaimQuest = function(arg, arg2, ...)
	if not arg or not arg2 then
		return false, "No NameMob or no CFrameQuest"
	end

	if not tbl8.CheckQuest(arg) then
		if tbl9.Distance(arg2) <= 30 then
			tbl11.Fire(...)
			return true
		end
		tbl9.Tween(arg2)
		return true
	end

	return nil, "idk error"
end

tbl8.GetCakeGate = function()
	local map = workspace:FindFirstChild("Map")
	map = map and map:FindFirstChild("CakeLoaf")
	map = map and map:FindFirstChild("BigMirror")
	return map and map:FindFirstChild("Main")
end
-- Source Leak (SL) | https://discord.gg/x7YbZeezpm

tbl8.EnterCakeGate = function()
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local v4 = tbl8.GetCakeGate()
	local cFrame = v4 and v4.CFrame or CFrame.new(-2145, 70, -12400)
	if tbl9.Distance(cFrame) > 20 then
		return tbl9.Tween(cFrame)
	end

	if v4 and firetouchinterest then
		firetouchinterest(v4, v3, 0)
		firetouchinterest(v4, v3, 1)
	end

	local random = math.random
	v3.CFrame = cFrame * CFrame.new(math.random(-3, 3), 0, random(-3, 3))
	wait(1)
end

tbl8.KillCakeBoss = function(obj, arg2)
	local v3 = tbl9.Distance(tbl8.GetCakeGate() or CFrame.new(-2145, 70, -12400))
	local v4 = tbl9.Distance(obj.HumanoidRootPart)
	if not v3 or not v4 then
		return
	end

	if obj.Parent == enemies and v4 <= v3 + 500 then
		return tbl8.Kill(obj, arg2, true)
	end
	return tbl8.EnterCakeGate()
end

tbl8.CakeSpawnerAt = 0

tbl8.CheckCakeSpawner = function()
	local cakeSpawnerAt = tbl8.CakeSpawnerAt
	if tick() - cakeSpawnerAt < 2 then
		return
	end
	tbl8.CakeSpawnerAt = tick()
	local ok, result = pcall(tbl11.Fire, "CakePrinceSpawner", true)
	if not ok then
		return
	end

	if tostring(result):find("already open", 1, true) then
		return
	end
	local v3 = tonumber
	local str = tostring(result):gsub("%D", "")
	local v4 = v3(str)
	if v4 and v4 > 0 then
		return
	end
	pcall(tbl11.Fire, "CakePrinceSpawner")
end

tbl8.RacePollAt = 0

tbl8.RaceSpawner = function()
	if not tbl10.HasItem("Sweet Chalice") then
		return wait(1)
	end

	if tbl8.GetBoss({ "Dough King", "Cake Prince" }) then
		return wait(1)
	end
	local flag = not (tbl8.RaceRemain and tbl8.RaceRemain < 10)

	if not flag then
		local racePollAt = tbl8.RacePollAt
		flag = tick() - racePollAt >= 0.5
	end

	if flag then
		local ok, result = pcall(tbl11.Fire, "CakePrinceSpawner", true)
		if not ok then
			return wait(1)
		end
		tbl8.RacePollAt = tick()
		tbl8.RaceOpen = tostring(result):find("already open", 1, true) ~= nil
		local v3 = tbl8
		local v4 = tonumber
		local str = tostring(result):gsub("%D", "")
		v3.RaceRemain = v4(str) or 0
	end
	-- more leaks: https://discord.gg/x7YbZeezpm

	if tbl8.RaceOpen then
		return wait(1)
	end

	if tbl8.RaceRemain < 10 then
		pcall(tbl11.Fire, "CakePrinceSpawner")
		return
	end

	if tbl8.RaceRemain > 30 then
		wait(1)
	end
end

tbl8.FarmCakeMobs = function(arg)
	tbl8.CheckCakeSpawner()
	if tbl["Accept Quests"] and not tbl8.CheckQuest("Cookie Crafter") then
		return tbl8.SafeClaimQuest("Cookie Crafter", CFrame.new(-2034, 38, -12018), "StartQuest", "CakeQuest1", 1)
	end
	local v3 = tbl8.GetMobs(tbl15)
	if v3 and tbl8.Alive(v3) then
		return tbl8.Kill(v3, arg)
	end
	return tbl8.WaitMob(tbl15, arg)
end

tbl8.FarmCocoa = function(arg)
	local v3 = tbl8.GetMobs(tbl16)
	if v3 and tbl8.Alive(v3) then
		return tbl8.Kill(v3, arg)
	end
	return tbl8.WaitMob(tbl16, arg)
end

tbl8.EliteNames = { "Diablo", "Deandre", "Urban" }
tbl8.EliteQuestAt = 0

tbl8.Elite = function()
	if lighting:GetAttribute("MAP") ~= "Sea3" then
		return wait(2)
	end
	local v3 = tbl8.GetBoss(tbl8.EliteNames)
	if not v3 then
		return wait(1)
	end

	if not tbl8.CheckQuest(v3.Name) then
		local eliteQuestAt = tbl8.EliteQuestAt
		if tick() - eliteQuestAt < 1 then
			return
		end
		tbl8.EliteQuestAt = tick()
		pcall(tbl11.Fire, "EliteHunter")
		return
	end

	return tbl8.Kill(v3, "Auto Elite", true)
end

tbl8.RipIndraSpot = CFrame.new(-5564.91406, 313.950531, -2666.69287)
tbl8.SoulReaperSpot = CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)
tbl8.DarkbeardSpot = CFrame.new(3781.985107421875, 14.850649833679199, -3498.081298828125)
tbl8.SummonAt = {}

tbl8.InSea = function(arg)
	return lighting:GetAttribute("MAP") == arg
end

tbl8.GetDetection = function(arg)
	local map = workspace:FindFirstChild("Map")
	map = map and map:FindFirstChild(arg)
	map = map and map:FindFirstChild("Summoner")
	return map and map:FindFirstChild("Detection")
end

tbl8.CanSummon = function(arg)
	local flag = tbl10.HasItem(arg)

	if flag then
		flag = tick() - (tbl8.SummonAt[arg] or 0) > 60
	end

	return flag
end

tbl8.Summon = function(arg, arg2, part8)
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local cFrame = part8 and part8.CFrame or arg2
	if (v3.Position - cFrame.Position).Magnitude > 10 then
		return tbl9.Tween(cFrame)
	end
	tbl10.EquipToolName(arg)
	wait(0.3)
	local character = localPlayer.Character and localPlayer.Character:FindFirstChild(arg)

	if part8 and firetouchinterest then
		firetouchinterest(v3, part8, 0)
		firetouchinterest(v3, part8, 1)

		if character and character:FindFirstChild("Handle") then
			firetouchinterest(character.Handle, part8, 0)
			firetouchinterest(character.Handle, part8, 1)
		end
	end

	tbl8.SummonAt[arg] = tick()
	wait(2)
end

tbl8.RipIndra = function()
	local v3 = tbl8.GetBoss({ "rip_indra True Form" })
	if v3 then
		return tbl8.Kill(v3, "Auto Rip Indra", true)
	end
	return tbl8.Summon("God's Chalice", tbl8.RipIndraSpot, tbl8.GetDetection("Boat Castle"))
end

tbl8.SoulReaper = function()
	local v3 = tbl8.GetBoss({ "Soul Reaper" })
	if v3 then
		return tbl8.Kill(v3, "Auto Soul Reaper", true)
	end
	return tbl8.Summon("Hallow Essence", tbl8.SoulReaperSpot, tbl8.GetDetection("Haunted Castle"))
end

tbl8.Darkbeard = function()
	local v3 = tbl8.GetBoss({ "Darkbeard" })
	if v3 then
		return tbl8.Kill(v3, "Auto Darkbeard", true)
	end
	return tbl8.Summon("Fist of Darkness", tbl8.DarkbeardSpot, tbl8.GetDetection("DarkbeardArena"))
end

tbl8.CursedCaptain = function()
	local v3 = tbl8.GetBoss({ "Cursed Captain" })
	if not v3 then
		return wait(1)
	end
	return tbl8.Kill(v3, "Auto Cursed Captain", true)
end

tbl8.RaidAt = 0
tbl8.RaidSeenAt = 0
tbl8.RaidCenter = Vector3.new(-5543, 313, -2964)

tbl8.IsRaidMob = function(obj)
	if not obj:IsA("Model") or obj.Name == "rip_indra True Form" or obj.Name == "Oni2" then
		return false
	end

	if obj.Name:find("Boss") or obj.Name:find("Friend") or obj.Name:find("Wraith") then
		return false
	end

	if not tbl8.Alive(obj) then
		return false
	end
	return (obj.HumanoidRootPart.Position - tbl8.RaidCenter).Magnitude < 1000
end

tbl8.FindRaidMob = function(instance3, part9)
	local huge = math.huge
	local value20 = nil

	for _, child in pairs(instance3:GetChildren()) do
		if tbl8.IsRaidMob(child) then
			local magnitude = part9 and (child.HumanoidRootPart.Position - part9.Position).Magnitude or 0

			if magnitude < huge then
				huge = magnitude
				value20 = child
			end
		end
	end

	return value20
end

tbl8.GetRaidMob = function()
	local raidAt = tbl8.RaidAt
	if tick() - raidAt < 0.5 and (not tbl8.RaidMob or tbl8.Alive(tbl8.RaidMob)) then
		return tbl8.RaidMob
	end
	tbl8.RaidAt = tick()
	local v3 = tbl10.GetH(2)
	tbl8.RaidMob = tbl8.FindRaidMob(enemies, v3) or tbl8.FindRaidMob(replicatedStorage, v3)

	if tbl8.RaidMob then
		tbl8.RaidSeenAt = tick()
	end

	return tbl8.RaidMob
end

tbl8.RaidActive = function()
	local flag = tbl8.GetRaidMob() ~= nil

	if not flag then
		local raidSeenAt = tbl8.RaidSeenAt
		flag = tick() - raidSeenAt < 10
	end

	return flag
end

tbl8.CastleRaid = function()
	local v3 = tbl8.GetRaidMob()
	if not v3 then
		return tbl9.Tween(CFrame.new(tbl8.RaidCenter + Vector3.new(0, 30, 0)))
	end
	return tbl8.Kill(v3, "Auto Castle Raid")
end

tbl8.SweetChaliceAt = 0

tbl8.DoughKing = function()
	local v3 = tbl8.GetBoss({ "Dough King", "Cake Prince" })
	if v3 then
		return tbl8.KillCakeBoss(v3, "Auto Dough King")
	end

	if tbl10.HasItem("Sweet Chalice") or not tbl10.HasItem("God's Chalice") then
		return tbl8.FarmCakeMobs("Auto Dough King")
	end

	if tbl10.GetMaterial("Conjured Cocoa") < 10 then
		return tbl8.FarmCocoa("Auto Dough King")
	end
	local sweetChaliceAt = tbl8.SweetChaliceAt
	if tick() - sweetChaliceAt < 3 then
		return
	end
	tbl8.SweetChaliceAt = tick()
	pcall(tbl11.Fire, "SweetChaliceNpc")
end

tbl6.Collected = 0
tbl6.Skipped = setmetatable({}, { __mode = "k" })

tbl6.CheckChest = function(arg, part10)
	if arg:GetAttribute("IsDisabled") then
		return
	end
	local v3 = tbl6.Skipped[arg]
	if v3 and tick() - v3 < 120 then
		return
	end
	local position = part10.Position
	return (arg:GetPivot().Position - position).Magnitude
end

tbl6.GetChest = function()
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local huge = math.huge
	local value21 = nil

	for _, value22 in pairs(collectionService:GetTagged("_ChestTagged")) do
		local v6 = tbl6.CheckChest(value22, v3)

		if v6 and v6 < huge then
			huge = v6
			value21 = value22
		end
	end

	return value21
end

tbl6.Collect = function(obj)
	tbl9.Tween(obj:GetPivot())
	local v3 = tbl10.GetH(2)
	if not v3 then
		return
	end
	local position = v3.Position
	if (obj:GetPivot().Position - position).Magnitude > 15 then
		return
	end
	local now = tick()

	while obj.Parent and not obj:GetAttribute("IsDisabled") and tick() - now < 2 do
		v3.CFrame = obj:GetPivot()

		if firetouchinterest and obj:IsA("BasePart") then
			firetouchinterest(obj, v3, 0)
			firetouchinterest(obj, v3, 1)
		end

		wait(0.1)
	end

	tbl6.Skipped[obj] = tick()

	if not obj.Parent or obj:GetAttribute("IsDisabled") then
		tbl6.Collected = tbl6.Collected + 1
	end
end

tbl6.AddBrowser = function(arg, arg2)
	local ok, result = pcall(arg2.InvokeServer, arg2, math.random(1, 100))
	if not ok or type(result) ~= "table" then
		return
	end

	for k, value23 in pairs(result) do
		local flag = k ~= game.JobId and type(value23) == "table"

		if flag then
			flag = (value23.Count or 0) <= 11
		end

		if flag then
			table.insert(arg, k)
		end
	end
end

tbl6.AddApi = function(arg)
	local request_ = request or http_request or syn and syn.request
	if not request_ then
		return
	end

	local ok, result = pcall(request_, {
		Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
		Method = "GET",
	})

	if not ok or type(result) ~= "table" or result.StatusCode ~= 200 then
		return
	end
	local ok2, result2 = pcall(httpService.JSONDecode, httpService, result.Body)
	if not ok2 or type(result2) ~= "table" or not result2.data then
		return
	end

	for _, value24 in pairs(result2.data) do
		if value24.id ~= game.JobId and value24.playing and value24.maxPlayers and value24.playing < value24.maxPlayers - 1 then
			table.insert(arg, value24.id)
		end
	end
end

tbl6.Hop = function()
	local serverBrowser = replicatedStorage:FindFirstChild("__ServerBrowser")
	if not serverBrowser then
		return wait(5)
	end
	local tbl17 = {}
	tbl6.AddBrowser(tbl17, serverBrowser)
	tbl6.AddApi(tbl17)
	if #tbl17 == 0 then
		return wait(5)
	end
	tbl13.Notify("Hop Server")
	tbl7.Queue()
	local jobId = game.JobId

	for i = 1, math.min(#tbl17, 10) do
		if game.JobId ~= jobId then
			return
		end
		pcall(serverBrowser.InvokeServer, serverBrowser, "teleport", table.remove(tbl17, math.random(1, #tbl17)))
		wait(3)
	end

	wait(5)
end

tbl6.LegendaryItems = { "God's Chalice", "Fist of Darkness" }

tbl6.SafeZone = {
	Sea2 = CFrame.new(-384.03524780273, 73.020072937012, 353.2282409668),
	Sea3 = CFrame.new(-5026.3584, 323.515503, -2996.28442),
}

tbl6.GetLegendary = function()
	for _, legendaryItem in pairs(tbl6.LegendaryItems) do
		if tbl10.HasItem(legendaryItem) then
			return legendaryItem
		end
	end
end

tbl6.StopLegendary = function(arg)
	fn3("Got", arg, "- stop chest")

	for _, value25 in pairs({ "Auto Chest", "Auto Chest [HOP]" }) do
		local options = tbl13.Library and tbl13.Library.Options and tbl13.Library.Options[value25]

		if options then
			options:SetValue(false)
		else
			tbl[value25] = false
		end
	end

	local v3 = tbl6.SafeZone[lighting:GetAttribute("MAP")]
	if not v3 then
		return
	end
	tbl9.Tween(v3)
end

tbl6.Farm = function(arg)
	local stopIfLegendaryItem = tbl["Stop If Legendary Item"] and tbl6.GetLegendary()
	if stopIfLegendaryItem then
		return tbl6.StopLegendary(stopIfLegendaryItem)
	end
	local flag

	if arg then
		flag = tbl6.Collected >= (tonumber(tbl["Select Chest Count"]) or 30)
	else
		flag = arg
	end

	if flag then
		return tbl6.Hop()
	end
	local v3 = tbl6.GetChest()
	if v3 then
		return tbl6.Collect(v3)
	end

	if arg then
		return tbl6.Hop()
	end
	wait(1)
end

tbl5.Codes = {
	"EASTEREXP",
	"BANEXPLOIT",
	"NOMOREHACKS",
	"WildDares",
	"BossBuild",
	"GetPranked",
	"EARN_FRUITS",
	"Sub2UncleKizaru",
	"FIGHT4FRUIT",
	"kittgaming",
	"TRIPLEABUSE",
	"Sub2CaptainMaui",
	"Sub2Fer999",
	"Enyu_is_Pro",
	"Magicbus",
	"JCWK",
	"Starcodeheo",
	"Bluxxy",
	"SUB2GAMERROBOT_EXP1",
	"Sub2NoobMaster123",
	"Sub2Daigrock",
	"Axiore",
	"TantaiGaming",
	"StrawHatMaine",
	"Sub2OfficialNoobie",
	"TheGreatAce",
	"SEATROLLIN",
	"24NOADMIN",
	"ADMIN_TROLL",
	"NEWTROLL",
	"SECRET_ADMIN",
	"staffbattle",
	"NOEXPLOIT",
	"NOOB2ADMIN",
	"CODESLIDE",
	"fruitconcepts",
}

tbl5.Styles = {
	{ "Black Leg", "Dark Step Teacher", { { "BuyBlackLeg" } } },
	{ "Fishman Karate", "Water Kung-fu Teacher", { { "BuyFishmanKarate" } } },
	{ "Electro", "Mad Scientist", { { "BuyElectro" } } },
	{
		"Dragon Claw",
		"Sabi",
		{ { "BlackbeardReward", "DragonClaw", "1" }, { "BlackbeardReward", "DragonClaw", "2" } },
	},
	{ "Superhuman", "Martial Arts Master", { { "BuySuperhuman" } } },
	{ "Death Step", "Phoeyu, the Reformed", { { "BuyDeathStep" } } },
	{ "Sharkman Karate", "Sharkman Teacher", { { "BuySharkmanKarate" } } },
	{ "Electric Claw", "Previous Hero", { { "BuyElectricClaw" } } },
	{ "Dragon Talon", "Uzoth", { { "BuyDragonTalon" } } },
	{ "Godhuman", "Ancient Monk", { { "BuyGodhuman" } } },
	{ "Sanguine Art", "Shafi", { { "BuySanguineArt" } } },
}

tbl5.LegendaryColors = { ["Snow White"] = true, ["Pure Red"] = true, ["Winter Sky"] = true }

tbl5.Call = function(arg, arg2)
	task.spawn(function()
		local ok = nil
		-- SL // discord.gg/x7YbZeezpm

		for _, item4 in ipairs(arg2) do
			local result
			ok, result = pcall(tbl11.Fire, unpack(item4))
			ok = ok and result or "error: " .. tostring(result)
		end

		tbl13.Notify(arg .. ": " .. tostring(ok))
	end)
end

tbl5.RedeemCodes = function()
	task.spawn(function()
		local redeem = remotes:FindFirstChild("Redeem")
		if not redeem then
			return tbl13.Notify("Redeem remote not found")
		end

		for _, code in ipairs(tbl5.Codes) do
			pcall(redeem.InvokeServer, redeem, code)
		end

		tbl13.Notify("Redeemed " .. #tbl5.Codes .. " codes")
	end)
end

tbl5.FindNpc = function(arg)
	local findFirstChild = replicatedStorage.FindFirstChild

	for _, value26 in pairs({ workspace:FindFirstChild("NPCs"), findFirstChild(replicatedStorage, "NPCs") }) do
		value26 = value26 and value26:FindFirstChild(arg)
		if value26 and value26:FindFirstChild("HumanoidRootPart") then
			return value26
		end
	end
end

tbl5.QueueStyle = function(arg)
	tbl5.Job = { Title = arg[1], Npc = arg[2], Calls = arg[3], At = tick() }
	tbl["Shop Job"] = true
	tbl13.Notify("Going to buy " .. arg[1])
end

tbl5.FinishJob = function(arg)
	tbl5.Job = nil
	tbl["Shop Job"] = false
	tbl13.Notify(arg)
end

tbl5.RunJob = function()
	local job = tbl5.Job
	if not job then
		return
	end
	local at = job.At
	if tick() - at > 60 then
		return tbl5.FinishJob(job.Title .. ": timeout")
	end
	local v3 = tbl5.FindNpc(job.Npc)
	if not v3 then
		return tbl5.FinishJob(job.Title .. ": NPC " .. job.Npc .. " not in this sea")
	end
	local v4 = tbl10.GetH(2)
	if not v4 then
		return
	end

	if (v4.Position - v3.HumanoidRootPart.Position).Magnitude > 8 then
		return tbl9.Tween(v3.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
	end
	tbl9.StopTween()
	task.wait(0.5 + math.random() * 0.5)
	local ok = nil

	for _, call in ipairs(job.Calls) do
		local result
		ok, result = pcall(tbl11.Fire, unpack(call))
		ok = ok and result or "error: " .. tostring(result)
	end

	tbl5.FinishJob(job.Title .. ": " .. (ok == 1 and "Buy success" or tostring(ok)))
end

tbl5.CloseSpinner = function()
	local ok, result = pcall(require, replicatedStorage.Controllers.UI.Spinner)
	if not ok or type(result) ~= "table" then
		return
	end

	if pcall(result.IsOpen) and result.IsOpen() then
		pcall(result.Close)
	end
end

tbl5.RandomBone = function()
	local ok, result, result2, result3 = pcall(tbl11.Fire, "Bones", "Check")
	if not ok then
		return
	end
	local n = tonumber(result3) or 0
	local n2 = tonumber(result) or 0

	for i = 1, math.min(n, math.floor(n2 / 50)) do
		if not tbl["Auto Random Bone"] then
			return
		end
		pcall(tbl11.Fire, "Bones", "Buy", 1, 1)
		tbl5.CloseSpinner()
		wait(0.3)
	end
end

tbl5.AutoBuy = function()
	local attribute = lighting:GetAttribute("MAP")

	if attribute == "Sea3" and tbl["Auto Buy Bribe"] and tostring(tbl11.Fire("InfoLeviathan", "1")) ~= "5" then
		tbl11.Fire("InfoLeviathan", "2")
	end

	if attribute == "Sea3" and tbl["Auto Random Bone"] then
		tbl5.RandomBone()
	end

	if tbl["Auto Random Fruit"] then
		tbl11.Fire("Cousin", "Buy")
	end

	if attribute == "Sea2" and tbl["Auto Buy Legendary Sword"] then
		tbl11.Fire("LegendarySwordDealer", "2")
	end

	if (attribute == "Sea2" or attribute == "Sea3") and tbl["Auto Buy Haki Color"] then
		local str = tostring(tbl11.Fire("ColorsDealer", "1"))
		--[[ SOURCE LEAK (SL) :: discord.gg/x7YbZeezpm ]]

		if not tbl["Only Buy Legendary Haki Color"] or tbl5.LegendaryColors[str] then
			tbl11.Fire("ColorsDealer", "2")
		end
	end

	if tbl["Auto Buy Candy X2 EXP"] then
		tbl11.Fire("Candies", "Buy", 1, 1)
	end

	if tbl["Auto Buy Candy 500 Fragments"] then
		tbl11.Fire("Candies", "Buy", 2, 2)
	end
end

tbl5.BuildList = function()
	local tbl17 = {
		{ "Separator", { Title = "Auto Buy" } },
		{ "Toggle", { Title = "Auto Buy Bribe", Desc = "Function Only Sea 3" } },
		{ "Toggle", { Title = "Auto Random Bone", Desc = "Function Only Sea 3" } },
		{ "Toggle", { Title = "Auto Random Fruit" } },
		{ "Toggle", { Title = "Auto Buy Legendary Sword", Desc = "Function Only Sea 2" } },
		{ "Toggle", { Title = "Auto Buy Haki Color", Desc = "Function Only Sea 2, Sea 3" } },
		{ "Toggle", { Title = "Only Buy Legendary Haki Color" } },
		{ "Toggle", { Title = "Auto Buy Candy X2 EXP" } },
		{ "Toggle", { Title = "Auto Buy Candy 500 Fragments" } },
		{ "Separator", { Title = "Fighting Style" } },
	}

	for _, style in ipairs(tbl5.Styles) do
		table.insert(tbl17, {
			"Button",
			{
				Title = "Buy " .. style[1],
				Desc = style[2],
				Callback = function()
					tbl5.QueueStyle(style)
				end,
			},
		})
	end

	table.insert(tbl17, { "Separator", { Title = "Abilities" } })

	for _, item5 in ipairs({
		{ "Skyjump", "$10,000 Beli", { { "BuyHaki", "Geppo" } } },
		{ "Buso Haki", "$25,000 Beli", { { "BuyHaki", "Buso" } } },
		{ "Soru", "$100,000 Beli", { { "BuyHaki", "Soru" } } },
		{ "Observation Haki", "$750,000 Beli", { { "KenTalk", "Buy" } } },
	}) do
		table.insert(tbl17, {
			"Button",
			{
				Title = "Buy " .. item5[1],
				Desc = item5[2],
				Callback = function()
					tbl5.Call(item5[1], item5[3])
				end,
			},
		})
	end

	table.insert(tbl17, { "Separator", { Title = "Misc" } })
	table.insert(tbl17, { "Button", { Title = "Redeem All Codes", Callback = tbl5.RedeemCodes } })

	for _, item6 in ipairs({
		{ "Buy Dual Flintlock", nil, { { "BuyItem", "Dual Flintlock" } } },
		{ "Reroll Race", "3000 Fragments", { { "BlackbeardReward", "Reroll", "2" } } },
		{
			"Reset Stats",
			"2500 Fragments",
			{ { "BlackbeardReward", "Refund", "1" }, { "BlackbeardReward", "Refund", "2" } },
		},
		{ "Buy Race Cyborg", nil, { { "CyborgTrainer", "Buy" } } },
		{ "Buy Race Ghoul", nil, { { "Ectoplasm", "BuyCheck", 4 }, { "Ectoplasm", "Change", 4 } } },
		{ "Teleport First Sea", nil, { { "TravelMain" } } },
		{ "Teleport Second Sea", nil, { { "TravelDressrosa" } } },
		{ "Teleport Third Sea", nil, { { "TravelZou" } } },
	}) do
		table.insert(tbl17, {
			"Button",
			{
				Title = item6[1],
				Desc = item6[2],
				Callback = function()
					tbl5.Call(item6[1], item6[3])
				end,
			},
		})
	end

	return tbl17
end

tbl2.Cache = {}

tbl2.Cached = function(arg, arg2, ...)
	local v3 = tbl2.Cache[arg]
	local flag

	if v3 then
		local at = v3.at
		flag = tick() - at < arg2
	else
		flag = v3
	end

	if flag then
		return v3.value
	end
	local ok, result = pcall(tbl11.Fire, ...)
	tbl2.Cache[arg] = { at = tick(), value = ok and result or nil }
	return ok and result or nil
end

tbl2.FormatTime = function(arg)
	local n = math.floor(arg / 3600)
	local n2 = math.floor(arg % 3600 / 60)
	local n3 = math.floor(arg % 60)
	return string.format("%02d:%02d:%02d", n, n2, n3)
end

tbl2.FindBoss = function(arg)
	for _, value27 in pairs(arg) do
		local v4 = tbl8.GetBoss(value27)
		if v4 then
			return v4
		end
	end
end

tbl2.BossText = function(arg)
	local v3 = tbl2.FindBoss(arg)
	if not v3 then
		return "Not spawned"
	end
	local humanoid = v3:FindFirstChild("Humanoid")
	return v3.Name .. " | HP " .. (humanoid and math.floor(humanoid.Health / math.max(humanoid.MaxHealth, 1) * 100) or 0) .. "%"
end

tbl2.Server = function()
	local attribute = lighting:GetAttribute("MAP") or "?"
	local maxPlayers = players.MaxPlayers
	return attribute .. " | Players " .. #players:GetPlayers() .. "/" .. maxPlayers .. " | Uptime " .. tbl2.FormatTime(workspace.DistributedGameTime)
end

tbl2.ServerTime = function()
	local clockTime = lighting.ClockTime
	local flag = clockTime >= 18 or clockTime < 5
	local n = flag and (5 - clockTime) % 24 or 18 - clockTime
	return string.format("%02d:%02d | %s | %s in %.1fh", math.floor(clockTime), math.floor(clockTime % 1 * 60), flag and "Night" or "Day", flag and "Day" or "Night", n)
end

tbl2.Moon = function()
	local attribute = lighting:GetAttribute("MoonPhase")
	if not attribute then
		return "Unknown"
	end

	if attribute == 5 then
		return "Full Moon"
	end

	if attribute == 4 then
		return "Near Full Moon (4/8)"
	end
	return "Phase " .. attribute .. "/8"
end

tbl2.Elite = function()
	local Elite = tbl2.Cached("Elite", 10, "EliteHunter", "Progress")
	return tbl2.BossText({ "Diablo", "Deandre", "Urban" }) .. " | Killed " .. tostring(Elite or "?")
end

tbl2.CakePrince = function()
	local v3 = tbl2.FindBoss({ "Dough King", "Cake Prince" })
	if v3 then
		return tbl2.BossText({ v3.Name })
	end
	local Cake = tbl2.Cached("Cake", 5, "CakePrinceSpawner", true)
	local v4 = tonumber
	local str = tostring(Cake):gsub("%D", "")
	local v5 = v4(str)
	if v5 then
		return v5 .. " mobs left"
	end
	return (tostring(Cake or "?"):gsub("<[^>]*>", ""))
end

tbl2.Rows = {
	{ "Server", tbl2.Server },
	{ "Server Time", tbl2.ServerTime },
	{ "Moon", tbl2.Moon },
	{ "Elite", tbl2.Elite },
	{ "Cake Prince", tbl2.CakePrince },
}

tbl2.Build = function(arg)
	tbl2.Paragraphs = {}

	for _, row in pairs(tbl2.Rows) do
		tbl2.Paragraphs[row[1]] = arg:AddParagraph({ Title = row[1], Content = "..." })
	end
end

tbl2.Update = function()
	for _, row in pairs(tbl2.Rows) do
		local v3 = tbl2.Paragraphs[row[1]]
		local ok, result = pcall(row[2])

		if v3 then
			v3:SetDesc(ok and tostring(result) or "Error")
		end
	end
end

tbl12.HitFunc = getsenv(net)._G.SendHitsToServer
local combatRemoteThread = require(modules.Flags).COMBAT_REMOTE_THREAD or false

tbl12.InRange = function(obj, arg2)
	return tbl8.Alive(obj) and (obj.HumanoidRootPart.Position - arg2).Magnitude <= 70
end

tbl12.GetHits = function(arg)
	local tbl17 = {}
	local v3 = tbl10.GetH(2)
	if not v3 then
		return tbl17
	end
	local position = v3.Position

	for _, getEnemy4 in pairs(tbl8.GetEnemies()) do
		if tbl12.InRange(getEnemy4, position) then
			table.insert(tbl17, getEnemy4)
		end
	end

	if arg then
		for _, child in pairs(characters:GetChildren()) do
			if child ~= localPlayer.Character and tbl12.InRange(child, position) then
				table.insert(tbl17, child)
			end
		end
	end

	if #tbl17 > 1 then
		table.sort(tbl17, function(arg2, arg3)
			return arg2.Humanoid.Health < arg3.Humanoid.Health
		end)
	end

	return tbl17
end

tbl12.HitAt = 0

tbl12.StartAttack = function(arg)
	local hitAt = tbl12.HitAt
	if tick() - hitAt < 0.1 then
		return
	end
	tbl12.HitAt = tick()
	local v3 = tbl12.GetHits(arg)

	if #v3 > 0 then
		local tbl17 = {}

		for _, value28 in pairs(v3) do
			table.insert(tbl17, { value28, value28.HumanoidRootPart })
		end

		local v4 = tbl17[1][2]
		reRegisterAttack:FireServer(0)

		if combatRemoteThread and tbl12.HitFunc then
			tbl12.HitFunc(v4, tbl17)
		else
			reRegisterHit:FireServer(v4, tbl17)
		end
	end
end

tbl10.Run = function(...)  end
tbl7.Toggle = "Auto Farm Missing Swords"
tbl7.LoadedAt = tick()
tbl7.OwnedAt = 0
tbl7.TravelAt = 0
tbl7.Owned = {}
-- deobfuscated by SL | Source Leak -> https://discord.gg/x7YbZeezpm

tbl7.BeliSwords = {
	"Katana",
	"Cutlass",
	"Dual Katana",
	"Iron Mace",
	"Triple Katana",
	"Pipe",
	"Dual-Headed Blade",
	"Soul Cane",
	"Bisento",
}

tbl7.ShipMobs = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" }
tbl7.Travel = { Sea1 = "TravelMain", Sea2 = "TravelDressrosa", Sea3 = "TravelZou" }

tbl7.Targets = {
	{ Sword = "Buddy Sword", Sea = "Sea3", Bosses = { "Cake Queen" }, Desc = "Cake Queen - Sea 3" },
	{
		Sword = "Spikey Trident",
		Sea = "Sea3",
		Bosses = { "Cake Prince", "Dough King" },
		Farm = "Cake",
		Desc = "Cake Prince / Dough King - Sea 3",
	},
	{ Sword = "Longsword", Sea = "Sea2", Bosses = { "Diamond" }, Desc = "Diamond - Sea 2" },
	{
		Sword = "Dragon Trident",
		Sea = "Sea2",
		Bosses = { "Tide Keeper" },
		Desc = "Tide Keeper - Sea 2",
	},
	{ Sword = "Flail", Sea = "Sea2", Bosses = { "Smoke Admiral" }, Desc = "Smoke Admiral - Sea 2" },
	{ Sword = "Gravity Blade", Sea = "Sea2", Bosses = { "Orbitus" }, Desc = "Orbitus - Sea 2" },
	{
		Sword = "Midnight Blade",
		Sea = "Sea2",
		Farm = "Ectoplasm",
		Desc = "Farm 100 Ectoplasm on Cursed Ship - Sea 2",
	},
	{
		Sword = "Pole (1st Form)",
		Sea = "Sea1",
		Bosses = { "Thunder God" },
		Desc = "Thunder God - Sea 1",
	},
	{ Sword = "Shark Saw", Sea = "Sea1", Bosses = { "The Saw" }, Desc = "The Saw - Sea 1" },
}

for _, target in ipairs(tbl7.Targets) do
	target.Toggle = "Auto " .. target.Sword
end

tbl7.Active = function(obj)
	return tbl[obj.Toggle] and not tbl7.Has(obj.Sword)
end

tbl7.Sync = function()
	local flag = false

	for _, target in ipairs(tbl7.Targets) do
		flag = flag or tbl[target.Toggle] == true
	end

	tbl[tbl7.Toggle] = flag
end

tbl7.BuildList = function()
	local tbl17 = {
		{ "Separator", { Title = "Swords" } },
		{
			"Toggle",
			{
				Title = "Hop Find Boss for Sword",
				Desc = "No sword boss in server -> hop to another server in this sea",
			},
		},
		{
			"Button",
			{
				Title = "Buy all sword with beli",
				Desc = "Katana, Cutlass, Dual Katana, Iron Mace, Triple Katana, Pipe, Dual-Headed Blade, Soul Cane, Bisento",
				Callback = function()
					task.spawn(tbl7.BuyAll)
				end,
			},
		},
		{ "Separator", { Title = "Boss / Farm Swords" } },
	}

	for _, target in ipairs(tbl7.Targets) do
		table.insert(tbl17, {
			"Toggle",
			{
				Title = target.Toggle,
				Desc = target.Desc,
				Callback = function(value)
					tbl[target.Toggle] = value
					tbl7.Sync()

					if not value then
						tbl9.StopTween()
					end
				end,
			},
		})
	end

	return tbl17
end

tbl7.Queue = function()
	if v2.NightHubBFNoQueue then
		return
	end
	local queueOnTeleport = queue_on_teleport or syn and syn.queue_on_teleport
	if not queueOnTeleport then
		return
	end
	queueOnTeleport("loadstring(readfile(\"MainBF.lua\"))()")
end

tbl7.RefreshOwned = function()
	local ownedAt = tbl7.OwnedAt
	if tick() - ownedAt < 20 then
		return
	end
	tbl7.OwnedAt = tick()
	local ok, result = pcall(tbl11.Fire, "getInventoryWeapons")
	if not ok or type(result) ~= "table" then
		return
	end
	local owned = {}

	for _, value29 in pairs(result) do
		if type(value29) == "table" and value29.Name then
			owned[value29.Name] = true
		end
	end

	tbl7.Owned = owned
	tbl7.Loaded = true
end

tbl7.Has = function(arg)
	return tbl7.Owned[arg] or tbl10.HasItem(arg)
end

tbl7.BuyOne = function(arg)
	if tbl7.Has(arg) then
		return 0
	end
	pcall(tbl11.Fire, "BuyItem", arg)
	task.wait(1)
	return 1
end

tbl7.BuyAll = function()
	if tbl7.Buying then
		return
	end
	tbl7.Buying = true
	tbl7.OwnedAt = 0
	tbl7.RefreshOwned()
	local n = 0

	for _, beliSword in ipairs(tbl7.BeliSwords) do
		n += tbl7.BuyOne(beliSword)
	end

	tbl7.OwnedAt = 0
	tbl7.Buying = false
	tbl13.Notify(n > 0 and "Bought " .. n .. " swords" or "Already own every beli sword")
end

tbl7.Pending = function(arg)
	local list2 = {}
	local flag = false
	local sea = nil
	local sea2 = nil

	for _, target in ipairs(tbl7.Targets) do
		local v3 = tbl7.Active(target)
		local flag2 = target.Sea == arg

		if v3 and flag2 then
			list2[#list2 + 1] = target
			flag = flag or not target.Farm
		end

		if v3 and not flag2 then
			sea = sea or target.Sea
			sea2 = sea2 or not target.Farm and target.Sea or nil
		end
	end

	return list2, flag, sea2, sea
end

tbl7.FindBoss = function(arg)
	for _, item7 in ipairs(arg) do
		local bosses = item7.Bosses and tbl8.GetBoss(item7.Bosses)
		if bosses then
			return bosses, item7
		end
	end
end

tbl7.Seas = { "Sea1", "Sea2", "Sea3" }

tbl7.SeaHasBoss = function(arg)
	for _, target in ipairs(tbl7.Targets) do
		if target.Sea == arg and not target.Farm and tbl7.Active(target) then
			return true
		end
	end
end

tbl7.NextSea = function(arg)
	local n = table.find(tbl7.Seas, arg) or 0

	for i = 1, 2 do
		local v3 = tbl7.Seas[(n + i - 1) % 3 + 1]
		if tbl7.SeaHasBoss(v3) then
			return v3
		end
	end

	return tbl7.Seas[n % 3 + 1]
end

tbl7.WaitBoss = function(arg)
	for _, item8 in ipairs(arg) do
		local bosses = item8.Bosses and tbl8.GetSpawnPart(item8.Bosses[1])
		if bosses then
			return tbl9.Tween(bosses.CFrame + Vector3.new(0, 30, 0))
		end
	end

	return wait(1)
end

tbl7.FindFarm = function(arg)
	for _, item9 in ipairs(arg) do
		if item9.Farm then
			return item9.Farm
		end
	end
end

tbl7.Ectoplasm = function()
	if tbl10.GetMaterial("Ectoplasm") >= 100 then
		pcall(tbl11.Fire, "Ectoplasm", "Buy", 3)
		tbl7.OwnedAt = 0
		return wait(2)
	end

	local v3 = tbl8.GetMobs(tbl7.ShipMobs)
	if v3 then
		return tbl8.Kill(v3, tbl7.Toggle)
	end
	return tbl8.WaitMob(tbl7.ShipMobs, tbl7.Toggle)
end

tbl7.GoSea = function(arg)
	local travelAt = tbl7.TravelAt
	if tick() - travelAt < 30 then
		return wait(1)
	end
	tbl7.TravelAt = tick()
	tbl13.Notify("Travel to " .. arg .. " for missing swords")
	tbl7.Queue()
	pcall(tbl11.Fire, tbl7.Travel[arg])
	wait(10)
end

tbl7.TurnOff = function(obj)
	if not tbl[obj.Toggle] then
		return
	end
	tbl[obj.Toggle] = false
	local elements = tbl13.Elements and tbl13.Elements[obj.Toggle]

	if elements then
		pcall(elements.SetValue, elements, false)
	end

	tbl13.Notify("Got " .. obj.Sword)
end

tbl7.Finish = function()
	for _, target in ipairs(tbl7.Targets) do
		tbl7.TurnOff(target)
	end

	tbl[tbl7.Toggle] = false
end

tbl7.Run = function()
	tbl7.RefreshOwned()
	if not tbl7.Loaded then
		return wait(1)
	end
	local attribute = lighting:GetAttribute("MAP")
	local v3, v4, v5, v6 = tbl7.Pending(attribute)
	if #v3 == 0 and not v6 then
		return tbl7.Finish()
	end
	local v7, v8 = tbl7.FindBoss(v3)
	if v7 and v8.Farm == "Cake" then
		return tbl8.KillCakeBoss(v7, tbl7.Toggle)
	end

	if v7 then
		return tbl8.Kill(v7, tbl7.Toggle, true)
	end
	local loadedAt = tbl7.LoadedAt
	if tick() - loadedAt < 15 then
		return wait(1)
	end

	if v5 then
		return tbl7.GoSea(tbl7.NextSea(attribute))
	end

	if v4 and tbl["Hop Find Boss for Sword"] then
		return tbl6.Hop()
	end
	local v9 = tbl7.FindFarm(v3)
	if v4 and not v9 then
		return tbl7.WaitBoss(v3)
	end

	if v9 == "Cake" then
		return tbl8.FarmCakeMobs(tbl7.Toggle)
	end

	if v9 == "Ectoplasm" then
		return tbl7.Ectoplasm()
	end
	return tbl7.GoSea(v6)
end

tbl3.CakeBossAlive = function()
	return tbl8.GetBoss({ "Dough King", "Cake Prince" }) ~= nil
end

tbl3.EliteReady = function()
	return lighting:GetAttribute("MAP") == "Sea3" and tbl8.GetBoss(tbl8.EliteNames) ~= nil
end

tbl3.RipIndraReady = function()
	if not tbl8.InSea("Sea3") then
		return false
	end

	if tbl8.GetBoss({ "rip_indra True Form" }) then
		return true
	end
	return not tbl["Auto Dough King"] and tbl8.CanSummon("God's Chalice")
end
-- join us: https://discord.gg/x7YbZeezpm

tbl3.SoulReaperReady = function()
	if not tbl8.InSea("Sea3") then
		return false
	end
	return tbl8.GetBoss({ "Soul Reaper" }) ~= nil or tbl8.CanSummon("Hallow Essence")
end

tbl3.DarkbeardReady = function()
	if not tbl8.InSea("Sea2") then
		return false
	end
	return tbl8.GetBoss({ "Darkbeard" }) ~= nil or tbl8.CanSummon("Fist of Darkness")
end

tbl3.CursedCaptainReady = function()
	return tbl8.InSea("Sea2") and tbl8.GetBoss({ "Cursed Captain" }) ~= nil
end

tbl3.CastleRaidReady = function()
	return tbl8.InSea("Sea3") and tbl8.RaidActive()
end

tbl3.IsReady = function(arg)
	if not tbl[arg[1]] then
		return false
	end
	return not arg[2] or arg[2]()
end

tbl3.Pick = function()
	for _, task_ in ipairs(tbl3.Tasks) do
		if tbl3.IsReady(task_) then
			return task_
		end
	end
end

tbl3.Release = function()
	tbl3.Current = nil
	tbl3.CurrentTask = nil
	tbl9.Velocity(false)
	tbl10.NoClip(false)
	tbl9.StopTween()
end

tbl3.PickAt = 0
tbl3.Loop = function(...)  end

tbl10.AntiAfk = function()
	virtualUser:CaptureController()
	virtualUser:ClickButton2(Vector2.new())
end

tbl10.Start = function()
	tbl10.Runtime = {}
	pcall(tbl10.FpsBoost)
	tbl10.IdledConnection = localPlayer.Idled:Connect(tbl10.AntiAfk)
	local tbl17 = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" }

	local tbl18 = {
		Bones = function()
			if tbl["Accept Quests"] and level.Value >= 2050 and not tbl8.CheckQuest("Posessed Mummy") then
				return tbl8.SafeClaimQuest("Posessed Mummy", CFrame.new(-9506, 172, 6074), "StartQuest", "HauntedQuest2", 2)
			end
			local v3 = tbl8.GetMobs(tbl17)
			if not v3 then
				return tbl8.WaitMob(tbl17, "Start Farm")
			end
			return tbl8.Kill(v3, "Start Farm")
		end,
		["Cake Prince"] = function()
			local v3 = tbl8.GetBoss({ "Cake Prince", "Dough King" })
			if v3 then
				return tbl8.KillCakeBoss(v3, "Start Farm")
			end
			return tbl8.FarmCakeMobs("Start Farm")
		end,
		Level = function()
			local v3 = tbl8.GetLevelQuest()
			if not v3 then
				return wait(2)
			end

			if tbl["Accept Quests"] and not tbl8.CheckQuest(v3.Mob) then
				return tbl8.SafeClaimQuest(v3.Mob, CFrame.new(v3.Pos) * CFrame.new(0, 4, 2), "StartQuest", v3.Quest, v3.Id)
			end
			local v4 = tbl8.GetMobs(v3.Mob)
			if v4 then
				return tbl8.Kill(v4, "Start Farm")
			end
			local v5 = tbl8.GetSpawnPart(v3.Mob)
			return v5 and tbl9.Tween(v5.CFrame + Vector3.new(0, 15, 0))
		end,
	}

	tbl3.Tasks = {
		{ "Shop Job", nil, tbl5.RunJob },
		{ tbl7.Toggle, nil, tbl7.Run },
		{ "Auto Dough King", tbl3.CakeBossAlive, tbl8.DoughKing },
		{ "Auto Rip Indra", tbl3.RipIndraReady, tbl8.RipIndra },
		{ "Auto Soul Reaper", tbl3.SoulReaperReady, tbl8.SoulReaper },
		{ "Auto Darkbeard", tbl3.DarkbeardReady, tbl8.Darkbeard },
		{ "Auto Cursed Captain", tbl3.CursedCaptainReady, tbl8.CursedCaptain },
		{ "Auto Elite", tbl3.EliteReady, tbl8.Elite },
		{ "Auto Castle Raid", tbl3.CastleRaidReady, tbl8.CastleRaid },
		{ "Auto Dough King", nil, tbl8.DoughKing },
		{
			"Auto Chest [HOP]",
			nil,
			function()
				tbl6.Farm(true)
			end,
		},
		{
			"Auto Chest",
			nil,
			function()
				tbl6.Farm()
			end,
		},
		{
			"Start Farm",
			nil,
			function()
				local v3 = tbl18[tbl["Select Mode Farm"]]
				return v3 and v3()
			end,
		},
	}

	tbl10.Functions = {
		["Enable Fast Attack"] = { tbl12.StartAttack },
		["Auto Turn On V4"] = { function()
			tbl10.TurnOnV4()
			wait(1)
		end },
		["Auto Turn On V3"] = { function()
			tbl10.TurnOnV3()
			wait(2)
		end },
	}

	spawn(tbl3.Loop)
	spawn(function(...)  end)
end

tbl13.Notify = function(arg)
	if not tbl13.Library then
		return
	end
	pcall(tbl13.Library.Notify, tbl13.Library, { Title = "Night Hub", Content = arg, Kind = "warn", Duration = 4 })
end

tbl13.GetProfile = function()
	local details = type(v) == "table" and v.Details
	if not details or not details.subscriptionTier then
		return {}
	end
	local serverTime = details.expiresAt and details.serverTime
	local str = "Lifetime"

	if serverTime then
		local n = details.expiresAt - details.serverTime
		str = n >= 86400 and math.floor(n / 86400) .. "d left" or math.floor(n / 3600) .. "h left"
	end

	return { Plan = details.subscriptionTier, Term = str }
end

tbl13.CreateWindow = function()
	tbl13.Title = "Night Hub"
	tbl13.SubTitle = "BETA V2"

	local ok, library = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/Ui-Library/V2Loader.luau"))()
	end)

	if not ok or type(library) ~= "table" then
		library = fn5("NightGlass.lua")
	end

	if type(library) ~= "table" then
		return nil, "Failed to load UI"
	end
	tbl13.Library = library
	library.OnUnload = tbl10.Stop

	local ok2, window = pcall(function()
		return tbl13.Library:CreateWindow({
			Title = tbl13.Title,
			SubTitle = tbl13.SubTitle,
			Size = UDim2.fromOffset(680, 480),
			TabWidth = 142,
			Key = Enum.KeyCode.RightControl,
			MinimizeKey = Enum.KeyCode.RightControl,
			Glass = false,
			Settings = { Save = true, Main = tbl13.Title, Folder = "MainBF", Game = "BloxFruit" },
			Profile = tbl13.GetProfile(),
		})
	end)

	if ok2 then
		tbl13.Window = window
		return true, window
	end
	return nil, "Failed to create window - " .. tostring(window)
end

tbl13.CreateTabs = function()
	if not tbl13.Window then
		return false, "No Window Found!"
	end
	tbl13.Tabs = {}
	local n = 0
	local n2 = 0
	local n3 = 0

	for _, value30 in pairs({
		{ "Status Server", "server" },
		{ "Configuration", "sliders-horizontal" },
		{ "Farmming", "home" },
		{ "Stack Farmming", "layers" },
		{ "Items Farmming", "swords" },
		{ "Shop", "shopping-cart" },
		{ "Settings", "settings" },
	}) do
		n += 1

		local ok, result = pcall(function()
			return tbl13.Window:AddTab({ Title = value30[1], Icon = value30[2] })
		end)

		if ok then
			n2 += 1
			tbl13.Tabs[value30[1]] = result
		else
			n3 += 1
		end
	end

	return true, { n, n2, n3 }
end

tbl13.BuildFeatures = function()
	local tbl17 = { "Dropdown", { Title = "Select Skill", Values = tbl4.Keys, Multi = true } }

	local tbl18 = {
		Farmming = {
			{ "Separator", { Title = "Farm" } },
			{
				"Dropdown",
				{
					Title = "Select Mode Farm",
					Values = { "Level", "Bones", "Cake Prince" },
					Default = "Level",
				},
			},
			{ "Toggle", { Title = "Start Farm" } },
			{ "Separator", { Title = "Mastery" } },
			{ "Toggle", { Title = "Auto Farm All Sword to 600 Mastery" } },
			{
				"Dropdown",
				{ Title = "Select Mastery", Values = { "Blox Fruit", "Gun" }, Default = "Blox Fruit" },
			},
			{
				"Toggle",
				{
					Title = "Auto Farm Mastery",
					Callback = function(value)
						tbl["Auto Farm Mastery"] = value

						if not value then
							tbl4.StopAim()
						end
					end,
				},
			},
			{ "Toggle", { Title = "Farm Mastery After V4 Awakening" } },
			{ "Slider", { Title = "Health %", Max = 50, Min = 10, Default = 25 } },
			tbl17,
			{ "Slider", { Title = "Hold Z", Max = 5, Min = 0, Rounding = 1 } },
			{ "Slider", { Title = "Hold X", Max = 5, Min = 0, Rounding = 1 } },
			{ "Slider", { Title = "Hold C", Max = 5, Min = 0, Rounding = 1 } },
			{ "Slider", { Title = "Hold V", Max = 5, Min = 0, Rounding = 1 } },
			{ "Slider", { Title = "Hold F", Max = 5, Min = 0, Rounding = 1 } },
		},
		["Items Farmming"] = tbl7.BuildList(),
		Shop = tbl5.BuildList(),
		["Stack Farmming"] = {
			{ "Toggle", { Title = "Auto Elite", Desc = "Function Only Sea 3" } },
			{ "Toggle", { Title = "Auto Castle Raid", Desc = "Function Only Sea 3" } },
			{ "Toggle", { Title = "Auto Soul Reaper", Desc = "Function Only Sea 3" } },
			{ "Toggle", { Title = "Auto Darkbeard", Desc = "Function Only Sea 2" } },
			{ "Toggle", { Title = "Auto Rip Indra", Desc = "Function Only Sea 3" } },
			{ "Toggle", { Title = "Auto Cursed Captain", Desc = "Function Only Sea 2" } },
			{ "Toggle", { Title = "Auto Dough King", Desc = "Function Only Sea 3" } },
			{ "Separator", { Title = "Chests" } },
			{
				"Dropdown",
				{ Title = "Select Chest Count", Values = { "20", "30", "40", "50" }, Default = "30" },
			},
			{ "Toggle", { Title = "Stop If Legendary Item", Default = true } },
			{ "Toggle", { Title = "Auto Chest" } },
			{ "Toggle", { Title = "Auto Chest [HOP]" } },
		},
		Configuration = {
			{ "Separator", { Title = "Farm" } },
			{ "Dropdown", { Title = "Select Tool", Values = { "Melee", "Sword", "Blox Fruit" } } },
			{
				"Toggle",
				{
					Title = "Accept Quests",
					Desc = "Auto claiming cake/bone quest when farm",
					Default = true,
				},
			},
			{ "Toggle", { Title = "Enable Fast Attack" } },
			{ "Slider", { Title = "Tween Speed", Max = 300, Min = 100 } },
			{
				"Toggle",
				{
					Title = "Safe Tween",
					Desc = "Dung 0.5-0.7s moi 3s khi bay xa de server khong keo giat/kick. Tat = bay lien mach nhanh hon nhung de bi giat",
					Default = true,
				},
			},
			{ "Separator", { Title = "Bring Mobs" } },
			{ "Slider", { Title = "Bring Amount", Max = 10, Min = 2 } },
			{ "Toggle", { Title = "Random Bring Pos When Detect Near Players" } },
			{ "Separator", { Title = "Spin Farm" } },
			{
				"Toggle",
				{ Title = "Spin Farm", Desc = "Bay vong tron quanh mob, thay cho tween dung yen" },
			},
			{ "Slider", { Title = "Spin Radius", Max = 150, Min = 5 } },
			{ "Slider", { Title = "Spin Speed", Max = 20, Min = 1 } },
			{ "Separator", { Title = "Race" } },
			{ "Toggle", { Title = "Auto Turn On V4", Desc = "Bat V4 khi day RaceEnergy" } },
			{ "Toggle", { Title = "Auto Turn On V3", Desc = "Spam skill toc V3 moi 2s" } },
		},
	}

	local function fn6(arg, arg2)
		if not arg then
			return false, "No tab found"
		end

		if not arg2 then
			return false, "Invaild config"
		end
		local first = arg2[1]
		local second = arg2[2]
		second.Description = second.Description or second.Desc

		if first == "Toggle" then
			second.Default = second.Default or false

			second.Callback = second.Callback or function(arg3)
				tbl[second.Title] = arg3

				if not arg3 then
					tbl9.StopTween()
				end
			end

			return arg:AddToggle(second.Title, second)
		end

		if first == "Dropdown" then
			second.Default = second.Default or second.Multi and {} or ""

			second.Callback = second.Callback or function(arg3)
				tbl[second.Title] = arg3
			end

			return arg:AddDropdown(second.Title, second)
		end

		if first == "Slider" then
			second.Default = second.Default or tbl[second.Title] or second.Min

			second.Callback = second.Callback or function(arg3)
				tbl[second.Title] = arg3
			end

			return arg:AddSlider(second.Title, second)
		end

		if first == "Button" then
			return arg:AddButton(second)
		end

		if first == "Separator" then
			return arg:AddSeparator(second.Title)
		end
	end

	tbl13.Elements = {}

	for k, value31 in pairs(tbl18) do
		if tbl13.Tabs[k] then
			for _, value32 in pairs(value31) do
				tbl13.Elements[value32[2].Title] = fn6(tbl13.Tabs[k], value32)
			end
		end
	end

	tbl13.Tabs.Settings:AddInterface()
end

tbl13.Init = function()
	local v3, v4 = tbl13.CreateWindow()
	if not v3 then
		return v4
	end
	local v5, v6 = tbl13.CreateTabs()
	if not v5 then
		return v6
	end
	fn4("Total", v6[1], "| Success:", v6[2], "Fail:", v6[3])
	tbl13.BuildFeatures()

	if tbl13.Tabs["Status Server"] then
		tbl2.Build(tbl13.Tabs["Status Server"])
	end
end

tbl10.Stop = function()
	if tbl10.Stopped then
		return
	end
	tbl10.Stopped = true

	if tbl10.IdledConnection then
		tbl10.IdledConnection:Disconnect()
	end

	if tbl13.Library and not tbl13.Library.Unloaded then
		pcall(tbl13.Library.Destroy, tbl13.Library)
	end

	for k, value33 in pairs(tbl) do
		if value33 == true then
			tbl[k] = false
		end
	end

	tbl4.StopAim()
	tbl9.StopTween()
end

if v2.NightHubBFStop then
	pcall(v2.NightHubBFStop)
	wait(0.5)
end

v2.NightHubBFStop = tbl10.Stop
tbl4.Hook()
tbl13.Init()
tbl10.Start()

-- more leaks: https://discord.gg/x7YbZeezpm