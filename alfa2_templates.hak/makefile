#
# This project constructs alfa2_templates.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa2_templates.hak
HAK_SOURCES=                                                   \
            .\*.TXT                                            \
            .\*.DLG                                            \
            .\*.UTC                                            \
            .\*.UTI                                            \
            .\*.UTP                                            \
            .\*.UTW                                            \
            .\*.UTM

NOT_YET_USED_HAK_SOURCES=                                      \
            .\*.UEN                                            \
            .\*.UTT                                            \
            .\*.UPE                                            \
            .\*.ULT                                            \
            .\*.UTD                                            \
            .\*.UTS                                            \
            .\*.USC                                            \
            .\*.UTR                                            


HAK_SOURCES_NL=$(HAK_SOURCES:.\=^
)

HAK_SOURCES_NL=$(HAK_SOURCES_NL: =)

all: $(HAKFILE)

script:

clean:
	@if exist $(HAKFILE) del /q $(HAKFILE) >NUL

$(HAKFILE): $(HAK_SOURCES)
	$(BUILD_MSG) (ERF) Creating - $(HAKFILE)
	@$(MKERF_NWN2) -c $(HAKFILE) @<<$(ERFUTIL_RSP)
-z$(HAK_SOURCES_NL)
<<NOKEEP

