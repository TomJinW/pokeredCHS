SECTION "bank1", ROMX

INCLUDE "data/sprites/facings.asm"
INCLUDE "engine/events/black_out.asm"
INCLUDE "data/pokemon/mew.asm"
INCLUDE "engine/battle/safari_zone.asm"
INCLUDE "engine/movie/title.asm"
INCLUDE "engine/pokemon/load_mon_data.asm"
INCLUDE "data/items/prices.asm"
INCLUDE "data/items/names.asm"
INCLUDE "data/text/unused_names.asm"
INCLUDE "engine/gfx/sprite_oam.asm"
INCLUDE "engine/gfx/oam_dma.asm"
INCLUDE "engine/link/print_waiting_text.asm"
INCLUDE "engine/overworld/sprite_collisions.asm"
INCLUDE "engine/debug/debug_menu.asm"
INCLUDE "engine/events/pick_up_item.asm"
INCLUDE "engine/overworld/movement.asm"
INCLUDE "engine/link/cable_club.asm"
INCLUDE "engine/menus/main_menu.asm"
INCLUDE "engine/movie/oak_speech/oak_speech.asm"
INCLUDE "engine/overworld/special_warps.asm"
INCLUDE "engine/debug/debug_party.asm"
INCLUDE "engine/menus/naming_screen.asm"
INCLUDE "engine/movie/oak_speech/oak_speech2.asm"
INCLUDE "engine/items/subtract_paid_money.asm"
INCLUDE "engine/menus/swap_items.asm"
INCLUDE "engine/events/pokemart.asm"
INCLUDE "engine/pokemon/learn_move.asm"
INCLUDE "engine/events/pokecenter.asm"
INCLUDE "engine/events/set_blackout_map.asm"
INCLUDE "engine/menus/display_text_id_init.asm"
INCLUDE "engine/menus/draw_start_menu.asm"
INCLUDE "engine/link/cable_club_npc.asm"
INCLUDE "engine/menus/text_box.asm"
INCLUDE "engine/battle/move_effects/drain_hp.asm"
INCLUDE "engine/menus/players_pc.asm"
INCLUDE "engine/pokemon/remove_mon.asm"
INCLUDE "engine/events/display_pokedex.asm"


SECTION "bank3", ROMX

INCLUDE "engine/joypad.asm"
INCLUDE "data/maps/songs.asm"
INCLUDE "data/maps/map_header_banks.asm"
INCLUDE "engine/overworld/clear_variables.asm"
INCLUDE "engine/overworld/player_state.asm"
INCLUDE "engine/events/poison.asm"
INCLUDE "engine/overworld/tilesets.asm"
INCLUDE "engine/overworld/daycare_exp.asm"
INCLUDE "data/maps/hide_show_data.asm"
INCLUDE "engine/overworld/field_move_messages.asm"
INCLUDE "engine/items/inventory.asm"
INCLUDE "engine/overworld/wild_mons.asm"
INCLUDE "engine/items/item_effects.asm"
INCLUDE "engine/menus/draw_badges.asm"
INCLUDE "engine/overworld/update_map.asm"
INCLUDE "engine/overworld/cut.asm"
INCLUDE "engine/overworld/missable_objects.asm"
INCLUDE "engine/overworld/push_boulder.asm"
INCLUDE "engine/pokemon/add_mon.asm"
INCLUDE "engine/flag_action.asm"
INCLUDE "engine/events/heal_party.asm"
INCLUDE "engine/math/bcd.asm"
INCLUDE "engine/movie/oak_speech/init_player_data.asm"
INCLUDE "engine/items/get_bag_item_quantity.asm"
INCLUDE "engine/overworld/pathfinding.asm"
INCLUDE "engine/gfx/hp_bar.asm"
INCLUDE "engine/events/hidden_objects/bookshelves.asm"
INCLUDE "engine/events/hidden_objects/indigo_plateau_statues.asm"
INCLUDE "engine/events/hidden_objects/book_or_sculpture.asm"
INCLUDE "engine/events/hidden_objects/elevator.asm"
INCLUDE "engine/events/hidden_objects/town_map.asm"
INCLUDE "engine/events/hidden_objects/pokemon_stuff.asm"


SECTION "Font Graphics", ROMX

INCLUDE "gfx/font.asm"


SECTION "Battle Engine 1", ROMX

INCLUDE "engine/overworld/is_player_just_outside_map.asm"
INCLUDE "engine/pokemon/status_screen.asm"
INCLUDE "engine/menus/party_menu.asm"
INCLUDE "gfx/player.asm"
INCLUDE "engine/overworld/turn_sprite.asm"
INCLUDE "engine/menus/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"
INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/move_effects/recoil.asm"
INCLUDE "engine/battle/move_effects/conversion.asm"
INCLUDE "engine/battle/move_effects/haze.asm"
INCLUDE "engine/battle/get_trainer_name.asm"
INCLUDE "engine/math/random.asm"


SECTION "Battle Engine 2", ROMX

INCLUDE "engine/gfx/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/events/evolve_trade.asm"
INCLUDE "engine/battle/move_effects/substitute.asm"
INCLUDE "engine/menus/pc.asm"


SECTION "Play Time", ROMX

INCLUDE "engine/play_time.asm"


SECTION "Doors and Ledges", ROMX

INCLUDE "engine/overworld/auto_movement.asm"
INCLUDE "engine/overworld/doors.asm"
INCLUDE "engine/overworld/ledges.asm"


SECTION "Pokémon Names", ROMX

INCLUDE "data/pokemon/names.asm"
INCLUDE "engine/movie/oak_speech/clear_save.asm"
INCLUDE "engine/events/elevator.asm"


SECTION "Hidden Objects 1", ROMX

INCLUDE "engine/menus/oaks_pc.asm"
INCLUDE "engine/events/hidden_objects/new_bike.asm"
INCLUDE "engine/events/hidden_objects/oaks_lab_posters.asm"
INCLUDE "engine/events/hidden_objects/safari_game.asm"
INCLUDE "engine/events/hidden_objects/cinnabar_gym_quiz.asm"
INCLUDE "engine/events/hidden_objects/magazines.asm"
INCLUDE "engine/events/hidden_objects/bills_house_pc.asm"
INCLUDE "engine/events/hidden_objects/oaks_lab_email.asm"


SECTION "Bill's PC", ROMX

INCLUDE "engine/pokemon/bills_pc.asm"


SECTION "Battle Engine 3", ROMX

INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/save_trainer_name.asm"
INCLUDE "engine/battle/move_effects/focus_energy.asm"


SECTION "Battle Engine 4", ROMX

INCLUDE "engine/battle/move_effects/leech_seed.asm"


SECTION "Battle Engine 5", ROMX

INCLUDE "engine/battle/display_effectiveness.asm"
INCLUDE "gfx/trainer_card.asm"
INCLUDE "engine/items/tmhm.asm"
INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/battle/move_effects/pay_day.asm"
INCLUDE "engine/slots/game_corner_slots2.asm"


SECTION "Battle Engine 6", ROMX

INCLUDE "engine/battle/move_effects/mist.asm"
INCLUDE "engine/battle/move_effects/one_hit_ko.asm"


SECTION "Slot Machines", ROMX

INCLUDE "engine/movie/title2.asm"
INCLUDE "engine/battle/link_battle_versus_text.asm"
INCLUDE "engine/slots/slot_machine.asm"
INCLUDE "engine/events/pewter_guys.asm"
INCLUDE "engine/math/multiply_divide.asm"
INCLUDE "engine/slots/game_corner_slots.asm"


SECTION "Battle Engine 7", ROMX

INCLUDE "data/moves/moves.asm"
INCLUDE "data/pokemon/base_stats.asm"
INCLUDE "data/pokemon/cries.asm"
INCLUDE "engine/battle/unused_stats_functions.asm"
INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"
INCLUDE "gfx/trade.asm"
INCLUDE "engine/pokemon/evos_moves.asm"
INCLUDE "engine/battle/move_effects/heal.asm"
INCLUDE "engine/battle/move_effects/transform.asm"
INCLUDE "engine/battle/move_effects/reflect_light_screen.asm"


SECTION "Battle Core", ROMX

INCLUDE "engine/battle/core.asm"
INCLUDE "engine/battle/effects.asm"


SECTION "bank10", ROMX

INCLUDE "engine/menus/pokedex.asm"
INCLUDE "engine/movie/trade.asm"
INCLUDE "engine/movie/intro.asm"
INCLUDE "engine/movie/trade2.asm"


SECTION "Pokédex Rating", ROMX

INCLUDE "engine/events/pokedex_rating.asm"


SECTION "Hidden Objects Core", ROMX

INCLUDE "engine/overworld/hidden_objects.asm"


SECTION "Screen Effects", ROMX

INCLUDE "engine/gfx/screen_effects.asm"


SECTION "Predefs", ROMX

INCLUDE "engine/events/give_pokemon.asm"
INCLUDE "engine/predefs.asm"


SECTION "Battle Engine 8", ROMX

INCLUDE "engine/battle/init_battle_variables.asm"
INCLUDE "engine/battle/move_effects/paralyze.asm"


SECTION "Hidden Objects 2", ROMX

INCLUDE "engine/events/card_key.asm"
INCLUDE "engine/events/prize_menu.asm"
INCLUDE "engine/events/hidden_objects/school_notebooks.asm"
INCLUDE "engine/events/hidden_objects/fighting_dojo.asm"
INCLUDE "engine/events/hidden_objects/indigo_plateau_hq.asm"


SECTION "Battle Engine 9", ROMX

INCLUDE "engine/battle/experience.asm"


SECTION "Diploma", ROMX

INCLUDE "engine/events/diploma.asm"


SECTION "Trainer Sight", ROMX

INCLUDE "engine/overworld/trainer_sight.asm"


SECTION "Battle Engine 10", ROMX

INCLUDE "engine/battle/common_text.asm"
INCLUDE "engine/pokemon/experience.asm"
INCLUDE "engine/events/oaks_aide.asm"


SECTION "Saffron Guards", ROMX

INCLUDE "engine/events/saffron_guards.asm"


SECTION "Starter Dex", ROMX

INCLUDE "engine/events/starter_dex.asm"


SECTION "Hidden Objects 3", ROMX

INCLUDE "engine/pokemon/set_types.asm"
INCLUDE "engine/events/hidden_objects/reds_room.asm"
INCLUDE "engine/events/hidden_objects/route_15_binoculars.asm"
INCLUDE "engine/events/hidden_objects/museum_fossils.asm"
INCLUDE "engine/events/hidden_objects/school_blackboard.asm"
INCLUDE "engine/events/hidden_objects/vermilion_gym_trash.asm"


SECTION "Cinnabar Lab Fossils", ROMX

INCLUDE "engine/events/cinnabar_lab.asm"


SECTION "Hidden Objects 4", ROMX

INCLUDE "engine/events/hidden_objects/gym_statues.asm"
INCLUDE "engine/events/hidden_objects/bench_guys.asm"
INCLUDE "engine/events/hidden_objects/blues_room.asm"
INCLUDE "engine/events/hidden_objects/pokecenter_pc.asm"


SECTION "Battle Engine 11", ROMX

INCLUDE "engine/battle/decrement_pp.asm"
INCLUDE "gfx/version.asm"


SECTION "bank1C", ROMX

INCLUDE "engine/movie/splash.asm"
INCLUDE "engine/movie/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/items/town_map.asm"
INCLUDE "engine/gfx/mon_icons.asm"
INCLUDE "engine/events/in_game_trades.asm"
INCLUDE "engine/gfx/palettes.asm"
INCLUDE "engine/menus/save.asm"


SECTION "Itemfinder 1", ROMX

INCLUDE "engine/movie/credits.asm"
INCLUDE "engine/pokemon/status_ailments.asm"
INCLUDE "engine/items/itemfinder.asm"


SECTION "Vending Machine", ROMX

INCLUDE "engine/events/vending_machine.asm"


SECTION "Itemfinder 2", ROMX

INCLUDE "engine/menus/league_pc.asm"
INCLUDE "engine/events/hidden_items.asm"


SECTION "bank1E", ROMX

INCLUDE "engine/battle/animations.asm"
INCLUDE "engine/overworld/cut2.asm"
INCLUDE "engine/overworld/dust_smoke.asm"
INCLUDE "gfx/fishing.asm"
INCLUDE "data/moves/animations.asm"
INCLUDE "data/battle_anims/subanimations.asm"
INCLUDE "data/battle_anims/frame_blocks.asm"
INCLUDE "engine/movie/evolution.asm"
INCLUDE "engine/overworld/elevator.asm"
INCLUDE "engine/items/tm_prices.asm"

SECTION "Home 2", ROMX

INCLUDE "home2.asm"

SECTION "DFS", ROMX
INCLUDE "dfs/dfs.asm"

SECTION "Chinese Fonts 50", ROMX
DFS_C_FF_L::
DFS_C_FF_H::
DFS_C_01_L::
INCBIN "dfs/ChineseFonts_01_L.bin"
DFS_C_02_H::
INCBIN "dfs/ChineseFonts_02_H.bin"
DFS_C_03_L::
INCBIN "dfs/ChineseFonts_03_L.bin"
DFS_C_03_H::
INCBIN "dfs/ChineseFonts_03_H.bin"
DFS_C_01_H::
INCBIN "dfs/ChineseFonts_01_H.bin"
DFS_C_02_L::
INCBIN "dfs/ChineseFonts_02_L.bin"
DFS_C_04_L::
INCBIN "dfs/ChineseFonts_04_L.bin"

SECTION "Chinese Fonts 51", ROMX
DFS_C_04_H::
INCBIN "dfs/ChineseFonts_04_H.bin"
DFS_C_05_L::
INCBIN "dfs/ChineseFonts_05_L.bin"
DFS_C_05_H::
INCBIN "dfs/ChineseFonts_05_H.bin"
DFS_C_06_L::
INCBIN "dfs/ChineseFonts_06_L.bin"
DFS_C_06_H::
INCBIN "dfs/ChineseFonts_06_H.bin"
DFS_C_07_L::
INCBIN "dfs/ChineseFonts_07_L.bin"
DFS_C_07_H::
INCBIN "dfs/ChineseFonts_07_H.bin"

SECTION "Chinese Fonts 52", ROMX
DFS_C_08_L::
INCBIN "dfs/ChineseFonts_08_L.bin"
DFS_C_08_H::
INCBIN "dfs/ChineseFonts_08_H.bin"
DFS_C_09_L::
INCBIN "dfs/ChineseFonts_09_L.bin"
DFS_C_09_H::
INCBIN "dfs/ChineseFonts_09_H.bin"
DFS_C_0A_L::
INCBIN "dfs/ChineseFonts_0A_L.bin"
DFS_C_0A_H::
INCBIN "dfs/ChineseFonts_0A_H.bin"
DFS_C_0B_L::
INCBIN "dfs/ChineseFonts_0B_L.bin"

SECTION "Chinese Fonts 53", ROMX
DFS_C_0B_H::
INCBIN "dfs/ChineseFonts_0B_H.bin"
DFS_C_0C_L::
INCBIN "dfs/ChineseFonts_0C_L.bin"
DFS_C_0C_H::
INCBIN "dfs/ChineseFonts_0C_H.bin"
DFS_C_0D_L::
INCBIN "dfs/ChineseFonts_0D_L.bin"
DFS_C_0D_H::
INCBIN "dfs/ChineseFonts_0D_H.bin"
DFS_C_0E_L::
INCBIN "dfs/ChineseFonts_0E_L.bin"
DFS_C_0E_H::
INCBIN "dfs/ChineseFonts_0E_H.bin"

SECTION "Chinese Fonts 54", ROMX
DFS_C_0F_L::
INCBIN "dfs/ChineseFonts_0F_L.bin"
DFS_C_0F_H::
INCBIN "dfs/ChineseFonts_0F_H.bin"
DFS_C_10_L::
INCBIN "dfs/ChineseFonts_10_L.bin"
DFS_C_10_H::
INCBIN "dfs/ChineseFonts_10_H.bin"
DFS_C_11_L::
INCBIN "dfs/ChineseFonts_11_L.bin"
DFS_C_11_H::
INCBIN "dfs/ChineseFonts_11_H.bin"
DFS_C_12_L::
INCBIN "dfs/ChineseFonts_12_L.bin"

SECTION "Chinese Fonts 55", ROMX
DFS_C_12_H::
INCBIN "dfs/ChineseFonts_12_H.bin"
DFS_C_13_L::
INCBIN "dfs/ChineseFonts_13_L.bin"
DFS_C_13_H::
INCBIN "dfs/ChineseFonts_13_H.bin"
DFS_C_18_L::
INCBIN "dfs/ChineseFonts_18_L.bin"
DFS_C_18_H::
INCBIN "dfs/ChineseFonts_18_H.bin"
DFS_C_19_L::
INCBIN "dfs/ChineseFonts_19_L.bin"
DFS_C_19_H::
INCBIN "dfs/ChineseFonts_19_H.bin"

SECTION "Chinese Fonts 56", ROMX
DFS_C_1A_L::
INCBIN "dfs/ChineseFonts_1A_L.bin"
DFS_C_1A_H::
INCBIN "dfs/ChineseFonts_1A_H.bin"
DFS_C_1B_L::
INCBIN "dfs/ChineseFonts_1B_L.bin"
DFS_C_1B_H::
INCBIN "dfs/ChineseFonts_1B_H.bin"
DFS_C_1C_L::
INCBIN "dfs/ChineseFonts_1C_L.bin"
DFS_C_1C_H::
INCBIN "dfs/ChineseFonts_1C_H.bin"
DFS_C_1D_L::
INCBIN "dfs/ChineseFonts_1D_L.bin"

SECTION "Chinese Fonts 57", ROMX
DFS_C_1D_H::
INCBIN "dfs/ChineseFonts_1D_H.bin"
DFS_C_1E_L::
INCBIN "dfs/ChineseFonts_1E_L.bin"
DFS_C_1E_H::
INCBIN "dfs/ChineseFonts_1E_H.bin"
DFS_C_1F_L::
INCBIN "dfs/ChineseFonts_1F_L.bin"
DFS_C_1F_H::
INCBIN "dfs/ChineseFonts_1F_H.bin"
DFS_C_28_L::
INCBIN "dfs/ChineseFonts_28_L.bin"
DFS_C_28_H::
INCBIN "dfs/ChineseFonts_28_H.bin"

SECTION "Chinese Fonts 58", ROMX
DFS_C_29_L::
INCBIN "dfs/ChineseFonts_29_L.bin"
DFS_C_29_H::
INCBIN "dfs/ChineseFonts_29_H.bin"
DFS_C_2A_L::
INCBIN "dfs/ChineseFonts_2A_L.bin"
DFS_C_2A_H::
INCBIN "dfs/ChineseFonts_2A_H.bin"
DFS_C_2B_L::
INCBIN "dfs/ChineseFonts_2B_L.bin"
DFS_C_2B_H::
INCBIN "dfs/ChineseFonts_2B_H.bin"
DFS_C_2C_L::
INCBIN "dfs/ChineseFonts_2C_L.bin"

SECTION "Chinese Fonts 59", ROMX
DFS_C_2C_H::
INCBIN "dfs/ChineseFonts_2C_H.bin"
DFS_C_2D_L::
INCBIN "dfs/ChineseFonts_2D_L.bin"
DFS_C_2D_H::
INCBIN "dfs/ChineseFonts_2D_H.bin"
DFS_C_2E_L::
INCBIN "dfs/ChineseFonts_2E_L.bin"
DFS_C_2E_H::
INCBIN "dfs/ChineseFonts_2E_H.bin"

SECTION "MISC", ROMX
INCLUDE "engine/menus/naming_screen_util.asm"
SECTION "IMECodeTable", ROMX
INCLUDE "dfs/IMECodeTable.asm"