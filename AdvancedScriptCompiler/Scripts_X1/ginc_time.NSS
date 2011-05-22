// ginc_time
/*
	Time library
	Includes support functions for "Time Events"
*/
// ChazM 11/17/06
// ChazM 1/10/07 Added NormalizeCTimeDate(), GetMinutesPerHour(); added prototypes
// ChazM 3/1/07 Num hours passed now saved when HasHourChanged() called
// ChazM 5/31/07 Added UpdateClock()
// ChazM 6/1/07 Added various Clock GUI functions
// MDiekmann 6/6/07 - Added support for clock GUI popup
// ChazM 6/7/07 - HasHourChanged() and CheckTime() now return number of Hours passed; added switches include.
// ChazM 6/22/07 - make friendly with ginc_autosave
// ChazM 7/2/07 - HasHourChanged() updated to calculate both the campaign hours and the module hours
// ChazM 7/25/07 - modified CheckTime(), HasHourChanged() - fix for time updates on module first entry

//void main(){}
//-------------------------------------------------
// Includes
//-------------------------------------------------

#include "ginc_debug"
#include "ginc_group"
#include "x2_inc_switches"
#include "ginc_autosave"

//-------------------------------------------------
// Structures
//-------------------------------------------------

struct CTimeDate
{
    int iYear;
	int iMonth;
    int iDay;
	int iHour;
	int iMinute;
	int iSecond;
	int iMillisecond;
};

// prefix: rhp
struct CHoursPassed
{
    int nNumModuleHoursPassed;
 	int nNumCampaignHoursPassed;
};
//-------------------------------------------------
// Constants
//-------------------------------------------------

const int EVENT_TIME_EVENT 			= 1012;

//Display Format Constants
const int M_D_Y_TEXT				= 1;
const int M_D_Y_SLASHES				= 2;
const int D_M_Y_TEXT				= 3;
const int D_M_Y_SLASHES				= 4;
const int Y_M_D_TEXT				= 5;
const int Y_M_D_SLASHES				= 6;

const string VAR_PREVIOUS_HOUR 		= "PREVIOUS_HOUR";
const string TEN_GROUP_NAME 		= "TIME_EVENT_NOTIFY";
const string VAR_HOURS_PASSED       = "HOURS_PASSED";

const string TIME_2DA 						= "time";			// 2da
const string TIME_IMAGE_COL 				= "Image";			// string - image to display
const string TIME_NAME_COL 					= "Name";			// int - str ref

const string GUI_SCREEN_PLAYERMENU			= "SCREEN_PLAYERMENU";
const string GUI_PLAYERMENU_CLOCK_BUTTON 	= "CLOCK_BUTTON";
const string SCREEN_OL_FRAME 				= "SCREEN_OL_MENU";
const string OL_DETAIL_CLOCK				= "OL_CLOCK";
//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------


// CTimeDate functions
//-------------------------------------------------
int GetMinutesPerHour();
struct CTimeDate NormalizeCTimeDate(struct CTimeDate rTimeDate);
struct CTimeDate NewCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
struct CTimeDate GetCurrentCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
struct CTimeDate AddCTimeDate(struct CTimeDate rTimeDate1, struct CTimeDate rTimeDate2);
void SetCTimeDate(struct CTimeDate rTimeDate);

// Hash functions
//-------------------------------------------------
//int GetTimeHash( int nHours, int nDays );
//int GetTimeHashDifference( int nHash1, int nHash2 );
//int GetCurrentTimeHash();
struct CHoursPassed HasHourChanged();
int GetNumHoursPassed();

// Time Registration
//-------------------------------------------------
void NotifyRegisteredObject(object oObject);
void NotifyRegisteredObjects();
void SetUpTimeEvent(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0);
struct CHoursPassed CheckTime();
void RegisterForTimeEvent(object oObject);

// Clock GUI
//-------------------------------------------------
void SetClockOnForPlayer(object oPC, int bClockOn=TRUE, int bOLMap = FALSE);
void SetClockOnForAllPlayers(int bClockOn=TRUE, int bOLMap = FALSE);
void UpdateClockForPlayer(object oPC);
void UpdateClockForAllPlayers();

// Time & Date display
//-------------------------------------------------
int GetFRSeason(struct CTimeDate rTimeDate);
string GetFRSeasonName(int iSeason);
string GetFRYearName(int iYear);
string GetFRMonthName(int iMonth);
string GetFRDayName(int iDay);
string GetFRDisplayDate(struct CTimeDate rTimeDate);
string GetFRDisplayTime(struct CTimeDate rTimeDate);

// Clock Popup set time and date
//--------------------------------------------------
string GetClockDisplayDate(struct CTimeDate rTimeDate, int nDisplayFormat = M_D_Y_TEXT);
string GetClockDisplayTime(struct CTimeDate rTimeDate);
string GetClockDisplay(struct CTimeDate rTimeDate, int bTimeOnly);




// Range Checks
//-------------------------------------------------
int IsCurrentHourInRange(int iStartHour, int iEndHour);
int IsCurrentDayInRange(int iStartDay, int iEndDay);
int IsCurrentMonthInRange(int iStartMonth, int iEndMonth);
int IsCurrentYearInRange(int iStartYear, int iEndYear);


//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// CTimeDate functions
//-------------------------------------------------


// Return number of minutes set for module (1-59)
int GetMinutesPerHour()
{
	int iRet = FloatToInt(HoursToSeconds(1)/60.0f);
	return (iRet);
}	

// Normalize a time date to be within appropriate values.
// only handles overflow (not underflow)
struct CTimeDate NormalizeCTimeDate(struct CTimeDate rTimeDate)
{
	int iMinsPerHour = GetMinutesPerHour();

	// cascade overflow
	rTimeDate.iSecond 	+= rTimeDate.iMillisecond / 1000;	// MS = 0-999
	rTimeDate.iMinute 	+= rTimeDate.iSecond / 60;			// Sec = 0 - 59
	rTimeDate.iHour 	+= rTimeDate.iMinute  / iMinsPerHour;	// Min = 0-X
	rTimeDate.iDay 		+= rTimeDate.iHour / 24;			// Hour = 0-23
	if (rTimeDate.iDay >= 1)
		rTimeDate.iMonth 	+= (rTimeDate.iDay-1) / 28;			// Day = 1-28
	if (rTimeDate.iMonth >= 1)
		rTimeDate.iYear 	+= (rTimeDate.iMonth-1) / 12;		// Month = 1-12
	
	// remove overflow
	rTimeDate.iMillisecond	%= 1000;
	rTimeDate.iSecond 		%= 60;
	rTimeDate.iMinute 		%= iMinsPerHour;
	rTimeDate.iHour 		%= 24;	
	if (rTimeDate.iDay >= 1)
		rTimeDate.iDay 			= ((rTimeDate.iDay-1) % 28) + 1;
	if (rTimeDate.iMonth >= 1)
		rTimeDate.iMonth 		= ((rTimeDate.iMonth-1) % 12) + 1;
	
	return (rTimeDate);
}


// return an unnormalized CTimeDate 
struct CTimeDate NewCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate;
	
	rTimeDate.iYear 		= iYear;
	rTimeDate.iMonth 		= iMonth;
	rTimeDate.iDay 			= iDay;
	rTimeDate.iHour 		= iHour;
	rTimeDate.iMinute 		= iMinute;
	rTimeDate.iSecond 		= iSecond;
	rTimeDate.iMillisecond 	= iMillisecond;

	return (rTimeDate);
}

// the params for this indicate additonal offset.
// return an unnormalized CTimeDate 
struct CTimeDate GetCurrentCTimeDate(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate;
	
	rTimeDate.iYear 		= GetCalendarYear()		+ iYear;
	rTimeDate.iMonth 		= GetCalendarMonth()	+ iMonth;
	rTimeDate.iDay 			= GetCalendarDay()		+ iDay;
	rTimeDate.iHour 		= GetTimeHour()			+ iHour;
	rTimeDate.iMinute 		= GetTimeMinute()		+ iMinute;
	rTimeDate.iSecond 		= GetTimeSecond()		+ iSecond;
	rTimeDate.iMillisecond 	= GetTimeMillisecond()	+ iMillisecond;

	return (rTimeDate);
}

// return an unnormalized CTimeDate 
struct CTimeDate AddCTimeDate(struct CTimeDate rTimeDate1, struct CTimeDate rTimeDate2)
{
	struct CTimeDate rTimeDate;
	
	rTimeDate.iYear 		= rTimeDate1.iYear + rTimeDate2.iYear;
	rTimeDate.iMonth 		= rTimeDate1.iMonth + rTimeDate2.iMonth;
	rTimeDate.iDay 			= rTimeDate1.iDay + rTimeDate2.iDay;
	rTimeDate.iHour 		= rTimeDate1.iHour + rTimeDate2.iHour;
	rTimeDate.iMinute 		= rTimeDate1.iMinute + rTimeDate2.iMinute;
	rTimeDate.iSecond 		= rTimeDate1.iSecond + rTimeDate2.iSecond;
	rTimeDate.iMillisecond 	= rTimeDate1.iMillisecond + rTimeDate2.iMillisecond;

	return (rTimeDate);
}

// Sets the time and date.  The TimeDate does not need to be normalized.
// The overflow values for any field will advance the next field.
// Note: if the time is set previous to what it currently is this will cause the day to advance.  Becuase 
// of this, care should be taken when incrementing by very small units (seconds & milliseconds).
void SetCTimeDate(struct CTimeDate rTimeDate)
{
	int iYear		= rTimeDate.iYear;
	int iMonth		= rTimeDate.iMonth;
	int iDay		= rTimeDate.iDay;	
	
	SetCalendar(iYear, iMonth, iDay);

	int iHour		= rTimeDate.iHour; 	
	int iMinute		= rTimeDate.iMinute;
	int iSecond		= rTimeDate.iSecond;
	int iMillisecond= rTimeDate.iMillisecond;
	
	SetTime (iHour, iMinute, iSecond, iMillisecond);
}


// Hash functions
//-------------------------------------------------

/*
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

*/
// Does module perceive that the hour has changed?  
// returns number of module hours passed (number of campaign hours passed is also stored)
struct CHoursPassed HasHourChanged()
{
	struct CHoursPassed rHP;
	int nNumModuleHoursPassed = 0;
	int nNumCampaignHoursPassed = 0;
	
	// What time is it?
	int nCurrentHour = GetCurrentTimeHash();	
	
	// we save this as a local on the module.  A campaign has multiple modules,
	// and when returning to a module, all the registered objects need to be notified of 
	// the amount of time that has passed.
    object oModule = GetModule();
	int nPreviousModuleHour = GetLocalInt(oModule, VAR_PREVIOUS_HOUR);
	int nPreviousCampaignHour = GetGlobalInt(VAR_PREVIOUS_HOUR);

	PrettyDebug ("nCurrentHour = " + IntToString(nCurrentHour));
	PrettyDebug ("nPreviousModuleHour = " + IntToString(nPreviousModuleHour));
	PrettyDebug ("nPreviousCampaignHour = " + IntToString(nPreviousCampaignHour));
	
	// time updates are never 0, so this module has not been initialized yet.
	if (nPreviousModuleHour == 0)
	{
		// initialize previous hour as being the current hour
		nPreviousModuleHour = nCurrentHour;
		SetLocalInt(oModule, VAR_PREVIOUS_HOUR, nPreviousModuleHour);
	}
	
	// time updates are never 0, so this campaign has not been initialized yet.
	if (nPreviousCampaignHour == 0)
	{
		// initialize previous hour as being the current hour
		nPreviousCampaignHour = nCurrentHour;
		SetGlobalInt(VAR_PREVIOUS_HOUR, nPreviousCampaignHour);
	}
	
	
	// return false if the time has not incremented.
	// Note that the number of module hours may change even if the number of campaign hours has not 
	// (but not vice versa - except when module hours is 0)
	if (nCurrentHour == nPreviousModuleHour)
		nNumModuleHoursPassed = 0;
	else
	{
		// return true if time has changed, and note the new "previous hour"
        // and number of hours passed
		SetLocalInt(oModule, VAR_PREVIOUS_HOUR, nCurrentHour);
      	nNumModuleHoursPassed = GetTimeHashDifference(nCurrentHour, nPreviousModuleHour);
		SetLocalInt(oModule, VAR_HOURS_PASSED, nNumModuleHoursPassed);
	}
	
	if (nCurrentHour == nPreviousCampaignHour)
		nNumCampaignHoursPassed = 0;
	else
	{				
		SetGlobalInt(VAR_PREVIOUS_HOUR, nCurrentHour);
      	nNumCampaignHoursPassed = GetTimeHashDifference(nCurrentHour, nPreviousCampaignHour);
		SetGlobalInt(VAR_HOURS_PASSED, nNumCampaignHoursPassed);
	}		

	rHP.nNumModuleHoursPassed = nNumModuleHoursPassed;
	rHP.nNumCampaignHoursPassed = nNumCampaignHoursPassed;
	return (rHP);					
}


/*
int GetPreviousHour()
{
	int iPreviousHour = GetLocalInt(OBJECT_SELF, VAR_PREVIOUS_HOUR);
    
	// if Previous hour is 0, then it  has not been initialized yet.
	if (iPreviousHour == 0)
	{
		// initialize previous hour as being the current hour
		iPreviousHour = GetCurrentTimeHash();
		SetLocalInt(oModule, VAR_PREVIOUS_HOUR, iPreviousHour);
	}
    
    return (iPreviousHour);
}
*/
int GetNumHoursPassed()
{
    object oModule = GetModule();
	//int iCurrentHour = GetCurrentTimeHash();
    // this is not returning correct thing.
	//int iPreviousHour = GetLocalInt(OBJECT_SELF, VAR_PREVIOUS_HOUR);
	//int iNumHoursPassed = GetTimeHashDifference(iCurrentHour, iPreviousHour);
	//PrettyDebug ("GetNumHoursPassed(): iCurrentHour = " + IntToString(iCurrentHour) + "iPreviousHour = " + IntToString(iPreviousHour));
	//PrettyDebug("GetNumHoursPassed(): iNumHoursPassed = " + IntToString(iNumHoursPassed));
    int iNumHoursPassed = GetLocalInt(oModule, VAR_HOURS_PASSED);
	return (iNumHoursPassed);
}


// Time Registration
//-------------------------------------------------


// Notify the registered object
void NotifyRegisteredObject(object oObject)
{
	// SignalEvent(oObject, evTimeEvent)
	
	string sScript = "t_" + GetTag(oObject);
	ExecuteScript(sScript, oObject);
}

// fires time event on all registered objects
void NotifyRegisteredObjects()
{
	int i = 0;
	float fDelay;
	object oMember = GetFirstInGroup(TEN_GROUP_NAME);
  	event evTimeEvent = EventUserDefined(EVENT_TIME_EVENT);
	while (GetIsObjectValid(oMember))
	{
	 	// Spread the events out a little bit so the server doesn't get swamped
		// w/ event requests.
		// might want to base this on number of objects in group so delay never
		// gets to large
		i++;
		fDelay = IntToFloat(i) * 0.01f;
	
  		DelayCommand(fDelay, NotifyRegisteredObject(oMember));
		oMember = GetNextInGroup(TEN_GROUP_NAME);
	}
}


// Events are stored as module vars "EVENT_<X>" with the value being a string representation of the time.
void SetUpTimeEvent(int iYear=0, int iMonth=0, int iDay=0, int iHour=0, int iMinute=0, int iSecond=0, int iMillisecond=0)
{
	struct CTimeDate rTimeDate = NewCTimeDate(iYear, iMonth, iDay, iHour, iMinute, iSecond, iMillisecond);
	
	// insert event into sorted list.	
}


// Determine any scheduled TimeDate events that need to fire.
// TimeDate event data is stored in sorted order.  We check and fire all events that 
// are found to be <= current time.  We can stop processing when we find one > current time.
// The data is stored in 2 places - global vars for the player and companions, and the the current 
// module for all other objects.
void CheckTimeDateEvents()
{
	
}



// Registers object for hourly event notification
void RegisterForTimeEvent(object oObject)
{
	GroupAddMember(TEN_GROUP_NAME, oObject);	// need to fix problems w/ conflicting groups
		
}



// Clock GUI
//-------------------------------------------------

// Set clock on (or off) for a specific Player
void SetClockOnForPlayer(object oPC, int bClockOn=TRUE, int bOLMap = FALSE)
{	
	if(bOLMap)
	{
		int bHidden = !bClockOn;
		SetGUIObjectHidden(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, bHidden);
		// if turning on, then we should update it.
		if (bClockOn)
			UpdateClockForPlayer(oPC);	
	}
	
	else
	{
		int bHidden = !bClockOn;
		SetGUIObjectHidden(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, bHidden);
		// if turning on, then we should update it.
		if (bClockOn)
			UpdateClockForPlayer(oPC);
	}
	
}


// Set clock on (or off) for all Players
void SetClockOnForAllPlayers(int bClockOn=TRUE, int bOLMap = FALSE)
{	
	int bHidden = !bClockOn;
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC))
	{
		if(bOLMap)
			SetGUIObjectHidden(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, bHidden);
			
		else
			SetGUIObjectHidden(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, bHidden);

		//AssignCommand(oPC, SpeakString("Yes I am working"));
		oPC = GetNextPC();
	}
	// if turning on, then we should update it.
	if (bClockOn)
		UpdateClockForAllPlayers();
}

// update clock for a specific Player
void UpdateClockForPlayer(object oPC)
{
	int bTimeOnly = GetGlobalInt(CAMPAIGN_SWITCH_ONLY_SHOW_TIME);
	struct CTimeDate rTimeDate = GetCurrentCTimeDate();
	string sTime = GetClockDisplay(rTimeDate, bTimeOnly);
	SetLocalGUIVariable(oPC, GUI_SCREEN_PLAYERMENU, 1, sTime);
	string sImage = Get2DAString(TIME_2DA, TIME_IMAGE_COL, GetTimeHour());
	SetGUITexture(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
	SetGUITexture(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, sImage);
	SetLocalGUIVariable(oPC, SCREEN_OL_FRAME, 1, sTime);
	PrettyDebug("I AM WORKING");
}


// update clock for all Players
// if clock is off (hidden), updates won't take effect.
void UpdateClockForAllPlayers()
{	
	int bTimeOnly = GetGlobalInt(CAMPAIGN_SWITCH_ONLY_SHOW_TIME);
	struct CTimeDate rTimeDate = GetCurrentCTimeDate();
	string sTime = GetClockDisplay(rTimeDate, bTimeOnly);
	string sImage = Get2DAString(TIME_2DA, TIME_IMAGE_COL, GetTimeHour());
	object oPC = GetFirstPC();
	while(GetIsObjectValid(oPC))
	{
		SetGUITexture(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
		SetLocalGUIVariable(oPC, GUI_SCREEN_PLAYERMENU, 1, sTime);
		
		SetGUITexture(oPC, SCREEN_OL_FRAME, OL_DETAIL_CLOCK, sImage);
		SetLocalGUIVariable(oPC, SCREEN_OL_FRAME, 1, sTime);
		//PrettyDebug("I AM WORKING");
		//AssignCommand(oPC, SpeakString("Yes I am working"));
		oPC = GetNextPC();
	}
}

// check if we're ready to fire another event.
// can be called as often as desired.
struct CHoursPassed CheckTime()
{
	CheckTimeDateEvents();
	
	// exit if the time has not incremented.
	//int nNumHoursPassed = HasHourChanged();

	struct CHoursPassed rHP = HasHourChanged();
	int nNumModuleHoursPassed =	rHP.nNumModuleHoursPassed;
	//int nNumCampaignHoursPassed = rHP.nNumCampaignHoursPassed;

	if (nNumModuleHoursPassed != 0)
	{
		//Time has incremented so send notifications		
		NotifyRegisteredObjects();
	}
	//return (nNumHoursPassed);
	return (rHP);
	
}


// Time & Date display
//-------------------------------------------------

const int SEASON_WINTER = 1;
const int SEASON_SPRING = 2;
const int SEASON_SUMMER = 3;
const int SEASON_AUTUMN = 4;

int GetFRSeason(struct CTimeDate rTimeDate)
{
	int iMonth = rTimeDate.iMonth;
	int iDay = rTimeDate.iDay;
	
	int iRet;
	switch(iMonth)
	{
		case 1:	iRet = SEASON_WINTER; 		break;
		case 2: iRet = SEASON_WINTER; 		break;
		case 3: iRet = (iDay<19)? SEASON_WINTER: SEASON_SPRING;	 	break;
		case 4:	iRet = SEASON_SPRING; 		break;
		case 5: iRet = SEASON_SPRING; 		break;
		case 6: iRet = (iDay<20)? SEASON_SPRING: SEASON_SUMMER;	 	break;
		case 7:	iRet = SEASON_SUMMER; 		break;
		case 8: iRet = SEASON_SUMMER; 		break;
		case 9: iRet = (iDay<21)? SEASON_SUMMER: SEASON_AUTUMN;	 	break;
		case 10: iRet = SEASON_AUTUMN; 		break;
		case 11: iRet = SEASON_AUTUMN; 		break;
		case 12: iRet = (iDay<20)? SEASON_AUTUMN: SEASON_WINTER;	break;

	}
	return (iRet);
}


string GetFRSeasonName(int iSeason)
{
	int iRet;
	string sRet;
	switch(iSeason)
	{
		case SEASON_WINTER: iRet = 201125;	 	break;	//Winter
		case SEASON_SPRING: iRet = 201126;	 	break;	//Spring
		case SEASON_SUMMER: iRet = 201127; 		break;	//Summer
		case SEASON_AUTUMN: iRet = 201128; 		break;	//Fall
	
	}
	sRet = GetStringByStrRef(iRet);
	return (sRet);
}

// Returns the Forgotten Realms name of the year
string GetFRYearName(int iYear)
{
	int iRet;
	string sRet;
	switch(iYear)
	{
		case 1372: iRet = 201116; 		break;	//The Year of Wild Magic
		case 1373: iRet = 201117; 		break;	//The Year of Rogue Dragons
		case 1374: iRet = 201118; 		break;	//The Year of Lightning Storms
		case 1375: iRet = 201119; 		break;	//The Year of Risen Elfkin
		case 1376: iRet = 201120; 		break;	//The Year of the Bent Blade
		case 1377: iRet = 201121; 		break;	//The Year of the Haunting
		case 1378: iRet = 201122; 		break;	//The Year of the Cauldron
		case 1379: iRet = 201123; 		break;	//The Year of the Lost Keep
		case 1380: iRet = 201124; 		break;	//The Year of the Blazing Hand
		default:   iRet = 0;			break;	//Bad String
	}
	sRet = GetStringByStrRef(iRet);
	return (sRet);
}



// Returns the Forgotten Realms name of the month
string GetFRMonthName(int iMonth)
{
	int iRet;
	string sRet;
	switch(iMonth)
	{
		case 1: iRet = 201101; 			break;	//Hammer
		case 2: iRet = 201102;	 		break;	//Alturiak
		case 3: iRet = 201103; 			break;	//Ches
		case 4: iRet = 201104;	 		break;	//Tarsakh
		case 5: iRet = 201106;	 		break;	//Mirtul
		case 6: iRet = 201108; 			break;	//Kythorn
		case 7: iRet = 201109; 			break;	//Flamerule
		case 8: iRet = 201110; 			break;	//Eleasis
		case 9: iRet = 201111; 			break;	//Eleint
		case 10: iRet = 201112;	 		break;	//Marpenoth
		case 11: iRet = 201113;	 		break;	//Uktar
		case 12: iRet = 201114;	 		break;	//Nightal
	}
	sRet = GetStringByStrRef(iRet);
	return (sRet);
}

// Returns the Forgotten Realms name of the day
string GetFRDayName(int iDay)
{
	int iRet;
	string sRet;
	switch(iDay)
	{
		case 1: iRet = 201129; 		break;	//first-day
		case 2: iRet = 201130; 		break;	//second-day
		case 3: iRet = 201131; 		break;	//third-day
		case 4: iRet = 201132; 		break;	//fourth-day
		case 5: iRet = 201133; 		break;	//fifth-day
		case 6: iRet = 201134; 		break;	//sixth-day
		case 7: iRet = 201135; 		break;	//seventh-day
		case 8: iRet = 201136; 		break;	//eighth-day
		case 9: iRet = 201137; 		break;	//ninth-day
		case 10: iRet = 201138; 		break;	//tenth-day
	}
	GetStringByStrRef(iRet);
	return (sRet);
}

// The date in standard Forgotten Realms format
string GetFRDisplayDate(struct CTimeDate rTimeDate)
{
	string sOut;
	sOut += IntToString(rTimeDate.iYear) + " ";
	sOut += GetFRYearName(rTimeDate.iYear) + " ";
	sOut += GetFRMonthName(rTimeDate.iMonth) + " ";
	sOut += IntToString(rTimeDate.iDay);
	
	return (sOut);	
}

// The time in standard Forgotten Realms format
string GetFRDisplayTime(struct CTimeDate rTimeDate)
{
	string sOut;
	sOut += IntToString(rTimeDate.iHour) + ":";
	sOut += IntToString(rTimeDate.iMinute) + ":";
	sOut += IntToString(rTimeDate.iSecond) + ".";
	sOut += IntToString(rTimeDate.iMillisecond);
	
	return (sOut);
}

// The date in clock format
string GetClockDisplayDate(struct CTimeDate rTimeDate, int nDisplayFormat = M_D_Y_TEXT)
{
	string sOut;
	switch (nDisplayFormat)
	{
		case M_D_Y_TEXT:
			sOut += GetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iDay) + ", ";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case M_D_Y_SLASHES:
			sOut += IntToString(rTimeDate.iMonth) + "/";
			sOut += IntToString(rTimeDate.iDay) + "/";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case D_M_Y_TEXT:
			sOut += IntToString(rTimeDate.iDay) + " ";
			sOut += GetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case D_M_Y_SLASHES:
			sOut += IntToString(rTimeDate.iDay) + "/";
			sOut += IntToString(rTimeDate.iMonth) + "/";
			sOut += IntToString(rTimeDate.iYear);
		break;
		
		case Y_M_D_TEXT:
			sOut += IntToString(rTimeDate.iYear) + " ";
			sOut += GetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iDay);
		break;
		
		case Y_M_D_SLASHES:
			sOut += IntToString(rTimeDate.iYear) + "/";
			sOut += IntToString(rTimeDate.iMonth) + "/";
			sOut += IntToString(rTimeDate.iDay);
		break;
		
		default:
			sOut += GetFRMonthName(rTimeDate.iMonth) + " ";
			sOut += IntToString(rTimeDate.iDay) + ", ";
			sOut += IntToString(rTimeDate.iYear);
		break;
	}	
	return (sOut);	
}

// The time in clock format
string GetClockDisplayTime(struct CTimeDate rTimeDate)
{
	string sOut;
	int iTimeRef = StringToInt(Get2DAString(TIME_2DA, TIME_NAME_COL, rTimeDate.iHour));
	int iHourRef = 201139;
	//time of day
	sOut += GetStringByStrRef(iTimeRef) + " - ";
	//"Hour: "
	sOut += GetStringByStrRef(iHourRef);
	//digit representing hour
	sOut += " " + IntToString(rTimeDate.iHour);	
	return (sOut);
}

string GetClockDisplay(struct CTimeDate rTimeDate, int bTimeOnly)
{
	string sOut;
	string sTest = GetStringByStrRef(0);
	string sYear = GetFRYearName(rTimeDate.iYear);
	sOut += GetClockDisplayTime(rTimeDate);
	if(!bTimeOnly)
	{
		sOut += "\n" + GetClockDisplayDate(rTimeDate, M_D_Y_TEXT);
		if(sYear != sTest)
		{
			sOut += "\n" + sYear;
		}	
	}	
	return (sOut);
}





// Range Checks
//-------------------------------------------------


// check if current hour is in specified range
int IsCurrentHourInRange(int iStartHour, int iEndHour)
{
	int iCurrentTime = GetTimeHour();	
	return (IsIntInRange(iCurrentTime, iStartHour, iEndHour));
}

// check if current day is in specified range
int IsCurrentDayInRange(int iStartDay, int iEndDay)
{
	int iCurrentDay = GetCalendarDay();
	return (IsIntInRange(iCurrentDay, iStartDay, iEndDay));
}

// check if current month is in specified range
int IsCurrentMonthInRange(int iStartMonth, int iEndMonth)
{
	int iCurrentMonth = GetCalendarMonth();
	return (IsIntInRange(iCurrentMonth, iStartMonth, iEndMonth));
}

// check if current year is in specified range
int IsCurrentYearInRange(int iStartYear, int iEndYear)
{
	int iCurrentYear = GetCalendarYear();
	return (IsIntInRange(iCurrentYear, iStartYear, iEndYear));
}