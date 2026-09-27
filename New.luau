repeat
	task.wait()
until game:IsLoaded()

local tbl

tbl = {
	IsDetected = false,
	_unpack = function(arg, arg2, arg3)
		arg2 = arg2 or 1
		local n = arg3 or #arg
		if n < arg2 then
			return
		end
		return arg[arg2], tbl._unpack(arg, arg2 + 1, n)
	end,
	_pcall = function(arg, ...)
		local tbl2 = { ... }

		local ok, result = pcall(function()
			return arg(tbl._unpack(tbl2))
		end)

		if not ok then
			return false, result
		end
		return true, result
	end,
}

local function fn()
	return true
end

local v, v2 = tbl._pcall(debug.info, fn, "f")

if not v or v2 ~= fn then
	tbl.IsDetected = true
	LPH_CRASH()
end

local v3, v4 = tbl._pcall(debug.info, 2, "f")

if not v3 or v4 ~= pcall then
	tbl.IsDetected = true
	LPH_CRASH()
end

local v5 = (cloneref or function(arg)
	return arg
end)(game:GetService("RunService"))

if v5:IsStudio() then
	tbl.IsDetected = true
	LPH_CRASH()
end

if v5:IsServer() then
	tbl.IsDetected = true
	LPH_CRASH()
end

if tbl.IsDetected then
	return
end

loadstring([[ 
  function LPH_NO_VIRTUALIZE(f) return f end;
  function LPH_JIT_MAX(f) return f end;
  function LPH_JIT(f) return f end;

  function LPH_ENCNUM(n, ...) return n end;
  function LPH_ENCSTR(s, ...) return s end;
  function LPH_ENCFUNC(f, ...) return f end;
  function LPH_ENCBUF(b, ...) return b end;

  function LPH_ATTRIBUTES(...) end;
  function LPH_REWRITE(expr, ...) return expr end;
  function LPH_STACKALLOC(size, zeroOrOne) return {} end;
  function LPH_PRECHECK(...) end;

  function VM(...) end;
  function PRESET(...) end;
  function ENCRYPT(...) end;
  function OPTIMIZE(...) end;
  function ERROR_HANDLING(...) end;
  function TRANSFORM(...) end;
  NONE, OPAL, ONYX = 0, 1, 2;
  FAST, SECURE = 0, 1;
  CONTROL_FLOW, EXTRACT, INLINE, UNROLL, NO_UPVALUES, level = 0, 0, 0, 0, 0, 0;
]])()

local function fn2()
	local now = tick()

	local function fn3()
		if not getfenv() then
			getfenv()
		end

		local function fn4(arg)
			local ok, result = pcall(function()
				return game:HttpGet(arg, true)
			end)

			if not ok then
				return nil, "Failed to load resource"
			end
			return result
		end

		return { load = function(arg)
			local v6, v7 = fn4(arg)
			if not v6 then
				return nil, v7
			end
			local chunk, v8 = loadstring(v6)
			if not chunk then
				return nil, v8
			end
			return chunk
		end }
	end

	local v6 = fn3()

	local tbl2 = {
		print = function()
		end,
		warn = function()
		end,
		error = function()
		end,
		pcall = pcall,
		xpcall = xpcall,
		tick = tick,
		time = time,
		os = { time = os.time, date = os.date, clock = os.clock },
		math = math,
		table = table,
		string = string,
		type = type,
		typeof = typeof,
		tonumber = tonumber,
		tostring = tostring,
		require = require,
		pairs = pairs,
		ipairs = ipairs,
		next = next,
		select = select,
		unpack = unpack,
		_G = _G,
  }
  local v11, v12, v13, v14, v15, v16, v17, v18 = fn4({ "Home", "10734942198" }, { "Main", "10723407389" }, { 
      Automatically", "10734923549" }, { "Sea Event", "16175025368" }, { "Teleport", "10734910680" }, { "Shop", "10734952273" }, { "Misc", "11447063791" }, { "Settings", "10734950309" })

	local tbl4 = {
		__spawn = task.spawn,
		__isLoaded = false,
		__unloadRequested = false,
		__locks = {},
		__timers = {},
		__hooks = {},
	}

	local function fn5(arg)
		return ({ [arg] = game:GetService(arg) })[arg]
	end

	local tbl5 = {
		Players = fn5("Players"),
		ReplicatedStorage = fn5("ReplicatedStorage"),
		HttpService = fn5("HttpService"),
		UserInputService = fn5("UserInputService"),
		Workspace = fn5("Workspace"),
		VirtualInputManager = fn5("VirtualInputManager"),
		TweenService = fn5("TweenService"),
		RunService = fn5("RunService"),
		Lighting = fn5("Lighting"),
		CollectionService = fn5("CollectionService"),
		TeleportService = fn5("TeleportService"),
	}

	local localPlayer = tbl5.Players.LocalPlayer
	local playerGui = localPlayer.PlayerGui

	local tbl6 = {
		Enemies = tbl5.Workspace:FindFirstChild("Enemies"),
		Characters = tbl5.Workspace:FindFirstChild("Characters"),
		Map = tbl5.Workspace:FindFirstChild("Map"),
		WorldOrigin = tbl5.Workspace:FindFirstChild("_WorldOrigin"),
		Remotes = tbl5.ReplicatedStorage:FindFirstChild("Remotes"),
		CommF_ = nil,
		Modules = tbl5.ReplicatedStorage:FindFirstChild("Modules"),
		Net = nil,
	}

	tbl6.CommF_ = tbl6.Remotes:WaitForChild("CommF_")
	tbl6.Net = tbl6.Modules:WaitForChild("Net")

	local tbl7 = {
		RegisterAttack = tbl6.Net:WaitForChild("RE/RegisterAttack"),
		RegisterHit = tbl6.Net:WaitForChild("RE/RegisterHit"),
		ReceivedHit = tbl6.Net:WaitForChild("RE/ReceivedHit"),
		ShootGunEvent = tbl6.Net:WaitForChild("RE/ShootGunEvent"),
	}

	local placeId = game.PlaceId

	local tbl8 = {
		placeId == 2753915549 or placeId == 85211729168715,
		placeId == 4442272183 or placeId == 79091703265657,
		placeId == 7449423635 or placeId == 100117331123089,
	}

	local tbl9 = {
		BoatShop = {
			[2] = CFrame.new(-13.488054275512695, 10.311711311340332, 2927.69287109375),
			[3] = CFrame.new(-16927.17578125, 9.0563430786132812, 435.248779296875),
		},
		BoatShopPos = {
			[2] = Vector3.new(-13.488054, 10.311711, 2927.6929),
			[3] = Vector3.new(-16927.176, 9.056343, 435.24878),
		},
		LevelSea = {
			["1"] = CFrame.new(-21332.876953125, 0, 1356.6005859375),
			["2"] = CFrame.new(-25077.7109375, 0, 2876.619140625),
			["3"] = CFrame.new(-29325.326171875, 0, 4763.1796875),
			["4"] = CFrame.new(-31615.3671875, 0, 5669.40478515625),
			["5"] = CFrame.new(-36453.9921875, 0, 6484.83056640625),
			["6"] = CFrame.new(-42170.15234375, 0, 4071.352294921875),
			Infinite = CFrame.new(0, 5, -1e14),
		},
		Islands = {
			["Sky 2"] = Vector3.new(-4607.8228, 872.5425, -1667.5569),
			["Sky 3"] = Vector3.new(-7894.6177, 5547.1416, -380.2912),
		},
	}

	local tbl10 = {
		"Rocket Fruit",
		"Spin Fruit",
		"Chop Fruit",
		"Spring Fruit",
		"Bomb Fruit",
		"Smoke Fruit",
		"Spike Fruit",
		"Flame Fruit",
		"Falcon Fruit",
		"Ice Fruit",
		"Sand Fruit",
		"Dark Fruit",
		"Ghost Fruit",
		"Diamond Fruit",
		"Light Fruit",
		"Rubber Fruit",
		"Barrier Fruit",
		"Magma Fruit",
		"Quake Fruit",
		"Buddha Fruit",
		"Love Fruit",
		"Spider Fruit",
		"Sound Fruit",
		"Phoenix Fruit",
		"Portal Fruit",
		"Rumble Fruit",
		"Pain Fruit",
		"Blizzard Fruit",
		"Gravity Fruit",
		"Mammoth Fruit",
		"T-Rex Fruit",
		"Dough Fruit",
		"Shadow Fruit",
		"Venom Fruit",
		"Control Fruit",
		"Spirit Fruit",
		"Dragon Fruit",
		"Leopard Fruit",
		"Yeti Fruit",
		"Kitsune Fruit",
		"Gas Fruit",
		"Blade Fruit",
	}

	local tbl11 = {
		Frags = {
			{ "Race Rerol", { "BlackbeardReward", "Reroll", "2" } },
			{ "Reset Stats", { "BlackbeardReward", "Refund", "2" } },
		},
		["Fighting Style"] = {
			{ "Buy Black Leg", { "BuyBlackLeg" } },
			{ "Buy Electro", { "BuyElectro" } },
			{ "Buy Fishman Karate", { "BuyFishmanKarate" } },
			{ "Buy Dragon Claw", { "BlackbeardReward", "DragonClaw", "2" } },
			{ "Buy Superhuman", { "BuySuperhuman" } },
			{ "Buy Death Step", { "BuyDeathStep" } },
			{ "Buy Sharkman Karate", { "BuySharkmanKarate" } },
			{ "Buy Electric Claw", { "BuyElectricClaw" } },
			{ "Buy Dragon Talon", { "BuyDragonTalon" } },
			{ "Buy GodHuman", { "BuyGodhuman" } },
			{ "Buy Sanguine Art", { "BuySanguineArt" } },
		},
		["Ability Teacher"] = {
			{ "Buy Geppo", { "BuyHaki", "Geppo" } },
			{ "Buy Buso", { "BuyHaki", "Buso" } },
			{ "Buy Soru", { "BuyHaki", "Soru" } },
			{ "Buy Ken", { "KenTalk", "Buy" } },
          },
		Sword = {
			{ "Buy Katana", { "BuyItem", "Katana" } },
			{ "Buy Cutlass", { "BuyItem", "Cutlass" } },
			{ "Buy Dual Katana", { "BuyItem", "Dual Katana" } },
			{ "Buy Iron Mace", { "BuyItem", "Iron Mace" } },
			{ "Buy Triple Katana", { "BuyItem", "Triple Katana" } },
			{ "Buy Pipe", { "BuyItem", "Pipe" } },
			{ "Buy Dual-Headed Blade", { "BuyItem", "Dual-Headed Blade" } },
			{ "Buy Soul Cane", { "BuyItem", "Soul Cane" } },
			{ "Buy Bisento", { "BuyItem", "Bisento" } },
		},
		Gun = {
			{ "Buy Musket", { "BuyItem", "Musket" } },
			{ "Buy Slingshot", { "BuyItem", "Slingshot" } },
			{ "Buy Flintlock", { "BuyItem", "Flintlock" } },
			{ "Buy Refined Slingshot", { "BuyItem", "Refined Slingshot" } },
			{ "Buy Refined Flintlock", { "BuyItem", "Refined Flintlock" } },
			{ "Buy Cannon", { "BuyItem", "Cannon" } },
			{ "Buy Kabucha", { "BlackbeardReward", "Slingshot", "2" } },
		},
		Accessories = {
			{ "Buy Black Cape", { "BuyItem", "Black Cape" } },
			{ "Buy Swordsman Hat", { "BuyItem", "Swordsman Hat" } },
			{ "Buy Tomoe Ring", { "BuyItem", "Tomoe Ring" } },
		},
		Race = {
			{ "Ghoul Race", { "Ectoplasm", "Change", 4 } },
			{ "Cyborg Race", { "CyborgTrainer", "Buy" } },
		},
	}

	local tbl12 = {
		"Flame",
		"Ice",
		"Quake",
		"Light",
		"Dark",
		"Spider",
		"Rumble",
		"Magma",
		"Buddha",
		"Sand",
		"Phoenix",
		"Dough",
	}

	local ItemReplicationService = require(tbl5.ReplicatedStorage.ItemReplicationService)
	local KEYS = require(tbl5.ReplicatedStorage.ItemReplicationService.KEYS)
	local ItemId = require(tbl5.ReplicatedStorage.Economy.ItemId)
	local ItemConfig = require(tbl5.ReplicatedStorage.ItemConfig)
	local RarityUtil = require(tbl5.ReplicatedStorage.Modules.Asset.RarityUtil)
	local PriceService = require(tbl5.ReplicatedStorage.PriceService)

	local tbl13 = {
		Moveset = "Melee",
		PhysicalMoveset = "Blox Fruit",
		Material = "Material",
		Accessory = "Accessory",
	}

	local function fn6()
		local tbl14 = {}

		local ok3, result3 = pcall(function()
			return tbl5.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits")
		end)

		if ok3 and typeof(result3) == "table" then
			for _, v19 in ipairs(result3) do
				if v19.Name and v19.Price then
					tbl14[v19.Name] = v19.Price
				end
			end
		end

		return tbl14
	end

	local function fn7(arg, arg2)
		local v19 = ItemConfig.match(arg, arg2)
		local v20 = nil

		if v19 then
			if v19.asNullable then
				v20 = v19:asNullable()
			else
				v20 = nil

				if v19.unwrap then
					v20 = v19:unwrap()
				end
			end
		end

		if not v20 then
			return nil
		end
		local rarity = v20.Quality and v20.Quality.Rarity
		if not rarity then
			return nil
		end
		return RarityUtil.tryGetRarity(rarity)
	end

	local function fn8()
		local tbl14 = {}
		local items = ItemReplicationService:GetItems(KEYS.QUANTITY)
		if not items then
			return tbl14
		end
		local v19 = fn6()

		for _, item in pairs(items) do
			local n = item.Value or 0
