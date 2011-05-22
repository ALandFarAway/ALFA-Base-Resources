// gc_singleplayer ()
/* 
	Returns TRUE if this is a single player only game, otherwise returns FALSE.
*/
// BMA-OEI 11/29/05

int StartingConditional()
{
	return ( GetIsSinglePlayer() );
}