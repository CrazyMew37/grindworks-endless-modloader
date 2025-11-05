extends ItemScript

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EnableNerfsSetting = SettingsConfig.data["enablenerfs"]
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]

var multiplier: StatMultiplier

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	if not Util.get_player():
		await Util.s_player_assigned
	var player := Util.get_player()
	player.stats.s_speed_changed.connect(on_speed_changed)
	create_multiplier()
	on_speed_changed(player.stats.speed)

func on_item_removed() -> void:
	Util.get_player().stats.multipliers.erase(multiplier)

## Sync multipliers to current speed amount
func on_speed_changed(speed: float) -> void:
	multiplier.amount = maxf(0.0, (speed - 1.0) * 0.5)
	if multiplier.amount > 0.5 && EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		multiplier.amount = 0.5

func create_multiplier() -> void:
	multiplier = StatMultiplier.new()
	multiplier.stat = 'crit_mult'
	multiplier.amount = 0.0
	multiplier.additive = true
	Util.get_player().stats.multipliers.append(multiplier)
