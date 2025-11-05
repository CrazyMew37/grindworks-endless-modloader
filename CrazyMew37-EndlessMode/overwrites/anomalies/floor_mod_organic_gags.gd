extends FloorModifier

const BOOST_AMT := 0.1
var floor_mod = 0.1

func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = 0.1 * floor(1 + ((Util.floor_number - 1) / 10))
	Util.get_player().stats.damage += floor_mod

func clean_up() -> void:
	Util.get_player().stats.damage -= floor_mod


func get_mod_name() -> String:
	return "Organic Gags"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/organic_gags.png")

func get_description() -> String:
	return "+10% damage for the floor! (Damage increase goes up every ten floors)"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
