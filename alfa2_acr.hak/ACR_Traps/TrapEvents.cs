using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_Traps
{
    enum TrapEvent
    {
        CreateGeneric = 1,
        CreateSpell = 2,
        DetectEnter = 3,
        DetectExit = 4,
        TriggerEnter = 5,
        TriggerExit = 6
    }
}