local dataStores = game:GetService("DataStoreService"):GetDataStore("CreditsDataStore")
local defaultCredits = 0
local playersLeft = 0

game.Players.PlayerAdded:Connect(function(player)
	
	playersLeft = playersLeft + 1
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 1
	level.Parent = leaderstats
	
	local Credits = Instance.new("IntValue")
	Credits.Name = "Credits"
	Credits.Value = 0
	Credits.Parent = leaderstats
	
	local playerData = Instance.new("Folder")
	playerData.Name = player.Name
	playerData.Parent = game.ServerStorage.PlayerData
	
	--local equipped = Instance.New("StringValue")
	--equipped.Name = "Equipped"
	--equipped.Parent = playerData
	
	--local inventory = Instance.New("Folder")
	--inventory.Name = "Inventory"
	--inventory.Parent = playerData
	
	
	player.CharacterAdded:Connect(function(character)
		character.Humanoid.Walkspeed = 20
		character.Humanoid.Died:Connect(function()
			
		
			if character.Humanoid and character.Humanoid:FindFirstChild("creator") then
				game.ReplicatedStorage.Status.Value = tostring(character.Humanoid.creator.Value).." KILLED  "..player.Name
			end

			if character:FindFirstChild("GameTag") then
				character.GameTag:Destroy()
			end
			
			player.LoadCharacter()
		end)		
	end)
	
	--Data Store
	
	local player_data
	local weaponsData
	local equippedData
	
	pcall(function()
		player_data = dataStores:GetAsync(player.UserId.."-Credits")
		print("CREDY:"..player_data)
	end)
	
	pcall(function()
		weaponsData = dataStores:GetAsync(player.UserId.."-Weps")
	end)
	
	pcall(function()
		equippedData = dataStores:GetAsync(player.UserId.."-EquippedValue")
	end)
	
	if player_data ~= nil then
		--Has data
		Credits.Value = player_data
		
	else
		--New  Player
		Credits.Value  = defaultCredits
	end
	
	if weaponsData then
		--For loop thru weapons saved
		--Load in
		
		--Set equipped value
	end
	
end)

local bindableEvent = Instance.new("BindableEvent")

game.Players.PlayerRemoving:Connect(function(player)
	pcall(function()
		dataStores:SetAsync(player.UserId.."-Credits",player.leaderstats.Credits.Value)
		print("Saved")
		playersLeft = playersLeft - 1
		bindableEvent:Fire()
	end)
	
end)


game:BindToClose(function()
	--triggered when shut down
	while playersLeft > 0 do
		bindableEvent.Event:Wait()
	end
	
end)