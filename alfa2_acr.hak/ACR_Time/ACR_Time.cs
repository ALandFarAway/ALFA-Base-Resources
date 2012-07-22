using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Time
{
    public partial class ACR_Time : CLRScriptBase, IGeneratedScriptProgram
    {
        const int ACR_TIME_SECONDS_SINCE_START = 1;
        const int ACR_TIME_MINUTES_SINCE_START = 2;
        const int ACR_TIME_HOURS_SINCE_START = 3;
        const int ACR_TIME_DAYS_SINCE_START = 4;
        const int ACR_TIME_MONTHS_SINCE_START = 5;
        const int ACR_TIME_YEARS_SINCE_START = 6;
        
        private ACR_Time([In] ACR_Time Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Value = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)
            int retValue = -1;

            switch (Value)
            {
                case ACR_TIME_SECONDS_SINCE_START:
                    {
                        retValue = DateTime.Now.Second +
                            (DateTime.Now.Minute * 60) +
                            (DateTime.Now.Hour * 60 * 60) +
                            (DateTime.Now.Day * 24 * 60 * 60) +
                            (DaysUntilStartOfMonth(DateTime.Now.Month, DateTime.Now.Year) * 24 * 60 * 60) +
                            (DaysFrom2012UntilStartOfYear(DateTime.Now.Year) * 24 * 60 * 60);
                        break;
                    }
                case ACR_TIME_MINUTES_SINCE_START:
                    {
                        retValue = DateTime.Now.Minute +
                            (DateTime.Now.Hour * 60) +
                            (DateTime.Now.Day * 24 * 60) +
                            (DaysUntilStartOfMonth(DateTime.Now.Month, DateTime.Now.Year) * 24 * 60) +
                            (DaysFrom2012UntilStartOfYear(DateTime.Now.Year) * 24 * 60);
                        break;
                    }
                case ACR_TIME_HOURS_SINCE_START:
                    {
                        retValue = DateTime.Now.Hour +
                            (DateTime.Now.Day * 24) +
                            (DaysUntilStartOfMonth(DateTime.Now.Month, DateTime.Now.Year) * 24) +
                            (DaysFrom2012UntilStartOfYear(DateTime.Now.Year) * 24);
                        break;
                    }
                case ACR_TIME_DAYS_SINCE_START:
                    {
                        retValue = DateTime.Now.Day +
                            DaysUntilStartOfMonth(DateTime.Now.Month, DateTime.Now.Year) +
                            DaysFrom2012UntilStartOfYear(DateTime.Now.Year);
                        break;
                    }
                case ACR_TIME_MONTHS_SINCE_START:
                    {
                        retValue = DateTime.Now.Month +
                            (DateTime.Now.Year - 2012) * 12;
                        break;
                    }
                case ACR_TIME_YEARS_SINCE_START:
                    {
                        retValue = DateTime.Now.Year - 2012;
                        break;
                    }
            }
            PrintInteger(Value);
                    
            return retValue;
        }

        public int DaysUntilStartOfMonth(int currentMonth, int currentYear)
        {
            if (currentMonth == 1) return 0;

            int retValue = 31;
            if (currentMonth >= 3)
            {
                retValue += 28;
                if (GetIsLeapYear(currentYear)) retValue++;
            }
            else if (currentMonth >= 4) retValue += 31;
            else if (currentMonth >= 5) retValue += 30;
            else if (currentMonth >= 6) retValue += 31;
            else if (currentMonth >= 7) retValue += 30;
            else if (currentMonth >= 8) retValue += 31;
            else if (currentMonth >= 9) retValue += 31;
            else if (currentMonth >= 10) retValue += 30;
            else if (currentMonth >= 11) retValue += 31;
            else if (currentMonth >= 12) retValue += 30;

            return retValue;
        }

        public int DaysFrom2012UntilStartOfYear(int currentYear)
        {
            if (currentYear == 2012) return 0;

            int retValue = 0;
            for (int count = 2012; count < currentYear; count++)
            {
                if (GetIsLeapYear(count)) retValue++;
                retValue += 365;
            }
            return retValue;
        }

        public bool GetIsLeapYear(int currentYear)
        {
            bool retValue = false;
            if (currentYear % 4 == 0) retValue = true;
            if (currentYear % 100 == 0) retValue = false;
            if (currentYear % 400 == 0) retValue = true;

            return retValue;
        }
    }
}
