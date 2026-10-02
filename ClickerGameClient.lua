-- StarterPlayer > StarterPlayerScripts > ClickerGameClient (LocalScript)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("ClickerRemote")

local RARITY_COLORS = {
	Common = Color3.fromRGB(200, 200, 200),
	Rare = Color3.fromRGB(80, 160, 255),
	Epic = Color3.fromRGB(180, 90, 255),
	Legendary = Color3.fromRGB(255, 190, 40),
	Mythic = Color3.fromRGB(255, 70, 90),
	Celestial = Color3.fromRGB(138, 43, 226),
	Omnipotent = Color3.fromRGB(255, 215, 0),
}

local SUFFIXES = {"", "K", "M", "B", "T", "Qa", "Qi"}
local function fmt(n)
	n = math.floor(n or 0)
	if n < 10000 then
		return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	end
	local i = 1
	while n >= 1000 and i < #SUFFIXES do
		n /= 1000
		i += 1
	end
	return string.format("%.2f%s", n, SUFFIXES[i])
end

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end

local function round(obj, r)
	new("UICorner", {CornerRadius = UDim.new(0, r or 10)}, obj)
end

local gui = new("ScreenGui", {Name = "ClickerGui", ResetOnSpawn = false}, player:WaitForChild("PlayerGui"))

-- HUD (small, top-left)
local hud = new("Frame", {Size = UDim2.new(0, 230, 0, 112), Position = UDim2.new(0, 12, 0, 12),
	BackgroundColor3 = Color3.fromRGB(20, 22, 29), BackgroundTransparency = 0.15, BorderSizePixel = 0}, gui)
round(hud, 12)
new("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, hud)
new("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 6)}, hud)

local function hudLabel(order, color, size)
	return new("TextLabel", {Size = UDim2.new(1, -10, 0, size + 4), BackgroundTransparency = 1, LayoutOrder = order,
		TextColor3 = color, Font = Enum.Font.GothamBold, TextSize = size, TextXAlignment = Enum.TextXAlignment.Left, Text = ""}, hud)
end
local coinLabel = hudLabel(1, Color3.fromRGB(255, 215, 90), 22)
local clickLabel = hudLabel(2, Color3.new(1, 1, 1), 15)
local autoLabel = hudLabel(3, Color3.new(1, 1, 1), 15)
local infoLabel = hudLabel(4, Color3.fromRGB(190, 170, 255), 14)

-- Click button (bottom center)
local clickButton = new("TextButton", {Size = UDim2.new(0, 200, 0, 64), AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, -24), Text = "CLICK!", TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold, TextSize = 28, BackgroundColor3 = Color3.fromRGB(70, 180, 110)}, gui)
round(clickButton, 16)
clickButton.MouseButton1Click:Connect(function()
	remote:FireServer("Click")
end)

-- Hatch popup
local hatchLabel = new("TextLabel", {Size = UDim2.new(0, 420, 0, 60), AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 90), BackgroundColor3 = Color3.fromRGB(20, 22, 29), BackgroundTransparency = 0.1,
	Font = Enum.Font.GothamBold, TextSize = 24, TextColor3 = Color3.new(1, 1, 1), Visible = false, Text = ""}, gui)
round(hatchLabel, 14)
local hatchToken = 0
local function showHatch(name, rarity)
	hatchToken += 1
	local my = hatchToken
	hatchLabel.Text = "You hatched a " .. name .. "!  (" .. rarity .. ")"
	hatchLabel.TextColor3 = RARITY_COLORS[rarity] or Color3.new(1, 1, 1)
	hatchLabel.Visible = true
	task.delay(3.5, function()
		if hatchToken == my then hatchLabel.Visible = false end
	end)
end

-- Side navigation buttons (right side)
local navPanel = new("Frame", {Size = UDim2.new(0, 60, 0, 400), AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -12, 0.5, 0), BackgroundTransparency = 1}, gui)

local navButtons = {}
local MENU_TABS = {
	{Name = "Upgrades", Icon = "⚙️", Color = Color3.fromRGB(80, 120, 255)},
	{Name = "Rebirths", Icon = "♻️", Color = Color3.fromRGB(160, 100, 250)},
	{Name = "Eggs", Icon = "🥚", Color = Color3.fromRGB(60, 160, 90)},
	{Name = "Pets", Icon = "🐉", Color = Color3.fromRGB(255, 100, 100)},
	{Name = "Buffs", Icon = "⭐", Color = Color3.fromRGB(255, 190, 40)},
	{Name = "Worlds", Icon = "🌍", Color = Color3.fromRGB(100, 200, 255)},
}

local currentTab = "Upgrades"
local panelOpen = false
local PANEL_W = 350

-- Main content panel (slides from right)
local contentPanel = new("Frame", {Size = UDim2.new(0, PANEL_W, 0, 520), AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(20, 22, 29), BorderSizePixel = 0}, gui)
round(contentPanel, 14)

local contentHeader = new("TextLabel", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(44, 47, 60), BorderSizePixel = 0,
	Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.new(1, 1, 1), Text = currentTab}, contentPanel)
new("UICorner", {CornerRadius = UDim.new(0, 14)}, contentHeader)

local content = new("ScrollingFrame", {Size = UDim2.new(1, -12, 1, -54), Position = UDim2.new(0, 6, 0, 42),
	BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
	AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new()}, contentPanel)
new("UIListLayout", {Padding = UDim.new(0, 4)}, content)

local data
local GREEN, BLUE, ORANGE, PURPLE, GREY = Color3.fromRGB(60, 160, 90), Color3.fromRGB(80, 120, 255),
	Color3.fromRGB(240, 120, 70), Color3.fromRGB(160, 100, 250), Color3.fromRGB(90, 92, 105)

local function row(title, desc, btnText, color, callback, titleColor)
	local f = new("Frame", {Size = UDim2.new(1, -8, 0, 64), BackgroundColor3 = Color3.fromRGB(44, 47, 60), BorderSizePixel = 0}, content)
	round(f, 10)
	new("TextLabel", {Text = title, Size = UDim2.new(1, -102, 0, 22), Position = UDim2.new(0, 8, 0, 5), BackgroundTransparency = 1,
		TextColor3 = titleColor or Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left}, f)
	new("TextLabel", {Text = desc, Size = UDim2.new(1, -102, 0, 32), Position = UDim2.new(0, 8, 0, 27), BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(200, 200, 205), Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, f)
	local b = new("TextButton", {Text = btnText, Size = UDim2.new(0, 90, 0, 36), Position = UDim2.new(1, -96, 0.5, -18),
		BackgroundColor3 = color, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 11, TextWrapped = true}, f)
	round(b, 8)
	if callback then b.MouseButton1Click:Connect(callback) end
end

local function getRebirthCost(count)
	return 50000 * (count + 1)
end

local function render()
	for _, c in ipairs(content:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	contentHeader.Text = currentTab
	if not data then return end

	if currentTab == "Upgrades" then
		row("Upgrade Click", "+1 base click power", fmt(data.clickCost) .. " coins", BLUE, function() remote:FireServer("UpgradeClick") end)
		row("Upgrade Auto", "+1 base coins per second", fmt(data.autoCost) .. " coins", ORANGE, function() remote:FireServer("UpgradeAuto") end)

	elseif currentTab == "Rebirths" then
		row("Buy 1 Rebirth", "Cost: " .. fmt(getRebirthCost(data.Rebirths)), fmt(getRebirthCost(data.Rebirths)) .. " coins", GREEN,
			function() remote:FireServer("BuyRebirths", 1) end)
		for i = 2, math.min(data.MaxRebirthsPerPurchase, 5) do
			local total = 0
			for j = 1, i do total += getRebirthCost(data.Rebirths + j - 1) end
			row("Buy " .. i .. " Rebirths", "Get " .. i .. " rebirths at once", fmt(total) .. " coins", GREEN,
				function() remote:FireServer("BuyRebirths", i) end)
		end
		if data.MaxRebirthsPerPurchase < 25 then
			row("Upgrade Max Rebirths", "Currently: " .. data.MaxRebirthsPerPurchase .. "/25",
				"Upgrade\n" .. fmt(data.MaxRebirthUpgradeCost), PURPLE,
				function() remote:FireServer("UpgradeMaxRebirths") end)
		else
			row("Max Rebirths", "You can now buy up to 25 rebirths at once!", "MAX", GREY, nil)
		end

	elseif currentTab == "Eggs" then
		for _, egg in ipairs(data.Eggs) do
			row(egg.Name, egg.Odds, "Hatch\n" .. fmt(egg.Cost), GREEN, function() remote:FireServer("HatchEgg", egg.Name) end)
		end

	elseif currentTab == "Pets" then
		row("Equipped: " .. data.EquippedCount .. "/" .. data.MaxEquipped, "Equipped pets float around you.", "", GREY, nil)
		for i, pet in ipairs(data.Pets) do
			row(pet.Name .. " [" .. pet.Rarity .. "]", "+" .. fmt(pet.Click) .. " click  |  +" .. fmt(pet.Auto) .. " auto",
				pet.Equipped and "Unequip" or "Equip", pet.Equipped and ORANGE or GREEN,
				function() remote:FireServer("TogglePet", i) end, RARITY_COLORS[pet.Rarity])
		end

	elseif currentTab == "Buffs" then
		for _, b in ipairs(data.Buffs) do
			row(b.Name, b.Description, b.Owned and "Owned" or fmt(b.Cost) .. " coins", b.Owned and GREY or BLUE,
				function() if not b.Owned then remote:FireServer("BuyBuff", b.Name) end end)
		end
		for _, t in ipairs(data.Titles) do
			row("Title: " .. t, "Click to wear this title", t == data.CurrentTitle and "Wearing" or "Wear",
				t == data.CurrentTitle and GREY or GREEN, function() remote:FireServer("SetTitle", t) end)
		end

	elseif currentTab == "Worlds" then
		for _, w in ipairs(data.Worlds) do
			local desc = "x" .. w.CoinMultiplier .. " coin multiplier"
			if w.Unlocked then
				local here = w.Index == data.CurrentWorld
				row(w.Name, desc, here and "Current" or "Travel", here and GREY or GREEN,
					function() if not here then remote:FireServer("ChangeWorld", w.Index) end end)
			else
				row(w.Name, desc, "Unlock\n" .. fmt(w.UnlockCost), PURPLE, function() remote:FireServer("UnlockWorld", w.Index) end)
			end
		end
	end
end

for i, tab in ipairs(MENU_TABS) do
	local btn = new("TextButton", {Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Color3.fromRGB(44, 47, 60),
		Font = Enum.Font.GothamBold, TextSize = 24, TextColor3 = Color3.new(1, 1, 1), Text = tab.Icon,
		LayoutOrder = i}, navPanel)
	round(btn, 10)
	navButtons[tab.Name] = btn
	
	btn.MouseButton1Click:Connect(function()
		currentTab = tab.Name
		panelOpen = true
		for name, b in pairs(navButtons) do
			b.BackgroundColor3 = (name == tab.Name) and tab.Color or Color3.fromRGB(44, 47, 60)
		end
		TweenService:Create(contentPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quad),
			{Position = UDim2.new(1, -PANEL_W - 12, 0.5, 0)}):Play()
		render()
	end)
end

-- Close panel when clicking outside
local closeArea = new("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 0}, gui)
closeArea.MouseButton1Click:Connect(function()
	if panelOpen then
		panelOpen = false
		TweenService:Create(contentPanel, TweenInfo.new(0.25, Enum.EasingStyle.Quad),
			{Position = UDim2.new(1, 0, 0.5, 0)}):Play()
		for _, b in pairs(navButtons) do
			b.BackgroundColor3 = Color3.fromRGB(44, 47, 60)
		end
	end
end)

new("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, navPanel)

-- Floating pets
local petFolder = new("Folder", {Name = "MyPets"}, workspace)
local petParts = {}

local function rebuildPets()
	for _, p in ipairs(petParts) do p:Destroy() end
	petParts = {}
	if not data then return end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	for _, pet in ipairs(data.Pets) do
		if pet.Equipped then
			local part = new("Part", {Shape = Enum.PartType.Ball, Size = Vector3.new(1.8, 1.8, 1.8), Anchored = true,
				CanCollide = false, CanQuery = false, CanTouch = false, Material = Enum.Material.Neon,
				Color = RARITY_COLORS[pet.Rarity] or Color3.new(1, 1, 1), Position = root and root.Position or Vector3.zero}, petFolder)
			local bb = new("BillboardGui", {Size = UDim2.new(0, 100, 0, 24), StudsOffset = Vector3.new(0, 2, 0), AlwaysOnTop = true}, part)
			new("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = pet.Name, Font = Enum.Font.GothamBold,
				TextSize = 14, TextColor3 = RARITY_COLORS[pet.Rarity] or Color3.new(1, 1, 1), TextStrokeTransparency = 0.4}, bb)
			table.insert(petParts, part)
		end
	end
end

RunService.RenderStepped:Connect(function()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local n, t = #petParts, os.clock()
	for i, part in ipairs(petParts) do
		local angle = (i / n) * math.pi * 2 + t * 0.7
		local target = root.Position + Vector3.new(math.cos(angle) * 5, 2.5 + math.sin(t * 2 + i) * 0.6, math.sin(angle) * 5)
		part.Position = part.Position:Lerp(target, 0.15)
	end
end)

-- Server events
local function updateHud()
	if not data then return end
	coinLabel.Text = "Coins: " .. fmt(data.Coins)
	clickLabel.Text = "Per Click: " .. fmt(data.clickPower)
	autoLabel.Text = "Auto / sec: " .. fmt(data.autoPerSecond)
	infoLabel.Text = "Rebirths: " .. data.Rebirths .. " | " .. tostring(data.CurrentTitle)
end

remote.OnClientEvent:Connect(function(kind, a, b)
	if kind == "Sync" then
		data = a
		updateHud()
		rebuildPets()
		render()
	elseif kind == "Coins" and data then
		for k, v in pairs(a) do data[k] = v end
		updateHud()
	elseif kind == "Hatched" then
		showHatch(a, b)
	end
end)

player.CharacterAdded:Connect(function()
	task.wait(1)
	rebuildPets()
end)

render()
remote:FireServer("RequestSync")
