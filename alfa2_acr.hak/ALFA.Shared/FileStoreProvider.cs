﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    /// <summary>
    /// This class provides access to internal file store providers.
    /// </summary>
    public static class FileStoreProvider
    {

        /// <summary>
        /// Create an Azure backend file store.
        /// </summary>
        /// <param name="ConnectionString">Supplies the connection string for
        /// the provider.</param>
        /// <returns>A FileStore object.</returns>
        public static FileStore CreateAzureFileStore(string ConnectionString)
        {
            return new AzureFileStore(ConnectionString);
        }

        /// <summary>
        /// The default vault connection string.  This is maintained by the
        /// ServerVaultConnector in ACR_ServerCommunicator when configuration
        /// is refreshed.  Its purpose is to allow components outside of the
        /// ACR_ServerCommunicator to perform vault transactions (for example,
        /// the latency monitor).
        /// </summary>
        public static string DefaultVaultConnectionString { get; set; }
    }

    /// <summary>
    /// This class describes namespaces for the file store provider top level
    /// collections.
    /// </summary>
    public static class FileStoreNamespace
    {

        /// <summary>
        /// The namespace for the server vault.
        /// </summary>
        public const string ServerVault = "alfa-nwn2-server-vault";

        /// <summary>
        /// The namespace for the ACR updater.
        /// </summary>
        public const string ACRUpdater = "alfa-nwn2-acr-updater";

    }
}
