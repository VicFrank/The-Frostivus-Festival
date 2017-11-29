require('minigames/minigame_base')
-- LinkLuaModifier("modifier_stunned_lua", 'heroes/modifiers/modifier_stunned_lua', LUA_MODIFIER_MOTION_NONE)


SpiritBreakerRaceGame = MiniGame:new()

function SpiritBreakerRaceGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("race_charge_lua", function(...) end)
	end
end

function SpiritBreakerRaceGame:GameStart()
	self:InitializeGame(self.duration)

	local vRaceRight = Entities:FindByName(nil, "race_lanes_right_boundary"):GetAbsOrigin()

	local race_spawner_center = Entities:FindByName(nil, "race_lanes_center")
	self:SpawnVisionDummies(race_spawner_center)

	-- Initialize the heroes
	for _,hero in pairs(_G.GameMode.heroList) do
		hero:SetAngles(0, 0, 0)
		hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
	end

	local numWinners = 0
	local numPlayers = GameRules.num_players


	-- Check if someone crossed the finish line
	Timers:CreateTimer(.1, function()
		if not self.isRunning then return end
		for _,hero in pairs(_G.GameMode.heroList) do
			if not hero.winner and hero:GetAbsOrigin().x > vRaceRight.x then
				self:AddWinner(hero:GetPlayerOwnerID())
				local distance = 200
				local newPosition = hero:GetAbsOrigin() + Vector(distance,0,0)
				FindClearSpaceForUnit(hero, newPosition, true)
				hero:AddNewModifier(hero, nil, "modifier_stunned_lua", {})
				hero.winner = true
				PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
				numWinners = numWinners + 1
				if numWinners == numPlayers - 1 then
					Timers:CreateTimer(3, function()
						if not self.isRunning then return end
						self:GameEnd()
					end)
				end
			end
		end
		return .03
	end)
end

function SpiritBreakerRaceGame:GameEnd()
	self.isRunning = false

	for _,hero in pairs(_G.GameMode.heroList) do
		hero.winner = false
	end

	self:DestroyVisionDummies()
	self:CleanUp()
end