extends Object

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EndlessDifficultySetting = SettingsConfig.data["endlessdifficulty"]

func randomize_details(chain: ModLoaderHookChain) -> void:
	chain.reference_object.clear()
	
	chain.reference_object.anomalies = chain.reference_object.get_anomalies()
	chain.reference_object.anomaly_count = chain.reference_object.anomalies.size()

	for anomaly: Script in chain.reference_object.anomalies:
		chain.reference_object.modifiers.append(anomaly)
	
	chain.reference_object.floor_difficulty = Util.floor_number + 1
	if not chain.reference_object.floor_difficulty in chain.reference_object.LEVEL_RANGES.keys():
		chain.reference_object.level_range = chain.reference_object.get_calculated_level_range(chain.reference_object.floor_difficulty)
	else:
		chain.reference_object.level_range.x = chain.reference_object.LEVEL_RANGES[chain.reference_object.floor_difficulty][0]
		chain.reference_object.level_range.y = chain.reference_object.LEVEL_RANGES[chain.reference_object.floor_difficulty][1]
	
	# Add onto the room count for the difficulty
	chain.reference_object.room_count += chain.reference_object.DIFFICULTY_ROOM_ADDITION * chain.reference_object.floor_difficulty
	
	# Set the room cap to 29 to prevent a floor lasting like 72 hours or smth -cm37
	if chain.reference_object.room_count > 29:
		chain.reference_object.room_count = 29
	
	# Get the default Cog Pool if none specified
	if not chain.reference_object.cog_pool:
		chain.reference_object.cog_pool = chain.reference_object.FALLBACK_COG_POOL

## Simple failsafe backend for mods or if we're ever testing on floors > 5
## I will not be testing how well balanced this is
## You modders can do that one yourselves I believe in you
# i did it dad -cm37
# but in all honestly why the hell does the base endless range do 9/15*x^(1/3)? There's a big jump in level and this formula makes more sense. -cm37
func get_calculated_level_range(chain: ModLoaderHookChain, difficulty: int) -> Vector2i:
	var LowMultiplier = 2
	var HighMultiplier = 3
	if EndlessDifficultySetting == 0:
		LowMultiplier = 2
		HighMultiplier = 3
	elif EndlessDifficultySetting == 1:
		LowMultiplier = 2.5
		HighMultiplier = 3.5
	elif EndlessDifficultySetting == 2:
		LowMultiplier = 3
		HighMultiplier = 4
	elif EndlessDifficultySetting == 3:
		LowMultiplier = 4
		HighMultiplier = 6
	elif EndlessDifficultySetting == 4:
		LowMultiplier = 1.5
		HighMultiplier = 2.5
	var base_range := Vector2i(ceili(((Util.floor_number + 1) * LowMultiplier)), ceili((Util.floor_number + 1) * HighMultiplier))
	return base_range
