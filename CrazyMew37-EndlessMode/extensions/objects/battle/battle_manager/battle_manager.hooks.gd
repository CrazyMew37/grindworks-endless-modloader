extends Object

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var overwritebattlespeedId = SettingsConfig.data["overwritebattlespeed"]
var OverwriteBattleSpeedSetting = [1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 25.0, 50.0]

func begin_turn(chain: ModLoaderHookChain):
	# Hide Battle UI
	chain.reference_object.battle_ui.hide()
	chain.reference_object.apply_battle_speed()
	chain.reference_object.current_round += 1
	chain.reference_object.is_round_ongoing = true
	# Inject partner moves before player's
	for partner in Util.get_player().partners:
		chain.reference_object.inject_battle_action(partner.get_attack(), 0)
	# Get actions from every Cog
	for cog in chain.reference_object.cogs:
		for i in cog.stats.turns:
			var attack = chain.reference_object.get_cog_attack(cog)
			if not attack == null:
				chain.reference_object.append_action(attack)
	chain.reference_object.s_round_started.emit(chain.reference_object.round_actions)
	await chain.reference_object.run_actions()
	chain.reference_object.round_over()

# Makes it so that the game only uses the BattleSpeed that the mod overwrites. -cm37
func apply_battle_speed(chain: ModLoaderHookChain) -> void:
	# Set the engine speed scale to the battle speed setting
	Engine.time_scale = OverwriteBattleSpeedSetting[overwritebattlespeedId]
