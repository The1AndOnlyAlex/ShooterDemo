local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerStorage = game:GetService("ServerStorage")

local MapsFolder = ServerStorage:WaitForChild("Maps")

local Status = ReplicatedStorage:WaitForChild("Status")

local GameLength = 60

local reward = 50

local Players = game:GetService("Players")

while true do
	
	Status.Value = "Waiting for enough players"
	
	repeat wait(1) until game.Players.NumPlayers >= 2
	
	Status.Value = "Intermission"
	
	wait(20)
	
	local plrs = {}
	
	for i, player in pairs(game.Players:GetPlayers()) do
		if player then
			table.insert(plrs,player)
		end
	end
	
	wait(2)
	
	local AvailableMaps = MapsFolder:GetChildren()
	
	local ChosenMap = AvailableMaps[math.random(1,#AvailableMaps)]
	
	Status.Value = ChosenMap.Name.." Chosen"
	
	local ClonedMap = ChosenMap:Clone()
	ClonedMap.Parent = workspace
	
	local SpawnPoints = ClonedMap:FindFirstChild("SpawnPoints")
	
	if not SpawnPoints then
		print("SpawnPoints Missing or Obstructed!")
	end
	
	local AvailableSpawnPoints = SpawnPoints:GetChildren()
	wait(6)
	for i, player in pairs(plrs) do
		if player then
			character = player.Character
			if character then
			--Nobody Leaves :D
				character:FindFirstChild("HumanoidRootPart").CFrame = AvailableSpawnPoints[1].CFrame + Vector3.new(0,10,0)
				table.remove(AvailableSpawnPoints,1)
				
				--Give Weapon
				local AK47 = ServerStorage.AK47:Clone()
				AK47.Parent = player.Backpack
				
				local GameTag = Instance.new("BoolValue")
				GameTag.Name = "GameTag"
				GameTag.Parent = player.Character
				
			else
			--Somebody leaves
				if not player then
					table.remove(plrs,i)
				end
			end
		end
	end -- for i, player in pairs(plrs) do
	
	
	StatusValue = "Get Ready to Play!"
	wait(3)
	
	for i = GameLength,0,-1 do
		
		for x, player in pairs(plrs) do
			if player then
				
				character = player.Character
				
				if not character then
				--Gone?
					table.remove(plrs,x)
				else
					if character:FindFirstChild("GameTag") then
						print(player.Name.." is still in the game!")
					else
					--DEAD	
						table.remove(plrs,x)
						print(player.Name.." has been removed!")
					end
				end
			else
				table.remove(plrs,x)
				print(player.Name.." has been removed!")
			end
		end
		
		Status.Value = "There are "..i.." seconds remaining, and "..#plrs.." players left"
		
		if #plrs == 1 then
			
			Status.Value = "The winner is "..plrs[1].Name
			plrs[1].leaderstats.Credits.Value = plrs[1].leaderstats.Credits.Value + reward
			break
			
		elseif #plrs == 0 then
			Status.Value = "Nobody Won!"
			break
			
		elseif i == 0 then
			Status.Value = "Times Up!"
			break
		end
		
		wait(1)
	end
	
	print("End of Game")
	
	wait(2)
	
	for i, player in pairs(game.Players:GetPlayers()) do
		character = player.Character
		
		if not character then
			--nothing
		else
			if character:FindFirstChild("GameTag") then
				character.GameTag:Destroy()
			end
			
			if player.Backpack:FindFirstChild("AK47") then
				player.Backpack.AK47:Destroy()
			end
			
			if character:FindFirstChild("AK47") then
				character.AK47:Destroy()
			end
			
		end
		
		player:LoadCharacter()
	end
	
	ClonedMap:Destroy()
	
	Status.Value = "Game Ended"
	
	wait(2)
end