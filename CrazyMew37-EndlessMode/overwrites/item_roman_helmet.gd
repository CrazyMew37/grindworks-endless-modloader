extends ItemScript

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EnableNerfsSetting = SettingsConfig.data["enablenerfs"]
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]

func on_collect(_item: Item, _object: Node3D) -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.cog_hp_death_threshold = 0.08
	else:
		player.stats.cog_hp_death_threshold += 0.08
	setup()

func on_load(_item: Item) -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.cog_hp_death_threshold = 0.08
	setup()

func setup() -> void:
	BattleService.s_cog_died_early.connect(cog_died_early)

func cog_died_early(_cog: Cog) -> void:
	if Util.get_player():
		Util.get_player().boost_queue.queue_text("No Mercy!", Color(1.0, 0.287, 0.225))

func on_item_removed() -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.cog_hp_death_threshold = 0.0
	else:
		player.stats.cog_hp_death_threshold -= 0.08
