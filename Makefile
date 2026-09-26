name := GBWARS3

PYTHON ?= python3

RGBASMFLAGS := -p 0xff
RGBLINKFLAGS := -p 0xff
RGBFIXFLAGS := -Wno-overwrite -v -p 0xff

RGBDS_VERSION ?= 1.0.3
RGBDS_ARCHIVE ?=
RGBDS_BIN_DIR ?= tools/rgbds/bin
ifeq ($(OS),Windows_NT)
RGBDS_EXEEXT := .exe
else
RGBDS_EXEEXT :=
endif
LOCAL_RGBASM := $(RGBDS_BIN_DIR)/rgbasm$(RGBDS_EXEEXT)
LOCAL_RGBLINK := $(RGBDS_BIN_DIR)/rgblink$(RGBDS_EXEEXT)
LOCAL_RGBFIX := $(RGBDS_BIN_DIR)/rgbfix$(RGBDS_EXEEXT)
LOCAL_RGBDS_VERSION_FILE := $(RGBDS_BIN_DIR)/VERSION
LOCAL_RGBDS_STAMP := $(RGBDS_BIN_DIR)/.version-$(RGBDS_VERSION)

RGBASM ?= $(LOCAL_RGBASM)
RGBLINK ?= $(LOCAL_RGBLINK)
RGBFIX ?= $(LOCAL_RGBFIX)
BUNDLED_RGBGFX := tools/rgbgfx-legacy/rgbgfx
RGBGFX ?= $(BUNDLED_RGBGFX)

objects := \
	symbols.o \
	engine/remaining_rom.o \
	data/gfx/graphics.o \
	engine/map/map_graphics.o \
	data/misc_text.o \
	engine/home/home.o \
	engine/home/home_boot_entry.o \
	engine/home/home_far_copy.o \
	engine/home/home_bank_call.o \
	engine/home/home_battle_helicopter_hp.o \
	engine/home/home_vram_tile_rectangle.o \
	engine/home/home_text_row.o \
	engine/home/home_infrared.o \
	engine/home/home_infrared_controller.o \
	engine/home/home_main_init.o \
	engine/home/home_bank2_startup_bridge.o \
	engine/home/home_mobile_runtime.o \
	engine/home/random_range.o \
	engine/home/home_medal_detail_lcd_stat.o \
	engine/home/home_vblank_fifo_enqueue.o \
	engine/home/home_vblank_two_plane_tile.o \
	engine/home/home_system.o \
	engine/home/home_indexed_bg_rectangle.o \
	engine/home/home_attract_layout.o \
	engine/home/home_fade_audio.o \
	engine/home/home_checksum.o \
	engine/home/home_mobile_api.o \
	engine/mobile/mobile_adapter_driver.o \
	engine/mobile/mobile_adapter_driver_requests_00_04.o \
	engine/mobile/mobile_adapter_driver_requests_06_10.o \
	engine/mobile/mobile_adapter_driver_requests_12_18.o \
	engine/mobile/mobile_adapter_driver_requests_1a_26.o \
	engine/mobile/mobile_adapter_driver_requests_28_2e.o \
	engine/mobile/mobile_adapter_driver_requests_32_42.o \
	engine/mobile/mobile_adapter_serial_service.o \
	engine/mobile/mobile_adapter_lcd_timer_service.o \
	engine/mobile/mobile_adapter_protocol_templates.o \
	engine/mobile/mobile_adapter_network_client.o \
	engine/mobile/mobile_adapter_response_parser.o \
	engine/mobile/mobile_adapter_response_headers.o \
	engine/mobile/mobile_adapter_auth_crypto_tail.o \
	engine/home/home_sound_bridge.o \
	engine/home/home_map.o \
	engine/home/home_arithmetic_core.o \
	engine/home/home_sprite_object.o \
	engine/sprite/sprite_data.o \
	engine/sprite/sprite_animation_data.o \
	engine/home/home_banked_text.o \
	engine/home/home_campaign_briefing.o \
	engine/network/text_shift_jis_converter.o \
	audio/music_driver.o \
	audio/driver_copies/music_driver_bank03.o \
	audio/driver_copies/music_driver_bank05.o \
	audio/driver_copies/music_driver_bank06.o \
	audio/driver_copies/music_driver_bank07.o \
	audio/driver_copies/music_driver_bank3e.o \
	audio/driver_copies/music_driver_bank3f.o \
	audio/music_data_bank03.o \
	audio/music_data_bank04.o \
	audio/music_data_bank05.o \
	audio/music_data_bank06.o \
	audio/music_data_bank07.o \
	audio/music_banks_3e_3f.o \
	audio/sound_driver.o \
	audio/driver_copies/sound_driver_bank09.o \
	audio/sound_data_bank08.o \
	audio/sound_data_bank09.o \
	engine/unit/unit.o \
	engine/unit/unit_setup.o \
	data/news.o \
	engine/map/map_editor_frontend_4000.o \
	engine/map/map_editor_interaction_runtime_4170.o \
	engine/map/map_editor_menu_handlers_460f.o \
	engine/map/map_editor_submenu_arrange_4d65.o \
	engine/map/map_editor_arrange_options_517e.o \
	engine/map/map_editor_fill_rectangle_52da.o \
	engine/map/map_editor.o \
	engine/ui/text_input.o \
	engine/ui/text_input_redraw_runtime_5245.o \
	engine/ui/common_screen_tilemap_runtime.o \
	engine/ui/sprite_exit_transition_runtime.o \
	engine/ui/map_menu_message_service_bank22.o \
	engine/ui/window_frame_attribute_helper_bank22.o \
	engine/ui/window_stack_runtime.o \
	engine/ui/title_screen_runtime.o \
	engine/ui/title_screen_background.o \
	engine/ui/startup_title_controller.o \
	engine/ui/attract_intro_runtime.o \
	engine/ui/attract_graphics_loader_bank26.o \
	engine/ui/attract_scene_runtime.o \
	engine/ui/attract_scene_resources_bank23.o \
	engine/ui/attract_scene_resources_bank24.o \
	engine/ui/startup_hardware_presentation.o \
	engine/ui/mobile_system_gb_logo.o \
	engine/ui/shared_presentation_runtime.o \
	engine/ui/campaign_background_runtime.o \
	engine/ui/presentation_sequence_dispatch.o \
	engine/ui/presentation_sequence_bodies.o \
	engine/ui/presentation_unit_sprite_loader.o \
	engine/ui/presentation_palette_wait_bank31.o \
	engine/ui/main_mode_dispatcher_bank14.o \
	engine/ui/file_slot_confirmation_runtime_bank14.o \
	engine/ui/main_menu_runtime.o \
	engine/ui/suspend_resume_runtime.o \
	engine/ui/suspend_saved_session_preview.o \
	engine/ui/main_mode_reset_runtime.o \
	engine/map/map_selection_runtime_bank15.o \
	engine/ui/bank26_reset_runtime.o \
	engine/map/map_name_ui.o \
	engine/map/map_name_9char.o \
	engine/map/map_runtime.o \
	engine/map/map_menu_reset_runtime_bank13.o \
	engine/map/bank0b_map_setup_runtime_4000.o \
	engine/map/map_cursor_presentation_runtime_4551.o \
	engine/map/bank0b_scanline_transition_4822.o \
	engine/map/bank0b_construction_actions_4941.o \
	engine/map/bank0b_construction_direction_hptransfer_4c18.o \
	engine/map/unit_action_menu_runtime_4f82.o \
	engine/map/bank0b_map_cursor_runtime_52bc.o \
	engine/map/bank0b_coordinate_analysis_54e0.o \
	engine/map/bank0b_connected_analysis_569b.o \
	engine/map/bank0b_analysis_fuel_cost_5709.o \
	engine/map/bank0b_side_unit_grid_573c.o \
	engine/map/bank0b_side_adjacency_test_57ae.o \
	engine/map/bank0b_side_occupancy_test_57c2.o \
	engine/unit/unit_creation_selection_runtime_57d6.o \
	engine/unit/unit_creation_property_eligibility_59bd.o \
	engine/unit/unit_creation_details_runtime_5a9c.o \
	engine/unit/unit_creation_purchase_affordability_5c1f.o \
	engine/unit/unit_creation_purchase_apply_5c68.o \
	engine/unit/unit_creation_selected_graphic_5c89.o \
	engine/unit/unit_creation_transport_state_5cb0.o \
	engine/unit/unit_transport_carried_child_list_setup_5cc3.o \
	engine/unit/unit_transport_carried_child_selection_5ccf.o \
	engine/unit/unit_transport_selected_child_resolver_5d6c.o \
	engine/unit/unit_transport_movement_selection_5e1e.o \
	engine/unit/unit_action_menu_active_runtime_5ed4.o \
	engine/unit/unit_action_move_runtime_5f44.o \
	engine/unit/unit_action_context_menu_601e.o \
	engine/unit/unit_action_move_availability_6096.o \
	engine/unit/unit_action_pave_availability_60a2.o \
	engine/unit/unit_action_1b_availability_60c0.o \
	engine/unit/unit_transport_action_availability_60d6.o \
	engine/unit/unit_action_fire_availability_60f7.o \
	engine/unit/unit_action_capture_availability_610e.o \
	engine/unit/unit_action_0a_availability_6128.o \
	engine/unit/unit_action_hp_transfer_availability_6142.o \
	engine/unit/unit_action_construction_availability_615c.o \
	engine/unit/unit_action_bomb_availability_6176.o \
	engine/unit/unit_action_load_availability_6194.o \
	engine/unit/unit_action_0f_availability_61ae.o \
	engine/unit/unit_action_wait_availability_61cd.o \
	engine/unit/unit_action_context_controller_61da.o \
	engine/unit/unit_action_executor_6283.o \
	engine/unit/unit_action_delete_wait_finalize_6524.o \
	engine/unit/unit_selection_interaction_presentation_655b.o \
	engine/unit/unit_selection_details_renderer_656e.o \
	engine/unit/unit_selection_details_tail_66f2.o \
	engine/unit/unit_selection_coordinate_init_67e3.o \
	engine/unit/unit_selection_coordinate_refresh_67fb.o \
	engine/unit/unit_selection_coordinate_phase_6815.o \
	engine/unit/unit_selection_scratch_map_presentation_683b.o \
	engine/unit/unit_selection_shared_map_presentation_6869.o \
	engine/unit/unit_action_common_finalize_68f4.o \
	engine/unit/unit_side_rank_table_693d.o \
	engine/unit/unit_experience_rank_change_presentation_6977.o \
	engine/map/ai/map_control_resolution_presentation_6a23.o \
	engine/map/ai/map_control_selected_map_controller_6b26.o \
	engine/map/ai/map_control_force_mode_6cfd.o \
	engine/map/ai/map_control_post_action_update_6d18.o \
	engine/map/ai/map_control_unit_elimination_6d69.o \
	engine/map/ai/map_control_turn_limit_6d9a.o \
	engine/map/ai/map_control_beginner_completion_6dfc.o \
	engine/map/map_call_presentation_bank1a.o \
	engine/map/map_result_presentation_bank1a.o \
	engine/map/map_result_presentation_bank27.o \
	engine/map/map_status_presentation_bank27.o \
	engine/map/map_save_presentation_providers.o \
	engine/map/map_save_prompt_runtime_bank15.o \
	engine/map/map_save_file_select_controller.o \
	engine/map/map_save_file_select_presentation.o \
	engine/map/map_save_bank14_providers.o \
	engine/map/map_save_medal_detail_background.o \
	engine/map/map_save_medal_detail_runtime.o \
	engine/map/map_save_recovery_notice.o \
	engine/map/map_save_boot_display.o \
	engine/map/map_sram_editor_slot_validation.o \
	engine/map/map_sram_checksum_runtime.o \
	engine/map/map_save_overwrite_state.o \
	engine/map/map_interrupt_prompt_bank31.o \
	engine/map/map_yield_prompt_bank27.o \
	engine/map/map_save_continue_prompt_bank27.o \
	engine/map/ai/map_control_result_transition_6e6e.o \
	engine/map/ai/map_control_transition_finalize_6ed6.o \
	engine/map/ai/map_control_opponent_cancel_prompt_6f1e.o \
	engine/map/ai/map_control_coordinate_interaction_6f95.o \
	engine/map/ai/map_control_selected_map_input_6fca.o \
	engine/map/ai/map_control_selected_map_command_menu_717d.o \
	engine/map/ai/map_control_selected_map_command_controller_7226.o \
	engine/map/ai/map_control_phase_command07_746d.o \
	engine/map/ai/map_control_interaction_input_74fa.o \
	engine/map/ai/map_control_horizontal_position_7525.o \
	engine/map/ai/map_control_horizontal_position_7564.o \
	engine/map/ai/map_control_vertical_position_759c.o \
	engine/map/ai/map_control_vertical_position_75db.o \
	engine/map/ai/map_control_command06_coordinate_selection_7613.o \
	engine/map/map_setup_scratch_reset_762b.o \
	engine/map/map_ui_coordinate_presentation_763d.o \
	engine/map/map_ui_refresh_wrapper_7645.o \
	engine/map/map_viewport_to_bgmap_coordinates_764a.o \
	engine/map/map_presentation_tile_block_loader_765d.o \
	engine/unit/unit_graphic_from_record_766c.o \
	engine/unit/unit_graphic_tiles_7675.o \
	engine/map/map_metatile_presenter_76c9.o \
	engine/unit/unit_move_status_overlay_775f.o \
	engine/ui/number_renderers_792a.o \
	engine/map/map_economy_panel_7a53.o \
	engine/home/home_vram_clear_rows_7a9d.o \
	engine/map/map_viewport_center_7acb.o \
	engine/map/map_pan_to_coordinates_7b01.o \
	engine/map/map_economy_runtime_7b6f.o \
	engine/unit/unit_current_phase_side_7d24.o \
	engine/unit/unit_transport_carried_child_action_63cf.o \
	engine/home/home_scanline_transition_stat.o \
	engine/map/map_save_slot_metadata.o \
	engine/map/map_sram.o \
	engine/map/map_demo_state_bank13.o \
	engine/map/map_editor_sram_save.o \
	data/maps/map_pointer_tables.o \
	data/maps/map_records.o \
	data/maps/map_records_standard_bank29.o \
	data/maps/map_records_standard_bank2a.o \
	data/maps/map_records_standard_bank2b.o \
	data/maps/map_records_standard_bank2c.o \
	data/maps/map_records_beginner_bank2c.o \
	data/maps/map_records_campaign_bank2d.o \
	data/maps/map_records_campaign_bank2e.o \
	data/maps/map_records_campaign_bank2f.o \
	engine/ui/suspend.o \
	engine/ui/beginner.o \
	engine/map/map_menu.o \
	engine/map/map_menu_runtime_47e3.o \
	engine/map/map_menu_runtime_4b86.o \
	engine/map/map_menu_runtime_4f40.o \
	engine/map/map_menu_continue_save_prompt.o \
	engine/map/map_menu_strings.o \
	engine/map/map_menu_ir_text.o \
	engine/ui/main_menu.o \
	engine/ui/configuration_runtime_bank15.o \
	engine/ui/name_screen.o \
	engine/unit/unit_creation.o \
	engine/versus/versus_bank17_ui_helpers.o \
	engine/unit/unit_list_bank17_helpers.o \
	engine/unit/unit_list_runtime_6c72.o \
	engine/unit/unit_list_action_runtime_70d9.o \
	engine/unit/unit_list_post_promotion_runtime_734d.o \
	engine/unit/unit_list_tail_runtime_7e78.o \
	engine/unit/unit_list.o \
	engine/unit/unit_reference_frontend_5da5.o \
	engine/unit/unit_reference_detail_helpers_5e7b.o \
	engine/unit/unit_reference_navigation_runtime_5f36.o \
engine/unit/unit_reference_detail_values_638a.o \
	engine/unit/unit_reference_detail_runtime_6707.o \
	engine/unit/unit_reference_submenu_controllers.o \
	engine/unit/unit_reference_movement_submenu_runtime.o \
	engine/unit/unit_reference_terrain_upkeep_provider.o \
	engine/unit/unit_reference_late_submenu_providers.o \
	engine/unit/unit_status.o \
	engine/unit/unit_status_runtime.o \
	engine/unit/unit_status_controller.o \
	engine/unit/unit_hp_transfer.o \
	engine/unit/unit_status_data.o \
	engine/campaign/campaign_map_select.o \
	engine/campaign/campaign_mode_entry_runtime.o \
	engine/campaign/campaign_result_detail_renderer.o \
	engine/map/map_surrender_resolution_prompt_bank27.o \
	engine/campaign/campaign_result_summary_runtime.o \
	engine/campaign/campaign_map_select_resources_bank24.o \
	engine/map/map_briefing_runtime.o \
	data/campaign/campaign_briefing_pointers.o \
	data/campaign/campaign_briefing_text_bank33.o \
	data/campaign/campaign_intro_extension.o \
	data/campaign/campaign_briefing_relocations.o \
	engine/campaign/campaign_medal_statistics_runtime.o \
	engine/campaign/campaign_statistics_tail_runtime.o \
	engine/map/ai/map_control_force.o engine/home/home_unit_record.o engine/map/ai/map_control_capture_targets.o engine/map/ai/map_control_analysis_runtime.o \
	engine/map/ai/map_control_resolution_helpers.o engine/map/ai/map_ai_transport_route_planning.o engine/map/ai/map_ai_procurement.o engine/map/ai/map_ai_actions.o engine/map/ai/map_ai_tactical_driver.o engine/map/ai/map_ai_tactical_policy_selector.o engine/map/ai/map_ai_tactical_scheduler.o engine/map/ai/map_ai_action_dispatch.o engine/map/ai/map_ai_bridge_attack_planning.o engine/map/ai/map_ai_tactical_selector_continuation.o \
	engine/map/ai/map_ai_tactical_helpers.o engine/map/ai/map_ai_attack_scoring.o engine/map/ai/map_ai_tactical_priority_data.o engine/map/ai/map_ai_direct_attack_support.o engine/map/ai/map_ai_bridge_attack_execution.o engine/map/property_state_table_management_5626.o engine/map/property_state_presentation_571b.o engine/map/property_state_runtime_5883.o engine/map/map_popup_presentation_runtime_5b43.o engine/infrared/map_infrared_exchange_runtime_6983.o engine/unit/unit_supply_service_runtime_6b44.o engine/unit/unit_action_presentation_runtime_66bb.o engine/unit/unit_deployment_runtime_7b89.o engine/unit/unit_transport_actions.o engine/unit/unit_development_action.o engine/unit/unit_bridge_action.o engine/map/ai/map_ai_service_targets.o engine/unit/unit_pave_runtime_7078.o engine/map/map_control_end_command_72b4.o engine/unit/unit_aircraft_fuel_upkeep_72de.o engine/unit/unit_capture_action.o engine/map/ai/map_ai_area_attack.o engine/map/map_action_effect_runtime_4e27.o engine/battle/battle_direct_attack.o engine/battle/battle_combat_setup.o \
	engine/ui/bank14_math.o \
	engine/ui/description_runtime_bank32.o \
	engine/ui/descriptions.o \
	engine/ui/descriptions_explanations.o \
	engine/mobile/mobile.o \
	engine/network/bank19_network_shift_jis_callers.o \
	engine/network/bank19_network_runtime_4195.o \
	engine/network/bank19_network_runtime_4a2a.o \
	engine/network/bank19_network_runtime_4d41.o \
	engine/network/bank19_network_runtime_5306.o \
	engine/network/bank19_network_runtime_56a2.o \
	engine/network/bank19_network_runtime_57a5.o \
	engine/network/bank19_network_runtime_61e6.o \
	engine/network/bank19_network_shift_jis_profiles.o \
	engine/network/bank19_network_ui_continuation.o \
	engine/network/bank19_network_persistent_init.o \
	engine/network/bank19_network_messages_tail.o \
	engine/mobile/mobile_unused_menu.o \
	engine/mobile/mobile_strings.o \
	data/medals.o \
	data/config.o \
	data/ranks.o \
	engine/battle/battle_info.o \
	engine/battle/battle_combat_runtime.o \
	engine/battle/battle_fire_availability_4000.o \
	engine/battle/battle_fire_bomb_runtime_418f.o \
	engine/battle/battle_unit_runtime.o \
	engine/battle/battle_unit_hp_layout.o \
	engine/battle/battle_hp_presets.o \
	engine/battle/battle_unit_sprite_loader.o \
	engine/battle/battle_unit_graphics.o \
	engine/battle/battle_place_graphics.o \
	engine/battle/battle_scene_resource_controller.o \
	engine/battle/battle_scene_resource_descriptor_presets.o \
	engine/battle/battle_scene_weapon_target_sfx.o \
	engine/battle/battle_scene_resource_layout.o \
	engine/battle/battle_scene_bank31_resource.o \
	engine/network/bank31_boot_save_runtime.o \
	engine/network/bank31_runtime_5675.o \
	engine/network/bank31_runtime_57e6.o \
	engine/network/bank31_runtime_5ac0.o \
	engine/network/bank31_runtime_5ce6.o \
	engine/network/bank31_runtime_5f27.o \
	engine/network/bank31_runtime_609c.o \
	engine/network/bank31_runtime_637f.o \
	engine/network/bank31_runtime_655d.o \
	engine/network/bank31_runtime_66e4.o \
	engine/network/bank22_game_code_shift_jis.o \
	engine/network/bank22_shift_jis_stream.o \
	engine/sprite/advanced_sprite.o \
	engine/battle/battle_scene_setup.o \
	engine/infrared/infrared_runtime.o \
	data/terrain.o \
	engine/versus/versus_map_selection_runtime.o \
	engine/versus/versus_style_country_runtime.o \
	engine/versus/versus_style_description_bank27.o \
	engine/versus/versus_country_maptype_runtime.o \
	engine/versus/versus_setup_runtime.o \
	engine/versus/versus.o

graphics := \
	gfx/ui/property_state_meter.2bpp \
	gfx/effects/map_action_effects.2bpp \
	gfx/effects/map_unit_transition.2bpp \
	gfx/effects/unit_hp_transfer.2bpp \
	gfx/effects/map_hp_change.2bpp \
	gfx/effects/map_status_markers.2bpp \
	gfx/font/charmap.2bpp \
	gfx/font/symbols.2bpp \
	gfx/units/map_icons.2bpp \
	gfx/units/battle/per_unit/shared_blank.2bpp \
	gfx/units/battle/per_unit/01_infantry.2bpp \
	gfx/units/battle/per_unit/02_missile_infantry.2bpp \
	gfx/units/battle/per_unit/03_mercenary_infantry.2bpp \
	gfx/units/battle/per_unit/04_construction_truck.2bpp \
	gfx/units/battle/per_unit/05_supply_truck.2bpp \
	gfx/units/battle/per_unit/06_supply_truck_s.2bpp \
	gfx/units/battle/per_unit/07_transport_truck.2bpp \
	gfx/units/battle/per_unit/08_transport_truck_s.2bpp \
	gfx/units/battle/per_unit/09_combat_buggy.2bpp \
	gfx/units/battle/per_unit/10_combat_buggy_s.2bpp \
	gfx/units/battle/per_unit/11_combat_vehicle.2bpp \
	gfx/units/battle/per_unit/12_combat_vehicle_s.2bpp \
	gfx/units/battle/per_unit/13_apc.2bpp \
	gfx/units/battle/per_unit/14_apc_s.2bpp \
	gfx/units/battle/per_unit/15_rocket_launcher.2bpp \
	gfx/units/battle/per_unit/16_rocket_launcher_s.2bpp \
	gfx/units/battle/per_unit/17_anti_air_tank.2bpp \
	gfx/units/battle/per_unit/18_mercenary_anti_air_missiles.2bpp \
	gfx/units/battle/per_unit/19_anti_air_missiles.2bpp \
	gfx/units/battle/per_unit/20_anti_air_missiles_s.2bpp \
	gfx/units/battle/per_unit/21_artillery.2bpp \
	gfx/units/battle/per_unit/22_artillery_s.2bpp \
	gfx/units/battle/per_unit/23_ifv.2bpp \
	gfx/units/battle/per_unit/24_ifv_s.2bpp \
	gfx/units/battle/per_unit/25_tank_destroyer.2bpp \
	gfx/units/battle/per_unit/26_tank_destroyer_s.2bpp \
	gfx/units/battle/per_unit/27_tank.2bpp \
	gfx/units/battle/per_unit/28_mercenary_tank.2bpp \
	gfx/units/battle/per_unit/29_fighter_plane_a.2bpp \
	gfx/units/battle/per_unit/30_fighter_plane_b.2bpp \
	gfx/units/battle/per_unit/31_fighter_plane_s.2bpp \
	gfx/units/battle/per_unit/32_attack_plane_a.2bpp \
	gfx/units/battle/per_unit/33_attack_plane_b.2bpp \
	gfx/units/battle/per_unit/34_attack_plane_s.2bpp \
	gfx/units/battle/per_unit/35_bomber.2bpp \
	gfx/units/battle/per_unit/36_mercenary_bomber.2bpp \
	gfx/units/battle/per_unit/37_transport_plane.2bpp \
	gfx/units/battle/per_unit/38_refueling_plane.2bpp \
	gfx/units/battle/per_unit/39_battle_helicopter.2bpp \
	gfx/units/battle/per_unit/40_battle_helicopter_s.2bpp \
	gfx/units/battle/per_unit/41_anti_sub_helicopter.2bpp \
	gfx/units/battle/per_unit/42_transport_helicopter.2bpp \
	gfx/units/battle/per_unit/43_transport_helicopter_s.2bpp \
	gfx/units/battle/per_unit/44_aegis_warship.2bpp \
	gfx/units/battle/per_unit/45_mercenary_missile_frigate.2bpp \
	gfx/units/battle/per_unit/46_large_carrier.2bpp \
	gfx/units/battle/per_unit/47_small_carrier.2bpp \
	gfx/units/battle/per_unit/48_transport_ship.2bpp \
	gfx/units/battle/per_unit/49_supply_tanker.2bpp \
	gfx/units/battle/per_unit/50_submarine.2bpp \
	gfx/units/battle/per_unit/51_submarine_s.2bpp \
	gfx/units/battle/per_unit/special_shared_blank.2bpp \
	gfx/units/battle/per_unit/52_special_0.2bpp \
	gfx/units/battle/per_unit/special_0_interstitial_frame.2bpp \
	gfx/units/battle/per_unit/53_special_1.2bpp \
	gfx/units/battle/per_unit/special_1_interstitial_frame.2bpp \
	gfx/units/battle/per_unit/54_special_2.2bpp \
	gfx/units/battle/per_unit/special_2_interstitial_frame.2bpp \
	gfx/units/battle/per_unit/55_special_3.2bpp \
	gfx/units/battle/per_unit/special_3_interstitial_frame.2bpp \
	gfx/units/battle/per_unit/56_special_4.2bpp \
	gfx/battle/common/battle_place_common.2bpp \
	gfx/battle/common/battle_ui_common.2bpp \
	gfx/environment/map/terrain_tiles.2bpp \
	gfx/environment/map/terrain_animations.2bpp \
	gfx/environment/map/animations/sea.2bpp \
	gfx/environment/map/animations/river.2bpp \
	gfx/environment/map/animations/bridge1.2bpp \
	gfx/environment/map/animations/bridge2.2bpp \
	gfx/environment/map/animations/shoal.2bpp \
	gfx/ui/days_menu.2bpp \
	gfx/title/title_screen.2bpp \
	gfx/ui/action_menu.2bpp \
	gfx/ui/system_messages.2bpp \
	gfx/ui/map_menu.2bpp \
	gfx/ui/name_screen.2bpp \
	gfx/file_select/file_select_numbers.2bpp \
	gfx/file_select/file_select_general1.2bpp \
	gfx/file_select/file_select_modes.2bpp \
	gfx/file_select/file_select_medals.2bpp \
	gfx/file_select/file_select_ranks.2bpp \
	gfx/ui/config.2bpp \
	gfx/ui/vs_menu_type.2bpp \
	gfx/ui/unit_status.2bpp \
	gfx/network/mobile_menu.2bpp \
	gfx/font/charmap_news.2bpp \
	gfx/results/results.2bpp \
	gfx/file_select/file_select_general2.2bpp

gfx/ui/system_messages.2bpp: RGBGFXFLAGS := --trim-end 6
gfx/units/map_icons.2bpp: RGBGFXFLAGS := --trim-end 5
gfx/ui/days_menu.2bpp: RGBGFXFLAGS := --trim-end 12
gfx/file_select/file_select_modes.2bpp: RGBGFXFLAGS := --trim-end 12
gfx/file_select/file_select_medals.2bpp: RGBGFXFLAGS := --trim-end 8
gfx/ui/vs_menu_type.2bpp: RGBGFXFLAGS := --trim-end 3
gfx/results/results.2bpp: RGBGFXFLAGS := --trim-end 3
gfx/file_select/file_select_general2.2bpp: RGBGFXFLAGS := --trim-end 4

.PHONY: all check-battle-scene-helpers
all: $(name).gbc
	@test -f $(name).gbc.orig || cp $(name).gbc $(name).gbc.orig
	@diff $(name).gbc.orig $(name).gbc




.PHONY: clean-code
clean-code:
	rm -f $(objects) $(objects:.o=.d)
	rm -f $(name).gbc $(name).map $(name).sym

.PHONY: clean
clean: clean-code
	rm -f $(graphics)
	$(MAKE) -C tools/rgbgfx-legacy clean

$(name).gbc: $(objects) | baserom-verified
	$(RGBLINK) -m $(@:.gbc=.map) -n $(@:.gbc=.sym) $(RGBLINKFLAGS) -o $@ $^
	$(RGBFIX) $(RGBFIXFLAGS) $@

%.o: %.asm
	$(RGBASM) -MP -M $*.d $(RGBASMFLAGS) -o $@ $<

$(objects): | baserom-verified $(graphics)

%.2bpp: %.png
	@if test "$(RGBGFX)" = "$(BUNDLED_RGBGFX)" && test ! -x "$(BUNDLED_RGBGFX)"; then $(MAKE) legacy-rgbgfx; fi
	$(RGBGFX) $(RGBGFXFLAGS) -o $@ $<

$(LOCAL_RGBDS_STAMP): tools/bootstrap_rgbds.py
	$(PYTHON) tools/bootstrap_rgbds.py --version $(RGBDS_VERSION) --dest $(RGBDS_BIN_DIR) $(if $(RGBDS_ARCHIVE),--archive "$(RGBDS_ARCHIVE)",)
	@touch "$@"

$(LOCAL_RGBASM) $(LOCAL_RGBLINK) $(LOCAL_RGBFIX): $(LOCAL_RGBDS_STAMP)
	@if test ! -x "$@"; then \
		$(PYTHON) tools/bootstrap_rgbds.py --version $(RGBDS_VERSION) --dest $(RGBDS_BIN_DIR) $(if $(RGBDS_ARCHIVE),--archive "$(RGBDS_ARCHIVE)",); \
		touch "$(LOCAL_RGBDS_STAMP)"; \
	fi
	@test -x "$@" || { echo "RGBDS bootstrap did not install $@" >&2; false; }


ifeq ($(RGBASM),$(LOCAL_RGBASM))
$(objects): | $(LOCAL_RGBASM)
endif
ifeq ($(RGBLINK),$(LOCAL_RGBLINK))
$(name).gbc: | $(LOCAL_RGBLINK)
endif
ifeq ($(RGBFIX),$(LOCAL_RGBFIX))
$(name).gbc: | $(LOCAL_RGBFIX)
endif
$(BUNDLED_RGBGFX):
	$(MAKE) -C tools/rgbgfx-legacy rgbgfx


baserom.gbc:
	@echo "Missing baserom.gbc! Provide an unmodified Japanese retail Game Boy Wars 3 ROM." >&2; false

.PHONY: baserom-verified check-baserom
baserom-verified: baserom.gbc tools/verify_baserom.py
	@$(PYTHON) tools/verify_baserom.py baserom.gbc

check-baserom: baserom-verified

.PHONY: rgbds rgbds-status
rgbds: $(LOCAL_RGBASM) $(LOCAL_RGBLINK) $(LOCAL_RGBFIX)

rgbds-status:
	@echo "Pinned RGBDS version: $(RGBDS_VERSION)"; \
	echo "RGBASM: $(RGBASM)"; \
	echo "RGBLINK: $(RGBLINK)"; \
	echo "RGBFIX: $(RGBFIX)"; \
	echo "RGBGFX: $(RGBGFX)"; \
	if test -f "$(LOCAL_RGBDS_VERSION_FILE)"; then printf "Local RGBDS version: "; cat "$(LOCAL_RGBDS_VERSION_FILE)"; else echo "Local RGBDS: [not bootstrapped]"; fi

-include $(objects:.o=.d)

.PHONY: legacy-rgbgfx
legacy-rgbgfx: $(BUNDLED_RGBGFX)


.PHONY: check-unit-list-tail-mnemonic
check-unit-list-tail-mnemonic: $(LOCAL_RGBASM) $(LOCAL_RGBLINK)
	$(PYTHON) tools/verify_unit_list_tail_mnemonic.py

.PHONY: check-unit-list-post-promotion-runtime
check-unit-list-post-promotion-runtime: $(LOCAL_RGBASM) $(LOCAL_RGBLINK)
	$(PYTHON) tools/verify_unit_list_post_promotion_runtime.py

.PHONY: check-rgbds-1-syntax
check-rgbds-1-syntax:
	@status=0; \
	if grep -RInE '^[[:space:]]*ldio[[:space:]]' --include='*.asm' engine data audio symbols.asm >/tmp/gbwars3-rgbds1-ldio.txt 2>/dev/null; then cat /tmp/gbwars3-rgbds1-ldio.txt; status=1; fi; \
	if grep -RInE '^[[:space:]]*ld[[:space:]]+(\[[[:space:]]*c[[:space:]]*\][[:space:]]*,|a[[:space:]]*,[[:space:]]*\[[[:space:]]*c[[:space:]]*\])' --include='*.asm' engine data audio symbols.asm >/tmp/gbwars3-rgbds1-ldc.txt 2>/dev/null; then cat /tmp/gbwars3-rgbds1-ldc.txt; status=1; fi; \
	if grep -RInE '^[[:space:]]*ldh[[:space:]]+(\[[[:space:]]*\$$[0-9A-Fa-f]{1,2}[[:space:]]*\]|a[[:space:]]*,[[:space:]]*\[[[:space:]]*\$$[0-9A-Fa-f]{1,2}[[:space:]]*\])' --include='*.asm' engine data audio symbols.asm >/tmp/gbwars3-rgbds1-lowldh.txt 2>/dev/null; then cat /tmp/gbwars3-rgbds1-lowldh.txt; status=1; fi; \
	rm -f /tmp/gbwars3-rgbds1-ldio.txt /tmp/gbwars3-rgbds1-ldc.txt /tmp/gbwars3-rgbds1-lowldh.txt; \
	if test $$status -eq 0; then echo "RGBDS 1.x removed-syntax audit: [ok]"; else echo "RGBDS 1.x removed-syntax audit: [failed]" >&2; fi; \
	exit $$status

.PHONY: check-toolchain
check-toolchain:
	@status=0; \
	for spec in "RGBASM=$(RGBASM)" "RGBLINK=$(RGBLINK)" "RGBFIX=$(RGBFIX)"; do \
		name=$${spec%%=*}; tool=$${spec#*=}; \
		if command -v "$$tool" >/dev/null 2>&1 || test -x "$$tool"; then \
			echo "$$name: $$tool [ok]"; \
		else \
			echo "$$name: $$tool [missing]" >&2; status=1; \
		fi; \
	done; \
	if test -x "$(BUNDLED_RGBGFX)"; then echo "RGBGFX: $(BUNDLED_RGBGFX) [built]"; \
	elif test -f tools/rgbgfx-legacy/src/gfx/main.c; then echo "RGBGFX: legacy compatibility source [available; built on demand]"; \
	else echo "RGBGFX compatibility source [missing]" >&2; status=1; fi; \
	exit $$status

.PHONY: check-map-records
check-map-unit-placements:
	python3 tools/verify_map_unit_placements.py baserom.gbc

check-map-initial-units:
	python3 tools/verify_map_initial_units.py baserom.gbc

check-map-initial-unit-symbols:
	python3 tools/verify_map_initial_unit_symbols.py

check-map-records: | baserom.gbc
	python3 tools/verify_map_records.py baserom.gbc

.PHONY: check-standard-map-records
check-standard-map-records: | baserom.gbc
	python3 tools/verify_standard_map_records.py baserom.gbc

.PHONY: check-beginner-map-records
check-beginner-map-records: | baserom.gbc
	python3 tools/verify_beginner_map_records.py baserom.gbc

.PHONY: check-campaign-map-records
check-campaign-map-records: | baserom.gbc
	python3 tools/verify_campaign_map_records.py baserom.gbc

.PHONY: check-map-runtime
check-map-runtime:
	python3 tools/verify_map_runtime.py baserom.gbc

.PHONY: check-map-sram
check-map-sram: | baserom.gbc
	python3 tools/verify_map_sram.py baserom.gbc

.PHONY: check-map-sram-serializer
check-map-sram-serializer:
	python3 tools/verify_map_sram_serializer.py baserom.gbc

.PHONY: check-map-sram-deserializer
check-map-sram-deserializer: | baserom.gbc
	python3 tools/verify_map_sram_deserializer.py baserom.gbc

.PHONY: check-map-name-width
check-map-name-width: | baserom.gbc
	python3 tools/verify_map_name_width.py baserom.gbc

.PHONY: check-map-name-editor
check-map-name-editor: | baserom.gbc
	python3 tools/verify_map_name_editor.py baserom.gbc

.PHONY: check-map-name-migration
check-map-name-migration: | baserom.gbc
	python3 tools/verify_map_name_migration.py baserom.gbc

.PHONY: check-map-name-sidecar
check-map-name-sidecar: | baserom.gbc
	$(PYTHON) tools/verify_map_name_sidecar.py baserom.gbc

.PHONY: check-map-name-9char
check-map-name-9char: | baserom.gbc
	$(PYTHON) tools/verify_map_name_9char.py baserom.gbc

.PHONY: check-map-checksum
check-map-checksum:
	$(PYTHON) tools/verify_map_checksum.py

.PHONY: check-map-parameters
check-map-parameters:
	$(PYTHON) tools/verify_map_parameters.py

.PHONY: check-unit-record-layout
check-unit-record-layout:
	$(PYTHON) tools/verify_unit_record_layout.py

.PHONY: check-unit-data-layout
check-unit-data-layout:
	$(PYTHON) tools/verify_unit_data_layout.py

.PHONY: check-unit-support-data
check-unit-support-data:
	$(PYTHON) tools/verify_unit_support_data.py

.PHONY: check-weapon-movement-data
check-weapon-movement-data:
	$(PYTHON) tools/verify_weapon_movement_data.py

.PHONY: check-weapon-data-macro
check-weapon-data-macro:
	$(PYTHON) tools/verify_weapon_data_macro.py

.PHONY: check-movement-data-macro
check-movement-data-macro:
	$(PYTHON) tools/verify_movement_data_macro.py

.PHONY: check-unit-crossrefs
check-unit-crossrefs:
	$(PYTHON) tools/verify_unit_crossrefs.py

.PHONY: check-unit-runtime
check-unit-runtime: | baserom.gbc
	$(PYTHON) tools/verify_unit_runtime.py baserom.gbc

.PHONY: check-unit-deletion
check-unit-deletion: | baserom.gbc
	$(PYTHON) tools/verify_unit_deletion.py baserom.gbc

.PHONY: check-unit-pair-filters
check-unit-pair-filters: | baserom.gbc
	$(PYTHON) tools/verify_unit_pair_filters.py baserom.gbc

.PHONY: check-unit-transport-supply
check-unit-transport-supply: | baserom.gbc
	$(PYTHON) tools/verify_unit_transport_supply.py baserom.gbc


check-unit-status-flags:
	python3 tools/verify_unit_status_flags.py

.PHONY: check-unit-semantic-names
check-unit-semantic-names:
	$(PYTHON) tools/verify_unit_semantic_names.py

.PHONY: check-unit-refill
check-unit-refill:
	python3 tools/verify_unit_refill.py

.PHONY: check-metatile-graphics-runtime
check-metatile-graphics-runtime: | baserom.gbc
	$(PYTHON) tools/verify_metatile_graphics_runtime.py baserom.gbc

.PHONY: check-graphics-layout
check-graphics-layout:
	python3 tools/verify_graphics_layout.py

.PHONY: check-map-graphics
check-map-graphics:
	python3 tools/verify_map_graphics.py

.PHONY: check-map-animation
check-map-animation: | baserom.gbc $(graphics)
	python3 tools/verify_map_animation.py

check-movement-costs: | baserom.gbc
	@python3 tools/verify_movement_costs.py

check-battle-graphics: | baserom.gbc $(graphics)
	@python3 tools/verify_battle_graphics.py

.PHONY: check-battle-unit-layout
check-battle-unit-layout: | baserom.gbc $(graphics)
	@python3 tools/verify_battle_unit_layout.py

.PHONY: check-battle-place-graphics
check-battle-place-graphics: | baserom.gbc
	@python3 tools/verify_battle_place_graphics.py

.PHONY: check-unit-compact-list
check-unit-compact-list: | baserom.gbc
	@python3 tools/verify_unit_compact_list.py

.PHONY: check-reserve-unit-semantics
check-reserve-unit-semantics:
	@python3 tools/verify_reserve_unit_semantics.py

.PHONY: check-battle-place-animation
check-battle-place-animation: | baserom.gbc
	@python3 tools/verify_battle_place_animation.py


.PHONY: check-battle-scene-resource-descriptor-presets
check-battle-scene-resource-descriptor-presets: | baserom.gbc
	$(PYTHON) tools/verify_battle_scene_resource_descriptor_presets.py baserom.gbc GBWARS3.gbc

.PHONY: check-battle-scene-common-setup check-battle-scene-family0 check-battle-scene-family12
check-battle-scene-helpers:
	$(PYTHON) tools/verify_battle_scene_helpers.py baserom.gbc

check-battle-scene-common-setup:
	@python3 tools/verify_battle_scene_common_setup.py

check-battle-scene-family0:
	$(PYTHON) tools/verify_battle_scene_family0.py baserom.gbc

check-battle-scene-family12:
	$(PYTHON) tools/verify_battle_scene_family12.py baserom.gbc

.PHONY: check-battle-scene-phase12-sides
check-battle-scene-phase12-sides:
	$(PYTHON) tools/verify_battle_scene_phase12_sides.py baserom.gbc

.PHONY: check-unit-experience
check-unit-experience:
	python3 tools/verify_unit_experience.py

.PHONY: check-unit-data-semantics
check-unit-data-semantics:
	$(PYTHON) tools/verify_unit_data_semantics.py

check-unit-data-macro:
	$(PYTHON) tools/verify_unit_data_macro.py

.PHONY: check-unit-purchase-promotion-runtime
check-unit-purchase-promotion-runtime:
	$(PYTHON) tools/verify_unit_purchase_promotion_runtime.py baserom.gbc

.PHONY: check-unit-purchase-promotion
check-unit-purchase-promotion:
	@python3 tools/verify_unit_purchase_promotion.py

.PHONY: check-unit-weapon-list-anchors
check-unit-weapon-list-anchors:
	$(PYTHON) tools/verify_unit_weapon_list_anchors.py

.PHONY: check-unit-weapon-summary-layout
check-unit-weapon-summary-layout:
	$(PYTHON) tools/verify_unit_weapon_summary_layout.py

check-unit-purchase-data-geometry:
	python3 tools/verify_unit_purchase_data_geometry.py

.PHONY: check-unit-list-scratch-layout
check-unit-list-scratch-layout:
	$(PYTHON) tools/verify_unit_list_scratch_layout.py

.PHONY: check-unit-purchase-allowed-list-geometry
check-unit-purchase-allowed-list-geometry:
	$(PYTHON) tools/verify_unit_purchase_allowed_list_geometry.py

check-unit-purchase-ram-layout:
	$(PYTHON) tools/verify_unit_purchase_ram_layout.py

.PHONY: check-unit-purchase-filter-contracts
check-unit-purchase-filter-contracts:
	$(PYTHON) tools/verify_unit_purchase_filter_contracts.py

.PHONY: check-unit-purchase-promotion-rom
check-unit-purchase-promotion-rom:
	$(PYTHON) tools/verify_unit_purchase_promotion_rom.py baserom.gbc

.PHONY: check-battle-cover-lookup
check-battle-cover-lookup:
	$(PYTHON) tools/verify_battle_cover_lookup.py

.PHONY: check-battle-combat-math-anchors
check-battle-combat-math-anchors:
	$(PYTHON) tools/verify_battle_combat_math_anchors.py

.PHONY: check-battle-multiplier-input-contract
check-battle-multiplier-input-contract:
	$(PYTHON) tools/verify_battle_multiplier_input_contract.py

.PHONY: check-battle-aftermath-attack-order
check-battle-aftermath-attack-order:
	$(PYTHON) tools/verify_battle_aftermath_attack_order.py

.PHONY: check-battle-runtime-ram-layout
check-battle-runtime-ram-layout:
	$(PYTHON) tools/verify_battle_runtime_ram_layout.py

.PHONY: check-battle-experience-contract
check-battle-experience-contract:
	$(PYTHON) tools/verify_battle_experience_contract.py

check-battle-formula-contract:
	$(PYTHON) tools/verify_battle_formula_contract.py

.PHONY: check-battle-damage-focus-contract
check-battle-damage-focus-contract:
	$(PYTHON) tools/verify_battle_damage_focus_contract.py

.PHONY: check-map-control-force-runtime
check-map-control-force-runtime: | baserom.gbc
	$(PYTHON) tools/verify_map_control_force_runtime.py baserom.gbc

.PHONY: check-unit-force-value-contract
check-unit-force-value-contract:
	$(PYTHON) tools/verify_unit_force_value_contract.py

.PHONY: check-campaign-medal-statistics-contract
check-campaign-medal-statistics-contract:
	$(PYTHON) tools/verify_campaign_medal_statistics_contract.py

.PHONY: check-campaign-medal-statistics-runtime
check-campaign-medal-statistics-runtime: | baserom.gbc
	$(PYTHON) tools/verify_campaign_medal_statistics_runtime.py baserom.gbc

.PHONY: check-rom0-arithmetic-contract
check-rom0-arithmetic-contract: | baserom.gbc
	$(PYTHON) tools/verify_rom0_arithmetic_contract.py baserom.gbc

.PHONY: check-map-control-economy-contract
check-map-control-economy-contract:
	$(PYTHON) tools/verify_map_control_economy_contract.py

.PHONY: check-map-economy-source-integration
check-map-economy-source-integration:
	@python3 tools/verify_map_economy_source_integration.py

.PHONY: check-campaign-statistics-source-integration
check-campaign-statistics-source-integration:
	python3 tools/verify_campaign_statistics_source_integration.py

.PHONY: check-map-name-scratch-integration
check-map-name-scratch-integration:
	python3 tools/verify_map_name_scratch_integration.py

check-rom0-symbolic-calls:
	python3 tools/verify_rom0_symbolic_calls.py

.PHONY: check-map-tile-runtime-integration
check-map-tile-runtime-integration:
	$(PYTHON) tools/verify_map_tile_runtime_integration.py baserom.gbc

.PHONY: check-unit-weapon-purchase-rom
check-unit-weapon-purchase-rom:
	$(PYTHON) tools/verify_unit_weapon_purchase_rom.py baserom.gbc

.PHONY: check-unit-built-counter
check-unit-built-counter:
	$(PYTHON) tools/verify_unit_built_counter.py baserom.gbc

check-battle-scene-resource-renderers:
	$(PYTHON) tools/verify_battle_scene_resource_renderers.py baserom.gbc

.PHONY: check-battle-combat-runtime-source
check-battle-combat-runtime-source: | baserom.gbc
	python3 tools/verify_battle_combat_runtime_source.py baserom.gbc

.PHONY: check-battle-hp-focus-runtime-source
check-battle-hp-focus-runtime-source: | baserom.gbc
	$(PYTHON) tools/verify_battle_hp_focus_runtime_source.py baserom.gbc

.PHONY: check-battle-aftermath-runtime-source
check-battle-aftermath-runtime-source: | baserom.gbc
	$(PYTHON) tools/verify_battle_aftermath_runtime_source.py baserom.gbc

.PHONY: check-battle-flank-support-runtime
check-battle-flank-support-runtime: | baserom.gbc
	$(PYTHON) tools/verify_battle_flank_support_runtime.py baserom.gbc

.PHONY: check-battle-weapon-selectors
check-battle-weapon-selectors: | baserom.gbc
	$(PYTHON) tools/verify_battle_weapon_selectors.py baserom.gbc

.PHONY: check-battle-info-presentation-runtime
check-battle-info-presentation-runtime:
	python3 tools/verify_battle_info_presentation_runtime.py baserom.gbc

.PHONY: check-battle-scene-resource-animations
check-battle-scene-resource-animations: | baserom.gbc
	$(PYTHON) tools/verify_battle_scene_resource_animations.py baserom.gbc

check-battle-scene-resource-roles:
	python3 tools/verify_battle_scene_resource_roles.py

.PHONY: check-infrared-runtime
check-infrared-runtime: | baserom.gbc
	$(PYTHON) tools/verify_infrared_runtime.py baserom.gbc

.PHONY: check-infrared-hardware-runtime
check-infrared-hardware-runtime:
	$(PYTHON) tools/verify_infrared_hardware_runtime.py

.PHONY: check-infrared-controller-runtime
check-infrared-controller-runtime:
	$(PYTHON) tools/verify_infrared_controller_runtime.py

.PHONY: check-infrared-controller-workspace
check-infrared-controller-workspace:
	$(PYTHON) tools/verify_infrared_controller_workspace.py

.PHONY: check-unit-status-scratch-lifetime
check-unit-status-scratch-lifetime:
	$(PYTHON) tools/verify_unit_status_scratch_lifetime.py

check-unit-status-shared-scratch:
	$(PYTHON) tools/verify_unit_status_shared_scratch.py

.PHONY: check-unit-status-controller-lifetime
check-unit-status-controller-lifetime:
	$(PYTHON) tools/verify_unit_status_controller_lifetime.py

check-unit-status-controller-runtime:
	$(PYTHON) tools/verify_unit_status_controller_runtime.py

.PHONY: check-campaign-map-select-runtime check-campaign-map-select-resources-bank24
check-campaign-map-select-runtime:
	$(PYTHON) tools/verify_campaign_map_select_runtime.py

check-campaign-map-select-resources-bank24: | baserom.gbc
	$(PYTHON) tools/verify_campaign_map_select_resources_bank24.py baserom.gbc

.PHONY: check-unit-hp-transfer-runtime check-unit-action-menu-runtime check-unit-status-data
check-unit-hp-transfer-runtime:
	$(PYTHON) tools/verify_unit_hp_transfer_runtime.py

check-unit-action-menu-runtime: | baserom.gbc
	$(PYTHON) tools/verify_unit_action_menu_runtime.py baserom.gbc

.PHONY: check-selected-map-command-menu check-selected-map-command-runtime
check-selected-map-command-menu: | baserom.gbc
	$(PYTHON) tools/verify_selected_map_command_menu.py baserom.gbc

check-selected-map-command-runtime: | baserom.gbc
	$(PYTHON) tools/verify_selected_map_command_runtime.py baserom.gbc

.PHONY: check-unit-creation-deploy-runtime
check-unit-creation-deploy-runtime: | baserom.gbc
	$(PYTHON) tools/verify_unit_creation_deploy_runtime.py baserom.gbc

.PHONY: check-unit-transport-carried-child-action
check-unit-transport-carried-child-action: | baserom.gbc
	$(PYTHON) tools/verify_unit_transport_carried_child_action.py baserom.gbc

check-unit-status-data:
	$(PYTHON) tools/verify_unit_status_data.py

.PHONY: check-map-briefing-runtime
check-map-briefing-runtime:
	$(PYTHON) tools/verify_map_briefing_runtime.py

.PHONY: check-campaign-briefing-pointer-contract
check-campaign-briefing-pointer-contract:
	$(PYTHON) tools/verify_campaign_briefing_pointer_contract.py



check-campaign-intro-extension: | baserom.gbc
	$(PYTHON) tools/verify_campaign_intro_extension.py baserom.gbc

check-campaign-intro-bank34-migration: | baserom.gbc
	$(PYTHON) tools/verify_campaign_intro_bank34_migration.py baserom.gbc

check-campaign-medal-statistics-gaps:
	$(PYTHON) tools/verify_campaign_medal_statistics_gaps.py

.PHONY: check-map-control-runtime-gap
check-map-control-phase-runtime:
	$(PYTHON) tools/verify_map_control_phase_runtime.py baserom.gbc

.PHONY: check-map-control-resolution-helpers
check-map-control-resolution-helpers: | baserom.gbc
	$(PYTHON) tools/verify_map_control_resolution_helpers.py baserom.gbc

check-map-control-runtime-gap: | baserom.gbc
	$(PYTHON) tools/verify_map_control_runtime_gap.py baserom.gbc



.PHONY: check-map-control-candidate-search
check-map-control-candidate-search: | baserom.gbc
	$(PYTHON) tools/verify_map_control_candidate_search.py baserom.gbc

.PHONY: check-map-control-analysis-workspace
check-map-control-analysis-workspace:
	$(PYTHON) tools/verify_map_control_analysis_workspace.py

.PHONY: check-map-control-analysis-boundaries
check-map-control-analysis-boundaries:
	$(PYTHON) tools/verify_map_control_analysis_boundaries.py

.PHONY: check-map-control-capture-targets
check-map-control-capture-targets:
	$(PYTHON) tools/verify_map_control_capture_targets.py

.PHONY: check-map-control-movement-cost-field
check-map-control-movement-cost-field: | baserom.gbc
	tools/verify_map_control_movement_cost_field.py baserom.gbc

.PHONY: check-map-ai-procurement-runtime
check-map-ai-procurement-runtime: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_procurement_runtime.py baserom.gbc

.PHONY: check-map-ai-actions-runtime
check-map-ai-actions-runtime: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_actions_runtime.py baserom.gbc

.PHONY: check-unit-terrain-services
check-unit-terrain-services: | baserom.gbc
	$(PYTHON) tools/verify_unit_terrain_services.py baserom.gbc

.PHONY: check-map-ai-transport-actions
check-map-ai-transport-actions: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_transport_actions.py baserom.gbc

.PHONY: check-map-ai-service-development
check-map-ai-service-development: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_service_development.py baserom.gbc

.PHONY: check-map-ai-capture-area-attack
check-map-ai-capture-area-attack: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_capture_area_attack.py baserom.gbc

.PHONY: check-map-ai-area-attack-terrain
check-map-ai-area-attack-terrain: GBWARS3.gbc
	$(PYTHON) tools/verify_map_ai_area_attack_terrain.py

.PHONY: check-map-ai-transport-route-planning
check-map-ai-transport-route-planning: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_transport_route_planning.py baserom.gbc

.PHONY: check-map-ai-final-actions
check-map-ai-final-actions: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_final_actions.py baserom.gbc

.PHONY: check-map-ai-tactical-selector-continuation
check-map-ai-tactical-selector-continuation: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_tactical_selector_continuation.py baserom.gbc

.PHONY: check-map-ai-tactical-helpers check-map-ai-tactical-priority-data check-map-ai-tactical-scheduler
check-map-ai-tactical-priority-data:
	$(PYTHON) tools/verify_map_ai_tactical_priority_data.py baserom.gbc

check-map-ai-tactical-scheduler:
	$(PYTHON) tools/verify_map_ai_tactical_scheduler.py baserom.gbc

.PHONY: check-map-ai-direct-attack-support
check-map-ai-direct-attack-support: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_direct_attack_support.py baserom.gbc

check-map-ai-tactical-helpers: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_tactical_helpers.py baserom.gbc

.PHONY: check-map-ai-tactical-driver check-map-ai-tactical-policy-selector
check-map-ai-tactical-driver: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_tactical_driver.py baserom.gbc

check-map-ai-tactical-policy-selector: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_tactical_policy_selector.py baserom.gbc

.PHONY: check-map-ai-attack-scoring check-home-unit-record
check-map-ai-attack-scoring: | baserom.gbc
	$(PYTHON) tools/verify_map_ai_attack_scoring.py baserom.gbc

check-home-unit-record: | baserom.gbc
	$(PYTHON) tools/verify_home_unit_record.py baserom.gbc

.PHONY: check-map-ai-tactical-selector-semantics
check-map-ai-tactical-selector-semantics:
	$(PYTHON) tools/verify_map_ai_tactical_selector_semantics.py $(BASEROM)

check-mobile-adapter-driver-frontend: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_frontend.py baserom.gbc

.PHONY: check-mobile-adapter-driver-requests-00-04
check-mobile-adapter-driver-requests-00-04: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_requests_00_04.py baserom.gbc

.PHONY: check-mobile-adapter-driver-requests-06-10
check-mobile-adapter-driver-requests-06-10: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_requests_06_10.py baserom.gbc

.PHONY: check-mobile-adapter-driver-requests-12-18
check-mobile-adapter-driver-requests-12-18: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_requests_12_18.py baserom.gbc

.PHONY: check-mobile-adapter-driver-requests-1a-26
check-mobile-adapter-driver-requests-1a-26: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_requests_1a_26.py baserom.gbc

.PHONY: check-mobile-adapter-driver-requests-28-2e
check-mobile-adapter-driver-requests-28-2e: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_requests_28_2e.py baserom.gbc

.PHONY: check-mobile-adapter-driver-requests-32-42
check-mobile-adapter-driver-requests-32-42: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_driver_requests_32_42.py baserom.gbc

.PHONY: check-mobile-adapter-serial-service
check-mobile-adapter-serial-service: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_serial_service.py baserom.gbc

check-mobile-adapter-lcd-timer-service:
	$(PYTHON) tools/verify_mobile_adapter_lcd_timer_service.py baserom.gbc

check-mobile-adapter-protocol-templates:
	$(PYTHON) tools/verify_mobile_adapter_protocol_templates.py baserom.gbc

.PHONY: check-mobile-adapter-network-client
check-mobile-adapter-network-client: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_network_client.py baserom.gbc

.PHONY: check-mobile-adapter-response-parser
check-mobile-adapter-response-parser: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_response_parser.py baserom.gbc

.PHONY: check-mobile-adapter-response-headers
check-mobile-adapter-response-headers: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_response_headers.py baserom.gbc

.PHONY: check-mobile-adapter-auth-crypto-tail
check-mobile-adapter-auth-crypto-tail: | baserom.gbc
	$(PYTHON) tools/verify_mobile_adapter_auth_crypto_tail.py baserom.gbc

check-campaign-briefing-text-reader: | baserom.gbc
	$(PYTHON) tools/verify_campaign_briefing_text_reader.py baserom.gbc

check-battle-place-unique-windows: | baserom.gbc
	$(PYTHON) tools/verify_battle_place_unique_windows.py baserom.gbc

.PHONY: check-battle-unit-sprites check-battle-place-window-backing check-battle-place-resources
check-battle-unit-sprites:
	python3 tools/verify_battle_unit_sprites.py

check-battle-place-window-backing: | baserom.gbc
	python3 tools/verify_battle_place_window_backing.py

check-battle-place-resources: | baserom.gbc
	python3 tools/verify_battle_place_window_backing.py










































.PHONY: check-campaign-intro-relocation
check-campaign-intro-relocation:
	$(PYTHON) tools/verify_campaign_intro_bank34_migration.py




















# Pret-style graphics separation: these ROM-order tile pools are technical build
# sources; the conventional PNG names are human-facing composed/color atlases.
gfx/units/map_icons.2bpp: gfx/units/source_tiles/map_icons.png
	$(RGBGFX) $(RGBGFXFLAGS) -o $@ $<

gfx/environment/map/terrain_tiles.2bpp: gfx/environment/map/source_tiles/terrain_tiles.png
	$(RGBGFX) $(RGBGFXFLAGS) -o $@ $<

.PHONY: gfx-resources
gfx-resources:
	$(PYTHON) tools/gfx/generate_graphics_resources.py baserom.gbc

















































































.PHONY: check-unit-move-status-overlay
check-unit-move-status-overlay: | baserom.gbc
	$(PYTHON) tools/verify_unit_move_status_overlay.py baserom.gbc

.PHONY: check-bank0b-display-helpers
check-bank0b-display-helpers: | baserom.gbc
	$(PYTHON) tools/verify_bank0b_display_helpers.py baserom.gbc

.PHONY: check-bank0b-tail-runtime
check-bank0b-tail-runtime: | baserom.gbc
	$(PYTHON) tools/verify_bank0b_tail_runtime.py baserom.gbc

.PHONY: check-map-cursor-presentation-runtime
check-map-cursor-presentation-runtime: | baserom.gbc
	$(PYTHON) tools/verify_map_cursor_presentation_runtime.py baserom.gbc

.PHONY: check-scanline-transition-source
check-scanline-transition-source: | baserom.gbc
	$(PYTHON) tools/verify_scanline_transition_source.py baserom.gbc

.PHONY: check-construction-terrain-actions
check-construction-terrain-actions: | baserom.gbc
	$(PYTHON) tools/verify_construction_terrain_actions.py baserom.gbc

.PHONY: check-sprite-object-engine
check-sprite-object-engine:
	@$(PYTHON) tools/verify_sprite_object_engine.py baserom.gbc

.PHONY: check-sprite-data-provider
check-sprite-data-provider:
	@$(PYTHON) tools/verify_sprite_data_provider.py baserom.gbc

.PHONY: check-sprite-animation-data
check-sprite-animation-data: | baserom.gbc
	@$(PYTHON) tools/verify_sprite_animation_data.py baserom.gbc

.PHONY: check-advanced-sprite-runtime
check-advanced-sprite-runtime: | baserom.gbc
	@$(PYTHON) tools/verify_advanced_sprite_runtime.py baserom.gbc

.PHONY: check-shared-display-runtime
check-shared-display-runtime: | baserom.gbc
	@$(PYTHON) tools/verify_shared_display_runtime.py baserom.gbc

.PHONY: check-title-screen-runtime
check-title-screen-runtime: | baserom.gbc
	@$(PYTHON) tools/verify_title_screen_runtime.py baserom.gbc

.PHONY: check-startup-title-controller
check-startup-title-controller: | baserom.gbc
	@$(PYTHON) tools/verify_startup_title_controller.py baserom.gbc

.PHONY: check-attract-intro-runtime
check-attract-intro-runtime: | baserom.gbc
	@$(PYTHON) tools/verify_attract_intro_runtime.py baserom.gbc

.PHONY: check-attract-scene-runtime
check-attract-scene-runtime: | baserom.gbc
	@$(PYTHON) tools/verify_attract_scene_runtime.py baserom.gbc
.PHONY: check-attract-scene-resources-bank23
check-attract-scene-resources-bank23: | baserom.gbc
	@$(PYTHON) tools/verify_attract_scene_resources_bank23.py baserom.gbc

.PHONY: check-attract-layout-renderer
check-attract-layout-renderer: | baserom.gbc
	@$(PYTHON) tools/verify_attract_layout_renderer.py baserom.gbc
.PHONY: check-attract-scene-resources-bank24
check-attract-scene-resources-bank24: | baserom.gbc
	@$(PYTHON) tools/verify_attract_scene_resources_bank24.py baserom.gbc

.PHONY: check-attract-scene0-aliases
check-attract-scene0-aliases: | baserom.gbc
	@$(PYTHON) tools/verify_attract_scene0_aliases.py baserom.gbc


.PHONY: check-common-screen-tilemap-runtime
check-common-screen-tilemap-runtime:
	$(PYTHON) tools/verify_common_screen_tilemap_runtime.py baserom.gbc

.PHONY: check-window-stack-runtime
check-window-stack-runtime:
	$(PYTHON) tools/verify_window_stack_runtime.py baserom.gbc

.PHONY: check-unit-list-controller-mnemonic
check-unit-list-controller-mnemonic: | baserom.gbc
	$(PYTHON) tools/verify_unit_list_controller_mnemonic.py baserom.gbc

.PHONY: check-unit-list-action-mnemonic
check-unit-list-action-mnemonic: | baserom.gbc
	$(PYTHON) tools/verify_unit_list_action_mnemonic.py baserom.gbc

.PHONY: check-bank0b-cursor-analysis-mnemonic
check-bank0b-cursor-analysis-mnemonic: GBWARS3.gbc
	$(PYTHON) tools/verify_bank0b_cursor_analysis_mnemonic.py

.PHONY: check-bank0b-map-setup-mnemonic
check-bank0b-map-setup-mnemonic: | baserom.gbc
	$(PYTHON) tools/verify_bank0b_map_setup_mnemonic.py baserom.gbc

.PHONY: check-map-resolution-semantics
check-map-resolution-semantics:
	$(PYTHON) tools/verify_map_resolution_semantics.py

.PHONY: check-map-result-presentation-runtime
check-map-result-presentation-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_map_result_presentation_runtime.py

.PHONY: check-result-presentation-providers
check-result-presentation-providers: GBWARS3.gbc
	$(PYTHON) tools/verify_result_presentation_providers.py

.PHONY: check-presentation-sequence-bodies

check-unit-action-presentation-runtime:
	$(PYTHON) tools/verify_unit_action_presentation_runtime.py

check-presentation-sequence-bodies: GBWARS3.gbc
	$(PYTHON) tools/verify_presentation_sequence_bodies.py

.PHONY: check-presentation-sequence-semantics
check-presentation-sequence-semantics: GBWARS3.gbc
	$(PYTHON) tools/verify_presentation_sequence_semantics.py

.PHONY: check-property-state-presentation
check-property-state-presentation: GBWARS3.gbc
	$(PYTHON) tools/verify_property_state_presentation.py

.PHONY: check-property-state-table-management
check-property-state-table-management: GBWARS3.gbc
	$(PYTHON) tools/verify_property_state_table_management.py

.PHONY: check-map-editor-interaction-runtime
check-map-editor-interaction-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_map_editor_interaction_runtime.py

.PHONY: check-map-editor-menu-handlers
check-map-editor-menu-handlers: GBWARS3.gbc
	$(PYTHON) tools/verify_map_editor_menu_handlers.py

.PHONY: check-property-state-runtime
check-property-state-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_property_state_runtime.py

.PHONY: check-map-editor-submenu-arrange
check-map-editor-submenu-arrange:
	$(PYTHON) tools/verify_map_editor_submenu_arrange.py

.PHONY: check-map-editor-arrange-options
check-map-editor-arrange-options: GBWARS3.gbc
	$(PYTHON) tools/verify_map_editor_arrange_options.py

.PHONY: check-map-action-effect-runtime
check-map-action-effect-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_map_action_effect_runtime.py

.PHONY: check-map-popup-presentation-runtime
check-map-popup-presentation-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_map_popup_presentation_runtime.py

.PHONY: check-unit-supply-service-runtime
check-unit-supply-service-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_supply_service_runtime.py

.PHONY: check-unit-deployment-runtime
check-unit-deployment-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_deployment_runtime.py

.PHONY: check-battle-fire-infrared-runtime
check-battle-fire-infrared-runtime:
	$(PYTHON) tools/verify_battle_fire_infrared_runtime.py

check-pave-fire-end-phase-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_pave_fire_end_phase_runtime.py

.PHONY: check-unit-list-bank17-helpers
check-unit-list-bank17-helpers: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_list_bank17_helpers.py

.PHONY: check-bank17-battle-palette-versus-helper
check-bank17-battle-palette-versus-helper: GBWARS3.gbc
	$(PYTHON) tools/verify_bank17_battle_palette_versus_helper.py

check-shared-graphics-unit-reference: GBWARS3.gbc
	$(PYTHON) tools/verify_shared_graphics_unit_reference.py

.PHONY: check-sprite-exit-transition-runtime
check-sprite-exit-transition-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_sprite_exit_transition_runtime.py

.PHONY: check-bank22-text-window-textinput-redraw
check-bank22-text-window-textinput-redraw: GBWARS3.gbc
	$(PYTHON) tools/verify_bank22_text_window_and_textinput_redraw.py

.PHONY: check-unit-reference-navigation-detail
check-unit-reference-navigation-detail: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_reference_navigation_detail.py

.PHONY: check-unit-reference-submenus
check-unit-reference-submenus: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_reference_submenus.py

.PHONY: check-unit-reference-terrain-upkeep-provider
check-unit-reference-terrain-upkeep-provider: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_reference_terrain_upkeep_provider.py

.PHONY: check-unit-reference-late-submenu-providers
check-unit-reference-late-submenu-providers: GBWARS3.gbc
	$(PYTHON) tools/verify_unit_reference_late_submenu_providers.py

.PHONY: check-description-runtime-bank32
check-description-runtime-bank32: GBWARS3.gbc
	$(PYTHON) tools/verify_description_runtime_bank32.py

.PHONY: check-recent-shared-providers
check-recent-shared-providers: GBWARS3.gbc
	$(PYTHON) tools/verify_recent_shared_providers.py

.PHONY: check-selected-map-command-providers
check-selected-map-command-providers: GBWARS3.gbc
	$(PYTHON) tools/verify_selected_map_command_providers.py

.PHONY: check-map-save-file-select-runtime
check-map-save-file-select-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_map_save_file_select_runtime.py

.PHONY: check-map-save-medal-checksum-runtime
check-map-save-medal-checksum-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_map_save_medal_checksum_runtime.py

.PHONY: check-startup-save-recovery-runtime
check-startup-save-recovery-runtime: GBWARS3.gbc
	$(PYTHON) tools/verify_startup_save_recovery_runtime.py

.PHONY: check-main-mode-startup-routing
check-main-mode-startup-routing: GBWARS3.gbc
	$(PYTHON) tools/verify_main_mode_startup_routing.py

.PHONY: check-campaign-result-detail-renderer
check-campaign-result-detail-renderer: GBWARS3.gbc
	python3 tools/verify_campaign_result_detail_renderer.py

.PHONY: check-map-surrender-resolution-prompt
check-map-surrender-resolution-prompt: GBWARS3.gbc
	$(PYTHON) tools/verify_map_surrender_resolution_prompt.py

.PHONY: check-battle-scene-weapon-target-sfx
check-battle-scene-weapon-target-sfx: | baserom.gbc
	$(PYTHON) tools/verify_battle_scene_weapon_target_sfx.py baserom.gbc GBWARS3.gbc

.PHONY: check-map-save-prompt-runtime-bank15
check-map-save-prompt-runtime-bank15: GBWARS3.gbc
	$(PYTHON) tools/verify_map_save_prompt_runtime_bank15.py

.PHONY: check-suspend-saved-session-preview
check-suspend-saved-session-preview: GBWARS3.gbc
	$(PYTHON) tools/verify_suspend_saved_session_preview.py

.PHONY: check-raw-executable-cleanup
check-raw-executable-cleanup:
	$(PYTHON) tools/verify_raw_executable_cleanup.py

.PHONY: check-map-selection-runtime-bank15
check-map-selection-runtime-bank15: GBWARS3.gbc
	$(PYTHON) tools/verify_map_selection_runtime_bank15.py

.PHONY: check-map-selection-resources-bank15
check-map-selection-resources-bank15: GBWARS3.gbc
	$(PYTHON) tools/verify_map_selection_resources_bank15.py

.PHONY: check-bank19-profile-list-setup
check-bank19-profile-list-setup: GBWARS3.gbc
	$(PYTHON) tools/verify_bank19_profile_list_setup.py

.PHONY: check-bank19-profile-review-double-contract
check-bank19-profile-review-double-contract: GBWARS3.gbc
	$(PYTHON) tools/verify_bank19_profile_review_double_contract.py

.PHONY: check-versus-country-maptype-mnemonic
check-versus-country-maptype-mnemonic: GBWARS3.gbc
	$(PYTHON) tools/verify_versus_country_maptype_mnemonic.py

.PHONY: check-bulk-runtime-mnemonic-cleanup
check-bulk-runtime-mnemonic-cleanup:
	$(PYTHON) tools/verify_bulk_runtime_mnemonic_cleanup.py
.PHONY: check-completion
check-completion: $(name).gbc
	$(PYTHON) tools/verify_completion.py

.PHONY: check-remaining-asset-migration
check-remaining-asset-migration:
	$(PYTHON) tools/verify_remaining_asset_migration.py


.PHONY: check-music-source
check-music-source: $(name).gbc
	$(PYTHON) tools/verify_music_source.py

.PHONY: check-refinement check-release
check-refinement: $(name).gbc
	$(PYTHON) tools/verify_refinement.py
	$(MAKE) check-remaining-asset-migration

check-release: baserom-verified $(name).gbc
	$(MAKE) check-rgbds-1-syntax
	$(MAKE) check-completion
	$(MAKE) check-refinement
	$(MAKE) check-music-source
	$(MAKE) check-semantic-polish
	$(PYTHON) tools/verify_release_static.py


.PHONY: check-semantic-polish
check-semantic-polish: $(name).gbc
	$(PYTHON) tools/verify_semantic_polish.py
