extends ItemScript

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EnableNerfsSetting = SettingsConfig.data["enablenerfs"]
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]

func on_collect(item: Item, _model: Node3D) -> void:
	var player := Util.get_player()
	var game_floor := Util.floor_manager
	
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.anomaly_boost = 1
	else:
		player.stats.anomaly_boost += 1
	
	# Make sure our instances are valid
	if not is_instance_valid(game_floor) or not is_instance_valid(player):
		return
	
	# If we were the floor reward, we shouldn't add a new anomaly
	if game_floor.floor_variant.reward == item:
		return
	
	try_add_anomaly(game_floor)

func try_add_anomaly(game_floor: GameFloor) -> void:
	game_floor.spawn_new_anomalies(1)

func on_item_removed() -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.anomaly_boost = 0
	else:
		player.stats.anomaly_boost -= 1
