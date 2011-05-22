// gc_range_day
/*
	Description:
	Checks to see if the current time is within the specified day range.
	Each month has 28 days.
	int iStartDay - start of range
	int iEndDay - end of range
*/
// ChazM 11/27/06

#include "ginc_time"
int StartingConditional(int iStartDay, int iEndDay)
{
	return (IsCurrentDayInRange(iStartDay, iEndDay));
}