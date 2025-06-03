extends Object

func spawn_cogs(chain: ModLoaderHookChain, cog_count := 1) -> void:
	for i in cog_count:
		var cog : Cog = chain.reference_object.COG.instantiate()
		chain.reference_object.cog_node.add_child(cog)
		chain.reference_object.cogs.append(cog)
	
	for cog in chain.reference_object.cogs:
		cog.global_position = chain.reference_object.get_cog_position(cog)
		cog.set_name("Cog%d" % chain.reference_object.cogs.find(cog))
		chain.reference_object.face_battle_center(cog)
		if cog_count == 1 and not Engine.is_editor_hint():
			if Util.floor_number > 5:
				var new_level = cog.level + (2 * ceili(Util.floor_number * 0.2))
				if is_instance_valid(Util.floor_manager):
					new_level = Util.floor_manager.floor_variant.level_range.y + (2 * ceili(Util.floor_number * 0.2))
				cog.level = new_level
			else:
				var new_level = cog.level + 2
				if is_instance_valid(Util.floor_manager):
					new_level = Util.floor_manager.floor_variant.level_range.y + 2
				cog.level = new_level
			cog.randomize_cog()
