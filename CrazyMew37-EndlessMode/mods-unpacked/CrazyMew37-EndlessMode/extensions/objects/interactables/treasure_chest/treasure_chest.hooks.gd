extends Object


func assign_item(chain: ModLoaderHookChain, world_item: WorldItem):
# Stop breaking the game, Treasure Chest. -cm37
	var floor_id = Util.floor_number % 5
	if floor_id == 0 && Util.floor_number > 4:
		floor_id = 5
	if chain.reference_object.scripted_progression and chain.reference_object.SCRIPTED_PROGRESSION_ITEMS[floor_id] != null:
		var scripted_item = chain.reference_object.SCRIPTED_PROGRESSION_ITEMS[floor_id]
		# 5th floor has a +8 laff boost
		if scripted_item == chain.reference_object.LAFF_BOOST:
			scripted_item = scripted_item.duplicate()
			scripted_item.stats_add['max_hp'] = 8
			scripted_item.stats_add['hp'] = 8
		world_item.item = scripted_item
		return
	if chain.reference_object.override_item:
		chain.reference_object.world_item.item = chain.reference_object.override_item
		return
	chain.reference_object.world_item.pool = chain.reference_object.item_pool
