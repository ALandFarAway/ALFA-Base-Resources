using System;
using System.Collections;
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

namespace ACR_CollectionLib
{
    public partial class ACR_CollectionLib : CLRScriptBase, IGeneratedScriptProgram
    {
        // Lists for the NW data types.
        private static Dictionary<string, List<int>> m_IntList = new Dictionary<string, List<int>>();
        public static Dictionary<string, List<float>> m_FloatList = new Dictionary<string, List<float>>();
        public static Dictionary<string, List<string>> m_StringList = new Dictionary<string, List<string>>();
        //public Dictionary<string, List<int>> m_ObjectList;

        // Dictionaries for NW data types.
        //public Dictionary<string, Dictionary<string, int>> m_IntDict;
        //public Dictionary<string, Dictionary<string, float>> m_FloatDict;
        //public Dictionary<string, Dictionary<string, string>> m_StringDict;
        //public Dictionary<string, Dictionary<string, int>> m_ObjectDict;

        // Queues for NWN2 data types.
        //public Dictionary<string, Queue<int>> m_IntQueue;
        //public Dictionary<string, Queue<float>> m_FloatQueue;
        //public Dictionary<string, Queue<string>> m_StringQueue;
        //public Dictionary<string, Queue<int>> m_ObjectQueue;

        // Stacks for NWN2 data types.
        //public Dictionary<string, Stack<int>> m_IntStack;
        //public Dictionary<string, Stack<float>> m_FloatStack;
        //public Dictionary<string, Stack<string>> m_StringStack;
        //public Dictionary<string, Stack<int>> m_ObjectStack;

        /// <summary>
        /// Define type codes for request collection types to ScriptMain.
        /// </summary>
        private enum COLLECTION_CODE
        {
            ARRAY_LIST,
            INT_LIST,
            FLOAT_LIST,
            STRING_LIST,
            OBJECT_LIST,
            INT_DICTIONARY,
            FLOAT_DICTIONARY,
            STRING_DICTIONARY,
            OBJECT_DICTIONARY,
            INT_QUEUE,
            FLOAT_QUEUE,
            STRING_QUEUE,
            OBJECT_QUEUE,
            INT_STACK,
            FLOAT_STACK,
            STRING_STACK,
            OBJECT_STACK,
            RESULT
        }

        private enum METHOD_CODE
        {
            CREATE,
            CREATE_IF_NOT_EXISTS,
            DELETE,
            DELETE_IF_EXISTS,
            EXISTS,
            ADD,
            COUNT,
            CLEAR,
            CONTAINS,
            CONTAINS_KEY,
            CONTAINS_VALUE,
            ELEMENT_AT,
            FIND,
            FIND_LAST,
            FIRST,
            INDEX_OF,
            INSERT,
            LAST,
            LAST_INDEX_OF,
            MAX,
            MIN,
            PEEK,
            POP,
            PUSH,
            REMOVE,
            REMOVE_AT,
            REMOVE_RANGE,
            REVERSE,
            SET_AT_INDEX,
            SORT,
            SUM
        }

        private enum RETURN_CODE
        {
            SUCCESS = 0,
            ERROR_NAME_CONFLICT = -3400,
            ERROR_COLLECTION_EXISTS = -3401,
            ERROR_COLLECTION_DOES_NOT_EXIST = -3402,
            ERROR_COLLECTION_NO_METHOD = -3403,
            ERROR_COLLECTION_NOT_FOUND = -3404
        }

        /// <summary>
        /// Define type codes for request collection types to ScriptMain.
        /// </summary>
        private enum DATA_TYPE
        {
            INT,
            FLOAT,
            STRING,
            OBJECT
        }

        // Module variables for return values.
        const string ACR_COLLECTION_RESULT_VAR_INT = "ACR_COLLECTION_RES_INT";
        const string ACR_COLLECTION_RESULT_VAR_FLOAT = "ACR_COLLECTION_RES_FLT";
        const string ACR_COLLECTION_RESULT_VAR_STRING = "ACR_COLLECTION_RES_STR";
        const string ACR_COLLECTION_RESULT_VAR_OBJECT = "ACR_COLLECTION_RES_OBJ";

        public ACR_CollectionLib([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_CollectionLib([In] ACR_CollectionLib Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        // ACR_CollectionLib( COLLECTION_CODE nCollection, METHOD_CODE nMethodCode, string sCollectionName, int nParamInt1, int nParamInt2, float fParamFlt1, float fParamFlt2, string sParamStr1, string sParamStr2 );
        public static Type[] ScriptParameterTypes = { typeof(int), typeof(int), typeof(string), typeof(int), typeof(int), typeof(float), typeof(float), typeof(string), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            // Parse our parameters.
            int nCollection = (int)ScriptParameters[0];
            int nMethodCode = (int)ScriptParameters[1];
            string sCollectionName = (string)ScriptParameters[2];
            int nParamInt1 = (int)ScriptParameters[3];
            int nParamInt2 = (int)ScriptParameters[4];
            float fParamFlt1 = (float)ScriptParameters[5];
            float fParamFlt2 = (float)ScriptParameters[6];
            string sParamStr1 = (string)ScriptParameters[7];
            string sParamStr2 = (string)ScriptParameters[8];

            // Return value.
            Int32 nReturnValue = (int)RETURN_CODE.SUCCESS;

            // What type of request are we making?
            switch ((COLLECTION_CODE)nCollection)
            {
                case COLLECTION_CODE.INT_LIST:
                    nReturnValue = HandleIntList(sCollectionName, (METHOD_CODE)nMethodCode, nParamInt1, nParamInt2);
                    break;
                case COLLECTION_CODE.FLOAT_LIST:
                    nReturnValue = HandleFloatList(sCollectionName, (METHOD_CODE)nMethodCode, fParamFlt1, nParamInt1, nParamInt2);
                    break;
                case COLLECTION_CODE.STRING_LIST:
                    nReturnValue = HandleStringList(sCollectionName, (METHOD_CODE)nMethodCode, sParamStr1, nParamInt1, nParamInt2);
                    break;
                default:
                    nReturnValue = (int)RETURN_CODE.ERROR_COLLECTION_NOT_FOUND;
                    break;
            }

            return nReturnValue;
        }

        private void SetReturnInt(int nValue)
        {
            SetLocalInt(GetModule(), ACR_COLLECTION_RESULT_VAR_INT, nValue);
        }

        private void SetReturnFloat(float fValue)
        {
            SetLocalFloat(GetModule(), ACR_COLLECTION_RESULT_VAR_FLOAT, fValue);
        }

        private void SetReturnString(string sValue)
        {
            SetLocalString(GetModule(), ACR_COLLECTION_RESULT_VAR_STRING, sValue);
        }

        private void SetReturnObject(uint uValue)
        {
            SetLocalObject(GetModule(), ACR_COLLECTION_RESULT_VAR_OBJECT, uValue);
        }

        private Int32 HandleIntList(string sCollectionName, METHOD_CODE nMethodCode, int nParam1, int nParam2)
        {
            Int32 nReturnValue = (int)RETURN_CODE.SUCCESS;

            // Make sure the collection does (or does not) exist.
            if (nMethodCode == METHOD_CODE.CREATE && m_IntList.ContainsKey(sCollectionName))
            {
                // This collection already exists.
                return (int)RETURN_CODE.ERROR_COLLECTION_EXISTS;
            }
            else if (nMethodCode == METHOD_CODE.CREATE_IF_NOT_EXISTS && m_IntList.ContainsKey(sCollectionName))
            {
                return (int)RETURN_CODE.SUCCESS;
            }
            else if (nMethodCode == METHOD_CODE.DELETE_IF_EXISTS && !m_IntList.ContainsKey(sCollectionName))
            {
                return (int)RETURN_CODE.SUCCESS;
            }
            else if (nMethodCode == METHOD_CODE.EXISTS)
            {
                SetReturnInt(Convert.ToInt32(m_IntList.ContainsKey(sCollectionName)));
                return (int)RETURN_CODE.SUCCESS;
            }

            // Switch out the DELETE_IF and CREATE_IF functions.
            if (nMethodCode == METHOD_CODE.CREATE_IF_NOT_EXISTS) nMethodCode = METHOD_CODE.CREATE;
            else if (nMethodCode == METHOD_CODE.DELETE_IF_EXISTS) nMethodCode = METHOD_CODE.DELETE;

            // Unless we're creating the collection, make sure it exists.
            if (nMethodCode != METHOD_CODE.CREATE && !m_IntList.ContainsKey(sCollectionName))
            {
                // Collection does not exist, cannot be accessed.
                return (int)RETURN_CODE.ERROR_COLLECTION_DOES_NOT_EXIST;
            }

            // Handle the request.
            switch (nMethodCode)
            {
                case METHOD_CODE.CREATE:
                    m_IntList.Add(sCollectionName, new List<int>());
                    break;
                case METHOD_CODE.DELETE:
                    m_IntList.Remove(sCollectionName);
                    break;
                case METHOD_CODE.ADD:
                    m_IntList[sCollectionName].Add(nParam1);
                    break;
                case METHOD_CODE.CLEAR:
                    m_IntList[sCollectionName].Clear();
                    break;
                case METHOD_CODE.CONTAINS:
                    SetReturnInt(Convert.ToInt32(m_IntList[sCollectionName].Contains(nParam1)));
                    break;
                case METHOD_CODE.COUNT:
                    SetReturnInt(m_IntList[sCollectionName].Count());
                    break;
                case METHOD_CODE.ELEMENT_AT:
                    SetReturnInt(m_IntList[sCollectionName].ElementAt(nParam1));
                    break;
                case METHOD_CODE.FIRST:
                    SetReturnInt(m_IntList[sCollectionName].First());
                    break;
                case METHOD_CODE.INDEX_OF:
                    SetReturnInt(m_IntList[sCollectionName].IndexOf(nParam1));
                    break;
                case METHOD_CODE.INSERT:
                    m_IntList[sCollectionName].Insert(nParam1, nParam2);
                    break;
                case METHOD_CODE.MAX:
                    SetReturnInt(m_IntList[sCollectionName].Max());
                    break;
                case METHOD_CODE.MIN:
                    SetReturnInt(m_IntList[sCollectionName].Min());
                    break;
                case METHOD_CODE.REMOVE:
                    m_IntList[sCollectionName].Remove(nParam1);
                    break;
                case METHOD_CODE.REMOVE_AT:
                    m_IntList[sCollectionName].RemoveAt(nParam1);
                    break;
                case METHOD_CODE.REMOVE_RANGE:
                    m_IntList[sCollectionName].RemoveRange(nParam1, nParam2);
                    break;
                case METHOD_CODE.REVERSE:
                    m_IntList[sCollectionName].Reverse();
                    break;
                case METHOD_CODE.SORT:
                    m_IntList[sCollectionName].Sort();
                    break;
                case METHOD_CODE.SUM:
                    SetReturnInt(m_IntList[sCollectionName].Sum());
                    break;
                default:
                    nReturnValue = (int)RETURN_CODE.ERROR_COLLECTION_NO_METHOD;
                    break;
            }

            return nReturnValue;
        }

        private Int32 HandleFloatList(string sCollectionName, METHOD_CODE nMethodCode, float fParam1, int nParam1, int nParam2)
        {
            Int32 nReturnValue = (int)RETURN_CODE.SUCCESS;

            // Make sure the collection does (or does not) exist.
            if (nMethodCode == METHOD_CODE.CREATE && m_FloatList.ContainsKey(sCollectionName))
            {
                // This collection already exists.
                return (int)RETURN_CODE.ERROR_COLLECTION_EXISTS;
            }
            else if (nMethodCode == METHOD_CODE.CREATE_IF_NOT_EXISTS && m_FloatList.ContainsKey(sCollectionName))
            {
                return (int)RETURN_CODE.SUCCESS;
            }
            else if (nMethodCode == METHOD_CODE.DELETE_IF_EXISTS && !m_FloatList.ContainsKey(sCollectionName))
            {
                return (int)RETURN_CODE.SUCCESS;
            }
            else if (nMethodCode == METHOD_CODE.EXISTS)
            {
                SetReturnInt(Convert.ToInt32(m_FloatList.ContainsKey(sCollectionName)));
                return (int)RETURN_CODE.SUCCESS;
            }

            // Switch out the DELETE_IF and CREATE_IF functions.
            if (nMethodCode == METHOD_CODE.CREATE_IF_NOT_EXISTS) nMethodCode = METHOD_CODE.CREATE;
            else if (nMethodCode == METHOD_CODE.DELETE_IF_EXISTS) nMethodCode = METHOD_CODE.DELETE;

            // Unless we're creating the collection, make sure it exists.
            if (nMethodCode != METHOD_CODE.CREATE && !m_FloatList.ContainsKey(sCollectionName))
            {
                // Collection does not exist, cannot be accessed.
                return (int)RETURN_CODE.ERROR_COLLECTION_DOES_NOT_EXIST;
            }

            // Handle the request.
            switch (nMethodCode)
            {
                case METHOD_CODE.CREATE:
                    m_FloatList.Add(sCollectionName, new List<float>());
                    break;
                case METHOD_CODE.DELETE:
                    m_FloatList.Remove(sCollectionName);
                    break;
                case METHOD_CODE.ADD:
                    m_FloatList[sCollectionName].Add(fParam1);
                    break;
                case METHOD_CODE.CLEAR:
                    m_FloatList[sCollectionName].Clear();
                    break;
                case METHOD_CODE.CONTAINS:
                    SetReturnInt(Convert.ToInt32(m_FloatList[sCollectionName].Contains(fParam1)));
                    break;
                case METHOD_CODE.COUNT:
                    SetReturnInt(m_FloatList[sCollectionName].Count());
                    break;
                case METHOD_CODE.ELEMENT_AT:
                    SetReturnFloat(m_FloatList[sCollectionName].ElementAt(nParam1));
                    break;
                case METHOD_CODE.FIRST:
                    SetReturnFloat(m_FloatList[sCollectionName].First());
                    break;
                case METHOD_CODE.INDEX_OF:
                    SetReturnInt(m_FloatList[sCollectionName].IndexOf(fParam1));
                    break;
                case METHOD_CODE.INSERT:
                    m_FloatList[sCollectionName].Insert(nParam1, fParam1);
                    break;
                case METHOD_CODE.MAX:
                    SetReturnFloat(m_FloatList[sCollectionName].Max());
                    break;
                case METHOD_CODE.MIN:
                    SetReturnFloat(m_FloatList[sCollectionName].Min());
                    break;
                case METHOD_CODE.REMOVE:
                    m_FloatList[sCollectionName].Remove(fParam1);
                    break;
                case METHOD_CODE.REMOVE_AT:
                    m_FloatList[sCollectionName].RemoveAt(nParam1);
                    break;
                case METHOD_CODE.REMOVE_RANGE:
                    m_FloatList[sCollectionName].RemoveRange(nParam1, nParam2);
                    break;
                case METHOD_CODE.REVERSE:
                    m_FloatList[sCollectionName].Reverse();
                    break;
                case METHOD_CODE.SORT:
                    m_FloatList[sCollectionName].Sort();
                    break;
                case METHOD_CODE.SUM:
                    SetReturnFloat(m_FloatList[sCollectionName].Sum());
                    break;
                default:
                    nReturnValue = (int)RETURN_CODE.ERROR_COLLECTION_NO_METHOD;
                    break;
            }

            return nReturnValue;
        }

        private Int32 HandleStringList(string sCollectionName, METHOD_CODE nMethodCode, string sParam1, int nParam1, int nParam2)
        {
            Int32 nReturnValue = (int)RETURN_CODE.SUCCESS;

            // Make sure the collection does (or does not) exist.
            if (nMethodCode == METHOD_CODE.CREATE && m_StringList.ContainsKey(sCollectionName))
            {
                // This collection already exists.
                return (int)RETURN_CODE.ERROR_COLLECTION_EXISTS;
            }
            else if (nMethodCode == METHOD_CODE.CREATE_IF_NOT_EXISTS && m_StringList.ContainsKey(sCollectionName))
            {
                return (int)RETURN_CODE.SUCCESS;
            }
            else if (nMethodCode == METHOD_CODE.DELETE_IF_EXISTS && !m_StringList.ContainsKey(sCollectionName))
            {
                return (int)RETURN_CODE.SUCCESS;
            }
            else if (nMethodCode == METHOD_CODE.EXISTS)
            {
                SetReturnInt(Convert.ToInt32(m_StringList.ContainsKey(sCollectionName)));
                return (int)RETURN_CODE.SUCCESS;
            }

            // Switch out the DELETE_IF and CREATE_IF functions.
            if (nMethodCode == METHOD_CODE.CREATE_IF_NOT_EXISTS) nMethodCode = METHOD_CODE.CREATE;
            else if (nMethodCode == METHOD_CODE.DELETE_IF_EXISTS) nMethodCode = METHOD_CODE.DELETE;

            // Unless we're creating the collection, make sure it exists.
            if (nMethodCode != METHOD_CODE.CREATE && !m_StringList.ContainsKey(sCollectionName))
            {
                // Collection does not exist, cannot be accessed.
                return (int)RETURN_CODE.ERROR_COLLECTION_DOES_NOT_EXIST;
            }

            // Handle the request.
            switch (nMethodCode)
            {
                case METHOD_CODE.CREATE:
                    m_StringList.Add(sCollectionName, new List<string>());
                    break;
                case METHOD_CODE.DELETE:
                    m_StringList.Remove(sCollectionName);
                    break;
                case METHOD_CODE.ADD:
                    m_StringList[sCollectionName].Add(sParam1);
                    break;
                case METHOD_CODE.CLEAR:
                    m_StringList[sCollectionName].Clear();
                    break;
                case METHOD_CODE.CONTAINS:
                    SetReturnInt(Convert.ToInt32(m_StringList[sCollectionName].Contains(sParam1)));
                    break;
                case METHOD_CODE.COUNT:
                    SetReturnInt(m_StringList[sCollectionName].Count());
                    break;
                case METHOD_CODE.ELEMENT_AT:
                    SetReturnString(m_StringList[sCollectionName].ElementAt(nParam1));
                    break;
                case METHOD_CODE.FIRST:
                    SetReturnString(m_StringList[sCollectionName].First());
                    break;
                case METHOD_CODE.INDEX_OF:
                    SetReturnInt(m_StringList[sCollectionName].IndexOf(sParam1));
                    break;
                case METHOD_CODE.INSERT:
                    m_StringList[sCollectionName].Insert(nParam1, sParam1);
                    break;
                case METHOD_CODE.REMOVE:
                    m_StringList[sCollectionName].Remove(sParam1);
                    break;
                case METHOD_CODE.REMOVE_AT:
                    m_StringList[sCollectionName].RemoveAt(nParam1);
                    break;
                case METHOD_CODE.REMOVE_RANGE:
                    m_StringList[sCollectionName].RemoveRange(nParam1, nParam2);
                    break;
                case METHOD_CODE.REVERSE:
                    m_StringList[sCollectionName].Reverse();
                    break;
                case METHOD_CODE.SORT:
                    m_StringList[sCollectionName].Sort();
                    break;
                default:
                    nReturnValue = (int)RETURN_CODE.ERROR_COLLECTION_NO_METHOD;
                    break;
            }

            return nReturnValue;
        }

    }
}
