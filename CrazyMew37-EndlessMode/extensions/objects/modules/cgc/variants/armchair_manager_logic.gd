extends "res://objects/modules/cgc/variants/armchair_manager_logic.gd"

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EndlessDifficultySetting = SettingsConfig.data["endlessdifficulty"]
var DifficultyMultiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	set_arm_level()
	set_animation("sit")

# HAHAHAHA I DID IT!!! -cm37
func set_arm_level() -> void:
	if EndlessDifficultySetting == 1 && Util.floor_number > 6:
		DifficultyMultiplier = 1.25
	elif EndlessDifficultySetting == 2 && Util.floor_number > 6:
		DifficultyMultiplier = 1.5
	elif EndlessDifficultySetting == 3 && Util.floor_number > 6:
		DifficultyMultiplier = 2
	elif EndlessDifficultySetting == 4 && Util.floor_number > 6:
		DifficultyMultiplier = 0.75
	else:
		DifficultyMultiplier = 1
	var ArmchairMan = $/root/SceneLoader/GameFloor/Rooms/FairwayPrison/Navigation/Props/desk/Cog
	var ArmchairManDNA: CogDNA = load("res://objects/cog/presets/misc/armchair_manager.tres")
	if Util.floor_number > 5:
		ArmchairMan.level = 20 * ceili(ceili(Util.floor_number * 0.2) * DifficultyMultiplier)
	else:
		ArmchairMan.level = 20
	ArmchairMan.set_dna(ArmchairManDNA, false)
