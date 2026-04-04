extends FloorModifier

const BOOST_AMT := 0.1
var floor_mod := 0.1

func modify_floor() -> void:
	if Util.floor_number > 5:
		floor_mod = 0.1 * (1 + (floor((Util.floor_number - 1) / 5) * 0.5))
	for track in Util.get_player().stats.gag_effectiveness:
		Util.get_player().stats.gag_effectiveness[track] += BOOST_AMT
	await Task.delay(10.0)
	clean_up()

func clean_up() -> void:
	for track in Util.get_player().stats.gag_effectiveness:
		Util.get_player().stats.gag_effectiveness[track] -= BOOST_AMT

func get_mod_name() -> String:
	return "Organic Gags"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/organic_gags.png")

func get_description() -> String:
	return "+10% damage for the floor! (Damage increase goes up by +5% every five floors)"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
