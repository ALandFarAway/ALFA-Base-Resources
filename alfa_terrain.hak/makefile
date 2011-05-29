#
# This project constructs alfa_terrain.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa_terrain.hak
HAK_SOURCES=                                                   \
            .\ag_champi_01.DDS                                 \
            .\gd_snow_dirt.DDS                                 \
            .\gd_snow_dirt_c.DDS                               \
            .\gd_snow_dirt_n.DDS                               \
            .\gd_snow_grass.DDS                                \
            .\gd_snow_grass_c.DDS                              \
            .\gd_snow_grass_n.DDS                              \
            .\tt_gm_snowfloor001a.DDS                          \
            .\tt_gm_snowfloor001a_c.DDS                        \
            .\tt_gm_snowfloor001a_n.DDS                        \
            .\tt_gm_snowfloor003a.DDS                          \
            .\tt_gm_snowfloor003a_c.DDS                        \
            .\tt_gm_snowfloor003a_n.DDS                        \
            .\tt_gr_cliff_12.DDS                               \
            .\tt_gr_cliff_12_c.DDS                             \
            .\tt_gr_cliff_12_n.DDS                             \
            .\tt_gs_beachsand_01.DDS                           \
            .\tt_gs_beachsand_01_c.DDS                         \
            .\tt_gs_beachsand_01_n.DDS                         \
            .\tt_gs_cobblestone_48.DDS                         \
            .\tt_gs_cobblestone_48_c.DDS                       \
            .\tt_gs_cobblestone_48_n.DDS                       \
            .\tt_gs_cobblestone_50.DDS                         \
            .\tt_gs_cobblestone_50_c.DDS                       \
            .\tt_gs_cobblestone_50_n.DDS                       \
            .\tt_gs_ice_01.DDS                                 \
            .\tt_gs_ice_01_c.DDS                               \
            .\tt_gs_ice_01_n.DDS                               \
            .\tt_gs_snow2_01.DDS                               \
            .\tt_gs_snow2_01_c.DDS                             \
            .\tt_gs_snow2_01_n.DDS                             \
            .\tt_gs_snow_01.DDS                                \
            .\tt_gs_snow_01_c.DDS                              \
            .\tt_gs_snow_01_n.DDS                              \
            .\tt_gs_snow_02.DDS                                \
            .\tt_gs_snow_02_c.DDS                              \
            .\tt_gs_snow_02_n.DDS                              \
            .\tt_ps_brckwarp.DDS                               \
            .\tt_ps_brckwarp_c.DDS                             \
            .\tt_ps_brckwarp_n.DDS                             \
            .\tt_ps_bubcliff.DDS                               \
            .\tt_ps_bubcliff_c.DDS                             \
            .\tt_ps_bubcliff_n.DDS                             \
            .\tt_ps_bubgrd.DDS                                 \
            .\tt_ps_bubgrd_c.DDS                               \
            .\tt_ps_bubgrd_n.DDS                               \
            .\tt_ps_ci_mosaic001.DDS                           \
            .\tt_ps_ci_mosaic001_c.DDS                         \
            .\tt_ps_ci_mosaic001_n.DDS                         \
            .\tt_ps_dust01.DDS                                 \
            .\tt_ps_dust01_c.DDS                               \
            .\tt_ps_dust01_n.DDS                               \
            .\tt_ps_dust04.DDS                                 \
            .\tt_ps_dust04_c.DDS                               \
            .\tt_ps_dust04_n.DDS                               \
            .\tt_ps_floor.DDS                                  \
            .\tt_ps_floored.DDS                                \
            .\tt_ps_floored_c.DDS                              \
            .\tt_ps_floored_n.DDS                              \
            .\tt_ps_floorslabs.DDS                             \
            .\tt_ps_floorslabs_c.DDS                           \
            .\tt_ps_floorslabs_n.DDS                           \
            .\tt_ps_floor_c.DDS                                \
            .\tt_ps_floor_n.DDS                                \
            .\tt_ps_grwarp.DDS                                 \
            .\tt_ps_grwarp_c.DDS                               \
            .\tt_ps_grwarp_n.DDS                               \
            .\tt_ps_rubble.DDS                                 \
            .\tt_ps_rubble_c.DDS                               \
            .\tt_ps_rubble_n.DDS                               \
            .\tt_ps_scrap02.DDS                                \
            .\tt_ps_scrap02_c.DDS                              \
            .\tt_ps_scrap02_n.DDS                              \
            .\tt_ps_sqbricks.DDS                               \
            .\tt_ps_sqbricks_c.DDS                             \
            .\tt_ps_sqbricks_n.DDS                             \
            .\_alfa_terrain_hak_1.80.TXT                       

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

