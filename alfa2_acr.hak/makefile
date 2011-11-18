#
# This project constructs alfa2_acr.hak.  It compiles all script sources that
# are a part of the hak and then packages them up into an ERF.
#

NSS_INCLUDES=$(NSS_INCLUDES);$(PROJECT_SOURCE_ROOT)\NWNX4\inc
NSS_FLAVOR=NWN2

#.IGNORE :

!include $(PROJECT_SOURCE_ROOT)\makefile.def

NSS_INCLNSS=                                                   \
            $(OUTPUTDIR)\acr_1984_i.nss                        \
            $(OUTPUTDIR)\acr_area_i.nss                        \
            $(OUTPUTDIR)\acr_array_i.nss                       \
            $(OUTPUTDIR)\acr_list_i.nss                        \
            $(OUTPUTDIR)\acr_chat_i.nss                        \
            $(OUTPUTDIR)\acr_creature_i.nss                    \
            $(OUTPUTDIR)\acr_db_persist_i.nss                  \
            $(OUTPUTDIR)\acr_death_i.nss                       \
            $(OUTPUTDIR)\acr_debug_i.nss                       \
            $(OUTPUTDIR)\acr_door_i.nss                        \
            $(OUTPUTDIR)\acr_effects_i.nss                     \
            $(OUTPUTDIR)\acr_events_i.nss                      \
            $(OUTPUTDIR)\acr_feat_events_i.nss                 \
            $(OUTPUTDIR)\acr_feat_i.nss                        \
            $(OUTPUTDIR)\acr_game_loc_i.nss                    \
            $(OUTPUTDIR)\acr_i.nss                             \
            $(OUTPUTDIR)\acr_items_i.nss                       \
            $(OUTPUTDIR)\acr_it_persist_i.nss                  \
            $(OUTPUTDIR)\acr_language_i.nss                    \
            $(OUTPUTDIR)\acr_mod_events_i.nss                  \
            $(OUTPUTDIR)\acr_nonlethal_i.nss                   \
            $(OUTPUTDIR)\acr_physical_object_i.nss             \
            $(OUTPUTDIR)\acr_placeable_i.nss                   \
            $(OUTPUTDIR)\acr_portal_i.nss                      \
            $(OUTPUTDIR)\acr_pps_i.nss                         \
            $(OUTPUTDIR)\acr_prc_bladesinger_i.nss             \
            $(OUTPUTDIR)\acr_quest_i.nss                       \
            $(OUTPUTDIR)\acr_queue_i.nss                       \
            $(OUTPUTDIR)\acr_resting_i.nss                     \
            $(OUTPUTDIR)\acr_scry_i.nss                        \
            $(OUTPUTDIR)\acr_seamlessat_i.nss                  \
            $(OUTPUTDIR)\acr_settings_i.nss                    \
            $(OUTPUTDIR)\acr_skills_i.nss                      \
            $(OUTPUTDIR)\acr_spawn_i.nss                       \
            $(OUTPUTDIR)\acr_spells_i.nss                      \
            $(OUTPUTDIR)\acr_spelltrack_i.nss                  \
            $(OUTPUTDIR)\acr_time_i.nss                        \
            $(OUTPUTDIR)\acr_tools_i.nss                       \
            $(OUTPUTDIR)\acr_tradescroll_i.nss                 \
            $(OUTPUTDIR)\acr_trigger_i.nss                     \
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
            $(OUTPUTDIR)\nwnx_clock.nss                        \
            $(OUTPUTDIR)\nwnx_include.nss                      \
            $(OUTPUTDIR)\nwnx_sql.nss                          \
            $(OUTPUTDIR)\nwnx_time.nss                         \
            $(OUTPUTDIR)\nw_i0_invocatns.nss                   \
            $(OUTPUTDIR)\acr_mobloot_i.nss                     \
            $(OUTPUTDIR)\acr_vanity_i.nss                         

NSS_OBJECTS=                                                   \
            $(OUTPUTDIR)\abr_plc_oninventorydisreturns.ncs     \
            $(OUTPUTDIR)\abr_plc_onopenreturns.ncs             \
            $(OUTPUTDIR)\abr_storeclose.ncs                    \
            $(OUTPUTDIR)\abr_storeopen.ncs                     \
            $(OUTPUTDIR)\abr_trg_returnsonenter.ncs            \
            $(OUTPUTDIR)\abr_trg_returnsonexit.ncs             \
            $(OUTPUTDIR)\acr_cs_abcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_atcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_bootpc.ncs                     \
            $(OUTPUTDIR)\acr_cs_gpcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_guard_duty.ncs                 \
            $(OUTPUTDIR)\acr_cs_guard_in.ncs                   \
            $(OUTPUTDIR)\acr_cs_guard_out.ncs                  \
            $(OUTPUTDIR)\acr_cs_has_item.ncs                   \
            $(OUTPUTDIR)\acr_cs_skcheck.ncs                    \
            $(OUTPUTDIR)\acr_cs_svcheck.ncs                    \
            $(OUTPUTDIR)\acr_feat_bladesong.ncs                \
            $(OUTPUTDIR)\acr_feat_bladesong_hb.ncs             \
            $(OUTPUTDIR)\acr_feat_spellsong.ncs                \
            $(OUTPUTDIR)\acr_feat_spellsong_hb.ncs             \
            $(OUTPUTDIR)\acr_feat_songofcelerity.ncs           \
            $(OUTPUTDIR)\acr_feat_songoffury.ncs               \
            $(OUTPUTDIR)\acr_quest_progress.ncs                \
            $(OUTPUTDIR)\acr_quest_reward.ncs                  \
            $(OUTPUTDIR)\acr_quest_update.ncs                  \
            $(OUTPUTDIR)\acr_s0_acidarrow.ncs                  \
            $(OUTPUTDIR)\acr_s0_barkskin.ncs                   \
            $(OUTPUTDIR)\acr_s0_bless.ncs                      \
            $(OUTPUTDIR)\acr_s0_blur.ncs                       \
            $(OUTPUTDIR)\acr_s0_causefear.ncs                  \
            $(OUTPUTDIR)\acr_s0_charmper.ncs                   \
            $(OUTPUTDIR)\acr_s0_complang.ncs                   \
            $(OUTPUTDIR)\acr_s0_curminw.ncs                    \
            $(OUTPUTDIR)\acr_s0_daze.ncs                       \
            $(OUTPUTDIR)\acr_s0_dazemonster.ncs                \
            $(OUTPUTDIR)\acr_s0_detectmagic.ncs                \
            $(OUTPUTDIR)\acr_s0_dismagic.ncs                   \
            $(OUTPUTDIR)\acr_s0_disruptundead.ncs              \
            $(OUTPUTDIR)\acr_s0_exretreat.ncs                  \
            $(OUTPUTDIR)\acr_s0_fear.ncs                       \
            $(OUTPUTDIR)\acr_s0_haltundead.ncs                 \
            $(OUTPUTDIR)\acr_s0_haste.ncs                      \
            $(OUTPUTDIR)\acr_s0_lsdispel.ncs                   \
            $(OUTPUTDIR)\acr_s0_rayenfeeb.ncs                  \
            $(OUTPUTDIR)\acr_s0_rayexhaustion.ncs              \
            $(OUTPUTDIR)\acr_s0_rayfrost.ncs                   \
            $(OUTPUTDIR)\acr_s0_readmagic.ncs                  \
            $(OUTPUTDIR)\acr_s0_scare.ncs                      \
            $(OUTPUTDIR)\acr_s0_snillocsnowball.ncs            \
            $(OUTPUTDIR)\acr_s0_spiderclimb.ncs                \
            $(OUTPUTDIR)\acr_s0_web.ncs                        \
            $(OUTPUTDIR)\acr_s2_wildshape.ncs                  \
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
            $(OUTPUTDIR)\gui_kemo_resize.ncs                   \
            $(OUTPUTDIR)\gui_kemo_turnchair.ncs                \
            $(OUTPUTDIR)\i_abr_it_firstaid_ac.ncs              \
            $(OUTPUTDIR)\i_acr_subdual_ac.ncs                  \
            $(OUTPUTDIR)\i_kemoportablechair_ac.ncs            \
            $(OUTPUTDIR)\kemo_animation_hb.ncs                 \
            $(OUTPUTDIR)\kemo_chair.ncs                        \
            $(OUTPUTDIR)\nw_s0_curcrwn.ncs                     \
            $(OUTPUTDIR)\nw_s0_curlgtw.ncs                     \
            $(OUTPUTDIR)\nw_s0_curmodw.ncs                     \
            $(OUTPUTDIR)\nw_s0_curserw.ncs                     \
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
            $(OUTPUTDIR)\nw_s2_layonhand.ncs                   \
            $(OUTPUTDIR)\nw_s2_snginregn.ncs                   \
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
            $(OUTPUTDIR)\x2_s0_cureother.ncs                   \
            $(OUTPUTDIR)\gui_zspawn_open.ncs                   \
            $(OUTPUTDIR)\gui_zspawn_close.ncs                  \
            $(OUTPUTDIR)\gui_zspawn_new.ncs                    \
            $(OUTPUTDIR)\acr_zspawn_one.ncs                    \
            $(OUTPUTDIR)\acr_zspawn_2d4.ncs                    \
            $(OUTPUTDIR)\nw_s0_magearm.ncs                     \
            $(OUTPUTDIR)\gui_atsign.ncs                        \
            $(OUTPUTDIR)\gui_setlanguse.ncs                    \
            $(OUTPUTDIR)\x2_s3_onhitcast.ncs                   \
            $(OUTPUTDIR)\acr_s0_dimdoor.ncs                    \
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
            $(OUTPUTDIR)\nw_s0_itenplagea.ncs                  \
            $(OUTPUTDIR)\nw_s0_itenplageb.ncs                  \
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
            $(OUTPUTDIR)\x0_s0_shield.ncs                      \
            $(OUTPUTDIR)\acr_disguise.ncs                   



HAKFILE=$(OUTPUTDIR)\alfa2_acr.hak

NSS_OBJECTS_NL=$(NSS_OBJECTS:.ncs=.ncs^
)
NSS_INCLNSS_NL=$(NSS_INCLNSS:.nss=.nss^
)

#
# Note, first line has .\ omitted so that it doesn't have a newline put on the
# front.  This is because the script macros always have newlines at the end.
#

HAK_SOURCES_MISC=                                              \
            *.TXT                                              \
            .\*.UTI                                            \
            .\*.UTC                                            \
            .\*.DLG                                            \
            .\*.UTW                                            \
            .\*.TGA                                            

HAK_SOURCES_MISC_NL=$(HAK_SOURCES_MISC:.\=^
)

HAK_SOURCES=$(NSS_OBJECTS_NL) $(NSS_OBJECTS_NL:.ncs=.nss) $(NSS_OBJECTS_NL:.ncs=.ndb) $(NSS_INCLNSS_NL) $(HAK_SOURCES_MISC_NL)

HAK_SOURCES_NL=$(HAK_SOURCES: =)

all: scriptincludes $(NSS_OBJECTS) $(HAKFILE)

script: scriptincludes $(NSS_OBJECTS)
	@copy /y *.nss $(OUTPUTDIR)\ >NUL

scriptincludes:
	@copy /y *.nss $(OUTPUTDIR)\ >NUL

clean:
	@if exist $(OUTPUTDIR)\*.ncs del $(OUTPUTDIR)\*.ncs
	@if exist $(OUTPUTDIR)\*.nss del $(OUTPUTDIR)\*.nss
	@if exist $(OUTPUTDIR)\*.ndb del $(OUTPUTDIR)\*.ndb
	@if exist $(HAKFILE) del /q $(HAKFILE) >NUL

$(HAKFILE): script $(HAK_SOURCES_MISC)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) @<<$(ERFUTIL_RSP)
-z
$(HAK_SOURCES_NL)
<<KEEP

!if 0
$(HAKFILE): $(HAK_SOURCES)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) -z $(HAK_SOURCES)
!endif
