//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_template_counterspell
//::
//::	A loveable, portable anti-mage. Full of counterspells and debuff's
//::
//::///////////////////////////////////////////////////////////////////////////
//  DBR 1/30/06

#include "ginc_ai"
	

void main()
{

		//Set either of these two flags to get preferred behavior.

		int bCounterSpell =1;
		int bDispel = 1;

		AIMakeCounterCaster(OBJECT_SELF, bCounterSpell, bDispel);


}