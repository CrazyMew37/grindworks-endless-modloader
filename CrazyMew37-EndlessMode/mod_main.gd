extends Node

# ! Comments prefixed with "!" mean they are extra info. Comments without them
# ! should be kept because they give your mod structure and make it easier to
# ! read by other modders
# ! Comments with "?" should be replaced by you with the appropriate information

# ! This template file is statically typed. You don't have to do that, but it can help avoid bugs
# ! You can learn more about static typing in the docs
# ! https://docs.godotengine.org/en/3.5/tutorials/scripting/gdscript/static_typing.html

# ? Brief overview of what your mod does...

const MOD_DIR := "CrazyMew37-EndlessMode" # Name of the directory that this file is in
const LOG_NAME := "CrazyMew37-EndlessMode:Main" # Full ID of the mod (AuthorName-ModName)

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


# ! your _ready func.
func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)

	# Add extensions
	install_script_extensions()
	install_script_hook_files()

	# Add translations
	add_translations()


func install_script_extensions() -> void:
	# ! any script extensions should go in this directory, and should follow the same directory structure as vanilla
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("objects/globals/globals.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("scenes/elevator_scene/elevator_scene.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("objects/general_ui/settings_menu/settings_menu.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("objects/modules/cgc/variants/armchair_manager_logic.gd"))


func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_hooks("res://objects/cog/cog.gd", extensions_dir_path.path_join("objects/cog/cog.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/interactables/treasure_chest/treasure_chest.gd", extensions_dir_path.path_join("objects/interactables/treasure_chest/treasure_chest.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://scenes/final_boss/penthouse_boss.gd", extensions_dir_path.path_join("scenes/final_boss/penthouse_boss.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://scenes/game_floor/floor_variants/floor_variant.gd", extensions_dir_path.path_join("scenes/game_floor/floor_variants/floor_variant.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/globals/item_service.gd", extensions_dir_path.path_join("objects/globals/item_service.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/status_effects/boss_effects/boss_logic_traffic_manager.gd", extensions_dir_path.path_join("objects/battle/battle_resources/status_effects/boss_effects/boss_logic_traffic_manager.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/status_effects/boss_effects/status_effect_bk_mental_math.gd", extensions_dir_path.path_join("objects/battle/battle_resources/status_effects/boss_effects/status_effect_bk_mental_math.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/misc_movies/bookkeeper/bk_cook_the_books.gd", extensions_dir_path.path_join("objects/battle/battle_resources/misc_movies/bookkeeper/bk_cook_the_books.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/interactables/lawbot_puzzles/lawbot_puzzle_grid.gd", extensions_dir_path.path_join("objects/interactables/lawbot_puzzles/lawbot_puzzle_grid.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/interactables/mole_stomp/mole_stomp.gd", extensions_dir_path.path_join("objects/interactables/mole_stomp/mole_stomp.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/modules/cgc/variants/cgc_maze_room.gd", extensions_dir_path.path_join("objects/modules/cgc/variants/cgc_maze_room.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/obstacles/room_timer.gd", extensions_dir_path.path_join("objects/obstacles/room_timer.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/modules/cgc/variants/cgc_multi_mole_manager.gd", extensions_dir_path.path_join("objects/modules/cgc/variants/cgc_multi_mole_manager.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_node/dynamic/battle_node_dynamic.gd", extensions_dir_path.path_join("objects/battle/battle_node/dynamic/battle_node_dynamic.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_resources/stats.gd", extensions_dir_path.path_join("objects/battle/battle_resources/stats.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/battle/battle_manager/battle_manager.gd", extensions_dir_path.path_join("objects/battle/battle_manager/battle_manager.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://objects/quests/types/quest_cog.gd", extensions_dir_path.path_join("objects/quests/types/quest_cog.hooks.gd"))
	ModLoaderMod.install_script_hooks("res://scenes/stranger_shop/stranger_shop.gd", extensions_dir_path.path_join("scenes/stranger_shop/stranger_shop.hooks.gd"))

func add_translations() -> void:
	# ! Place all of your translation files into this directory
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	var settingsConfig := ModLoaderConfig.get_config("CrazyMew37-EndlessMode", "endlesssettings")
	if not settingsConfig:
		settingsConfig == ModLoaderConfig.create_config("CrazyMew37-EndlessMode", "endlesssettings", {
			"endlessenabled": 0,
			"dupes": 0,
			"speedcap": 0,
			"overwritebattlespeed": 0,
			"managerfrequency": 0,
			"endlessdifficulty": 0,
			"jellybeanwipe": 0,
			"luckwipe": 0,
			"speedwipe": 0,
		})
