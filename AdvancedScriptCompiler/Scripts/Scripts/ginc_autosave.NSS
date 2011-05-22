// ginc_autosave.nss
/*
	NWN2 Single Player Auto Save Include
*/
// BMA-OEI 8/22/06

//temp
#include "ginc_debug"


const int AUTOSAVE_COOL_DOWN	= 5; 						// in in-game hours
const string AUTOSAVE_LAST_SAVE	= "00_nAutoSaveLastSave"; 	// time hash timestamp


// Return time hash given nHours and nDays
// Ranges between 24 (0 Hour 1 Day) and 695 (23 Hour 28 Day)
int GetTimeHash( int nHours, int nDays );

// Return time hash difference (adjusts for wrap around)
int GetTimeHashDifference( int nHash1, int nHash2 );

// Return current time hash
int GetCurrentTimeHash();

// Return last auto save time hash
int GetAutoSaveTimeHash();

// Return TRUE if Single Player and sufficient time has passed since last save
int GetAbleToAutoSave( int bUseCoolDown=TRUE );

// Auto Save if able to auto save
void AttemptSinglePlayerAutoSave( int bUseCoolDown=TRUE );


// Return time hash given nHours and nDays
// Ranges between 24 (0 Hour 1 Day) and 695 (23 Hour 28 Day)
int GetTimeHash( int nHours, int nDays )
{
	int nTimeHash = nHours + ( nDays * 24 );
	return ( nTimeHash );
}

// Return time hash difference (adjusts for wrap around)
int GetTimeHashDifference( int nHash1, int nHash2 )
{
	int nDifference = nHash1 - nHash2;
	if ( nDifference < 0 )
	{
		nDifference = nDifference + 672; // wrap around
	}
	
	//PrettyMessage( "GetTimeHashDifference( " + IntToString( nHash1 ) +  ", " + IntToString( nHash2 ) +  " ) = " + IntToString( nDifference ) );
	return ( nDifference );
}

// Return current time hash
int GetCurrentTimeHash()
{
	int nCurrentHour = GetTimeHour();
	int nCurrentDay = GetCalendarDay();
	//PrettyMessage( "GetCurrentTimeHash(): nCurrentHour = " + IntToString( nCurrentHour ) + ", nCurrentDay = " + IntToString( GetCalendarDay() ) );
	int nTimeHash = GetTimeHash( nCurrentHour, nCurrentDay );
	return ( nTimeHash );
}

// Return last auto save time hash
int GetAutoSaveTimeHash()
{
	int nTimeHash = GetGlobalInt( AUTOSAVE_LAST_SAVE );
	return ( nTimeHash );
}

// Return TRUE if Single Player and sufficient time has passed since last save
int GetAbleToAutoSave( int bUseCoolDown=TRUE )
{
	int nSinglePlayer = GetIsSinglePlayer();
	
	if ( nSinglePlayer == TRUE )
	{
		if ( bUseCoolDown == TRUE )
		{
			int nCurrentTime = GetCurrentTimeHash();
			int nLastSave = GetAutoSaveTimeHash();
			//PrettyMessage( "nCurrentTime = " + IntToString( nCurrentTime ) + ", nLastSave = " + IntToString( nLastSave ) );
			if ( GetTimeHashDifference( nCurrentTime, nLastSave ) >= AUTOSAVE_COOL_DOWN )
			{
				//PrettyDebug( "GetAbleToAutoSave() = TRUE" );
				return ( TRUE );
			}		
		}
		else
		{
			//PrettyDebug( "GetAbleToAutoSave() = TRUE" );
			return ( TRUE );		
		}
	}
	
	//PrettyDebug( "GetAbleToAutoSave() = FALSE" );
	return ( FALSE );
}

// Auto Save if able to auto save
void AttemptSinglePlayerAutoSave( int bUseCoolDown=TRUE )
{
	if ( GetAbleToAutoSave( bUseCoolDown ) == TRUE )
	{
		int nCurrentTime = GetCurrentTimeHash();
		SetGlobalInt( AUTOSAVE_LAST_SAVE, nCurrentTime );
		DoSinglePlayerAutoSave();
	}
}