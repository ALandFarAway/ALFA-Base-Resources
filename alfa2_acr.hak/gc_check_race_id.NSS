// Returns TRUE if the PC's race is the one provided.
int StartingConditional( int nRace ) {
	return ( GetRacialType( GetPCSpeaker() ) == nRace );
}