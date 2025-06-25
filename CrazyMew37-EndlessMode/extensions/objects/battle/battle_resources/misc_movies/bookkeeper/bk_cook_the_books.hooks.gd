extends Object

# These books are cooked alright. Burnt at this point. Hope this doesn't make bk too strong. -cm37
func apply_cooked(chain: ModLoaderHookChain) -> void:
	if chain.reference_object.COOKED.id in chain.reference_object.manager.get_status_ids_for_target(chain.reference_object.targets[0]):
		# If they already have the cooked effect, simply increase its damage value.
		var cooked: StatEffectBKCooked = chain.reference_object.manager.get_statuses_of_id_for_target(chain.reference_object.targets[0], chain.reference_object.COOKED.id)[0]
		cooked.amount += ceili(2 * (Util.floor_number * 0.2))
	else:
		# Apply cooked fresh
		var cooked = chain.reference_object.COOKED.duplicate()
		cooked.amount = ceili(10 * (Util.floor_number * 0.2))
		cooked.rounds = -1
		cooked.target = chain.reference_object.targets[0]
		cooked.bookkeeper = chain.reference_object.user
		chain.reference_object.manager.add_status_effect(cooked)

	# No instant effect, so do it ourselves.
	chain.reference_object.manager.affect_target(chain.reference_object.targets[0], ceili(10 * (Util.floor_number * 0.2)))
	await chain.reference_object.manager.check_pulses(chain.reference_object.targets)
