#include "acr_language_i"

// Returns TRUE if the PC knows the given language.
int StartingConditional( string sLanguage ) {
	return ( ACR_IsLanguageKnown( GetPCSpeaker(), sLanguage ) );
}