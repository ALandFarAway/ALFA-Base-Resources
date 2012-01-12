#
# This project builds the IRC bot.
#

#.IGNORE :

!include $(PROJECT_SOURCE_ROOT)\makefile.def

all: makeclrapps

makeclrapps:
	$(BUILD_MSG) (CSProj) Building - ALFAIRCBot
	@$(MSBUILD) ALFAIRCBot.csproj $(MSBUILD_FLAGS)

clean:
	@if exist bin rd /s /q bin
	@if exist obj rd /s /q obj

