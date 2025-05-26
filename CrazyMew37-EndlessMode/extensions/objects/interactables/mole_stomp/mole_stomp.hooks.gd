extends Object

# i hate moles -cm37
func win_game(chain: ModLoaderHookChain) -> void:
	if chain.reference_object.game_mode == chain.reference_object.GameMode.ENDLESS:
		return
	if Util.floor_number > 5:
		Util.get_player().quick_heal(-chain.reference_object.base_damage * ceili(Util.floor_number * 0.2))
	else:
		Util.get_player().quick_heal(-chain.reference_object.base_damage)
	chain.reference_object.end_game()
	chain.reference_object.s_game_win.emit()
