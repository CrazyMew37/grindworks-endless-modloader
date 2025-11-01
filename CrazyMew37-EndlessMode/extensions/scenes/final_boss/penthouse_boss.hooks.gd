extends Object

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EndlessDifficultySetting = SettingsConfig.data["endlessdifficulty"]
var DifficultyMultiplier = 1

func _ready(chain: ModLoaderHookChain) -> void:
	if EndlessDifficultySetting == 1 && Util.floor_number > 5:
		DifficultyMultiplier = 5
	elif EndlessDifficultySetting == 2 && Util.floor_number > 5:
		DifficultyMultiplier = 6
	elif EndlessDifficultySetting == 3 && Util.floor_number > 5:
		DifficultyMultiplier = 8
	elif EndlessDifficultySetting == 4 && Util.floor_number > 5:
		DifficultyMultiplier = 3
	else:
		DifficultyMultiplier = 4
	Globals.s_entered_barrel_room.emit()

	chain.reference_object.set_caged_toon_dna(chain.reference_object.get_caged_toon_dna())
	AudioManager.set_music(chain.reference_object.MUSIC_TRACK)
	# Set their level! Gonna mimic Buck here. -cm37
	# Pick the first boss
	chain.reference_object.boss_cog.level = ceili(((Util.floor_number) * (DifficultyMultiplier + (floori((Util.floor_number - 1) / 8) / 2))))
	var boss_choices = chain.reference_object.possible_bosses.duplicate()
	if chain.reference_object.DEBUG_FORCE_BOSS_ONE != null and OS.is_debug_build() and chain.reference_object.WANT_DEBUG_BOSSES:
		chain.reference_object.boss_one_choice = chain.reference_object.DEBUG_FORCE_BOSS_ONE
	else:
		chain.reference_object.boss_one_choice = RandomService.array_pick_random('base_seed', boss_choices)
	chain.reference_object.boss_cog.set_dna(chain.reference_object.boss_one_choice, false)
	boss_choices.erase(chain.reference_object.boss_one_choice)

	# Pick the second boss
	chain.reference_object.boss_cog_2.level = Util.floor_number * DifficultyMultiplier
	if chain.reference_object.DEBUG_FORCE_BOSS_TWO != null and OS.is_debug_build() and chain.reference_object.WANT_DEBUG_BOSSES:
		chain.reference_object.boss_two_choice = chain.reference_object.DEBUG_FORCE_BOSS_TWO
	else:
		chain.reference_object.boss_two_choice = RandomService.array_pick_random('base_seed', boss_choices)
	chain.reference_object.boss_cog_2.set_dna(chain.reference_object.boss_two_choice, false)

	# Nerf their damage got damn!!!
	chain.reference_object.boss_cog.stats.damage = 1.8
	chain.reference_object.boss_cog_2.stats.damage = 1.8

	# Start the battle
	Util.get_player().state = Player.PlayerState.WALK
	chain.reference_object.battle.player_entered(Util.get_player())

	if not BattleService.ongoing_battle:
		await BattleService.s_battle_started

	# Every 2 rounds, starting on round 2: Spawn in 2 more cogs
	BattleService.ongoing_battle.s_round_started.connect(chain.reference_object.try_add_cogs)
	BattleService.ongoing_battle.s_participant_died.connect(chain.reference_object.participant_died)
	BattleService.ongoing_battle.s_battle_ending.connect(chain.reference_object.battle_ending)

	chain.reference_object.boss_cog.stats.hp_changed.connect(chain.reference_object.on_boss_hp_changed)
	chain.reference_object.boss_cog_2.stats.hp_changed.connect(chain.reference_object.on_boss_hp_changed)

func fill_elevator(chain: ModLoaderHookChain, cog_count: int, dna: CogDNA = null) -> Array[Cog]:
	if EndlessDifficultySetting == 1 && Util.floor_number > 5:
		DifficultyMultiplier = 1.25
	elif EndlessDifficultySetting == 2 && Util.floor_number > 5:
		DifficultyMultiplier = 1.5
	elif EndlessDifficultySetting == 3 && Util.floor_number > 5:
		DifficultyMultiplier = 2.0
	elif EndlessDifficultySetting == 4 && Util.floor_number > 5:
		DifficultyMultiplier = 0.75
	else:
		DifficultyMultiplier = 1.0
	var COG_EXTENDED_RANGE = Vector2i(ceili(0.7 * (((Util.floor_number) * ((4 * DifficultyMultiplier) + (floori((Util.floor_number - 1) / 8) / 2))))) - 5 * floori((Util.floor_number + 5) / 10), ceili(0.7 * (((Util.floor_number) * ((4 * DifficultyMultiplier) + (floori((Util.floor_number - 1) / 8) / 2))))))
	var roll_for_proxies : bool = SaveFileService.progress_file.proxies_unlocked and chain.reference_object.darkened_sky
	var new_cogs: Array[Cog]
	for i in cog_count:
		var cog = chain.reference_object.COG_SCENE.instantiate()
		cog.custom_level_range = COG_EXTENDED_RANGE
		if dna: cog.dna = dna
		elif roll_for_proxies and RandomService.randf_channel('mod_cog_chance') < 0.25:
			cog.use_mod_cogs_pool = true
		chain.reference_object.battle.add_child(cog)
		cog.global_position = chain.reference_object.get_char_position("CogPos%d" % (i + 1))
		new_cogs.append(cog)
	return new_cogs
