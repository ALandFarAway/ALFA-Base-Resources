// ga_time_advance
/*
	Advance time by amount indicated
	
	Time can only be advanced forwards; attempting to set the time backwards will result in the day advancing and 
	then the time being set to that specified.
	
	nHour - The number of hours to advance.
	nMinute - The number of Minutes to advance.
	nSecond - The number of Seconds to advance.
	nMillisecond - The number of Milliseconds to advance.
*/
// ChazM 6/27/06

void main(int nHour, int nMinute, int nSecond, int nMillisecond)
{
    nHour 			= GetTimeHour() + nHour;
    nMinute 		= GetTimeMinute() + nMinute;
    nSecond 		= GetTimeSecond() + nSecond;
    nMillisecond 	= GetTimeMillisecond() + nMillisecond;

    // Set the new time
    SetTime(nHour, nMinute, nSecond, nMillisecond);
}

