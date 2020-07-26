#
# This project constructs alfa2_acr.hak.  It compiles all script sources that
# are a part of the hak and then packages them up into an ERF.
#

NSS_INCLUDES=$(NSS_INCLUDES);$(PROJECT_SOURCE_ROOT)\NWNX4\inc
NSS_FLAVOR=NWN2

#.IGNORE :

!include $(PROJECT_SOURCE_ROOT)\makefile.def

NSS_INCLNSS=                                                   \
            $(OUTPUTDIR)\1sc_searchable.nss                    \
            $(OUTPUTDIR)\1sc_searchable_treasure.nss           \
            $(OUTPUTDIR)\acr_1984_i.nss                        \
            $(OUTPUTDIR)\acr_anchor_i.nss                      \
            $(OUTPUTDIR)\acr_area_i.nss                        \
            $(OUTPUTDIR)\acr_array_i.nss                       \
            $(OUTPUTDIR)\acr_list_i.nss                        \
            $(OUTPUTDIR)\acr_chat_i.nss                        \
            $(OUTPUTDIR)\acr_collections_i.nss                 \
            $(OUTPUTDIR)\acr_craft_creation_i.nss              \
            $(OUTPUTDIR)\acr_craft_progress_i.nss              \
            $(OUTPUTDIR)\acr_creature_i.nss                    \
            $(OUTPUTDIR)\acr_db_persist_i.nss                  \
            $(OUTPUTDIR)\acr_death_i.nss                       \
            $(OUTPUTDIR)\acr_debug_i.nss                       \
            $(OUTPUTDIR)\acr_door_i.nss                        \
            $(OUTPUTDIR)\acr_effects_i.nss                     \
            $(OUTPUTDIR)\acr_environment_i.nss                 \
            $(OUTPUTDIR)\acr_events_i.nss                      \
            $(OUTPUTDIR)\acr_feat_events_i.nss                 \
            $(OUTPUTDIR)\acr_feat_i.nss                        \
            $(OUTPUTDIR)\acr_game_loc_i.nss                    \
            $(OUTPUTDIR)\acr_hazards_i.nss                     \
            $(OUTPUTDIR)\acr_i.nss                             \
            $(OUTPUTDIR)\acr_interface_i.nss                   \
            $(OUTPUTDIR)\acr_items_i.nss                       \
            $(OUTPUTDIR)\acr_it_persist_i.nss                  \
            $(OUTPUTDIR)\acr_language_i.nss                    \
            $(OUTPUTDIR)\acr_mod_events_i.nss                  \
            $(OUTPUTDIR)\acr_mod_event_hook_i.nss              \
            $(OUTPUTDIR)\acr_nonlethal_i.nss                   \
            $(OUTPUTDIR)\acr_pchide_i.nss                      \
            $(OUTPUTDIR)\acr_physical_object_i.nss             \
            $(OUTPUTDIR)\acr_placeable_i.nss                   \
            $(OUTPUTDIR)\acr_poison_i.nss                      \
            $(OUTPUTDIR)\acr_portal_i.nss                      \
            $(OUTPUTDIR)\acr_pps_i.nss                         \
            $(OUTPUTDIR)\acr_prc_bladesinger_i.nss             \
            $(OUTPUTDIR)\acr_quest_i.nss                       \
            $(OUTPUTDIR)\acr_queue_i.nss                       \
            $(OUTPUTDIR)\acr_resting_i.nss                     \
            $(OUTPUTDIR)\acr_roll_i.nss                        \
            $(OUTPUTDIR)\acr_scry_i.nss                        \
            $(OUTPUTDIR)\acr_seamlessat_i.nss                  \
            $(OUTPUTDIR)\acr_settings_i.nss                    \
            $(OUTPUTDIR)\acr_skills_i.nss                      \
            $(OUTPUTDIR)\acr_spawn_i.nss                       \
            $(OUTPUTDIR)\acr_spells_i.nss                      \
            $(OUTPUTDIR)\acr_spellhook_i.nss                   \
            $(OUTPUTDIR)\acr_spelltrack_i.nss                  \
            $(OUTPUTDIR)\acr_time_i.nss                        \
            $(OUTPUTDIR)\acr_tools_i.nss                       \
            $(OUTPUTDIR)\acr_tradescroll_i.nss                 \
            $(OUTPUTDIR)\acr_travel_i.nss                      \
            $(OUTPUTDIR)\acr_trigger_i.nss                     \
            $(OUTPUTDIR)\acr_gui_i.nss                         \
            $(OUTPUTDIR)\acr_vfx_i.nss                         \
            $(OUTPUTDIR)\acr_wealth_i.nss                      \
            $(OUTPUTDIR)\acr_xp_i.nss                          \
            $(OUTPUTDIR)\dmfi_inc_const.nss                    \
            $(OUTPUTDIR)\nw_i0_spells.nss                      \
            $(OUTPUTDIR)\acr_zspawn_i.nss                      \
            $(OUTPUTDIR)\nwn2_inc_spells.nss                   \
            $(OUTPUTDIR)\dmfi_inc_command.nss                  \
            $(OUTPUTDIR)\dmfi_inc_conv.nss                     \
            $(OUTPUTDIR)\dmfi_inc_emotes.nss                   \
            $(OUTPUTDIR)\dmfi_inc_english.nss                  \
            $(OUTPUTDIR)\dmfi_inc_inc_com.nss                  \
            $(OUTPUTDIR)\dmfi_inc_initial.nss                  \
            $(OUTPUTDIR)\dmfi_inc_lang.nss                     \
            $(OUTPUTDIR)\dmfi_inc_langexe.nss                  \
            $(OUTPUTDIR)\dmfi_inc_sendtex.nss                  \
            $(OUTPUTDIR)\dmfi_inc_tool.nss                     \
            $(OUTPUTDIR)\kemo_includes.nss                     \
            $(OUTPUTDIR)\tkl_cardgame_descriptions.nss         \
            $(OUTPUTDIR)\tkl_cardgame_include.nss              \
            $(OUTPUTDIR)\tkl_performer_include.nss             \
            $(OUTPUTDIR)\tkl_performer_settings.nss            \
            $(OUTPUTDIR)\nwnx_clock.nss                        \
            $(OUTPUTDIR)\nwnx_include.nss                      \
            $(OUTPUTDIR)\nwnx_sql.nss                          \
            $(OUTPUTDIR)\nwnx_time.nss                         \
            $(OUTPUTDIR)\nwnx_objectattributes_include.nss     \
            $(OUTPUTDIR)\nwnx_craft.nss                        \
            $(OUTPUTDIR)\nwnx_craft_system.nss                 \
            $(OUTPUTDIR)\nwnx_nwscriptvm_include.nss           \
            $(OUTPUTDIR)\nw_i0_invocatns.nss                   \
            $(OUTPUTDIR)\acr_mobloot_i.nss                     \
            $(OUTPUTDIR)\acr_vanity_i.nss                      \
            $(OUTPUTDIR)\ginc_companion.nss                    \
            $(OUTPUTDIR)\hench_i0_assoc.nss                    \
            $(OUTPUTDIR)\hench_i0_attack.nss                   \
            $(OUTPUTDIR)\hench_i0_melee.nss                    \
            $(OUTPUTDIR)\hench_i0_strings.nss                  \
            $(OUTPUTDIR)\wand_inc_conf.nss                     \
            $(OUTPUTDIR)\wand_inc_language.nss                 \
            $(OUTPUTDIR)\wand_inc_language_it.nss              \
            $(OUTPUTDIR)\wand_inc_misc.nss                     \
            $(OUTPUTDIR)\wand_inc.nss                          \
            $(OUTPUTDIR)\acr_srvadmin_i.nss                    \
            $(OUTPUTDIR)\acr_server_ipc_i.nss                  \
            $(OUTPUTDIR)\acr_version_i.nss                     \
            $(OUTPUTDIR)\acr_server_misc_i.nss                 \
            $(OUTPUTDIR)\acr_scliext_i.nss                     \
            $(OUTPUTDIR)\acr_area_instance_i.nss               \
            $(OUTPUTDIR)\nw_s0_prvalign_i.nss                  \
            $(OUTPUTDIR)\x0_i0_anims.nss                       \
            $(OUTPUTDIR)\x0_i0_enemy.nss                       \
            $(OUTPUTDIR)\x2_inc_switches.nss                   \
            $(OUTPUTDIR)\ginc_crafting.nss                     \
            $(OUTPUTDIR)\ginc_group.nss                        \
            $(OUTPUTDIR)\acr_report_i.nss                      \
            $(OUTPUTDIR)\acr_combat_actions_i.nss              \
            $(OUTPUTDIR)\acr_combateffects_i.nss               \
            $(OUTPUTDIR)\acr_notifications_i.nss               \
            $(OUTPUTDIR)\hench_i0_ai.nss                       \
            $(OUTPUTDIR)\acr_1sc_spawn_i.nss                   \
            $(OUTPUTDIR)\acr_conversions_i.nss                 \
            $(OUTPUTDIR)\x2_inc_itemprop.nss                   \
            $(OUTPUTDIR)\acr_travelmap_i.nss                   \
            $(OUTPUTDIR)\x0_i0_spells.nss                      \
            $(OUTPUTDIR)\gui_bhvr_inc.nss                      \
            $(OUTPUTDIR)\acr_traps_i.nss                       \
            $(OUTPUTDIR)\acr_bard_i.nss                        \
            $(OUTPUTDIR)\shinn_sava_config_i.nss               \
            $(OUTPUTDIR)\shinn_sava_i.nss                      \
            $(OUTPUTDIR)\alfa_i0_oozesplit.nss                 \
            $(OUTPUTDIR)\acr_dropgold_i.nss                    \
            $(OUTPUTDIR)\acr_movement_i.nss                    \
            $(OUTPUTDIR)\acr_position_i.nss                    \
            $(OUTPUTDIR)\acr_guiglobals_i.nss                  

NSS_OBJECTS=                                                   \
            $(OUTPUTDIR)\1sc_plc_ontrapdisarm.ncs              \
            $(OUTPUTDIR)\1sc_plc_onunlock.ncs                  \
            $(OUTPUTDIR)\1sc_search_chest_high.ncs             \
            $(OUTPUTDIR)\1sc_search_chest_low.ncs              \
            $(OUTPUTDIR)\1sc_search_chest_norm.ncs             \
            $(OUTPUTDIR)\1sc_search_chest_unique.ncs           \
            $(OUTPUTDIR)\1sc_search_destroyed.ncs              \
            $(OUTPUTDIR)\1sc_search_dmgd_high.ncs              \
            $(OUTPUTDIR)\1sc_search_dmgd_low.ncs               \
            $(OUTPUTDIR)\1sc_search_dmgd_norm.ncs              \
            $(OUTPUTDIR)\1sc_search_dmgd_unique.ncs            \
            $(OUTPUTDIR)\1sc_trg_onenter.ncs                   \
            $(OUTPUTDIR)\abr_plc_oninventorydisreturns.ncs     \
            $(OUTPUTDIR)\abr_plc_onopenreturns.ncs             \
            $(OUTPUTDIR)\abr_storeclose.ncs                    \
            $(OUTPUTDIR)\abr_storeopen.ncs                     \
            $(OUTPUTDIR)\abr_trg_returnsonenter.ncs            \
            $(OUTPUTDIR)\abr_trg_returnsonexit.ncs             \
            $(OUTPUTDIR)\acr_cs_abcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_atcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_bootpc.ncs                     \
            $(OUTPUTDIR)\acr_crafting_store_onclose.ncs        \
            $(OUTPUTDIR)\acr_cs_gpcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_guard_duty.ncs                 \
            $(OUTPUTDIR)\acr_cs_guard_in.ncs                   \
            $(OUTPUTDIR)\acr_cs_guard_out.ncs                  \
            $(OUTPUTDIR)\acr_cs_has_item.ncs                   \
            $(OUTPUTDIR)\acr_cs_skcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_svcheck.ncs                    \
            $(OUTPUTDIR)\acr_feat_bladesong.ncs                \
            $(OUTPUTDIR)\acr_feat_bladesong_hb.ncs             \
            $(OUTPUTDIR)\acr_feat_brew_potion.ncs              \
            $(OUTPUTDIR)\acr_feat_craft.ncs                    \
            $(OUTPUTDIR)\acr_feat_craft_wand.ncs               \
            $(OUTPUTDIR)\acr_feat_scribe_scroll.ncs            \
            $(OUTPUTDIR)\acr_feat_spellsong.ncs                \
            $(OUTPUTDIR)\acr_feat_spellsong_hb.ncs             \
            $(OUTPUTDIR)\acr_feat_songofcelerity.ncs           \
            $(OUTPUTDIR)\acr_feat_songoffury.ncs               \
            $(OUTPUTDIR)\acr_quest_progress.ncs                \
            $(OUTPUTDIR)\acr_quest_reward.ncs                  \
            $(OUTPUTDIR)\acr_quest_rewardbycr.ncs              \
            $(OUTPUTDIR)\acr_quest_update.ncs                  \
            $(OUTPUTDIR)\acr_poison_applied.ncs                \
            $(OUTPUTDIR)\acr_poison_impact.ncs                 \
            $(OUTPUTDIR)\acr_poison_incubated.ncs              \
            $(OUTPUTDIR)\acr_s0_acidarrow.ncs                  \
            $(OUTPUTDIR)\acr_s0_barkskin.ncs                   \
            $(OUTPUTDIR)\acr_s0_bless.ncs                      \
            $(OUTPUTDIR)\acr_s0_blur.ncs                       \
            $(OUTPUTDIR)\acr_s0_causefear.ncs                  \
            $(OUTPUTDIR)\acr_s0_charmper.ncs                   \
            $(OUTPUTDIR)\acr_s0_combust.ncs                    \
            $(OUTPUTDIR)\acr_s0_complang.ncs                   \
            $(OUTPUTDIR)\acr_s0_curminw.ncs                    \
            $(OUTPUTDIR)\acr_s0_daze.ncs                       \
            $(OUTPUTDIR)\acr_s0_dazemonster.ncs                \
            $(OUTPUTDIR)\acr_s0_detectmagic.ncs                \
            $(OUTPUTDIR)\acr_s0_dimdoor.ncs                    \
            $(OUTPUTDIR)\go_xp_lock.ncs                        \
            $(OUTPUTDIR)\acr_s0_dimensional_anchor.ncs         \
            $(OUTPUTDIR)\acr_s0_dismagic.ncs                   \
            $(OUTPUTDIR)\acr_s0_disruptundead.ncs              \
            $(OUTPUTDIR)\acr_s0_exretreat.ncs                  \
            $(OUTPUTDIR)\acr_s0_fear.ncs                       \
            $(OUTPUTDIR)\acr_s0_feather_fall.ncs               \
            $(OUTPUTDIR)\acr_s0_glibness.ncs                   \
            $(OUTPUTDIR)\acr_s0_haltundead.ncs                 \
            $(OUTPUTDIR)\acr_s0_haste.ncs                      \
            $(OUTPUTDIR)\acr_s0_jump.ncs                       \
            $(OUTPUTDIR)\acr_s0_lsdispel.ncs                   \
			$(OUTPUTDIR)\nw_s0_neutpois.ncs                    \
            $(OUTPUTDIR)\acr_s0_open_close.ncs                 \
            $(OUTPUTDIR)\acr_s0_rayenfeeb.ncs                  \
            $(OUTPUTDIR)\acr_s0_rayexhaustion.ncs              \
            $(OUTPUTDIR)\acr_s0_rayfrost.ncs                   \
            $(OUTPUTDIR)\acr_s0_readmagic.ncs                  \
            $(OUTPUTDIR)\acr_s0_scare.ncs                      \
            $(OUTPUTDIR)\acr_s0_seeinvis.ncs                   \
            $(OUTPUTDIR)\acr_s0_sleep.ncs                      \
            $(OUTPUTDIR)\acr_s0_snillocsnowball.ncs            \
            $(OUTPUTDIR)\acr_s0_spiderclimb.ncs                \
            $(OUTPUTDIR)\acr_s0_stoneskin.ncs                  \
            $(OUTPUTDIR)\acr_s0_water_breathing.ncs            \
            $(OUTPUTDIR)\acr_s0_web.ncs                        \
            $(OUTPUTDIR)\acr_s0_shillelagh.ncs                 \
            $(OUTPUTDIR)\acr_s0_goodberry.ncs                  \
            $(OUTPUTDIR)\acr_s0_magicstone.ncs                 \
            $(OUTPUTDIR)\acr_s3_onhitmstone.ncs                \
            $(OUTPUTDIR)\acr_s0_rp.ncs                         \
            $(OUTPUTDIR)\acr_s1_recall_spirit.ncs              \
            $(OUTPUTDIR)\acr_s2_wildshape.ncs                  \
            $(OUTPUTDIR)\acr_spellhook.ncs                     \
            $(OUTPUTDIR)\acr_trg_portalstart.ncs               \
            $(OUTPUTDIR)\dmfi_conv_def.ncs                     \
            $(OUTPUTDIR)\dmfi_conv_def_pc.ncs                  \
            $(OUTPUTDIR)\dmfi_delayed_pcload.ncs               \
            $(OUTPUTDIR)\dmfi_exe_tool.ncs                     \
            $(OUTPUTDIR)\dmfi_mod_pcload.ncs                   \
            $(OUTPUTDIR)\dmfi_plugin_cmd1.ncs                  \
            $(OUTPUTDIR)\dmfi_plugin_cmd2.ncs                  \
            $(OUTPUTDIR)\dmfi_plugin_emt1.ncs                  \
            $(OUTPUTDIR)\dmfi_plugin_rule.ncs                  \
            $(OUTPUTDIR)\acr_getnearestcreaturetolocation.ncs  \
            $(OUTPUTDIR)\gui_kemo_chair_anim.ncs               \
            $(OUTPUTDIR)\gui_kemo_portablechair.ncs            \
            $(OUTPUTDIR)\gui_resting_calc.ncs                  \
            $(OUTPUTDIR)\gui_kemo_resize.ncs                   \
            $(OUTPUTDIR)\gui_kemo_turnchair.ncs                \
            $(OUTPUTDIR)\i_abr_it_firstaid_ac.ncs              \
            $(OUTPUTDIR)\i_acr_subdual_ac.ncs                  \
            $(OUTPUTDIR)\i_kemoportablechair_ac.ncs            \
            $(OUTPUTDIR)\kemo_animation_hb.ncs                 \
            $(OUTPUTDIR)\kemo_chair.ncs                        \
            $(OUTPUTDIR)\gui_kemo_anim.ncs                     \
            $(OUTPUTDIR)\nw_s0_wordfaith.ncs                   \
            $(OUTPUTDIR)\gui_kemo_anim_lap.ncs                 \
            $(OUTPUTDIR)\gui_kemo_animation.ncs                \
            $(OUTPUTDIR)\gui_kemo_bio.ncs                      \
            $(OUTPUTDIR)\gui_kemo_nudge.ncs                    \
            $(OUTPUTDIR)\gui_kemo_repeat.ncs                   \
            $(OUTPUTDIR)\nw_s0_colspray.ncs                    \
            $(OUTPUTDIR)\nw_s0_curcrwn.ncs                     \
            $(OUTPUTDIR)\nw_s0_curlgtw.ncs                     \
            $(OUTPUTDIR)\nw_s0_curmodw.ncs                     \
            $(OUTPUTDIR)\nw_s0_curserw.ncs                     \
            $(OUTPUTDIR)\nw_s0_grease.ncs                      \
            $(OUTPUTDIR)\nw_s0_grrestore.ncs                   \
            $(OUTPUTDIR)\nw_s0_heal.ncs                        \
            $(OUTPUTDIR)\nw_s0_macurcrit.ncs                   \
            $(OUTPUTDIR)\nw_s0_macurligt.ncs                   \
            $(OUTPUTDIR)\nw_s0_macurmod.ncs                    \
            $(OUTPUTDIR)\nw_s0_macurseri.ncs                   \
            $(OUTPUTDIR)\nw_s0_magearm.ncs                     \
            $(OUTPUTDIR)\nw_s0_masheal.ncs                     \
            $(OUTPUTDIR)\nw_s0_regen.ncs                       \
            $(OUTPUTDIR)\nw_s0_rejuvcocoon.ncs                 \
            $(OUTPUTDIR)\X0_S0_AcidSplash.ncs                  \
            $(OUTPUTDIR)\x0_s0_inflict.ncs                     \
            $(OUTPUTDIR)\NX2_S0_OrbAcid.ncs                    \
            $(OUTPUTDIR)\NX2_S0_OrbAcidLess.ncs                \
            $(OUTPUTDIR)\NX2_S0_OrbCold.ncs                    \
            $(OUTPUTDIR)\NX2_S0_OrbColdLess.ncs                \
            $(OUTPUTDIR)\NX2_S0_OrbElec.ncs                    \
            $(OUTPUTDIR)\NX2_S0_OrbElecLess.ncs                \
            $(OUTPUTDIR)\NX2_S0_OrbFire.ncs                    \
            $(OUTPUTDIR)\NX2_S0_OrbFireLess.ncs                \
            $(OUTPUTDIR)\NX2_S0_OrbSound.ncs                   \
            $(OUTPUTDIR)\NX2_S0_OrbSoundLess.ncs               \
            $(OUTPUTDIR)\nw_s0_shknggrsp.ncs                   \
            $(OUTPUTDIR)\nw_s0_deathknel.ncs                   \
            $(OUTPUTDIR)\nx_s0_scorchingray.ncs                \
            $(OUTPUTDIR)\nx_s0_scorchingraysingle.ncs          \
            $(OUTPUTDIR)\nx_s0_scorchingraymany.ncs            \
            $(OUTPUTDIR)\X2_S0_InfestMag.ncs                   \
            $(OUTPUTDIR)\NW_S0_SearLght.ncs                    \
            $(OUTPUTDIR)\nw_s0_vamptch.ncs                     \
            $(OUTPUTDIR)\nw_s0_contagion.ncs                   \
            $(OUTPUTDIR)\nw_s0_enervat.ncs                     \
            $(OUTPUTDIR)\nw_s0_slaylive.ncs                    \
            $(OUTPUTDIR)\nw_s0_disngrt.ncs                     \
            $(OUTPUTDIR)\nw_s0_polarray.ncs                    \
            $(OUTPUTDIR)\nw_s0_enedrain.ncs                    \
            $(OUTPUTDIR)\x0_s0_bigby4.ncs                      \
            $(OUTPUTDIR)\x0_s0_bigby5.ncs                      \
            $(OUTPUTDIR)\nx_s0_avasculate.ncs                  \
            $(OUTPUTDIR)\nw_s2_layonhand.ncs                   \
            $(OUTPUTDIR)\nw_s2_sngfascin.ncs                   \
            $(OUTPUTDIR)\nw_s2_wholeness.ncs                   \
            $(OUTPUTDIR)\nx2_s0_healing_sting.ncs              \
            $(OUTPUTDIR)\nx_s0_lsrvigor.ncs                    \
            $(OUTPUTDIR)\nx_s0_mlsrvigor.ncs                   \
            $(OUTPUTDIR)\nx_s0_vigor.ncs                       \
            $(OUTPUTDIR)\nx_s0_vigorcycle.ncs                  \
            $(OUTPUTDIR)\nx_s0_walldisp.ncs                    \
            $(OUTPUTDIR)\x0_s3_acid.ncs                        \
            $(OUTPUTDIR)\x0_s3_alchem.ncs                      \
            $(OUTPUTDIR)\x0_s3_choke.ncs                       \
            $(OUTPUTDIR)\x0_s3_holy.ncs                        \
            $(OUTPUTDIR)\x0_s3_tangle.ncs                      \
            $(OUTPUTDIR)\x0_s3_thunder.ncs                     \
            $(OUTPUTDIR)\X2_S0_BattTide.ncs                    \
            $(OUTPUTDIR)\X2_S0_BattTideA.ncs                   \
            $(OUTPUTDIR)\X2_S0_BattTideB.ncs                   \
            $(OUTPUTDIR)\X2_S0_BattTideC.ncs                   \
            $(OUTPUTDIR)\x2_s0_cureother.ncs                   \
            $(OUTPUTDIR)\x2_s1_ether.ncs                       \
            $(OUTPUTDIR)\acr_tradescroll_impact.ncs            \
            $(OUTPUTDIR)\gui_zspawn_open.ncs                   \
            $(OUTPUTDIR)\gui_zspawn_close.ncs                  \
            $(OUTPUTDIR)\gui_zspawn_new.ncs                    \
            $(OUTPUTDIR)\acr_zspawn_one.ncs                    \
            $(OUTPUTDIR)\acr_zspawn_2d4.ncs                    \
            $(OUTPUTDIR)\acr_zspawn_one_nh.ncs                 \
            $(OUTPUTDIR)\acr_zspawn_2d4_nh.ncs                 \
            $(OUTPUTDIR)\gui_atsign.ncs                        \
            $(OUTPUTDIR)\gui_acr_anchorman.ncs                 \
            $(OUTPUTDIR)\gui_acr_examine.ncs                   \
            $(OUTPUTDIR)\gui_acr_lockedit.ncs                  \
            $(OUTPUTDIR)\gui_acr_pvfx.ncs                      \
            $(OUTPUTDIR)\gui_acr_slang.ncs                     \
            $(OUTPUTDIR)\gui_acr_ugui.ncs                      \
            $(OUTPUTDIR)\gui_acr_ugui_target.ncs               \
            $(OUTPUTDIR)\gui_dropgold_close.ncs                \
            $(OUTPUTDIR)\gui_dropgold_open.ncs                 \
            $(OUTPUTDIR)\gui_dropgold_modify_value.ncs         \
            $(OUTPUTDIR)\gui_dropgold_target.ncs               \
            $(OUTPUTDIR)\abr_plc_getdropgold.ncs               \
            $(OUTPUTDIR)\tkl_cardgame_chair.ncs                \
            $(OUTPUTDIR)\tkl_performer_lute.ncs                \
            $(OUTPUTDIR)\tkl_performer_drum.ncs                \
            $(OUTPUTDIR)\tkl_performer_flute.ncs               \
            $(OUTPUTDIR)\tkl_performer_score.ncs               \
            $(OUTPUTDIR)\tkl_performer_ue.ncs                  \
            $(OUTPUTDIR)\tkl_performer_npc_actions.ncs         \
            $(OUTPUTDIR)\gui_tkl_cardgame.ncs                  \
            $(OUTPUTDIR)\gui_tkl_cardgame_bank.ncs             \
            $(OUTPUTDIR)\gui_tkl_cardgame_pot.ncs              \
            $(OUTPUTDIR)\gui_tkl_performer.ncs                 \
            $(OUTPUTDIR)\gui_tkl_performer_cancel.ncs          \
            $(OUTPUTDIR)\gui_tkl_performer_input.ncs           \
            $(OUTPUTDIR)\gui_tkl_performer_message.ncs         \
            $(OUTPUTDIR)\x2_s3_onhitcast.ncs                   \
            $(OUTPUTDIR)\nw_s0_ibeguinfl.ncs                   \
            $(OUTPUTDIR)\nw_s0_ibeshblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_ibewiblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_ibrimblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_icharm.ncs                      \
            $(OUTPUTDIR)\nw_s0_ichiltent.ncs                   \
            $(OUTPUTDIR)\nw_s0_ichiltenta.ncs                  \
            $(OUTPUTDIR)\nw_s0_ichiltentc.ncs                  \
            $(OUTPUTDIR)\nw_s0_icursedes.ncs                   \
            $(OUTPUTDIR)\nw_s0_idarkfors.ncs                   \
            $(OUTPUTDIR)\nw_s0_idarkness.ncs                   \
            $(OUTPUTDIR)\nw_s0_ideadwalk.ncs                   \
            $(OUTPUTDIR)\nw_s0_idevmagic.ncs                   \
            $(OUTPUTDIR)\nw_s0_idranblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_idrkonlck.ncs                   \
            $(OUTPUTDIR)\nw_s0_idvlsight.ncs                   \
            $(OUTPUTDIR)\nw_s0_ieldblast.ncs                   \
            $(OUTPUTDIR)\nw_s0_ieldchain.ncs                   \
            $(OUTPUTDIR)\nw_s0_ieldcone.ncs                    \
            $(OUTPUTDIR)\nw_s0_ielddoom.ncs                    \
            $(OUTPUTDIR)\nw_s0_ieldspear.ncs                   \
            $(OUTPUTDIR)\nw_s0_ientrward.ncs                   \
            $(OUTPUTDIR)\nw_s0_ifleescen.ncs                   \
            $(OUTPUTDIR)\nw_s0_ifrgtblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_ihellblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_ihideous2.ncs                   \
            $(OUTPUTDIR)\nw_s0_ihideousb.ncs                   \
            $(OUTPUTDIR)\nw_s0_ileapsbnd.ncs                   \
            $(OUTPUTDIR)\nw_s0_inoxiblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_iretinvis.ncs                   \
            $(OUTPUTDIR)\nw_s0_iseeunsen.ncs                   \
            $(OUTPUTDIR)\nw_s0_itenplage.ncs                   \
            $(OUTPUTDIR)\nw_s0_itenplagec.ncs                  \
            $(OUTPUTDIR)\nw_s0_iuttrblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_ivitrblst.ncs                   \
            $(OUTPUTDIR)\nw_s0_ivoradisp.ncs                   \
            $(OUTPUTDIR)\nw_s0_iwalkunsn.ncs                   \
            $(OUTPUTDIR)\nw_s0_iwallflam.ncs                   \
            $(OUTPUTDIR)\nw_s0_iwallflama.ncs                  \
            $(OUTPUTDIR)\nw_s0_iwallflamc.ncs                  \
            $(OUTPUTDIR)\nw_s0_iwordchng.ncs                   \
            $(OUTPUTDIR)\nw_s0_impmagarm.ncs                   \
            $(OUTPUTDIR)\x0_s0_ether.ncs                       \
            $(OUTPUTDIR)\x0_s0_shield.ncs                      \
            $(OUTPUTDIR)\acr_s0_shadow_acidfog.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_acidfoga.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_acidfogb.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_acidfogc.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_arc_lightning.ncs       \
            $(OUTPUTDIR)\acr_s0_shadow_evards.ncs              \
            $(OUTPUTDIR)\acr_s0_shadow_evardsa.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_evardsc.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_orbsound.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_vitsphere.ncs           \
            $(OUTPUTDIR)\nw_s0_grshconj.ncs                    \
            $(OUTPUTDIR)\acr_s0_shadow_darkness.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_darknessa.ncs           \
            $(OUTPUTDIR)\acr_s0_shadow_darknessb.ncs           \
            $(OUTPUTDIR)\acr_s0_shadowevoc.ncs                 \
            $(OUTPUTDIR)\acr_s0_shadow_icestorm.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_lghtnbolt.ncs           \
            $(OUTPUTDIR)\acr_s0_shadow_orbelecless.ncs         \
            $(OUTPUTDIR)\acr_s0_shadow_wallfire.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_acidbrth.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_flmarrow.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_grease.ncs              \
            $(OUTPUTDIR)\acr_s0_shadow_greasea.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_greaseb.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_greasec.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_magmiss.ncs             \
            $(OUTPUTDIR)\acr_s0_shadow_stinkcld.ncs            \
            $(OUTPUTDIR)\acr_s0_shadow_stinkclda.ncs           \
            $(OUTPUTDIR)\acr_s0_shadow_stinkcldc.ncs           \
            $(OUTPUTDIR)\acr_s0_shadow_wallfirea.ncs           \
            $(OUTPUTDIR)\acr_s0_shadow_wallfirec.ncs           \
            $(OUTPUTDIR)\nw_s0_shadconj.ncs                    \
            $(OUTPUTDIR)\nw_s0_harm.ncs                        \
            $(OUTPUTDIR)\nw_c2_default1.ncs                    \
            $(OUTPUTDIR)\nw_c2_default2.ncs                    \
            $(OUTPUTDIR)\nw_c2_default3.ncs                    \
            $(OUTPUTDIR)\nw_c2_default4.ncs                    \
            $(OUTPUTDIR)\nw_c2_default5.ncs                    \
            $(OUTPUTDIR)\nw_c2_default6.ncs                    \
            $(OUTPUTDIR)\nw_c2_default7.ncs                    \
            $(OUTPUTDIR)\nw_c2_default8.ncs                    \
            $(OUTPUTDIR)\nw_c2_default9.ncs                    \
            $(OUTPUTDIR)\nw_c2_defaulta.ncs                    \
            $(OUTPUTDIR)\nw_c2_defaultb.ncs                    \
            $(OUTPUTDIR)\nw_c2_defaultd.ncs                    \
            $(OUTPUTDIR)\nw_c2_defaulte.ncs                    \
            $(OUTPUTDIR)\nwnx_craft_set_constants.ncs          \
            $(OUTPUTDIR)\nwnx_craft_init.ncs                   \
            $(OUTPUTDIR)\gui_color_tls.ncs                     \
            $(OUTPUTDIR)\d_nwnx_craft_action.ncs               \
            $(OUTPUTDIR)\d_nwnx_craft_condition.ncs            \
            $(OUTPUTDIR)\d_nwnx_craft_escape_dialog.ncs        \
            $(OUTPUTDIR)\d_nwnx_craft_item_init.ncs            \
            $(OUTPUTDIR)\gb_assoc_attack.ncs                   \
            $(OUTPUTDIR)\gb_assoc_block.ncs                    \
            $(OUTPUTDIR)\gb_assoc_combat.ncs                   \
            $(OUTPUTDIR)\gb_assoc_conv.ncs                     \
            $(OUTPUTDIR)\gb_assoc_damage.ncs                   \
            $(OUTPUTDIR)\gb_assoc_death.ncs                    \
            $(OUTPUTDIR)\gb_assoc_distrb.ncs                   \
            $(OUTPUTDIR)\gb_assoc_heart.ncs                    \
            $(OUTPUTDIR)\gb_assoc_percep.ncs                   \
            $(OUTPUTDIR)\gb_assoc_rest.ncs                     \
            $(OUTPUTDIR)\gb_assoc_spawn.ncs                    \
            $(OUTPUTDIR)\gb_assoc_spell.ncs                    \
            $(OUTPUTDIR)\gb_assoc_usrdef.ncs                   \
            $(OUTPUTDIR)\gui_hss_pc_tool.ncs                   \
            $(OUTPUTDIR)\gui_cre_identify.ncs                  \
            $(OUTPUTDIR)\gui_dmc_crexamine.ncs                 \
            $(OUTPUTDIR)\gui_dmc_crselect.ncs                  \
            $(OUTPUTDIR)\gui_dmc_crspawn.ncs                   \
            $(OUTPUTDIR)\gui_dmc_crunselect.ncs                \
            $(OUTPUTDIR)\gui_dmc_forcerest.ncs                 \
            $(OUTPUTDIR)\gui_dmc_givexp.ncs                    \
            $(OUTPUTDIR)\gui_dmc_setxp.ncs                     \
            $(OUTPUTDIR)\gui_dmfi_battle.ncs                   \
            $(OUTPUTDIR)\gui_dmfi_dmlist.ncs                   \
            $(OUTPUTDIR)\gui_dmfi_dmtool.ncs                   \
            $(OUTPUTDIR)\gui_dmfi_dmui.ncs                     \
            $(OUTPUTDIR)\gui_dmfi_dmlist.ncs                   \
            $(OUTPUTDIR)\gui_dmfi_mngrtool.ncs                 \
            $(OUTPUTDIR)\gui_dmfi_playerui.ncs                 \
            $(OUTPUTDIR)\gui_dmfi_list.ncs                     \
            $(OUTPUTDIR)\gui_dmfi_skills.ncs                   \
            $(OUTPUTDIR)\gui_dmfi_text.ncs                     \
            $(OUTPUTDIR)\gui_dmfi_trgtool.ncs                  \
            $(OUTPUTDIR)\gui_dmfi_vfxcustom.ncs                \
            $(OUTPUTDIR)\hench_o0_ai.ncs                       \
            $(OUTPUTDIR)\acr_disguise.ncs                      \
            $(OUTPUTDIR)\gui_scliext_identify.ncs              \
            $(OUTPUTDIR)\gui_scliext_dm_pollarea.ncs           \
            $(OUTPUTDIR)\gui_it_pickupequip.ncs                \
            $(OUTPUTDIR)\gui_option_hench_change.ncs           \
            $(OUTPUTDIR)\gui_set_last_dragged_item.ncs         \
            $(OUTPUTDIR)\gui_wand_init_dmfi_h.ncs              \
            $(OUTPUTDIR)\gui_wand_init_dmfi_v.ncs              \
            $(OUTPUTDIR)\gui_wand_init_h.ncs                   \
            $(OUTPUTDIR)\gui_wand_init_v.ncs                   \
            $(OUTPUTDIR)\gui_wand_lvm_close.ncs                \
            $(OUTPUTDIR)\gui_wand_lvm_del_float.ncs            \
            $(OUTPUTDIR)\gui_wand_lvm_del_int.ncs              \
            $(OUTPUTDIR)\gui_wand_lvm_del_loc.ncs              \
            $(OUTPUTDIR)\gui_wand_lvm_del_obj.ncs              \
            $(OUTPUTDIR)\gui_wand_lvm_del_str.ncs              \
            $(OUTPUTDIR)\gui_wand_lvm_do_float.ncs             \
            $(OUTPUTDIR)\gui_wand_lvm_do_int.ncs               \
            $(OUTPUTDIR)\gui_wand_lvm_do_loc.ncs               \
            $(OUTPUTDIR)\gui_wand_lvm_do_obj.ncs               \
            $(OUTPUTDIR)\gui_wand_lvm_do_str.ncs               \
            $(OUTPUTDIR)\gui_wand_lvm_init.ncs                 \
            $(OUTPUTDIR)\gui_wand_lvm_init_area.ncs            \
            $(OUTPUTDIR)\gui_wand_lvm_init_float.ncs           \
            $(OUTPUTDIR)\gui_wand_lvm_init_int.ncs             \
            $(OUTPUTDIR)\gui_wand_lvm_init_loc.ncs             \
            $(OUTPUTDIR)\gui_wand_lvm_init_obj.ncs             \
            $(OUTPUTDIR)\gui_wand_lvm_init_str.ncs             \
            $(OUTPUTDIR)\gui_wand_lvm_new_tab.ncs              \
            $(OUTPUTDIR)\gui_wand_lvm_obj_input_lost_foc.ncs   \
            $(OUTPUTDIR)\gui_wand_lvm_reload.ncs               \
            $(OUTPUTDIR)\gui_wand_lvm_show.ncs                 \
            $(OUTPUTDIR)\gui_wand_lvm_target_loc.ncs           \
            $(OUTPUTDIR)\gui_wand_lvm_target_obj.ncs           \
            $(OUTPUTDIR)\gui_wand_pim_close.ncs                \
            $(OUTPUTDIR)\gui_wand_pim_cursed.ncs               \
            $(OUTPUTDIR)\gui_wand_pim_droppable.ncs            \
            $(OUTPUTDIR)\gui_wand_pim_equip.ncs                \
            $(OUTPUTDIR)\gui_wand_pim_examine.ncs              \
            $(OUTPUTDIR)\gui_wand_pim_give.ncs                 \
            $(OUTPUTDIR)\gui_wand_pim_identified.ncs           \
            $(OUTPUTDIR)\gui_wand_pim_init.ncs                 \
            $(OUTPUTDIR)\gui_wand_pim_init_radial.ncs          \
            $(OUTPUTDIR)\gui_wand_pim_init_radial_eq.ncs       \
            $(OUTPUTDIR)\gui_wand_pim_plot.ncs                 \
            $(OUTPUTDIR)\gui_wand_pim_reload.ncs               \
            $(OUTPUTDIR)\gui_wand_pim_show.ncs                 \
            $(OUTPUTDIR)\gui_wand_pim_show_tab.ncs             \
            $(OUTPUTDIR)\gui_wand_pim_stolen.ncs               \
            $(OUTPUTDIR)\gui_wand_pim_take.ncs                 \
            $(OUTPUTDIR)\gui_wand_pim_unequip.ncs              \
            $(OUTPUTDIR)\gui_wand_turn_horizontal.ncs          \
            $(OUTPUTDIR)\gui_wand_turn_vertical.ncs            \
            $(OUTPUTDIR)\wand_init.ncs                         \
            $(OUTPUTDIR)\gui_chatselect.ncs                    \
            $(OUTPUTDIR)\gui_containerclose.ncs                \
            $(OUTPUTDIR)\i_tkl_performer_score_ac.ncs          \
            $(OUTPUTDIR)\dmfi_usd_portal.ncs                   \
            $(OUTPUTDIR)\i_dmfi_exe_tool_ac.ncs                \
            $(OUTPUTDIR)\i_acr_dcsetter_ac.ncs                 \
            $(OUTPUTDIR)\i_acr_dmexamine_ac.ncs                \
            $(OUTPUTDIR)\i_abr_it_dm_damagewand_ac.ncs         \
            $(OUTPUTDIR)\i_abr_it_dmprcvalidate_ac.ncs         \
            $(OUTPUTDIR)\i_abr_spawntoggle_ac.ncs              \
            $(OUTPUTDIR)\i_omega_wand_ac.ncs                   \
            $(OUTPUTDIR)\omega_at.ncs                          \
            $(OUTPUTDIR)\omega_cast.ncs                        \
            $(OUTPUTDIR)\omega_deity.ncs                       \
            $(OUTPUTDIR)\omega_dmg.ncs                         \
            $(OUTPUTDIR)\omega_dmprcvalidate.ncs               \
            $(OUTPUTDIR)\omega_dmquarantine.ncs                \
            $(OUTPUTDIR)\omega_faction.ncs                     \
            $(OUTPUTDIR)\omega_interact.ncs                    \
            $(OUTPUTDIR)\omega_locate.ncs                      \
            $(OUTPUTDIR)\omega_lock_unlock.ncs                 \
            $(OUTPUTDIR)\omega_lockable.ncs                    \
            $(OUTPUTDIR)\omega_plc_onused.ncs                  \
            $(OUTPUTDIR)\omega_remove_effects.ncs              \
            $(OUTPUTDIR)\omega_settrapdet.ncs                  \
            $(OUTPUTDIR)\omega_settrapdis.ncs                  \
            $(OUTPUTDIR)\omega_setunlock.ncs                   \
            $(OUTPUTDIR)\omega_spawntoggle.ncs                 \
            $(OUTPUTDIR)\omega_stealth.ncs                     \
            $(OUTPUTDIR)\omega_trap.ncs                        \
            $(OUTPUTDIR)\omega_trapcheck.ncs                   \
            $(OUTPUTDIR)\omega_trapspring.ncs                  \
            $(OUTPUTDIR)\omega_vehicle.ncs                     \
            $(OUTPUTDIR)\acr_area_instance_onleave.ncs         \
            $(OUTPUTDIR)\gui_powexp.ncs                        \
            $(OUTPUTDIR)\gui_measure_latency.ncs               \
            $(OUTPUTDIR)\acr_version_check.ncs                 \
            $(OUTPUTDIR)\acr_portal_exe.ncs                    \
            $(OUTPUTDIR)\acr_portal_cnd.ncs                    \
            $(OUTPUTDIR)\abr_trg_swimonenter.ncs               \
            $(OUTPUTDIR)\abr_trg_swimonexit.ncs                \
            $(OUTPUTDIR)\gui_playerreport.ncs                  \
            $(OUTPUTDIR)\kemo_move.ncs                         \
            $(OUTPUTDIR)\nw_s2_sngincomp.ncs                   \
            $(OUTPUTDIR)\nw_s2_sngincour.ncs                   \
            $(OUTPUTDIR)\nw_s2_sngindefn.ncs                   \
            $(OUTPUTDIR)\nw_s2_snginjrng.ncs                   \
            $(OUTPUTDIR)\nw_s2_snginlegn.ncs                   \
            $(OUTPUTDIR)\nw_s2_snginregn.ncs                   \
            $(OUTPUTDIR)\nw_s2_snginslow.ncs                   \
            $(OUTPUTDIR)\nw_s2_sngintufn.ncs                   \
            $(OUTPUTDIR)\gb_player_heart.ncs                   \
            $(OUTPUTDIR)\nx2_s0_summonbaatezu.ncs              \
            $(OUTPUTDIR)\as_group_loot.ncs                     \
            $(OUTPUTDIR)\as_group_loot_beetle.ncs              \
            $(OUTPUTDIR)\as_group_loot_chest.ncs               \
            $(OUTPUTDIR)\as_group_loot_death.ncs               \
            $(OUTPUTDIR)\as_group_loot_furnishing.ncs          \
            $(OUTPUTDIR)\as_group_loot_nature.ncs              \
            $(OUTPUTDIR)\gui_notifylist.ncs                    \
            $(OUTPUTDIR)\d_appearance_action.ncs               \
            $(OUTPUTDIR)\acr_ipc_logmsg.ncs                    \
            $(OUTPUTDIR)\acr_checkpersistentint.ncs            \
            $(OUTPUTDIR)\acr_subdual.ncs                       \
            $(OUTPUTDIR)\acr_cs_classkill.ncs                  \
            $(OUTPUTDIR)\acr_cs_regionchk.ncs                  \
            $(OUTPUTDIR)\acr_cs_regions.ncs                    \
            $(OUTPUTDIR)\acr_cs_skillpoints.ncs                \
            $(OUTPUTDIR)\acr_cs_skillptchk.ncs                 \
            $(OUTPUTDIR)\acr_addpersistentint.ncs              \
            $(OUTPUTDIR)\acr_check_language.ncs                \
            $(OUTPUTDIR)\acr_cs_doorcheck.ncs                  \
            $(OUTPUTDIR)\acr_cs_settrapdet.ncs                 \
            $(OUTPUTDIR)\acr_cs_settrapdis.ncs                 \
            $(OUTPUTDIR)\acr_cs_setunlock.ncs                  \
            $(OUTPUTDIR)\acr_cs_trapcheck.ncs                  \
            $(OUTPUTDIR)\acr_setpersistentint.ncs              \
            $(OUTPUTDIR)\acr_writepersistentint.ncs            \
            $(OUTPUTDIR)\acr_check_same_race.ncs               \
            $(OUTPUTDIR)\abr_spawn_debug.ncs                   \
            $(OUTPUTDIR)\abr_plc_onclosereturns.ncs            \
            $(OUTPUTDIR)\abr_storeopen2.ncs                    \
            $(OUTPUTDIR)\abr_onuse_rezlever.ncs                \
            $(OUTPUTDIR)\i_abr_dmquarantine_ac.ncs             \
            $(OUTPUTDIR)\i_abr_it_gr_oil_ac.ncs                \
            $(OUTPUTDIR)\i_abr_it_msc_bagpipes_ac.ncs          \
            $(OUTPUTDIR)\acr_restartcombatmode.ncs             \
            $(OUTPUTDIR)\i_abr_it_gr_rope_climb_ac.ncs         \
            $(OUTPUTDIR)\acr_touchattack.ncs                   \
            $(OUTPUTDIR)\x2_s0_grmagweap.ncs                   \
            $(OUTPUTDIR)\x2_s0_magcweap.ncs                    \
            $(OUTPUTDIR)\nw_s2_turndead.ncs                    \
            $(OUTPUTDIR)\x0_s0_masscamo.ncs                    \
            $(OUTPUTDIR)\ga_faction_join.ncs                   \
            $(OUTPUTDIR)\gc_check_language.ncs                 \
            $(OUTPUTDIR)\gc_check_race_id.ncs                  \
            $(OUTPUTDIR)\gc_check_subrace_id.ncs               \
            $(OUTPUTDIR)\ga_give_partial_quest_xp.ncs          \
            $(OUTPUTDIR)\ga_give_quest_xp.ncs                  \
            $(OUTPUTDIR)\ga_give_xp.ncs                        \
            $(OUTPUTDIR)\ga_open_store.ncs                     \
            $(OUTPUTDIR)\x1_openstore.ncs                      \
            $(OUTPUTDIR)\gui_msgboard.ncs                      \
            $(OUTPUTDIR)\gui_startboard.ncs                    \
            $(OUTPUTDIR)\gui_bhvr_update.ncs                   \
            $(OUTPUTDIR)\gui_bhvr_hench_change.ncs             \
            $(OUTPUTDIR)\nw_s0_darkvis.ncs                     \
            $(OUTPUTDIR)\nw_s0_holyaura.ncs                    \
            $(OUTPUTDIR)\nw_s0_unhaura.ncs                     \
            $(OUTPUTDIR)\x2_s0_holyswrd.ncs                    \
            $(OUTPUTDIR)\nw_s0_circgood.ncs                    \
            $(OUTPUTDIR)\nw_s0_circgooda.ncs                   \
            $(OUTPUTDIR)\nw_s0_circgoodb.ncs                   \
            $(OUTPUTDIR)\nw_s0_circevil.ncs                    \
            $(OUTPUTDIR)\nw_s0_circevila.ncs                   \
            $(OUTPUTDIR)\nw_s0_circevilb.ncs                   \
            $(OUTPUTDIR)\nw_s0_circlaw.ncs                     \
            $(OUTPUTDIR)\nw_s0_circlawa.ncs                    \
            $(OUTPUTDIR)\nw_s0_circlawb.ncs                    \
            $(OUTPUTDIR)\nw_s0_circchaos.ncs                   \
            $(OUTPUTDIR)\nw_s0_circchaoa.ncs                   \
            $(OUTPUTDIR)\nw_s0_circchaob.ncs                   \
            $(OUTPUTDIR)\nw_s0_previl.ncs                      \
            $(OUTPUTDIR)\nw_s0_prgood.ncs                      \
            $(OUTPUTDIR)\nw_s0_prlaw.ncs                       \
            $(OUTPUTDIR)\nw_s0_prchaos.ncs                     \
            $(OUTPUTDIR)\x2_s0_blssweap.ncs                    \
            $(OUTPUTDIR)\nw_s0_crgrund.ncs                     \
            $(OUTPUTDIR)\nw_s0_crundead.ncs                    \
            $(OUTPUTDIR)\nw_s0_grplanar.ncs                    \
            $(OUTPUTDIR)\nw_s0_lsplanar.ncs                    \
            $(OUTPUTDIR)\nw_s0_planar.ncs                      \
            $(OUTPUTDIR)\nw_s0_hammgods.ncs                    \
            $(OUTPUTDIR)\nw_s0_summon.ncs                      \
            $(OUTPUTDIR)\acr_s2_deathtouch.ncs                 \
            $(OUTPUTDIR)\acr_s2_baldom.ncs                     \
            $(OUTPUTDIR)\acr_s2_charmdom.ncs                   \
            $(OUTPUTDIR)\acr_s0_longstride.ncs                 \
            $(OUTPUTDIR)\acr_s0_mount.ncs                      \
            $(OUTPUTDIR)\acr_s0_analyzeportal.ncs              \
            $(OUTPUTDIR)\acr_resync_gui.ncs                    \
            $(OUTPUTDIR)\gui_choosercreator.ncs                \
            $(OUTPUTDIR)\gui_creatorspawn.ncs                  \
            $(OUTPUTDIR)\acr_quest_collection.ncs              \
            $(OUTPUTDIR)\acr_quest_errand.ncs                  \
            $(OUTPUTDIR)\acr_traponenter.ncs                   \
            $(OUTPUTDIR)\acr_traponexit.ncs                    \
            $(OUTPUTDIR)\acr_trapdtctenter.ncs                 \
            $(OUTPUTDIR)\acr_trapdtctexit.ncs                  \
            $(OUTPUTDIR)\acr_trapdisarm.ncs                    \
            $(OUTPUTDIR)\nw_s1_barbrage.ncs                    \
            $(OUTPUTDIR)\nw_s1_frenzy.ncs                      \
            $(OUTPUTDIR)\nw_s0_findtrap.ncs                    \
            $(OUTPUTDIR)\gui_chooserjump.ncs                   \
            $(OUTPUTDIR)\nw_s0_spmantle.ncs                    \
            $(OUTPUTDIR)\nw_s0_lstspmant.ncs                   \
            $(OUTPUTDIR)\nw_s0_lsspmant.ncs                    \
            $(OUTPUTDIR)\nw_s0_grspmant.ncs                    \
            $(OUTPUTDIR)\gui_lootgen.ncs                       \
            $(OUTPUTDIR)\nw_s0_lowltvisn.ncs                   \
            $(OUTPUTDIR)\x0_s1_petrgaze.ncs                    \
            $(OUTPUTDIR)\nw_s0_silence.ncs                     \
            $(OUTPUTDIR)\acr_server_ping_request.ncs           \
            $(OUTPUTDIR)\acr_server_ping_response.ncs          \
            $(OUTPUTDIR)\acr_feat_ride.ncs                     \
            $(OUTPUTDIR)\acr_feat_warhorse.ncs                 \
            $(OUTPUTDIR)\acr_cre_onhorseconversation.ncs       \
            $(OUTPUTDIR)\acr_cre_onhorsedeath.ncs              \
            $(OUTPUTDIR)\acr_defense_onenter.ncs               \
            $(OUTPUTDIR)\as_group_infest.ncs                   \
            $(OUTPUTDIR)\gui_infestation.ncs                   \
            $(OUTPUTDIR)\gui_infestpick.ncs                    \
            $(OUTPUTDIR)\nw_s0_identify.ncs                    \
            $(OUTPUTDIR)\nw_s0_greasea.ncs                     \
            $(OUTPUTDIR)\acr_rnddungtrans.ncs                  \
            $(OUTPUTDIR)\nw_s1_gazechaos.ncs                   \
            $(OUTPUTDIR)\nw_s1_gazecharm.ncs                   \
            $(OUTPUTDIR)\nw_s1_gazeconfu.ncs                   \
            $(OUTPUTDIR)\nw_s1_gazedaze.ncs                    \
            $(OUTPUTDIR)\nw_s1_gazedeath.ncs                   \
            $(OUTPUTDIR)\nw_s1_gazedomn.ncs                    \
            $(OUTPUTDIR)\nw_s1_gazedoom.ncs                    \
            $(OUTPUTDIR)\nw_s1_gazeevil.ncs                    \
            $(OUTPUTDIR)\nw_s1_gazefear.ncs                    \
            $(OUTPUTDIR)\nw_s1_gazegood.ncs                    \
            $(OUTPUTDIR)\nw_s1_gazelaw.ncs                     \
            $(OUTPUTDIR)\nw_s1_gazeparal.ncs                   \
            $(OUTPUTDIR)\nw_s1_gazestun.ncs                    \
            $(OUTPUTDIR)\nw_s2_snghaven.ncs                    \
            $(OUTPUTDIR)\acr_set_player_password.ncs           \
            $(OUTPUTDIR)\nw_s1_mephit_caustic_breath.ncs       \
            $(OUTPUTDIR)\nw_s1_mephit_dust_breath.ncs          \
            $(OUTPUTDIR)\nw_s1_mephit_grit_breath.ncs          \
            $(OUTPUTDIR)\nw_s1_mephit_magma_breath.ncs         \
            $(OUTPUTDIR)\c_nwndragon_hb_vfx.ncs                \
            $(OUTPUTDIR)\c_nwndragon_vfx.ncs                   \
            $(OUTPUTDIR)\gui_chatbub_vfx.ncs                   \
            $(OUTPUTDIR)\i_smoker_ac.ncs                       \
            $(OUTPUTDIR)\gui_shinn_sava_main.ncs               \
            $(OUTPUTDIR)\shinn_sava_hub.ncs                    \
            $(OUTPUTDIR)\shinn_sava_start.ncs                  \
            $(OUTPUTDIR)\gui_ps_parchment_rename.ncs           \
            $(OUTPUTDIR)\gui_ps_parchment_write.ncs            \
            $(OUTPUTDIR)\i_ps_parchment_ac.ncs                 \
            $(OUTPUTDIR)\ps_parchment_read.ncs                 \
            $(OUTPUTDIR)\ps_parchment_readaloud.ncs            \
            $(OUTPUTDIR)\ps_parchment_write.ncs                 

#
# Note, CLR scripts must be listed once here and once in makeclrscripts and
# for both bin and obj subdirectories in clean.
#

CLRSCRIPT_OBJECTS=$(OUTPUTDIR)\TestClrScript.ncs               \
                  $(OUTPUTDIR)\ScriptLoader.ncs                \
                  $(OUTPUTDIR)\LatencyMonitor.ncs              \
                  $(OUTPUTDIR)\ACR_HealthMonitor.ncs           \
                  $(OUTPUTDIR)\ACR_ServerCommunicator.ncs      \
                  $(OUTPUTDIR)\ACR_Time.ncs                    \
                  $(OUTPUTDIR)\ACR_ServerMisc.ncs              \
                  $(OUTPUTDIR)\ACR_CreatureBehavior.ncs        \
                  $(OUTPUTDIR)\ACR_EmptyScript.ncs             \
                  $(OUTPUTDIR)\ACR_Wealth.ncs                  \
                  $(OUTPUTDIR)\ACR_Items.ncs                   \
                  $(OUTPUTDIR)\ACR_PCHide.ncs                  \
                  $(OUTPUTDIR)\ACR_ReadRawString.ncs           \
                  $(OUTPUTDIR)\ACR_Candlekeep.ncs              \
                  $(OUTPUTDIR)\ACR_CollectionLib.ncs           \
                  $(OUTPUTDIR)\ACR_ChooserCreator.ncs          \
                  $(OUTPUTDIR)\ACR_Traps.ncs                   \
                  $(OUTPUTDIR)\ACR_AssemblyLoader.ncs          \
                  $(OUTPUTDIR)\ACR_Movement.ncs                \
                  $(OUTPUTDIR)\ACR_Quest.ncs                   \
                  $(OUTPUTDIR)\ACR_DatabaseConnector.ncs       

HAKFILE=$(OUTPUTDIR)\alfa2_acr.hak

NSS_OBJECTS_NL=$(NSS_OBJECTS:.ncs=.ncs^
)
NSS_INCLNSS_NL=$(NSS_INCLNSS:.nss=.nss^
)

CLRSCRIPT_OBJECTS_NL=$(CLRSCRIPT_OBJECTS:.ncs=.ncs^
)

#
# Note, first line has .\ omitted so that it doesn't have a newline put on the
# front.  This is because the script macros always have newlines at the end.
#

HAK_SOURCES_MISC=                                              \
            *.TXT                                              \
            .\*.DLG                                            \
            .\*.TGA                                            \
            .\*.GFF                                            

HAK_SOURCES_MISC_NL=$(HAK_SOURCES_MISC:.\=^
)

HAK_SOURCES=$(NSS_OBJECTS_NL) $(NSS_OBJECTS_NL:.ncs=.nss) $(NSS_OBJECTS_NL:.ncs=.ndb) $(CLRSCRIPT_OBJECTS_NL) $(NSS_INCLNSS_NL) $(HAK_SOURCES_MISC_NL)

HAK_SOURCES_NL=$(HAK_SOURCES: =)

all: scriptincludes makeclrscripts $(NSS_OBJECTS) $(HAKFILE)

script: scriptincludes $(NSS_OBJECTS)
	@copy /y *.nss $(OUTPUTDIR)\ >NUL

scriptincludes:
	@copy /y *.nss $(OUTPUTDIR)\ >NUL

makeclrscripts:
	$(BUILD_MSG) (CSProj) Building - ALFA.Shared
	@$(MSBUILD) ALFA.Shared\ALFA.Shared.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - TestClrScript
	@$(MSBUILD) TestClrScript\TestClrScript.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ScriptLoader
	@$(MSBUILD) ScriptLoader\ScriptLoader.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - LatencyMonitor
	@$(MSBUILD) LatencyMonitor\LatencyMonitor.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_HealthMonitor
	@$(MSBUILD) ACR_HealthMonitor\ACR_HealthMonitor.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_ServerCommunicator
	@$(MSBUILD) ACR_ServerCommunicator\ACR_ServerCommunicator.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Time
	@$(MSBUILD) ACR_Time\ACR_Time.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_ServerMisc
	@$(MSBUILD) ACR_ServerMisc\ACR_ServerMisc.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_CreatureBehavior
	@$(MSBUILD) ACR_CreatureBehavior\ACR_CreatureBehavior.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_EmptyScript
	@$(MSBUILD) ACR_EmptyScript\ACR_EmptyScript.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Wealth
	@$(MSBUILD) ACR_Wealth\ACR_Wealth.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Items
	@$(MSBUILD) ACR_Items\ACR_Items.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_ReadRawString
	@$(MSBUILD) ACR_ReadRawString\ACR_ReadRawString.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Candlekeep
	@$(MSBUILD) ACR_Candlekeep\ACR_Candlekeep.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_ChooserCreator
	@$(MSBUILD) ACR_ChooserCreator\ACR_ChooserCreator.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Traps
	@$(MSBUILD) ACR_Traps\ACR_Traps.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_CollectionLib
	@$(MSBUILD) ACR_CollectionLib\ACR_CollectionLib.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_PCHide
	@$(MSBUILD) ACR_PCHide\ACR_PCHide.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_AssemblyLoader
	@$(MSBUILD) ACR_AssemblyLoader\ACR_AssemblyLoader.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Movement
	@$(MSBUILD) ACR_Movement\ACR_Movement.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_Quest
	@$(MSBUILD) ACR_Quest\ACR_Quest.csproj $(MSBUILD_FLAGS)
	$(BUILD_MSG) (CSProj) Building - ACR_DatabaseConnector
	@$(MSBUILD) ACR_DatabaseConnector\ACR_DatabaseConnector.csproj $(MSBUILD_FLAGS)

clean:
	@if exist $(OUTPUTDIR)\*.ncs del $(OUTPUTDIR)\*.ncs
	@if exist $(OUTPUTDIR)\*.nss del $(OUTPUTDIR)\*.nss
	@if exist $(OUTPUTDIR)\*.ndb del $(OUTPUTDIR)\*.ndb
	@if exist $(HAKFILE) del /q $(HAKFILE) >NUL
	@if exist $(OUTPUTDIR)\CLRBUILDLOG del $(OUTPUTDIR)\CLRBUILDLOG
	@if exist ALFA.Shared\bin rd /s /q ALFA.Shared\bin
	@if exist ALFA.Shared\obj rd /s /q ALFA.Shared\obj
	@if exist TestClrScript\bin rd /s /q TestClrScript\bin
	@if exist TestClrScript\obj rd /s /q TestClrScript\obj
	@if exist ScriptLoader\bin rd /s /q ScriptLoader\bin
	@if exist ScriptLoader\obj rd /s /q ScriptLoader\obj
	@if exist LatencyMonitor\bin rd /s /q LatencyMonitor\bin
	@if exist LatencyMonitor\obj rd /s /q LatencyMonitor\obj
	@if exist ACR_HealthMonitor\bin rd /s /q ACR_HealthMonitor\bin
	@if exist ACR_HealthMonitor\obj rd /s /q ACR_HealthMonitor\obj
	@if exist ACR_ServerCommunicator\bin rd /s /q ACR_ServerCommunicator\bin
	@if exist ACR_ServerCommunicator\obj rd /s /q ACR_ServerCommunicator\obj
	@if exist ACR_Time\bin rd /s /q ACR_Time\bin
	@if exist ACR_Time\obj rd /s /q ACR_Time\obj
	@if exist ACR_ServerMisc\bin rd /s /q ACR_ServerMisc\bin
	@if exist ACR_ServerMisc\obj rd /s /q ACR_ServerMisc\obj
	@if exist ACR_CreatureBehavior\bin rd /s /q ACR_CreatureBehavior\bin
	@if exist ACR_CreatureBehavior\obj rd /s /q ACR_CreatureBehavior\obj
	@if exist ACR_EmptyScript\bin rd /s /q ACR_EmptyScript\bin
	@if exist ACR_EmptyScript\obj rd /s /q ACR_EmptyScript\obj
	@if exist ACR_Wealth\bin rd /s /q ACR_Wealth\bin
	@if exist ACR_Wealth\obj rd /s /q ACR_Wealth\obj
	@if exist ACR_Items\bin rd /s /q ACR_Items\bin
	@if exist ACR_Items\obj rd /s /q ACR_Items\obj	
	@if exist ACR_Candlekeep\bin rd /s /q ACR_Candlekeep\bin
	@if exist ACR_Candlekeep\obj rd /s /q ACR_Candlekeep\obj
	@if exist ACR_ChooserCreator\bin rd /s /q ACR_ChooserCreator\bin
	@if exist ACR_ChooserCreator\obj rd /s /q ACR_ChooserCreator\obj
	@if exist ACR_Traps\bin rd /s /q ACR_Traps\bin
	@if exist ACR_Traps\obj rd /s /q ACR_Traps\obj
	@if exist ACR_CollectionLib\bin rd /s /q ACR_CollectionLib\bin
	@if exist ACR_CollectionLib\obj rd /s /q ACR_CollectionLib\obj
	@if exist ACR_PCHide\bin rd /s /q ACR_PCHide\bin
	@if exist ACR_PCHide\obj rd /s /q ACR_PCHide\obj
	@if exist ACR_AssemblyLoader\bin rd /s /q ACR_AssemblyLoader\bin
	@if exist ACR_AssemblyLoader\obj rd /s /q ACR_AssemblyLoader\obj
	@if exist ACR_Movement\bin rd /s /q ACR_Movement\bin
	@if exist ACR_Movement\obj rd /s /q ACR_Movement\obj
	@if exist ACR_Quest\bin rd /s /q ACR_Quest\bin
	@if exist ACR_Quest\obj rd /s /q ACR_Quest\obj
	@if exist ACR_DatabaseConnector\bin rd /s /q ACR_DatabaseConnector\bin
	@if exist ACR_DatabaseConnector\obj rd /s /q ACR_DatabaseConnector\obj

$(HAKFILE): script $(HAK_SOURCES_MISC)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) @<<$(ERFUTIL_RSP)
-z
$(HAK_SOURCES_NL)
<<NOKEEP

!if 0
$(HAKFILE): $(HAK_SOURCES)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) -z $(HAK_SOURCES)
!endif

