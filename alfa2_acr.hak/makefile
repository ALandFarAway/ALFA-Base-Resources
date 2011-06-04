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
            $(OUTPUTDIR)\acr_chat_i.nss                        \
            $(OUTPUTDIR)\acr_creature_i.nss                    \
            $(OUTPUTDIR)\acr_db_persist_i.nss                  \
            $(OUTPUTDIR)\acr_death_i.nss                       \
            $(OUTPUTDIR)\acr_debug_i.nss                       \
            $(OUTPUTDIR)\acr_door_i.nss                        \
            $(OUTPUTDIR)\acr_events_i.nss                      \
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
            $(OUTPUTDIR)\acr_quest_i.nss                       \
            $(OUTPUTDIR)\acr_queue_i.nss                       \
            $(OUTPUTDIR)\acr_resting_i.nss                     \
            $(OUTPUTDIR)\acr_scry_i.nss                        \
            $(OUTPUTDIR)\acr_seamlessat_i.nss                  \
            $(OUTPUTDIR)\acr_settings_i.nss                    \
            $(OUTPUTDIR)\acr_skills_i.nss                      \
            $(OUTPUTDIR)\acr_spawn_i.nss                       \
            $(OUTPUTDIR)\acr_spelltrack_i.nss                  \
            $(OUTPUTDIR)\acr_time_i.nss                        \
            $(OUTPUTDIR)\acr_tools_i.nss                       \
            $(OUTPUTDIR)\acr_tradescroll_i.nss                 \
            $(OUTPUTDIR)\acr_trigger_i.nss                     \
            $(OUTPUTDIR)\acr_vfx_i.nss                         \
            $(OUTPUTDIR)\acr_wealth_i.nss                      \
            $(OUTPUTDIR)\acr_xp_i.nss                          \

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
            $(OUTPUTDIR)\acr_trg_portalstart.ncs               \
            $(OUTPUTDIR)\i_abr_it_firstaid_ac.ncs              \
            $(OUTPUTDIR)\i_acr_subdual_ac.ncs                  \
            $(OUTPUTDIR)\nwn2_inc_spells.ncs                   \
            $(OUTPUTDIR)\nw_i0_spells.ncs                      \
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
            $(OUTPUTDIR)\x0_s3_acid.ncs                        \
            $(OUTPUTDIR)\x0_s3_alchem.ncs                      \
            $(OUTPUTDIR)\x0_s3_choke.ncs                       \
            $(OUTPUTDIR)\x0_s3_holy.ncs                        \
            $(OUTPUTDIR)\x0_s3_tangle.ncs                      \
            $(OUTPUTDIR)\x0_s3_thunder.ncs                     \
            $(OUTPUTDIR)\x2_s0_cureother.ncs                   \
            $(OUTPUTDIR)\x2_s3_onhitcast.ncs                   


HAKFILE=$(OUTPUTDIR)\alfa2_acr.hak

HAK_SOURCES=                                                   \
            $(NSS_OBJECTS)                                     \
            $(NSS_OBJECTS:.ncs=.nss)                           \
            $(NSS_OBJECTS:.ncs=.ndb)                           \
            $(NSS_INCLNSS)                                     


all: $(NSS_OBJECTS) $(HAKFILE)

script: $(NSS_OBJECTS) $(NSS_INCLNSS)
	copy /y *.nss $(OUTPUTDIR)\

clean:
	@if exist $(OUTPUTDIR)\*.ncs del $(OUTPUTDIR)\*.ncs
	@if exist $(OUTPUTDIR)\*.nss del $(OUTPUTDIR)\*.nss
	@if exist $(OUTPUTDIR)\*.ndb del $(OUTPUTDIR)\*.ndb
	@if exist $(HAKFILE) del /q $(HAKFILE) >NUL

$(HAKFILE): $(HAK_SOURCES)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) -z $(HAK_SOURCES)

