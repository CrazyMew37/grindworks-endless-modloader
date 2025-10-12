extends Object

# thanks to discord user 3n for this. -cm37
func create_reprimand_attack(chain: ModLoaderHookChain) -> void:
	var reprimand = chain.reference_object.REPRIMAND.duplicate()
	reprimand.user = chain.reference_object.target
	reprimand.damage = ceili(60 * (Util.floor_number * 0.2))
	reprimand.targets = [Util.get_player()]
	chain.reference_object.manager.round_end_actions.append(reprimand)
