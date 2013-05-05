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

namespace ACR_Traps
{
    public partial class ACR_Traps : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Traps([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Traps([In] ACR_Traps Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int), typeof(float), typeof(float), typeof(float), typeof(uint), typeof(int), typeof(int), typeof(float), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(uint), typeof(int), typeof(int), typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Value = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)

            TrapEvent currentEvent = (TrapEvent)ScriptParameters[0];

            switch (currentEvent)
            {
                case TrapEvent.CreateGeneric:
                    {
                        NWLocation loc = Location((uint)ScriptParameters[4], Vector((float)ScriptParameters[1], (float)ScriptParameters[2], (float)ScriptParameters[3]), 0.0f);
                        TriggerArea triggerArea = (TriggerArea)ScriptParameters[5];
                        int effectArea = (int)ScriptParameters[6];
                        float effectSize = (float)ScriptParameters[7];
                        int damageType = (int)ScriptParameters[8];
                        int diceNumber = (int)ScriptParameters[9];
                        int diceType = (int)ScriptParameters[10];
                        int saveDC = (int)ScriptParameters[11];
                        int attackBonus = (int)ScriptParameters[12];
                        int numberOfShots = (int)ScriptParameters[13];
                        uint trapOrigin = (uint)ScriptParameters[14];
                        int targetAlignment = (int)ScriptParameters[15];
                        int targetRace = (int)ScriptParameters[16];
                        int minimumToTrigger = (int)ScriptParameters[17];
                        CreateTraps.GenericDamage(this, loc, triggerArea, effectArea, effectSize, damageType, diceNumber, diceType, saveDC, attackBonus, numberOfShots, trapOrigin, targetAlignment, targetRace, minimumToTrigger);
                        break;
                    }
                case TrapEvent.CreateSpell:
                    {
                        NWLocation loc = Location((uint)ScriptParameters[4], Vector((float)ScriptParameters[1], (float)ScriptParameters[2], (float)ScriptParameters[3]), 0.0f);
                        TriggerArea triggerArea = (TriggerArea)ScriptParameters[5];
                        int spellId = (int)ScriptParameters[8];
                        int numberOfShots = (int)ScriptParameters[13];
                        uint trapOrigin = (uint)ScriptParameters[14];
                        int targetAlignment = (int)ScriptParameters[15];
                        int targetRace = (int)ScriptParameters[16];
                        int minimumToTrigger = (int)ScriptParameters[17];
                        CreateTraps.Spell(this, loc, triggerArea, spellId, numberOfShots, trapOrigin, targetAlignment, targetRace, minimumToTrigger);
                        break;
                    }
            }

            SendMessageToAllDMs(String.Format("ACR_Traps fired: {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}, {14}, {15}, {16}", ScriptParameters[0], ScriptParameters[1], ScriptParameters[2], ScriptParameters[3], ScriptParameters[4], ScriptParameters[5], ScriptParameters[6], ScriptParameters[7], ScriptParameters[8], ScriptParameters[9], ScriptParameters[10], ScriptParameters[11], ScriptParameters[12], ScriptParameters[13], ScriptParameters[14], ScriptParameters[15], ScriptParameters[16]));
            return 0;
        }

    }
}
