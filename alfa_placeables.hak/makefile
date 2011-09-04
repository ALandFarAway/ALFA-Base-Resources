#
# This project constructs alfa_placeables.hak.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

HAKFILE=$(OUTPUTDIR)\alfa_placeables.hak
HAK_SOURCES=                                                   \
            .\*.JPG                                            \
            .\*.TXT                                            \
            .\*.TGA                                            \
            .\*.GR2                                            \
            .\*.MDB                                            \
            .\*.UTP                                            \
            .\*.DDS                                            

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

