using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace DeploymentDownloader
{
    class FileVerification
    {
        public static bool VerifyFile(string filename, string sha1Hash, long filesize)
        {
            // Get file info.
            FileInfo f = new FileInfo(filename);

            // Get sha1 hash.
            string hash = GetSHA1Hash(filename);

            // Make checks.
            if (filesize != f.Length)
            {
                return false;
            }
            else if (!hash.Equals(sha1Hash))
            {
                return false;
            }

            return true;
        }

        public static bool VerifyFile(string filename, ADLResource resource)
        {
            // Get file info.
            FileInfo f = new FileInfo(filename);

            // Get the size and hash we're checking against.
            long size = 0;
            string checkHash = "";
            if (f.Extension.Equals(".lzma"))
            {
                size = resource.dlsize;
                checkHash = resource.downloadHash;
            }
            else
            {
                size = resource.size;
                checkHash = resource.hash;
            }

            return VerifyFile(filename, checkHash, size);
        }

        public static bool VerifyFile(string filename, DependencyResource resource)
        {
            // Get file info.
            FileInfo f = new FileInfo(filename);

            // Get the size and hash we're checking against.
            long size = 0;
            string checkHash = "";
            if (f.Extension.Equals(".lzma"))
            {
                size = resource.downloadSize;
                checkHash = resource.downloadHash;
            }
            else
            {
                size = resource.size;
                checkHash = resource.hash;
            }

            return VerifyFile(filename, checkHash, size);
        }

        public static string GetSHA1Hash(string filename)
        {
            FileStream fStream = new FileStream(filename, FileMode.Open);
            SHA1Managed sha1 = new SHA1Managed();
            byte[] buffer = sha1.ComputeHash(fStream);
            StringBuilder formatted = new StringBuilder(buffer.Length);
            foreach (byte b in buffer)
            {
                formatted.AppendFormat("{0:X2}", b);
            }
            fStream.Close();

            return formatted.ToString().ToUpper();
        }
    }
}
