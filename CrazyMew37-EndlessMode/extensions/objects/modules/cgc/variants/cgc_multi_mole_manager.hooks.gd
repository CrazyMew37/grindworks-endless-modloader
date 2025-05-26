extends Object

# moles -cm37
func win_game(chain: ModLoaderHookChain) -> void:
	if Util.floor_number > 5:
		Util.get_player().quick_heal(10 * ceili(Util.floor_number * 0.2))
	else:
		Util.get_player().quick_heal(10)
	chain.reference_object.spawn_winner_chests_for_winners_only()
	chain.reference_object.end_game()
