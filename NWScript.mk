#
# This makefile include sets up inference rules to compile NWScript source
# files.
#

NSS_FLAGS=$(NSS_FLAGS) -x "error " -q -e -o -v1.70 -i $(NSS_INC_PATH) -i $(NSS_INCLUDES);

{}.nss{$(OUTPUTDIR)}.ncs:
	$(BUILD_MSG) (NWScript) Compiling - $(<:.\=)
	@$(NSS_COMPILER) $(NSS_FLAGS) $< $*.ncs
	@copy /Y $< $*.nss >NUL

{..\}.nss{$(OUTPUTDIR)}.ncs:
	$(BUILD_MSG) (NWScript) Compiling - $(<:.\=)
	@$(NSS_COMPILER) $(NSS_FLAGS) $< $*.ncs
	@copy /Y $< $*.nss >NUL

.SUFFIXES: .nss .ncs

