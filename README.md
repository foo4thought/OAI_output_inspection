#
# these procedures were adopted to address problems with the OAI output of PBCore data from openvault.wgbh.org, as reported by Boston Public Library
# 
# those problems were with the contents of Fedora's "PBCore" datastream:
#   for some items, it contains '<?xml version="1.0"?>' which disrupts the OAI client
#   for some items, XML was malformed


# in the browser, determine how many resumption-token-delimited "pages" of OAI output will be offered by the site
# e.g., vary the last number after the last colon in the URL
#   http://openvault.wgbh.org/oai?verb=ListIdentifiers&resumptionToken=oai_dc.f(2011-10-05T13:31:13Z).u(2013-10-09T17:38:43Z):247
# there were 248

# now use curl to download all pages from the OAI harvest interface to XML files; note the range of pages in [] 

curl 'http://openvault.wgbh.org/oai?verb=ListIdentifiers&resumptionToken=oai_dc.f(2011-10-05T13:31:13Z).u(2013-10-09T17:38:43Z):[0-248]'  -o "#1.xml" --retry 3


# now extract the catalog URLs from the XML files just downloaded from the harvester

for i in `ls -1 *.xml`;do xsltproc getCatalogIdentifiers.xsl "$i" >> catalogURLs.txt;done

# now modify the style sheet (comment/uncomment) to extract the catalog IDs from the XML files just downloaded from the harvester

for i in `ls -1 *.xml`;do xsltproc getCatalogIdentifiers.xsl "$i" >> catalogIDS.txt;done

# now inspect the pbcore datastreams of all catalog items and flag those that fail simple XML validation.

for i in `cat catalogURLs.txt `;do good=`curl "$i".pbcore | xsltproc prettyPrintXML.xsl -`;if [ ! "$good" ];then echo "$i" >> badXML.txt;fi;done

# now inspect the pbcore datastreams of all catalog items and flag those that contain the XML declaration.

for i in `cat catalogURLs.txt `;do xml=`curl "$i".pbcore | grep '<?xml version="1.0"?>'`;if [  "$xml" ];then echo "$i" >> removeXMLheader.txt;fi;done