#
# This project constructs the ALFA buildmod.
#

NSS_INCLUDES=$(PROJECT_SOURCE_ROOT)\alfa2_acr.hak;$(NSS_INCLUDES);$(PROJECT_SOURCE_ROOT)\NWNX4\inc
NSS_FLAVOR=NWN2

OUTPUTSUBDIR=buildmod\\

!include $(PROJECT_SOURCE_ROOT)\makefile.def

NSS_INCLNSS=                                                   \
            $(OUTPUTDIR)\acf_settings_i.nss                    \
            $(OUTPUTDIR)\acf_spawn_i.nss

NSS_OBJECTS=                                                   \
            $(OUTPUTDIR)\acf_area_client.ncs                   \
            $(OUTPUTDIR)\acf_area_onenter.ncs                  \
            $(OUTPUTDIR)\acf_area_onexit.ncs                   \
            $(OUTPUTDIR)\acf_area_onexit2.ncs                  \
            $(OUTPUTDIR)\acf_area_onhbeat.ncs                  \
            $(OUTPUTDIR)\acf_area_userdef.ncs                  \
            $(OUTPUTDIR)\acf_cre_flocking.ncs                  \
            $(OUTPUTDIR)\acf_cre_onblocked.ncs                 \
            $(OUTPUTDIR)\acf_cre_onconversation.ncs            \
            $(OUTPUTDIR)\acf_cre_ondamaged.ncs                 \
            $(OUTPUTDIR)\acf_cre_ondeath.ncs                   \
            $(OUTPUTDIR)\acf_cre_onendcombatround.ncs          \
            $(OUTPUTDIR)\acf_cre_onheartbeat.ncs               \
            $(OUTPUTDIR)\acf_cre_oninventorydisturbed.ncs      \
            $(OUTPUTDIR)\acf_cre_onperception.ncs              \
            $(OUTPUTDIR)\acf_cre_onphysicallyattacked.ncs      \
            $(OUTPUTDIR)\acf_cre_onrested.ncs                  \
            $(OUTPUTDIR)\acf_cre_onspawnin.ncs                 \
            $(OUTPUTDIR)\acf_cre_onspellcastat.ncs             \
            $(OUTPUTDIR)\acf_cre_onuserdefined.ncs             \
            $(OUTPUTDIR)\acf_door_attack.ncs                   \
            $(OUTPUTDIR)\acf_door_castat.ncs                   \
            $(OUTPUTDIR)\acf_door_damaged.ncs                  \
            $(OUTPUTDIR)\acf_door_death.ncs                    \
            $(OUTPUTDIR)\acf_door_examine.ncs                  \
            $(OUTPUTDIR)\acf_door_hbeat.ncs                    \
            $(OUTPUTDIR)\acf_door_onclick.ncs                  \
            $(OUTPUTDIR)\acf_door_onclose.ncs                  \
            $(OUTPUTDIR)\acf_door_onclosed.ncs                 \
            $(OUTPUTDIR)\acf_door_onconversation.ncs           \
            $(OUTPUTDIR)\acf_door_ondamaged.ncs                \
            $(OUTPUTDIR)\acf_door_ondeath.ncs                  \
            $(OUTPUTDIR)\acf_door_ondisarm.ncs                 \
            $(OUTPUTDIR)\acf_door_onfail.ncs                   \
            $(OUTPUTDIR)\acf_door_onfailtoopen.ncs             \
            $(OUTPUTDIR)\acf_door_onheartbeat.ncs              \
            $(OUTPUTDIR)\acf_door_onlock.ncs                   \
            $(OUTPUTDIR)\acf_door_onmeleeattacked.ncs          \
            $(OUTPUTDIR)\acf_door_onopen.ncs                   \
            $(OUTPUTDIR)\acf_door_onspellcastat.ncs            \
            $(OUTPUTDIR)\acf_door_ontraptriggered.ncs          \
            $(OUTPUTDIR)\acf_door_onunlock.ncs                 \
            $(OUTPUTDIR)\acf_door_onused.ncs                   \
            $(OUTPUTDIR)\acf_door_onuserdefined.ncs            \
            $(OUTPUTDIR)\acf_door_unlock.ncs                   \
            $(OUTPUTDIR)\acf_door_userdef.ncs                  \
            $(OUTPUTDIR)\acf_mod_onacquireitem.ncs             \
            $(OUTPUTDIR)\acf_mod_onactivateitem.ncs            \
            $(OUTPUTDIR)\acf_mod_onchat.ncs                    \
            $(OUTPUTDIR)\acf_mod_oncliententer.ncs             \
            $(OUTPUTDIR)\acf_mod_onclientleave.ncs             \
            $(OUTPUTDIR)\acf_mod_oncutsceneabort.ncs           \
            $(OUTPUTDIR)\acf_mod_onheartbeat.ncs               \
            $(OUTPUTDIR)\acf_mod_onmoduleload.ncs              \
            $(OUTPUTDIR)\acf_mod_onmodulestart.ncs             \
            $(OUTPUTDIR)\acf_mod_onpcloaded.ncs                \
            $(OUTPUTDIR)\acf_mod_onplayerdeath.ncs             \
            $(OUTPUTDIR)\acf_mod_onplayerdying.ncs             \
            $(OUTPUTDIR)\acf_mod_onplayerequipitem.ncs         \
            $(OUTPUTDIR)\acf_mod_onplayerlevelup.ncs           \
            $(OUTPUTDIR)\acf_mod_onplayerrespawn.ncs           \
            $(OUTPUTDIR)\acf_mod_onplayerrest.ncs              \
            $(OUTPUTDIR)\acf_mod_onplayerunequipitem.ncs       \
            $(OUTPUTDIR)\acf_mod_onunacquireitem.ncs           \
            $(OUTPUTDIR)\acf_mod_onuserdefinedevent.ncs        \
            $(OUTPUTDIR)\acf_plc_onclick.ncs                   \
            $(OUTPUTDIR)\acf_plc_onclosed.ncs                  \
            $(OUTPUTDIR)\acf_plc_onconversation.ncs            \
            $(OUTPUTDIR)\acf_plc_ondamaged.ncs                 \
            $(OUTPUTDIR)\acf_plc_ondeath.ncs                   \
            $(OUTPUTDIR)\acf_plc_ondisarm.ncs                  \
            $(OUTPUTDIR)\acf_plc_onheartbeat.ncs               \
            $(OUTPUTDIR)\acf_plc_oninventorydisturbed.ncs      \
            $(OUTPUTDIR)\acf_plc_onlock.ncs                    \
            $(OUTPUTDIR)\acf_plc_onmeleeattacked.ncs           \
            $(OUTPUTDIR)\acf_plc_onopen.ncs                    \
            $(OUTPUTDIR)\acf_plc_onspellcastat.ncs             \
            $(OUTPUTDIR)\acf_plc_ontraptriggered.ncs           \
            $(OUTPUTDIR)\acf_plc_onunlock.ncs                  \
            $(OUTPUTDIR)\acf_plc_onused.ncs                    \
            $(OUTPUTDIR)\acf_plc_onuserdefined.ncs             \
            $(OUTPUTDIR)\acf_trg_onclick.ncs                   \
            $(OUTPUTDIR)\acf_trg_ondisarm.ncs                  \
            $(OUTPUTDIR)\acf_trg_onenter.ncs                   \
            $(OUTPUTDIR)\acf_trg_onexit.ncs                    \
            $(OUTPUTDIR)\acf_trg_onheartbeat.ncs               \
            $(OUTPUTDIR)\acf_trg_ontraptriggered.ncs           \
            $(OUTPUTDIR)\acf_trg_onuserdefined.ncs

all: safedir copyfiles $(NSS_OBJECTS)

safedir:
	@if not exist $(OUTPUTDIR) mkdir $(OUTPUTDIR)

copyfiles:
	@copy /y *.* $(OUTPUTDIR)\ >NUL

clean:
	@if exist $(OUTPUTDIR) del /q $(OUTPUTDIR)\*

