extends FloorModifier

var level_change_vector: Vector2i
var floor_mod = -1

## Increases the Cog level min/max for the floor
func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = ceil(-1 - ((Util.floor_number - 1) / 5))
	if tightened_sec_present():
		level_change_vector = Vector2i(floor_mod, 0)
	else:
		level_change_vector = Vector2(floor_mod, floor_mod)
	game_floor.level_range += level_change_vector

func clean_up() -> void:
	game_floor.level_range += Vector2i(1, 1)

func get_mod_name() -> String:
	return "Faulty Security"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/faulty_security.png")

func get_description() -> String:
	return "Cogs are one level lower (Level decrease goes up every five floors)"

func tightened_sec_present() -> bool:
	for modifier in game_floor.floor_variant.anomalies:
		if modifier.resource_path == "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_level_up.gd":
			return true
	return false
