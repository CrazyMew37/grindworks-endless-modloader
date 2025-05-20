extends Object

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
	chain.reference_object.stats.damage = 0.4 + (chain.reference_object.level * 0.1)
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
