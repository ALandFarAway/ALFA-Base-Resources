#
# This project constructs alfa_creatures.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa_creatures.hak
HAK_SOURCES=                                                   \
            .\*.UTC                                            \
            .\*.WAV                                            \
            .\*.MDB                                            \
            .\*.GR2                                            \
            .\*.TGA                                            \
            .\*.SSF                                            \
            .\*.FXA                                            \
            .\*.XML                                            \
            .\*.SEF                                            \
            .\*.BBX                                            \
            .\*.GRM                                            \
            .\*.PFX                                            \
            .\*.PDN                                            \
            .\*.UTI                                            \
            .\*.DDS                                            \
            .\*.TXT
                                                       
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

