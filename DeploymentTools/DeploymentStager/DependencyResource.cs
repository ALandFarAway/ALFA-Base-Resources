using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace DeploymentStager
{
    class DependencyResource
    {
        public DependencyResource(XElement xmlElement, string filepath)
        {
            // Load basic resources.
            path = filepath;
            name = (string)xmlElement.Attribute("name");
            location = (string)xmlElement.Attribute("location");
        }

        public void Stage(DeploymentStager stager, XElement xmlElement)
        {
            FileInfo file = new FileInfo(path);

            // Get the pre-compress data.
            hash = FileVerification.GetSHA1Hash(path);
            size = file.Length;

            // Compress.
            if (!Directory.Exists("staging")) Directory.CreateDirectory("staging");
            string compressPath = "staging\\" + file.Name + ".lzma";
            SevenzipCompresser compresser = new SevenzipCompresser(path);
            int ExitCode = compresser.compress(compressPath);

            // Get the data for the compressed file.
            FileInfo archive = new FileInfo(compressPath);
            downloadHash = FileVerification.GetSHA1Hash(compressPath);
            downloadSize = archive.Length;

            // Update the XML.
            xmlElement.SetAttributeValue("hash", hash);
            xmlElement.SetAttributeValue("downloadHash", downloadHash);
            xmlElement.SetAttributeValue("size", size);
            xmlElement.SetAttributeValue("downloadSize", downloadSize);
        }

        public string path;
        public string name;
        public string hash;
        public string downloadHash;
        public long size;
        public long downloadSize;
        public string location;
    }
}
