extends Node

func _init():
	var overwrite_armchair = preload("res://mods-unpacked/CrazyMew37-EndlessMode/overwrites/objects/modules/cgc/variants/cgc_fairway_fence_prison.tscn")
	overwrite_armchair.take_over_path("res://objects/modules/cgc/variants/cgc_fairway_fence_prison.tscn")
