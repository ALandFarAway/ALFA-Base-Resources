// ga_global_float
/*
   This script changes a global float variable's value
   
   Parameters:
     string sVariable   = Name of variable to change
     string sChange     = VALUE	  (EFFECT)
	 					  "5.1"   (Set to 5.1)
						  "=-2.3" (Set to -2.3)
						  "+3.0"  (Add 3.0)
						  "+"     (Add 1.0)
						  "++"    (Add 1.0)
						  "-4.9"  (Subtract 4.9)
						  "-"     (Subtract 1.0)
						  "--"    (Subtract 1.0)
*/
// FAB 10/7
// BMA 4/15/05 added set operator, "=n"

void main(string sVariable, string sChange )
{
    float fChange;
	
	if (GetStringLeft(sChange, 1) == "=")
	{
		// BMA 4/15/05
		sChange = GetStringRight(sChange, GetStringLength(sChange) - 1);
		fChange = StringToFloat(sChange);	
	}
    else if (GetStringLeft(sChange, 1) == "+")
    {
        // If sChange is just "+" then default to increment by 1
        if (GetStringLength(sChange) == 1)
        {
            fChange = GetGlobalFloat(sVariable) + 1.0;
        }
        else    // This means there's more than just "+"
        {
            if (GetSubString(sChange, 1, 1) == "+")     // "++" condition
            {
                fChange = GetGlobalFloat(sVariable) + 1.0;
            }
            else
            {
                sChange = GetStringRight(sChange, GetStringLength(sChange) - 1);
                fChange = StringToFloat(sChange) + GetGlobalFloat(sVariable);
            }
        }
    }
    else if (GetStringLeft(sChange, 1) == "-")
    {
        // If sChange is just "-" then default to increment by 1
        if (GetStringLength(sChange) == 1)
        {
            fChange = GetGlobalFloat(sVariable) - 1.0;
        }
        else    // This means there's more than just "-"
        {
            if (GetSubString(sChange, 1, 1) == "-")     // "--" condition
            {
                fChange = GetGlobalFloat(sVariable) - 1.0;
            }
            else
            {
                sChange = GetStringRight(sChange, GetStringLength(sChange) - 1);
                fChange = GetGlobalFloat(sVariable) - StringToFloat(sChange);
            }
        }
    }
    else
    {
        fChange = StringToFloat(sChange);
        if (sChange == "") fChange = GetGlobalFloat(sVariable) + 1.0;
    }

    
	SetGlobalFloat(sVariable, fChange);
}

