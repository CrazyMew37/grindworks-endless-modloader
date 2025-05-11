extends Object

func get_gag_rate(chain: ModLoaderHookChain) -> float:
	if not Util.get_player():
		return 0
	
	var floor_num := maxi(Util.floor_number + 1, 1)
	
	var stats := Util.get_player().stats
	var total_gags := 0
	var collected_gags := 0
	
	# Find the base amount of gags the player has
	for key in stats.gags_unlocked.keys():
		for track: Track in stats.character.gag_loadout.loadout:
			if track.track_name == key:
				total_gags += track.gags.size()
		collected_gags += stats.gags_unlocked[key]
	
	# Now, find the track frames currently in play and add those to the total
	for item: Item in chain.reference_object.items_in_play:
		if item.arbitrary_data.has('track'):
			collected_gags += 1
	
	# Don't allow track frames to spawn when all gags have been acquired
	if collected_gags >= total_gags:
		return 0.0
	
	var gag_percent: float = float(collected_gags) / float(total_gags)
	
	if Util.floor_number > 5:
		floor_num = 6
	# We aim for the player to have collected all of their gags by the end of Floor 5. (Considered floor 6 by this code)
	# Floor 0: 20% of all gags collected
	# Floor 1: 35% of all gags collected
	# Floor 2: 50% of all gags collected
	# Floor 3: 70% of all gags collected
	# Floor 4: 90% of all gags collected
	# Floor 5: 100% of all gags collected
	var goal_percent := minf(chain.reference_object.GagGoals[floor_num], 1.0)
	
	var chance := (1.0 - (gag_percent / goal_percent)) * 1.35
	
	return chance
