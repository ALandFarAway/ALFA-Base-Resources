// gr_manipulate_time 
/*
	Manipulates time based on choices in conversation
	looks at these local vars:
		"DirectionOfUnits"
		"TypeOfUnits"
		"NumberOfUnits"
*/
// ChazM 3/30/07

#include "ginc_time"
// #include "ginc_debug"
void main()
{
	PrettyDebug("manipulate_time() called");
	string sDirectionOfUnits = GetLocalString(OBJECT_SELF, "DirectionOfUnits");
	string sTypeOfUnits = GetLocalString(OBJECT_SELF, "TypeOfUnits");
	int iNumberOfUnits = GetLocalInt(OBJECT_SELF, "NumberOfUnits");
	if (sDirectionOfUnits == "B")
		iNumberOfUnits *= -1;
		
	//if (iNumberOfUnits <=0)
	//	return;
		
	int iYear=0;
	int iMonth=0;
	int iDay=0;
	int iHour=0;
	
	if (sTypeOfUnits == "Y")
		iYear = iNumberOfUnits;
	else if (sTypeOfUnits == "M")
		iMonth = iNumberOfUnits;
	else if (sTypeOfUnits == "D")
		iDay = iNumberOfUnits;
	else if (sTypeOfUnits == "H")
		iHour = iNumberOfUnits;

	//GetCurrentCTimeDate(iYear, iMonth, iDay, iHour);
	PrettyDebug("manipulate_time()  -- GetCurrentCTimeDate() ");
	SetCTimeDate(GetCurrentCTimeDate(iYear, iMonth, iDay, iHour));
	PrettyDebug("manipulate_time() finished ");

}