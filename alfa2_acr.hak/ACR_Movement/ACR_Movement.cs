﻿using System;
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
            if(!AppearanceTypes.currentSwimTrigger.ContainsKey(Target))
            {
                AppearanceTypes.currentSwimTrigger.Add(Target, OBJECT_INVALID);
            }

            switch((MovementCommand)Command)
            {
                case MovementCommand.EnterWater:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Swimming;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    if (GetIsObjectValid(AppearanceTypes.currentSwimTrigger[Target]) == CLRScriptBase.TRUE)
                    {
                        AppearanceTypes.currentSwimTrigger[Target] = OBJECT_SELF;
                    }
                    else
                    {
                        AppearanceTypes.currentSwimTrigger[Target] = OBJECT_SELF;
                        Swimming.SwimTriggerEnter(this, Target);
                    }
                    break;
                case MovementCommand.ExitWater:
                    break;
                case MovementCommand.MountHorse:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Riding;
                    Riding.MountHorse(this, Target, OBJECT_SELF);
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.CloakRemoved:
                    if (Riding.isWarhorse.ContainsKey(Target))
                    {
                        AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Walking;
                        Riding.Dismount(this, Target, GetPCItemLastUnequipped(), GetLocation(Target));
                        AppearanceTypes.RecalculateMovement(this, Target);
                    }
                    break;
                case MovementCommand.ToOverlandMap:
                    AppearanceTypes.overlandMap[Target] = true;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.FromOverlandMap:
                    AppearanceTypes.overlandMap[Target] = false;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.Dismount:
                    if(Riding.isWarhorse.ContainsKey(Target))
                    {
                        AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Walking;
                        AppearanceTypes.RecalculateMovement(this, Target);
                        Riding.Dismount(this, Target, GetItemInSlot(INVENTORY_SLOT_CLOAK, Target), GetLocation(OBJECT_SELF));
                    }
                    break;
                case MovementCommand.ForceRecalculate:
                    AppearanceTypes.RecalculateMovement(this, Target);
                    break;
                case MovementCommand.RestoreHorse:
                    AppearanceTypes.characterMovement[Target] = AppearanceTypes.MovementType.Riding;
                    AppearanceTypes.RecalculateMovement(this, Target);
                    if (!Riding.isWarhorse.ContainsKey(Target)) Riding.isWarhorse.Add(Target, true);
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
            Dismount = 6,
            ForceRecalculate = 7,
            RestoreHorse = 8
        }

    }
}
