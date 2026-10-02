-- StarterPlayer > StarterPlayerScripts > ClickerGameClient.lua
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage:WaitForChild("ClickerRemote")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 980, 0, 620)
mainFrame.Position = UDim2.new(0.5, -490, 0.5, -310)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 29)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 42)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Clicker Empire"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = mainFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(0, 260, 0, 30)
coinLabel.Position = UDim2.new(0, 20, 0, 62)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = "Coins: 0"
coinLabel.TextColor3 = Color3.fromRGB(255, 215, 90)
coinLabel.Font = Enum.Font.GothamSemibold
coinLabel.TextSize = 22
coinLabel.Parent = mainFrame

local rebirthLabel = Instance.new("TextLabel")
rebirthLabel.Size = UDim2.new(0, 180, 0, 24)
rebirthLabel.Position = UDim2.new(0, 300, 0, 64)
rebirthLabel.BackgroundTransparency = 1
rebirthLabel.Text = "Rebirths: 0"
rebirthLabel.TextColor3 = Color3.fromRGB(200, 170, 255)
rebirthLabel.Font = Enum.Font.GothamSemibold
rebirthLabel.TextSize = 18
rebirthLabel.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 0, 24)
titleLabel.Position = UDim2.new(0, 500, 0, 64)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Title: None"
titleLabel.TextColor3 = Color3.fromRGB(120, 220, 160)
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

local clickLabel = Instance.new("TextLabel")
clickLabel.Size = UDim2.new(0, 220, 0, 24)
clickLabel.Position = UDim2.new(0, 20, 0, 100)
clickLabel.BackgroundTransparency = 1
clickLabel.Text = "Per Click: 1"
clickLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
clickLabel.Font = Enum.Font.Gotham
clickLabel.TextSize = 18
clickLabel.Parent = mainFrame

local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(0, 220, 0, 24)
autoLabel.Position = UDim2.new(0, 20, 0, 128)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "Auto / sec: 0"
autoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
autoLabel.Font = Enum.Font.Gotham
autoLabel.TextSize = 18
autoLabel.Parent = mainFrame

local worldLabel = Instance.new("TextLabel")
worldLabel.Size = UDim2.new(0, 220, 0, 24)
worldLabel.Position = UDim2.new(0, 300, 0, 100)
worldLabel.BackgroundTransparency = 1
worldLabel.Text = "World: Normal"
worldLabel.TextColor3 = Color3.fromRGB(110, 220, 140)
worldLabel.Font = Enum.Font.Gotham
worldLabel.TextSize = 18
worldLabel.Parent = mainFrame

local totalLabel = Instance.new("TextLabel")
totalLabel.Size = UDim2.new(0, 220, 0, 24)
totalLabel.Position = UDim2.new(0, 300, 0, 128)
totalLabel.BackgroundTransparency = 1
totalLabel.Text = "Total Earned: 0"
totalLabel.TextColor3 = Color3.fromRGB(120, 200, 255)
totalLabel.Font = Enum.Font.Gotham
totalLabel.TextSize = 18
totalLabel.Parent = mainFrame

local clickButton = Instance.new("TextButton")
clickButton.Size = UDim2.new(0, 220, 0, 120)
clickButton.Position = UDim2.new(0.5, -110, 0, 170)
clickButton.Text = "CLICK!"
clickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clickButton.Font = Enum.Font.GothamBold
clickButton.TextSize = 30
clickButton.BackgroundColor3 = Color3.fromRGB(70, 180, 110)
clickButton.Parent = mainFrame

local clickButtonCorner = Instance.new("UICorner")
clickButtonCorner.CornerRadius = UDim.new(0, 18)
clickButtonCorner.Parent = clickButton

local upgradeClick = Instance.new("TextButton")
upgradeClick.Size = UDim2.new(0, 180, 0, 48)
upgradeClick.Position = UDim2.new(0, 20, 1, -98)
upgradeClick.Text = "Upgrade Click"
upgradeClick.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeClick.Font = Enum.Font.GothamSemibold
upgradeClick.TextSize = 16
upgradeClick.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
upgradeClick.Parent = mainFrame

local upgradeAuto = Instance.new("TextButton")
upgradeAuto.Size = UDim2.new(0, 180, 0, 48)
upgradeAuto.Position = UDim2.new(0.5, -90, 1, -98)
upgradeAuto.Text = "Upgrade Auto"
upgradeAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeAuto.Font = Enum.Font.GothamSemibold
upgradeAuto.TextSize = 16
upgradeAuto.BackgroundColor3 = Color3.fromRGB(255, 122, 80)
upgradeAuto.Parent = mainFrame

local rebirthButton = Instance.new("TextButton")
rebirthButton.Size = UDim2.new(0, 180, 0, 48)
rebirthButton.Position = UDim2.new(1, -200, 1, -98)
rebirthButton.Text = "Rebirth"
rebirthButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rebirthButton.Font = Enum.Font.GothamSemibold
rebirthButton.TextSize = 16
rebirthButton.BackgroundColor3 = Color3.fromRGB(170, 110, 255)
rebirthButton.Parent = mainFrame

local worldPanel = Instance.new("ScrollingFrame")
worldPanel.Size = UDim2.new(0, 450, 0, 140)
worldPanel.Position = UDim2.new(0, 20, 0, 310)
worldPanel.BackgroundColor3 = Color3.fromRGB(42, 45, 56)
worldPanel.BorderSizePixel = 0
worldPanel.ScrollBarThickness = 6
worldPanel.Parent = mainFrame

local worldCorner = Instance.new("UICorner")
worldCorner.CornerRadius = UDim.new(0, 12)
worldCorner.Parent = worldPanel

local petPanel = Instance.new("ScrollingFrame")
petPanel.Size = UDim2.new(0, 450, 0, 200)
petPanel.Position = UDim2.new(0, 500, 0, 310)
petPanel.BackgroundColor3 = Color3.fromRGB(42, 45, 56)
petPanel.BorderSizePixel = 0
petPanel.ScrollBarThickness = 6
petPanel.Parent = mainFrame

local petCorner = Instance.new("UICorner")
petCorner.CornerRadius = UDim.new(0, 12)
petCorner.Parent = petPanel

local buffPanel = Instance.new("ScrollingFrame")
buffPanel.Size = UDim2.new(0, 930, 0, 160)
buffPanel.Position = UDim2.new(0, 20, 0, 145)
buffPanel.BackgroundColor3 = Color3.fromRGB(42, 45, 56)
buffPanel.BorderSizePixel = 0
buffPanel.ScrollBarThickness = 6
buffPanel.Visible = false
buffPanel.Parent = mainFrame

local buffCorner = Instance.new("UICorner")
buffCorner.CornerRadius = UDim.new(0, 12)
buffCorner.Parent = buffPanel

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 280, 0, 32)
tabBar.Position = UDim2.new(0.5, -140, 0, 150)
tabBar.BackgroundColor3 = Color3.fromRGB(54, 58, 68)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabBar

local buttonShop = Instance.new("TextButton")
buttonShop.Size = UDim2.new(0, 140, 1, 0)
buttonShop.Position = UDim2.new(0, 0, 0, 0)
buttonShop.BackgroundColor3 = Color3.fromRGB(75, 142, 255)
buttonShop.Text = "Shop"
buttonShop.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonShop.Font = Enum.Font.GothamSemibold
buttonShop.TextSize = 16
buttonShop.Parent = tabBar

local buttonWorlds = Instance.new("TextButton")
buttonWorlds.Size = UDim2.new(0, 140, 1, 0)
buttonWorlds.Position = UDim2.new(0, 140, 0, 0)
buttonWorlds.BackgroundColor3 = Color3.fromRGB(84, 90, 110)
buttonWorlds.Text = "Worlds"
buttonWorlds.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonWorlds.Font = Enum.Font.GothamSemibold
buttonWorlds.TextSize = 16
buttonWorlds.Parent = tabBar

local function hideAllPanels()
    buffPanel.Visible = false
    worldPanel.Visible = false
    petPanel.Visible = false
end

buttonShop.MouseButton1Click:Connect(function()
    hideAllPanels()
    buffPanel.Visible = true
end)

buttonWorlds.MouseButton1Click:Connect(function()
    hideAllPanels()
    worldPanel.Visible = true
    petPanel.Visible = true
end)

local templateButton = Instance.new("TextButton")
templateButton.Size = UDim2.new(0, 200, 0, 76)
templateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
templateButton.BorderSizePixel = 0
templateButton.Text = ""
templateButton.Visible = false
templateButton.Parent = buffPanel

local templateCorner = Instance.new("UICorner")
templateCorner.CornerRadius = UDim.new(0, 10)
templateCorner.Parent = templateButton

local itemTitle = Instance.new("TextLabel")
itemTitle.Name = "ItemTitle"
itemTitle.Size = UDim2.new(1, -12, 0, 22)
itemTitle.Position = UDim2.new(0, 6, 0, 8)
itemTitle.BackgroundTransparency = 1
itemTitle.Text = "Buff"
itemTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
itemTitle.Font = Enum.Font.GothamBold
itemTitle.TextSize = 15
itemTitle.Parent = templateButton

local itemDesc = Instance.new("TextLabel")
itemDesc.Name = "ItemDesc"
itemDesc.Size = UDim2.new(1, -12, 0, 18)
itemDesc.Position = UDim2.new(0, 6, 0, 30)
itemDesc.BackgroundTransparency = 1
itemDesc.Text = "Desc"
itemDesc.TextColor3 = Color3.fromRGB(210, 210, 210)
itemDesc.Font = Enum.Font.Gotham
itemDesc.TextSize = 12
itemDesc.Parent = templateButton

local itemCost = Instance.new("TextLabel")
itemCost.Name = "ItemCost"
itemCost.Size = UDim2.new(1, -12, 0, 18)
itemCost.Position = UDim2.new(0, 6, 0, 52)
itemCost.BackgroundTransparency = 1
itemCost.Text = "Cost: 0"
itemCost.TextColor3 = Color3.fromRGB(255, 210, 80)
itemCost.Font = Enum.Font.GothamSemibold
itemCost.TextSize = 12
itemCost.Parent = templateButton

local worldTemplate = Instance.new("TextButton")
worldTemplate.Size = UDim2.new(0, 150, 0, 60)
worldTemplate.BackgroundColor3 = Color3.fromRGB(65, 70, 90)
worldTemplate.BorderSizePixel = 0
worldTemplate.Text = ""
worldTemplate.Visible = false
worldTemplate.Parent = worldPanel

local worldTemplateCorner = Instance.new("UICorner")
worldTemplateCorner.CornerRadius = UDim.new(0, 10)
worldTemplateCorner.Parent = worldTemplate

local worldName = Instance.new("TextLabel")
worldName.Name = "WorldName"
worldName.Size = UDim2.new(1, -10, 0, 18)
worldName.Position = UDim2.new(0, 5, 0, 8)
worldName.BackgroundTransparency = 1
worldName.Text = "World"
worldName.TextColor3 = Color3.fromRGB(255, 255, 255)
worldName.Font = Enum.Font.GothamBold
worldName.TextSize = 13
worldName.Parent = worldTemplate

local worldCost = Instance.new("TextLabel")
worldCost.Name = "WorldCost"
worldCost.Size = UDim2.new(1, -10, 0, 16)
worldCost.Position = UDim2.new(0, 5, 0, 30)
worldCost.BackgroundTransparency = 1
worldCost.Text = "Cost: 0"
worldCost.TextColor3 = Color3.fromRGB(155, 208, 255)
worldCost.Font = Enum.Font.Gotham
worldCost.TextSize = 11
worldCost.Parent = worldTemplate

local petTemplate = Instance.new("TextButton")
petTemplate.Size = UDim2.new(0, 190, 0, 70)
petTemplate.BackgroundColor3 = Color3.fromRGB(80, 82, 92)
petTemplate.BorderSizePixel = 0
petTemplate.Text = ""
petTemplate.Visible = false
petTemplate.Parent = petPanel

local petTemplateCorner = Instance.new("UICorner")
petTemplateCorner.CornerRadius = UDim.new(0, 10)
petTemplateCorner.Parent = petTemplate

local petName = Instance.new("TextLabel")
petName.Name = "PetName"
petName.Size = UDim2.new(1, -12, 0, 18)
petName.Position = UDim2.new(0, 6, 0, 8)
petName.BackgroundTransparency = 1
petName.Text = "Pet"
petName.TextColor3 = Color3.fromRGB(255, 255, 255)
petName.Font = Enum.Font.GothamBold
petName.TextSize = 14
petName.Parent = petTemplate

local petMeta = Instance.new("TextLabel")
petMeta.Name = "PetMeta"
petMeta.Size = UDim2.new(1, -12, 0, 16)
petMeta.Position = UDim2.new(0, 6, 0, 28)
petMeta.BackgroundTransparency = 1
petMeta.Text = "Cost: 0"
petMeta.TextColor3 = Color3.fromRGB(220, 220, 220)
petMeta.Font = Enum.Font.Gotham
petMeta.TextSize = 11
petMeta.Parent = petTemplate

local petState = Instance.new("TextLabel")
petState.Name = "PetState"
petState.Size = UDim2.new(1, -12, 0, 16)
petState.Position = UDim2.new(0, 6, 0, 46)
petState.BackgroundTransparency = 1
petState.Text = "Owned"
petState.TextColor3 = Color3.fromRGB(110, 220, 140)
petState.Font = Enum.Font.GothamSemibold
petState.TextSize = 11
petState.Parent = petTemplate

local function refreshWorlds(data)
    for _, child in ipairs(worldPanel:GetChildren()) do
        if child:IsA("TextButton") and child ~= worldTemplate then
            child:Destroy()
        end
    end

    local xOffset = 10
    for _, world in ipairs(data.UnlockedWorlds or {}) do
        local clone = worldTemplate:Clone()
        clone.Visible = true
        clone.Position = UDim2.new(0, xOffset, 0, 12)
        clone.Parent = worldPanel

        local nameLabel = clone:FindFirstChild("WorldName")
        if nameLabel then
            nameLabel.Text = world.Name
        end

        local costLabel = clone:FindFirstChild("WorldCost")
        if costLabel then
            if world.Index == data.CurrentWorld then
                costLabel.Text = "Current"
                costLabel.TextColor3 = Color3.fromRGB(110, 220, 140)
                clone.BackgroundColor3 = Color3.fromRGB(45, 80, 56)
            else
                costLabel.Text = "Use"
                costLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
                clone.BackgroundColor3 = Color3.fromRGB(65, 70, 90)
            end
        end

        clone.MouseButton1Click:Connect(function()
            if world.Index ~= data.CurrentWorld then
                remote:FireServer("ChangeWorld", world.Index)
            end
        end)

        xOffset += 160
    end
end

local function refreshPets(data)
    for _, child in ipairs(petPanel:GetChildren()) do
        if child:IsA("TextButton") and child ~= petTemplate then
            child:Destroy()
        end
    end

    local xOffset = 10
    local yOffset = 10
    local count = 0

    for _, pet in ipairs(data.AvailablePets or {}) do
        local clone = petTemplate:Clone()
        clone.Visible = true
        clone.Position = UDim2.new(0, xOffset + (count % 2) * 200, 0, yOffset + math.floor(count / 2) * 80)
        clone.Parent = petPanel

        local nameLabel = clone:FindFirstChild("PetName")
        if nameLabel then
            nameLabel.Text = pet.Name
        end

        local metaLabel = clone:FindFirstChild("PetMeta")
        if metaLabel then
            metaLabel.Text = "+" .. tostring(pet.ClickBonus) .. " Click | +" .. tostring(pet.AutoBonus) .. " Auto"
        end

        local stateLabel = clone:FindFirstChild("PetState")
        if stateLabel then
            if pet.Owned then
                stateLabel.Text = "Owned"
                stateLabel.TextColor3 = Color3.fromRGB(110, 220, 140)
                clone.BackgroundColor3 = Color3.fromRGB(50, 80, 58)
            else
                stateLabel.Text = "Buy: " .. tostring(pet.Cost)
                stateLabel.TextColor3 = Color3.fromRGB(255, 210, 80)
                clone.BackgroundColor3 = Color3.fromRGB(80, 82, 92)
            end
        end

        clone.MouseButton1Click:Connect(function()
            if not pet.Owned then
                remote:FireServer("BuyPet", pet.Name)
            end
        end)

        count += 1
    end
end

local function refreshBuffs(data)
    for _, child in ipairs(buffPanel:GetChildren()) do
        if child:IsA("TextButton") and child ~= templateButton then
            child:Destroy()
        end
    end

    local xOffset = 10
    local yOffset = 10
    local count = 0

    for _, buff in ipairs(data.AvailableBuffs or {}) do
        local clone = templateButton:Clone()
        clone.Visible = true
        clone.Position = UDim2.new(0, xOffset + (count % 4) * 220, 0, yOffset + math.floor(count / 4) * 82)
        clone.Parent = buffPanel

        local titleText = clone:FindFirstChild("ItemTitle")
        if titleText then
            titleText.Text = buff.Name
        end

        local descText = clone:FindFirstChild("ItemDesc")
        if descText then
            descText.Text = buff.Description
        end

        local costText = clone:FindFirstChild("ItemCost")
        if costText then
            if buff.Owned then
                costText.Text = "Owned"
                costText.TextColor3 = Color3.fromRGB(110, 220, 140)
                clone.BackgroundColor3 = Color3.fromRGB(42, 70, 50)
            else
                costText.Text = "Cost: " .. tostring(buff.Cost)
                costText.TextColor3 = Color3.fromRGB(255, 210, 80)
                clone.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            end
        end

        clone.MouseButton1Click:Connect(function()
            if not buff.Owned then
                remote:FireServer("BuyBuff", buff.Name)
            end
        end)

        count += 1
    end
end

remote.OnClientEvent:Connect(function(type, data)
    if type ~= "Sync" then
        return
    end

    coinLabel.Text = "Coins: " .. tostring(data.Coins)
    clickLabel.Text = "Per Click: " .. tostring(data.clickPower)
    autoLabel.Text = "Auto / sec: " .. tostring(data.autoPerSecond)
    rebirthLabel.Text = "Rebirths: " .. tostring(data.Rebirths)
    titleLabel.Text = "Title: " .. tostring(data.CurrentTitle)
    worldLabel.Text = "World: " .. tostring(data.CurrentWorld)
    totalLabel.Text = "Total Earned: " .. tostring(data.TotalCoinsEarned)

    if data.clickCost then
        upgradeClick.Text = "Upgrade Click\nCost: " .. tostring(data.clickCost)
    end

    if data.autoCost then
        upgradeAuto.Text = "Upgrade Auto\nCost: " .. tostring(data.autoCost)
    end

    refreshWorlds(data)
    refreshPets(data)
    refreshBuffs(data)
end)

clickButton.MouseButton1Click:Connect(function()
    remote:FireServer("Click")
end)

upgradeClick.MouseButton1Click:Connect(function()
    remote:FireServer("UpgradeClick")
end)

upgradeAuto.MouseButton1Click:Connect(function()
    remote:FireServer("UpgradeAuto")
end)

rebirthButton.MouseButton1Click:Connect(function()
    remote:FireServer("Rebirth")
end)

remote:FireServer("RequestSync")
