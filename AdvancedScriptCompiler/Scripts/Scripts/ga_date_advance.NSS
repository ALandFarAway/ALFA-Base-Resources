// ga_date_advance
/*
	Advance date by amount indicated
	
	nYear - Number of years to advance.
	nMonth - Number of months to advance.
	nDay - Number of days to advance.
*/
// ChazM 6/27/06

void main(int nYear, int nMonth, int nDay)
{
    nYear 		= GetCalendarYear() + nYear;
    nMonth 		= GetCalendarMonth() + nMonth;
    nDay 		= GetCalendarDay() + nDay;

    // Set the new date
	SetCalendar(nYear, nMonth, nDay);
}


