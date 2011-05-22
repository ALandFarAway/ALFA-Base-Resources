// ga_destroy
/*
    This script destroys objects
        sTag        = The tag(s) of the object(s) to destroy. You can pass multiple
                      tags, seperated by commas (NO SPACES) to destroy multiple objects
                      (ie. "Object1,Object2,Object3")
                      NOTE: There may eventually be a function to eat white space
                      (See Mantis 3296), but for now do not put spaces in the string.
        iInstance   = The instance of the object to destroy. Pass -1 to destroy
                      all instances.  Pass 0 to destroy the first instance.
        fDelay      = The delay before destroying the object(s)

*/
// TDE 3/7/05
// ChazM 3/8/05   - commented and tweaked.
// ChazM 6/7/05   - fixed bug, modified comment
// BMA-OEI 1/11/06 removed default param

void PrepForDestruction(object oTarget)
{
	SetPlotFlag(oTarget,FALSE);
    SetImmortal(oTarget,FALSE);
    AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
}

// detroy all objects (iInstance=-1) or a specific instance of object
void Destroy(string sTagString, int iInstance = 0, float fDelay = 0.0)
{
    if (iInstance == -1)
    {   // delete all objects
        int iInst = 0;
        object oObject = GetObjectByTag(sTagString, iInst);

        while (GetIsObjectValid(oObject))
        {
			PrepForDestruction(oObject);
            DestroyObject (oObject, fDelay);
            iInst ++;
            oObject = GetObjectByTag(sTagString, iInst);
        }
    }
    else
    {   // delete a specific instance of object
		object oTarget = GetObjectByTag(sTagString,iInstance);
		if(GetIsObjectValid(oTarget))
		{
			PrepForDestruction(oTarget);
        	DestroyObject (oTarget, fDelay);
		}
    }
}



void main(string sTagString, int iInstance, float fDelay)
{
    string sNewString = sTagString;
    int iLen = GetStringLength(sTagString);
    int iCommaPos = FindSubString( sNewString, "," ); //find first comma

    while(iCommaPos != -1)
    {
        // get first tag and destroy it
        string sTempString = GetSubString(sNewString , 0, iCommaPos);
        Destroy(sTempString, iInstance, fDelay);

        // drop first tag and comma
        sNewString  = GetSubString(sNewString, iCommaPos + 1, iLen);
        // determine new length
        iLen = GetStringLength(sNewString);
        // get next comma position (returns -1 if not found)
        iCommaPos = FindSubString(sNewString, "," );
    }

    //sNewString is equal to last tag to destroy
    Destroy(sNewString, iInstance, fDelay);
}


