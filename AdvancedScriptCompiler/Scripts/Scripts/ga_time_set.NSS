// ga_time_set
/*
	Set time to to value indicated.
	
	Time can only be advanced forwards; attempting to set the time backwards will result in the day advancing and 
	then the time being set to that specified.
	
	nHour - The new hour value, from 0 to 23.
	nMinute - The new minute value from 0 to 1 (or 0 to a higher value if the module properties for time were changed).
	nSecond - The new second value, from 0 to 59.
	nMillisecond - The new millisecond value, from 0 to 999.
*/
// ChazM 6/27/06

void main(int nHour, int nMinute, int nSecond, int nMillisecond)
{
    // Set the new time
    SetTime(nHour, nMinute, nSecond, nMillisecond);
}
