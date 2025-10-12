extends Object

# Buff them boss cogs -cm37
func roll_for_level(chain: ModLoaderHookChain) -> void:
	# Get a random cog level first
	if chain.reference_object.level == 0:
		if is_instance_valid(Util.floor_manager):
			chain.reference_object.custom_level_range = Util.floor_manager.level_range
		elif chain.reference_object.dna: 
			chain.reference_object.custom_level_range = Vector2i(chain.reference_object.dna.level_low, chain.reference_object.dna.level_high)
		chain.reference_object.level = RNG.channel(RNG.ChannelCogLevels).randi_range(chain.reference_object.custom_level_range.x, chain.reference_object.custom_level_range.y)
	
	# Allow for Cogs to be higher level than the floor intends
	if sign( chain.reference_object.level_range_offset) == 1:
		if Util.floor_number > 5:
			chain.reference_object.level = chain.reference_object.custom_level_range.y + (chain.reference_object.level_range_offset * ceili(Util.floor_number * 0.2))
		else:
			chain.reference_object.level = chain.reference_object.custom_level_range.y + chain.reference_object.level_range_offset
	elif sign( chain.reference_object.level_range_offset) == -1:
		chain.reference_object.level = (chain.reference_object.custom_level_range.y - chain.reference_object.level_range_offset) + 1

# My first mod seperate from another's. Unsurprsingly, it nearly drove me mad at first. -cm37
## Scales the Cog's chain.reference_object.stats based on level
func set_up_stats(chain: ModLoaderHookChain) -> void:
	if not chain.reference_object.stats: chain.reference_object.stats = BattleStats.new()
	chain.reference_object.stats.max_hp = (chain.reference_object.level + 1) * (chain.reference_object.level + 2)

	if chain.reference_object.dna.is_mod_cog:
		chain.reference_object.health_mod *= Util.get_mod_cog_health_mod()
		# Nerf Proxy HP so that it's not ungodly high in later runs. Cap begins around floor 12 or so. -cm37
	if chain.reference_object.health_mod > 3.0:
		chain.reference_object.health_mod = 3.0
	if not is_equal_approx(chain.reference_object.dna.health_mod, 1.0):
		chain.reference_object.health_mod *= chain.reference_object.dna.health_mod
	if not is_equal_approx(chain.reference_object.health_mod, 1.0):
		chain.reference_object.stats.max_hp = ceili(chain.reference_object.stats.max_hp * chain.reference_object.health_mod)
	chain.reference_object.stats.hp = chain.reference_object.stats.max_hp
	chain.reference_object.stats.evasiveness = 0.5 + (chain.reference_object.level * 0.05)
	chain.reference_object.stats.damage = 0.4 + (chain.reference_object.level * 0.13)
	chain.reference_object.stats.accuracy = 0.75 + (chain.reference_object.level * 0.05)
	var new_text: String = chain.reference_object.dna.cog_name + '\n'
	new_text += 'Level ' + str(chain.reference_object.level)
	if chain.reference_object.v2: new_text += " v2.0"
	if chain.reference_object.dna.is_mod_cog: new_text += '\nProxy'
	if chain.reference_object.dna.is_admin: new_text += '\nAdministrator'
	if chain.reference_object.dna.custom_nametag_suffix: new_text += '\n%s' % chain.reference_object.dna.custom_nametag_suffix
	chain.reference_object.body.nametag.text = new_text
	chain.reference_object.body.nametag_node.update_position(new_text)
	if not chain.reference_object.stats.hp_changed.is_connected(chain.reference_object.update_health_light):
		chain.reference_object.stats.hp_changed.connect(chain.reference_object.update_health_light.unbind(1))
