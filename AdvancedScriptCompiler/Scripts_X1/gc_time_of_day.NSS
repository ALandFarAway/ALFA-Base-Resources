// gc_time_of_day (string sTimeOfDay)
/*
	Description:
	Checks to see if the current time is within the specified time of day.
    
    sTimeOfDay: "DUSK" - the specific hour dusk occurs in
                "DAWN" - the specific hour dawn occurs in
                "DAY" - the range of hours between (but not including) dawn and dusk
                "NIGHT" - the range of hours between (but not including) dusk and dawn
                "NOON" - the hour of noon
                "MIDNIGHT" - the hour of midnight                
*/
// ChazM 1/22/07

#include "ginc_debug"

// Tima of Day constants
const string TOD_DUSK   = "DUSK";   // - the specific hour dusk occurs in
const string TOD_DAWN   = "DAWN";   // - the specific hour dawn occurs in
const string TOD_DAY    = "DAY";    // - the range of hours between (but not including) dawn and dusk
const string TOD_NIGHT  = "NIGHT";  // - the range of hours between (but not including) dusk and dawn
const string TOD_NOON   = "NOON";   // - the hour of noon
const string TOD_MIDNIGHT= "MIDNIGHT";// - the hour of midnight

int StartingConditional(string sTimeOfDay)
{
    int iRet = FALSE;
    
    sTimeOfDay = GetStringUpperCase(sTimeOfDay);
    int iHour = GetTimeHour();
    
    if (sTimeOfDay == TOD_DUSK)
        iRet = GetIsDusk();
    else if (sTimeOfDay == TOD_DAWN)
        iRet = GetIsDawn();
    else if (sTimeOfDay == TOD_DAY)
        iRet = GetIsDay();
    else if (sTimeOfDay == TOD_NIGHT)
        iRet = GetIsNight();
    else if (sTimeOfDay == TOD_NOON)
        iRet = (GetTimeHour() == 12);
    else if (sTimeOfDay == TOD_MIDNIGHT)
        iRet = (GetTimeHour() == 0);
    else
        PrettyError("Unrecognized Time of Day");

	return (iRet);
}

/*
other constants that could be added if we knew the hour of dusk and dawn...
        
        "MORNING" - the hours of dawn until before noon
        "AFTERNOON" - the hours of noon until before dusk.
        "EVENING" - the hours of dusk until before midnight
        "AFTERMIDNIGHT" - the hours of midnight until before dawn

*/