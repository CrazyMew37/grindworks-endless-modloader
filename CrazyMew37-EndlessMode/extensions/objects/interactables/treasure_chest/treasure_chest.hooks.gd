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
	world_item.pool = chain.reference_object.item_pool

func _ready(chain: ModLoaderHookChain) -> void:
	if Engine.is_editor_hint():
		return
	
	if not chain.reference_object.item_pool:
		chain.reference_object.do_reroll_chance()
	elif chain.reference_object.item_pool.resource_path == "res://objects/items/pools/special_items.tres":
		chain.reference_object.override_replacement_rolls = true

func do_reroll_chance(chain: ModLoaderHookChain) -> void:
	var reward_chest_roll := RandomService.randf_channel('chest_rolls')
	if reward_chest_roll < Globals.reward_chest_chance:
		print("Spawning reward pool chest")
		chain.reference_object.item_pool = Globals.REWARD_ITEM_POOL
		if RandomService.randf_channel('chest_rolls') < chain.reference_object.REWARD_OVERRIDE_CHANCE:
			chain.reference_object.override_replacement_rolls = true
	else:
		print("Spawning progressive pool chest")
		chain.reference_object.item_pool = Globals.PROGRESSIVE_ITEM_POOL
