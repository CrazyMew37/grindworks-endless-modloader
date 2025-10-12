extends Object

# thanks to discord user 3n for this. -cm37
func queue_retaliation(chain: ModLoaderHookChain) -> void:
	var action = chain.reference_object.ACTION_RETALIATION.duplicate()
	chain.reference_object.action.user = chain.reference_object.target
	action.damage = ceili(60 * (Util.floor_number * 0.2))
	action.targets = [Util.get_player()]
	chain.reference_object.manager.round_end_actions.append(action)
