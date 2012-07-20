using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace DeploymentTool
{
    class ADLResource
    {
        public ADLResource(XElement xmlElement)
        {
            // Load basic resources.
            type = (string)xmlElement.Attribute("type");
            hash = (string)xmlElement.Attribute("hash");
            downloadHash = (string)xmlElement.Attribute("downloadHash");
            name = (string)xmlElement.Attribute("name");
            dlsize = (long)xmlElement.Attribute("dlsize");
            size = (long)xmlElement.Attribute("size");
            critical = ((string)xmlElement.Attribute("critical")).Equals("true");
            exclude = ((string)xmlElement.Attribute("exclude")).Equals("true");
            urlOverride = (string)xmlElement.Attribute("urlOverride");

            // Get download resources.
            servers = new List<int>();
            List<XElement> ServerRefs = xmlElement.Element("server-ref").Elements().ToList();
            for (int i = 0; i < ServerRefs.Count; i++)
            {
                servers.Add(int.Parse(ServerRefs[i].Value));
            }
            if (servers.Count == 0)
            {
                Console.WriteLine(string.Format("WARNING: Resource entry '{0}' contains no valid server references.", name));
            }
        }

        public string type;
        public string hash;
        public string downloadHash;
        public string name;
        public long dlsize;
        public long size;
        public bool critical;
        public bool exclude;
        public string urlOverride;
        public List<int> servers;
    }
}
