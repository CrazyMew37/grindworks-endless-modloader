extends "res://objects/general_ui/settings_menu/settings_menu.gd"

# Kudos to Squiddy and their Hatstack mod for making these settings possible. This is complex stuff. -cm37
var EndlessEnabledButton : GeneralButton
var DupeButton : GeneralButton

var Pla : Player

var endlessenabledId : int
var dupeId : int

const EndlessEnabledSetting : Dictionary = {
	0 : "On",
	1 : "Off",
}

const DupeSetting : Dictionary = {
	0 : "Every 5 Floors",
	1 : "Every Floor",
	2 : "No Duplicates",
}

func _ready() -> void:
	super()
	var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings").data
	endlessenabledId = SettingsConfig["endlessenabled"]
	dupeId = SettingsConfig["dupes"]

	var DupeMenuResource = load("res://mods-unpacked/CrazyMew37-EndlessMode/dupe_settings.tscn")
	var DupeMenu = DupeMenuResource.instantiate()
	var SettingContainer = get_node("Panel/SettingScroller/MarginContainer/SettingContainer")
	add_child(DupeMenu)
	DupeMenu.reparent(SettingContainer)
	
	EndlessEnabledButton = DupeMenu.get_node("%EndlessEnabledButton")
	DupeButton = DupeMenu.get_node("%DupeButton")
	
	EndlessEnabledButton.text = EndlessEnabledSetting[endlessenabledId]
	DupeButton.text = DupeSetting[dupeId]
	
	EndlessEnabledButton.connect("pressed", endlessenabled)
	DupeButton.connect("pressed", dupe)

func endlessenabled() -> void:
	endlessenabledId += 1
	if endlessenabledId >= len(EndlessEnabledSetting):
		endlessenabledId = 0
	EndlessEnabledButton.text = EndlessEnabledSetting[endlessenabledId]

func dupe() -> void:
	dupeId += 1
	if dupeId >= len(DupeSetting):
		dupeId = 0
	DupeButton.text = DupeSetting[dupeId]
	
	
func close(save := false) -> void:
	super(save)
	var endlessConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
	endlessConfig.data = {
		"endlessenabled": endlessenabledId,
		"dupes": dupeId,
	}
	ModLoaderConfig.update_config(endlessConfig)
	ModLoaderConfig.refresh_current_configs()
