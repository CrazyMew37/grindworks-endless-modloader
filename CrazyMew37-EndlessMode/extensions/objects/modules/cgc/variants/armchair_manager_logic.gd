extends "res://objects/modules/cgc/variants/armchair_manager_logic.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	set_arm_level()
	set_animation("sit")

# HAHAHAHA I DID IT!!! -cm37
func set_arm_level() -> void:
	var ArmchairMan = $/root/GameFloor/Rooms/FairwayPrison/Navigation/Props/desk/Cog
	var ArmchairManDNA: CogDNA = load("res://objects/cog/presets/misc/armchair_manager.tres")
	if Util.floor_number > 5:
		ArmchairMan.level = 20 * ceili(Util.floor_number * 0.2)
	else:
		ArmchairMan.level = 20
	ArmchairMan.set_dna(ArmchairManDNA, false)
