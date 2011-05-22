// ga_death
/*
    This script makes objects appear dead
        sTag        = The tag(s) of the object(s) to make dead. You can pass multiple
                      tags, seperated by commas (NO SPACES) to make multiple objects dead
                      (ie. "Object1,Object2,Object3")
        iInstance   = The instance of the object(s) to make dead. Pass -1 to make
                      all instances dead.
*/
// TDE 3/7/05
// BMA-OEI 1/11/06 removed default param
// TDE 8/3/06 - Set Immortal and Plot flags to FALSE, Added some debug strings
// TDE 8/28/06 - Changed SetIsDestroyable to (FALSE, FALSE, TRUE) so that the corpses can be looted

#include "ginc_debug"

void Death(string sTagString, int iInstance = 0)
{
	PrettyDebug("Applying Death Effect To: " + sTagString + " Instance = " + IntToString(iInstance));		
    if (iInstance == -1)
    {
        int iInst;
        object oObject;
        while (GetIsObjectValid(GetObjectByTag(sTagString, iInst)))
        {
            oObject = GetObjectByTag(sTagString, iInst);

            AssignCommand(oObject, SetIsDestroyable( FALSE,FALSE,TRUE ));
		    SetImmortal( oObject, FALSE );
		    SetPlotFlag( oObject, FALSE );
            effect eFX = EffectDeath();
			PrettyDebug("Name of oObject = " + GetName(oObject));		
            ApplyEffectToObject( DURATION_TYPE_INSTANT,eFX,oObject );
            iInst ++;
        }
    }
    else
    {
        object oObject = GetObjectByTag(sTagString, iInstance);

        AssignCommand(oObject, SetIsDestroyable( FALSE,FALSE,TRUE ));
	    SetImmortal( oObject, FALSE );
	    SetPlotFlag( oObject, FALSE );
        effect eFX = EffectDeath();
		PrettyDebug("Name of oObject = " + GetName(oObject));		
        ApplyEffectToObject( DURATION_TYPE_INSTANT,eFX,oObject );
    }
}

void main(string sTagString, int iInstance)
{
    string newString = sTagString;
    int iLen = GetStringLength(sTagString);

    //find first comma
    int CommaPos = FindSubString( newString, "," );

    while(CommaPos != -1)
    {
        string tempString = GetSubString(newString, 0, CommaPos);

        Death(tempString, iInstance);
        newString = GetSubString(newString, CommaPos + 1, iLen);
        iLen = GetStringLength(newString);
        CommaPos = FindSubString( newString, "," );
    }

    //newString is equal to last tag to destroy
    Death(newString, iInstance);
}