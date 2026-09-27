-- generated using SL | Source Leak
-- https://discord.gg/x7YbZeezpm

local connection = game.AttributeChanged:Connect(function(attribute)
end)

connection:Disconnect()

local connection2 = workspace.AttributeChanged:Connect(function(attribute2)
end)

connection2:Disconnect()
local Folder = Instance.new("Folder")

local connection3 = Folder.AttributeChanged:Connect(function(attribute3)
end)

connection3:Disconnect()
Folder:GetChildren()
Folder:Destroy()
local Folder2 = Instance.new("Folder", Folder)
-- deobfuscated by 𝖲𝗈𝗎𝗋𝖼𝖾 𝖫𝖾𝖺𝗄 -> https://discord.gg/x7YbZeezpm

local connection4 = Folder2.AttributeChanged:Connect(function(attribute4)
end)

connection4:Disconnect()
Folder2.Name = "59397465"
Folder:WaitForChild("59397465")
Folder:Destroy()
Folder2:Destroy()
local HttpService = game:GetService("HttpService")

local connection5 = HttpService.AttributeChanged:Connect(function(attribute5)
end)

connection5:Disconnect()
local RunService = game:GetService("RunService")

local connection6 = RunService.AttributeChanged:Connect(function(attribute6)
end)

connection6:Disconnect()
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RbxAnalyticsService = game:FindService("RbxAnalyticsService")

_G.SAEConfig = {
	Events = {
		["Dr. Scramble"] = {
			["Auto Buy Shop"] = false,
			["Auto Collect Gear"] = false,
			["Auto Hunt Experiments"] = false,
			["Minimum Drone HP"] = 0,
			["Shop Item"] = "Scrambled"
		}
	},
	Farming = {
		["Auto Claim Reward Index"] = true,
		["Auto Equip Best Pets"] = true,
		["Auto Full Index"] = true,
		["Auto Hatch"] = true,
		["Auto Place"] = true,
		["Auto Treadmill"] = true,
		["Auto Tutorial"] = true,
		["Auto Upgrade Base"] = false,
		["Auto Upgrade Treadmill"] = false,
		["Claim Offline Earnings"] = true
	},
	Favoriting = { ["Auto Favorite"] = false, ["Target Categories"] = {}, ["Target Rarities"] = {} },
	Fusing = { ["Auto Fuse"] = false, ["Target Categories"] = {}, ["Target Rarities"] = {} },
	Misc = { ["Anti AFK"] = true, ["Auto Reconnect"] = true, ["FPS Boost"] = false },
	Movement = { Mode = "Teleport", Speed = 800 },
	Selling = {
		["Auto Sell Eggs"] = false,
		["Auto Sell Pets"] = false,
		Delay = 5,
		["Minimum Value"] = 0,
		["Target Rarities"] = {},
		Weight = 10,
		["Weight Mode"] = "None"
	},
	Stealing = {
		["Auto Steal"] = true,
		["Farm Areas"] = {},
		["Minimum Value"] = 0,
		["Target Mutations"] = {},
		["Target Rarities"] = {}
	},
	Webhook = { ["Notify On Hatch"] = false, ["Notify On Steal"] = false, Rarities = {}, URL = "" }
}

getgenv().SAEConfig = {
	Events = {
		["Dr. Scramble"] = {
			["Auto Buy Shop"] = false,
			["Auto Collect Gear"] = false,
			["Auto Hunt Experiments"] = false,
			["Minimum Drone HP"] = 0,
			["Shop Item"] = "Scrambled"
		}
	},
	Farming = {
		["Auto Claim Reward Index"] = true,
		["Auto Equip Best Pets"] = true,
		["Auto Full Index"] = true,
		["Auto Hatch"] = true,
		["Auto Place"] = true,
		["Auto Treadmill"] = true,
		["Auto Tutorial"] = true,
		["Auto Upgrade Base"] = false,
		["Auto Upgrade Treadmill"] = false,
		["Claim Offline Earnings"] = true
	},
	Favoriting = { ["Auto Favorite"] = false, ["Target Categories"] = {}, ["Target Rarities"] = {} },
	Fusing = { ["Auto Fuse"] = false, ["Target Categories"] = {}, ["Target Rarities"] = {} },
	Misc = { ["Anti AFK"] = true, ["Auto Reconnect"] = true, ["FPS Boost"] = false },
	Movement = { Mode = "Teleport", Speed = 800 },
	Selling = {
		["Auto Sell Eggs"] = false,
		["Auto Sell Pets"] = false,
		Delay = 5,
		["Minimum Value"] = 0,
		["Target Rarities"] = {},
		Weight = 10,
		["Weight Mode"] = "None"
	},
	Stealing = {
		["Auto Steal"] = true,
		["Farm Areas"] = {},
		["Minimum Value"] = 0,
		["Target Mutations"] = {},
		["Target Rarities"] = {}
	},
	Webhook = { ["Notify On Hatch"] = false, ["Notify On Steal"] = false, Rarities = {}, URL = "" }
}

RbxAnalyticsService:GetClientId()

-- SOURCE LEAK (SL) | https://discord.gg/x7YbZeezpm