#
# This project constructs alfa2_2da.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa2_2da.hak
HAK_SOURCES=                                                   \
            .\alfa_acr02.tlk                                   \
            .\ambientmusic.2DA                                 \
            .\appearance.2DA                                   \
            .\armorrulestats.2DA                               \
            .\armorvisualdata.2DA                              \
            .\backgrounds.2DA                                  \
            .\baseitems.2DA                                    \
            .\classes.2DA                                      \
            .\cls_feat_spiritshaman.2DA                        \
            .\cls_pres_archer.2DA                              \
            .\cls_pres_arctr.2DA                               \
            .\cls_pres_asasin.2DA                              \
            .\cls_pres_blkgrd.2DA                              \
            .\cls_pres_divcha.2DA                              \
            .\cls_pres_doomguide.2DA                           \
            .\cls_pres_dradis.2DA                              \
            .\cls_pres_duel.2DA                                \
            .\cls_pres_dwdef.2DA                               \
            .\cls_pres_eknight.2DA                             \
            .\cls_pres_frenz.2DA                               \
            .\cls_pres_harper.2DA                              \
            .\cls_pres_hellfire.2DA                            \
            .\cls_pres_invisiblade.2DA                         \
            .\cls_pres_nw9wd.2DA                               \
            .\cls_pres_palema.2DA                              \
            .\cls_pres_redwiz.2DA                              \
            .\cls_pres_sacredfist.2DA                          \
            .\cls_pres_scholar.2DA                             \
            .\cls_pres_sdthf.2DA                               \
            .\cls_pres_shadow.2DA                              \
            .\cls_pres_wm.2DA                                  \
            .\cls_pres_wprst.2DA                               \
            .\cls_skill_archer.2DA                             \
            .\cls_skill_arctr.2DA                              \
            .\cls_skill_asasin.2DA                             \
            .\cls_skill_barb.2DA                               \
            .\cls_skill_bard.2DA                               \
            .\cls_skill_blkgrd.2DA                             \
            .\cls_skill_cler.2DA                               \
            .\cls_skill_divcha.2DA                             \
            .\cls_skill_doomguide.2DA                          \
            .\cls_skill_dradis.2DA                             \
            .\cls_skill_dru.2DA                                \
            .\cls_skill_duelist.2DA                            \
            .\cls_skill_dwdef.2DA                              \
            .\cls_skill_eknight.2DA                            \
            .\cls_skill_favored_soul.2DA                       \
            .\cls_skill_fight.2DA                              \
            .\cls_skill_frenz.2DA                              \
            .\cls_skill_harper.2DA                             \
            .\cls_skill_hellfire.2DA                           \
            .\cls_skill_invisiblade.2DA                        \
            .\cls_skill_monk.2DA                               \
            .\cls_skill_nw9wd.2DA                              \
            .\cls_skill_pal.2DA                                \
            .\cls_skill_palema.2DA                             \
            .\cls_skill_rang.2DA                               \
            .\cls_skill_redwiz.2DA                             \
            .\cls_skill_rog.2DA                                \
            .\cls_skill_sacredfist.2DA                         \
            .\cls_skill_scholar.2DA                            \
            .\cls_skill_sdthf.2DA                              \
            .\cls_skill_shadow.2DA                             \
            .\cls_skill_sorc.2DA                               \
            .\cls_skill_spiritshaman.2DA                       \
            .\cls_skill_stormlord.2DA                          \
            .\cls_skill_swashbuckler.2DA                       \
            .\cls_skill_wiz.2DA                                \
            .\cls_skill_wlck.2DA                               \
            .\cls_skill_wm.2DA                                 \
            .\cls_skill_wprst.2DA                              \
            .\des_crft_spells.2DA                              \
            .\doortypes.2DA                                    \
            .\feat.2DA                                         \
            .\ftext_styles.2DA                                 \
            .\grass.2DA                                        \
            .\iprp_chargecost.2DA                              \
            .\iprp_damagecost.2DA                              \
            .\iprp_resistcost.2DA                              \
            .\iprp_spells.2DA                                  \
            .\itempropdef.2DA                                  \
            .\itemprops.2DA                                    \
            .\metatiles.2DA                                    \
            .\npc_soundset.2DA                                 \
            .\nwn2_deities.2DA                                 \
            .\nwn2_icons.2DA                                   \
            .\nwn2_tips.2DA                                    \
            .\packages.2DA                                     \
            .\placeables.2DA                                   \
            .\race_feat_yuanti.2DA                             \
            .\racialsubtypes.2DA                               \
            .\racialtypes.2DA                                  \
            .\restduration.2DA                                 \
            .\skills.2DA                                       \
            .\skillvsitemcost.2DA                              \
            .\soundset.2DA                                     \
            .\spells.2DA                                       \
            .\terrainmaterials.2DA                             \
            .\texturestileceiling.2DA                          \
            .\texturestilefloor.2DA                            \
            .\texturestilewall.2DA                             \
            .\tiles.2DA                                        \
            .\tilesets.2DA                                     \
            .\wingmodel.2DA                                    \
            .\_alfa_ambientmusic_2da_1.80.TXT                  \
            .\_alfa_appearance_2da_1.74.TXT                    \
            .\_alfa_armorrulestats_2da_1.70.TXT                \
            .\_alfa_armorvisualdata_2da_1.71.TXT               \
            .\_alfa_backgrounds_2da_1.70.TXT                   \
            .\_alfa_baseitems_2da_1.68.TXT                     \
            .\_alfa_classes_2da_1.73.TXT                       \
            .\_alfa_cls_pres_all_2da_1.73.TXT                  \
            .\_alfa_cls_skill_all_2da_1.73.TXT                 \
            .\_alfa_des_crft_spells_2da_1.74.TXT               \
            .\_alfa_doortypes_2da_1.80.TXT                     \
            .\_alfa_feat_2da_1.73.TXT                          \
            .\_alfa_ftext_styles_2da_1.3.TXT                   \
            .\_alfa_grass_2da_1.60.TXT                         \
            .\_alfa_iprp_chargecost_2da_1.68.TXT               \
            .\_alfa_iprp_damagecost_2da_1.64.TXT               \
            .\_alfa_iprp_resistcost_2da_1.64.TXT               \
            .\_alfa_iprp_spells_2da_1.80.TXT                   \
            .\_alfa_itempropdef_2da_1.74.TXT                   \
            .\_alfa_itemprops_2da_1.74.TXT                     \
            .\_alfa_metatiles_2da_1.74.TXT                     \
            .\_alfa_npc_soundset_2da_1.70.TXT                  \
            .\_alfa_nwn2_dieties_2da_1.71.TXT                  \
            .\_alfa_nwn2_icons_2da_1.71.TXT                    \
            .\_alfa_nwn2_tips_2da_1.55.TXT                     \
            .\_alfa_packages_2da_1.71.TXT                      \
            .\_alfa_placeables_2da_1.80.TXT                    \
            .\_alfa_race_feat_yuanti_2da_1.70.TXT              \
            .\_alfa_racialsubtypes_2da_1.70.TXT                \
            .\_alfa_racialtypes_2da_1.70.TXT                   \
            .\_alfa_restduration_2da.TXT                       \
            .\_alfa_skills_2da_1.71.TXT                        \
            .\_alfa_skillvsitemcost_2da_1.67.TXT               \
            .\_alfa_soundset_2da_1.73.TXT                      \
            .\_alfa_spells_2da_1.70.TXT                        \
            .\_alfa_terrainmaterials_2da_1.80.TXT              \
            .\_alfa_texturestilesceiling_2da_1.TXT             \
            .\_alfa_texturestilesfloor_2da_1.2.TXT             \
            .\_alfa_texturestileswall_2da_1.2.TXT              \
            .\_alfa_tilesets_2da_1.74.TXT                      \
            .\_alfa_tiles_2da_1.74.TXT                         \
            .\_alfa_wingmodel_2da_1.71.TXT                     \
            .\__alfa_2da_hak_1.80.TXT                           

HAK_SOURCES_NL=$(HAK_SOURCES:.\=^
)

HAK_SOURCES_NL=$(HAK_SOURCES_NL: =)

all: $(HAKFILE)

script:

clean:
	del /q $(HAKFILE) >NUL
$(HAKFILE): $(HAK_SOURCES)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) @<<$(ERFUTIL_RSP)
-z$(HAK_SOURCES_NL)
<<NOKEEP

