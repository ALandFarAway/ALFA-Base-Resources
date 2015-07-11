using System;
using System.Collections.Generic;

using NWN2Toolset.NWN2.Data;

namespace ACR_BuilderPlugin.Helpers
{
    class VariableHelper
    {

        //
        // Boolean - Nonstandard NWN2 type. A non-zero integer is true.
        //

        #region Boolean
        public static bool GetBoolean(NWN2ScriptVarTable variables, string name)
        {
            return GetInteger(variables, name) != 0;
        }

        public static void SetBoolean(NWN2ScriptVarTable variables, string name, bool value)
        {
            SetInteger(variables, name, Convert.ToInt32(value));
        }
        #endregion

        //
        // Float
        //

        #region Float
        public static float GetFloat(NWN2ScriptVarTable variables, string name)
        {
            try
            {
                return variables.GetVariable(name).ValueFloat;
            }
            catch
            {
                return 0.0f;
            }
        }

        public static void SetFloat(NWN2ScriptVarTable variables, string name, float value)
        {
            try
            {
                variables.GetVariable(name).ValueFloat = value;
                variables.GetVariable(name).VariableType = NWN2ScriptVariableType.Float;
            }
            catch
            {
                NWN2ScriptVariable var = new NWN2ScriptVariable(name, value);
                var.VariableType = NWN2ScriptVariableType.Float;
                variables.Add(var);
            }
        }
        #endregion

        //
        // Integer
        //

        #region Integer
        public static int GetInteger(NWN2ScriptVarTable variables, string name)
        {
            try
            {
                return variables.GetVariable(name).ValueInt;
            }
            catch
            {
                return 0;
            }
        }

        public static void SetInteger(NWN2ScriptVarTable variables, string name, int value)
        {
            try
            {
                variables.GetVariable(name).ValueInt = value;
                variables.GetVariable(name).VariableType = NWN2ScriptVariableType.Int;
            }
            catch
            {
                NWN2ScriptVariable var = new NWN2ScriptVariable(name, value);
                var.VariableType = NWN2ScriptVariableType.Int;
                variables.Add(var);
            }
        }
        #endregion

        //
        // String
        //

        #region String
        public static string GetString(NWN2ScriptVarTable variables, string name)
        {
            try
            {
                return variables.GetVariable(name).ValueString;
            }
            catch
            {
                return "";
            }
        }

        public static void SetString(NWN2ScriptVarTable variables, string name, string value)
        {
            try
            {
                variables.GetVariable(name).ValueString = value;
                variables.GetVariable(name).VariableType = NWN2ScriptVariableType.String;
            }
            catch
            {
                NWN2ScriptVariable var = new NWN2ScriptVariable(name, value);
                var.VariableType = NWN2ScriptVariableType.String;
                variables.Add(var);
            }
        }
        #endregion

        //
        // String Array - Nonstandard NWN2 type. '*' is replaced with a variable index.
        // Note: Index starts at 1!
        //

        #region String Array
        public static string[] GetStringArray(NWN2ScriptVarTable variables, string name)
        {
            try
            {
                List<string> ret = new List<string>();
                for (uint i = 1; i < uint.MaxValue; i++)
                {
                    string val = GetString(variables, name.Replace("*", i.ToString()));
                    if (val == "")
                        break;
                    ret.Add(val);
                }
                return ret.ToArray();
            }
            catch
            {
                return new string[] {};
            }
        }

        public static void SetStringArray(NWN2ScriptVarTable variables, string name, string[] value)
        {
            try
            {
                DeleteStringArray(variables, name);
                for (uint i = 1; i <= value.Length; i++)
                {
                    SetString(variables, name.Replace("*", i.ToString()), value[i-1]);
                }
            }
            catch
            {

            }
        }

        public static void DeleteStringArray(NWN2ScriptVarTable variables, string name)
        {
            try
            {
                for (uint i = 1; i < uint.MaxValue; i++)
                {
                    NWN2ScriptVariable var = variables.GetVariable(name.Replace("*", i.ToString()));
                    if (var.VariableType == NWN2ScriptVariableType.None)
                        break;
                    variables.Remove(var);
                }
            }
            catch
            {

            }
        }
        #endregion
    }
}
