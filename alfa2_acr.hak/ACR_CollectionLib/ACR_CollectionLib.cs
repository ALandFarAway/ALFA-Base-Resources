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

        // Generic array.
        private Dictionary<string, ArrayList> m_ArrayLists;

        // Lists for the NW data types.
        public Dictionary<string, List<int>> m_IntList;
        public Dictionary<string, List<float>> m_FloatList;
        public Dictionary<string, List<string>> m_StringList;
        public Dictionary<string, List<int>> m_ObjectList;

        // Dictionaries for NW data types.
        public Dictionary<string, Dictionary<string, int>> m_IntDict;
        public Dictionary<string, Dictionary<string, float>> m_FloatDict;
        public Dictionary<string, Dictionary<string, string>> m_StringDict;
        public Dictionary<string, Dictionary<string, int>> m_ObjectDict;

        // Queues for NWN2 data types.
        public Dictionary<string, Queue<int>> m_IntQueue;
        public Dictionary<string, Queue<float>> m_FloatQueue;
        public Dictionary<string, Queue<string>> m_StringQueue;
        public Dictionary<string, Queue<int>> m_ObjectQueue;

        // Stacks for NWN2 data types.
        public Dictionary<string, Stack<int>> m_IntStack;
        public Dictionary<string, Stack<float>> m_FloatStack;
        public Dictionary<string, Stack<string>> m_StringStack;
        public Dictionary<string, Stack<int>> m_ObjectStack;

        // Results.
        public int m_ResultInt;
        public float m_ResultFloat;
        public string m_ResultString;
        public int m_ResultObject;

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
            DELETE,
            ADD,
            CLEAR,
            CONTAINS,
            COUNT,
            ELEMENTAT,
            MAX,
            REVERSE,
            SUM
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

        public ACR_CollectionLib([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_CollectionLib([In] ACR_CollectionLib Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        // ACR_CollectionLib( COLLECTION_CODE nCollection, METHOD_CODE nMethodCode, string sCollectionName, int nParamInt1, int nParamInt2, float fParamFlt1, float fParamFlt2, string sParamStr1, string sParamStr2, int nParamObj1, int nParamObj2 );
        public static Type[] ScriptParameterTypes = { typeof(int), typeof(int), typeof(string), typeof(int), typeof(int), typeof(float), typeof(float), typeof(string), typeof(string), typeof(int), typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            // Parse our parameters.
            COLLECTION_CODE nCollection = (COLLECTION_CODE)ScriptParameters[0];
            METHOD_CODE nMethodCode = (METHOD_CODE)ScriptParameters[1];
            string sCollectionName = (string)ScriptParameters[2];
            int nParamInt1 = (int)ScriptParameters[3];
            int nParamInt2 = (int)ScriptParameters[4];
            float fParamFlt1 = (float)ScriptParameters[5];
            float fParamFlt2 = (float)ScriptParameters[6];
            string sParamStr1 = (string)ScriptParameters[7];
            string sParamStr2 = (string)ScriptParameters[8];
            int nParamObj1 = (int)ScriptParameters[9];
            int nParamObj2 = (int)ScriptParameters[10];

            // Return value.
            Int32 nReturnValue = DefaultReturnCode;

            // What type of request are we making?
            switch (nCollection)
            {
                case COLLECTION_CODE.INT_LIST:
                    HandleIntList(sCollectionName, nMethodCode, nParamInt1, nParamInt2);
                    break;
            }

            return nReturnValue;
        }

        private Int32 HandleIntList( string sCollectionName, METHOD_CODE nMethod, int nParam1, int nParam2 ) {
            Int32 nReturnValue = 0;

            switch (nMethod)
            {

            }

            return nReturnValue;
        }

    }
}
