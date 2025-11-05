extends ItemScript

var SettingsConfig = ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
var EnableNerfsSetting = SettingsConfig.data["enablenerfs"]
var EndlessEnabledSetting = SettingsConfig.data["endlessenabled"]

const ChancePerProxy := 0.35

var curr_battle_proxy_num: int = 0

func on_collect(_item: Item, _object: Node3D) -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.proxy_health_mod = -0.25
	else:
		player.stats.proxy_health_mod -= 0.25
	setup()

func on_load(_item: Item) -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.proxy_health_mod = -0.25
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(_battle_started)

func _battle_started(battle: BattleManager) -> void:
	curr_battle_proxy_num = battle.cogs.filter(func(x: Cog): return x.dna.is_mod_cog).size()
	battle.s_spawned_reward_chest.connect(_spawned_reward_chest)

func _spawned_reward_chest(chest: TreasureChest) -> void:
	if RNG.channel(RNG.ChannelRolodexRolls).randf() <= (ChancePerProxy * curr_battle_proxy_num):
		chest.make_duplicate_chest()
		Util.get_player().boost_queue.queue_text("Double Down!", Color.GREEN)
		
func on_item_removed() -> void:
	var player := Util.get_player()
	if EnableNerfsSetting == 0 && EndlessEnabledSetting == 0:
		player.stats.proxy_health_mod = 0.0
	else:
		player.stats.proxy_health_mod += 0.25
