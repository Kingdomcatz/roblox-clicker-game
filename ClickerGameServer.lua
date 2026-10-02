-- ServerScriptService > ClickerGameServer (Script)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("ClickerRemote")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "ClickerRemote"
	remote.Parent = ReplicatedStorage
end

local MAX_EQUIPPED = 5
local MAX_PETS = 50
local rng = Random.new()

-- Expanded pet roster with rarities
local PETS = {
	-- Common
	Cat = {Click = 2, Auto = 1, Rarity = "Common"},
	Dog = {Click = 3, Auto = 2, Rarity = "Common"},
	Bunny = {Click = 5, Auto = 3, Rarity = "Common"},
	Parrot = {Click = 4, Auto = 2, Rarity = "Common"},
	Fish = {Click = 1, Auto = 1, Rarity = "Common"},
	Turtle = {Click = 2, Auto = 2, Rarity = "Common"},
	
	-- Rare
	Fox = {Click = 12, Auto = 8, Rarity = "Rare"},
	Wolf = {Click = 15, Auto = 10, Rarity = "Rare"},
	Eagle = {Click = 18, Auto = 12, Rarity = "Rare"},
	Snake = {Click = 10, Auto = 7, Rarity = "Rare"},
	Dolphin = {Click = 14, Auto = 9, Rarity = "Rare"},
	Tiger = {Click = 20, Auto = 13, Rarity = "Rare"},
	
	-- Epic
	Dragon = {Click = 25, Auto = 15, Rarity = "Epic"},
	Phoenix = {Click = 60, Auto = 40, Rarity = "Epic"},
	Unicorn = {Click = 120, Auto = 80, Rarity = "Epic"},
	Gryphon = {Click = 80, Auto = 50, Rarity = "Epic"},
	Kraken = {Click = 70, Auto = 45, Rarity = "Epic"},
	Chimera = {Click = 100, Auto = 65, Rarity = "Epic"},
	
	-- Legendary
	["Shadow Beast"] = {Click = 300, Auto = 200, Rarity = "Legendary"},
	Cerberus = {Click = 350, Auto = 230, Rarity = "Legendary"},
	["Ice Titan"] = {Click = 320, Auto = 210, Rarity = "Legendary"},
	["Lava Lord"] = {Click = 340, Auto = 225, Rarity = "Legendary"},
	Basilisk = {Click = 330, Auto = 220, Rarity = "Legendary"},
	["Time Warden"] = {Click = 360, Auto = 240, Rarity = "Legendary"},
	
	-- Mythic
	["God Slayer"] = {Click = 800, Auto = 600, Rarity = "Mythic"},
	["Celestial Dragon"] = {Click = 900, Auto = 650, Rarity = "Mythic"},
	Leviathan = {Click = 1000, Auto = 700, Rarity = "Mythic"},
	["Void Entity"] = {Click = 950, Auto = 675, Rarity = "Mythic"},
	["Cosmic Beast"] = {Click = 1100, Auto = 750, Rarity = "Mythic"},
	
	-- Celestial (Ultra Rare)
	["Omnipotent One"] = {Click = 2000, Auto = 1200, Rarity = "Celestial"},
	["Supreme Deity"] = {Click = 2200, Auto = 1300, Rarity = "Celestial"},
	["Infinite Spirit"] = {Click = 2100, Auto = 1250, Rarity = "Celestial"},
	
	-- Omnipotent (Rarest)
	["The Absolute"] = {Click = 5000, Auto = 3000, Rarity = "Omnipotent"},
}

local EGGS = {
	{Name = "Basic Egg", Cost = 100, Pets = {
		{"Cat", 25}, {"Dog", 25}, {"Bunny", 20}, {"Parrot", 15}, {"Fish", 10}, {"Turtle", 5}
	}},
	{Name = "Rare Egg", Cost = 2500, Pets = {
		{"Bunny", 15}, {"Fox", 30}, {"Wolf", 25}, {"Eagle", 20}, {"Snake", 10}
	}},
	{Name = "Epic Egg", Cost = 40000, Pets = {
		{"Dragon", 30}, {"Phoenix", 25}, {"Unicorn", 20}, {"Gryphon", 15}, {"Kraken", 10}
	}},
	{Name = "Legendary Egg", Cost = 500000, Pets = {
		{"Shadow Beast", 25}, {"Cerberus", 25}, {"Ice Titan", 20}, {"Lava Lord", 15}, {"Basilisk", 15}
	}},
	{Name = "Mythic Egg", Cost = 5000000, Pets = {
		{"God Slayer", 20}, {"Celestial Dragon", 25}, {"Leviathan", 20}, {"Void Entity", 20}, {"Cosmic Beast", 15}
	}},
	{Name = "Celestial Egg", Cost = 50000000, Pets = {
		{"Omnipotent One", 35}, {"Supreme Deity", 35}, {"Infinite Spirit", 30}
	}},
	{Name = "Omnipotent Egg", Cost = 500000000, Pets = {
		{"The Absolute", 100}
	}},
}

local BUFFS = {
	{Name = "Golden Touch", Cost = 5000, Type = "click", Value = 1.15, Description = "+15% click power"},
	{Name = "Turbo Engine", Cost = 12000, Type = "auto", Value = 1.2, Description = "+20% auto income"},
	{Name = "Rebirth Boost", Cost = 25000, Type = "rebirth", Value = 1.5, Description = "Rebirth bonuses +50% stronger"},
	{Name = "Lucky Title", Cost = 1500, Type = "title", Value = "Lucky", Description = "Unlocks the Lucky title"},
	{Name = "King Title", Cost = 5000, Type = "title", Value = "King", Description = "Unlocks the King title"},
	{Name = "Dragon Gift", Cost = 20000, Type = "pet", Value = "Dragon", Description = "Gives you a free Dragon"},
}

local WORLDS = {
	{Name = "Normal", Index = 1, UnlockCost = 0, CoinMultiplier = 1},
	{Name = "Desert", Index = 2, UnlockCost = 5000, CoinMultiplier = 2},
	{Name = "Ice Kingdom", Index = 3, UnlockCost = 50000, CoinMultiplier = 3},
	{Name = "Shadow Realm", Index = 4, UnlockCost = 500000, CoinMultiplier = 5},
	{Name = "Celestial", Index = 5, UnlockCost = 5000000, CoinMultiplier = 10},
	{Name = "Infinite Void", Index = 6, UnlockCost = 100000000, CoinMultiplier = 25},
}

local playerData = {}

local function getData(player)
	if not playerData[player] then
		playerData[player] = {
			Coins = 0, TotalCoinsEarned = 0,
			clickPower = 1, autoPerSecond = 0, clickLevel = 1, autoLevel = 1,
			Rebirths = 0,
			CurrentWorld = 1, UnlockedWorlds = {1},
			Pets = {}, Equipped = {},
			Buffs = {}, Titles = {}, CurrentTitle = "None",
			clickBuff = 1, autoBuff = 1, rebirthBuff = 1,
			MaxRebirthsPerPurchase = 1,
		}
	end
	return playerData[player]
end

local function getClickCost(level) return 25 + (level - 1) * 25 end
local function getAutoCost(level) return 50 + (level - 1) * 40 end
local function getRebirthCost(rebirthCount) return 50000 * (rebirthCount + 1) end
local function getRebirthMaxCost(currentMax) return 100000 * (currentMax ^ 1.5) end

local function worldMult(index)
	for _, w in ipairs(WORLDS) do
		if w.Index == index then return w.CoinMultiplier end
	end
	return 1
end

local function petBonuses(data)
	local c, a = 0, 0
	for i, name in ipairs(data.Pets) do
		if data.Equipped[i] then
			c += PETS[name].Click
			a += PETS[name].Auto
		end
	end
	return c, a
end

local function rebirthBoost(data)
	return 1 + data.Rebirths * 0.15 * data.rebirthBuff
end

local function calcClick(data)
	local pc = petBonuses(data)
	return math.floor(data.clickPower * worldMult(data.CurrentWorld) * rebirthBoost(data) * data.clickBuff + pc)
end

local function calcAuto(data)
	local _, pa = petBonuses(data)
	return math.floor(data.autoPerSecond * worldMult(data.CurrentWorld) * rebirthBoost(data) * data.autoBuff + pa)
end

local function equippedCount(data)
	local n = 0
	for _, v in pairs(data.Equipped) do if v then n += 1 end end
	return n
end

local function updateLeaderstats(player, data)
	local ls = player:FindFirstChild("leaderstats")
	if not ls then return end
	ls.Coins.Value = data.Coins
	ls.Rebirths.Value = data.Rebirths
	ls.Title.Value = data.CurrentTitle
end

local function pushCoins(player, data)
	updateLeaderstats(player, data)
	remote:FireClient(player, "Coins", {
		Coins = data.Coins,
		TotalCoinsEarned = data.TotalCoinsEarned,
		clickPower = calcClick(data),
		autoPerSecond = calcAuto(data),
	})
end

local function syncClient(player)
	local data = getData(player)
	updateLeaderstats(player, data)

	local worlds = {}
	for _, w in ipairs(WORLDS) do
		table.insert(worlds, {Name = w.Name, Index = w.Index, UnlockCost = w.UnlockCost,
			CoinMultiplier = w.CoinMultiplier, Unlocked = table.find(data.UnlockedWorlds, w.Index) ~= nil})
	end

	local pets = {}
	for i, name in ipairs(data.Pets) do
		table.insert(pets, {Name = name, Rarity = PETS[name].Rarity, Click = PETS[name].Click,
			Auto = PETS[name].Auto, Equipped = data.Equipped[i] == true})
	end

	local eggs = {}
	for _, egg in ipairs(EGGS) do
		local total = 0
		for _, p in ipairs(egg.Pets) do total += p[2] end
		local odds = {}
		for _, p in ipairs(egg.Pets) do
			table.insert(odds, p[1] .. " " .. math.floor(p[2] / total * 100 + 0.5) .. "%")
		end
		table.insert(eggs, {Name = egg.Name, Cost = egg.Cost, Odds = table.concat(odds, " • ")})
	end

	local buffs = {}
	for _, b in ipairs(BUFFS) do
		table.insert(buffs, {Name = b.Name, Cost = b.Cost, Description = b.Description,
			Owned = table.find(data.Buffs, b.Name) ~= nil})
	end

	remote:FireClient(player, "Sync", {
		Coins = data.Coins, TotalCoinsEarned = data.TotalCoinsEarned,
		clickPower = calcClick(data), autoPerSecond = calcAuto(data),
		clickCost = getClickCost(data.clickLevel), autoCost = getAutoCost(data.autoLevel),
		Rebirths = data.Rebirths,
		CurrentWorld = data.CurrentWorld, CurrentTitle = data.CurrentTitle,
		Worlds = worlds, Pets = pets, Eggs = eggs, Buffs = buffs,
		MaxEquipped = MAX_EQUIPPED, EquippedCount = equippedCount(data),
		Titles = data.Titles,
		MaxRebirthsPerPurchase = data.MaxRebirthsPerPurchase,
		MaxRebirthUpgradeCost = getRebirthMaxCost(data.MaxRebirthsPerPurchase),
	})
end

local function createLeaderstats(player)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = player
	for _, info in ipairs({{"Title", "StringValue", "None"}, {"Rebirths", "IntValue", 0}, {"Coins", "IntValue", 0}}) do
		local v = Instance.new(info[2])
		v.Name = info[1]
		v.Value = info[3]
		v.Parent = ls
	end
end

local function addPet(data, name)
	table.insert(data.Pets, name)
	local idx = #data.Pets
	if equippedCount(data) < MAX_EQUIPPED then
		data.Equipped[idx] = true
	end
end

local function rollEgg(egg)
	local total = 0
	for _, p in ipairs(egg.Pets) do total += p[2] end
	local roll = rng:NextNumber() * total
	for _, p in ipairs(egg.Pets) do
		roll -= p[2]
		if roll <= 0 then return p[1] end
	end
	return egg.Pets[1][1]
end

Players.PlayerAdded:Connect(function(player)
	createLeaderstats(player)
	local data = getData(player)
	syncClient(player)

	task.spawn(function()
		while player.Parent do
			task.wait(1)
			local gain = calcAuto(data)
			if gain > 0 then
				data.Coins += gain
				data.TotalCoinsEarned += gain
				pushCoins(player, data)
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player] = nil
end)

remote.OnServerEvent:Connect(function(player, action, arg)
	local data = getData(player)

	local function spend(cost)
		if data.Coins >= cost then
			data.Coins -= cost
			return true
		end
		return false
	end

	if action == "RequestSync" then
		syncClient(player)

	elseif action == "Click" then
		local p = calcClick(data)
		data.Coins += p
		data.TotalCoinsEarned += p
		pushCoins(player, data)

	elseif action == "UpgradeClick" then
		if spend(getClickCost(data.clickLevel)) then
			data.clickPower += 1
			data.clickLevel += 1
			syncClient(player)
		end

	elseif action == "UpgradeAuto" then
		if spend(getAutoCost(data.autoLevel)) then
			data.autoPerSecond += 1
			data.autoLevel += 1
			syncClient(player)
		end

	elseif action == "HatchEgg" then
		if typeof(arg) ~= "string" or #data.Pets >= MAX_PETS then return end
		for _, egg in ipairs(EGGS) do
			if egg.Name == arg then
				if spend(egg.Cost) then
					local petName = rollEgg(egg)
					addPet(data, petName)
					remote:FireClient(player, "Hatched", petName, PETS[petName].Rarity)
					syncClient(player)
				end
				break
			end
		end

	elseif action == "TogglePet" then
		if typeof(arg) ~= "number" then return end
		local idx = math.floor(arg)
		if not data.Pets[idx] then return end
		if data.Equipped[idx] then
			data.Equipped[idx] = nil
		elseif equippedCount(data) < MAX_EQUIPPED then
			data.Equipped[idx] = true
		end
		syncClient(player)

	elseif action == "BuyBuff" then
		if typeof(arg) ~= "string" or table.find(data.Buffs, arg) then return end
		for _, b in ipairs(BUFFS) do
			if b.Name == arg then
				if spend(b.Cost) then
					table.insert(data.Buffs, b.Name)
					if b.Type == "click" then data.clickBuff *= b.Value
					elseif b.Type == "auto" then data.autoBuff *= b.Value
					elseif b.Type == "rebirth" then data.rebirthBuff *= b.Value
					elseif b.Type == "title" then
						table.insert(data.Titles, b.Value)
						data.CurrentTitle = b.Value
					elseif b.Type == "pet" then
						addPet(data, b.Value)
					end
					syncClient(player)
				end
				break
			end
		end

	elseif action == "UnlockWorld" then
		if typeof(arg) ~= "number" or table.find(data.UnlockedWorlds, arg) then return end
		for _, w in ipairs(WORLDS) do
			if w.Index == arg then
				if spend(w.UnlockCost) then
					table.insert(data.UnlockedWorlds, w.Index)
					syncClient(player)
				end
				break
			end
		end

	elseif action == "ChangeWorld" then
		if typeof(arg) == "number" and table.find(data.UnlockedWorlds, arg) then
			data.CurrentWorld = arg
			syncClient(player)
		end

	elseif action == "SetTitle" then
		if typeof(arg) == "string" and table.find(data.Titles, arg) then
			data.CurrentTitle = arg
			syncClient(player)
		end

	elseif action == "BuyRebirths" then
		if typeof(arg) ~= "number" or arg < 1 or arg > data.MaxRebirthsPerPurchase then return end
		local totalCost = 0
		for i = 1, arg do
			totalCost += getRebirthCost(data.Rebirths + i - 1)
		end
		if spend(totalCost) then
			for i = 1, arg do
				data.Rebirths += 1
				data.Coins = 0
				data.TotalCoinsEarned = 0
				data.clickPower, data.autoPerSecond = 1, 0
				data.clickLevel, data.autoLevel = 1, 1
				data.CurrentWorld = 1
				data.UnlockedWorlds = {1}
			end
			syncClient(player)
		end

	elseif action == "UpgradeMaxRebirths" then
		if data.MaxRebirthsPerPurchase >= 25 then return end
		local cost = getRebirthMaxCost(data.MaxRebirthsPerPurchase)
		if spend(cost) then
			data.MaxRebirthsPerPurchase += 1
			syncClient(player)
		end
	end
end)
