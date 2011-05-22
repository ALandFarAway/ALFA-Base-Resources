//	m_c_is_night
/*
	Conditional check to see if it's night.
*/
//	JSH-OEI 02/15/08

int StartingConditional()
{
	if (!GetIsNight())
		return FALSE;
	else
		return TRUE;
}