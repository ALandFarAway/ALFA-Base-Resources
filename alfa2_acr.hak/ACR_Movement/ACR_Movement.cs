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

namespace ACR_Movement
{
    public partial class ACR_Movement : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Movement([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Movement([In] ACR_Movement Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int), typeof(uint) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Command = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)
            uint Target = (uint)ScriptParameters[1];

            if(!AppearanceTypes.characterMovement.ContainsKey(Target))
            {
                AppearanceTypes.characterMovement.Add(Target, AppearanceTypes.MovementType.Walking);
            }
            if(!AppearanceTypes.overlandMap.ContainsKey(Target))
            {
                AppearanceTypes.overlandMap.Add(Target, false);
            }

            switch((MovementCommand)Command)
            {
                case MovementCommand.EnterWater:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Swimming;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    Swimming.SwimTriggerEnter(this, Target, OBJECT_SELF);
                    break;
                case MovementCommand.ExitWater:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Walking;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.MountHorse:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Riding;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.CloakRemoved:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Walking;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.ToOverlandMap:
                    AppearanceTypes.overlandMap[Target] = true;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.FromOverlandMap:
                    AppearanceTypes.overlandMap[Target] = false;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
            }

            return 0;
        }

        enum MovementCommand
        {
            EnterWater = 0,
            ExitWater = 1,
            MountHorse = 2,
            CloakRemoved = 3,
            ToOverlandMap = 4,
            FromOverlandMap = 5,
        }

    }
}
