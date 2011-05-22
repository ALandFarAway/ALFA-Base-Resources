#include "x0_inc_henai"

#include "hench_i0_generic"

void main()
{
    // TK removed SendForHelp
//    SendForHelp();
	InitializeCreatureInformation(OBJECT_SELF);
    
	SetCommandable(TRUE);

    ClearAllActions();

	SetCommandable(FALSE);
}