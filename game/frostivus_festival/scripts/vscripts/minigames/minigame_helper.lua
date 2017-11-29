LinkLuaModifier("modifier_health_lua", "heroes/modifiers/modifier_health_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_lua", "heroes/modifiers/modifier_mana_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stunned_lua", "heroes/modifiers/modifier_stunned_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rooted_lua", "heroes/modifiers/modifier_rooted_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_provide_vision_lua", "heroes/modifiers/modifier_provide_vision_lua.lua", LUA_MODIFIER_MOTION_NONE)

minigame_tables = require('minigames/minigame_init_tables')
minigame_tables_bucket = {}

function GameMode:StartRandomGame()
	-- if IsInToolsMode() then		
	-- 	GameMode:EndGame()
	-- end

	if GameRules.round == GameRules.MAX_ROUNDS then
		GameMode:EndGame()
		return
	end
	local miniGameTable = PickRandomShuffle(minigame_tables, minigame_tables_bucket)

	if GameRules.num_players == 1 then
		while not miniGameTable["singlePlayer"] do
			print("Skipping " .. miniGameTable["name"])
			miniGameTable = PickRandomShuffle(minigame_tables, minigame_tables_bucket)
		end
	end
	GameMode:InitializeRound(miniGameTable)
end

function GameMode:StartGameByName(gameName)
	local miniGameTable = minigame_tables[gameName]
	if not miniGameTable then print('Minigame Name ' .. gameName ' not found') end

	if GameMode.currentGame then
		GameMode.currentGame:GameEnd()
	end
	GameMode:InitializeRound(miniGameTable)
end

function GameMode:InitializeRound(miniGameTable)
	local gameName = miniGameTable["name"]
	local gameDescription = miniGameTable["description"]
	print("Initializing " .. gameName)
	print(gameDescription)

	local gameStartDelay = 5
	if IsInToolsMode() then
		gameStartDelay = 5
	end

	GameRules.round = GameRules.round + 1

	local roundStartData = {
		round_name = gameName,
		round_description = gameDescription,
		round_number = GameRules.round,
		round_screen_duration = gameStartDelay,
	}

	CustomGameEventManager:Send_ServerToAllClients("round_started", roundStartData)

	GameMode.currentGame = miniGameTable['game']
	GameMode.currentGame:Precache()

	GameMode:CreateHeroesForRound(miniGameTable["hero"])
	GameMode:DoToAllHeroes(function(hero)
		hero:AddNewModifier(unit, nil, "modifier_stunned_lua", {duration = gameStartDelay})
	end)

	GameMode:PlaceHeroesAtSpawns(miniGameTable["arena"] .. "_spawner_hero")

	local worldBoundsMin = Entities:FindByName(nil, miniGameTable["arena"] .. "_camera_min"):GetAbsOrigin()
	local worldBoundsMax = Entities:FindByName(nil, miniGameTable["arena"] .. "_camera_max"):GetAbsOrigin()
	ChangeWorldBounds(worldBoundsMin, worldBoundsMax)
	-- Show the Round Description UI
	-- Notifications:TopToAll({text=gameName, duration=gameStartDelay + .5})
	-- Notifications:TopToAll({text=gameDescription, duration=gameStartDelay + .5})
	-- Wait so there's time for precaching
	Timers:CreateTimer(gameStartDelay, function()
		GameMode.currentGame:GameStart()
		GameMode:StartBattleMusic()
	end)
end

function GameMode:EndGame()
	-- Start Bonus rounds
	local winningTeam = DOTA_TEAM_GOODGUYS
	local maxScore = -1
    for team, score in pairs(GameRules.score) do
    	if score > maxScore then
    		winningTeam = team
    		maxScore = score
    	end
    end

    GameRules:SetGameWinner(winningTeam)
end

function GameMode:CreateHeroesForRound(miniGameHeroTable)
	local heroName = miniGameHeroTable["heroName"]
	local health = miniGameHeroTable["health"]
	local healthRegen = miniGameHeroTable["healthRegen"] or 0
	local mana = miniGameHeroTable["mana"] or 0
	local manaRegen = miniGameHeroTable["manaRegen"] or 0
	local armor = miniGameHeroTable["armor"] or 0
	local visionRange = miniGameHeroTable["vision"] or 1800
	local moveSpeed = miniGameHeroTable["moveSpeed"] or 300
	local abilities = miniGameHeroTable["abilities"]
	local modifierName = miniGameHeroTable["modifierName"]
	local items = miniGameHeroTable["items"] or {}

	local newHeroList = {}
	GameMode:DoToAllHeroes(function(hero)
		hero:RespawnHero(false, false)
		unit = GameMode:SwapHero(hero, heroName)
		table.insert(newHeroList, unit)

		if miniGameHeroTable["noWearables"] then
			GameMode:RemoveWearables(unit)
		end

	    --unit:SetOriginalModel(creepTable.Model)
		--unit:SetModel(creepTable.Model)

		--unit:SetUnitName(creepName)
		unit:SetBaseMoveSpeed(moveSpeed)
		unit:SetPhysicalArmorBaseValue(armor)
		unit:AddNewModifier(unit, nil, "modifier_health_lua", {health = health})
		unit:SetBaseHealthRegen(healthRegen)

		unit:AddNewModifier(unit, nil, "modifier_mana_lua", {mana = mana})
		unit:SetBaseManaRegen(manaRegen)

		unit:SetDayTimeVisionRange(visionRange)
		unit:SetNightTimeVisionRange(visionRange)

		if modifierName then
			unit:AddNewModifier(unit, nil, modifierName, {})
		end

		for _,abilityName in pairs(abilities) do
			unit:AddAbility(abilityName):UpgradeAbility(true)
		end

		for _,itemName in pairs(items) do
			local item = CreateItem(itemName, unit, unit)
			unit:AddItem(item)
		end
	end)
	GameMode.heroList = newHeroList
end

function GameMode:SwapHero(hero, newHeroName)
	local player = hero:GetPlayerOwner()
	local playerID = player:GetPlayerID()
	local team = PlayerResource:GetTeam(playerID)

	local unit = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0)

	return unit
end

function GameMode:RemoveAllAbilities(hero)
	for i=0,23 do
		local abil = hero:GetAbilityByIndex(i)		
		if abil then
			hero:RemoveAbility(abil:GetAbilityName())
		end
	end
end

function GameMode:PlaceHeroesAtSpawns(spawnerName)
	--find the spawners with this name, and spawn heroes at each of them randomly
	local spawners = Entities:FindAllByName(spawnerName)
    local bucket = {}
    for _,hero in pairs(GameMode.heroList) do
        local spawnLocation = PickRandomShuffle(spawners, bucket):GetAbsOrigin()
        FindClearSpaceForUnit(hero, spawnLocation, true)
        hero:SetAngles(0, RandomFloat(0,359), 0)
        hero.spawnLocation = spawnLocation
        Timers:CreateTimer(0.2, function()
        	GameMode:CenterCameraOnHero(hero)
        end)
    end
end

function GameMode:StartBattleMusic()
    for _,hero in pairs(GameMode.heroList) do
        local player = hero:GetPlayerOwner()
        player:SetMusicStatus(DOTA_MUSIC_STATUS_EXPLORATION, .5)
    end
end

function GameMode:CenterCameraOnHero(hero)
	local playerID = hero:GetPlayerOwnerID()	
	PlayerResource:SetCameraTarget(playerID, hero)

	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(playerID, nil)
	end)
end

function GameMode:SwapLayers(old, new)
    DoEntFire(new, "ShowWorldLayerAndSpawnEntities", "", 0.0, nil, nil)
    DoEntFire(old, "HideWorldLayerAndDestroyEntities", "", 0.0, nil, nil)
end

function GameMode:RemoveWearables(hero)
    local model = hero:FirstMoveChild()
    while model ~= nil do
    	if model:GetClassname() == "dota_item_wearable" then
    		model:AddEffects(EF_NODRAW)
    	end
    	model = model:NextMovePeer()
    end
end

function GameMode:DoToAllHeroes(func)
	for _,hero in pairs(GameMode.heroList) do
		func(hero)
	end
end

function ChangeWorldBounds(minBounds, maxBounds)
    local oldBounds = Entities:FindByClassname(nil, "world_bounds")
    if oldBounds then 
        oldBounds:RemoveSelf()
    end

    SpawnEntityFromTableSynchronous("world_bounds", {Min = minBounds, Max = maxBounds})
end 