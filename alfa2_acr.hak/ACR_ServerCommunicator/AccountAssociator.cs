using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This class is used to generate account association information that is
    /// used to allow the forum software to link a user's BioWare community
    /// account with an ALFA forum account.
    /// </summary>
    public static class AccountAssociator
    {

        /// <summary>
        /// This method generates the account association URL that the user
        /// will be sent to in order to link their in-game BioWare community
        /// account with their online forum account.
        /// </summary>
        /// <param name="AccountName">Supplies the community account name that
        /// will be validated.</param>
        /// <param name="AccountAssociationSecret">Supplies the shared secret
        /// from the database config table that is used to authenticate the
        /// generated URL.</param>
        /// <param name="BaseURL">Optionally supplies the base URL to use for
        /// the request (overriding the default).</param>
        /// <returns>The URL to send the user to in order to link their
        /// account.  The web page at the URL prompts the user to log on to the
        /// content management system, then authenticates the request URL
        /// parameters and updates the database as appropriate.</returns>
        public static string GenerateAssociationURL(string AccountName, string AccountAssociationSecret, string BaseURL)
        {
            using (MD5CryptoServiceProvider MD5Csp = new MD5CryptoServiceProvider())
            {
                string Challenge;
                string Verifier;
                byte[] Data;
                StringBuilder VerifierString = new StringBuilder();

                Challenge = CreateChallengeString();
                Verifier = AccountName.ToLower() + Challenge + AccountAssociationSecret;
                Data = MD5Csp.ComputeHash(Encoding.UTF8.GetBytes(Verifier));
                Data = MD5Csp.ComputeHash(Data);

                for (int i = 0; i < Data.Length; i += 1)
                    VerifierString.Append(Data[i].ToString("x2"));

                return String.Format("{0}?AccountName={1}&Challenge={2}&Verifier={3}",
                    String.IsNullOrEmpty(BaseURL) ? AccountAssociationServiceURL : BaseURL,
                    Uri.EscapeDataString(AccountName),
                    Uri.EscapeDataString(Challenge),
                    Uri.EscapeDataString(VerifierString.ToString()));
            }
        }

        /// <summary>
        /// Create a randomized challenge string.
        /// </summary>
        /// <returns>The challenge string.</returns>
        private static string CreateChallengeString()
        {
            using (RandomNumberGenerator Rng = RandomNumberGenerator.Create())
            {
                byte[] RandomData = new byte[16];
                StringBuilder RandomDataString = new StringBuilder();

                Rng.GetBytes(RandomData);

                for (int i = 0; i < RandomData.Length; i += 1)
                    RandomDataString.Append(RandomData[i].ToString("x2"));

                return RandomDataString.ToString();
            }
        }

        /// <summary>
        /// The base URL of the account association service.
        /// </summary>
        private const string AccountAssociationServiceURL = "http://www.alandfaraway.info/services/AccountAssociator";

    }
}
