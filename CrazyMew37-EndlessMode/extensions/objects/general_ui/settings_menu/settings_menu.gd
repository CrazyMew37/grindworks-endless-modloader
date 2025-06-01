extends "res://objects/general_ui/settings_menu/settings_menu.gd"

# Kudos to Squiddy and their Hatstack mod for making these settings possible. This is complex stuff. -cm37
var EndlessEnabledButton : GeneralButton
var DupeButton : GeneralButton
var SpeedCapButton : GeneralButton

var Pla : Player

var endlessenabledId : int
var dupeId : int
var speedcapId : int

const EndlessEnabledSetting : Dictionary = {
	0 : "On",
	1 : "Off",
}

const DupeSetting : Dictionary = {
	0 : "Every 5 Floors",
	1 : "Every Floor",
	2 : "No Duplicates",
}

const SpeedCapSetting : Dictionary = {
	0 : "200%",
	1 : "300%",
	2 : "400%",
	3 : "500%",
	4 : "1000%",
	5 : "Unlimited",
	6 : "150%",
}

func _ready() -> void:
	super()
	var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings").data
	endlessenabledId = SettingsConfig["endlessenabled"]
	dupeId = SettingsConfig["dupes"]
	speedcapId = SettingsConfig["speedcap"]

	var DupeMenuResource = load("res://mods-unpacked/CrazyMew37-EndlessMode/dupe_settings.tscn")
	var DupeMenu = DupeMenuResource.instantiate()
	var SettingContainer = get_node("Panel/SettingScroller/MarginContainer/SettingContainer")
	add_child(DupeMenu)
	DupeMenu.reparent(SettingContainer)
	
	EndlessEnabledButton = DupeMenu.get_node("%EndlessEnabledButton")
	DupeButton = DupeMenu.get_node("%DupeButton")
	SpeedCapButton = DupeMenu.get_node("%SpeedCapButton")
	
	EndlessEnabledButton.text = EndlessEnabledSetting[endlessenabledId]
	DupeButton.text = DupeSetting[dupeId]
	SpeedCapButton.text = SpeedCapSetting[speedcapId]

	EndlessEnabledButton.connect("pressed", endlessenabled)
	DupeButton.connect("pressed", dupe)
	SpeedCapButton.connect("pressed", speedcap)

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

func speedcap() -> void:
	speedcapId += 1
	if speedcapId >= len(SpeedCapSetting):
		speedcapId = 0
	SpeedCapButton.text = SpeedCapSetting[speedcapId]

	
func close(save := false) -> void:
	super(save)
	var endlessConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
	endlessConfig.data = {
		"endlessenabled": endlessenabledId,
		"dupes": dupeId,
		"speedcap": speedcapId,
	}
	ModLoaderConfig.update_config(endlessConfig)
	ModLoaderConfig.refresh_current_configs()
