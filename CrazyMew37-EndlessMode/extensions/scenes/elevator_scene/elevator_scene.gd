extends "res://scenes/elevator_scene/elevator_scene.gd"

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]
var DupeSetting = SettingsConfig.data["dupes"]

func _ready():
	if Util.floor_number > 0 && Util.floor_number % 5 == 0:
		if EndlessEnabledSetting == 0:
			$ElevatorUI.arrow_left.show()
			$ElevatorUI.arrow_right.show()
		else:
			$ElevatorUI.arrow_left.hide()
			$ElevatorUI.arrow_right.hide()
	
	# Get the player in here or so help me
	player = Util.get_player()
	if not player:
		player = load('res://objects/player/player.tscn').instantiate()
		SceneLoader.add_persistent_node(player)
	player.game_timer_tick = false
	player.state = Player.PlayerState.STOPPED
	player.global_position = player_pos.global_position
	player.face_position(camera.global_position)
	player.scale = Vector3(2, 2, 2)
	player.set_animation('neutral')
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if SaveFileService.run_file and SaveFileService.run_file.floor_choice:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		start_game_floor(SaveFileService.run_file.floor_choice)
		return
	
	# Close the elevator doors
	elevator.animator.play('open')
	elevator.animator.seek(0.0)
	elevator.animator.pause()
	
	AudioManager.stop_music()
	AudioManager.set_default_music(load('res://audio/music/beta_installer.ogg'))
	
	# Obliterate those seen items. -cm37
	if DupeSetting == 0 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4 && Util.floor_number % 5 == 0:
			ItemService.seen_items.clear()
	elif DupeSetting == 1 && EndlessEnabledSetting == 0:
		if Util.floor_number > 4:
			ItemService.seen_items.clear()
		
	# Save progress at every elevator scene
	await Task.delay(0.1)
	SaveFileService.save()
	
	# Get the next random floor
	get_next_floors()

func start_floor(floor_var: FloorVariant):
	SaveFileService.run_file.floor_choice = floor_var
	SaveFileService.save()
	elevator.animator.play('open')
	player.turn_to_position($Outside.global_position, 1.5)
	$ElevatorUI.hide()
	await camera.exit()
	
	start_game_floor(floor_var)

func start_game_floor(floor_var : FloorVariant) -> void:
	player.scale = Vector3(1, 1, 1)
	player.game_timer_tick = true
	if floor_var.override_scene:
		SceneLoader.change_scene_to_packed(floor_var.override_scene)
	else:
		var game_floor: GameFloor = load('res://scenes/game_floor/game_floor.tscn').instantiate()
		game_floor.floor_variant = floor_var
		SceneLoader.change_scene_to_node(game_floor)

## Selects 3 random floors to give to the player
func get_next_floors() -> void:
	if Util.floor_number > 4 && Util.floor_number % 5 == 0:
		final_boss_time_baby()
	var floor_variants := Globals.FLOOR_VARIANTS
	var taken_items: Array[String] = []
	for i in 3:
		var new_floor := floor_variants[RandomService.randi_channel('floors') % floor_variants.size()]
		floor_variants.erase(new_floor)
		new_floor = new_floor.duplicate()
		
		# Roll for alt floor
		if new_floor.alt_floor and RandomService.randi_channel('floors') % ALT_FLOOR_CHANCE == 0:
			new_floor = new_floor.alt_floor.duplicate()
		
		new_floor.randomize_details()
		while not new_floor.reward or new_floor.reward.item_name in taken_items:
			new_floor.randomize_item()
		next_floors.append(new_floor)
		taken_items.append(new_floor.reward.item_name)
	$ElevatorUI.floors = next_floors
	$ElevatorUI.set_floor_index(0)

func final_boss_time_baby() -> void:
	var final_floor := FINAL_FLOOR_VARIANT.duplicate()
	final_floor.level_range = Vector2i((9 * (Util.floor_number / 5)), (14 * (Util.floor_number / 5)))
	next_floors = [final_floor]
	$ElevatorUI.floors = next_floors
	$ElevatorUI.set_floor_index(0)
