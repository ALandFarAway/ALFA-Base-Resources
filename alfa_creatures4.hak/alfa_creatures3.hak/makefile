#
# This project constructs alfa_creatures3.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa_creatures3.hak
HAK_SOURCES=                                                   \
            .\*.UTC                                            \
            .\*.BBX                                            \
            .\*.MDB                                            \
            .\*.GR2                                            \
            .\*.TGA                                            \
            .\*.UTI                                            \
            .\*.SEF                                            \
            .\*.DDS                                            \
            .\*.PFX                                         

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
