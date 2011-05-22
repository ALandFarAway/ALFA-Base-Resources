// ga_lock_orientation
//
// Lock orientation of sTarget.  bLock = FALSE will unlock.
	
// EPF 7/11/07
	
#include "ginc_param_const"
	
void main(string sTarget, int bLock)
{
	SetOrientOnDialog(GetTarget(sTarget), !bLock);
}
