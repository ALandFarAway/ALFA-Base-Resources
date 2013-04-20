#
# This project constructs the ALFA buildmod.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

NSS_FLAVOR=NWN2

NSS_INCLNSS=                                                    \
    $(OUTPUTDIR)\buildmod\acf_settings_i.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_spawn_i.ncs

NSS_OBJECTS=                                                    \
    $(OUTPUTDIR)\buildmod\acf_area_client.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_area_onenter.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_area_onexit.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_area_onexit2.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_area_onhbeat.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_area_userdef.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_cre_flocking.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_cre_onblocked.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_cre_onconversation.ncs            \
    $(OUTPUTDIR)\buildmod\acf_cre_ondamaged.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_cre_ondeath.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_cre_onendcombatround.ncs          \
    $(OUTPUTDIR)\buildmod\acf_cre_onheartbeat.ncs               \
    $(OUTPUTDIR)\buildmod\acf_cre_oninventorydisturbed.ncs      \
    $(OUTPUTDIR)\buildmod\acf_cre_onperception.ncs              \
    $(OUTPUTDIR)\buildmod\acf_cre_onphysicallyattacked.ncs      \
    $(OUTPUTDIR)\buildmod\acf_cre_onrested.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_cre_onspawnin.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_cre_onspellcastat.ncs             \
    $(OUTPUTDIR)\buildmod\acf_cre_onuserdefined.ncs             \
    $(OUTPUTDIR)\buildmod\acf_door_attack.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_castat.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_damaged.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_door_death.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_door_examine.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_door_hbeat.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_door_onclick.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_door_onclose.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_door_onclosed.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_door_onconversation.ncs           \
    $(OUTPUTDIR)\buildmod\acf_door_ondamaged.ncs                \
    $(OUTPUTDIR)\buildmod\acf_door_ondeath.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_door_ondisarm.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_door_onfail.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_onfailtoopen.ncs             \
    $(OUTPUTDIR)\buildmod\acf_door_onheartbeat.ncs              \
    $(OUTPUTDIR)\buildmod\acf_door_onlock.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_onmeleeattacked.ncs          \
    $(OUTPUTDIR)\buildmod\acf_door_onopen.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_onspellcastat.ncs            \
    $(OUTPUTDIR)\buildmod\acf_door_ontraptriggered .ncs         \
    $(OUTPUTDIR)\buildmod\acf_door_ontraptriggered.ncs          \
    $(OUTPUTDIR)\buildmod\acf_door_onunlock.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_door_onused.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_onuserdefined.ncs            \
    $(OUTPUTDIR)\buildmod\acf_door_unlock.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_door_userdef.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_mod_onacquireitem.ncs             \
    $(OUTPUTDIR)\buildmod\acf_mod_onactivateitem.ncs            \
    $(OUTPUTDIR)\buildmod\acf_mod_onchat.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_mod_oncliententer.ncs             \
    $(OUTPUTDIR)\buildmod\acf_mod_onclientleave.ncs             \
    $(OUTPUTDIR)\buildmod\acf_mod_oncutsceneabort.ncs           \
    $(OUTPUTDIR)\buildmod\acf_mod_onheartbeat.ncs               \
    $(OUTPUTDIR)\buildmod\acf_mod_onmoduleload.ncs              \
    $(OUTPUTDIR)\buildmod\acf_mod_onmodulestart.ncs             \
    $(OUTPUTDIR)\buildmod\acf_mod_onpcloaded.ncs                \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerdeath.ncs             \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerdying.ncs             \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerequipitem.ncs         \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerlevelup.ncs           \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerrespawn.ncs           \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerrest.ncs              \
    $(OUTPUTDIR)\buildmod\acf_mod_onplayerunequipitem.ncs       \
    $(OUTPUTDIR)\buildmod\acf_mod_onunacquireitem.ncs           \
    $(OUTPUTDIR)\buildmod\acf_mod_onuserdefinedevent.ncs        \
    $(OUTPUTDIR)\buildmod\acf_plc_onclick.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_plc_onclosed.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_plc_onconversation.ncs            \
    $(OUTPUTDIR)\buildmod\acf_plc_ondamaged.ncs                 \
    $(OUTPUTDIR)\buildmod\acf_plc_ondeath.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_plc_ondisarm.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_plc_onheartbeat.ncs               \
    $(OUTPUTDIR)\buildmod\acf_plc_oninventorydisturbed.ncs      \
    $(OUTPUTDIR)\buildmod\acf_plc_onlock.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_plc_onmeleeattacked.ncs           \
    $(OUTPUTDIR)\buildmod\acf_plc_onopen.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_plc_onspellcastat.ncs             \
    $(OUTPUTDIR)\buildmod\acf_plc_ontraptriggered.ncs           \
    $(OUTPUTDIR)\buildmod\acf_plc_onunlock.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_plc_onused.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_plc_onuserdefined.ncs             \
    $(OUTPUTDIR)\buildmod\acf_trg_onclick.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_trg_ondisarm.ncs                  \
    $(OUTPUTDIR)\buildmod\acf_trg_onenter.ncs                   \
    $(OUTPUTDIR)\buildmod\acf_trg_onexit.ncs                    \
    $(OUTPUTDIR)\buildmod\acf_trg_onheartbeat.ncs               \
    $(OUTPUTDIR)\buildmod\acf_trg_ontraptriggered.ncs           \
    $(OUTPUTDIR)\buildmod\acf_trg_onuserdefined.ncs

all:
	scriptincludes
	@copy /y *.* $(OUTPUTDIR)\buildmod\ >NUL

clean:
	@if exist $(OUTPUTDIR)\buildmod\*.* del $(OUTPUTDIR)\buildmod\*.*