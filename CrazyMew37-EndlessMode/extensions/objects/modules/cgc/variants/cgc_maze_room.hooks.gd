extends Object

# i also hate mazes -cm37
func win_game(chain: ModLoaderHookChain, body : Node3D) -> void:
	print("Maze game won.")
	if not chain.reference_object.active or not body is Player: return
	if Util.floor_number > 5:
		body.quick_heal(-chain.reference_object.base_damage * ceili(Util.floor_number * 0.2))
	else:
		body.quick_heal(-chain.reference_object.base_damage)
	chain.reference_object.active = false
	if chain.reference_object.game_timer:
		chain.reference_object.game_timer.queue_free()
