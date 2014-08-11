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

#ifndef ACR_TIME_I
#define ACR_TIME_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float DAY_TO_SECONDS = 86400.0;
const float HOUR_TO_SECONDS = 3600.0;

// The date in which our time counter begins counting seconds to keep track of
// Realms time.
const int TIME_YEAR_START = 1373;

const int ALFA2_FR_YEAR_START = 1375;
const int ALFA2_RL_YEAR_START = 2008;

const int ACR_TIME_SECONDS_SINCE_START = 1;
const int ACR_TIME_MINUTES_SINCE_START = 2;
const int ACR_TIME_HOURS_SINCE_START = 3;
const int ACR_TIME_DAYS_SINCE_START = 4;
const int ACR_TIME_MONTHS_SINCE_START = 5;
const int ACR_TIME_YEARS_SINCE_START = 6;

const int ACR_TIME_SECONDS_IN_UTC = 11;
const int ACR_TIME_MINUTES_IN_UTC = 12;
const int ACR_TIME_HOURS_IN_UTC = 13;
const int ACR_TIME_DAYS_IN_UTC = 14;
const int ACR_TIME_MONTHS_IN_UTC = 15;
const int ACR_TIME_YEARS_IN_UTC = 16;

// Game to real time ratio local float.
const string _TIME_RATIO_LF = "ACR_TIME_RATIO";

// Persistent int for current server time:
const string ACR_MODULE_TIME = "ACR_TIME_SERVERTIME";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct DateStruct
{
	int year;
	int month;
	int day;
	int holiday;
};

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

//! Gets the game clock as an integer counting the number of milliseconds passed since
//! the server started.
int ACR_GetGameMillisecondsSinceStart();

//! Gets the game clock as an integer counting the number of seconds passed since
//  the server started.  Note that the value may be negative and should only be
//  used to track relative time.
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

//! Finds out day of the tenday (from 1 to 10).
int ACR_GetDayOfTenday(int day=-1);

//! Stores the current time passage persistently
void ACR_StoreTime();

//! This function computes the current date & time and normalizes to minutes
//!  - Returns: number of minutes
int ACR_GetTimeStampInMinutes();

//! This function computes the current date & time and normalizes to hours
//!  - bStartOfDay: Calculate time up through hour 0.
//!  - Returns: number of hours
int ACR_GetTimeStampInHours(int bStartOfDay = FALSE);

//! Converts given date to readable string
//!  - full: Full or short date
//!  - informal: informal or formal month names
//!  - Returns: readable string of date
string ACR_FRDateToString(int full=1,int informal=0, int year=0, int month=0, int day=0, int holiday=0);

//! Returns current FR year
int ACR_GetFRYear();

//! Returns name of FR Year
string ACR_GetFRYearName(int year=0);

//! Returns current FR month
int ACR_GetFRMonth();

//! Returns current FR day
int ACR_GetFRDay();

//! Returns current FR tenday
int ACR_GetFRTenday();

//! Returns current FR holiday
int ACR_GetFRHoliday();

//! Converts given rl date to fr date
//!  - Returns: FR date
struct DateStruct ACR_ConvertDate(int year=0, int month=0, int day=0);

// Private functions

//! Calculate and set proper FR date from RL date
void _CalcDate();

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_tools_i"
#include "acr_db_persist_i"

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
        SetCalendar(TIME_YEAR_START, 1, 1);
		if (ACR_GetIsModuleOffline() == FALSE) {
			ACR_SetPersistentInt(oMod, ACR_MODULE_TIME, ACR_GetTimeStampInMinutes());
			ACR_StoreTime();
		} else {
			WriteTimestampedLogEntry("Module is offline.");
		}
		WriteTimestampedLogEntry("Restarted canon calander at Jan 1, TIME_YEAR_START; as no record could be found.");
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

		if (ACR_GetIsModuleOffline() == FALSE) {
			ACR_StoreTime();
		} else {
			WriteTimestampedLogEntry("Module is offline.");
		}
		// log the information to the serverlog.
		WriteTimestampedLogEntry("Synchronized to "+sExternalServer+" with ID="+IntToString(nExternalServerID)+", written to the SQL database with RL timestamp: "+sSQLtime);
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

int ACR_GetGameMillisecondsSinceStart()
{
    int nSeconds = ACR_GetGameSecondsSinceStart();
    int nMilSeconds = nSeconds * 1000 + GetTimeMillisecond();
    return nMilSeconds;
}

int ACR_GetGameSecondsSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_SECONDS_SINCE_START);
    return ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE);
}

int ACR_GetGameMinutesSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_MINUTES_SINCE_START);
    return ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE);
}

int ACR_GetGameHoursSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_MINUTES_SINCE_START);
    return FloatToInt(ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE) / (HoursToSeconds(1) / 60.0f));
}

int ACR_GetGameDaysSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_MINUTES_SINCE_START);
    return FloatToInt(ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE) / (HoursToSeconds(24) / 60.0f));
}

int ACR_GetGameMonthsSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_MINUTES_SINCE_START);
    return FloatToInt(ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE) / ((HoursToSeconds(24) / 60.0f) * DAYS_PER_MONTH));
}

int ACR_GetGameYearsSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_MINUTES_SINCE_START);
    return FloatToInt(ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE) / ((HoursToSeconds(24) / 60.0f) * DAYS_PER_MONTH * 12));
}

int ACR_GetRealDaysSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_DAYS_SINCE_START);
    return ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE);
}

int ACR_GetRealMonthsSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_MONTHS_SINCE_START);
    return ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE);
}

int ACR_GetRealYearsSinceStart()
{
    ClearScriptParams();
    AddScriptParameterInt(ACR_TIME_YEARS_SINCE_START);
    return ExecuteScriptEnhanced("ACR_Time", GetModule(), TRUE);
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

void ACR_StoreTime()
{
	object oMod = GetModule();
	int date,day,month,year;

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

	if (ACR_GetIsModuleOffline() == FALSE) {
		ACR_SetPersistentInt(oMod, ACR_MODULE_TIME, ACR_GetTimeStampInMinutes());
	} else {
		WriteTimestampedLogEntry("Module is offline.");
	}

	// Handling for rl -> fr date conversion
	ACR_SQLQuery("SELECT CURDATE() + 0");

	if (ACR_SQLFetch() == SQL_SUCCESS) {
		date = StringToInt(ACR_SQLGetData(0));
		day = date % 100;
		month = (date / 100) % 100;
		year = (date / 10000);

		SetGlobalInt("ACR_Day", day);
		SetGlobalInt("ACR_Month", month);
		SetGlobalInt("ACR_Year", year);
	}

	_CalcDate();

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

void _CalcDate()
{
	int i,j,len,year,month,day,holiday;
	struct DateStruct ds;

	ds = ACR_ConvertDate();

	SetGlobalInt("ACR_FR_Year", ds.year);
	SetGlobalInt("ACR_FR_Month", ds.month);
	SetGlobalInt("ACR_FR_Day", ds.day);
	SetGlobalInt("ACR_FR_Holiday", ds.holiday);
}

struct DateStruct ACR_ConvertDate(int year=0, int month=0, int day=0)
{
	int holiday = 0, leap;
	struct DateStruct ds;

	// Harptos Calendar
	// ----------------
	//
	// 30	- Hammer [Deepwinter]
	// 1	- Midwinter
	// 30	- Aluriak [The Claw(s) of Winter/The Cold]
	// 30	- Ches (18, Spring Equinox) [The Claw of the Sunsets]
	// 30	- Tarsakh [The Claw of the Storms]
	// 1	- Greengrass
	// 30	- Mirtul [The Melting]
	// 30	- Kythorn (20, Summer Solstice) [The Time of Flowers]
	// 30	- Flamerule [Summertide]
	// 1	- Midsummer
	// 1 	- Shieldmeet (leap only)
	// 30	- Eleasias [Highsun]
	// 30	- Eleint (21, Autumn Equinox) [The Fading]
	// 1	- Highharvestide
	// 30	- Marpenoth [Leafall]
	// 30	- Uktar [The Rotting]
	// 1	- Feast of the Moon
	// 30	- Nightal (20, Winter Solstice) [The Drawing Down]
	
	if (year == 0)
		year = GetGlobalInt("ACR_Year");
	if (month == 0)
		month = GetGlobalInt("ACR_Month");
	if (day == 0)
		day = GetGlobalInt("ACR_Day");

	leap = !((year - ALFA2_RL_YEAR_START) % 4);

	day += month > 11 ? 30 : 0;
	day += month > 10 ? 31 : 0;
	day += month > 9 ? 30 : 0;
	day += month > 8 ? 31 : 0;
	day += month > 7 ? 31 : 0;
	day += month > 6 ? 30 : 0;
	day += month > 5 ? 31 : 0;
	day += month > 4 ? 30 : 0;
	day += month > 3 ? 31 : 0;
	day += month > 2 ? 28 + leap : 0;
	day += month > 1 ? 31 : 0;

	if (day <= 30) {
		month = 1;
	}
	// midwinter
	else if (day == 30 + 1) {
		month = 0;
		day = 0;
		holiday = 1;
	}
	else if (day <= 31 + 30) {
		month = 2;
		day -= 31;
	}
	else if (day <= 61 + 30) {
		month = 3;
		day -= 61;
		if (day == 18)
			holiday = 2;
	}
	else if (day <= 91 + 30) {
		month = 4;
		day -= 91;
	}
	// greengrass
	else if (day <= 121 + 1) {
		month = 0;
		day = 0;
		holiday = 3;
	}
	else if (day <= 122 + 30) {
		month = 5;
		day -= 122;
	}
	else if (day <= 152 + 30) {
		month = 6;
		day -= 152;
		if (day == 20)
			holiday = 4;
	}
	else if (day <= 182 + 30) {
		month = 7;
		day -= 182;
	}
	// midsummer
	else if (day <= 212 + 1) {
		month = 0;
		day = 0;
		holiday = 5;
	}
	// shieldmeet, leap
	else if (leap && (day <= 213 + 1)) {
		month = 0;
		day = 0;
		holiday = 6;
	}
	// calculate w/ leap offset
	else {
		if (leap)
			day--;

		if (day <= 213 + 30) {
			month = 8;
			day -= 213;
		}
		else if (day <= 243 + 30) {
			month = 9;
			day -= 243;
			if (day == 21)
				holiday = 7;
		}
		// highharvestide
		else if (day <= 273 + 1) {
			month = 0;
			day = 0;
			holiday = 8;
		}
		else if (day <= 274 + 30) {
			month = 10;
			day -= 274;
		}
		else if (day <= 304 + 30) {
			month = 11;
			day -= 304;
		}
		// feast of the moon
		else if (day <= 334 + 1) {
			month = 0;
			day = 0;
			holiday = 9;
		}
		else {
			month = 12;
			day -= 335;
			if (day == 20)
				holiday = 10;
		}
	}

	year -= (ALFA2_RL_YEAR_START - ALFA2_FR_YEAR_START);
	
	ds.year = year;
	ds.month = month;
	ds.day = day;
	ds.holiday = holiday;

	return ds;
}

int ACR_GetFRYear()
{
	return GetGlobalInt("ACR_FR_Year");
}

string ACR_GetFRYearName(int year=0)
{
	string str = "Year of";
	if (year == 0)
		year = ACR_GetFRYear();

	str += " ";

	switch (year) {
		case 1370:
			str += "the Tankard";
			break;
		case 1371:
			str += "the Unstrung Harp";
			break;
		case 1372:
			str += "Wild Magic";
			break;
		case 1373:
			str += "Rogue Dragons";
			break;
		case 1374:
			str += "Lightning Storms";
			break;
		case 1375:
			str += "Risen Elfkin";
			break;
		case 1376:
			str += "the Bent Blade";
			break;
		case 1377:
			str += "the Haunting";
			break;
		case 1378:
			str += "the Cauldron";
			break;
		case 1379:
			str += "the Lost Keep";
			break;
		case 1380:
			str += "the Blazing Hand";
			break;
		case 1381:
			str += "Starving";
			break;
		case 1382:
			str += "the Black Blazon";
			break;
		case 1383:
			str += "the Vindicated Warrior";
			break;
		case 1384:
			str += "Three Streams Blooded";
			break;
		case 1385:
			str += "Blue Fire";
			break;
		case 1386:
			str += "the Halflings' Lament";
			break;
		case 1387:
			str += "the Emerald Ermine";
			break;
		case 1388:
			str += "the Tanarukka";
			break;
		case 1389:
			str += "the Forgiven Foes";
			break;
		case 1390:
			str += "the Walking Man";
			break;
		case 1391:
			str += "the Wrathful Eye";
			break;
		case 1392:
			str += "the Scroll";
			break;
		case 1393:
			str += "the Ring";
			break;
		case 1394:
			str += "Deaths Unmourned";
			break;
		case 1395:
			str += "Silent Death";
			break;
		case 1396:
			str += "the Secret";
			break;
		case 1397:
			str += "the Quill";
			break;
		case 1398:
			str += "the Voyage";
			break;
		case 1399:
			str += "the Fallen Friends";
			break;
		case 1400:
			str += "Lost Ships";
			break;
		default:
			str += "invalid year";
	}

	return str;
}

int ACR_GetFRMonth()
{
	return GetGlobalInt("ACR_FR_Month");
}

int ACR_GetFRDay()
{
	return GetGlobalInt("ACR_FR_Day");
}

int ACR_GetDayOfTenday(int day = -1)
{
	if (day == -1)
		day = GetGlobalInt("ACR_FR_Day");

	if (day == 0)
		return 0;

	return (day%10);
}

int ACR_GetFRWeekday()
{
	return ACR_GetDayOfTenday();
}

int ACR_GetFRHoliday()
{
	return GetGlobalInt("ACR_FR_Holiday");
}

string ACR_FRDateToString(int full=1,int informal=0, int year=0, int month=0, int day=0, int holiday=0)
{
	int tenday;
	string str="",tenday_str,day_str,year_str,month_str,holiday_str;

	if (year == 0) {
		year = GetGlobalInt("ACR_FR_Year");
		month = GetGlobalInt("ACR_FR_Month");
		day = GetGlobalInt("ACR_FR_Day");
		holiday = GetGlobalInt("ACR_FR_Holiday");
	}

	tenday = ACR_GetDayOfTenday(day);
	
	/* Tenday isn't actually 0, it's 10 on a non-holiday */
	if (!holiday && !tenday)
		tenday = 10;


	switch (tenday) {
		case 1:
			tenday_str = "First-day";
			break;
		case 2:
			tenday_str = "Second-day";
			break;
		case 3:
			tenday_str = "Third-day";
			break;
		case 4:
			tenday_str = "Fourth-day";
			break;
		case 5:
			tenday_str = "Fifth-day";
			break;
		case 6:
			tenday_str = "Sixth-day";
			break;
		case 7:
			tenday_str = "Seventh-day";
			break;
		case 8:
			tenday_str = "Eighth-day";
			break;
		case 9:
			tenday_str = "Ninth-day";
			break;
		case 10:
			tenday_str = "Tenth-day";
			break;
		default:
			tenday_str = "";
	}

	switch (month) {
		case 1:
			month_str = informal ? "Deepwinter" : "Hammer";
			break;
		case 2:
			month_str = informal ? "The Claw of Winter" : "Aluriak";
			break;
		case 3:
			month_str = informal ? "The Claw of the Sunsets" : "Ches";
			break;
		case 4:
			month_str = informal ? "The Claw of the Storms" : "Tarsakh";
			break;
		case 5:
			month_str = informal ? "The Melting" : "Mirtul";
			break;
		case 6:
			month_str = informal ? "The Time of Flowers" : "Kythorn";
			break;
		case 7:
			month_str = informal ? "Summertide" : "Flamerule";
			break;
		case 8:
			month_str = informal ? "Highsun" : "Eleasias";
			break;
		case 9:
			month_str = informal ? "The Fading" : "Eleint";
			break;
		case 10:
			month_str = informal ? "Leafall" : "Marpenoth";
			break;
		case 11:
			month_str = informal ? "The Rotting" : "Uktar";
			break;
		case 12:
			month_str = informal ? "The Drawing Down" : "Nightal";
			break;
		default:
			month_str = "";
	}

	
	switch (holiday) {
		case 1:
			holiday_str = "Midwinter";
			break;
		case 2:
			holiday_str = "Spring Equinox";
			break;
		case 3:
			holiday_str = "Greengrass";
			break;
		case 4:
			holiday_str = "Summer Solstice";
			break;
		case 5:
			holiday_str = "Midsummer";
			break;
		case 6:
			holiday_str = "Shieldmeet";
			break;
		case 7:
			holiday_str = "Autumn Equinox";
			break;
		case 8:
			holiday_str = "Highharvestide";
			break;
		case 9:
			holiday_str = "Feast of the Moon";
			break;
		case 10:
			holiday_str = "Winter Solstice";
			break;
		default:
			holiday_str = "";
	}

	day_str = IntToString(day);
	year_str = IntToString(year);

	if (full) {
		if (holiday_str != "")
			str += holiday_str + " ";

		if (tenday_str != "")
			str += tenday_str + ", " + month_str + " " + day_str + ", ";

		str += ACR_GetFRYearName(year);
		str += " ("+year_str+" DR)";
	}
	else {
		month_str = IntToString(month);

		if (holiday_str != "")
			str += holiday_str + " ";

		if (tenday_str != "")
			str += day_str + "/" + month_str + "/";

		str += GetStringRight(year_str,2);
	}

	return str;
}

#endif
