// gc_range_year
/*
	Description:
	Checks to see if the current year is within the specified year range.
	The default starting year is 1372
	int iStartYear - start of range
	int iEndYear - end of range
*/
// ChazM 11/27/06

#include "ginc_time"
int StartingConditional(int iStartYear, int iEndYear)
{
	return (IsCurrentYearInRange(iStartYear, iEndYear));
}