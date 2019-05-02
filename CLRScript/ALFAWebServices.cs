//
// This module contains logic for interacting with web service APIs exposed by
// the ALFA web server system.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{

    /// <summary>
    /// This class encapsulates access to the ALFA Web Services framework.
    /// </summary>
    public class WebServices
    {

        /// <summary>
        /// This method performs a synchronous request to the main web server
        /// in order to determine the public (external) network address of the
        /// server.
        /// 
        /// An exception is raised on failure.
        /// </summary>
        /// <returns>The server hostname is returned on success.</returns>
        public static string GetExternalHostname()
        {
            return GetExternalHostname(null);
        }

        /// <summary>
        /// This method performs a synchronous request to the main web server
        /// in order to determine the public (external) network address of the
        /// server.
        /// 
        /// An exception is raised on failure.
        /// </summary>
        /// <param name="ServiceURL">Optionally supplies the URL of the get
        /// hostname web service.</param>
        /// <returns>The server hostname is returned on success.</returns>
        public static string GetExternalHostname(string ServiceURL)
        {
            HttpWebRequest Request = (HttpWebRequest)WebRequest.Create(String.IsNullOrEmpty(ServiceURL) ? WebServicesURL + "myip.php" : ServiceURL);
            HttpWebResponse Response = (HttpWebResponse)Request.GetResponse();
            Stream ResponseStream = null;

            try
            {
                ResponseStream = Response.GetResponseStream();

                using (StreamReader Reader = new StreamReader(ResponseStream))
                {
                    string Address = Reader.ReadToEnd().Trim();
                    IPAddress Parsed;

                    if (!IPAddress.TryParse(Address, out Parsed))
                        throw new InvalidDataException("Invalid response received from myip.php web service: " + Address);

                    return Address;
                }
            }
            finally
            {
                if (ResponseStream != null)
                    ResponseStream.Close();

                Response.Close();
            }
        }



        /// <summary>
        /// This constant supplies the base URL for all ALFA web services.
        /// </summary>
        private static string WebServicesURL = "http://www.alandfaraway.info/";

    }   
}

