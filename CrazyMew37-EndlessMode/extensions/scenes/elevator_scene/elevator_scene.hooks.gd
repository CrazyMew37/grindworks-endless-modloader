extends Object

# This Elevator sucks -cm37

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]
var DupeSetting = SettingsConfig.data["dupes"]
var ManagerFrequencySetting = SettingsConfig.data["managerfrequency"]
var EndlessDifficultySetting = SettingsConfig.data["endlessdifficulty"]
var DifficultyMultiplier = 1
var JellybeanWipeSetting = SettingsConfig.data["jellybeanwipe"]
var LuckWipeSetting = SettingsConfig.data["jellybeanwipe"]
var SpeedWipeSetting = SettingsConfig.data["jellybeanwipe"]

# idc about the lag just let me hook this thing -cm37
var FINAL_FLOOR_VARIANT = preload('res://scenes/game_floor/floor_variants/alt_floors/final_boss_floor.tres')
var next_floors: Array[FloorVariant] = []


func _ready(chain: ModLoaderHookChain) -> void:
	var ElevatorGUI = chain.reference_object.get_node("ElevatorUI")
	if EndlessEnabledSetting == 1 && Util.floor_number > 4:
		ElevatorGUI.arrow_left.hide()
		ElevatorGUI.arrow_right.hide()
	
	# Get the player in here or so help me
	chain.reference_object.player = Util.get_player()
	if not chain.reference_object.player:
		chain.reference_object.player = load('res://objects/player/player.tscn').instantiate()
		SceneLoader.add_persistent_node(chain.reference_object.player)
	chain.reference_object.player.game_timer_tick = false
	chain.reference_object.player.state = Player.PlayerState.STOPPED
	chain.reference_object.player.global_position = chain.reference_object.player_pos.global_position
	chain.reference_object.player.face_position(chain.reference_object.camera.global_position)
	chain.reference_object.player.scale = Vector3(2, 2, 2)
	chain.reference_object.player.set_animation('neutral')
	chain.reference_object.camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if SaveFileService.run_file and SaveFileService.run_file.floor_choice:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		start_game_floor(chain, SaveFileService.run_file.floor_choice)
		return
	
	# Close the elevator doors
	chain.reference_object.elevator.animator.play('open')
	chain.reference_object.elevator.animator.seek(0.0)
	chain.reference_object.elevator.animator.pause()
	
	AudioManager.stop_music()
	AudioManager.set_default_music(load('res://audio/music/beta_installer.ogg'))
	
	# Obliterate those seen items. -cm37
	if DupeSetting == 0 && EndlessEnabledSetting == 0:
		if Util.floor_number % 5 == 0 && Util.floor_number > 4:
			ItemService.seen_items.clear()
	elif DupeSetting == 1 && EndlessEnabledSetting == 0:
		if Util.floor_number % 10 == 0 && Util.floor_number > 4:
			ItemService.seen_items.clear()
	elif DupeSetting == 2 && EndlessEnabledSetting == 0:
		if Util.floor_number % 20 == 0 && Util.floor_number > 4:
			ItemService.seen_items.clear()
	elif DupeSetting == 3 && EndlessEnabledSetting == 0:
		if Util.floor_number % 25 == 0 && Util.floor_number > 4:
			ItemService.seen_items.clear()
	elif DupeSetting == 4 && EndlessEnabledSetting == 0:
		if Util.floor_number % 50 == 0 && Util.floor_number > 4:
			ItemService.seen_items.clear()
	elif DupeSetting == 5 && EndlessEnabledSetting == 0:
		if Util.floor_number % 100 == 0 && Util.floor_number > 4:
			ItemService.seen_items.clear()
	elif DupeSetting == 7 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4:
			ItemService.seen_items.clear()
			
	# Obliterate those dragon wings and bee wings. -cm37
	# Note: The wipes happen a floor later than usual because of directors. -cm37
	if JellybeanWipeSetting == 1 && EndlessEnabledSetting == 0:
		if Util.floor_number % 5 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.money = 0
	elif JellybeanWipeSetting == 2 && EndlessEnabledSetting == 0:
		if Util.floor_number % 10 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.money = 0
	elif JellybeanWipeSetting == 3 && EndlessEnabledSetting == 0:
		if Util.floor_number % 20 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.money = 0
	elif JellybeanWipeSetting == 4 && EndlessEnabledSetting == 0:
		if Util.floor_number % 25 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.money = 0
	elif JellybeanWipeSetting == 5 && EndlessEnabledSetting == 0:
		if Util.floor_number % 50 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.money = 0
	elif JellybeanWipeSetting == 6 && EndlessEnabledSetting == 0:
		if Util.floor_number % 100 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.money = 0
			
	if LuckWipeSetting == 1 && EndlessEnabledSetting == 0:
		if Util.floor_number % 5 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.luck = 1.0
	elif LuckWipeSetting == 2 && EndlessEnabledSetting == 0:
		if Util.floor_number % 10 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.luck = 1.0
	elif LuckWipeSetting == 3 && EndlessEnabledSetting == 0:
		if Util.floor_number % 20 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.luck = 1.0
	elif LuckWipeSetting == 4 && EndlessEnabledSetting == 0:
		if Util.floor_number % 25 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.luck = 1.0
	elif LuckWipeSetting == 5 && EndlessEnabledSetting == 0:
		if Util.floor_number % 50 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.luck = 1.0
	elif LuckWipeSetting == 6 && EndlessEnabledSetting == 0:
		if Util.floor_number % 100 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.luck = 1.0
	
	if SpeedWipeSetting == 1 && EndlessEnabledSetting == 0:
		if Util.floor_number % 5 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.speed = 1.0
	elif SpeedWipeSetting == 2 && EndlessEnabledSetting == 0:
		if Util.floor_number % 10 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.speed = 1.0
	elif SpeedWipeSetting == 3 && EndlessEnabledSetting == 0:
		if Util.floor_number % 20 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.speed = 1.0
	elif SpeedWipeSetting == 4 && EndlessEnabledSetting == 0:
		if Util.floor_number % 25 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.speed = 1.0
	elif SpeedWipeSetting == 5 && EndlessEnabledSetting == 0:
		if Util.floor_number % 50 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.speed = 1.0
	elif SpeedWipeSetting == 6 && EndlessEnabledSetting == 0:
		if Util.floor_number % 100 == 1 && Util.floor_number > 4:
			chain.reference_object.player.stats.speed = 1.0
		
	# Save progress at every elevator scene
	await Task.delay(0.1)
	SaveFileService.save()
	
	# Get the next random floor
	get_next_floors(chain)

func start_floor(chain: ModLoaderHookChain, floor_var: FloorVariant):
	var ElevatorGUI = chain.reference_object.get_node("ElevatorUI")
	var OutsideNode = chain.reference_object.get_node("Outside")
	SaveFileService.run_file.floor_choice = floor_var
	SaveFileService.save()
	chain.reference_object.elevator.animator.play('open')
	chain.reference_object.player.turn_to_position(OutsideNode.global_position, 1.5)
	ElevatorGUI.hide()
	await chain.reference_object.camera.exit()
	
	start_game_floor(chain, floor_var)

func start_game_floor(chain: ModLoaderHookChain, floor_var : FloorVariant) -> void:
	chain.reference_object.player.scale = Vector3(1, 1, 1)
	chain.reference_object.player.game_timer_tick = true
	if floor_var.override_scene:
		SceneLoader.change_scene_to_packed(floor_var.override_scene)
	else:
		var game_floor: GameFloor = load('res://scenes/game_floor/game_floor.tscn').instantiate()
		game_floor.floor_variant = floor_var
		SceneLoader.change_scene_to_node(game_floor)

## Selects 3 random floors to give to the player
func get_next_floors(chain: ModLoaderHookChain) -> void:
	var ElevatorGUI = chain.reference_object.get_node("ElevatorUI")
	# Start of Manager Schenanigans -cm37
	if EndlessEnabledSetting == 1:
		if Util.floor_number > 4:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 0 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 5 == 0:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 1 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 10 == 0:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 2 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 20 == 0:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 3 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 25 == 0:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 4 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 50 == 0:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 5 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 100 == 0:
			final_boss_time_baby(chain)
	elif ManagerFrequencySetting == 6 && EndlessEnabledSetting == 0:
		final_boss_time_baby(chain)
	var floor_variants := Globals.FLOOR_VARIANTS
	var taken_items: Array[String] = []
	for i in 3:
		var new_floor := floor_variants[RNG.channel(RNG.ChannelFloors).randi() % floor_variants.size()]
		floor_variants.erase(new_floor)
		new_floor = new_floor.duplicate(true)
		
		# Roll for alt floor
		if new_floor.alt_floor and RNG.channel(RNG.ChannelFloors).randf() < chain.reference_object.ALT_FLOOR_CHANCE:
			new_floor = new_floor.alt_floor.duplicate(true)
		
		new_floor.randomize_details()
		while not new_floor.reward or new_floor.reward.item_name in taken_items:
			new_floor.randomize_item()
		next_floors.append(new_floor)
		taken_items.append(new_floor.reward.item_name)
	ElevatorGUI.floors = next_floors
	ElevatorGUI.set_floor_index(0)

func final_boss_time_baby(chain: ModLoaderHookChain) -> void:
	var ElevatorGUI = chain.reference_object.get_node("ElevatorUI")
	var final_floor = FINAL_FLOOR_VARIANT.duplicate()
	if EndlessDifficultySetting == 1 && EndlessEnabledSetting == 0 && Util.floor_number > 5:
		DifficultyMultiplier = 1.25
	elif EndlessDifficultySetting == 2 && EndlessEnabledSetting == 0 && Util.floor_number > 5:
		DifficultyMultiplier = 1.5
	elif EndlessDifficultySetting == 3 && EndlessEnabledSetting == 0 && Util.floor_number > 5:
		DifficultyMultiplier = 2
	elif EndlessDifficultySetting == 4 && EndlessEnabledSetting == 0 && Util.floor_number > 5:
		DifficultyMultiplier = 0.75
	else:
		DifficultyMultiplier = 1
	final_floor.level_range = Vector2i(ceili((0.8 * ((4 * DifficultyMultiplier) + (floori((Util.floor_number - 1.0) / 8.0) / 2.0))) * Util.floor_number) - (6.0 * floori((Util.floor_number + 5.0) / 10.0)), ceili((0.8 * ((4 * DifficultyMultiplier) + (floori((Util.floor_number - 1.0) / 8.0) / 2.0))) * Util.floor_number))
	next_floors = [final_floor]
	ElevatorGUI.floors = next_floors
	ElevatorGUI.set_floor_index(0)
