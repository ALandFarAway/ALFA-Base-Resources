// ga_refresh_timedate_tokens
/*
	Update a number of custom time/date tokens for use.
	
	Custom Tokens can be used in conversation text like so:
	"The time is <CUSTOM250>"
	
	Time Tokens:
	250 - Formatted Time
	251 - hours
	252 - minutes
	253 - seconds
	254 - millisecs
	
	Date Tokens:
	269 - Formatted Date
	261 - Year
	262 - Year Name
	263 - Month 
	264 - Month Name
	265 - Day
	266 - Day Name	
	267 - Season Name	
	
*/
// ChazM 11/21/06




#include "ginc_time"

void main()
{
	struct CTimeDate rTimeDate = GetCurrentCTimeDate();
	//ActionSpeakString("The date is: " + GetFRDisplayDate(rTimeDate) + " and the time is " + GetFRDisplayTime(rTimeDate));

	SetCustomToken (250, GetFRDisplayTime(rTimeDate));
	SetCustomToken (251, IntToString(rTimeDate.iHour));// hours
	SetCustomToken (252, IntToString(rTimeDate.iMinute));// mins
	SetCustomToken (253, IntToString(rTimeDate.iSecond));// sec
	SetCustomToken (254, IntToString(rTimeDate.iMillisecond));// millisec
	
	SetCustomToken (260, GetFRDisplayDate(rTimeDate));
	SetCustomToken (261, IntToString(rTimeDate.iYear)); //Year
	SetCustomToken (262, GetFRYearName(rTimeDate.iYear)); //Year Name
	SetCustomToken (263, IntToString(rTimeDate.iMonth)); //Month 
	SetCustomToken (264, GetFRMonthName(rTimeDate.iMonth)); //Month Name
	SetCustomToken (265, IntToString(rTimeDate.iDay)); //Day
	SetCustomToken (266, GetFRDayName(rTimeDate.iDay)); //Day Name
	SetCustomToken (267, GetFRSeasonName(GetFRSeason(rTimeDate))); //Season Name
}