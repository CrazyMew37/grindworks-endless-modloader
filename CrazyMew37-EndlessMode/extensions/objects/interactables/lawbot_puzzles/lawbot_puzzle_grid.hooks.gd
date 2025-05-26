extends Object

# hope this does something -cm37
func win_game(chain: ModLoaderHookChain) -> void:
	if Engine.is_editor_hint():
		return
		
	chain.reference_object.s_win.emit()
	if chain.reference_object.lose_battle:
		chain.reference_object.lose_battle.queue_free()
	chain.reference_object.queue_free()
	if Util.get_player() and chain.reference_object.should_heal_player:
		if Util.floor_number > 5:
			Util.get_player().quick_heal(-chain.reference_object.explosion_damage * ceili(Util.floor_number * 0.2))
		else:
			Util.get_player().quick_heal(-chain.reference_object.explosion_damage)
		AudioManager.play_sound(load("res://audio/sfx/battle/gags/toonup/sparkly.ogg"))
