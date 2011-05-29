#
# This makefile include defines the standard target macros for recursion into
# subdirectories.
#

all: $(DIRS)
	@for %a in ($**) do @(                             \
	$(BUILD_MSG) [BUILD] Entering directory %a [$@] && \
	pushd %a &&                                        \
	$(MAKE) /NOLOGO $@ &&                              \
	$(BUILD_MSG) [BUILD] Leaving directory %a [$@] &&  \
	popd                                               \
	)                                          

clean: $(DIRS)
	@for %a in ($**) do @(                             \
	$(BUILD_MSG) [BUILD] Entering directory %a [$@] && \
	pushd %a &&                                        \
	$(MAKE) /NOLOGO $@ &&                              \
	$(BUILD_MSG) [BUILD] Leaving directory %a [$@] &&  \
	popd                                               \
	)                                          

