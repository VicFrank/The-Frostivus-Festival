function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = thisEntity:FindAbilityByName( "ogre_tank_melee_smash" )
	JumpAbility = thisEntity:FindAbilityByName( "ogre_tank_jump_smash" )
	thisEntity.hasteFactor = 1

	thisEntity:SetContextThink( "OgreTankThink", OgreTankThink, 1 )
end

function OgreTankThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	thisEntity:SetAcquisitionRange( 3000 )

	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	for i = 1, #enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 300 then
				nEnemiesRemoved = nEnemiesRemoved + 1
				table.remove( enemies, i )
			end
		end
	end

	if JumpAbility ~= nil and JumpAbility:IsFullyCastable() and nEnemiesRemoved > 0 then
		print("Jump")
		return Jump()
	end

	if #enemies == 0 then
		print("No enemies")
		return 1
	end

	if SmashAbility ~= nil and SmashAbility:IsFullyCastable() then
		print("Smash")
		return Smash( enemies[ 1 ] )
	end

	print("Move")
	return 0.5
end


function Jump()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = JumpAbility:entindex(),
		Queue = false,
	})
	
	return 2.5
end


function Smash( enemy )
	if enemy == nil then
		print("enemy is nil")
		return 0.5
	end

	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
		--print( "If player can't see me, provide brief vision to his team as I start my Smash" )
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.5 } )
	end

	local direction = enemy:GetForwardVector():Normalized()
    local smashPrediction = enemy:GetAbsOrigin() + direction * RandomInt(0,300)

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = SmashAbility:entindex(),
		Position = smashPrediction,
		Queue = false,
	})

	return 3 / thisEntity.hasteFactor
end

