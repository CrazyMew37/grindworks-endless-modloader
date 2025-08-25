extends "res://objects/general_ui/settings_menu/settings_menu.gd"

# Kudos to Squiddy and their Hatstack mod for making these settings possible. This is complex stuff. -cm37
var EndlessEnabledButton : GeneralButton
var DupeButton : GeneralButton
var SpeedCapButton : GeneralButton
var ManagerFrequencyButton : GeneralButton
var EndlessDifficultyButton : GeneralButton

var Pla : Player

var endlessenabledId : int
var dupeId : int
var speedcapId : int
var overwritebattlespeedId : int
var managerfrequencyId : int
var endlessdifficultyId : int

const EndlessEnabledSetting : Dictionary = {
	0 : "On",
	1 : "Off",
}

const DupeSetting : Dictionary = {
	0 : "Every 5 Floors",
	1 : "Every 10 Floors",
	2 : "Every 20 Floors",
	3 : "Every 25 Floors",
	4 : "Every 50 Floors",
	5 : "Every 100 Floors",
	6 : "No Duplicates",
	7 : "Every Floor",
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

# don't sue me alder -cm37
var OverwriteBattleSpeedSetting = [1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 25.0, 50.0]

const ManagerFrequencySetting : Dictionary = {
	0 : "Every 5 Floors",
	1 : "Every 10 Floors",
	2 : "Every 20 Floors",
	3 : "Every 25 Floors",
	4 : "Every 50 Floors",
	5 : "Every 100 Floors",
	6 : "Every Floor",
}

const EndlessDifficultySetting : Dictionary = {
	0 : "Normal (2/3x)",
	1 : "Hard (2.5/3.5x)",
	2 : "Very Hard (3/4x)",
	3 : "Extreme (4/6x)",
	4 : "Easy (1.5/2.5x)",
}

func _ready() -> void:
	super()
	var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings").data
	endlessenabledId = SettingsConfig["endlessenabled"]
	dupeId = SettingsConfig["dupes"]
	speedcapId = SettingsConfig["speedcap"]
	overwritebattlespeedId = SettingsConfig["overwritebattlespeed"]
	managerfrequencyId = SettingsConfig["managerfrequency"]
	endlessdifficultyId = SettingsConfig["endlessdifficulty"]

	var DupeMenuResource = load("res://mods-unpacked/CrazyMew37-EndlessMode/dupe_settings.tscn")
	var DupeMenu = DupeMenuResource.instantiate()
	var SettingContainer = get_node("Panel/SettingScroller/MarginContainer/SettingContainer")
	add_child(DupeMenu)
	DupeMenu.reparent(SettingContainer)
	
	EndlessEnabledButton = DupeMenu.get_node("%EndlessEnabledButton")
	DupeButton = DupeMenu.get_node("%DupeButton")
	SpeedCapButton = DupeMenu.get_node("%SpeedCapButton")
	ManagerFrequencyButton = DupeMenu.get_node("%ManagerFrequencyButton")
	EndlessDifficultyButton = DupeMenu.get_node("%EndlessDifficultyButton")
	
	EndlessEnabledButton.text = EndlessEnabledSetting[endlessenabledId]
	DupeButton.text = DupeSetting[dupeId]
	SpeedCapButton.text = SpeedCapSetting[speedcapId]
	ManagerFrequencyButton.text = ManagerFrequencySetting[managerfrequencyId]
	EndlessDifficultyButton.text = EndlessDifficultySetting[endlessdifficultyId]

	EndlessEnabledButton.connect("pressed", endlessenabled)
	DupeButton.connect("pressed", dupe)
	SpeedCapButton.connect("pressed", speedcap)
	ManagerFrequencyButton.connect("pressed", managerfrequency)
	EndlessDifficultyButton.connect("pressed", endlessdifficulty)

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
	
func managerfrequency() -> void:
	managerfrequencyId += 1
	if managerfrequencyId >= len(ManagerFrequencySetting):
		managerfrequencyId = 0
	ManagerFrequencyButton.text = ManagerFrequencySetting[managerfrequencyId]
	
func endlessdifficulty() -> void:
	endlessdifficultyId += 1
	if endlessdifficultyId >= len(EndlessDifficultySetting):
		endlessdifficultyId = 0
	EndlessDifficultyButton.text = EndlessDifficultySetting[endlessdifficultyId]

# TIME TO HIJACK THE BATTLE SPEED! MWAHAHAHAHA!!! -cm37
func _sync_gameplay_settings() -> void:
	var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings").data
	speed_button.text = get_speed_string(OverwriteBattleSpeedSetting[SettingsConfig["overwritebattlespeed"]])
	reaction_button.text = get_toggle_text(get_setting('item_reactions'))
	auto_sprint_button.text = get_toggle_text(get_setting('auto_sprint'))
	control_style_button.text = get_control_style(get_setting('control_style'))
	cam_sens_slider.value = get_setting("camera_sensitivity")
	timer_button.text = get_toggle_text(get_setting('show_timer'))
	intro_skip_button.text = get_toggle_text(get_setting('skip_intro'))
	custom_cogs_button.text = get_toggle_text(get_setting('use_custom_cogs'))
	button_prompts_button.text = get_toggle_text(get_setting('button_prompts'))
	
	if not is_instance_valid(Util.floor_manager) or Util.stuck_lock:
		stuck_element.queue_free()
	if not SaveFileService.progress_file.characters_unlocked > 1:
		intro_skip_element.queue_free()
	
func change_speed() -> void:
	overwritebattlespeedId += 1
	if overwritebattlespeedId >= len(OverwriteBattleSpeedSetting):
		overwritebattlespeedId = 0
	speed_button.text = get_speed_string(OverwriteBattleSpeedSetting[overwritebattlespeedId])

# It was way, WAY too hard to make the speed cap update live. Thank god I found a way. -cm37
func close(save := false) -> void:
	super(save)
	if prev_file and not save:
		ModLoaderConfig.refresh_current_configs()
	else:
		var endlessConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
		endlessConfig.data = {
			"endlessenabled": endlessenabledId,
			"dupes": dupeId,
			"speedcap": speedcapId,
			"overwritebattlespeed": overwritebattlespeedId,
			"managerfrequency": managerfrequencyId,
			"endlessdifficulty": endlessdifficultyId,
		}
		ModLoaderConfig.update_config(endlessConfig)
		ModLoaderConfig.refresh_current_configs()
		if not is_instance_valid(SceneLoader.current_scene):
			var PauseChange = get_node("/root/PauseMenu")
			PauseChange.apply_stat_labels()
			PauseChange.apply_stat_changes()
