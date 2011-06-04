#
# This makefile include defines the standard target macros for recursion into
# subdirectories.
#

all: $(DIRS)
	@set BLDERRFILE=$(PROJECT_SOURCE_ROOT)\release\_BLDERRORS 
	@if exist %BLDERRFILE% del /q %BLDERRFILE% >NUL          
	@for %a in ($**) do @(                                   \
	$(BUILD_MSG) [BUILD] Entering directory %a [$@] &        \
	pushd %a &                                               \
	$(MAKE) /NOLOGO $@ &                                     \
	call $(PROJECT_SOURCE_ROOT)\chkerr.cmd %a %ERRORLEVEL% & \
	$(BUILD_MSG) [BUILD] Leaving directory %a [$@] &         \
	popd                                                     \
	)                                                        
	@if exist %BLDERRFILE% (                                 \
	$(BUILD_MSG) [BUILD] Build failed due to build errors. & \
	$(BUILD_MSG) [BUILD] Failing projects were: &            \
	$(BUILD_MSGFILE) %BLDERRFILE% &                          \
	del /q %BLDERRFILE% >NUL &                               \
	exit 1                                                   \
	)                                                        

clean: $(DIRS)
	@set BLDERRFILE=$(PROJECT_SOURCE_ROOT)\release\_BLDERRORS 
	@if exist %BLDERRFILE% del /q %BLDERRFILE% >NUL          
	@for %a in ($**) do @(                                   \
	$(BUILD_MSG) [BUILD] Entering directory %a [$@] &        \
	pushd %a &                                               \
	$(MAKE) /NOLOGO $@ &                                     \
	call $(PROJECT_SOURCE_ROOT)\chkerr.cmd %a %ERRORLEVEL% & \
	$(BUILD_MSG) [BUILD] Leaving directory %a [$@] &         \
	popd                                                     \
	)                                                        
	@if exist %BLDERRFILE% (                                 \
	$(BUILD_MSG) [BUILD] Build failed due to build errors. & \
	$(BUILD_MSG) [BUILD] Failing projects were: &            \
	$(BUILD_MSGFILE) %BLDERRFILE% &                          \
	del /q %BLDERRFILE% >NUL &                               \
	exit 1                                                   \
	)                                                        

