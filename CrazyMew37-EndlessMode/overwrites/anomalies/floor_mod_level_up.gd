extends FloorModifier

var level_change_vector: Vector2i
var floor_mod = 1

## Increases the Cog level min/max for the floor
func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = floor(1 + ((Util.floor_number - 1) / 5))
	if faulty_sec_present():
		level_change_vector = Vector2i(0, floor_mod)
	else:
		level_change_vector = Vector2(floor_mod, floor_mod)
	game_floor.level_range += level_change_vector
	

func clean_up() -> void:
	game_floor.level_range -= level_change_vector

func get_mod_name() -> String:
	return "Tightened Security"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/tightened_security.png")

func get_description() -> String:
	return "Cogs are one level higher (Level increase goes up every five floors)"

func faulty_sec_present() -> bool:
	for modifier in game_floor.floor_variant.anomalies:
		if modifier.resource_path == "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_level_down.gd":
			return true
	return false
