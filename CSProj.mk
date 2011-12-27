#
# This makefile include sets up inference rules to compile CSProj project
# files.
#

MSBUILD_FLAGS=/p:Configuration=Release /p:Platform=AnyCPU /verbosity:quiet /nologo

#
# The CLRv2 version of MSBuild doesn't set MSBuildToolsPath automatically, so
# set it manually because the csproj files may depend on it.
#

!if "$(CLR_VERSION)" == "v2.0.50727"
MSBUILD_FLAGS=$(MSBUILD_FLAGS) /p:MSBuildToolsPath=$(MSBUILD_TOOLS_PATH)
!endif

#{}.csproj{$(OUTPUTDIR)}.ncs:
#	$(BUILD_MSG) (CSProj) Building - $(<:.\=)
#	@$(MSBUILD) $(MSBUILD_FLAGS) $< $*.ncs

#{..\}.csproj{$(OUTPUTDIR)}.ncs:
#	$(BUILD_MSG) (CSProj) Building - $(<:.\=)
#	@$(MSBUILD) $(MSBUILD_FLAGS) $< $*.ncs

#.SUFFIXES: .csproj .ncs

