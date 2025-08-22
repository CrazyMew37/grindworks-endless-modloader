extends Object

# SANIC - cm37
static var SPEED_SETTING_STAT = 2.0

# Additive
@export var max_hp := 25:
	set(x):
		max_hp = x
		max_hp_changed.emit(x)
@export var hp := 25:
	set(x):
		if debug_invulnerable:
			hp = max_hp
		else:
			hp = clamp(x, 0, max_hp)
		hp_changed.emit(hp)
@export var turns := 1
var debug_invulnerable := false

var multipliers: Array[StatMultiplier] = []

# Signals for objects listening
signal hp_changed(health: int)
signal max_hp_changed(health: int)
signal s_damage_changed(new_damaage: float)
signal s_accuracy_changed(new_accuracy: float)
signal s_defense_changed(new_defense: float)
signal s_evasiveness_changed(new_evasiveness: float)
signal s_speed_changed(new_speed: float)

func _to_string():
	var return_string := "Stats: \n"
	var active = false 
	for property in get_property_list():
		if not active and property.name != 'damage':
			continue
		elif property.name == 'damage': 
			active = true
		return_string += property.name + ': ' + str(get(property.name)) + '\n'
	return return_string

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var SpeedCapSetting = SettingsConfig.data["speedcap"]
func SetSpeedCap():
	SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
	SpeedCapSetting = SettingsConfig.data["speedcap"]
	if SpeedCapSetting == 1:
		SPEED_SETTING_STAT = 3.0
	elif SpeedCapSetting == 2:
		SPEED_SETTING_STAT = 4.0
	elif SpeedCapSetting == 3:
		SPEED_SETTING_STAT = 5.0
	elif SpeedCapSetting == 4:
		SPEED_SETTING_STAT = 10.0
	elif SpeedCapSetting == 5:
		SPEED_SETTING_STAT = UNCAPPED_STAT_VAL
	elif SpeedCapSetting == 6:
		SPEED_SETTING_STAT = 1.5
	else:
		SPEED_SETTING_STAT = 2.0

static var STAT_CLAMPS: Dictionary[String, Vector2] = {
	'speed' : Vector2(0.7, SPEED_SETTING_STAT),
	'damage' : Vector2(0.1, UNCAPPED_STAT_VAL),
	'defense' : Vector2(0.1, UNCAPPED_STAT_VAL),
	'evasiveness' : Vector2(0.1, UNCAPPED_STAT_VAL),
	'luck' : Vector2(0.1, UNCAPPED_STAT_VAL),
}
const UNCAPPED_STAT_VAL := -999.0

# Thanks Erin Miller for this. -cm37
func clamp_stat(chain: ModLoaderHookChain, stat: String, amount: float) -> float:
	var clamped_amount = chain.execute_next([stat, amount])
	SetSpeedCap()
	match stat:
		'speed':
			if amount < SPEED_SETTING_STAT or SpeedCapSetting == 5:
				return max(amount, 0.7)
			else:
				return clamp(amount, 0.7, SPEED_SETTING_STAT)
		_:
			return clamped_amount
