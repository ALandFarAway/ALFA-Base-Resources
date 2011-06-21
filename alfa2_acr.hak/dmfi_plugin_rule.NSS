#include "dmfi_inc_initial"
void main()
{
	DMFI_GrantLanguage(OBJECT_SELF, "HighElf");
    SendText(OBJECT_SELF, "An additional language 'HighElf' has been granted via a plugin.", FALSE, COLOR_GREY);
}