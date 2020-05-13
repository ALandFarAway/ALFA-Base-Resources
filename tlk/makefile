#
# This project constructs alfa_acr02.tlk.
#

!include $(PROJECT_SOURCE_ROOT)\makefile.def

TLKFILE=$(OUTPUTDIR)\alfa_acr02.tlk
TLK_SOURCE=.\alfa.tls


all: $(TLKFILE)

script:

clean:
	@if exist $(TLKFILE) del /q $(TLKFILE) >NUL

$(TLKFILE):
	$(BUILD_MSG) (TLK) Creating - $(TLKFILE)
	$(MKTLK) $(TLK_SOURCE) --output $(TLKFILE)
