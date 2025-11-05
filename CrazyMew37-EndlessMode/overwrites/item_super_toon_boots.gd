extends ItemScript

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EnableNerfsSetting = SettingsConfig.data["enablenerfs"]
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_started)

func on_battle_started(manager: BattleManager) -> void:
	await get_tree().process_frame
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		manager.battle_stats[Util.get_player()].turns = 4
	else:
		manager.battle_stats[Util.get_player()].turns += 1
	manager.s_round_started.connect(reset_moves.bind(manager), CONNECT_ONE_SHOT)
	manager.battle_ui.refresh_turns()

func reset_moves(_actions, manager: BattleManager) -> void:
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		manager.battle_stats[Util.get_player()].turns = 3
	else:
		manager.battle_stats[Util.get_player()].turns -= 1
	manager.battle_ui.refresh_turns()
