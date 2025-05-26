extends Object

# hope this doesn't break anything -cm37
func game_won(chain: ModLoaderHookChain) -> void:
	if not chain.reference_object.game_active: return
	chain.reference_object.game_active = false
	if is_instance_valid(chain.reference_object.timer):
		chain.reference_object.timer.queue_free()
	if Util.floor_number > 5:
		Util.get_player().quick_heal(chain.reference_object.heal_amount * ceili(Util.floor_number * 0.2))
	else:
		Util.get_player().quick_heal(chain.reference_object.heal_amount)
	chain.reference_object.s_game_won.emit()
