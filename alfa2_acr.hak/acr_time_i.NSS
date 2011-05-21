////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_time_i
//      Version : 0.5
//         Date : 2009-05-15
//       Author : Ronan & AcadiusLost
//
//  Local Variable Prefix = ACR_TIME
//
//  Description
//  These scripts handle everything involved in controlling and retrieving data
//  from in-game type.
//  Revision History
//  2006/04/01  Ronan:  Inception
//  2006/07/21  AcadiusLost  Added persistenct checks to InitializeTime. graduated up the 
//                  timestamp functions from acr_resting_i, Added recurring storage of server time.
//  2007/07/22  Cipher  Adjusted function names per standards
//  2007/12/16  AcadiusLost  Added check for failed server time write, to queue module end.
//  2008/01/26  AcadiusLost  Altered InitializeTime() to handle DB failures on initialization
//  2008/02/22  AcadiusLost  Uncommented time storage command in StoreTime()
//  2008/12/08  AcadiusLost  Re-added failure tolerance for timestamp (DB disconnect) to prevent mod reloads
//                   now that NWNx4 1.09 has reconnect functionality.
//  2009/02/10  AcadiusLost  Added SQL query to synchronize server clocks OnInitializeTime()
//  2009/05/15  AcadiusLost  Amended GetTimeStampInMinutes() to work in "game-minutes".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float DAY_TO_SECONDS = 86400.0;
const float HOUR_TO_SECONDS = 3600.0;

// The date in which our time counter begins counting seconds to keep track of
// Realms time.
const int TIME_YEAR_START = 1373;

/*const int _TIME_SECONDS_START = 0;
const int _TIME_SECONDS_END = 5;
const int _TIME_MINUTES_START = 6;
const int _TIME_MINUTES_END = 11;
const int _TIME_HOURS_START = 12;
const int _TIME_HOURS_END = 16;
const int _TIME_DAYS_START = 17;
const int _TIME_DAYS_END = 21;
const int _TIME_MONTH_START = 22;
const int _TIME_MONTH_END = 25;
const int _TIME_YEAR_START =*/

// Game to real time ratio local float.
const string _TIME_RATIO_LF = "ACR_TIME_RATIO";

// Persistent int for current server time:
const string ACR_MODULE_TIME = "ACR_TIME_SERVERTIME";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! This function is called when the module loads.
//! Do we want to syncronize IG time across servers?
void ACR_InitializeTime();

//! Returns the number of real-time seconds in nHours game-hours.
float ACR_GameHoursToRealSeconds(float nHours);

//! Returns the number of real-time seconds in nHours game-minutes.
float ACR_GameMinutesToRealSeconds(float nMinutes);

//! Returns the number of real-time seconds in nHours game-seconds.
float ACR_GameSecondsToRealSeconds(float nSeconds);

//! Gets the game clock as an integer counting the number of seconds passed since
//! the server started.
int ACR_GetGameSecondsSinceStart();

//! Gets the game clock as an integer counting the number of minutes passed since
//! the server started.
int ACR_GetGameMinutesSinceStart();

//! Gets the game clock as an integer counting the number of hours passed since
//! the server started.
int ACR_GetGameHoursSinceStart();

//! Gets the game clock as an integer counting the number of days passed since
//! the server started.
int ACR_GetGameDaysSinceStart();

//! Gets the game clock as an integer counting the number of months passed since
//! the server started.
int ACR_GetGameMonthsSinceStart();

//! Gets the game clock as an integer counting the number of years passed since
//! the server started.
int ACR_GetGameYearsSinceStart();

//! Gets the number of seconds until the game clock is equal to the next
//! occurance of nHour. This could be the current day, or the next.
float ACR_GetSecondsUntilNextHour(int nHour);

//! Returns the ratio of game to real time the module was started with.
float ACR_GetGameToRealTimeRatio();

//! Returns the current day of the tenday (from 1 to 10).
int ACR_GetDayOfTenday();

//! Stores the current time passage persistently
void ACR_StoreTime();

//! This function computes the current date & time and normalizes to minutes
//!  - Returns: number of minutes
int ACR_GetTimeStampInMinutes();

//! This function computes the current date & time and normalizes to hours
//!  - bStartOfDay: Calculate time up through hour 0.
//!  - Returns: number of hours
int ACR_GetTimeStampInHours(int bStartOfDay = FALSE);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_InitializeTime() {
	object oMod = GetModule();
	string sExternalServer = "";
	string sSQLtime = "";
	int nExternalServerID = 0;
	int nExternalTimestamp = 0;
	int nStoredTime = 0;
	// for now, examine all the mod timestamps in the database, pick the most "current" one.
	ACR_SQLQuery("SELECT pwdata.Value, pwdata.Last, pwdata.Name, servers.ID, servers.Name FROM pwdata JOIN servers ON pwdata.Name = servers.Name WHERE pwdata.Key = '"+ACR_MODULE_TIME+"'");
	while (ACR_SQLFetch() == SQL_SUCCESS) {
		// server timestamp(s) are on record, iterate through and pick the highest for now
		//  eventually we'll want to correct to an external clock here, but need to
		//	include handling for clock rollback before that happens.
		nExternalTimestamp = StringToInt(ACR_SQLGetData(0));
		if (nExternalTimestamp > nStoredTime) {
			// current server record has a more advanced timestamp.  lock onto that.
			nStoredTime = nExternalTimestamp;
			nExternalServerID = StringToInt(ACR_SQLGetData(3));
			sExternalServer = ACR_SQLGetData(2);
			sSQLtime = ACR_SQLGetData(1);
		}
	}
	if (nStoredTime == 0) {
		// no server timestamps could be found (new schema?)
		// start from canon start date.
        SetCalendar(1373, 1, 1);
		ACR_SetPersistentInt(oMod, ACR_MODULE_TIME, ACR_GetTimeStampInMinutes());
		ACR_StoreTime();
		WriteTimestampedLogEntry("Restarted canon calander at Jan 1, 1373; as no record could be found.");
	} else {
	    // Work out date from timestamp (total faerun minutes since DR)
	    int nYear = nStoredTime / 483840;
		nStoredTime = nStoredTime - (nYear * 483840);
		int nMonth = nStoredTime / 40320;
		nStoredTime = nStoredTime - (nMonth * 40320);
		int nDay = nStoredTime / 1440;
		nStoredTime = nStoredTime - (nDay * 1440);
		int nHour = nStoredTime / 24;
		nStoredTime = nStoredTime - (nHour * 24);
		int nMinute = nStoredTime / 60;
		
		SetCalendar(nYear, nMonth, nDay);
		SetTime(nHour, nMinute, 0, 0);
		ACR_StoreTime();
		// log the information to the serverlog.
		WriteTimestampedLogEntry("Syncronized to "+sExternalServer+" with ID="+IntToString(nExternalServerID)+", written to the SQL database with RL timestamp: "+sSQLtime);
	}
}

float ACR_GameHoursToRealSeconds(float nHours) {
    return nHours * 3600.0 / ACR_GetGameToRealTimeRatio();
}

float ACR_GameMinutesToRealSeconds(float nMinutes) {
    return nMinutes * 60.0 / ACR_GetGameToRealTimeRatio();
}

float ACR_GameSecondsToRealSeconds(float nSeconds) {
    return nSeconds / ACR_GetGameToRealTimeRatio();
}

int ACR_GetGameSecondsSinceStart() {
    int nYears = GetCalendarYear() - TIME_YEAR_START;
    int nMonths = nYears * 12 + GetCalendarMonth() - 1;
    int nDays = nMonths * DAYS_PER_MONTH + GetCalendarDay() - 1;
    int nHours = nDays * 24 + GetTimeHour();
    int nMinutes = nHours * 60 + GetTimeMinute();
    int nSeconds = nMinutes * 60 + GetTimeSecond();
    return nSeconds;
}

int ACR_GetGameMinutesSinceStart() {
    int nYears = GetCalendarYear() - TIME_YEAR_START;
    int nMonths = nYears * 12 + GetCalendarMonth() - 1;
    int nDays = nMonths * DAYS_PER_MONTH + GetCalendarDay() - 1;
    int nHours = nDays * 24 + GetTimeHour();
    int nMinutes = nHours * 60 + GetTimeMinute();
    return nMinutes;
}

int ACR_GetGameHoursSinceStart() {
    int nYears = GetCalendarYear() - TIME_YEAR_START;
    int nMonths = nYears * 12 + GetCalendarMonth() - 1;
    int nDays = nMonths * DAYS_PER_MONTH + GetCalendarDay() - 1;
    int nHours = nDays * 24 + GetTimeHour();
    return nHours;
}

int ACR_GetGameDaysSinceStart() {
    int nYears = GetCalendarYear() - TIME_YEAR_START;
    int nMonths = nYears * 12 + GetCalendarMonth() - 1;
    int nDays = nMonths * DAYS_PER_MONTH + GetCalendarDay() - 1;
    return nDays;
}

int ACR_GetGameMonthsSinceStart() {
    int nYears = GetCalendarYear() - TIME_YEAR_START;
    int nMonths = nYears * 12 + GetCalendarMonth() - 1;
    return nMonths;
}

int ACR_GetGameYearsSinceStart() {
    int nYears = GetCalendarYear() - TIME_YEAR_START;
    return nYears;
}

float ACR_GetSecondsUntilNextHour(int nNextHour) {
    int nTime = GetTimeHour();
    nTime = nNextHour - nTime;
    nTime = nTime * 60 - GetTimeMinute();
    nTime = nTime * 60 - GetTimeSecond();
    if(nTime < 0) {
        nTime = (24 * 60 * 60) - nTime;
    }
    return nTime / ACR_GetGameToRealTimeRatio();
}

float ACR_GetGameToRealTimeRatio() {
    return 3600.0 / HoursToSeconds(1);
}

int ACR_GetDayOfTenday() {
    return (ACR_GetGameDaysSinceStart() % 10) + 1;
}

void ACR_StoreTime()
{
    object oMod = GetModule();
    int nLastTimestamp = ACR_GetPersistentInt(oMod, ACR_MODULE_TIME);
	if (nLastTimestamp == 0) {
	    int nNumberOfFails = GetLocalInt(oMod, ACR_DB_FAILURES);
		if (nNumberOfFails > 2) { 
		    ACR_ResetDatabase(); 
		}
		SetLocalInt(oMod, ACR_DB_FAILURES, nNumberOfFails+1);
	} else {
	    SetLocalInt(oMod, ACR_DB_FAILURES, 0);
	}
    ACR_SetPersistentInt(oMod, ACR_MODULE_TIME, ACR_GetTimeStampInMinutes());
	DelayCommand(420.0, ACR_StoreTime());
}

int ACR_GetTimeStampInMinutes()
{
    int nTimeStamp = 0;

    // normalize time to minutes
    nTimeStamp += GetCalendarYear() * 483840; //336 * 24 * 60
    nTimeStamp += GetCalendarMonth() * 40320; //28 * 24 * 60
    nTimeStamp += GetCalendarDay() * 1440; //24 * 60
    nTimeStamp += GetTimeHour() * 60;
	// GetTimeMinute() uses RL minutes, so scale using the time compression.
    nTimeStamp += FloatToInt(60.0 * (IntToFloat(GetTimeMinute()*60 + GetTimeSecond()) / (HoursToSeconds(1))));

    return nTimeStamp;
}

int ACR_GetTimeStampInHours(int bStartOfDay = FALSE)
{
    int nTimeStamp = 0;

    // normalize time to the hour
    nTimeStamp += GetCalendarYear() * 8064; //336 * 24
    nTimeStamp += GetCalendarMonth() * 672; //28 * 24
    nTimeStamp += GetCalendarDay() * 24;
    if (!bStartOfDay) { nTimeStamp += GetTimeHour(); }

    return nTimeStamp;
}