require('minigames/taunt_game')
require('minigames/techies_game')
require('minigames/chain_frost_game')
require('minigames/crystal_maiden_game')
require('minigames/zuus_race')
require('minigames/mirana_arrow_game')
require('minigames/necro_game')
require('minigames/pudge_wars_game')
require('minigames/shadowfiend_wars')
require('minigames/remote_mine_game')
require('minigames/monkey_king_game')
require('minigames/earth_spirit_soccer')
require('minigames/druid_game')
require('minigames/drow_archer_game')
require('minigames/ogre_seal_game')
require('minigames/ogre_game')
require('minigames/bloodseeker_game')
require('minigames/spirit_breaker_race')
require('minigames/zombie_game')
require('minigames/ursa_game')
require('minigames/invoker_leader_game')
require('minigames/furion_teleport_game')
require('minigames/spirit_breaker_game')
require('minigames/templar_game')
require('minigames/campfire_survival')
require('minigames/enchantress_game')
require('minigames/techies_sumo_game')
require('minigames/snowball_game')
require('minigames/fire_trap_game')
require('minigames/storegga_game')
require('minigames/antimage_game')
require('minigames/timbersaw_game')


tMINIGAME_INIT_TABLE = {
	-- snowball_game = {
	-- 	name = "Snowball",
	-- 	description = "",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_tusk",
	-- 		health = 100,
	-- 		mana = 0,
	-- 		abilities = {
	-- 			"snowball_lua",
	-- 		},			
	-- 	},
	-- 	arena = "snow_medium",
	-- 	game = SnowballGame:new{duration=-1},
	-- },

	taunt_game = {
		name = "Suicidal Axe",
		description = "Be the first player to die",
		hero = {
			heroName = "npc_dota_hero_axe",
			health = 100,
			mana = 100,
			abilities = {
				"custom_berserkers_call",
			},			
		},
		arena = "snow_small",
		game = TauntGame:new{duration=120},
	},

	suicidal_pudge_game = {
		name = "Suicidal Pudge",
		description = "Stay away from the suicidal pudge",
		hero = {
			heroName = "npc_dota_hero_crystal_maiden",
			health = 100,
			mana = 100,
			manaRegen = .6,
			moveSpeed = 275,
			abilities = {
				"custom_frostbite",
			},			
		},
		arena = "snow_small",
		game = SuicidalPudgeGame:new{duration=180},
	},

	chain_frost_game = {
		name = "Chain Frost Tag",
		description = "Avoid the Lich's Chain Frosts",
		hero = {
			heroName = "npc_dota_hero_terrorblade",
			health = 1000,
			healthRegen = 1.65,
			mana = 300,
			manaRegen = .65,
			abilities = {
				"conjure_image_lua",
			},			
		},
		arena = "snow_small",
		game = ChainFrostGame:new{duration=120},
	},

	remote_mine_game = {
		name = "Minefield Survival",		
		description = "Avoid the exploding bombs",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_techies",
			health = 100,
			healthRegen = 1,
			mana = 0,
			abilities = {
			},			
		},
		arena = "snow_small",
		game = RemoteMineGame:new{duration=120},
	},

	zuus_race = {
		name = "Minefield Racing",
		description = "Navigate a dangerous minefield, using lightning to guide your way",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_zuus",
			health = 100,
			healthRegen = 1,
			mana = 100,
			manaRegen = .165,
			vision = 9000,
			moveSpeed = 250,
			abilities = {
				"lightning_bolt_lua",
				"place_land_mine_lua"
			},			
		},
		arena = "snow_race",
		game = ZuusRaceGame:new{duration=180},
	},

	mirana_arrow_game = {
		name = "Arrow Practice",
		description = "Shoot one of the bells with an Arrow",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_mirana",
			health = 100,
			mana = 100,
			vision = 9000,
			abilities = {
				"mirana_arrow_lua"
			},			
		},
		arena = "snow_long",
		game = MiranaArrowGame:new{duration=120},
	},

	necro_game = {
		name = "Survive the Winter",
		description = "Pick up Regen Runes to survive the freezing winter",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_queenofpain",
			health = 100,
			mana = 100,
			abilities = {
			},			
		},
		arena = "snow_arena",
		game = NecroGame:new{duration=120},
	},

	pudge_wars = {
		name = "Pudge Wars",
		description = "Get points by killing other players",
		hero = {
			heroName = "npc_dota_hero_pudge",
			health = 100,
			healthRegen = 1.5,
			mana = 200,
			manaRegen = .5,
			abilities = {
				"custom_pudge_meat_hook",
			},			
		},
		arena = "snow_arena",
		game = PudgeWars:new{duration=120},
	},

	-- shadowfiend_wars = {
	-- 	name = "Shadowfiend Wars",
	-- 	description = "Get points by killing other players",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_nevermore",
	-- 		health = 100,
	-- 		healthRegen = .35,
	-- 		mana = 100,
	-- 		abilities = {
	-- 			"custom_shadowraze1",
	-- 			"custom_shadowraze2",
	-- 			"custom_shadowraze3",
	-- 		},
	-- 	},
	-- 	arena = "snow_arena",
	-- 	game = ShadowfiendWars:new{duration=120},
	-- },

	-- monkey_king_game = {
	-- 	name = "Monkey Mischief",
	-- 	description = "Find and kill the 20 disguised Monkey Kings",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_lion",
	-- 		health = 100,
	-- 		mana = 100,
	-- 		vision = 9000,
	-- 		abilities = {
	-- 			"lion_finger_lua"
	-- 		},
	-- 	},
	-- 	arena = "snow_small",
	-- 	game = MonkeyKingGame:new{duration=120},
	-- },

	earth_spirit_game = {
		name = "Kaolin Soccer",
		description = "Keep the ball out of your goal",
		hero = {
			heroName = "npc_dota_hero_earth_spirit",
			health = 100,
			mana = 100,
			moveSpeed = 360,
			abilities = {
				"earth_spirit_kick_lua",
			},
		},
		arena = "snow_small",
		game = EarthSpiritGame:new{duration=120},
	},

	-- druid_game = {
	-- 	name = "Boar, Bear, Hawk",
	-- 	description = "Last Druid Standing",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_lone_druid",
	-- 		health = 300,
	-- 		mana = 100,
	-- 		manaRegen = .4,
	-- 		noWearables = true,
	-- 		abilities = {
	-- 			"shapeshift_bear_lua",
	-- 			"shapeshift_boar_lua",				
	-- 			"shapeshift_hawk_lua",
	-- 		},
	-- 	},
	-- 	arena = "snow_arena",
	-- 	game = DruidGame:new{duration=180},
	-- },

	archer_wars = {
		name = "Archer Wars",
		description = "Last Archer Standing",
		hero = {
			heroName = "npc_dota_hero_drow_ranger",
			health = 100,
			healthRegen = .6,
			mana = 100,
			armor = 3,
			abilities = {
				"drow_shoot_arrow_lua",
			},
		},
		arena = "snow_arena",
		game = DrowArcherGame:new{duration=180},
	},

	ogre_seal_game = {
		name = "Ogre Seal Survival",
		description = "Avoid getting crushed by the Ogre Seal",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_vengefulspirit",
			health = 100,
			healthRegen = .8,
			mana = 100,
			abilities = {
				"custom_nether_swap",
			},
		},
		arena = "snow_small",
		game = OgreSealGame:new{duration=120},
	},

	ogre_game = {
		name = "Ogre Survival",
		description = "Avoid getting crushed by the Ogre",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_puck",
			health = 100,
			healthRegen = .8,
			mana = 100,
			abilities = {
				"custom_puck_phase_shift"
			},
		},
		arena = "snow_small",
		game = OgreGame:new{duration=120},
	},

	bloodseeker_game = {
		name = "Red Light, Green Light",
		description = "Make it to the end of the race without being killed by rupture",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_weaver",
			health = 100,
			mana = 100,
			moveSpeed = 150,
			vision = 9000,
			abilities = {
				"shukuchi_lua"
			},
		},
		arena = "snow_race",
		game = BloodseekerGame:new{duration=120},
	},

	spirit_breaker_race = {
		name = "Spirit Breaker Race",
		description = "Spam Charge to move forwards",
		hero = {
			heroName = "npc_dota_hero_spirit_breaker",
			health = 100,
			mana = 100,
			abilities = {
				"race_charge_lua"
			},
		},
		arena = "race_lanes",
		game = SpiritBreakerRaceGame:new{duration=75},		
	},

	zombie_game = {
		name = "Zombies Zombies Zombies",
		description = "Survive the Zombie Apocalypse",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_sniper",
			health = 100,
			mana = 100,
			manaRegen = .25,
			armor = 3,
			abilities = {
				"sniper_ground_shot_lua",
			},
		},
		arena = "snow_arena",
		game = ZombieGame:new{duration=180},
	},

	ursa_game = {
		name = "Poke the Ogre",
		description = "Do the most damage to the Ogre before time runs out. Fury Swipes stacks with other players.",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_ursa",
			health = 1000,
			healthRegen = 1.35,
			mana = 100,
			manaRegen = .33,
			armor = 3,
			abilities = {
				"custom_overpower",
				"custom_fury_swipes",
			},
		},
		arena = "snow_small",
		game = UrsaGame:new{duration=120},
	},

	invoker_leader_game = {
		name = "Follow the Leader",
		description = "Invoke the same spells as Invoker\n\nTake damage for invoking the wrong spell, or not invoking on time",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_invoker",
			health = 5,
			mana = 0,
			modifierName = "modifier_rooted_lua",
			abilities = {				
				"invoker_quas_lua",
				"invoker_wex_lua",
				"invoker_exort_lua",
				"generic_hidden",
				"generic_hidden",
				"invoker_invoke_lua",
			},
		},
		arena = "snow_stage",
		game = InvokerLeaderGame:new{duration=120},
	},

	furion_teleport_game = {
		name = "Coin Collection",
		description = "Collect the most coins before time runs out",
		hero = {
			heroName = "npc_dota_hero_furion",
			health = 100,
			mana = 0,
			vision = 10000,
			abilities = {
				"furion_teleport_lua",
			},
		},
		arena = "snow_large_center",
		game = FurionTeleportGame:new{duration=75},
	},

	spirit_breaker_game = {
		name = "Spirit Breaker Sumo",
		description = "Try to push other players out of bounds",
		hero = {
			heroName = "npc_dota_hero_spirit_breaker",
			health = 100,
			mana = 0,
			armor = 3,
			moveSpeed = 300,
			abilities = {
				"greater_bash_lua",
			},
		},
		arena = "snow_tiny",
		game = SpiritBreakerGame:new{duration=120},
	},

	templar_game = {
		name = "Refraction Survival",
		description = "Use Refraction to survive the fire. Keeping Refraction on drains mana.",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_templar_assassin",
			health = 3,
			mana = 100,
			modifierName = "modifier_rooted_lua",
			abilities = {
				"refraction_lua",
			},			
		},
		arena = "snow_stage",
		game = TemplarGame:new{duration=120},
	},

	-- campfire_survival = {
	-- 	name = "Campfire Survival",
	-- 	description = "Survive the blizzard by finding campfires to keep you warm",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_ancient_apparition",
	-- 		health = 100,
	-- 		mana = 100,
	-- 		vision = 1200,
	-- 		abilities = {
	-- 			"custom_cold_feet",
	-- 			"custom_ice_vortex",
	-- 		},			
	-- 	},
	-- 	arena = "snow_large",
	-- 	game = CampfireSurvivalGame:new{duration=-1},
	-- },

	enchantress_game = {
		name = "Impetus Throwing Contest",
		description = "Throw the longest Impetus. Distance is measured from where you are when your lance hits.",
		hero = {
			heroName = "npc_dota_hero_enchantress",
			health = 100,
			mana = 0,
			items = {"item_blink_lua"},
			abilities = {
				"impetus_lua"
			},			
		},
		arena = "snow_medium",
		game = EnchantressGame:new{duration=75},
	},

	techies_sumo_game = {
		name = "Techies Knockout",
		description = "Use your mines to push other players out of bounds",
		hero = {
			heroName = "npc_dota_hero_techies",
			health = 100,
			mana = 0,
			abilities = {
				"place_propulsion_mine_lua",
				"detonate_propulsion_mine_lua",
			},
		},
		arena = "snow_tiny",
		game = TechiesSumoGame:new{duration=120},
	},

	fire_trap_game = {
		name = "Fire Trap Race",
		description = "Make it to the end without being killed by the fire",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_sven",
			health = 100,
			mana = 0,
			abilities = {
			},
		},
		arena = "snow_race",
		game = FireTrapGame:new{duration=120},
	},

	-- storegga_game = {
	-- 	name = "Avalanche Survival",
	-- 	description = "Survive the avalanches caused by the elder tiny",
	-- 	hero = {
	-- 		heroName = "npc_dota_hero_tiny",
	-- 		health = 100,
	-- 		mana = 0,
	-- 		abilities = {
	-- 		},
	-- 	},
	-- 	arena = "snow_medium",
	-- 	game = StoreggaGame:new{duration=180},
	-- },

	antimage_game = {
		name = "An End To All Magic",
		description = "Don't get pushed off the platform by Invoker's Deafening Blasts",
		singlePlayer = true,
		hero = {
			heroName = "npc_dota_hero_antimage",
			health = 100,
			mana = 100,
			abilities = {
				"custom_antimage_blink",
			},
		},
		arena = "snow_tiny",
		game = AntimageGame:new{duration=120},
	},

	timbersaw_game = {
		name = "Deforestation",
		description = "Destroy the most trees before time runs out!",
		hero = {
			heroName = "npc_dota_hero_shredder",
			health = 100,
			mana = 0,
			abilities = {
				"whirling_death_lua",
				"timber_chain_lua",
				"generic_hidden",
				"generic_hidden",
				"chakram_return_lua",
				"chakram_lua",
			},
		},
		arena = "snow_large_center",
		game = TimbersawGame:new{duration=75},
	},
}

return tMINIGAME_INIT_TABLE