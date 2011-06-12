#
# This project constructs alfa_fx.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa_fx.hak
HAK_SOURCES=                                                   \
            .\*.SEF                                            \
            .\*.WAV                                            \
            .\*.PFX                                            \
            .\*.SEF                                            \
            .\*.BBX                                            \
            .\*.GR2                                            \
            .\*.TGA                                            \
            .\*.DDS                                            \
            .\*.MDB                                            \
            .\*.PFB                                            \
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

