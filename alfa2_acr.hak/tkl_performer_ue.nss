/*
Author: brockfanning
Date: Early 2008...
Purpose: This shuts down TKL performer whenever a PC unequips this instrument.
*/

#include "tkl_performer_include"

void main()
{
	ShutDownTKLPerformer(GetPCItemLastUnequippedBy(), GetPCItemLastUnequipped());
}