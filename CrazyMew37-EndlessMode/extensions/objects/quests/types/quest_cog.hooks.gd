extends Object

func randomize_objective(chain: ModLoaderHookChain) -> void:
	chain.reference_object.quota = RNG.channel(RNG.ChannelQuests).randi_range(chain.reference_object.OBJECTIVE_RANGE.x, chain.reference_object.OBJECTIVE_RANGE.y)
	var quotaf := float(chain.reference_object.quota)
	
	var quest_type = RNG.channel(RNG.ChannelCogQuestTypes).randi() % 3
	if quest_type == 1 and chain.reference_object.prev_quest_roll == 1:
		quest_type += 1 * RNG.channel(RNG.ChannelCogQuestTypes).pick_random([-1, 1])
	
	var level_ranges := FloorVariant.LEVEL_RANGES
	var floor_num: int = max(Util.floor_number, 0)
	
	var minimum_level: int = 0
	var maximum_level: int = 0
	
	if Util.floor_number < 6:
		minimum_level = mini(0, level_ranges[floor_num][0] - 1)
		maximum_level = mini(7, level_ranges[floor_num][1] - 1)
	else:
		minimum_level = Util.floor_number * 2
		maximum_level = Util.floor_number * 3
	
	# 33% chance of department specific
	if quest_type == 0:
		chain.reference_object.department = chain.reference_object.goal_dept
	elif quest_type == 1:
		var cog_pool : CogPool
		match chain.reference_object.goal_dept:
			CogDNA.CogDept.SELL:
				cog_pool = load('res://objects/cog/presets/pools/sellbot.tres')
			CogDNA.CogDept.CASH:
				cog_pool = load('res://objects/cog/presets/pools/cashbot.tres')
			CogDNA.CogDept.LAW:
				cog_pool = load('res://objects/cog/presets/pools/lawbot.tres')
			CogDNA.CogDept.BOSS:
				cog_pool = load('res://objects/cog/presets/pools/bossbot.tres')
				
		if Util.floor_number < 6:
			chain.reference_object.specific_cog = cog_pool.cogs[RNG.channel(RNG.ChannelCogQuestTypes).randi_range(minimum_level, maximum_level)]
		else:
			chain.reference_object.specific_cog = cog_pool.cogs[RNG.channel(RNG.ChannelCogQuestTypes).randi_range(0, 7)]
		
	
	# Reduce quotas for more specific quest types
	if not chain.reference_object.department == CogDNA.CogDept.NULL:
		quotaf /= 2.0
	elif chain.reference_object.specific_cog:
		quotaf /= 4.0
	
	# Level minimum objectives
	if RNG.channel(RNG.ChannelCogQuestTypes).randi() % 3 == 0:
		if chain.reference_object.specific_cog:
			chain.reference_object.min_level = RNG.channel(RNG.ChannelCogQuestTypes).randi_range(chain.reference_object.specific_cog.level_low + 1, chain.reference_object.specific_cog.level_low + 3)
			if chain.reference_object.min_level > chain.reference_object.specific_cog.level_high or chain.reference_object.min_level > maximum_level: 
				chain.reference_object.min_level = 1
		else:
			chain.reference_object.min_level = RNG.channel(RNG.ChannelCogQuestTypes).randi_range(minimum_level, maximum_level)
	
	if chain.reference_object.min_level > 1 && Util.floor_number < 6:
		quotaf /= maxf(chain.reference_object.min_level/4.0,1.25)
	elif chain.reference_object.min_level > 1 && Util.floor_number >= 6:
		quotaf /= 1.25
	
	chain.reference_object.quota = int(round(quotaf))
