extends Object

func _ready(chain: ModLoaderHookChain) -> void:
	Globals.s_entered_barrel_room.emit()

	chain.reference_object.set_caged_toon_dna(chain.reference_object.get_caged_toon_dna())
	AudioManager.set_music(chain.reference_object.MUSIC_TRACK)
	# Set their level! Gonna mimic Buck here. -cm37
	# Pick the first boss
	chain.reference_object.boss_cog.level = Util.floor_number * 4
	var boss_choices = chain.reference_object.possible_bosses.duplicate()
	if chain.reference_object.DEBUG_FORCE_BOSS_ONE != null and OS.is_debug_build() and chain.reference_object.WANT_DEBUG_BOSSES:
		chain.reference_object.boss_one_choice = chain.reference_object.DEBUG_FORCE_BOSS_ONE
	else:
		chain.reference_object.boss_one_choice = RandomService.array_pick_random('base_seed', boss_choices)
	chain.reference_object.boss_cog.set_dna(chain.reference_object.boss_one_choice, false)
	boss_choices.erase(chain.reference_object.boss_one_choice)

	# Pick the second boss
	chain.reference_object.boss_cog_2.level = Util.floor_number * 4
	if chain.reference_object.DEBUG_FORCE_BOSS_TWO != null and OS.is_debug_build() and chain.reference_object.WANT_DEBUG_BOSSES:
		chain.reference_object.boss_two_choice = chain.reference_object.DEBUG_FORCE_BOSS_TWO
	else:
		chain.reference_object.boss_two_choice = RandomService.array_pick_random('base_seed', boss_choices)
	chain.reference_object.boss_cog_2.set_dna(chain.reference_object.boss_two_choice, false)

	# Nerf their damage got damn!!!
	chain.reference_object.boss_cog.stats.damage = 1.6
	chain.reference_object.boss_cog_2.stats.damage = 1.6

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
	var COG_EXTENDED_RANGE = chain.reference_object.COG_LEVEL_RANGE * (Util.floor_number * 0.2)
	var roll_for_proxies : bool = SaveFileService.progress_file.proxies_unlocked and not chain.reference_object.darkened_sky
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
