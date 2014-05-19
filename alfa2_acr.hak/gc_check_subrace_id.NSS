// Returns TRUE if the PC's subrace is the one provided.
int StartingConditional( int nSubrace ) {
	return ( GetSubRace( GetPCSpeaker() ) == nSubrace );
}