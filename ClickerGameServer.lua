-- ServerScriptService > ClickerGameServer.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("ClickerRemote")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "ClickerRemote"
    remote.Parent = ReplicatedStorage
end

local PETS = {
    {Name = "Cat", Cost = 100, ClickBonus = 2, AutoBonus = 0.5, Rarity = "Common"},
    {Name = "Dog", Cost = 250, ClickBonus = 4, AutoBonus = 1, Rarity = "Common"},
    {Name = "Dragon", Cost = 1000, ClickBonus = 10, AutoBonus = 5, Rarity = "Rare"},
    {Name = "Phoenix", Cost = 5000, ClickBonus = 25, AutoBonus = 15, Rarity = "Rare"},
    {Name = "Unicorn", Cost = 15000, ClickBonus = 50, AutoBonus = 30, Rarity = "Epic"},
    {Name = "Shadow Beast", Cost = 50000, ClickBonus = 100, AutoBonus = 75, Rarity = "Epic"},
    {Name = "God Slayer", Cost = 200000, ClickBonus = 250, AutoBonus = 200, Rarity = "Legendary"}
}

local BUFFS = {
    {Name = "Golden Touch", Cost = 5000, Type = "click", Value = 1.15, Description = "+15% click power"},
    {Name = "Turbo Engine", Cost = 12000, Type = "auto", Value = 1.2, Description = "+20% auto income"},
    {Name = "Rebirth Boost", Cost = 25000, Type = "rebirth", Value = 1.25, Description = "+25% stronger rebirths"},
    {Name = "Lucky Title", Cost = 1500, Type = "title", Value = "Lucky", Description = "Title unlocked: Lucky"},
    {Name = "King Title", Cost = 5000, Type = "title", Value = "King", Description = "Title unlocked: King"},
    {Name = "Legendary Egg", Cost = 20000, Type = "pet", Value = "Dragon", Description = "Unlocks Dragon pet"}
}

local WORLDS = {
    {Name = "Normal", Index = 1, UnlockCost = 0, CoinMultiplier = 1},
    {Name = "Desert", Index = 2, UnlockCost = 5000, CoinMultiplier = 2},
    {Name = "Ice Kingdom", Index = 3, UnlockCost = 50000, CoinMultiplier = 3},
    {Name = "Shadow Realm", Index = 4, UnlockCost = 500000, CoinMultiplier = 5},
    {Name = "Celestial", Index = 5, UnlockCost = 5000000, CoinMultiplier = 10},
    {Name = "Infinite Void", Index = 6, UnlockCost = 100000000, CoinMultiplier = 25}
}

local playerData = {}

local function getPetInfo(petName)
    for _, pet in ipairs(PETS) do
        if pet.Name == petName then
            return pet
        end
    end
    return nil
end

local function getBuffInfo(buffName)
    for _, buff in ipairs(BUFFS) do
        if buff.Name == buffName then
            return buff
        end
    end
    return nil
end

local function getData(player)
    if not playerData[player] then
        playerData[player] = {
            Coins = 0,
            clickPower = 1,
            autoPerSecond = 0,
            clickLevel = 1,
            autoLevel = 1,
            Rebirths = 0,
            TotalCoinsEarned = 0,
            CurrentWorld = 1,
            UnlockedWorlds = {1},
            Pets = {},
            PetClickBonus = 0,
            PetAutoBonus = 0,
            Buffs = {},
            Titles = {},
            CurrentTitle = "None",
            clickBuffMultiplier = 1,
            autoBuffMultiplier = 1,
            rebirthBuffMultiplier = 1
        }
    end
    return playerData[player]
end

local function getClickCost(level)
    return 25 + (level - 1) * 25
end

local function getAutoCost(level)
    return 50 + (level - 1) * 40
end

local function getWorldMultiplier(worldIndex)
    for _, world in ipairs(WORLDS) do
        if world.Index == worldIndex then
            return world.CoinMultiplier
        end
    end
    return 1
end

local function calculateClickPower(data)
    local baseClick = data.clickPower
    local rebirthBoost = 1 + (data.Rebirths * 0.15)
    local worldMult = getWorldMultiplier(data.CurrentWorld)
    return (baseClick * worldMult * rebirthBoost * data.clickBuffMultiplier) + data.PetClickBonus
end

local function calculateAutoPerSec(data)
    local baseAuto = data.autoPerSecond
    local rebirthBoost = 1 + (data.Rebirths * 0.2)
    local worldMult = getWorldMultiplier(data.CurrentWorld)
    return (baseAuto * worldMult * rebirthBoost * data.autoBuffMultiplier) + data.PetAutoBonus
end

local function syncClient(player)
    local data = getData(player)
    local unlockedWorlds = {}

    for _, worldIdx in ipairs(data.UnlockedWorlds) do
        for _, world in ipairs(WORLDS) do
            if world.Index == worldIdx then
                table.insert(unlockedWorlds, world)
            end
        end
    end

    local availablePets = {}
    for _, pet in ipairs(PETS) do
        table.insert(availablePets, {
            Name = pet.Name,
            Cost = pet.Cost,
            ClickBonus = pet.ClickBonus,
            AutoBonus = pet.AutoBonus,
            Rarity = pet.Rarity,
            Owned = table.find(data.Pets, pet.Name) ~= nil
        })
    end

    local availableBuffs = {}
    for _, buff in ipairs(BUFFS) do
        table.insert(availableBuffs, {
            Name = buff.Name,
            Cost = buff.Cost,
            Type = buff.Type,
            Value = buff.Value,
            Description = buff.Description,
            Owned = table.find(data.Buffs, buff.Name) ~= nil
        })
    end

    remote:FireClient(player, "Sync", {
        Coins = data.Coins,
        clickPower = calculateClickPower(data),
        autoPerSecond = calculateAutoPerSec(data),
        clickCost = getClickCost(data.clickLevel),
        autoCost = getAutoCost(data.autoLevel),
        clickLevel = data.clickLevel,
        autoLevel = data.autoLevel,
        Rebirths = data.Rebirths,
        TotalCoinsEarned = data.TotalCoinsEarned,
        CurrentWorld = data.CurrentWorld,
        CurrentTitle = data.CurrentTitle,
        UnlockedWorlds = unlockedWorlds,
        AvailablePets = availablePets,
        OwnedPets = data.Pets,
        PetClickBonus = data.PetClickBonus,
        PetAutoBonus = data.PetAutoBonus,
        AvailableBuffs = availableBuffs,
        OwnedBuffs = data.Buffs,
        Titles = data.Titles,
        clickBuffMultiplier = data.clickBuffMultiplier,
        autoBuffMultiplier = data.autoBuffMultiplier,
        rebirthBuffMultiplier = data.rebirthBuffMultiplier
    })
end

local function createLeaderstats(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats

    local rebirths = Instance.new("IntValue")
    rebirths.Name = "Rebirths"
    rebirths.Value = 0
    rebirths.Parent = leaderstats

    local titleValue = Instance.new("StringValue")
    titleValue.Name = "Title"
    titleValue.Value = "None"
    titleValue.Parent = leaderstats

    return coins, rebirths, titleValue
end

Players.PlayerAdded:Connect(function(player)
    local coinsStats, rebirtStats, titleStat = createLeaderstats(player)
    local data = getData(player)

    local function updateDisplay()
        coinsStats.Value = data.Coins
        rebirtStats.Value = data.Rebirths
        titleStat.Value = data.CurrentTitle
    end

    updateDisplay()

    task.spawn(function()
        while player.Parent do
            local d = getData(player)
            local autoPerSec = calculateAutoPerSec(d)
            if autoPerSec > 0 then
                d.Coins += math.floor(autoPerSec)
                d.TotalCoinsEarned += math.floor(autoPerSec)
                updateDisplay()
                syncClient(player)
            end
            task.wait(1)
        end
    end)

    syncClient(player)
end)

Players.PlayerRemoving:Connect(function(player)
    playerData[player] = nil
end)

remote.OnServerEvent:Connect(function(player, action, ...)
    local data = getData(player)
    local args = {...}

    if action == "RequestSync" then
        syncClient(player)
        return
    end

    if action == "Click" then
        local clickPower = calculateClickPower(data)
        data.Coins += clickPower
        data.TotalCoinsEarned += clickPower

        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats and leaderstats:FindFirstChild("Coins") then
            leaderstats.Coins.Value = data.Coins
        end
        syncClient(player)
        return
    end

    if action == "UpgradeClick" then
        local cost = getClickCost(data.clickLevel)
        if data.Coins >= cost then
            data.Coins -= cost
            data.clickPower += 1
            data.clickLevel += 1

            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats and leaderstats:FindFirstChild("Coins") then
                leaderstats.Coins.Value = data.Coins
            end
            syncClient(player)
        end
        return
    end

    if action == "UpgradeAuto" then
        local cost = getAutoCost(data.autoLevel)
        if data.Coins >= cost then
            data.Coins -= cost
            data.autoPerSecond += 1
            data.autoLevel += 1

            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats and leaderstats:FindFirstChild("Coins") then
                leaderstats.Coins.Value = data.Coins
            end
            syncClient(player)
        end
        return
    end

    if action == "BuyPet" then
        local petName = args[1]
        local pet = getPetInfo(petName)

        if pet and data.Coins >= pet.Cost then
            if not table.find(data.Pets, petName) then
                data.Coins -= pet.Cost
                table.insert(data.Pets, petName)
                data.PetClickBonus += pet.ClickBonus
                data.PetAutoBonus += pet.AutoBonus

                local leaderstats = player:FindFirstChild("leaderstats")
                if leaderstats and leaderstats:FindFirstChild("Coins") then
                    leaderstats.Coins.Value = data.Coins
                end
                syncClient(player)
            end
        end
        return
    end

    if action == "BuyBuff" then
        local buffName = args[1]
        local buff = getBuffInfo(buffName)

        if buff and data.Coins >= buff.Cost then
            if not table.find(data.Buffs, buffName) then
                data.Coins -= buff.Cost
                table.insert(data.Buffs, buffName)

                if buff.Type == "click" then
                    data.clickBuffMultiplier *= buff.Value
                elseif buff.Type == "auto" then
                    data.autoBuffMultiplier *= buff.Value
                elseif buff.Type == "rebirth" then
                    data.rebirthBuffMultiplier *= buff.Value
                elseif buff.Type == "title" then
                    if not table.find(data.Titles, buff.Value) then
                        table.insert(data.Titles, buff.Value)
                    end
                    data.CurrentTitle = buff.Value
                elseif buff.Type == "pet" then
                    local petToUnlock = getPetInfo(buff.Value)
                    if petToUnlock and not table.find(data.Pets, buff.Value) then
                        table.insert(data.Pets, buff.Value)
                        data.PetClickBonus += petToUnlock.ClickBonus
                        data.PetAutoBonus += petToUnlock.AutoBonus
                    end
                end

                local leaderstats = player:FindFirstChild("leaderstats")
                if leaderstats and leaderstats:FindFirstChild("Coins") then
                    leaderstats.Coins.Value = data.Coins
                end

                if leaderstats and leaderstats:FindFirstChild("Title") then
                    leaderstats.Title.Value = data.CurrentTitle
                end

                syncClient(player)
            end
        end
        return
    end

    if action == "UnlockWorld" then
        local worldIndex = args[1]
        local world = nil
        for _, w in ipairs(WORLDS) do
            if w.Index == worldIndex then
                world = w
                break
            end
        end

        if world and data.Coins >= world.UnlockCost and not table.find(data.UnlockedWorlds, worldIndex) then
            data.Coins -= world.UnlockCost
            table.insert(data.UnlockedWorlds, worldIndex)

            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats and leaderstats:FindFirstChild("Coins") then
                leaderstats.Coins.Value = data.Coins
            end
            syncClient(player)
        end
        return
    end

    if action == "ChangeWorld" then
        local worldIndex = args[1]
        if table.find(data.UnlockedWorlds, worldIndex) then
            data.CurrentWorld = worldIndex
            syncClient(player)
        end
        return
    end

    if action == "Rebirth" then
        if data.TotalCoinsEarned >= 100000 then
            data.Coins = 0
            data.clickPower = 1
            data.autoPerSecond = 0
            data.clickLevel = 1
            data.autoLevel = 1
            data.Rebirths += 1
            data.TotalCoinsEarned = 0
            data.CurrentWorld = 1
            data.UnlockedWorlds = {1}
            data.Pets = {}
            data.PetClickBonus = 0
            data.PetAutoBonus = 0
            data.clickBuffMultiplier = math.max(1, data.clickBuffMultiplier * data.rebirthBuffMultiplier)
            data.autoBuffMultiplier = math.max(1, data.autoBuffMultiplier * data.rebirthBuffMultiplier)

            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                if leaderstats:FindFirstChild("Coins") then
                    leaderstats.Coins.Value = 0
                end
                if leaderstats:FindFirstChild("Rebirths") then
                    leaderstats.Rebirths.Value = data.Rebirths
                end
            end
            syncClient(player)
        end
        return
    end
end)
