extends Object

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var overwritebattlespeedId = SettingsConfig.data["overwritebattlespeed"]
var OverwriteBattleSpeedSetting = [1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0]

# Makes it so that the game only uses the BattleSpeed that the mod overwrites. -cm37
func apply_battle_speed(chain: ModLoaderHookChain) -> void:
	# Set the engine speed scale to the battle speed setting
	Engine.time_scale = OverwriteBattleSpeedSetting[overwritebattlespeedId]
