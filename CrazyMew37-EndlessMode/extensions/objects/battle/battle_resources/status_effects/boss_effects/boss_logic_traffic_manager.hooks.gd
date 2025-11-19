extends Object

const ACTION_NEW_RETALIATION := preload('res://objects/battle/battle_resources/misc_movies/traffic_manager/traffic_jam.tres')

# thanks to discord user 3n for this. -cm37
func queue_retaliation(chain: ModLoaderHookChain) -> void:
	var action = ACTION_NEW_RETALIATION.duplicate()
	action.user = chain.reference_object.target
	action.damage = ceili(60 * (Util.floor_number * 0.2))
	action.targets = [Util.get_player()]
	chain.reference_object.manager.round_end_actions.append(action)
