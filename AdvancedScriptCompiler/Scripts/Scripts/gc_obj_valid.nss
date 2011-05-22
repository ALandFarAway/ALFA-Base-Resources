// gc_obj_valid(string sTag, int bAreaOnly)
/* 
   Determines if object is valid (e.g. exists, != OBJECT_INVALID). GetNearest may fail in case of searching the OWNER's tag.
   
   Parameters:
     string sTag   = The tag of the object to search for.
     int bAreaOnly = If =0 search entire module; otherwise search OWNER's area only.   
*/
// BMA 4/20/05
// BMA-OEI 8/26/05 swapped getobject/getnearest, changed parameters
// BMA-OEI 1/11/05 removed default params

int StartingConditional(string sTag, int bAreaOnly)
{
	object oObject;

	if (bAreaOnly == 0)
	{
		// Search module	
		oObject = GetObjectByTag(sTag);
	}
	else
	{
		// Search area from owner only
		oObject = GetNearestObjectByTag(sTag);
	}

	return GetIsObjectValid(oObject);
}